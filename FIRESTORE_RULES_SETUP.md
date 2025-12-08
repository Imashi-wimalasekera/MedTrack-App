# Firestore Security Rules Setup Guide

## 🔴 **Permission Denied Error - How to Fix**

The error `[cloud_firestore/permission-denied] Missing or insufficient permissions` occurs when your Firestore security rules don't allow reads on the Users collection.

## ✅ **Solution: Deploy Firestore Rules**

### **Step 1: Install Firebase CLI**
```bash
npm install -g firebase-tools
```

### **Step 2: Initialize Firebase in Project**
```bash
firebase init firestore
```

When prompted:
- Select your Firebase project
- Keep default locations or specify custom paths
- Accept overwriting existing rules

### **Step 3: Update firestore.rules**

Copy the contents of `firestore.rules` from your project root to your Firebase local config:

```bash
# If you have Firebase set up locally
cp firestore.rules path-to-firebase-project/firestore.rules
```

### **Step 4: Deploy Rules via Console (Easiest)**

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database** → **Rules**
4. Click **Edit rules**
5. Replace the entire content with the rules below
6. Click **Publish**

### **Step 5: Apply These Rules**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow authenticated users to read their own user document
    match /Users/{userId} {
      allow create: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      
      // Caregivers can read patient data if linked
      allow read: if request.auth != null && 
                     exists(/databases/$(database)/documents/Users/$(request.auth.uid)) &&
                     request.auth.uid in get(/databases/$(database)/documents/Users/$(resource.id)).data.linkedCaregivers;
      
      // Subcollections
      match /Medications/{document=**} {
        allow read, write: if request.auth.uid == userId;
        allow read: if request.auth != null && request.auth.uid in get(/databases/$(database)/documents/Users/$(userId)).data.linkedCaregivers;
      }
      
      match /MedicationLogs/{document=**} {
        allow read, write: if request.auth.uid == userId;
        allow read: if request.auth != null && request.auth.uid in get(/databases/$(database)/documents/Users/$(userId)).data.linkedCaregivers;
      }
      
      match /CaregiverNotes/{document=**} {
        allow create, read, write: if request.auth != null;
      }
    }
    
    // Caregivers collection
    match /Caregivers/{caregiverId} {
      allow create: if request.auth != null && request.auth.uid == caregiverId;
      allow read, write: if request.auth != null && request.auth.uid == caregiverId;
    }
    
    // Notifications collection
    match /Notifications/{notificationId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null && request.auth.uid == resource.data.caregiverId;
    }
  }
}
```

## 🚀 **Deploy via Firebase CLI**

If you have Firebase installed locally:

```bash
# Navigate to your firebase project directory
cd path-to-your-firebase-project

# Deploy only Firestore rules
firebase deploy --only firestore:rules

# Or deploy everything
firebase deploy
```

## ✨ **After Deployment**

1. **Restart your Flutter app** (full restart, not just hot reload)
2. **Try logging in again**
3. You should now see the caregiver dashboard or user dashboard
4. No more permission denied errors!

## 🔍 **Verify Rules Were Applied**

1. Go to Firebase Console
2. Navigate to **Firestore Database** → **Rules**
3. You should see the new rules (not the default "match everything")

## 📋 **What These Rules Do**

| Action | Who | Where | Condition |
|--------|-----|-------|-----------|
| Create User doc | Anyone | Their own doc | `auth.uid == userId` |
| Read User doc | Owner | Their doc | `auth.uid == userId` |
| Read User doc | Caregiver | Linked patient's doc | `auth.uid in linkedCaregivers` |
| Write User doc | Owner | Their doc | `auth.uid == userId` |
| Read/Write Medications | Owner | Their meds | `auth.uid == userId` |
| Read Medications | Caregiver | Linked patient's meds | In `linkedCaregivers` array |
| Read/Write Caregivers | Owner | Their doc | `auth.uid == caregiverId` |

## ⚠️ **If You Still Get Permission Denied**

1. **Check your Firebase project ID** is correct in `firebase_options.dart`
2. **Verify the user is authenticated** (check Firebase Console → Authentication)
3. **Check the Users collection exists** in Firestore
4. **Double-check the rules were published** (not just saved as draft)

## 🛠️ **Temporary Fix (Development Only)**

If you need temporary access during development, use these permissive rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

⚠️ **DO NOT USE IN PRODUCTION** - This allows anyone authenticated to read/write everything!

## 📞 **Still Having Issues?**

1. Check [Firebase Documentation](https://firebase.google.com/docs/firestore/security/start)
2. Verify your project is on **Blaze plan** (required for most functions)
3. Check Firebase Console for error logs in **Firestore** section
4. Restart your development environment completely

---

**After applying these rules, your permission error should be resolved!** ✅
