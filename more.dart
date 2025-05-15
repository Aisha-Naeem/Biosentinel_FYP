import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart'; // Import the ApiRoutes file for backend routes
import '../teacher_module/teacher_help.dart'; // Import the Teacher Help page

class TeacherMenuPage extends StatefulWidget {
  const TeacherMenuPage({super.key});

  @override
  State<TeacherMenuPage> createState() => _TeacherMenuPageState();
}

class _TeacherMenuPageState extends State<TeacherMenuPage> {
  String? teacherName;
  String? teacherEmail;
  bool _isLoading = true; // To show loading indicator while fetching data

  // Fetch teacher data from backend using UID stored in SharedPreferences
  Future<void> _fetchTeacherData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('firebase_uid'); // Retrieve the Firebase UID

    if (uid != null) {
      try {
        final response = await http.post(
          Uri.parse(
              ApiRoutes.login), // Send UID to backend for fetching teacher data
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'uid': uid}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body); // Decode the response
          setState(() {
            teacherName = data['user']['name'];
            teacherEmail = data['user']['email'];
            _isLoading = false; // Stop loading
          });
        } else {
          _showErrorDialog('Error fetching teacher data from the backend.');
        }
      } catch (e) {
        _showErrorDialog('Failed to fetch data: ${e.toString()}');
      }
    } else {
      _showErrorDialog('UID not found. Please log in again.');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTeacherData(); // Fetch teacher data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style:
              TextStyle(color: Colors.white), // Title text color set to white
        ),
        backgroundColor:
            const Color(0xFF1E3A5F), // Deep Blue for header background
        iconTheme: const IconThemeData(
            color: Colors.white), // Make the back icon white
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Profile Header
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E3A5F), // Deep Blue
                        Color(0xFF664E8C), // Soft Purple
                        Color(0xFF56C6B9), // Teal
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  accountName: Text(
                    teacherName ?? 'Loading...', // Display teacher's name
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    teacherEmail ?? 'Loading...', // Display teacher's email
                    style: const TextStyle(color: Colors.white),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pushNamed(context, '/teacher-home'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/teacher-profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Mark Attendance'),
                  onTap: () =>
                      Navigator.pushNamed(context, '/manual-attendance'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.assessment),
                  title: const Text('View Attendance Records'),
                  onTap: () =>
                      Navigator.pushNamed(context, '/attendance-records'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const TeacherHelpPage()), // Navigate to TeacherHelpPage
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Display a confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context), // Close the dialog
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear user session data here if necessary (e.g., SharedPreferences)
                                // Navigate to the login page and remove all routes
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login', // Replace with your login route
                                  (route) => false, // Remove all routes
                                );
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
