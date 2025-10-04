# 🔐 Anonymous Sign-in Implementation Guide

**Date:** October 4, 2025  
**Context:** Understanding Anonymous Authentication for Otlob App

---

## 📖 What is Anonymous Sign-in?

**Anonymous Authentication** allows users to use your app **without creating an account**. It's like a "guest mode" that provides:

✅ **Temporary user ID** - Firebase creates a unique user ID  
✅ **No credentials required** - No email, phone, or password  
✅ **Full Firebase access** - Can use Firestore, Storage, etc.  
✅ **Upgradeable** - Can later convert to permanent account  

---

## 🎯 How It Works in Otlob App

### User Flow:

```
User opens app
    ↓
[Continue as Guest] button
    ↓
Anonymous sign-in (instant)
    ↓
Browse restaurants ✅
Add items to cart ✅
Save favorites ✅
    ↓
User tries to checkout
    ↓
"Please sign in to complete your order"
    ↓
[Sign in with Email] or [Sign in with Phone]
    ↓
Link anonymous account → Real account
    ↓
Order placed ✅
```

---

## ✅ Benefits

### For Users:
- **Instant access** - No signup friction
- **Try before commit** - Explore the app first
- **Easy upgrade** - Data preserved when they sign in

### For Your Business:
- **Higher conversion** - More users try the app
- **Data collection** - Track anonymous user behavior
- **Gradual onboarding** - Ask for credentials only when needed

---

## 🔒 Limitations

### What Anonymous Users **CAN** Do:
✅ Browse restaurants  
✅ View menus and details  
✅ Add items to cart  
✅ Save favorites  
✅ View their cart  

### What Anonymous Users **CANNOT** Do:
❌ Place orders (needs delivery address & payment)  
❌ View order history  
❌ Save delivery addresses  
❌ Use payment methods  
❌ Track orders  
❌ Contact support with account  

---

## 🛠️ Implementation Strategy

### Step 1: Enable Anonymous Auth in Firebase

**Firebase Console:**
1. Go to: https://console.firebase.google.com/project/otlob-6e081/authentication/providers
2. Click **"Anonymous"**
3. Toggle **"Enable"**
4. Click **"Save"**

**Takes:** 30 seconds ⏱️

---

### Step 2: Add Anonymous Sign-in to Code

**A. Update Repository Interface**

`lib/features/auth/domain/repositories/auth_repository.dart`:
```dart
abstract class AuthRepository {
  Future<void> sendOTP(String phoneNumber);
  Future<User> verifyOTP(String otp, String phoneNumber);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithApple();
  Future<User> signInAnonymously(); // ✨ NEW
  Future<User> linkEmailPassword(String email, String password); // ✨ NEW
  Future<User> linkPhone(String phoneNumber); // ✨ NEW
  Future<void> logout();
  User? getCurrentUser();
  Future<void> saveUser(User user);
}
```

**B. Update Data Source**

`lib/features/auth/data/datasources/firebase_auth_datasource.dart`:
```dart
Future<User> signInAnonymously() async {
  try {
    final credential = await _auth.signInAnonymously();
    final firebaseUser = credential.user!;
    
    return User(
      id: firebaseUser.uid,
      email: '', // No email for anonymous
      name: 'Guest', // Default name
      createdAt: DateTime.now(),
      isVerified: false,
      isAnonymous: true, // ✨ Need to add this field to User entity
    );
  } catch (e) {
    throw Exception('Anonymous sign-in failed: $e');
  }
}

Future<User> linkEmailPassword(String email, String password) async {
  try {
    final currentUser = _auth.currentUser;
    if (currentUser == null || !currentUser.isAnonymous) {
      throw Exception('No anonymous user to link');
    }
    
    // Link anonymous account to email/password
    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    
    final linkedCredential = await currentUser.linkWithCredential(credential);
    final linkedUser = linkedCredential.user!;
    
    return User(
      id: linkedUser.uid, // Same ID, now permanent
      email: email,
      name: linkedUser.displayName ?? 'User',
      createdAt: DateTime.now(),
      isVerified: linkedUser.emailVerified,
      isAnonymous: false, // No longer anonymous
    );
  } catch (e) {
    throw Exception('Account linking failed: $e');
  }
}
```

