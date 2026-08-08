# XvaluappCore

Pure-Swift domain layer for the Xvaluapp/"Dirt Conquers" judged-competition
scoring app, ported from the original Objective-C implementation in
`../../RedBullApp/`. This package intentionally imports nothing beyond
`Foundation` — no UIKit, SwiftUI, or MultipeerConnectivity — so it builds and
unit-tests on any platform (proven here: `swift build && swift test` both run
clean with 13/13 tests passing, no Xcode/iOS SDK required).

## What's in here vs. what's still legacy

| Legacy (Objective-C) | Here | Status |
|---|---|---|
| `DataBase.m` / `GestorBD.m` (raw SQL, no parameter binding, SQL-injection-prone) | `Persistence/EventStore.swift` (Codable JSON store) | Ported, redesigned |
| `AVG(calificacion) GROUP BY nombre` queries duplicated 3x in `JudgePanel.m` + `Subtitulados.m`'s `idaiNoCa*`/`idNoCa*` family (~6 methods) | `Scoring/RankingEngine.swift` | Ported, unified, unit-tested |
| `ProximaEliminatoria:`'s hardcoded `LIMIT 12` + reversed re-indexing | `RankingEngine.finalists(from:count:)` | Ported, de-hardcoded |
| `escribecalif:`'s string-slicing keypad state machine (has a real bug: length-2 input is unhandled) | `Scoring/ScoreEntryPad.swift` | Ported, bug fixed + regression-tested |
| The `"Acceso"`-keyed `NSDictionary` MultipeerConnectivity protocol (10 ad hoc shapes, `NSKeyedArchiver`) | `Sync/SyncMessage.swift` | Redesigned as a typed `Codable` enum |
| `PARTICIPANTES`/`JUECES`/`RUBROS`/`EVALUACION`/`EVALUACIONLO`/`BUFFER` SQLite tables | `Models/Event.swift`, `Models/Score.swift` | Ported, collapsed to one `Score.Status` enum |
| `BasicTable`/`TablaSeccionada`/`Resultados`/`Resultados1` (4 near-duplicate table controllers) + `Subtitulados`'s row-zipping methods | *(not yet ported — this is SwiftUI-layer work, belongs in the iOS app target, not this platform-agnostic package)* | Pending |
| `Funciones.m` (animation helpers) | *(not yet ported — SwiftUI `.animation`/`.transition` modifiers, belongs in the app target)* | Pending |
| `JudgePanel.m`'s 6 screens (config list, judge scoring, master monitor, rankings toggle, results carousel, admin console) | *(not yet ported)* | Pending — see the migration report for the phased plan |

## Using this from the iOS app target

This package has no iOS app target of its own (can't be created/validated in
this environment — no full Xcode/iOS SDK available here, only Swift's
command-line toolchain). To wire it in:

1. In Xcode, create a new iOS App (SwiftUI, iOS 17+, iPhone+iPad/"Universal").
2. File → Add Package Dependencies → Add Local... → select this folder.
3. `import XvaluappCore` in the app target and build the SwiftUI screens
   against `Event`, `RankingEngine`, `ScoreEntryPad`, `SyncMessage`, and
   `JSONEventStore`/`EventStoring`.
4. Add a thin `MultipeerSyncTransport` in the app target: encode/decode
   `SyncMessage` with `JSONEncoder`/`JSONDecoder` (or `PropertyListEncoder`
   for smaller payloads) and send/receive over `MCSession` — this package
   deliberately stops at "here's the `Data` to send," since
   `MultipeerConnectivity` requires the iOS SDK to compile.

## Running the tests

```sh
swift test
```
