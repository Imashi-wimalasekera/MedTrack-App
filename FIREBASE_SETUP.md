.# Firebase Setup Guide for MedTrack

## Part A: Firebase Console Setup (Web Interface)

### Step 1: Create Firebase Project

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Sign in with your Google account

2. **Create New Project**
   - Click "Add project" or "Create a project"
   - Enter project name: **MedTrack** (or your preferred name)
   - Click "Continue"

3. **Google Analytics** (Optional but recommended)
   - Toggle "Enable Google Analytics" ON (recommended for tracking app usage)
   - Click "Continue"
   - Select or create a Google Analytics account
   - Click "Create project"
   - Wait 30-60 seconds for project creation

4. **Project Created!**
   - Click "Continue" when you see "Your new project is ready"

### Step 2: Enable Authentication Methods

1. **Open Authentication**
   - In the left sidebar, click "Build" → "Authentication"
   - Click "Get started" button

2. **Enable Email/Password Authentication**
   - Click on "Sign-in method" tab (top of page)
   - Find "Email/Password" in the list
   - Click on it
   - Toggle **"Enable"** switch to ON
   - Toggle **"Email link (passwordless sign-in)"** to OFF (we'll use password)
   - Click "Save"

3. **Enable Google Authentication**
   - Still in "Sign-in method" tab
   - Find "Google" in the list
   - Click on it
   - Toggle **"Enable"** switch to ON
   - Enter your **Project support email** (your email address)
   - Click "Save"

4. **Enable Apple Authentication** (Optional - for iOS)
   - Find "Apple" in the list
   - Click on it
   - Toggle **"Enable"** switch to ON
   - You'll need Apple Developer account details later
   - For now, just enable it and click "Save"

### Step 3: Set Up Firestore Database

1. **Open Firestore Database**
   - In left sidebar, click "Build" → "Firestore Database"
   - Click "Create database" button

2. **Choose Security Mode**
   - Select **"Start in test mode"** (for development)
   - ⚠️ **Important**: Test mode allows read/write access for 30 days
   - We'll add security rules later
   - Click "Next"

3. **Choose Database Location**
   - Select the region closest to your users
   - Recommended for Sri Lanka: **asia-south1** (Mumbai) or **asia-southeast1** (Singapore)
   - ⚠️ **Important**: You cannot change this later!
   - Click "Enable"
   - Wait 1-2 minutes for database creation

4. **Database Created!**
   - You should see an empty database with "Start collection" button
   - Don't create collections yet - we'll do this through the app

### Step 4: Register Your Apps

#### For Web App:
1. **Add Web App**
   - In Project Overview (top of left sidebar), click the ⚙️ gear icon → "Project settings"
   - Scroll down to "Your apps" section
   - Click the **</>** (web) icon
   - App nickname: **MedTrack Web**
   - ✅ Check "Also set up Firebase Hosting" (optional)
   - Click "Register app"

2. **Copy Configuration**
   - You'll see Firebase SDK configuration
   - **Don't copy this manually** - we'll use FlutterFire CLI to do this automatically
   - Click "Continue to console"

#### For Android App:
1. **Add Android App**
   - In "Your apps" section, click the Android icon
   - Android package name: `com.example.frontend` (or your custom package name)
     - To find yours: Open `android/app/build.gradle` and look for `applicationId`
   - App nickname: **MedTrack Android**
   - Click "Register app"

2. **Download google-services.json**
   - Click "Download google-services.json"
   - Save this file - you'll need it later
   - Click "Next" → "Next" → "Continue to console"

#### For iOS App:
1. **Add iOS App**
   - In "Your apps" section, click the iOS icon
   - iOS bundle ID: `com.example.frontend` (or your custom bundle ID)
     - To find yours: Open `ios/Runner.xcodeproj/project.pbxproj` and search for `PRODUCT_BUNDLE_IDENTIFIER`
   - App nickname: **MedTrack iOS**
   - Click "Register app"

2. **Download GoogleService-Info.plist**
   - Click "Download GoogleService-Info.plist"
   - Save this file - you'll need it later
   - Click "Next" → "Next" → "Continue to console"

### Step 5: Update Firestore Security Rules (Important!)

1. **Open Firestore Rules**
   - Go to "Firestore Database" → "Rules" tab

2. **Replace Default Rules**
   - Delete everything and paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Caregivers can read users they're linked to
    match /caregivers/{caregiverId} {
      allow read, write: if request.auth != null;
    }
    
    // Medications - users can manage their own
    match /medications/{medicationId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

3. **Publish Rules**
   - Click "Publish"
   - These rules ensure users can only access their own data

---

## Part B: Local Development Setup

### Step 1: Install Firebase CLI
1. Install Node.js if you haven't already: https://nodejs.org/
2. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

### Step 2: Login to Firebase
```bash
firebase login
```
- This will open a browser window
- Sign in with the same Google account you used for Firebase Console
- Grant permissions

### Step 3: Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### Step 4: Install Flutter Dependencies
```bash
cd frontend
flutter pub get
```

### Step 5: Configure Firebase for Flutter

**In your frontend directory**, run:
```bash
cd frontend
flutterfire configure
```

**What this does:**
- Scans your Firebase project
- Detects all registered apps
- Generates `lib/firebase_options.dart` with configuration
- Sets up platform-specific files

**Follow the prompts:**
1. Select your Firebase project: **MedTrack** (use arrow keys + Enter)
2. Select platforms to configure:
   - Press **Space** to select: Android, iOS, Web
   - Press **Enter** to confirm
3. Wait for configuration to complete

**Expected output:**
```
✓ Firebase configuration file lib/firebase_options.dart generated successfully
```

### Step 6: Add google-services.json to Android

1. **Locate the file**
   - Find `google-services.json` you downloaded earlier (from Step 4 in Part A)

2. **Copy to Android folder**
   ```bash
   # On Windows (PowerShell)
   Copy-Item "C:\Users\YOUR_USERNAME\Downloads\google-services.json" "android\app\"
   
   # Verify it's there
   dir android\app\google-services.json
   ```

3. **Verify placement**
   - File should be at: `frontend/android/app/google-services.json`
   - NOT in `android/` root directory

### Step 7: Add GoogleService-Info.plist to iOS (Mac only)

**Skip this if you don't have a Mac - iOS setup requires Xcode**

1. **Open iOS project in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Add the plist file**
   - Locate `GoogleService-Info.plist` you downloaded earlier
   - Drag and drop it into Xcode's `Runner` folder (left sidebar)
   - In the dialog that appears:
     - ✅ Check "Copy items if needed"
     - ✅ Make sure "Runner" target is selected
     - Click "Finish"

### Step 8: Verify Firebase Initialization

**Check that main.dart has Firebase initialization:**

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MedTrackApp());
}
```

**This code should already be in your main.dart** ✅

### Step 9: Test Your Setup
**Clean and run the app:**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

**What to test:**
1. App should launch without Firebase errors
2. Click "Get Started" → should navigate to Login page
3. No errors in console about Firebase initialization

**Common errors and fixes:**

❌ **"firebase_options.dart not found"**
- Run `flutterfire configure` again
- Make sure you're in the `frontend` directory

❌ **"DefaultFirebaseOptions not defined"**
- Check that `firebase_options.dart` exists in `lib/`
- Run `flutter clean` and `flutter pub get`

❌ **"google-services.json not found"**
- Make sure file is in `android/app/`
- Check filename is exactly `google-services.json`

---

## Part C: Managing Firebase Console

### Viewing Users (After Authentication Setup)

1. **Go to Authentication**
   - Firebase Console → Authentication → Users tab
   - Here you'll see all registered users
   - Shows: User ID, Email, Sign-in provider, Created date

2. **View User Details**
   - Click on any user to see:
     - UID (unique identifier)
     - Email verification status
     - Sign-in providers linked
     - Last sign-in time
   
3. **Manual User Management**
   - Add user: Click "Add user" button
   - Delete user: Click user → three dots → Delete
   - Disable user: Click user → "Disable account"

### Viewing Firestore Data

1. **Go to Firestore Database**
   - Firebase Console → Firestore Database → Data tab

2. **Browse Collections**
   - You'll see collections like: `users`, `medications`, `caregivers`
   - Click collection name to view documents
   - Click document ID to view/edit fields

3. **Search and Filter**
   - Use search bar at top to find specific documents
   - Click "Start collection" to manually add data

4. **Edit Data Manually**
   - Click on any document
   - Click field value to edit
   - Click "Update" to save changes
   - Use "Delete" to remove documents

### Monitoring Authentication

1. **View Sign-in Methods**
   - Authentication → Sign-in method tab
   - See which methods are enabled
   - View usage statistics

2. **Templates (Email Customization)**
   - Authentication → Templates tab
   - Customize email verification emails
   - Customize password reset emails
   - Edit subject lines and content

3. **Settings**
   - Authentication → Settings tab
   - Authorized domains: Add custom domains
   - User actions: Email verification settings

### Monitoring Database Usage

1. **Usage Tab**
   - Firestore Database → Usage tab
   - See:
     - Document reads/writes
     - Storage used
     - Network bandwidth

2. **Indexes**
   - Firestore Database → Indexes tab
   - See composite indexes
   - Auto-created when you use complex queries

### Understanding Quotas (Free Tier)

**Firestore Free Tier Limits:**
- 50,000 document reads/day
- 20,000 document writes/day
- 20,000 document deletes/day
- 1 GB storage
- 10 GB/month network egress

**Authentication Free Tier:**
- Unlimited users
- Unlimited sign-ins

**What happens if you exceed:**
- App will start throwing errors
- Upgrade to Blaze (pay-as-you-go) plan
- Minimum charge: $0 (only pay for what you use)

### Setting Up Budget Alerts

1. **Go to Firebase Console**
   - Click ⚙️ gear icon → Usage and billing

2. **Set Budget**
   - Click "Details & settings"
   - Click "Set budget alert"
   - Enter amount (e.g., $10)
   - Enter email for alerts
   - Save

---

## Part D: Security Best Practices

### 1. Update Security Rules Before Production

**Current rules are for TESTING ONLY!** They expire in 30 days.

**Production-ready rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is authenticated
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check if user owns the document
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users can only read/write their own profile
    match /users/{userId} {
      allow read: if isSignedIn();
      allow write: if isOwner(userId);
    }
    
    // Medications - user can only access their own
    match /medications/{medicationId} {
      allow read, write: if isSignedIn() && 
        request.auth.uid == resource.data.userId;
    }
    
    // Caregivers can see linked users
    match /caregivers/{caregiverId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update, delete: if isSignedIn() && 
        (request.auth.uid == resource.data.userId || 
         request.auth.uid == resource.data.caregiverId);
    }
  }
}
```

