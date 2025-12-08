# 🚑 MedTrack – Medicine Reminder & Tracking App

A cross-platform Flutter application designed to help users manage their medication schedules with timely reminders, dosage tracking, refill alerts, and an optional caregiver mode for added safety.

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📱 Features

### 🔔 Medication Reminders
- Schedule reminders for each medicine
- Supports multiple medicines with custom timings
- Push notifications for timely alerts

### ✔️ Dose Tracking
- Mark doses as **Taken** or **Missed**
- Complete medication history logs stored in Firestore
- Track adherence rates and patterns

### 🔄 Refill Alerts
- Auto-detects low stock based on usage
- Sends refill reminder notifications
- Never run out of essential medications

### 👨‍👩‍👧 Caregiver Mode
- Link a caregiver account for monitoring
- Caregiver receives missed-dose alerts
- View adherence logs with read-only access
- Perfect for elderly care or chronic conditions

### 📅 Calendar View
- Visual log of daily/weekly medication intake
- Easy-to-read adherence tracking
- Historical data visualization

### 🔐 Authentication
- Email/Password sign-in
- Google Sign-In
- Apple Sign-In
- Secure password recovery

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Material Design** - UI components

### Backend / Cloud
- **Firebase Authentication** - User authentication & authorization
- **Firebase Firestore** - Real-time database for medication logs
- **Firebase Cloud Messaging** - Push notifications
- **Firebase Storage** - User profile & medication images

### Additional Packages
- `google_sign_in` - Google OAuth integration
- `sign_in_with_apple` - Apple Sign-In
- `cloud_firestore` - Firestore database SDK
- `firebase_auth` - Authentication SDK
- `flutter_svg` - SVG asset support

---

## 🧱 Project Structure

```
MedTrack-App/
├── frontend/
│   ├── lib/
│   │   ├── main.dart                    # App entry point
│   │   ├── landing_page.dart            # Welcome screen
│   │   ├── firebase_options.dart        # Firebase configuration
│   │   └── pages/
│   │       ├── login_page.dart          # User login
│   │       ├── signup_page.dart         # User registration
│   │       └── forgot_password_page.dart # Password recovery
│   ├── assets/
│   │   ├── logo/                        # App logo
│   │   └── icons/                       # Custom icons
│   ├── android/                         # Android-specific files
│   ├── ios/                             # iOS-specific files
│   ├── web/                             # Web-specific files
│   └── pubspec.yaml                     # Dependencies
├── CURRENT_STATUS.md                    # Development status
├── FIREBASE_SETUP.md                    # Firebase setup guide
└── README.md                            # This file
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10 or higher)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDE)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Imashi-wimalasekera/MedTrack-App.git
   cd MedTrack-App/frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Follow instructions in `FIREBASE_SETUP.md`
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update `firebase_options.dart` with your Firebase config

4. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

---

## 🔧 Configuration

### Firebase Configuration
Ensure you've set up Firebase Authentication with the following providers:
- ✅ Email/Password
- ✅ Google Sign-In
- ✅ Apple Sign-In (for iOS)

### Platform-Specific Setup

#### Android
1. Add SHA-1 and SHA-256 fingerprints to Firebase Console
2. Enable Google Sign-In in Firebase Authentication
3. Download and replace `google-services.json`

#### iOS
1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Configure URL schemes in `Info.plist`
3. Enable Sign-In with Apple capability

#### Web
1. Add web client ID to `index.html`
2. Configure authorized domains in Firebase Console

---

## 📸 Screenshots

*Coming soon - Screenshots of login, medication list, reminders, and caregiver features*

---

## 🗺️ Roadmap

- [x] User authentication (Email, Google, Apple)
- [x] Password recovery
- [ ] Medication management (Add/Edit/Delete)
- [ ] Reminder scheduling with notifications
- [ ] Dose tracking and history
- [ ] Refill alerts
- [ ] Caregiver mode
- [ ] Calendar view
- [ ] Dark mode support
- [ ] Multi-language support

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Authors

- **Imashi Wimalasekera** - [@Imashi-wimalasekera](https://github.com/Imashi-wimalasekera)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design for UI guidelines
- All contributors and testers

---

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact: [Your Email]

---

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Project Status](CURRENT_STATUS.md)
- [Firebase Setup Guide](FIREBASE_SETUP.md)

---

**Made with ❤️ using Flutter and Firebase**
