import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart'; // Import the ApiRoutes file for backend routes

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  String? role;
  bool _isLoading = true;

  // Fetch UID from SharedPreferences and get user data from backend
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('firebase_uid'); // Retrieve the Firebase UID

    if (uid != null) {
      try {
        final response = await http.post(
          Uri.parse(ApiRoutes.login), // Use the correct backend API URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'uid': uid}),
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body); // Decode the response
          setState(() {
            name = userData['user']['name'];
            email = userData['user']['email'];
            role = userData['user']['role'];
            _isLoading = false; // Stop loading
          });
        } else {
          // Handle backend error
          _showErrorDialog('Error fetching user data from the backend.');
        }
      } catch (e) {
        // Handle error
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
    _fetchUserData(); // Fetch user data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E3A5F), Color(0xFF2A5885)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name ?? 'Loading...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email ?? 'Loading...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          role ?? 'Loading...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
