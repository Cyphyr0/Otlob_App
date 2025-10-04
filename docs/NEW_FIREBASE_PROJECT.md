# 🎉 Fresh Firebase Project Setup

**Date:** October 4, 2025  
**Status:** ✅ Clean slate - No compromised keys!

## 🆕 New Firebase Project

- **Project Name:** otlob
- **Project ID:** `otlob-6e081`
- **Project Number:** 450554002301
- **Console:** https://console.firebase.google.com/project/otlob-6e081

## ✅ Configured Apps

### Android
- **Package:** com.example.flutter_application_1
- **App ID:** 1:450554002301:android:f6519685f1b9e7b11eea14
- **SHA-1:** `EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE`
- **SHA-256:** `78:A3:8B:E3:44:0D:AB:C6:4A:4A:BE:18:18:5D:69:94:E9:76:6B:3D:7F:B4:31:4C:9C:B2:56:0E:3B:6C:9E:BF`

### iOS
- **Bundle ID:** com.example.flutterApplication1
- **App ID:** 1:450554002301:ios:056a08ab07e29dad1eea14

### Web
- **App ID:** 1:450554002301:web:6d757c22f7d8bfd21eea14

### Windows
- **App ID:** 1:450554002301:web:55a2543486c1b96d1eea14

## 🔐 Security Status

- ✅ Brand new API keys (never exposed)
- ✅ `firebase_options.dart` in `.gitignore`
- ✅ `google-services.json` in `.gitignore`
- ✅ No keys in Git history
- ✅ Clean repository

## 📋 Next Steps - Enable Firebase Services

### 1. Authentication (5 min)
**Go to:** https://console.firebase.google.com/project/otlob-6e081/authentication/providers

1. Click **Get Started**
2. Enable **Email/Password**
3. Enable **Google Sign-in**
   - Support email: `getotlob@gmail.com`
   - Add SHA-1 in Project Settings: `EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE`
4. Enable **Phone** (for OTP)

### 2. Firestore Database (5 min)
**Go to:** https://console.firebase.google.com/project/otlob-6e081/firestore

1. Click **Create Database**
2. Choose **Start in test mode**
3. Select location: **eur3** (Europe - closest to Egypt)

**Test Mode Rules (expires Nov 4, 2025):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 11, 4);
    }
  }
}
```

### 3. Firebase Storage (5 min)
**Go to:** https://console.firebase.google.com/project/otlob-6e081/storage

1. Click **Get Started**
2. Choose **Start in test mode**
3. Use same location as Firestore

### 4. Restrict API Keys (IMPORTANT!)
**Go to:** https://console.cloud.google.com/apis/credentials?project=otlob-6e081

For **Android key:**
1. Click the key name
2. **Application restrictions:**
   - Select "Android apps"
   - Package: `com.example.flutter_application_1`
   - SHA-1: `EB:BB:D2:D9:E9:56:93:AE:61:68:12:EC:90:E0:A2:93:78:B5:41:BE`
3. **API restrictions:**
   - Restrict to:
     - Firebase Installations API
     - Cloud Firestore API
     - Firebase Cloud Messaging API
     - Identity Toolkit API
     - Token Service API
4. Click **Save**

Repeat for iOS and Web keys with appropriate restrictions.

## 🗂️ Test Data Structure

### Collection: `restaurants`
```json
{
  "id": "rest_001",
  "name": "Kazouza",
  "description": "Premium Egyptian koshari",
  "imageUrl": "https://placeholder.com/restaurant.jpg",
  "rating": 4.8,
  "deliveryTime": "30-40 min",
  "deliveryFee": 15.0,
  "minimumOrder": 50.0,
  "categories": ["Egyptian", "Koshari"],
  "isOpen": true,
  "location": {
    "lat": 30.0444,
    "lng": 31.2357,
    "address": "Downtown Cairo"
  },
  "menuItems": [
    {
      "id": "item_001",
      "name": "Koshari Large",
      "description": "Traditional Egyptian street food",
      "price": 45.0,
      "imageUrl": "https://placeholder.com/koshari.jpg",
      "category": "Main Course",
      "isAvailable": true
    }
  ]
}
```

### Collection: `users`
```json
{
  "uid": "<firebase_auth_uid>",
  "name": "Ahmed Hassan",
  "email": "user@example.com",
  "phone": "+201234567890",
  "profileImageUrl": "",
  "addresses": [
    {
      "id": "addr_001",
      "title": "Home",
      "street": "Tahrir Street",
      "building": "Building 5",
      "floor": "3",
      "apartment": "12",
      "district": "Downtown",
      "city": "Cairo",
      "governorate": "Cairo",
      "coordinates": {
        "lat": 30.0444,
        "lng": 31.2357
      },
      "isDefault": true
    }
  ],
  "favorites": [],
  "createdAt": {"_seconds": 1728057600}
}
```

### Collection: `orders`
```json
{
  "orderId": "ORD_20251004_001",
  "userId": "<firebase_auth_uid>",
  "restaurantId": "rest_001",
  "restaurantName": "Kazouza",
  "status": "pending",
  "items": [
    {
      "menuItemId": "item_001",
      "name": "Koshari Large",
      "quantity": 2,
      "price": 45.0,
      "subtotal": 90.0
    }
  ],
  "subtotal": 90.0,
  "deliveryFee": 15.0,
  "total": 105.0,
  "paymentMethod": "cash",
  "deliveryAddress": {},
  "createdAt": {"_seconds": 1728057600},
  "estimatedDeliveryTime": {"_seconds": 1728060300}
}
```

## ✅ Verification Checklist

- [x] New Firebase project created (otlob-6e081)
- [x] FlutterFire configured
- [x] firebase_options.dart generated
- [x] SHA-1 fingerprint obtained
- [x] Code analyzed (no errors)
- [x] firebase_options.dart in .gitignore
- [ ] Authentication enabled
- [ ] Firestore database created
- [ ] Storage enabled
- [ ] API keys restricted
- [ ] Test data added
- [ ] App tested with real Firebase

## 🚀 Quick Commands

```powershell
# Check Firebase login
firebase login:list

# List all projects
firebase projects:list

# Reconfigure if needed
dart pub global run flutterfire_cli:flutterfire configure --project=otlob-6e081

# Run app
flutter run

# Build release
flutter build apk --release
```

## 📧 Contact Email

**Support Email:** getotlob@gmail.com

## 🔗 Important Links

- **Firebase Console:** https://console.firebase.google.com/project/otlob-6e081
- **Google Cloud Console:** https://console.cloud.google.com/apis/credentials?project=otlob-6e081
- **Authentication:** https://console.firebase.google.com/project/otlob-6e081/authentication
- **Firestore:** https://console.firebase.google.com/project/otlob-6e081/firestore
- **Storage:** https://console.firebase.google.com/project/otlob-6e081/storage

---

**Status:** Ready to enable services and start development! 🎊
