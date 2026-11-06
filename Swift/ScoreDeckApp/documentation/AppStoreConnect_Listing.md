# ScoreDeck — App Store Connect listing

**Paste from this file only.** Every field App Store Connect asks for, in the order its pages
show them (written 2026-10-19). Background stays in [../APP_STORE_LISTING.md](../APP_STORE_LISTING.md)
and [AppStore_Assets.md](AppStore_Assets.md); where they disagree with this sheet, this sheet
wins. Check from the Aguach1leLabs repo:
`python3 scripts/listing_check.py ~/Desktop/DEVELOPMENTS/03_Xvaluapp/Swift/ScoreDeckApp --live`.

## App Information

| Field | Value |
|---|---|
| Bundle ID | `com.aguach1leLabs.ScoreDeck` |
| SKU | `ScoreDeck` |
| Primary language | English (U.S.) |
| Primary category | Sports |
| Secondary category | Utilities |
| Content rights | No, it does not contain, show, or access third-party content (rosters, logos and photos are the organizer's own or generated with their key) |
| Age rating | 4+. Questionnaire: every content question "None"; no unrestricted web access; devices at one event sync with each other over the local network, with no chat and no public sharing |

## Pricing and Availability

| Field | Value |
|---|---|
| Price | Free (no in-app purchases) |
| Availability | All countries and regions |

## App Privacy

| Field | Value |
|---|---|
| Privacy Policy URL | `https://enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/privacy.html` |
| Data collection | **Data Not Collected.** Event data moves only between the event's own devices over the local network (MultipeerConnectivity); optional AI images send a short text description to OpenAI under the organizer's own key; the developer runs no server |

## Listing: English (U.S.)

### Name
```text
ScoreDeck
```

### Subtitle
```text
Live Event Judging & Scoring
```

### Promotional Text
```text
Score any judged event live — BMX, skate, gymnastics, dance. Judges score on their own devices, a master console approves, a screen shows results.
```

### Description
```text
ScoreDeck turns any iPad or iPhone into a live judging and scoring system — no internet connection required.

Built for judged competitions: BMX and skate contests, freestyle and dirt-jump events, gymnastics, dance, or any format where judges score competitors across multiple categories and a crowd wants to see live standings.

HOW IT WORKS
Every device at the event picks a role:
• Judge — score competitors on a simple numeric keypad, one category at a time
• Master — review and approve scores, manage the roster, advance to finals
• Screen — an unattended, auto-rotating leaderboard for the crowd: overall standings plus one page per scoring category

All devices sync over the local network — no Wi-Fi router, no internet, no account required. Scores judges submit sync to the master in real time; approved scores push out to every judge and screen device automatically.

BUILT FOR THE WHOLE EVENT
• Create an event, add participants, judges, and scoring categories in minutes
• Give every participant a flag or a photo — add your own or generate one with AI
• Add a logo and banner to brand the event on the results screen
• Advance the top competitors to a finals round with one tap
• Full control over your data — nothing leaves your devices except what you explicitly sync between them at the event

PRIVACY
ScoreDeck doesn't require an account, doesn't track you, and doesn't send your event data anywhere. AI image generation is optional and uses your own OpenAI API key, stored only in this device's Keychain.
```

### Keywords
```text
judging,scoring,tournament,bmx,skate,competition,judge,leaderboard,scoreboard,event,offline
```

### Support URL
```text
https://enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/support.html
```

### Marketing URL
```text
https://enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/marketing.html
```

### Screenshots
`store-assets/iphone-6.3/en-*.png` → iPhone 6.3" · `store-assets/ipad-13/en-*.png` → iPad 13". Upload in file-name order.

## Listing: Spanish (Mexico)

### Name
```text
ScoreDeck
```

### Subtitle
```text
Jueces y puntuación en vivo
```

### Promotional Text
```text
Califica cualquier evento en vivo: BMX, skate, gimnasia, baile. Los jueces califican desde su dispositivo, un maestro aprueba y una pantalla muestra los resultados.
```

### Description
```text
ScoreDeck convierte cualquier iPad o iPhone en un sistema de calificación y puntuación en vivo, sin necesidad de conexión a internet.

Diseñado para competencias con jueces: contests de BMX y skate, eventos de freestyle y dirt-jump, gimnasia, baile, o cualquier formato donde los jueces califiquen a los competidores en varias categorías y el público quiera ver la clasificación en vivo.

CÓMO FUNCIONA
Cada dispositivo en el evento elige un rol:
• Juez — califica a los competidores con un teclado numérico sencillo, una categoría a la vez
• Maestro — revisa y aprueba las calificaciones, gestiona la plantilla, avanza a la final
• Pantalla — una tabla de posiciones sin supervisión que se actualiza automáticamente para el público: la clasificación general más una página por categoría

Todos los dispositivos se sincronizan por la red local — sin router de Wi-Fi, sin internet, sin necesidad de cuenta. Las calificaciones que envían los jueces se sincronizan con el maestro en tiempo real; las calificaciones aprobadas se envían automáticamente a cada juez y a la pantalla.

PENSADO PARA TODO EL EVENTO
• Crea un evento y agrega participantes, jueces y categorías en minutos
• Dale a cada participante una bandera o una foto — agrega la tuya o genera una con IA
• Agrega un logotipo y un banner para personalizar el evento en la pantalla de resultados
• Avanza a los mejores competidores a una ronda final con un toque
• Control total sobre tus datos — nada sale de tus dispositivos salvo lo que sincronizas explícitamente entre ellos durante el evento

PRIVACIDAD
ScoreDeck no requiere una cuenta, no te rastrea y no envía los datos de tu evento a ningún lado. La generación de imágenes con IA es opcional y usa tu propia clave de API de OpenAI, guardada solo en el llavero de este dispositivo.
```

### Keywords
```text
calificacion,puntuacion,torneo,bmx,skate,competencia,juez,clasificacion,marcador,evento,offline
```

### Support URL
```text
https://enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/support.html
```

### Marketing URL
```text
https://enriquegalicia.github.io/Aguach1leLabs-pages/scoredeck/marketing.html
```

### Screenshots
`store-assets/iphone-6.3/es-*.png` · `store-assets/ipad-13/es-*.png`. The Spanish set shows the Spanish UI.

## Version

| Field | Value |
|---|---|
| Version | 1.0 (build 1, from `Sources/Info.plist`) |
| Copyright | 2026 Aguach1leLabs |
| Release | Automatically release this version |
| Export compliance | `ITSAppUsesNonExemptEncryption = false` is in the build (standard HTTPS and MultipeerConnectivity's own encryption only) |

## App Review

| Field | Value |
|---|---|
| Sign-in required | No (no account exists) |
| Contact name | Enrique Galicia |
| Contact email | mat.enrique.galicia@gmail.com |
| Contact phone | Entered in App Store Connect (not kept in the repo) |

### Notes
```text
ScoreDeck runs the scoring at a judged event across several devices. No account, no internet and no purchase are needed. You can review everything on one device:

1. On the events screen, tap "Add Demo Event", then open "Ridgeline Jam".
2. Choose roles: turn on Judge, Master and Screen together (one device can hold all three), pick a judge, then Done.
3. Score tab: pick a category and a rider, type a score on the keypad (e.g. 84.5) and tap Submit Score. Because this device is also the Master, the score is approved at once.
4. Leaderboard tab: the auto-rotating standings the crowd sees, overall and per category.
5. Console tab: roster editing, standings, "Advance to Finals" and event export.

With a second device, open the same event (export/import it, or create one and invite the other device from Connections); scores submitted on the judge device then wait for approval on the master. The app asks for Local Network access only to find the other devices at the event.

AI images are optional: in Settings, a user can add their own OpenAI key to generate an event banner or rider avatar. Without a key, the app is fully functional and photos come from the library.
```
