import 'package:flutter/material.dart';

class MedicationHistoryPage extends StatefulWidget {
  final String? patientId;

  const MedicationHistoryPage({super.key, required this.patientId});

  @override
  State<MedicationHistoryPage> createState() => _MedicationHistoryPageState();
}

class _MedicationHistoryPageState extends State<MedicationHistoryPage> {
  final historyLogs = [
    {
      'date': 'Today',
      'entries': [
        {
          'time': '9:00 AM',
          'medicine': 'Vitamin D',
          'status': 'Taken',
          'delayMinutes': 0,
        },
        {
          'time': '1:00 PM',
          'medicine': 'Blood Pressure Pill',
          'status': 'Taken',
          'delayMinutes': 5,
        },
        {
          'time': '7:00 PM',
          'medicine': 'Metformin',
          'status': 'Skipped',
          'delayMinutes': 0,
        },
      ],
    },
    {
      'date': 'Yesterday',
      'entries': [
        {
          'time': '9:00 AM',
          'medicine': 'Vitamin D',
          'status': 'Taken',
          'delayMinutes': 0,
        },
        {
          'time': '1:00 PM',
          'medicine': 'Blood Pressure Pill',
          'status': 'Taken',
          'delayMinutes': 0,
        },
        {
          'time': '7:00 PM',
          'medicine': 'Metformin',
          'status': 'Taken',
          'delayMinutes': 10,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(),
        title: const Text(
          'Medication History',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyLogs.length,
        itemBuilder: (context, index) {
          final dayLog = historyLogs[index];
          final date = dayLog['date'] as String;
          final entries = dayLog['entries'] as List;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...entries.map(
                (entry) => _buildHistoryCard(entry as Map<String, dynamic>),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> entry) {
    final statusColor = entry['status'] == 'Taken'
        ? Colors.green
        : entry['status'] == 'Skipped'
        ? Colors.red
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              entry['status'] == 'Taken'
                  ? Icons.check_circle
                  : entry['status'] == 'Skipped'
                  ? Icons.cancel
                  : Icons.schedule,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['medicine'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry['time'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry['status'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 4),
              if (entry['delayMinutes'] > 0)
                Text(
                  '+${entry['delayMinutes']} min late',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
