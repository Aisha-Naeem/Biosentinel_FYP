import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../api_routes.dart';
import 'registration.dart'; // <-- Yahan RegistrationPage import karo

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Map<String, dynamic>> enrolledCourses = [];
  String? studentUid;

  @override
  void initState() {
    super.initState();
    loadStudentUID();
  }

  Future<void> loadStudentUID() async {
    final prefs = await SharedPreferences.getInstance();
    studentUid = prefs.getString('student_uid');
    if (studentUid != null) {
      await fetchEnrolledCourses();
    } else {
      print("⚠️ No student UID found.");
    }
  }

  Future<void> fetchEnrolledCourses() async {
    final url = Uri.parse("${ApiRoutes.fetchStudentEnrollments}/$studentUid");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          enrolledCourses = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("Failed to fetch courses: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching courses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        backgroundColor: Colors.indigo,
      ),
      body: enrolledCourses.isEmpty
          ? const Center(child: Text("No enrolled courses found."))
          : ListView.builder(
              itemCount: enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = enrolledCourses[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.indigo),
                    title: Text(course['course_name'] ?? "Unknown Course"),
                    subtitle: Text(
                        "Section ${course['section']} - ${course['teacher_name']}"),
                    onTap: () {
                      // Navigate to RegistrationPage on course tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