**C. Update Repository Implementation**

`lib/features/auth/data/repositories/firebase_auth_repository.dart`:
```dart
@override
Future<User> signInAnonymously() async {
  try {
    final user = await _dataSource.signInAnonymously();
    await saveUser(user);
    return user;
  } catch (e) {
    throw AuthFailure(message: 'Anonymous sign-in failed: $e');
  }
}

@override
Future<User> linkEmailPassword(String email, String password) async {
  try {
    final user = await _dataSource.linkEmailPassword(email, password);
    await saveUser(user); // Update local data
    return user;
  } catch (e) {
    throw AuthFailure(message: 'Account linking failed: $e');
  }
}
```

**D. Update User Entity**

`lib/features/auth/domain/entities/user.dart`:
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final bool isVerified;
  final bool isAnonymous; // ✨ NEW

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    this.isVerified = false,
    this.isAnonymous = false, // ✨ NEW - default to false
  });
  
  // Update toJson and fromJson to include isAnonymous
}
```

**E. Update Auth Provider**

`lib/features/auth/presentation/providers/auth_provider.dart`:
```dart
Future<void> signInAnonymously() async {
  state = const AsyncValue.loading();
  try {
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.signInAnonymously();
    await SharedPrefsHelper.setAuthenticated(true);
    state = AsyncValue.data(user);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}

Future<void> linkAccountWithEmail(String email, String password) async {
  state = const AsyncValue.loading();
  try {
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.linkEmailPassword(email, password);
    state = AsyncValue.data(user);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}
```

---

### Step 3: Add UI for Anonymous Sign-in

**A. Update Login/Signup Screens**

Add a "Continue as Guest" button:

```dart
// In login_screen.dart or signup_screen.dart

TextButton(
  onPressed: () async {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signInAnonymously();
    if (mounted) {
      context.go('/home'); // Go to home as guest
    }
  },
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.person_outline, size: 20),
      SizedBox(width: 8),
      Text('Continue as Guest'),
    ],
  ),
)
```

**B. Add "Sign in to Continue" Dialog**

When anonymous user tries to checkout:

```dart
// In cart_screen.dart or checkout flow

Future<void> _handleCheckout() async {
  final user = ref.read(authProvider).value;
  
  if (user?.isAnonymous ?? false) {
    // Show dialog to sign in
    final shouldSignIn = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign in Required'),
        content: Text(
          'Please sign in with your email or phone number to complete your order and track delivery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sign In'),
          ),
        ],
      ),
    );
    
    if (shouldSignIn == true && mounted) {
      // Go to login screen, but preserve cart data
      context.push('/login?returnTo=/checkout');
    }
  } else {
    // User is signed in, proceed with checkout
    _proceedToCheckout();
  }
}
```

**C. Add Account Linking Flow**

After user signs in from anonymous state:

```dart
// In login process, after email/password entered

