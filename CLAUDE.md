# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

Three things live side by side here:

- **`RedBullApp/` + `Xvaluapp.xcodeproj`** — the original, working Objective-C
  iOS app (product name "Xvaluapp", still internally named RedBullApp,
  bundle id `com.Magnificent.Xvaluapp`). It's a live, offline,
  peer-to-peer judging/scoring app built for a BMX freestyle dirt-jump
  event called **"Dirt Conquers"** (hardcoded db filenames
  `DirtConquers1.db` / `DirtConquersFinals1.db` in `JudgePanel.m` give it
  away). The project file now targets **`IPHONEOS_DEPLOYMENT_TARGET = 15.0`**
  and **`TARGETED_DEVICE_FAMILY = "1,2"`** (universal iPhone+iPad, bumped up
  from the original iOS 7.0 / iPad-only settings), but the UI itself was
  never adapted for that — every xib still uses `fixedFrame="YES"`
  iPad-sized absolute layouts and there's no non-iPad orientation key in
  `Xvaluapp-Info.plist`, so an iPhone install renders badly. Considered the
  **legacy reference implementation only** — see the "Which app ships"
  note below before adding features here.
- **`Swift/XvaluappCore/`** — a from-scratch Swift Package with this app's
  domain logic in Swift (branch `swift-migration`). Pure `Foundation`, no
  UIKit/SwiftUI/MultipeerConnectivity dependency, so it builds and tests
  without Xcode's iOS SDK.
