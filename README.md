# MedTrack App

A Flutter-based medication reminder and tracking application for patients and caregivers.

## Features

### User Management
- User registration & login (Firebase Auth)
- Caregiver linking (optional)
- Role-based access (Patient/Caregiver)

### Medication Management
- Add, edit, delete medications
- Store dosage, frequency, and schedule
- Medication stock tracking
- Refill alerts when stock is low

### Reminders & Notifications
- Push notifications for medicine time
- Missed-dose reminders
- Caregiver notifications for linked patients

### Tracking & Logs
- Mark medicine as Taken or Missed
- Complete medication history
- Date-range based log filtering
- All logs stored in Firestore

### Caregiver Mode
- Link to multiple patients
- Receive missed-dose alerts
- View patient logs (read-only)
- Monitor medication adherence

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── medication_model.dart
│   └── medication_log_model.dart
├── services/
│   ├── auth_service.dart
│   ├── medication_service.dart
│   ├── medication_log_service.dart
│   └── notification_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── medication_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── medication/
│   │   ├── add_medication_screen.dart
│   │   └── medication_list_screen.dart
│   ├── logs/
│   │   └── medication_logs_screen.dart
│   └── caregiver/
│       └── caregiver_dashboard_screen.dart
├── widgets/
│   ├── medication_card.dart
│   └── log_list_item.dart
└── utils/
    ├── constants.dart
    └── validators.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase account
- Android Studio / VS Code

### Firebase Setup
1. Create a new Firebase project
2. Add Android and/or iOS apps to your Firebase project
3. Download and add configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
4. Enable Firebase Authentication (Email/Password)
5. Create Firestore database
6. Enable Firebase Cloud Messaging

### Installation
1. Clone the repository
```bash
git clone https://github.com/Imashi-wimalasekera/MedTrack-App.git
cd MedTrack-App
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```


## License

This project is for educational purposes.
