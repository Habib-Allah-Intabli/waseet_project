# Waseet Project - Mobile Deployment Checklist

This document outlines the step-by-step checklist required to safely build, sign, optimize, and release the Waseet application for Android and iOS production environments.

---

## 🤖 Android Deployment

### 1. Signing Configuration
- [ ] **Generate Upload Keystore**: Generate a secure keystore file using `keytool`:
  ```bash
  keytool -genkey -v -keystore upload-keystore.jks -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  ```
- [ ] **Configure keystore properties**: Create a file named `android/key.properties` (this is ignored by Git in `.gitignore`):
  ```properties
  storePassword=<keystore-password>
  keyPassword=<key-password>
  keyAlias=upload
  storeFile=../upload-keystore.jks
  ```
- [ ] **Edit `android/app/build.gradle`**: Ensure the signing configurations load from `key.properties`:
  ```groovy
  def keystoreProperties = new Properties()
  def keystorePropertiesFile = rootProject.file('key.properties')
  if (keystorePropertiesFile.exists()) {
      keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
  }

  android {
      ...
      signingConfigs {
          release {
              keyAlias keystoreProperties['keyAlias']
              keyPassword keystoreProperties['keyPassword']
              storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
              storePassword keystoreProperties['storePassword']
          }
      }
      buildTypes {
          release {
              signingConfig signingConfigs.release
              minifyEnabled true
              shrinkResources true
              proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
          }
      }
  }
  ```

### 2. Permissions & Manifest
- [ ] **Review `android/app/src/main/AndroidManifest.xml`**:
  - [ ] Internet permission: `<uses-permission android:name="android.permission.INTERNET"/>`
  - [ ] Notification access and post permissions (Android 13+ support).
- [ ] **Set target and compile SDK versions**: Ensure they comply with current Google Play Console requirements (e.g. compile/target SDK 34+).

### 3. Build & Release
- [ ] Clean build artifacts:
  ```bash
  flutter clean
  flutter pub get
  ```
- [ ] Build Android App Bundle (AAB):
  ```bash
  flutter build appbundle --release
  ```

---

## 🍏 iOS Deployment

### 1. App Store Connect & Xcode Configuration
- [ ] **App ID & Profiles**: Register the Bundle Identifier in Apple Developer portal and create App Store Provisioning Profiles.
- [ ] **Deployment Target**: Set the iOS deployment target inside Xcode (`Runner.xcodeproj`) to iOS 12.0 or higher.
- [ ] **Display Name & Bundle Identifier**: Validate Bundle Identifier and Display Name in the Xcode General Settings.

### 2. Manifest & Privacy Keys (`Info.plist`)
- [ ] **Localization strings**: Ensure `easy_localization` config is loaded and target supported locales (`ar`, `en`).
- [ ] **Privacy permissions descriptions**: Include description strings for permissions used in the application:
  - [ ] Notification permissions.
  - [ ] Cellular data access.

### 3. Build & Archive
- [ ] Install Pods:
  ```bash
  cd ios
  pod install
  cd ..
  ```
- [ ] Build iOS IPA:
  ```bash
  flutter build ipa --release
  ```
- [ ] Open Xcode project, select **Product > Archive**, and upload the build using Organizer or Transporter to App Store Connect.

---

## 🔥 Firebase & Analytics Configuration

- [ ] **Default Firebase Config**: Verify `lib/firebase_options.dart` points to your production Firebase projects.
- [ ] **Google Services files**:
  - [ ] Place `google-services.json` inside `android/app/`.
  - [ ] Place `GoogleService-Info.plist` inside `ios/Runner/` using Xcode.
- [ ] **Authentication Settings**: Enable email/password sign-in provider in your Firebase project console.
- [ ] **Firestore Rules**: Verify Firestore security rules are configured to require authentication:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /users/{userId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      match /trips/{tripId} {
        allow read: if request.auth != null;
        allow write: if request.auth != null && request.auth.uid == resource.data.userId;
      }
      match /bookings/{bookingId} {
        allow read, write: if request.auth != null;
      }
    }
  }
  ```

---

## 🏁 Post-Deployment Verification

- [ ] Perform E2E tests on real physical devices (both iOS and Android).
- [ ] Verify Push Notification delivery under background and foreground states using Firebase Cloud Messaging.
- [ ] Validate theme persistence and language changes.
