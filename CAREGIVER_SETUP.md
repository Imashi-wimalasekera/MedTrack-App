# MedTrack Caregiver System - Complete Setup Guide

## 📋 Overview

MedTrack now includes a comprehensive **Caregiver Management System** with Firebase integration, real-time notifications, and role-based access control. Caregivers can monitor multiple patients' medication adherence and receive alerts for missed doses.

## 🎯 Features Implemented

### 1. **Caregiver Dashboard**
- **Profile Section**: Displays caregiver name, email, and linked patients
- **Patient Selector Dropdown**: Quick switch between monitored patients
- **Missed Dose Alerts**: Real-time notifications with patient name, medicine, and time
- **Today's Summary**: Cards showing Taken, Skipped, and Upcoming medication counts
- **Weekly Adherence Chart**: 7-day bar graph visualization
- **Refill Alerts**: Stock level warnings
- **Quick Actions**: Buttons for adding notes and viewing history
- **Navigation**: Bottom nav bar for accessing all caregiver features

### 2. **Patient Management**
- **Patient List Page**: View all linked patients with age, last medication time, and adherence %
- **Patient Details Page**: Individual patient medication schedule and statistics
- **Real-time Data**: Fetches from Firestore in real-time

### 3. **Medication Monitoring**
- **Medication History**: Organized by date with status indicators (Taken/Skipped)
- **Upcoming Doses Timeline**: Shows scheduled times and current status
- **Delay Tracking**: Records how late medications were taken
- **Status Filtering**: Color-coded indicators for quick recognition

> **Note**: Notifications and tracking features (FCM, local notifications, "Taken"/"Missed" logging) are handled by Member 3's implementation and integrate with the caregiver dashboard.

### 4. **Caregiver Notes**
- **Add Notes**: Create notes visible on patient's home page
- **Note History**: Timestamped notes with caregiver information
- **Delete Option**: Remove outdated notes
- **Patient Context**: Each note is linked to a specific patient

### 5. **Role-Based Navigation**
- **Automatic Routing**: Users with "Caregiver" role → Caregiver Dashboard
- **Fallback**: Default users → User Dashboard (coming soon)
- **Firebase Storage**: Roles stored in Firestore user documents

## 🔧 Technical Implementation

### New Files Created

```
frontend/lib/
├── pages/
│   ├── caregiver/
│   │   ├── caregiver_dashboard.dart       # Main dashboard
│   │   ├── patient_list.dart              # Patient list view
│   │   ├── patient_details.dart           # Patient details page
│   │   ├── medication_history.dart        # Medication logs
│   │   └── caregiver_notes.dart           # Notes management
├── services/
│   └── firebase_service.dart              # Firestore queries & operations
├── role_based_navigator.dart              # Route based on user role
├── firestore_structure.dart               # Database schema documentation
└── main.dart                              # Updated with RoleBasedNavigator
```

> **Note**: Notification system (FCM, local notifications, tracking) is implemented by Member 3

### Firestore Database Structure

```
Users/{userId}
  ├── email: string
  ├── displayName: string
  ├── role: "User" | "Caregiver"
  ├── age: number
  ├── createdAt: timestamp
  ├── linkedCaregivers: array
  ├── adherencePercentage: number
  └── lastMedicationTime: string
  │
  ├── Medications/{medId}/
  │   ├── name: string
  │   ├── dosage: string
  │   ├── time: array
  │   ├── frequency: string
  │   └── stockCount: number
  │
  ├── MedicationLogs/{logId}/
  │   ├── medicineName: string
  │   ├── status: "Taken" | "Skipped" | "Pending"
  │   ├── timestamp: timestamp
  │   └── delayMinutes: number
  │
  └── CaregiverNotes/{noteId}/
      ├── text: string
      ├── timestamp: timestamp
      └── caregiverName: string

Caregivers/{caregiverId}
  ├── email: string
  ├── displayName: string
  ├── linkedPatients: array
  ├── createdAt: timestamp
  └── phone: string
```

> **Note**: Notification preferences, notification tracking, and FCM implementation are handled by Member 3's notification system.

## 🚀 Getting Started

### 1. Update pubspec.yaml
Ensure these dependencies are present:
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^0.13.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  google_sign_in: ^6.0.0
  sign_in_with_apple: ^5.0.0
  flutter_svg: ^2.0.0
