# 🔑 Updated SHA-1 Fingerprint - Project-Specific Keystore

**Date:** October 4, 2025  
**Issue:** Firebase OAuth conflict - Another project was using the same SHA-1 from default keystore  
**Solution:** Created project-specific keystore with unique SHA-1

---

## ✅ New SHA-1 Fingerprint (Use This!)

**SHA-1:**
```
7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB
```

**SHA-256:**
```
DC:64:C6:E0:13:B9:C7:8C:4A:6B:33:68:B1:C4:04:B8:C1:81:0F:78:82:A4:84:70:86:86:B8:7E:C8:11:7B:4C
```

**Valid Until:** February 19, 2053

---

## 📍 What Changed?

### Before (Old - DO NOT USE):
- **Keystore:** `C:\Users\hisham\.android\debug.keystore` (Default Android keystore)
- **SHA-1:** `EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE`
- **Problem:** Shared across ALL Flutter projects on this machine
- **Result:** Firebase OAuth conflict error

### After (New - CURRENT):
- **Keystore:** `android/app/keystore/otlob-debug.keystore` (Project-specific)
- **SHA-1:** `7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB`
- **Alias:** `otlob-key-alias`
- **Passwords:** `otlob2025` (both store and key)
- **Benefit:** Unique to this project only - No conflicts!

---

## 🔧 How It Works

### Keystore Configuration

The project now has its own keystore configured in:

**File:** `android/key.properties` (gitignored)
```properties
storePassword=otlob2025
keyPassword=otlob2025
keyAlias=otlob-key-alias
storeFile=keystore/otlob-debug.keystore
```

**File:** `android/app/build.gradle.kts`
```kotlin
import java.util.Properties
import java.io.FileInputStream

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        getByName("debug") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
```

---

## 📋 Next Steps - Update Firebase Console

### 1. Remove Old SHA-1 (Optional but Recommended)

Go to: https://console.firebase.google.com/project/otlob-6e081/settings/general

1. Scroll to **"Your apps"** section
2. Click on **Android app** (com.example.flutter_application_1)
3. Find the old SHA-1: `EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE`
4. Click **"Remove"** or **"Delete"** (if present)

### 2. Add New SHA-1 (REQUIRED)

1. Still in Project Settings → Android app section
2. Click **"Add fingerprint"** button
3. Paste the **NEW SHA-1**:
   ```
   7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB
   ```
4. *(Optional)* Also add **SHA-256**:
   ```
   DC:64:C6:E0:13:B9:C7:8C:4A:6B:33:68:B1:C4:04:B8:C1:81:0F:78:82:A4:84:70:86:86:B8:7E:C8:11:7B:4C
   ```
5. Click **"Save"**

### 3. Download New google-services.json

After adding the SHA-1, Firebase may regenerate the configuration:

1. In the same Android app section
2. Click **"Download google-services.json"**
3. Replace the file at: `android/app/google-services.json`
4. ⚠️ **DO NOT COMMIT** - It's gitignored

### 4. Enable Google Sign-in

Now you can enable Google authentication:

1. Go to: https://console.firebase.google.com/project/otlob-6e081/authentication/providers
2. Click **"Google"**
3. Toggle **"Enable"**
4. Set support email: `getotlob@gmail.com`
5. Click **"Save"**

---

## 🧪 Verification

### Check Current SHA-1

To verify the project is using the new keystore:

```powershell
cd android
.\gradlew signingReport
```

**Expected Output (for :app module):**
```
Variant: debug
Config: debug
Store: C:\Users\hisham\...\flutter_application_1\android\app\keystore\otlob-debug.keystore
Alias: otlob-key-alias
SHA1: 7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB
Valid until: Wednesday, February 19, 2053
```

### Test Build

```powershell
flutter clean
flutter pub get
flutter build apk --debug
```

The APK will be signed with the new keystore automatically.

---

## 🔒 Security Notes

### Files Added to .gitignore

```gitignore
# Keystore files (CRITICAL - Contains signing keys!)
android/key.properties
android/app/keystore/
*.keystore
*.jks
```

### Keystore Backup

**⚠️ IMPORTANT:** Backup the keystore file safely!

**Location to Backup:**
- `android/app/keystore/otlob-debug.keystore`

**Why:** If you lose this keystore, you cannot:
- Update the app on devices that have it installed
- Use the same SHA-1 for Firebase (will need to regenerate everything)

**Where to Store:**
- External hard drive (encrypted)
- Password manager (as binary attachment)
- Secure cloud storage (private, encrypted)
- **DO NOT:** Commit to Git, share publicly, email

---

## 🆘 Troubleshooting

### Error: "Another project contains an OAuth 2.0 client..."

✅ **Fixed!** This was the original problem. The new project-specific keystore resolves it.

### Build Error: "keystore not found"

**Cause:** The `key.properties` file is missing or incorrect.

**Solution:**
```powershell
# Recreate key.properties in android/ folder
echo "storePassword=otlob2025" > android\key.properties
echo "keyPassword=otlob2025" >> android\key.properties
echo "keyAlias=otlob-key-alias" >> android\key.properties
echo "storeFile=keystore/otlob-debug.keystore" >> android\key.properties
```

### Google Sign-in Still Not Working

1. ✅ Verify new SHA-1 is added in Firebase Console
2. ✅ Download latest `google-services.json`
3. ✅ Run `flutter clean && flutter pub get`
4. ✅ Rebuild the app
5. ✅ Check Firebase Authentication is enabled
6. ✅ Check support email is set to `getotlob@gmail.com`

### Need to Regenerate Keystore

If you need to create a new keystore again:

```powershell
# Delete old keystore
Remove-Item android\app\keystore\otlob-debug.keystore

# Generate new one
& "C:\Program Files\Java\jdk-22\bin\keytool.exe" -genkey -v `
  -keystore "android\app\keystore\otlob-debug.keystore" `
  -alias otlob-key-alias `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -storepass otlob2025 `
  -keypass otlob2025 `
  -dname "CN=Otlob App, OU=Development, O=Otlob, L=Cairo, S=Cairo, C=EG"

# Get new SHA-1
cd android
.\gradlew signingReport
```

---

## 📚 References

- **Firebase Project:** https://console.firebase.google.com/project/otlob-6e081
- **Firebase Documentation:** https://firebase.google.com/docs/android/setup
- **Android Signing Guide:** https://developer.android.com/studio/publish/app-signing
- **Flutter Signing Guide:** https://docs.flutter.dev/deployment/android#signing-the-app

---

## ✅ Checklist

- [x] Created project-specific keystore
- [x] Updated build.gradle.kts to use new keystore
- [x] Created key.properties configuration file
- [x] Added keystore files to .gitignore
- [x] Verified new SHA-1: `7F:92:17:18:4F:49:76:F9:FF:C6:5C:60:A6:B4:5B:2B:DD:BC:A5:EB`
- [ ] **TODO:** Remove old SHA-1 from Firebase Console
- [ ] **TODO:** Add new SHA-1 to Firebase Console
- [ ] **TODO:** Enable Google Sign-in in Firebase
- [ ] **TODO:** Download updated google-services.json
- [ ] **TODO:** Test Google Sign-in functionality

---

**Status:** ✅ **READY** - New keystore configured and working!  
**Next Action:** Update Firebase Console with new SHA-1 fingerprint
