import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualAttendancePage extends StatefulWidget {
  const ManualAttendancePage({super.key});

  @override
  State<ManualAttendancePage> createState() => _ManualAttendancePageState();
}

class _ManualAttendancePageState extends State<ManualAttendancePage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCourse;
  String? studentId;
  String? selectedReason;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<String> reasonsList = [
    'Biometric Device Error',
    'Finger Not Recognized',
    'System Error',
    'Other'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manual Attendance',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Course',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCourse,
                        items: [
                          'Data Structures and Algo',
                          'clouds',
                          'Database',
                          'genai'
                        ]
                            .map((course) => DropdownMenuItem(
                                  value: course,
                                  child: Text(course),
                                ))
                            .toList(),
                        validator: (value) =>
                            value == null ? 'Please select a course' : null,
                        onChanged: (value) {
                          setState(() {
                            selectedCourse = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
                          hintText: '21F-9136',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          studentId = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter student ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Reason for Manual Entry',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedReason,
                        items: reasonsList
                            .map((reason) => DropdownMenuItem(
                                  value: reason,
                                  child: Text(reason),
                                ))
                            .toList(),
                        validator: (value) =>
                            value == null ? 'Please select a reason' : null,
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Date',
                                ),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Time',
                                ),
                                child: Text(selectedTime.format(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Attendance marked successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Mark Attendance',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