```

### 2. Configure Firestore Rules
Set up appropriate Firestore security rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /Users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read: if request.auth.uid in resource.data.linkedCaregivers;
    }
    
    // Caregivers collection
    match /Caregivers/{caregiverId} {
      allow read, write: if request.auth.uid == caregiverId;
    }
    
    // Notifications collection
    match /Notifications/{notificationId} {
      allow create: if request.auth != null;
      allow read: if request.auth.uid == resource.data.caregiverId;
    }
  }
}
```

### 3. Running the App
```bash
cd frontend
flutter pub get
flutter run
```

## 📱 User Flows

### Caregiver Sign-Up Flow
1. User selects "Caregiver" in role dropdown
2. Account created with `role: "Caregiver"` in Firestore
3. Caregiver Dashboard appears on login

### Adding a Patient Link
1. Caregiver provides patient ID or email
2. System links caregiver to patient's `linkedCaregivers` array
3. Caregiver sees patient in linked patients list

### Monitoring Medication
1. Caregiver selects patient from dropdown
2. Dashboard updates with patient's real-time data
3. Dashboard displays medication history and adherence data
4. Weekly chart shows adherence trends

> **Note**: Real-time alerts and notifications are handled by Member 3's notification system

### Setting Notifications
> **Note**: Notification features (local notifications, FCM, scheduling, tracking) are implemented by Member 3. This integrates with caregiver dashboard to display patient data.

## 🔔 Integration with Member 3's Notification System

The caregiver dashboard reads medication logs and status data created by Member 3's notification & tracking system:

**Member 3 Handles:**
- ⏰ Scheduling local notifications for medicine times
- 📱 Firebase Cloud Messaging for cross-device reminders
- ✅ Tracking medication intake (logging "Taken"/"Missed")
- 🔔 Sending caregiver notifications when doses are missed

**Caregiver Dashboard Displays:**
- 📊 Medication logs from Firestore (created by Member 3's tracking)
- 📈 Adherence statistics calculated from logs
- 📅 Medication history organized by date
- 🔍 Patient status overview

**Data Flow:**
```
User's App (Member 3)
    ↓
Logs "Taken"/"Missed" to Firestore
    ↓
Caregiver Dashboard
    ↓
Reads and displays medication data
```

## 🎨 UI/UX Design

- **Color Scheme**: Teal (#4DB8AC) primary, white backgrounds
- **Cards**: Shadowed containers with rounded corners
- **Status Indicators**: Color-coded (Green=Taken, Red=Skipped, Orange=Upcoming)
- **Charts**: Simple bar graphs for weekly adherence
- **Navigation**: Bottom navigation bar for main sections
- **Responsive**: Optimized for mobile and tablet screens

## 🔐 Security Features

- ✅ Role-based access control
- ✅ Firestore security rules
- ✅ User authentication via Firebase Auth
- ✅ Patient privacy (only linked caregivers can view)
- ✅ Note visibility only to related parties

## 📊 Data Flow

```
User Signs Up with Role "Caregiver"
    ↓
Role saved to Firestore
    ↓
RoleBasedNavigator checks role
    ↓
Routes to CaregiverDashboard
    ↓
Fetches linked patients from Firestore
    ↓
Displays real-time patient data
    ↓
Caregiver can manage notes & view alerts
    ↓
Backend processes notifications
```

## 🛠️ Next Steps

1. **Deploy Cloud Functions** for email/SMS notifications
2. **Create User Dashboard** for regular users
3. **Add Patient Linking UI** for caregivers
4. **Implement Real-time Sync** with Firestore listeners
5. **Add Analytics** for adherence trends
6. **Push Notification Setup** with Firebase Cloud Messaging
7. **Doctor Portal** for viewing patient reports

## 📝 Testing

Test the system with:
1. Create a "Caregiver" user and a "User" patient
2. Link them in Firestore: Add caregiver ID to patient's `linkedCaregivers`
3. Create medication logs for the patient
4. Monitor the caregiver dashboard for real-time updates
5. Test notification preferences and alerts

## 🐛 Troubleshooting

**Issue: Caregiver not seeing patients**
- Verify patient ID exists in Firestore
- Check `linkedPatients` array in caregiver doc

**Issue: Real-time data not updating**
- Ensure Firestore security rules allow reads
- Check console for Firestore errors

**Issue: Notifications not sending**
- Verify notification preferences are enabled
- Check backend Cloud Functions deployment

## 📚 Documentation

- See `firestore_structure.dart` for database schema
- See `firebase_service.dart` for API methods
- See `notification_service.dart` for notification handling

---

**MedTrack v2.0 - Caregiver System Ready!** 🎉
