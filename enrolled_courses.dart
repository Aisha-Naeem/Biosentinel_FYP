import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../api_routes.dart';

class EnrolledCoursesList extends StatefulWidget {
  const EnrolledCoursesList({super.key});

  @override
  State<EnrolledCoursesList> createState() => _EnrolledCoursesListState();
}

class _EnrolledCoursesListState extends State<EnrolledCoursesList> {
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
      print("⚠️ No student UID found in SharedPreferences.");
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
        print("✅ Courses loaded: ${enrolledCourses.length}");
      } else {
        print("❌ Failed to fetch courses: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 Error during fetch: $e");
    }
  }

  Future<void> _addCourse(
      String courseName, String section, String teacherName) async {
    final url = Uri.parse("${ApiRoutes.enrollments}");
    final prefs = await SharedPreferences.getInstance();
    final studentUid = prefs.getString('student_uid');

    if (studentUid == null) {
      print("⚠️ No student UID found.");
      return;
    }

    final body = json.encode({
      "student_uid": studentUid,
      "course_name": courseName,
      "section": section,
      "teacher_name": teacherName,
    });

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Course added successfully");
        await fetchEnrolledCourses();
      } else {
        print("❌ Failed to add course: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 Error adding course: $e");
    }
  }

  void _showAddCourseDialog() {
    String courseName = '';
    String section = '';
    String teacherName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Course Name'),
                onChanged: (value) => courseName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Section'),
                onChanged: (value) => section = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Teacher Name'),
                onChanged: (value) => teacherName = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (courseName.isNotEmpty &&
                    section.isNotEmpty &&
                    teacherName.isNotEmpty) {
                  await _addCourse(courseName, section, teacherName);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enrolled Courses"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCourseDialog,
          ),
        ],
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
                  ),
                );
              },
            ),
    );
  }
}
