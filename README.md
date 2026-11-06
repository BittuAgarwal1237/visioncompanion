# Vision Companion

A Flutter app that uses the phone camera in two ways. One screen finds objects live through the camera using a TFLite model that runs on the device. The other lets you take a photo and sends it to an AI vision API, which gives back a short description and a few tags. It works with TalkBack, and the whole app is available in English and Hindi.

I built this for the ProxMaq Flutter assignment. It is Android only, since that is what I tested on.

**APK download:** `https://drive.google.com/drive/folders/1un1Zb12HoWlfonijQ7QyWtUni44qjAOh?usp=sharing`

## What it does

- **Live object detector.** Opens the back camera, runs `ssd_mobilenet_v1` on the camera frames in a separate isolate, and draws boxes with the confidence on top of the preview. Boxes are coloured by category (people, vehicles, animals and so on) and the inference time of the last frame is shown on screen. There is a pause/resume button. When the top object changes the phone vibrates, and TalkBack reads out the top object at most once every 2 seconds.
- **AI image analyzer.** Take a photo, wait for the spinner, and you get a description plus tags with a confidence for each. While it works, TalkBack says "Analyzing image, please wait" and the camera button is disabled. If something fails you get a normal message and a retry button, never a stack trace. The photo is not uploaded to Firebase, it only goes to the API.
- **History.** Every detection and analysis is saved to Firestore under `users/{uid}/history` with `timestamp`, `featureType` and `resultSummary`. Detector entries also store the raw labels of the top three objects in an `items` list. For the analyzer, `resultSummary` is the description followed by the names of its top five tags. The History tab shows the latest 100, newest first, and you swipe an entry away to delete it.
- **Login.** Email and password, or Google Sign-In. The session stays after you close the app.
- **Language.** English and Hindi, switchable from Settings. The choice is remembered.

## Models used

| Feature | Model | Where it runs |
| --- | --- | --- |
| Live object detector | `ssd_mobilenet_v1` (TFLite) | On the phone |
| AI image analyzer | `qwen/qwen3.8-27b` | Groq API |

## Stack

Flutter 3, flutter_bloc (Cubit), equatable, go_router, get_it, Firebase (Auth, Firestore, Crashlytics, Analytics), google_sign_in, tflite_flutter, camera, image_picker, http, flutter_dotenv, shared_preferences, and flutter_localizations with intl and ARB files.

## Setting it up

You need Flutter 3.x, Android Studio (or just the Android SDK), and a real Android phone. The camera and TFLite parts do not behave well on an emulator.

### 1. Get the code

```
git clone PASTE_REPO_URL_HERE
cd visioncompanion
flutter pub get
```

### 2. The model files

```
assets/models/ssd_mobilenet_v1.tflite
assets/models/labelmap.txt
```

Put the `.tflite` file directly in that folder. If the exact file names are not found, the app looks for any `.tflite` and `.txt` file under `assets/models/`, but Flutter only knows about files in folders that are listed in `pubspec.yaml`. If the file ends up inside a subfolder, that subfolder has to be listed too. Both `assets/models/` and `.env` need to be listed under `flutter: assets:` in `pubspec.yaml`.

### 3. Firebase

`google-services.json` and the API keys are not committed, so you have to connect your own Firebase project.

1. Create a project at the Firebase console.
2. Add an Android app. The package name is `com.example.visioncompanion`.
3. In Authentication, turn on **Email/Password** and **Google**.
4. Create a Firestore database.
5. Turn on Crashlytics. Analytics comes with the project.
6. Add your SHA-1 and SHA-256 fingerprints in the project settings. Google Sign-In will not work without them. For the debug key you can get them with `cd android && ./gradlew signingReport`. For a release build, use the fingerprints of your release keystore as well.
7. Run FlutterFire from the project folder. This creates `lib/firebase_options.dart` with your own project's identifiers, replacing any existing one:
   ```
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
8. Download `google-services.json` and place it in `android/app/`.



### 4. The `.env` file

Copy `.env.example` to `.env` in the project root (next to `pubspec.yaml`, not inside `lib/`) and fill in your key:

```
GROQ_API_KEY=gsk_your_key_here
```


One thing to know about the model. The assignment says to use `meta-llama/llama-4-scout-17b-16e-instruct`, but Groq shut that model down in July 2026 and it now returns a 404. The app uses `qwen/qwen3.8-27b` instead, which accepts images and is available on my Groq account. The models are kept in a list in `lib/core/constants/app_constants.dart` (`groqModels`). If Groq answers 404 or 400 for a model, the app tries the next one in the list; right now the list has one model. If Groq removes it too, check `console.groq.com/docs/vision` for the current vision model and change the entry in that list.

### 5. Run it

```
flutter run
```

Release build:

```
flutter build apk --release
```

The APK ends up in `build/app/outputs/flutter-apk/app-release.apk`.

## Project layout

```
lib/
  core/          theme, router, dependency injection (get_it), constants, services
  features/
    auth/        login, register, Google sign-in
    home/        home screen, bottom navigation, profile sheet
    detector/    live TFLite detection
    analyzer/    photo + AI analysis
    history/     saved results from Firestore
    settings/    language switch
  l10n/          app_en.arb, app_hi.arb
  main.dart
```

Each feature has its own Cubit with sealed state classes. Widgets only show state and call the Cubit, the logic sits in the Cubits and in the data classes next to them. Repositories and services are registered with get_it in `core/di/service_locator.dart`.

## Testing

I tested on a physical Android phone and on an emulator, and went through every screen with TalkBack.

- Physical phone: `FILL_IN_PHONE_MODEL`, Android `FILL_IN`
- Emulator: `FILL_IN_EMULATOR_NAME`, Android `FILL_IN`
- Screen recording: `PASTE_RECORDING_LINK_HERE`

## Known problems

- Android only. I did not try iOS.
- Detection speed depends on the phone. The assignment asks for under 150 ms per frame, and the screen shows the real inference time so you can check it on your own device. My test numbers are in the documentation.
- The AI analyzer uses Groq's free tier, so it can be slow or refuse requests when the limit is hit. The model it uses is a preview model and Groq may change or remove it.
- Any failed reply from Groq that is not a rejected key (a removed model, a server error) is shown with the same "AI service is busy" message as a rate limit. In a debug run the real status code and reply are printed to the log.
- The detector only knows the 80 COCO classes. Things outside that list will be missed or labelled as something close.
- Detector entries in History are translated when they are shown, so they follow the current language. This works because new detector entries store the raw labels in the `items` list; the summary text is only a fallback for entries without it. Analyzer entries keep the text the AI wrote at that moment, in the language that was active then.


