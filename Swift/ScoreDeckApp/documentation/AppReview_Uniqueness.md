# ScoreDeck: answers to App Review's 4.3 / 4.2.6 questions

Written 2026-10-17, before the first submission, following `Aguach1leLabs/APP_REVIEW_4_3_GUARD.md`
(rule 3). Keep every answer true; if the product changes, update this file first.

## What changed 2026-10-16/17, before it reaches review

- Its own look: `AguaTheme.scoreDeck` (warm graphite, the icon's amber `#F2B33D`) instead of the
  shared portfolio slate and the shared amber swatch.
- An on-screen "Add Demo Event" button on the empty events screen (the demo was only in the +
  menu, while the text told people to add it).
- The demo event is fictional ("Ridgeline Jam"); it used to carry the legacy app's real event name.
- Its AI image prompt no longer asks for the account's old sticker style.
- Support, privacy and marketing pages, live at `enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/`.
- Screenshots: iPhone 6.3" and iPad 13", English and Spanish (`documentation/store-assets/`),
  staged with `-StoreShot <leaderboard|judge|console|roles|events>` in Debug builds.

## Before you submit

1. **Answer 9 has to be exactly true.** The legacy Objective-C app was built for a BMX event
   ("Dirt Conquers"; its project was internally named RedBullApp). If that first version was
   commissioned or owned by the event's organizer or a sponsor, answer 9 must say so and say why
   ScoreDeck is yours to publish; App Review asks precisely this under 4.2.6.
2. Make answer 5 match App Store Connect → Apps at that moment.
3. Answer 4 describes internal testing; add an external TestFlight round if you run one.
4. Leave 14 days after the previous new-app submission.

## Reply to paste if App Review sends the nine questions (3,732 characters)

```
Thank you for reviewing ScoreDeck. The answers to all nine questions follow.

1. ScoreDeck runs the scoring at a judged competition (BMX and skate contests, gymnastics, dance, any format where judges score competitors in several categories). Every iPhone or iPad at the event takes a role: Judges score each competitor on a large keypad, the Master reviews and approves scores and runs heats and finals, and a Screen shows live, auto-rotating standings to the crowd. The devices sync directly with each other over the local network, so it works at a dirt track or a gym with no internet, no router and no account. It replaces paper score sheets and a laptop spreadsheet, which are slow, error-prone and leave the crowd waiting for results.

2. Organizers, judges and volunteers of small and mid-size judged events: grassroots BMX, skate and scooter contests, school and club gymnastics, dance competitions. Typically a handful of staff with their own phones and an iPad on a stand for the crowd, often outdoors with poor or no internet. English and Spanish.

3. Professional judging systems are sold to federations and big events with dedicated hardware or cloud subscriptions, and general scoring apps assume one person entering every score into one device with an internet connection. ScoreDeck is free, works offline across several devices at once with a review-and-approve step between judges and the master, and gives the crowd a live leaderboard screen, all from the phones and tablets the staff already carry.

4. Testing was internal: my own testing and an internal group of testers, over several rounds. Changes made from it: the first Swift version locked a device into one role for the whole event, which broke when a judge also had to run the screen, so devices now hold any combination of roles and can change them without leaving the event; any connected device can now edit the roster, instead of only the master; a demo event and an on-screen button to add it were added because a new user had nothing to try; and saves that fail mid-event now show an alert instead of crashing.

5. Standalone. My other apps serve unrelated needs: PepperTalk (assertive-communication practice), KeepChallengeIt (one daily fitness challenge), TheLuckyNumber (lottery number picker for entertainment), SharedNapkin (shared sketching for two people), SteadyMind (processing-speed exercises for older adults), YourMindSpark (daily logic puzzles), Critical Path (a business cash-flow simulator) and FidgetLog (a virtual pet). None does event judging, scoring or device-to-device sync.

6. No. None of my other apps deals with events, judges or live results, and ScoreDeck's value is several devices working together at one event; it could not live inside a single-player app.

7. Two small internal packages of mine are linked: AguaDesign (about 200 lines: spacing and a theme structure each app fills with its own colors; ScoreDeck has its own graphite-and-amber scoreboard look) and AguaAI (a wrapper used only for the optional AI banner and avatar images, with the user's own OpenAI key). The judging model, ranking engine, sync protocol and every screen were written for ScoreDeck; no source file is identical to another app's.

8. No. Apple frameworks only (SwiftUI, MultipeerConnectivity, Foundation): no third-party SDKs, templates or content libraries. Optional image generation calls OpenAI directly with the user's own key.

9. No. ScoreDeck is my own product, published under my own developer account. It is a from-scratch rewrite of an offline judging tool I first built in Objective-C for a BMX dirt-jump contest, generalized for any judged event. No client, partner, template provider or app-generation service is involved.
```

## App Review notes (paste into App Review Information → Notes, 1,176 characters)

```
ScoreDeck runs the scoring at a judged event across several devices. No account, no internet and no purchase are needed. You can review everything on one device:

1. On the events screen, tap "Add Demo Event", then open "Ridgeline Jam".
2. Choose roles: turn on Judge, Master and Screen together (one device can hold all three), pick a judge, then Done.
3. Score tab: pick a category and a rider, type a score on the keypad (e.g. 84.5) and tap Submit Score. Because this device is also the Master, the score is approved at once.
4. Leaderboard tab: the auto-rotating standings the crowd sees, overall and per category.
5. Console tab: roster editing, standings, "Advance to Finals" and event export.

With a second device, open the same event (export/import it, or create one and invite the other device from Connections); scores submitted on the judge device then wait for approval on the master. The app asks for Local Network access only to find the other devices at the event.

AI images are optional: in Settings, a user can add their own OpenAI key to generate an event banner or rider avatar. Without a key, the app is fully functional and photos come from the library.
```

## The nine answers

### 1. What the app does and the problem it solves

```
ScoreDeck runs the scoring at a judged competition (BMX and skate contests, gymnastics, dance, any format where judges score competitors in several categories). Every iPhone or iPad at the event takes a role: Judges score each competitor on a large keypad, the Master reviews and approves scores and runs heats and finals, and a Screen shows live, auto-rotating standings to the crowd. The devices sync directly with each other over the local network, so it works at a dirt track or a gym with no internet, no router and no account. It replaces paper score sheets and a laptop spreadsheet, which are slow, error-prone and leave the crowd waiting for results.
```

### 2. Intended user

```
Organizers, judges and volunteers of small and mid-size judged events: grassroots BMX, skate and scooter contests, school and club gymnastics, dance competitions. Typically a handful of staff with their own phones and an iPad on a stand for the crowd, often outdoors with poor or no internet. English and Spanish.
```

### 3. The gap it fills

```
Professional judging systems are sold to federations and big events with dedicated hardware or cloud subscriptions, and general scoring apps assume one person entering every score into one device with an internet connection. ScoreDeck is free, works offline across several devices at once with a review-and-approve step between judges and the master, and gives the crowd a live leaderboard screen, all from the phones and tablets the staff already carry.
```

### 4. Beta testing

```
Testing was internal: my own testing and an internal group of testers, over several rounds. Changes made from it: the first Swift version locked a device into one role for the whole event, which broke when a judge also had to run the screen, so devices now hold any combination of roles and can change them without leaving the event; any connected device can now edit the roster, instead of only the master; a demo event and an on-screen button to add it were added because a new user had nothing to try; and saves that fail mid-event now show an alert instead of crashing.
```

### 5. Standalone product or part of a suite

```
Standalone. My other apps serve unrelated needs: PepperTalk (assertive-communication practice), KeepChallengeIt (one daily fitness challenge), TheLuckyNumber (lottery number picker for entertainment), SharedNapkin (shared sketching for two people), SteadyMind (processing-speed exercises for older adults), YourMindSpark (daily logic puzzles), Critical Path (a business cash-flow simulator) and FidgetLog (a virtual pet). None does event judging, scoring or device-to-device sync.
```

### 6. Could it be an in-app purchase in another app?

```
No. None of my other apps deals with events, judges or live results, and ScoreDeck's value is several devices working together at one event; it could not live inside a single-player app.
```

### 7. Shared code, frameworks or assets with my other apps

```
Two small internal packages of mine are linked: AguaDesign (about 200 lines: spacing and a theme structure each app fills with its own colors; ScoreDeck has its own graphite-and-amber scoreboard look) and AguaAI (a wrapper used only for the optional AI banner and avatar images, with the user's own OpenAI key). The judging model, ranking engine, sync protocol and every screen were written for ScoreDeck; no source file is identical to another app's.
```

### 8. Shared code or content with third-party apps

```
No. Apple frameworks only (SwiftUI, MultipeerConnectivity, Foundation): no third-party SDKs, templates or content libraries. Optional image generation calls OpenAI directly with the user's own key.
```

### 9. Built for a client or third party?

```
No. ScoreDeck is my own product, published under my own developer account. It is a from-scratch rewrite of an offline judging tool I first built in Objective-C for a BMX dirt-jump contest, generalized for any judged event. No client, partner, template provider or app-generation service is involved.
```