- **`Swift/XvaluappApp/`** — a real SwiftUI iOS app target (product name
  "Xvaluapp", bundle id `com.Magnificent.XvaluappSwift`, iOS 17+, universal
  iPhone+iPad) that consumes `XvaluappCore` and adds a `MultipeerConnectivity`
  transport, persistence wiring, and a SwiftUI screen per legacy role. This
  is the **active development target and the intended App Store submission
  vehicle** — see "Which app ships" below. Xcode project is generated from
  `project.yml` via `xcodegen`; regenerate with `xcodegen generate` after
  editing `project.yml` (adding/removing source files needs a regenerate
  too, since file membership isn't tracked by folder reference).

There's no more `Legacy/` archive folder — it held pre-`Images.xcassets`
icon PNGs and one dead/orphaned `TablaSeccionada` fork, all already
verified unreferenced in `project.pbxproj`, and was deleted outright
(2026-08-23) rather than kept around; git history still has it if it's
ever needed. Same pass also deleted the unrelated-client-project files
called out below (`Fondo-Drenaje*`, `Logo-Drenaje.gif`, the three
`DINNextLTPro-*.otf` fonts) and their now-stale `project.pbxproj` entries.

### Which app ships

The Objective-C app (`RedBullApp/`) has accumulated serious, hard-to-patch-
incrementally problems: unescaped `stringWithFormat:` SQL on every query
(real injection risk, not theoretical), several concretely reachable crash
bugs (see below), two structurally broken sync features, unauthenticated
peers able to trigger a full data wipe or force finals over the mesh, no
Local Network / photo-library privacy strings, no privacy manifest, no
1024×1024 marketing icon, no launch screen, a hand-pinned provisioning
profile GUID that won't resolve on another machine, and — discovered
during a full-repo audit and since deleted — several bundled files
(`Fondo-Drenaje*.jpg`, `Logo-Drenaje.gif`, unregistered `DINNextLTPro-*.otf`
fonts) left over from unrelated prior client projects with no relation to
this app. Bringing it
to App Store quality would be close to a full rewrite of a ~2,000-line
god-object view controller, so it isn't the target — treat it as reference
material for behavior parity, not a place to build new features.
`Swift/XvaluappApp/` is significantly further along than a from-scratch
rewrite would be (all six legacy screens have a SwiftUI equivalent except
the auto-rotating results carousel) and is the one intended to actually
ship.

## Commands

### Legacy Objective-C app (`RedBullApp` / `Xvaluapp.xcodeproj`)

Requires full Xcode — this sandbox only has Command Line Tools (no
`iphoneos` SDK; `xcodebuild` is unavailable here). From a machine with
Xcode installed:

```sh
open Xvaluapp.xcodeproj
# or, headless:
xcodebuild -project Xvaluapp.xcodeproj -scheme Xvaluapp -sdk iphonesimulator build
```

The `RedBullAppTests` target exists but has no real tests beyond the
default `RedBullAppTests.m` stub.

### `Swift/XvaluappCore`

```sh
cd Swift/XvaluappCore
swift build
swift test                        # run the full suite
swift test --filter <TestName>    # run one test or suite
```

Uses the **Swift Testing** framework (`import Testing`, `@Test`, `#expect`),
not XCTest — XCTest requires a full Xcode install and is not available in
Command-Line-Tools-only environments like this one. Don't add
`import XCTest` here; new tests should follow the existing `@Test`/`#expect`
style in `Tests/XvaluappCoreTests/`.

### `Swift/XvaluappApp`

Same Xcode/iOS-SDK requirement as the legacy app — unbuildable in a
Command-Line-Tools-only sandbox (imports SwiftUI/UIKit/MultipeerConnectivity/
Observation). From a machine with Xcode installed:

```sh
cd Swift/XvaluappApp
xcodegen generate                 # regenerate Xvaluapp.xcodeproj from project.yml
open Xvaluapp.xcodeproj
# or, headless:
xcodebuild -project Xvaluapp.xcodeproj -scheme Xvaluapp -sdk iphonesimulator build
```

There is no test target for this app yet (no XCTest/Swift-Testing files
under `Swift/XvaluappApp/`) — `EventSession`, `MultipeerTransport`, and every
SwiftUI view are currently untested. This build has never been verified in
a real Xcode toolchain since it was written in a sandbox without one —
treat first-build compiler errors as expected, not a sign something else is
wrong.

## Architecture

### Legacy app: one god-object view controller

`JudgePanel.m` (~2,000 lines, one file) is effectively the entire app: six
different "screens" — participant/judge/category config list, judge scoring
keypad, master-device monitor/approve view, ranking toggle, an
auto-rotating results carousel, and a plaintext-password-gated admin
console — are all implemented as one `UIViewController` that shows/hides
roughly 30 `IBOutlet`s, rather than using separate screens or navigation.
It also owns the entire `MultipeerConnectivity` session and message-dispatch
logic directly.

Data flow: `CreacionEventos` (launcher — picks/creates an event and sets a
device role of Master/Judge/Screen, stored in `NSUserDefaults`) →
`JudgePanel` (per-role UI + sync) → `GestorBD` / `DataBase` (a hand-rolled
`sqlite3` C-API wrapper — **every query is built with `stringWithFormat:`,
there is no parameter binding anywhere in the file**; treat any change here
as a SQL-injection-sensitive area) → SQLite tables `PARTICIPANTES` /
`JUECES` / `RUBROS` / `EVALUACION` / `EVALUACIONLO` / `BUFFER` / `ARCHIVOS`.

Sync protocol: every peer both advertises and browses simultaneously; all
messages are `NSDictionary` payloads tagged with a free-text `"Acceso"` key
(ten distinct shapes: `Inicial`, `Dato`, `Pantalla`, `JuezRev`, `JuezRev2`,
`Sincronia`, `UpdateLocal`, `UpdateOrder`, `CleanThemAll`, `Eliminatorias`),
archived with `NSKeyedArchiver`, and **broadcast to all connected peers** —
each device decides locally (from its own role, stashed in
`MCPeerID.accessibilityLabel`) whether to act on a message. There is no
origin-peer check and no leader election, so two devices both set to
"Master" can write conflicting data.

`Subtitulados.m`, `Funciones.m`, and `BasicTable` / `TablaSeccionada` /
`Resultados` / `Resultados1` (plus their cell classes) form a shared
UI-helper layer — mostly near-duplicate table/list scaffolding and
dictionary-reshaping utilities, with a dense Spanish naming shorthand worth
knowing: `tit` = título/title, `sub` = subtítulo, `Ca` = calificación/score,
`Ba` = bandera/flag, `No` = nombre/name.

Known, already-diagnosed issues worth knowing before touching this code:
`escribecalif:`'s keypad string-length branches have no case for length 2
(a judge who's typed exactly two digits gets no response to a third
keypress); `Guardar:` collapses the judge and scoring-category (`Rubro`)
selection to the same id and the category picker setup is commented out, so
independent per-category scoring doesn't actually work in this build;
`TablaSeccionada copia.h/.m` was an unreferenced, regressed fork, deleted
outright (2026-08-23, see "Repository overview") — don't resurrect it from
git history; event create/rename/delete UI in
`CreacionEventos.m` is fully commented out and its buttons hidden in the
xib, so only the two hardcoded seed events are reachable; logo/background
images are persisted to disk but never displayed (every render call site is
commented out).

### `Swift/XvaluappCore`: the migration target

Deliberately platform-agnostic (`Foundation` only) so it's independently
buildable/testable outside Xcode. Maps roughly 1:1 onto the legacy pieces
above:

- `Models/Event.swift`, `Models/Score.swift` — replace the
  `PARTICIPANTES`/`JUECES`/`RUBROS`/`EVALUACION`/`EVALUACIONLO`/`BUFFER`
  tables; the old three-table score lifecycle collapses into one
  `Score.Status` enum (`pending`/`approved`).
- `Scoring/RankingEngine.swift` — replaces the `AVG() GROUP BY` queries
  duplicated across `JudgePanel.m` plus `Subtitulados.m`'s
  `idaiNoCa*`/`idNoCa*` method family. `finalists(from:count:)` replaces
  `ProximaEliminatoria:`'s hardcoded `LIMIT 12`.
- `Scoring/ScoreEntryPad.swift` — replaces `escribecalif:`, with the
  length-2 bug fixed and covered by a regression test.
- `Sync/SyncMessage.swift` — one exhaustive `Codable` enum replacing the
  ten-shape `"Acceso"`-keyed dictionary protocol. It only defines the wire
  format — the iOS app target is expected to add a thin
  `MultipeerConnectivity` transport that encodes/decodes this type over
  `MCSession`.
- `Persistence/EventStore.swift` — an `EventStoring` protocol plus a
  `JSONEventStore` implementation, replacing `DataBase.m`/`GestorBD.m`'s raw
  SQL with an injection-proof `Codable`-JSON store (this app's data scale —
  dozens of participants, low thousands of score rows per event — doesn't
  need SQL). JSON only, and stays that way — image *bytes* are stored
  outside this package (see `Swift/XvaluappApp`'s `XvaluappAI`/
  `LocalImageStore` below); `Event.logoImageFilename`/
  `backgroundImageFilename` and `Participant.imageFilename` just hold a
  local file path string into that store.

### `Swift/XvaluappApp`: the SwiftUI app target

Wires `XvaluappCore` up to a real iOS app. One SwiftUI view per legacy
screen, `@Observable EventSession` as the glue layer, `MultipeerTransport`
as the `MultipeerConnectivity` transport for `SyncMessage`:

- `EventListView` — event picker/creator, with swipe/context-menu delete
  (confirmed via `.confirmationDialog`) and rename.
- `RoleSelectionView` → `EventDetailView` — role gate (Judge/Master/Screen),
  replacing `CreacionEventos`'s role buttons + the `Accesado` NSUserDefaults
  flag.
- `ScoringView` — judge's category picker + `ScoreEntryPad` keypad, replaces
  the scoring half of `JudgePanel`.
- `MasterConsoleView` — roster editor link, peer connections list, "Advance
  to Finals"/"Reset All Scores" behind a `.confirmationDialog` — replaces
  `Monitoreo:` and the plaintext-password admin console.
- `RosterEditorView` / `NewEventView` — participant/judge/category CRUD,
  replacing the config-list screen and `CreacionEventos`'s commented-out
  create/rename/delete UI (this one actually works).
- `ScoreboardCarouselView` — the Screen role's auto-rotating results
  display, replacing `Play:`'s `NSTimer` fade sequence: one page for
  overall standings plus one per scoring category, advancing every 8s via
  a `.task` loop, `TabView(.page)` for the swipe/dots chrome. `StandingsView`
  itself now takes an optional `categoryID` and is reused as each page.
- `FlagImage` / `Country.swift` (in `XvaluappCore`) — static bundled flag
  assets keyed by country code, used as the fallback in `ParticipantAvatar`
  for any participant without a photo.

Fixed since the initial pass: `EventSession.persist()` surfaces save
failures as `persistenceError` (alerted on in `EventDetailView`) instead of
crashing via `try!`; `MultipeerTransport` holds incoming invitations as
`pendingInvitation` for the user to accept/decline instead of
auto-accepting; `EventListView` now supports event delete (swipe/context
menu, with a confirmation dialog) and rename.

### Imagery & branding

`project.yml` now depends on two packages from the **separate**
`Aguach1leLabs` repo — `AguaDesign` (dark-first tokens/components) and
`AguaAI` (BYOK OpenAI service + `LocalImageStore`) — via local SPM paths
(`../../../../Xcode/Aguach1leLabs/Packages/...`, relative to
`Swift/XvaluappApp/`). **This only resolves if both repos stay checked out
at their current relative location on this machine** — unlike every other
app in that Lab, Xvaluapp doesn't live inside the `Aguach1leLabs` directory
tree, so this crosses a repo boundary in a way none of their other local
package references do. If either repo ever moves, or this project is
cloned onto another machine without `Aguach1leLabs` alongside it at the
same relative path, update `project.yml`'s `packages:` block (switch to a
git-URL package reference, or vendor the two packages into this repo).

