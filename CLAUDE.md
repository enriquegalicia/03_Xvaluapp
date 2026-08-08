# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

Two things live side by side here, plus an archive folder:

- **`RedBullApp/` + `Xvaluapp.xcodeproj`** — the original, working Objective-C
  iOS app (product name "Xvaluapp", still internally named RedBullApp,
  bundle id `com.Magnificent.Xvaluapp`). It's a live, offline,
  peer-to-peer judging/scoring app built for a BMX freestyle dirt-jump
  event called **"Dirt Conquers"** (hardcoded db filenames
  `DirtConquers1.db` / `DirtConquersFinals1.db` in `JudgePanel.m` give it
  away). iPad-only (`TARGETED_DEVICE_FAMILY = 2`), iOS 7.0 deployment
  target, ARC enabled.
- **`Swift/XvaluappCore/`** — a from-scratch Swift Package that is the start
  of migrating this app's domain logic to Swift (branch `swift-migration`).
  Pure `Foundation`, no UIKit/SwiftUI/MultipeerConnectivity dependency, so
  it builds and tests without Xcode's iOS SDK.
- **`Legacy/`** — files archived out of the active project during cleanup
  (old exported `.ipa` builds, unused pre-`Images.xcassets` icon PNGs, one
  dead/orphaned source fork). See `Legacy/README.md` for what moved and why
  — everything there was verified unreferenced in `project.pbxproj` before
  being moved, so the original Xcode project is unaffected.

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
`TablaSeccionada copia.h/.m` (now in `Legacy/DeadCode/`) is an unreferenced,
regressed fork — don't resurrect it; event create/rename/delete UI in
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
  need SQL).

There is no iOS app target yet — no SwiftUI screens exist in this repo.
Building one (in Xcode, on a machine with the iOS SDK) is the next phase of
this migration; don't assume UI code exists anywhere yet.
