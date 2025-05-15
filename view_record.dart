import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api_routes.dart'; // Apne project ke mutabiq path set karein
import 'package:shared_preferences/shared_preferences.dart';

class TeacherReportsPage extends StatefulWidget {
  const TeacherReportsPage({Key? key}) : super(key: key);

  @override
  State<TeacherReportsPage> createState() => _TeacherReportsPageState();
}

class _TeacherReportsPageState extends State<TeacherReportsPage> {
  List<Map<String, dynamic>> courses = [];
  String? selectedCourseId;

  // Dummy attendance data for students per course
  final Map<String, List<Map<String, dynamic>>> attendanceData = {
    "3": [
      {"name": "haider", "present_today": true},
      {"name": "xyz", "present_today": false},
    ],
    "6": [
      {"name": "haider", "present_today": true},
    ],
  };

  Future<String?> getTeacherUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('firebase_uid');
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    String? teacherUid = await getTeacherUid();
    if (teacherUid == null) {
      _showDialog('Error', 'Teacher UID not found');
      return;
    }

    try {
      final Uri uri = Uri.parse(ApiRoutes.courses).replace(queryParameters: {
        'teacher_id': teacherUid,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List coursesData = jsonDecode(response.body);
        setState(() {
          courses = coursesData.map((course) {
            return {
              'course_name': course['course_name'],
              'batch': course['batch'],
              'section': course['section'],
              'id': course['id'].toString(),
            };
          }).toList();
        });
      } else {
        _showDialog('Error',
            'Failed to fetch courses. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog('Error', 'Error fetching courses: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // Count present and absent students for selected course
    int totalStudents = 0;
    int presentToday = 0;
    int absentToday = 0;
    if (selectedCourseId != null) {
      final students = attendanceData[selectedCourseId] ?? [];
      totalStudents = students.length;
      presentToday =
          students.where((s) => s['present_today'] == true).toList().length;
      absentToday = totalStudents - presentToday;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Attendance Reports"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: selectedCourseId == null
            ? ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          "${course['course_name']} - Batch ${course['batch']} - Section ${course['section']}"),
                      onTap: () {
                        setState(() {
                          selectedCourseId = course['id'].toString();
                        });
                      },
                    ),
                  );
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back to Courses"),
                    onPressed: () {
                      setState(() {
                        selectedCourseId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Course: ${courses.firstWhere((c) => c['id'] == selectedCourseId)['course_name']}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Summary cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryCard(
                          icon: Icons.group,
                          label: "Total Students",
                          value: totalStudents.toString(),
                          color: Colors.blue),
                      _buildSummaryCard(
                          icon: Icons.check_circle,
                          label: "Present Today",
                          value: presentToday.toString(),
                          color: Colors.green),
                      _buildSummaryCard(
                          icon: Icons.cancel,
                          label: "Absent Today",
                          value: absentToday.toString(),
                          color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: attendanceData[selectedCourseId]?.length ?? 0,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final student =
                            attendanceData[selectedCourseId]![index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[300],
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(student['name']),
                            trailing: Text(
                              student['present_today'] == true
                                  ? "Present"
                                  : "Absent",
                              style: TextStyle(
                                color: student['present_today'] == true
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        width: 110,
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
