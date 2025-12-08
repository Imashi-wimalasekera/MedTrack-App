import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/caregiver/caregiver_dashboard.dart';
import 'pages/login_page.dart';

class RoleBasedNavigator extends StatefulWidget {
  const RoleBasedNavigator({super.key});

  @override
  State<RoleBasedNavigator> createState() => _RoleBasedNavigatorState();
}

class _RoleBasedNavigatorState extends State<RoleBasedNavigator> {
  late Stream<User?> _authStream;
  String? _userRole;
  bool _isLoadingRole = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        try {
          // Try to fetch from Firestore
          final doc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

          if (doc.exists && doc.data() != null) {
            setState(() {
              _userRole = doc['role'] ?? 'User';
              _isLoadingRole = false;
              _errorMessage = null;
            });
          } else {
            // Document doesn't exist, create it with default role
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .set({
                  'email': user.email ?? '',
                  'displayName': user.displayName ?? 'User',
                  'role': 'User',
                  'createdAt': DateTime.now(),
                  'linkedCaregivers': [],
                  'adherencePercentage': 0,
                  'lastMedicationTime': 'N/A',
                }, SetOptions(merge: true));

            setState(() {
              _userRole = 'User';
              _isLoadingRole = false;
              _errorMessage = null;
            });
          }
        } on FirebaseException catch (e) {
          print('Firebase Error loading user role: ${e.code} - ${e.message}');

          // Permission denied - use default role
          if (e.code == 'permission-denied') {
            setState(() {
              _userRole = 'User'; // Default to User if permissions denied
              _isLoadingRole = false;
              _errorMessage =
                  'Note: Using default role. Please update Firestore rules.';
            });
          } else {
            setState(() {
              _userRole = 'User';
              _isLoadingRole = false;
              _errorMessage = 'Error: ${e.message}';
            });
          }
        } catch (e) {
          print('Error loading user role: $e');
          setState(() {
            _userRole = 'User';
            _isLoadingRole = false;
            _errorMessage = 'Connection error. Using default role.';
          });
        }
      } else {
        setState(() {
          _userRole = null;
          _isLoadingRole = false;
          _errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const LoginPage();
        }

        if (_isLoadingRole) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Show error snackbar if exists
        if (_errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage!),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          });
        }

        // Navigate based on role
        if (_userRole == 'Caregiver') {
          return const CaregiverDashboard();
        } else {
          // User dashboard - to be implemented
          return Scaffold(
            appBar: AppBar(
              title: const Text('User Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
            body: const Center(child: Text('User Dashboard - Coming Soon')),
          );
        }
      },
    );
  }
}
