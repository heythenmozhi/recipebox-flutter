# RecipeBox Flutter App

RecipeBox is a Flutter recipe app using the public DummyJSON Recipes API.

## The 6 assignment requirements

1. **Paginated recipe list:** loads 20 recipes at a time and has a Load more button.
2. **Search:** searches recipes through DummyJSON.
3. **Details screen:** opens a recipe and shows ingredients and cooking instructions.
4. **Create recipe form:** validates recipe name, cuisine, and preparation time, then sends a POST request.
5. **Local persistence:** favourites are saved with `shared_preferences` and remain after the app restarts.
6. **Network states:** list/details/add flows show loading and error feedback; the list also has an empty state and retry/refresh controls.

## Important API note

DummyJSON is a demo API. `POST /recipes/add` returns a simulated successful response, but the server does not permanently store the new recipe. This app shows that limitation instead of pretending otherwise.

## Run on your Android phone

### 1. Open the project
Extract this ZIP, then open the `RecipeBox_Flutter_Corrected` folder in VS Code or Android Studio. Open a terminal in that folder.

### 2. Check Flutter and install packages
```powershell
flutter doctor
flutter pub get
flutter test
flutter analyze
```

### 3. Prepare Android
In Android Studio, open **SDK Manager → SDK Tools** and install **Android SDK Command-line Tools (latest)** and **Android SDK Platform-Tools**. Accept licenses:
```powershell
flutter doctor --android-licenses
flutter doctor
```

### 4. Run on a real Android phone
- Enable Developer options and USB debugging on the phone.
- Connect it to the computer using a data-capable USB cable.
- Approve the USB debugging prompt on the phone.
- Run:
```powershell
flutter devices
flutter run
```

You can also start an Android emulator from Android Studio's Device Manager and run `flutter run`.

### 5. Build an APK to install/share
```powershell
flutter build apk --release
```
The APK will be created at:
`build\app\outputs\flutter-apk\app-release.apk`

Copy that APK to your phone and install it. Android may ask you to allow installation from that file manager.

## Colour theme

The app uses a warm orange primary colour with a light cream background. The Android app label is `RecipeBox`.

## Notes

- An internet connection is required to load and search online recipes and submit the demo form.
- Favourites are stored on the device.
- The first Android build may take a while while Gradle downloads dependencies.
