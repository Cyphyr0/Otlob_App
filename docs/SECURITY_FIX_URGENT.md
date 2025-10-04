# 🚨 URGENT: Security Fix - Exposed API Keys

**Date:** October 4, 2025  
**Status:** ⚠️ CRITICAL - Immediate action required

## 🔴 Problem

Firebase API keys were accidentally committed to the public GitHub repository in commit `43779e3`. GitHub detected the following exposed secrets:

- `lib/firebase_options.dart` (Lines 47, 57, 65)
- `android/app/google-services.json`
- `firebase.json`

**These files contain:**
- Firebase API keys
- Project IDs
- App IDs
- Sender IDs

## ✅ Immediate Actions Taken

1. ✅ Added sensitive files to `.gitignore`
2. ⏳ Need to remove from Git history
3. ⏳ Need to rotate Firebase keys

## 🔧 Step-by-Step Fix

### Option 1: Force Push (Easiest - If no one else is using the repo)

```powershell
# 1. Remove files from Git cache
git rm --cached lib/firebase_options.dart
git rm --cached android/app/google-services.json
git rm --cached firebase.json

# 2. Commit the removal
git commit -m "security: Remove sensitive Firebase files from tracking"

# 3. Force push to rewrite history
git push origin main --force
```

### Option 2: BFG Repo Cleaner (Recommended - Cleanest solution)

```powershell
# 1. Download BFG Repo Cleaner
# Download from: https://rtyley.github.io/bfg-repo-cleaner/

# 2. Clone a fresh copy of your repo
cd C:\Users\hisham\Desktop\Dev\Projects\
git clone --mirror https://github.com/Cyphyr0/Otlob_App.git

# 3. Run BFG to remove the files
java -jar bfg.jar --delete-files firebase_options.dart Otlob_App.git
java -jar bfg.jar --delete-files google-services.json Otlob_App.git
java -jar bfg.jar --delete-files firebase.json Otlob_App.git

# 4. Clean up and push
cd Otlob_App.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

### Option 3: GitHub Secret Scanning Fix (Quick)

Since the files are already in `.gitignore`:

```powershell
# 1. Make a new commit that overwrites the old files
# (Firebase will regenerate new keys automatically)

# 2. Reconfigure Firebase to get NEW keys
dart pub global run flutterfire_cli:flutterfire configure --project=otlob-app-98371 --out=lib/firebase_options.dart --yes

# 3. Commit and push
git add .
git commit -m "security: Regenerate Firebase configuration with new keys"
git push origin main

# 4. Contact GitHub to dismiss the security alert
# Go to: https://github.com/Cyphyr0/Otlob_App/security/secret-scanning
```

## 🔐 Rotate Firebase Keys (IMPORTANT!)

Even after removing from Git, the old keys are still valid. You MUST rotate them:

### In Firebase Console:

1. **Restrict API Keys**
   - Go to: https://console.cloud.google.com/apis/credentials?project=otlob-app-98371
   - Find your API keys
   - Click each key → **API restrictions**
   - Restrict to only: Firebase, FCM, Firestore
   - Add **Application restrictions** → Set to your Android package name

2. **Enable App Check (Recommended)**
   - Go to Firebase Console → Build → App Check
   - Register your app
   - This prevents unauthorized API access even if keys leak

3. **Regenerate Keys (If paranoid)**
   - Delete the old API keys in Google Cloud Console
   - Reconfigure Firebase with `flutterfire configure`
   - This generates completely new keys

## 📝 .gitignore Updated

Added to `.gitignore`:
```
# Firebase sensitive files
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
firebase.json
.firebaserc
```

## 🎯 Prevention for Future

### 1. Use Environment Variables (Production)
```dart
// Instead of hardcoded keys, use:
class FirebaseConfig {
  static const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
}
```

### 2. Use Git Hooks
Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
if git diff --cached --name-only | grep -q "firebase_options.dart"; then
    echo "❌ ERROR: Attempting to commit firebase_options.dart!"
    exit 1
fi
```

### 3. Use Secret Scanning
Enable in GitHub: Settings → Code security and analysis → Secret scanning

## ⚠️ Why This Matters

**Exposed Firebase keys can allow attackers to:**
- ❌ Read/Write to your Firestore database
- ❌ Upload files to Firebase Storage
- ❌ Send push notifications to your users
- ❌ Rack up Firebase billing costs
- ❌ Access user authentication data

**Cost of a breach:**
- Firebase free tier exhausted immediately
- Potential $1000s in unexpected charges
- User data compromised
- App reputation damaged

## 🚀 Quick Fix (DO THIS NOW)

```powershell
# Run these commands immediately:

# 1. Regenerate Firebase config with NEW keys
cd C:\Users\hisham\Desktop\Dev\Projects\Flutter_Otlob\flutter_application_1
dart pub global run flutterfire_cli:flutterfire configure --project=otlob-app-98371 --out=lib/firebase_options.dart --yes

# 2. Verify .gitignore is working
git status
# Should NOT show firebase_options.dart as changed

# 3. Restrict API keys in Google Cloud Console
# Go to: https://console.cloud.google.com/apis/credentials?project=otlob-app-98371
# For EACH key: Set Application restrictions + API restrictions

# 4. Enable App Check
# Go to: https://console.firebase.google.com/project/otlob-app-98371/appcheck
# Click "Register" for your Android app

# 5. Monitor usage
# Go to: https://console.firebase.google.com/project/otlob-app-98371/usage
# Check for any unusual spikes
```

## 📊 Verification Checklist

- [ ] `.gitignore` updated with Firebase files
- [ ] Files removed from Git tracking
- [ ] New Firebase config generated
- [ ] API keys restricted in Google Cloud Console
- [ ] App Check enabled
- [ ] GitHub secret scanning alert dismissed
- [ ] Firebase usage monitored for anomalies
- [ ] Team notified about security incident

## 🔗 Important Links

- **GitHub Security Alerts:** https://github.com/Cyphyr0/Otlob_App/security/secret-scanning
- **Google Cloud Credentials:** https://console.cloud.google.com/apis/credentials?project=otlob-app-98371
- **Firebase Console:** https://console.firebase.google.com/project/otlob-app-98371
- **Firebase App Check:** https://console.firebase.google.com/project/otlob-app-98371/appcheck

## 📞 If You Need Help

This is a CRITICAL security issue. If unsure:
1. Don't panic
2. Follow the "Quick Fix" section above
3. Restrict API keys IMMEDIATELY
4. Enable App Check
5. Monitor Firebase usage for next 24 hours

---

**Remember:** API keys in Git history stay there forever unless actively removed. Even if you delete the repo, forks and clones still have them!
