// Firestore Database Structure for MedTrack App
//
// Users Collection:
// /Users/{userId}
//   - email (string)
//   - displayName (string)
//   - role (string: "User" or "Caregiver")
//   - age (number)
//   - phone (string)
//   - createdAt (timestamp)
//   - linkedCaregivers (array of caregiver IDs)
//   - adherencePercentage (number)
//   - lastMedicationTime (string)
//
//   Subcollections:
//   - Medications/{medId}
//     - name (string)
//     - dosage (string)
//     - frequency (string)
//     - time (array of times)
//     - stockCount (number)
//     - refillDate (date)
//     - instructions (string)
//
//   - MedicationLogs/{logId}
//     - medicineName (string)
//     - status (string: "Taken", "Skipped", "Pending")
//     - scheduledTime (timestamp)
//     - actualTime (timestamp)
//     - timestamp (timestamp)
//     - delayMinutes (number)
//
//   - CaregiverNotes/{noteId}
//     - text (string)
//     - timestamp (timestamp)
//     - caregiverId (string)
//     - caregiverName (string)
//
// Caregivers Collection:
// /Caregivers/{caregiverId}
//   - email (string)
//   - displayName (string)
//   - linkedPatients (array of user IDs)
//   - createdAt (timestamp)
//   - phone (string)
//   - notificationPreferences (object)
//     - emailNotifications (boolean)
//     - smsNotifications (boolean)
//     - pushNotifications (boolean)
//     - missedDoseAlerts (boolean)
//     - adherenceAlerts (boolean)
//     - refillAlerts (boolean)
//
// Notifications Collection:
// /Notifications/{notificationId}
//   - type (string: "MissedDose", "LowAdherence", "RefillReminder")
//   - patientId (string)
//   - patientName (string)
//   - caregiverEmail (string)
//   - timestamp (timestamp)
//   - status (string: "pending", "sent", "failed")
//   - sendEmail (boolean)
//   - sendSMS (boolean)
//   - [Additional fields based on type]
//
// Sample Query Patterns:
// 1. Get all linked patients for caregiver:
//    db.collection("Caregivers").doc(caregiverId).get()
//
// 2. Get missed doses for a patient today:
//    db.collection("Users").doc(patientId).collection("MedicationLogs")
//      .where("status", "==", "Skipped")
//      .where("timestamp", ">=", startOfDay)
//      .where("timestamp", "<=", endOfDay)
//
// 3. Get medication schedule:
//    db.collection("Users").doc(patientId).collection("Medications").get()
//
// 4. Get caregiver notes:
//    db.collection("Users").doc(patientId).collection("CaregiverNotes")
//      .orderBy("timestamp", "desc")