- `XvaluappAI.swift` — one `enum` holding a shared `OpenAIVisionService`
  (BYOK, key from Keychain), a shared `LocalImageStore(subdirectory:
  "Xvaluapp")`, and `styleSuffix`, a fixed prompt fragment matching
  `ICON_STYLE_GUIDE.md`'s DNA (terracotta primary fill, espresso-brown ink
  outline, flat/no photorealism) so anything generated here reads as part
  of the same Lab as the app icon.
- `SettingsView` — BYOK OpenAI key entry, copied from PlateSnap's screen
  almost verbatim. Reachable from `EventListView`'s gear button.
- `ImagePickerField` — attaches an image to an event (logo/background) or
  a participant: `PhotosPicker` for a library photo (no
  `NSPhotoLibraryUsageDescription` needed — it runs out-of-process and only
  hands back what's explicitly picked) or "Generate with AI…" via
  `OpenAIVisionService.generateImage(prompt:size:)` (added to `AguaAI`
  itself, additive-only — every other app depending on that package is
  unaffected). Used in `NewEventView` and `RosterEditorView`.
- `StoredImage` / `ParticipantAvatar` — render a saved path (or the
  graceful SF Symbol / flag fallback) in `EventListView`'s row,
  `ScoreboardCarouselView`'s banner, and every participant row in
  `StandingsView`/`ScoringView`.
- **Image bytes are not synced between devices yet.** `SyncMessage`/
  `EventSession` still sync the full `Event` JSON (including its
  `...ImageFilename` path strings), but those paths are local to whichever
  device set them — a Judge/Screen device that received a roster update
  referencing the Master's logo just shows the placeholder, since the
  actual file never crossed the wire. Transferring the image bytes too
  (e.g. `MCSession.sendResource(at:withName:toPeer:...)`, or a new small
  `SyncMessage` case for images under some size threshold) is the natural
  next step here.
- App accent color is `AguaColor.Accent.amber` (`#D4960A`), set once via
  `.tint(...)` on the root `WindowGroup` content in `XvaluappApp.swift`.

App Store compliance done so far: the 1024×1024 marketing icon already
existed; `PrivacyInfo.xcprivacy` now declares no tracking, no collected
data, and no required-reason API usage (accurate — the app doesn't call
any of the flagged FileManager/UserDefaults/disk-space/boot-time APIs);
`UILaunchScreen` now sets a branded dark background (`LaunchBackground`
color asset, matching `AguaColor.bgPrimary`) instead of a blank white
screen; `AccentColor` now matches the chosen amber accent exactly;
`ITSAppUsesNonExemptEncryption: false` skips the encryption questionnaire
on upload; `APP_STORE_LISTING.md` has draft name/subtitle/description/
keywords/category copy ready to paste into App Store Connect.

Still open: `XvaluappApp.swift`'s one-time `try! JSONEventStore(directory:)`
at launch is left as-is (documented as intentional — there's no recovery
path if Application Support can't be created); no test target for the app
layer; `RosterEditorView`/`NewEventView`/`ScoringView`/`MasterConsoleView`
still use plain system `Form`/`List` styling rather than
`AguaColor`/`.aguaCard()` throughout — `StandingsView` and the app-wide
background/tint are done, the rest is a straightforward follow-up pass,
not a redesign; the current bundle id (`com.Magnificent.XvaluappSwift`)
and lack of a Development Team in `project.yml` still need to be set to
whatever this app will actually ship under before it can be archived/
submitted; screenshots and a hosted support/privacy-policy URL are needed
before the App Store Connect listing can actually be submitted (see
`APP_STORE_LISTING.md`) — both require a real device/simulator run, which
this sandbox can't do.