Future<void> _loginAndLinkAccount(String email, String password) async {
  final authNotifier = ref.read(authProvider.notifier);
  final currentUser = ref.read(authProvider).value;
  
  if (currentUser?.isAnonymous ?? false) {
    // Link anonymous account to email
    await authNotifier.linkAccountWithEmail(email, password);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created! Your cart has been preserved.'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/checkout'); // Return to checkout
    }
  } else {
    // Normal login
    await authNotifier.loginWithEmail(email, password);
    if (mounted) {
      context.go('/home');
    }
  }
}
```

---

## 🎨 UI/UX Best Practices

### 1. **Make it Obvious**
```
┌─────────────────────────────┐
│  Sign in with Google        │  ← Primary
├─────────────────────────────┤
│  Sign in with Email         │
├─────────────────────────────┤
│  Sign in with Phone         │
├─────────────────────────────┤
│                             │
│  [ Continue as Guest ]      │  ← Secondary, subtle
└─────────────────────────────┘
```

### 2. **Set Expectations**
```
"Browse and explore without signing up.
You'll need to sign in to place orders."
```

### 3. **Prompt at Right Time**
Don't interrupt until user needs authenticated features:
- ✅ Prompt when adding to cart: NO (let them browse)
- ✅ Prompt when checking out: YES (need delivery info)
- ✅ Prompt when saving favorites: OPTIONAL (suggest but don't force)

### 4. **Preserve Data**
When converting anonymous → real account:
- Keep cart items ✅
- Keep favorites ✅
- Keep browsing history ✅

---

## 🔐 Security Considerations

### Firebase Rules for Anonymous Users

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Anonymous users can read restaurants (public data)
    match /restaurants/{restaurantId} {
      allow read: if true; // Public
      allow write: if false; // Only admins
    }
    
    // Anonymous users can read/write their own cart (temporary)
    match /carts/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Works for both anonymous and authenticated users
    }
    
    // Only authenticated (non-anonymous) users can create orders
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                     request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
                       !request.auth.token.firebase.sign_in_provider == 'anonymous';
      // ⬆️ This blocks anonymous users from creating orders
    }
    
    // User profiles - only for non-anonymous
    match /users/{userId} {
      allow read, write: if request.auth != null && 
                            request.auth.uid == userId &&
                            !request.auth.token.firebase.sign_in_provider == 'anonymous';
    }
  }
}
```

### Storage Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Public images (restaurants, menu items)
    match /public/{allPaths=**} {
      allow read: if true;
      allow write: if false; // Only admins via backend
    }
    
    // User uploads (profile pics, etc.) - no anonymous
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && 
                      request.auth.uid == userId &&
                      !request.auth.token.firebase.sign_in_provider == 'anonymous';
    }
  }
}
```

---

## 📊 Data Flow

### Anonymous User Session:
```
1. User opens app
2. signInAnonymously() → Firebase creates temp UID
3. Store UID locally (SharedPrefs)
4. User browses, adds to cart
5. Cart data saved to Firestore: /carts/{anonymousUID}
6. User clicks "Checkout"
7. Prompt: "Sign in to continue"
8. User enters email/password
9. linkWithCredential() → Anonymous UID becomes permanent
10. Cart data preserved (same UID)
11. Order created with real user account
```

### Data Persistence:
```
Before linking:
carts/anon_abc123 → { items: [...], userId: 'anon_abc123' }

After linking:
carts/anon_abc123 → { items: [...], userId: 'anon_abc123' }
                    (Same data, same ID, but now user is authenticated)

users/anon_abc123 → { email: 'user@example.com', name: 'John', ... }
                    (New user profile created with same ID)
```

---

## ✅ Checklist

### Firebase Console:
- [ ] Enable Anonymous authentication
- [ ] Update Firestore rules (block orders for anonymous)
- [ ] Update Storage rules (block uploads for anonymous)

### Code Changes:
- [ ] Add `isAnonymous` field to User entity
- [ ] Implement `signInAnonymously()` in data source
- [ ] Implement `linkEmailPassword()` in data source
- [ ] Add methods to repository interface
- [ ] Add methods to auth provider
- [ ] Add "Continue as Guest" button to login/signup
- [ ] Add checkout blocker for anonymous users
- [ ] Add account linking flow
- [ ] Add "Sign in to Continue" dialog
- [ ] Test anonymous → authenticated flow

### Testing:
- [ ] Sign in as guest
- [ ] Browse restaurants
- [ ] Add items to cart
- [ ] Try to checkout (should prompt to sign in)
- [ ] Sign in with email
- [ ] Verify cart preserved
- [ ] Complete order successfully

---

## 🚀 Recommendation

**For Otlob App: YES, enable anonymous sign-in!**

### Why?
1. **Lower barrier to entry** - Users can explore immediately
2. **Common in food delivery** - UberEats, DoorDash do this
3. **Data preserved** - Cart saved when they sign up
4. **Better conversion** - Users try before committing

### When to Prompt Sign-in?
- **Checkout** - Need delivery address
- **Order tracking** - Need account to track
- **Favorites** - Optional, suggest but don't force
- **Payment** - Definitely need authenticated account

---

**Status:** Ready to implement! Enable in Firebase Console first, then add code.

**Time Estimate:** 2-3 hours for full implementation + testing
