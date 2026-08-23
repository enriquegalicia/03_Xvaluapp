# App Store Connect listing — draft

Draft copy for the ScoreDeck listing, in **English and Spanish** — matching
the in-app localization (`Localizable.xcstrings`/`InfoPlist.xcstrings`, see
CLAUDE.md). These are two separate things Apple treats independently: the
in-app catalog controls what the app itself displays, while this page's
content is what you paste into App Store Connect's own "Localizations"
list (App Information → add "Spanish" as a second app-listing language)
so the Store listing itself — name, description, keywords, screenshots —
also appears in Spanish for users browsing in that language. Screenshots
can't be produced here (no iOS SDK in this sandbox — see CLAUDE.md);
everything else is ready to paste in once the app's been archived.

## English

### Name & subtitle

- **Name** (30 char max): `ScoreDeck`
- **Subtitle** (30 char max): `Live Event Judging & Scoring`

### Promotional text (170 char max, editable without a new build)

> Score any judged event live — BMX, skate, gymnastics, dance. Judges score
> on their own devices, a master console approves, a screen shows results.

### Description

```
ScoreDeck turns any iPad or iPhone into a live judging and scoring system —
no internet connection required.

Built for judged competitions: BMX and skate contests, freestyle and dirt-
jump events, gymnastics, dance, or any format where judges score
competitors across multiple categories and a crowd wants to see live
standings.

HOW IT WORKS
Every device at the event picks a role:
• Judge — score competitors on a simple numeric keypad, one category at a
  time
• Master — review and approve scores, manage the roster, advance to
  finals
• Screen — an unattended, auto-rotating leaderboard for the crowd:
  overall standings plus one page per scoring category

All devices sync over the local network — no Wi-Fi router, no internet,
no account required. Scores judges submit sync to the master in real
time; approved scores push out to every judge and screen device
automatically.

BUILT FOR THE WHOLE EVENT
• Create an event, add participants, judges, and scoring categories in
  minutes
• Give every participant a flag or a photo — add your own or generate one
  with AI
• Add a logo and banner to brand the event on the results screen
• Advance the top competitors to a finals round with one tap
• Full control over your data — nothing leaves your devices except what
  you explicitly sync between them at the event

PRIVACY
ScoreDeck doesn't require an account, doesn't track you, and doesn't send
your event data anywhere. AI image generation is optional and uses your
own OpenAI API key, stored only in this device's Keychain.
```

### Keywords (100 char max, comma-separated, no spaces after commas)

```
judging,scoring,tournament,bmx,skate,competition,judge,leaderboard,scoreboard,event,offline
```

## Spanish

### Name & subtitle

- **Name** (30 char max): `ScoreDeck` — kept as-is; a product name isn't usually translated.
- **Subtitle** (30 char max): `Jueces y puntuación en vivo`

### Promotional text (170 char max)

> Califica cualquier evento en vivo: BMX, skate, gimnasia, baile. Los
> jueces califican desde su dispositivo, un maestro aprueba y una
> pantalla muestra los resultados.

### Description

```
ScoreDeck convierte cualquier iPad o iPhone en un sistema de calificación
y puntuación en vivo, sin necesidad de conexión a internet.

Diseñado para competencias con jueces: contests de BMX y skate, eventos
de freestyle y dirt-jump, gimnasia, baile, o cualquier formato donde los
jueces califiquen a los competidores en varias categorías y el público
quiera ver la clasificación en vivo.

CÓMO FUNCIONA
Cada dispositivo en el evento elige un rol:
• Juez — califica a los competidores con un teclado numérico sencillo,
  una categoría a la vez
• Maestro — revisa y aprueba las calificaciones, gestiona la plantilla,
  avanza a la final
• Pantalla — una tabla de posiciones sin supervisión que se actualiza
  automáticamente para el público: la clasificación general más una
  página por categoría

Todos los dispositivos se sincronizan por la red local — sin router de
Wi-Fi, sin internet, sin necesidad de cuenta. Las calificaciones que
envían los jueces se sincronizan con el maestro en tiempo real; las
calificaciones aprobadas se envían automáticamente a cada juez y a la
pantalla.

PENSADO PARA TODO EL EVENTO
• Crea un evento y agrega participantes, jueces y categorías en minutos
• Dale a cada participante una bandera o una foto — agrega la tuya o
  genera una con IA
• Agrega un logotipo y un banner para personalizar el evento en la
  pantalla de resultados
• Avanza a los mejores competidores a una ronda final con un toque
• Control total sobre tus datos — nada sale de tus dispositivos salvo lo
  que sincronizas explícitamente entre ellos durante el evento

PRIVACIDAD
ScoreDeck no requiere una cuenta, no te rastrea y no envía los datos de
tu evento a ningún lado. La generación de imágenes con IA es opcional y
usa tu propia clave de API de OpenAI, guardada solo en el llavero de
este dispositivo.
```

### Keywords (100 char max)

```
calificacion,puntuacion,torneo,bmx,skate,competencia,juez,clasificacion,marcador,evento,offline
```

*(Written without accents — App Store keyword search is largely
accent-insensitive, and this keeps every term unambiguous in the 100-char
limit. Apple lets you pick a specific Spanish variant — Spain vs. Latin
America — if you want two separate Spanish localizations instead of one;
this draft uses neutral, widely-understood Spanish that reads naturally
in either.)*

## Category

- Primary: **Sports**
- Secondary: **Utilities**

## Age rating

No objectionable content, no user-generated content shared publicly, no
account/login. Expect **4+** — confirm against the current App Store
Connect questionnaire at submission time, since the ratings system is
revised periodically.

## Support & marketing URLs

Not yet set — App Store Connect requires a working support URL (at
minimum a contact page or email) and accepts an optional marketing URL.
Needs a real URL before submission; a bare GitHub repo link works as a
placeholder support URL if nothing else exists yet.

## Privacy policy URL

Required even for an app this data-light, since it still processes photos
a user chooses to submit for AI generation and stores an API key locally.
A short, honest policy is enough — "we don't collect anything; AI features
call OpenAI directly with your own key; nothing is sent to us" — but it
needs to be hosted somewhere App Store Connect can link to (a GitHub Pages
page or a one-line page on any site you control works fine).

## Screenshots

Needed once the app runs on real hardware/simulator, per required device
size (6.7" iPhone, 12.9" iPad at minimum for a universal app). Good shot
list once it's running:
1. Screen role — the auto-rotating standings carousel with an event
   banner set
2. Judge role — the scoring keypad mid-entry
3. Master console — roster + connections + advance-to-finals
4. Roster editor — a participant with an AI-generated photo
5. Event list — a couple of events with logos set