### 2. Enable App Check (Prevent Abuse)

**What it does:** Prevents unauthorized apps from accessing your Firebase

1. Go to Project Settings → App Check
2. Click "Get started"
3. Register your apps
4. Enforce App Check in Firestore rules

### 3. Set Up Email Verification

**Force users to verify email before accessing app:**

```dart
// In your authentication code
if (user != null && !user.emailVerified) {
  await user.sendEmailVerification();
  // Show "Please verify your email" message
}
```

### 4. Monitor Authentication Logs

1. Go to Authentication → Users
2. Check for suspicious activity:
   - Multiple failed login attempts
   - Same IP creating many accounts
   - Unusual sign-in times

---

## Part E: Troubleshooting Common Issues

### Issue 1: "Error: No Firebase project found"
**Solution:**
```bash
firebase login
flutterfire configure
```

### Issue 2: "PlatformException: Google sign-in failed"
**Solution:**
- Check that Google is enabled in Firebase Console
- Verify SHA-1 fingerprint is added (Android)
- Make sure google-services.json is in android/app/

### Issue 3: "Permission denied" in Firestore
**Solution:**
- Check security rules in Firestore Console
- Verify user is authenticated
- Check document path matches security rules

### Issue 4: App Check enforcement blocking requests
**Solution:**
- Go to Firebase Console → App Check
- Temporarily disable enforcement
- Register your debug app token

