# Sync architecture: decentralized roster + multi-role devices

This documents the pass that replaced the exclusive single-`PeerRole` model
and master-owns-the-roster sync with the current design: connect first, pick
roles (any combination, changeable anytime) second, and merge roster edits
from any device instead of one device replacing everyone else's copy. It's
meant to be read alongside the code, not instead of it — file references
below are starting points, not exhaustive.

## What changed, in one paragraph

`EventSession.connect(displayName:)` now starts advertising *and* browsing
the moment `EventDetailView` appears, before any role is picked — every
device can discover and be discovered by every other device, and the
existing accept/decline alert (`EventDetailView`'s "Connection Request")
gates joining. `PeerRole` moved from an exclusive `role: PeerRole?` to
`roles: Set<PeerRole>`, toggled via `RoleSelectionView` (now a re-enterable
"Change Roles" screen, not a one-shot gate) and broadcast via the new
`.roleAnnounce` message. `Participant`/`Judge`/`ScoringCategory` ids moved
from per-device sequential `Int` to `UUID`, each carrying `updatedAt` +
`originDeviceID`, so `RosterMerge.merge` can union two devices' independent
additions and resolve same-id conflicts by last-write-wins instead of one
side's `.rosterUpdated`/`.fullEventSnapshot` unconditionally overwriting the
other. Deletion needed a tombstone (`isDeleted`) because a plain union has
no way to represent "this was here and got removed" — see below.

## Known limitations, ranked by how likely they are to actually bite

### 1. The Master-singleton guard is optimistic, not exclusive (by design)

`EventSession.canEnableMaster` only checks peers this device is *currently
connected to* and has *already heard a `.roleAnnounce` from*. Two real
races follow from that:

- **Simultaneous claim**: two devices both open `RoleSelectionView` and tap
  Master within the same connection-establishment window, before either has
  received the other's `.roleAnnounce`. Both succeed locally; each then
  broadcasts `.master`, and both devices' Connections lists start showing
  "two Masters" — visible, but not prevented.
- **Late joiner**: a third device connects to a Master's session, but there's
  a brief window before it's received the Master's `.roleAnnounce` where its
  own `canEnableMaster` still reads `true`.

This was the explicitly agreed trade-off (lightweight/optimistic over a real
election protocol) given the app's scale — a handful of staff devices on one
LAN, not an adversarial or high-churn environment. If it ever needs
hardening, the next step up in cost is a light **claim token**: the event
itself carries an optional `masterClaimedBy: UUID?` + `claimedAt: Date`
field, set only by whoever successfully claims it and merged like any other
event-level field (`Event.merged(with:)` already has the machinery); a
device trying to enable Master when the merged event already shows a
different, recent claim gets refused *after* the fact and prompted to step
down, rather than just silently coexisting. That still isn't a real
election (no quorum, no fencing), but it turns "invisible until someone
checks the Connections list" into "surfaced within one sync round".
Actual leader election (e.g. lowest-`deviceID`-wins with a heartbeat) is
the full fix but is a meaningfully bigger protocol to design, test, and
reason about race conditions for — not worth it unless real events start
hitting the race in practice.

### 2. Roster merge has no field-level resolution — it's whole-entity last-write-wins

If device A renames a participant while device B (disconnected, working
from a stale copy) changes that same participant's country code, whichever
device's edit has the later `updatedAt` wins *entirely* — the other
device's change is silently lost, not merged field-by-field. A real
CRDT (e.g. a last-write-wins register *per field*, not per entity) would
fix this but meaningfully complicates the model (`Participant` would need
per-field timestamps, not one `updatedAt`) for a conflict pattern that's
rare in practice: two devices editing the *same* participant's *different*
fields while disconnected from each other, in the narrow window before the
next sync. Worth watching for if events end up running with several judges
editing the roster concurrently and offline for stretches; not worth
building preemptively.

### 3. Deletion needed tombstones, and tombstones need eventual cleanup

Deleting a participant is represented as `isDeleted = true`, not an actual
array removal — a plain union merge has no other way to keep a deletion
from being resurrected by a peer's older, non-deleted copy of the same id
(see `RosterMerge`'s tombstone tests). That's correct, but it means deleted
rows accumulate in `Event.participants`/`.judges`/`.categories` forever;
nothing currently prunes them. At this app's scale (dozens of participants,
a handful of judges/categories, one event at a time) that's not a real
storage or performance problem, but if an event gets rebuilt/edited
heavily across a long weekend, worth a periodic "compact" pass — safe once
every device is known to have converged (hard to guarantee without some
sync-completion signal, which doesn't exist yet).

### 4. Symmetric advertise+browse reintroduces a mutual-invite race

The original code deliberately had only the Master browse/invite, with a
comment noting this avoided "races between two devices trying to invite
each other simultaneously." Moving to symmetric discovery (every device
both advertises and browses, since role is no longer known before
connecting) reintroduces that: two devices in range can each discover and
invite the other at nearly the same moment, producing two simultaneous
"Connection Request" alerts, one on each side, for what's conceptually one
connection. `MCSession` generally tolerates this without corrupting state,
but it's a rough edge a real event will occasionally see. Cheap fix if it
turns out to matter: only auto-invite when your own `MCPeerID.displayName`
sorts lower than the discovered peer's (a common MultipeerConnectivity
tie-break pattern) — deterministic, no protocol change, just an ordering
rule in `MultipeerTransport`/`EventSession`'s discovery-to-invite path.

