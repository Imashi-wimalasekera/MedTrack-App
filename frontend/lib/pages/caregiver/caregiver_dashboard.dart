import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'patient_list.dart';
import 'patient_details.dart';
import 'medication_history.dart';
import 'caregiver_notes.dart';

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  int _selectedIndex = 0;
  String? _selectedPatientId;
  String _caregiverName = 'Caregiver';
  String _caregiverEmail = '';
  List<Map<String, dynamic>> linkedPatients = [
    {
      'id': 'patient1',
      'name': 'John Doe',
      'age': 65,
      'lastMedicationTime': '2:30 PM',
      'adherencePercentage': 92,
    },
    {
      'id': 'patient2',
      'name': 'Jane Smith',
      'age': 72,
      'lastMedicationTime': '1:15 PM',
      'adherencePercentage': 88,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCaregiverInfo();
    _selectedPatientId = linkedPatients.isNotEmpty
        ? linkedPatients[0]['id']
        : null;
  }

  void _loadCaregiverInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _caregiverName = user.displayName ?? 'Caregiver';
        _caregiverEmail = user.email ?? '';
      });
    }
  }

  void _navigateToPage(int index) {
    setState(() => _selectedIndex = index);
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
        backgroundColor: const Color(0xFF0E7C86),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildDashboardView()
            : _selectedIndex == 1
            ? PatientListPage(
                linkedPatients: linkedPatients,
                onPatientSelected: (patientId) {
                  setState(() => _selectedPatientId = patientId);
                  _navigateToPage(0);
                },
              )
            : _selectedIndex == 2
            ? PatientDetailsPage(
                patientId: _selectedPatientId,
                linkedPatients: linkedPatients,
              )
            : _selectedIndex == 3
            ? MedicationHistoryPage(patientId: _selectedPatientId)
            : CaregiverNotesPage(patientId: _selectedPatientId),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4DB8AC),
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.details), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: 'Notes'),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF4DB8AC),
                  child: Text(
                    _caregiverName.isNotEmpty
                        ? _caregiverName[0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _caregiverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _caregiverEmail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Patients Section
          const Text(
            'Linked Patients',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: linkedPatients.length,
              itemBuilder: (context, index) {
                final patient = linkedPatients[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(patient['name']),
                      subtitle: Text(
                        'Age: ${patient['age']} | Adherence: ${patient['adherencePercentage']}%',
                      ),
                      leading: CircleAvatar(child: Text(patient['name'][0])),
                      onTap: () {
                        setState(() => _selectedPatientId = patient['id']);
                        _navigateToPage(2);
                      },
                    ),
                    if (index < linkedPatients.length - 1)
                      const Divider(height: 0),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Alerts Section
          const Text(
            'Missed Dose Alerts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.orange[50],
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[300]!),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Metformin',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'John Doe missed at 9:00 AM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Today's Summary
          const Text(
            "Today's Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.green[50],
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    children: [
                      const Text(
                        '3',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Taken',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  color: Colors.red[50],
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    children: [
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Missed',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  color: Colors.blue[50],
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    children: [
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
