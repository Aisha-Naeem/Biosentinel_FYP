// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart'; // Backend routes file

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoading = true;
  String name = '';
  String email = '';
  String rollNumber = '';
  String department = '';
  String batch = '';
  String degree = '';

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
  }

  Future<void> fetchStudentProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('student_uid');

    if (uid == null) {
      setState(() {
        _isLoading = false;
      });
      // Optionally show error or navigate to login
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiRoutes.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        setState(() {
          name = user['name'] ?? '';
          email = user['email'] ?? '';
          rollNumber = user['roll_number'] ??
              ''; // Replace keys according to your backend
          department = user['department'] ?? '';
          batch = user['batch'] ?? '';
          degree = user['degree'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle API error
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle fetch error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1E3A5F), Color(0xFF2A5885)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Roll Number: $rollNumber',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow('Email', email),
                    _buildInfoRow('Department', department),
                    _buildInfoRow('Batch', batch),
                    _buildInfoRow('Degree', degree),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