### Issue 5: "Too many requests" error
**Solution:**
- You've hit rate limits
- Wait a few minutes
- Implement exponential backoff in code

---

## Part F: Next Steps After Setup

### 1. Test Authentication
- Try signing up with email/password
- Try Google sign-in
- Check that users appear in Firebase Console

### 2. Create User Profiles
- After signup, create user document in Firestore
- Store: name, email, role, created date

### 3. Implement Caregiver Linking
- Create `caregivers` collection
- Link caregiver UID to user UID
- Set up permissions

### 4. Add Medication Reminders
- Create `medications` collection
- Store: userId, medicine name, dosage, schedule

---

## Summary Checklist

**Firebase Console (Web):**
- ✅ Created Firebase project
- ✅ Enabled Email/Password authentication  
- ✅ Enabled Google authentication
- ✅ Created Firestore database
- ✅ Updated security rules
- ✅ Registered web/android/ios apps
- ✅ Downloaded google-services.json
- ✅ Downloaded GoogleService-Info.plist

**Local Development:**
- ✅ Installed Firebase CLI
- ✅ Logged into Firebase
- ✅ Installed FlutterFire CLI
- ✅ Ran `flutterfire configure`
- ✅ Added google-services.json to android/app/
- ✅ Verified firebase_options.dart exists
- ✅ App runs without Firebase errors

**Ready for:**
- ✅ Implementing authentication logic
- ✅ Creating user profiles
- ✅ Setting up caregiver management
- ✅ Building medication reminders

## Next Steps for Your Team Member (User & Caregiver Management):
1. Create user profiles in Firestore after signup
2. Implement caregiver linking (one-to-one or one-to-many)
3. Create Firestore collections:
   - `users` - store user profiles
   - `caregivers` - link caregivers to users
   - `medications` - store medicine reminders

## Troubleshooting:
- If Firebase initialization fails, make sure `firebase_options.dart` exists
- For "Duplicate class" errors on Android, check gradle files
- For iOS build errors, run `pod install` in the ios folder
- Clear build: `flutter clean` then `flutter pub get`

## Files Created:
✅ `lib/pages/login_page.dart` - Complete login UI
✅ `lib/landing_page.dart` - Updated with navigation
✅ `pubspec.yaml` - Firebase dependencies added
✅ `lib/main.dart` - Firebase initialization (next step)

## What's Next:
After Firebase setup is complete, I'll help you implement:
1. Sign up page
2. Firebase authentication logic
3. Google/Apple sign-in
4. User profile creation in Firestore
5. Password reset functionality
