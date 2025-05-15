import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_routes.dart';

class Session extends StatefulWidget {
  const Session({super.key});
  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedCourseId;
  final TextEditingController _durationController = TextEditingController();

  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> sessions = [];
  String? editingSessionId;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _fetchSessions();
  }

  Future<void> _fetchCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? teacherUid = prefs.getString('firebase_uid');
    if (teacherUid == null) return;

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
              'id': course['id'].toString(),
              'course_name': '${course['course_name']} (${course['section']})',
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching courses: $e');
    }
  }

  Future<void> _fetchSessions() async {
    try {
      final response = await http.get(Uri.parse(ApiRoutes.sessions));
      if (response.statusCode == 200) {
        final List sessionsData = jsonDecode(response.body);
        setState(() {
          sessions = sessionsData.map((session) {
            return Map<String, dynamic>.from(session);
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching sessions: $e');
    }
  }

  Future<void> _createOrUpdateSession() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        selectedCourseId != null) {
      try {
        final DateTime combinedDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );

        Map<String, dynamic> sessionData = {
          'course_id': int.parse(selectedCourseId!),
          'start_time': combinedDateTime.toIso8601String(),
          'duration_minutes': int.parse(_durationController.text),
        };

        http.Response response;
        if (editingSessionId == null) {
          response = await http.post(
            Uri.parse(ApiRoutes.sessions),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(sessionData),
          );
        } else {
          response = await http.put(
            Uri.parse('${ApiRoutes.sessions}/$editingSessionId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(sessionData),
          );
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          //final responseData = jsonDecode(response.body);

          // Print broadcasting info to terminal
          // String sessionUuid = responseData['uuid'] ?? 'UUID not available';
          // print('Broadcasting session...');
          // print('Session UUID: $sessionUuid);
          // print('Major: 100');
          // print('Minor: 0');

          Navigator.of(context).pop();
          _clearForm();
          await _fetchSessions();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Session ${editingSessionId == null ? 'created' : 'updated'} successfully'),
            ),
          );
        } else {
          debugPrint("Unexpected response: ${response.body}");
        }
      } catch (e) {
        debugPrint('Error creating/updating session: $e');
      }
    }
  }

  Future<void> _deleteSession(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('${ApiRoutes.sessions}/$id'));
      if (response.statusCode == 200) {
        _fetchSessions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session deleted successfully')),
        );
      }
    } catch (e) {
      debugPrint('Error deleting session: $e');
    }
  }

  void _showSessionForm([Map<String, dynamic>? session]) {
    if (session != null) {
      final startTime = DateTime.parse(session['start_time']);
      selectedDate = startTime;
      selectedTime = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
      selectedCourseId = session['course_id'].toString();
      _durationController.text = session['duration_minutes'].toString();
      editingSessionId = session['id'].toString();
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session == null ? 'Create New Session' : 'Update Session'),
        content: SingleChildScrollView(child: _buildForm()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearForm();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _createOrUpdateSession,
            child: Text(session == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(selectedDate == null
                ? 'Select Date'
                : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
          ListTile(
            title: Text(selectedTime == null
                ? 'Select Time'
                : 'Time: ${selectedTime!.format(context)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );
              if (picked != null) setState(() => selectedTime = picked);
            },
          ),
          DropdownButtonFormField<String>(
            value: selectedCourseId,
            decoration: const InputDecoration(labelText: 'Select Course'),
            items: courses.map((course) {
              return DropdownMenuItem<String>(
                value: course['id'],
                child: Text(course['course_name']),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedCourseId = value),
            validator: (value) =>
                value == null ? 'Please select a course' : null,
          ),
          TextFormField(
            controller: _durationController,
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'Please enter duration' : null,
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    selectedDate = null;
    selectedTime = null;
    selectedCourseId = null;
    _durationController.clear();
    editingSessionId = null;
  }

  String _getSessionStatus(Map<String, dynamic> session) {
    try {
      final now = DateTime.now();
      final startTime = DateTime.parse(session['start_time']).toLocal();
      final endTime = startTime.add(
        Duration(minutes: int.parse(session['duration_minutes'].toString())),
      );
      return now.isBefore(endTime) ? 'Active' : 'Expired';
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    return status == 'Active' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Sessions'),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No sessions available.'))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final course = courses.firstWhere(
                  (c) => c['id'].toString() == session['course_id'].toString(),
                  orElse: () => <String, String>{'course_name': 'Unknown'},
                );
                final status = _getSessionStatus(session);
                final startTime =
                    DateTime.parse(session['start_time']).toLocal();
                final formattedTime =
                    TimeOfDay.fromDateTime(startTime).format(context);
                final formattedDate =
                    '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}';

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Course: ${course['course_name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: $formattedDate'),
                        Text('Time: $formattedTime'),
                        Text('Duration: ${session['duration_minutes']} min'),
                        Row(
                          children: [
                            const Text('Status: '),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showSessionForm(session),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteSession(session['id'].toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSessionForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
