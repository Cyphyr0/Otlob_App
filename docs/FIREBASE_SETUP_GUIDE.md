# Firebase Setup Guide for Otlob App

## Prerequisites
- ✅ FlutterFire CLI installed
- ⚠️ Need: Firebase account (free)
- ⚠️ Need: Firebase CLI installed

## Step-by-Step Setup

### Step 1: Install Firebase CLI

**Option A: Using npm (Recommended)**
```powershell
npm install -g firebase-tools
```

**Option B: Using standalone installer**
Download from: https://firebase.google.com/docs/cli#install-cli-windows

### Step 2: Login to Firebase
```powershell
firebase login
```
- This will open your browser
- Login with your Google account
- Authorize Firebase CLI

### Step 3: Configure Firebase for Flutter

Run this command in your project directory:
```powershell
cd c:\Users\hisham\Desktop\Dev\Projects\Flutter_Otlob
flutterfire configure
```

**What this does:**
1. Creates a new Firebase project (or selects existing one)
2. Registers your Android/iOS/Web apps
3. Downloads configuration files
4. Creates `firebase_options.dart` automatically
5. Sets up all required Firebase services

**Interactive prompts you'll see:**
```
? Select a Firebase project to configure your Flutter application with:
  > Create a new project
    my-existing-project
    
? What platforms should your configuration support?
  ✓ Android
  ✓ iOS
  ✓ Web
  
? Which Firebase services do you want to use?
  ✓ Authentication
  ✓ Firestore
  ✓ Storage
  ✓ Analytics
  ✓ Crashlytics
  ✓ Messaging
```

### Step 4: Initialize Firebase in App

The app code is already prepared! Just need to uncomment/add initialization in `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

### Step 5: Enable Firebase Services in Console

Go to Firebase Console: https://console.firebase.google.com

#### A. Enable Authentication
1. Click "Authentication" in left menu
2. Click "Get Started"
3. Enable these sign-in methods:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Phone (for OTP)

#### B. Create Firestore Database
1. Click "Firestore Database"
2. Click "Create Database"
3. Select "Start in test mode" (for development)
4. Choose location: `eur3` (Europe) or nearest to Egypt

#### C. Enable Storage
1. Click "Storage"
2. Click "Get Started"
3. Start in test mode

#### D. Enable Analytics & Crashlytics
- Already enabled by default when you configure

### Step 6: Set Up Firestore Rules (Development)

In Firebase Console > Firestore Database > Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow all authenticated users to read restaurants
    match /restaurants/{restaurantId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins can write
    }
    
    // Allow users to manage their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
                           request.resource.data.userId == request.auth.uid;
    }
    
    // Tawseya votes
    match /votes/{voteId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
                              resource.data.userId == request.auth.uid;
    }
  }
}
```

### Step 7: Add Test Data to Firestore

In Firestore Console, create these collections manually:

#### `restaurants` collection:
```json
{
  "id": "mama-kitchen-001",
  "name": "Mama's Kitchen",
  "cuisine": "Egyptian",
  "rating": 4.8,
  "tawseyaCount": 25,
  "imageUrl": "https://example.com/mamas_kitchen.jpg",
  "description": "Authentic home-cooked Egyptian meals with fresh ingredients.",
  "address": "Downtown Cairo",
  "isOpen": true,
  "distance": 2.5,
  "priceLevel": 2,
  "menu": {
    "Appetizers": [
      {
        "name": "Hummus",
        "price": 5.0,
        "imageUrl": ""
      },
      {
        "name": "Falafel",
        "price": 4.0,
        "imageUrl": ""
      }
    ]
  }
}
```

### Step 8: Test the App

Run the app after Firebase initialization:
```powershell
flutter run -d emulator-5556
```

**What should work:**
- ✅ User registration/login
- ✅ Google sign-in
- ✅ Restaurant data loading from Firestore
- ✅ User profile creation
- ✅ Order placement

## Troubleshooting

### Issue: "No Firebase App has been created"
**Solution:** Make sure `Firebase.initializeApp()` is called before `runApp()`

### Issue: "google-services.json not found"
**Solution:** Run `flutterfire configure` again

### Issue: "Permission denied" on Firestore
**Solution:** Check Firestore rules, make sure user is authenticated

### Issue: Build fails after adding Firebase
**Solution:** 
```powershell
flutter clean
flutter pub get
flutter run
```

## Security Notes

⚠️ **Important:** The test mode rules are INSECURE for production!

Before deploying to production:
1. Update Firestore rules to require authentication
2. Add proper validation
3. Implement admin role checks
4. Enable App Check
5. Review Firebase Security Checklist

## Next Steps After Firebase Setup

1. ✅ Replace mock restaurant data with Firestore queries
2. ✅ Implement user authentication flow
3. ✅ Add real order placement
4. ✅ Set up push notifications
5. ✅ Integrate payment gateway (Paymob)
6. ✅ Add image upload for user profiles
7. ✅ Implement Tawseya voting system

## Useful Links

- Firebase Console: https://console.firebase.google.com
- FlutterFire Documentation: https://firebase.flutter.dev
- Firebase Pricing: https://firebase.google.com/pricing (Free tier is generous!)

## Cost Estimate

For development/MVP:
- ✅ **FREE** - Firebase Spark Plan includes:
  - Authentication: Unlimited free
  - Firestore: 50K reads/day, 20K writes/day
  - Storage: 1GB
  - Hosting: 10GB/month
  - Analytics: Unlimited

This is more than enough for 100-500 daily active users!

---

Last Updated: October 4, 2025
