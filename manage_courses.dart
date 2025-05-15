import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_routes.dart';

class ManageCoursesPage extends StatefulWidget {
  const ManageCoursesPage({super.key});

  @override
  State<ManageCoursesPage> createState() => _ManageCoursesPageState();
}

class _ManageCoursesPageState extends State<ManageCoursesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  List<Map<String, dynamic>> courses = [];
  String? _currentCourseId;

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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

  Future<void> _addCourse() async {
    String? teacherUid = await getTeacherUid();
    if (teacherUid == null) {
      _showDialog('Error', 'Teacher UID not found');
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(ApiRoutes.createCourse),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'course_name': _courseController.text,
            'batch': _batchController.text,
            'section': _sectionController.text,
            'teacher_id': teacherUid,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          Navigator.pop(context);
          _fetchCourses();
          _showDialog('Success', 'Course added successfully');
        } else {
          final responseData = jsonDecode(response.body);
          _showDialog('Error', responseData['error'] ?? 'Failed to add course');
        }
      } catch (e) {
        _showDialog('Error', 'Error adding course: $e');
      }
    }
  }

  Future<void> _updateCourse() async {
    if (_formKey.currentState!.validate()) {
      String? teacherUid = await getTeacherUid();
      if (teacherUid == null) {
        _showDialog('Error', 'Teacher UID not found');
        return;
      }

      try {
        final response = await http.put(
          Uri.parse('${ApiRoutes.courses}/$_currentCourseId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'course_name': _courseController.text,
            'batch': _batchController.text,
            'section': _sectionController.text,
            'teacher_id': teacherUid,
          }),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
          _fetchCourses();
          _showDialog('Success', 'Course updated successfully');
        } else {
          final responseData = jsonDecode(response.body);
          _showDialog(
              'Error', responseData['error'] ?? 'Failed to update course');
        }
      } catch (e) {
        _showDialog('Error', 'Error updating course: $e');
      }
    }
  }

  void _showAddOrUpdateCourseDialog([String? courseId]) {
    if (courseId != null) {
      final course = courses.firstWhere((course) => course['id'] == courseId);
      _batchController.text = course['batch'];
      _courseController.text = course['course_name'];
      _sectionController.text = course['section'];
      _currentCourseId = courseId;
    } else {
      _clearControllers();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(courseId == null ? 'Add New Course' : 'Update Course'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _batchController,
                  decoration: const InputDecoration(labelText: 'Batch'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter batch' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _courseController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter course name' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _sectionController,
                  decoration: const InputDecoration(labelText: 'Section'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter section' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (courseId == null) {
                _addCourse();
              } else {
                _updateCourse();
              }
            },
            child: Text(courseId == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCourse(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiRoutes.courses}/$courseId'),
      );

      if (response.statusCode == 200) {
        _fetchCourses();
        _showDialog('Success', 'Course deleted successfully');
      } else {
        final responseData = jsonDecode(response.body);
        _showDialog(
            'Error', responseData['error'] ?? 'Failed to delete course');
      }
    } catch (e) {
      _showDialog('Error', 'Error deleting course: $e');
    }
  }

  void _clearControllers() {
    _batchController.clear();
    _courseController.clear();
    _sectionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Courses'),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Course: ${courses[index]['course_name']}'),
                    subtitle: Text(
                      'Batch: ${courses[index]['batch']}\nSection: ${courses[index]['section']}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAddOrUpdateCourseDialog(
                              courses[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCourse(courses[index]['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrUpdateCourseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
