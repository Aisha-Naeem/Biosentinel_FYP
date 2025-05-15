import 'package:flutter/material.dart';

class DailyAttendancePage extends StatefulWidget {
  const DailyAttendancePage({Key? key}) : super(key: key);

  @override
  State<DailyAttendancePage> createState() => _DailyAttendancePageState();
}

class _DailyAttendancePageState extends State<DailyAttendancePage> {
  // Dummy enrolled courses
  final List<Map<String, String>> enrolledCourses = [
    {"id": "course1", "name": "Data Structures and Algo"},
    {"id": "course2", "name": "clouds"},
    {"id": "course3", "name": "genai"},
  ];

  // Dummy attendance data per course
  final Map<String, List<Map<String, String>>> attendanceData = {
    "course1": [
      {"date": "2025-05-13", "status": "Present"},
      {"date": "2025-05-14", "status": "Absent"},
    ],
    "course2": [
      {"date": "2025-05-13", "status": "Present"},
      {"date": "2025-05-14", "status": "Present"},
    ],
    "course3": [
      {"date": "2025-05-15", "status": "Present"},
    ],
  };

  String? selectedCourseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Attendance"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedCourseId == null
            ? ListView.builder(
                itemCount: enrolledCourses.length,
                itemBuilder: (context, index) {
                  final course = enrolledCourses[index];
                  return Card(
                    child: ListTile(
                      title: Text(course['name']!),
                      onTap: () {
                        setState(() {
                          selectedCourseId = course['id'];
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
                    "Attendance for ${enrolledCourses.firstWhere((c) => c['id'] == selectedCourseId)['name']}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: attendanceData[selectedCourseId]?.length ?? 0,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final record = attendanceData[selectedCourseId]![index];
                        return ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(record['date']!),
                          trailing: Text(
                            record['status']!,
                            style: TextStyle(
                              color: record['status'] == "Present"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
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
}
