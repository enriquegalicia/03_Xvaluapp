# Legacy

Files moved here on 2026-08-07 during the Swift migration cleanup. None of these
were referenced by `Xvaluapp.xcodeproj/project.pbxproj` (verified by grep before
moving), so relocating them does not affect the original Objective-C build.

- **BuildArchives/** — four old exported `.ipa` builds (A1/A2/B1/C1) that were
  sitting in the repo root. Build products don't belong in git history going
  forward — ship via TestFlight/Releases instead. Kept here rather than deleted
  since they may be useful reference artifacts of what actually shipped.
- **UnusedRootIcons/** — pre-`Images.xcassets` era icon PNGs (`icon-29.png`,
  `icon_iPad-*.png`, `iconiTunesArtWork-*.png`) duplicated at the repo root.
  The active icons live in `RedBullApp/Images.xcassets/AppIcon.appiconset/`;
  these root copies were dead weight.
- **DeadCode/** — `TablaSeccionada copia.h/.m`, an orphaned earlier fork of
  `TablaSeccionada` with regressed/buggier pagination math and zero `#import`
  references anywhere in the project. Not part of the app; kept for history
  only.

See the migration report (shared separately) for the full analysis, the
target Swift project layout, and the phased porting plan.
