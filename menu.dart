import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart'; // Backend routes file

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? studentName;
  String? studentEmail;
  bool _isLoading = true;

  Future<void> _fetchStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('student_uid'); // Get student UID

    if (uid == null) {
      _showErrorDialog('UID not found. Please log in again.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiRoutes.login), // Same backend API as teacher login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          studentName = data['user']['name'];
          studentEmail = data['user']['email'];
          _isLoading = false;
        });
      } else {
        _showErrorDialog('Error fetching student data from backend.');
      }
    } catch (e) {
      _showErrorDialog('Failed to fetch data: ${e.toString()}');
    }
  }

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
    _fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E3A5F),
                        Color(0xFF664E8C),
                        Color(0xFF56C6B9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  accountName: Text(
                    studentName ?? 'Loading...',
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    studentEmail ?? 'Loading...',
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
                  onTap: () => Navigator.pushNamed(context, '/student-home'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/student-profile'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Support'),
                  onTap: () => Navigator.pushNamed(context, '/help'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear SharedPreferences here if needed
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
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
