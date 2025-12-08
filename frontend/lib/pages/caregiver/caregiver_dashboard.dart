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

  List<Map<String, dynamic>> missedDoseAlerts = [
    {
      'patientName': 'John Doe',
      'medicineName': 'Metformin',
      'time': '9:00 AM',
      'timestamp': '5 mins ago',
    },
  ];

  List<Map<String, dynamic>> todaysSummary = [
    {'status': 'Taken', 'count': 3},
    {'status': 'Skipped', 'count': 1},
    {'status': 'Upcoming', 'count': 1},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
      child: Column(
        children: [
          // Top Section - Profile & Patient Selector
          _buildProfileSection(),

          const SizedBox(height: 20),

          // Missed Dose Alerts
          _buildMissedDoseAlerts(),

          const SizedBox(height: 20),

          // Today's Summary
          _buildTodaysSummary(),

          const SizedBox(height: 20),

          // Weekly Chart Section
          _buildWeeklyChart(),

          const SizedBox(height: 20),

          // Refill Alerts
          _buildRefillAlerts(),

          const SizedBox(height: 20),

          // Quick Actions
          _buildQuickActions(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF4DB8AC),
                child: Text(
                  _caregiverName[0].toUpperCase(),
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
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _caregiverEmail,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Linked Patients Dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedPatientId,
              isExpanded: true,
              underline: const SizedBox(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              items: linkedPatients
                  .map(
                    (patient) => DropdownMenuItem<String>(
                      value: patient['id'],
                      child: Text(
                        '${patient['name']} (Age: ${patient['age']})',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedPatientId = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedDoseAlerts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Missed Dose Alerts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (missedDoseAlerts.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'All patients taking medications on time! ✓',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            ...missedDoseAlerts.map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alert['patientName'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${alert['medicineName']} - ${alert['time']}',
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
              Text(
                alert['timestamp'],
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: todaysSummary
                .asMap()
                .entries
                .map((entry) => Expanded(child: _buildSummaryCard(entry.value)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> item) {
    final colors = {
      'Taken': const Color(0xFF4DB8AC),
      'Skipped': Colors.red,
      'Upcoming': Colors.orange,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors[item['status']]?.withValues(alpha: 0.1),
        border: Border.all(
          color: colors[item['status']]!.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            item['count'].toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors[item['status']],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item['status'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Adherence',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildBarChart(
                          entry.value,
                          [85, 90, 75, 95, 88, 92, 80][entry.key],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Average Adherence: 85%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4DB8AC),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String day, int percentage) {
    return Column(
      children: [
        Container(
          width: 24,
          height: (percentage / 100) * 100,
          decoration: BoxDecoration(
            color: const Color(0xFF4DB8AC),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 11, color: Colors.black87)),
      ],
    );
  }

  Widget _buildRefillAlerts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_pharmacy, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Refill Alerts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border.all(color: Colors.orange[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Metformin - Stock: 5 tablets (Refill in 2 days)',
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToPage(4),
              icon: const Icon(Icons.note_add),
              label: const Text('Add Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DB8AC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _navigateToPage(3),
              icon: const Icon(Icons.history),
              label: const Text('View History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4DB8AC),
                side: const BorderSide(color: Color(0xFF4DB8AC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
