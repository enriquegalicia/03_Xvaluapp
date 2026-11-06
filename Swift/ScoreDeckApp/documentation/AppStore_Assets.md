# App Store assets: ScoreDeck

Portfolio rules, specs and workflow: `Aguach1leLabs/APP_STORE_ASSETS.md` (in the main
Aguach1leLabs repo; this app lives in its own repo). Upload-ready files go in
[store-assets/](store-assets/), one folder per slot. Check them from the Aguach1leLabs repo:
`python3 scripts/store_assets.py check "/Users/aguachile/Desktop/DEVELOPMENTS/03_Xvaluapp/Swift/ScoreDeckApp"`.

**State (2026-10-06):** Nothing is captured ([APP_STORE_LISTING.md](../APP_STORE_LISTING.md) still asks for 6.7" and 12.9"; the required sizes are now **iPhone 6.3" (1206 × 2622)** and **iPad 13" (2064 × 2752)**). This app's iPad layout matters most: events run on iPads. Capture on **iPhone 17 Pro** and **iPad Pro 13-inch (M5)** simulators, EN + ES.

## Screenshot story

Up to three can appear in search on their own, so 1-3 must explain the product without help.

1. **Screen role**: the auto-rotating standings carousel with an event banner
2. **Judge role**: the scoring keypad mid-entry
3. **Master console**: roster, connections, advance to finals
4. Roster editor
5. Event list

## Capture

Read by `python3 scripts/capture_screens.py "<this app's folder>"` (in the Aguach1leLabs repo): one line per shot (name: launch arguments), captured on iPhone 17 Pro and iPad Pro 13-inch (M5) in every language. `-StoreShot <id>` (Debug builds only, `Sources/DemoData.swift`) seeds the scored demo event and opens that screen without starting the local-network session. Added 2026-10-30, after four of the earlier captures came out blank.

- **01-leaderboard:** -StoreShot leaderboard
- **02-judge:** -StoreShot judge
- **03-console:** -StoreShot console
- **04-roles:** -StoreShot roles
- **05-events:** -StoreShot events
- **Wait:** 9

## On-image text

| # | EN | ES |
|---|---|---|
| 1 | Live results for the crowd | Resultados en vivo para el público |
| 2 | Judges score on their own device | Cada juez califica en su dispositivo |
| 3 | No internet needed | Sin necesidad de internet |

## Art spec

Read by `python3 scripts/creative_assets.py "/Users/aguachile/Desktop/DEVELOPMENTS/03_Xvaluapp/Swift/ScoreDeckApp"` (in the Aguach1leLabs repo). Edit a line, then
re-run: `--force` regenerates the AI art, while the search composite re-renders free from the cached
background. `Search screens` match the upload-ready screenshots by number (`01` → `en-01-*.png`), so
the search asset appears as soon as screenshots exist. Art direction is this app's own; no
sibling uses the same medium (4.3 rule (`Aguach1leLabs/APP_STORE_ASSETS.md`)).

- **Header prompt:** Wide bold sports-broadcast style illustration at night: a BMX rider silhouette mid-air above a dirt-jump ramp in the centre, stadium floodlights and a cheering crowd as soft shapes below, an amber (#D4960A) judge's clipboard scorecard with a bright star badge glowing in the sky like a scoreboard, dynamic light streaks. Exciting and family-friendly. The rider sits in the central 60%. No readable faces, no text, letters, numbers, logos, phones or UI.
- **Search background prompt:** Night stadium background with soft floodlight glows and crowd silhouettes only along the bottom edge and corners, deep navy and amber. The top third and the centre must stay calm and nearly empty so a headline and phone screenshots can sit there. No text, letters, numbers, logos, phones or UI anywhere.
- **Search screens:** 01, 02, 03
- **Search headline:** en = Live judging for any event | es = Jueceo en vivo para cualquier evento
- **Ink:** #FFF6E5
- **Font:** SFNS.ttf Expanded Heavy

## Product Page Optimization

Rules: APP_STORE_ASSETS.md §6 (`Aguach1leLabs/APP_STORE_ASSETS.md`).
Starts once a version is approved and live. One test at a time, up to 90 days.

**Test 1: Crowd screen vs judge keypad.** Do organisers respond more to the crowd leaderboard (the show) or the judge keypad (how simple it is)? Use 2 treatments at 50% traffic (25% each), in every language the
page has.

- **Original:** the Screen role standings
- **Treatment A** (`store-assets/ppo/a-judge-first/`): the judge keypad first
- **Treatment B** (`store-assets/ppo/b-master-first/`): the master console first

Apply a winner only at 90% confidence. **Next test:** captions on vs off the first three
screenshots. An icon test needs the alternate icon shipped in a build first (§6).

**Results log:** none yet.

## Custom Product Pages

Rules: APP_STORE_ASSETS.md §7 (`Aguach1leLabs/APP_STORE_ASSETS.md`).
In App Store Connect: *Custom Product Pages → +*. Choose **Copy Existing Product Page** and use
Reference Name `ScoreDeck · <slug> · <audience>`. Files go in `store-assets/cpp/<slug>/<slot>/`.
Each keyword can belong to only one page.

| Slug | Audience · keywords | First screenshot | Promo text | Deep link |
|---|---|---|---|---|
| `bmx-skate` | BMX and skate contests · bmx contest, skate competition scoring | Screen role standings for a BMX event | Run your BMX or skate contest with live judging on iPads, no internet needed.<br>ES: Organiza tu competencia de BMX o skate con jueceo en vivo en iPads, sin internet. | opens Screen |
| `gymnastics-dance` | Gymnastics and dance · gymnastics scoring, dance competition judging | the judge keypad | Judges score on their own devices; the crowd sees live results.<br>ES: Los jueces califican en sus dispositivos y el público ve resultados en vivo. | opens Judge |

## Watch-outs

- Every asset must be 4+, with no prices, URLs, ©, Apple awards, other platforms or competitor names.
- Participant photos in demo data must be AI-generated or ours, never real riders.
- No real event, sponsor or federation logos (no X Games, no UCI).
- Keep riders' tricks safe-looking: no crashes on images.
