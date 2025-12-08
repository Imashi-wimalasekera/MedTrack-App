import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get caregiver's linked patients
  static Future<List<Map<String, dynamic>>> getLinkedPatients(
    String caregiverId,
  ) async {
    try {
      final doc = await _firestore
          .collection('Caregivers')
          .doc(caregiverId)
          .get();
      if (doc.exists) {
        final patientIds = List<String>.from(doc['linkedPatients'] ?? []);
        final patients = <Map<String, dynamic>>[];

        for (String patientId in patientIds) {
          final patientDoc = await _firestore
              .collection('Users')
              .doc(patientId)
              .get();
          if (patientDoc.exists) {
            patients.add({
              'id': patientId,
              'name': patientDoc['displayName'] ?? 'Unknown',
              'age': patientDoc['age'] ?? 0,
              'lastMedicationTime': patientDoc['lastMedicationTime'] ?? 'N/A',
              'adherencePercentage': patientDoc['adherencePercentage'] ?? 0,
              'email': patientDoc['email'] ?? '',
            });
          }
        }
        return patients;
      }
      return [];
    } catch (e) {
      print('Error fetching linked patients: $e');
      return [];
    }
  }

  // Get missed doses for a patient
  static Future<List<Map<String, dynamic>>> getMissedDoses(
    String patientId,
  ) async {
    try {
      final query = await _firestore
          .collection('Users')
          .doc(patientId)
          .collection('MedicationLogs')
          .where('status', isEqualTo: 'Skipped')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return {
          'patientName': data['patientName'] ?? 'Unknown',
          'medicineName': data['medicineName'] ?? 'Unknown',
          'time': data['scheduledTime'] ?? 'N/A',
          'timestamp': _getTimeAgo(data['timestamp']),
        };
      }).toList();
    } catch (e) {
      print('Error fetching missed doses: $e');
      return [];
    }
  }

  // Get today's medication summary
  static Future<Map<String, int>> getTodaysSummary(String patientId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      final logs = await _firestore
          .collection('Users')
          .doc(patientId)
          .collection('MedicationLogs')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();

      int taken = 0, skipped = 0, upcoming = 0;

      for (var doc in logs.docs) {
        final status = doc['status'] ?? 'Upcoming';
        if (status == 'Taken') taken++;
        if (status == 'Skipped') skipped++;
        if (status == 'Upcoming') upcoming++;
      }

      return {'taken': taken, 'skipped': skipped, 'upcoming': upcoming};
    } catch (e) {
      print('Error fetching today summary: $e');
      return {'taken': 0, 'skipped': 0, 'upcoming': 0};
    }
  }

  // Get weekly adherence data
  static Future<List<int>> getWeeklyAdherence(String patientId) async {
    try {
      final weeklyData = <int>[0, 0, 0, 0, 0, 0, 0]; // Mon-Sun

      for (int i = 0; i < 7; i++) {
        final day = DateTime.now().subtract(Duration(days: i));
        final startOfDay = DateTime(day.year, day.month, day.day);
        final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

        final logs = await _firestore
            .collection('Users')
            .doc(patientId)
            .collection('MedicationLogs')
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('timestamp', isLessThanOrEqualTo: endOfDay)
            .get();

        if (logs.docs.isNotEmpty) {
          int taken = logs.docs.where((d) => d['status'] == 'Taken').length;
          int total = logs.docs.length;
          weeklyData[6 - i] = ((taken / total) * 100).toInt();
        }
      }

      return weeklyData;
    } catch (e) {
      print('Error fetching weekly adherence: $e');
      return [0, 0, 0, 0, 0, 0, 0];
    }
  }

  // Get upcoming medication doses
  static Future<List<Map<String, dynamic>>> getUpcomingDoses(
    String patientId,
  ) async {
    try {
      final query = await _firestore
          .collection('Users')
          .doc(patientId)
          .collection('Medications')
          .get();

      final doses = <Map<String, dynamic>>[];
      for (var doc in query.docs) {
        doses.add({
          'id': doc.id,
          'medicine': doc['name'] ?? 'Unknown',
          'dosage': doc['dosage'] ?? 'N/A',
          'time': doc['time'] ?? 'N/A',
          'status': doc['lastStatus'] ?? 'Upcoming',
        });
      }
      return doses;
    } catch (e) {
      print('Error fetching upcoming doses: $e');
      return [];
    }
  }

  // Add a caregiver note
  static Future<void> addCaregiverNote(String patientId, String note) async {
    try {
      await _firestore
          .collection('Users')
          .doc(patientId)
          .collection('CaregiverNotes')
          .add({
            'text': note,
            'timestamp': DateTime.now(),
            'caregiverId': _auth.currentUser?.uid,
            'caregiverName': _auth.currentUser?.displayName ?? 'Caregiver',
          });
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // Get caregiver notes for a patient
  static Future<List<Map<String, dynamic>>> getCaregiverNotes(
    String patientId,
  ) async {
    try {
      final query = await _firestore
          .collection('Users')
          .doc(patientId)
          .collection('CaregiverNotes')
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': data['text'] ?? '',
          'timestamp': data['timestamp'] ?? Timestamp.now(),
          'caregiverName': data['caregiverName'] ?? 'Unknown',
        };
      }).toList();
    } catch (e) {
      print('Error fetching caregiver notes: $e');
      return [];
    }
  }

  // Helper function to get time ago format
  static String _getTimeAgo(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    }
    return 'N/A';
  }
}