### 5. New UI strings need a Spanish pass

This app is localized into English and Spanish via `Localizable.xcstrings`
(see the main `CLAUDE.md`). Everything added in this pass uses
`LocalizedStringKey`-typed parameters correctly (including fixing a fresh
instance of the documented "`String`-typed param silently skips catalog
lookup" gotcha in the new `RoleToggleRow`), so Xcode's String Catalog
extraction will pick these strings up as new/untranslated on the next
build in Xcode. They need an actual Spanish translation pass there — this
sandbox can't run Xcode to regenerate or hand-verify the `.xcstrings` file,
so it wasn't attempted here rather than risk a malformed catalog.

### 6. Image bytes still don't sync — unrelated to this pass, still open

Unchanged from before: `Event.logoImageFilename`/`backgroundImageFilename`/
`Participant.imageFilename` are local file paths, and only the path string
travels in `SyncMessage`, not the bytes. A Judge/Screen device that merges
in a roster entry referencing another device's photo just shows the
placeholder. Still the natural next step (`MCSession.sendResource` or a
size-capped image `SyncMessage` case), not attempted here since it's
orthogonal to roster/role sync.

## What to verify on a real device pass (can't be checked in this sandbox)

This sandbox has no iOS SDK (`xcodebuild` unavailable — see `CLAUDE.md`), so
none of the app-target changes above have been compiled, only reasoned
through against the existing code and cross-checked file by file. Before
trusting this in the field:

- Build in Xcode and fix whatever the id-type mechanical pass missed —
  `Int` → `UUID` touches a lot of call sites; `swift test` in
  `Swift/XvaluappCore` is green (21/21), but that only covers the
  Foundation-only package, not the SwiftUI/MultipeerConnectivity layer.
- Two physical devices: create an event on one, add different participants
  on each while they're out of range, bring them into range, confirm both
  sets show up merged with no duplicates.
- Same setup, but delete a participant on one device before merging —
  confirm it stays deleted (the tombstone tests in
  `RosterMergeTests.swift` cover the merge logic in isolation; the network
  round trip through `.rosterUpdated` hasn't been exercised against real
  hardware).
- Three devices: one Master, then enable Master on a second device that's
  still out of Bluetooth/Wi-Fi range of the first, then bring them into
  range — confirms/measures the race in limitation #1 rather than just
  reasoning about it.
- A device holding Master + Judge + Screen at once: confirm all three tabs
  work and switching between them doesn't drop the Multipeer connection
  (nothing in this pass tears down `transport` on a tab switch, only on
  `EventDetailView` actually disappearing — but worth confirming on-device
  since tab switching has its own view-lifecycle quirks that only show up
  at runtime).
