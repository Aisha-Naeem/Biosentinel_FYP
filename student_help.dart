import 'package:flutter/material.dart';

class StudentHelpPage extends StatefulWidget {
  const StudentHelpPage({super.key});

  @override
  State<StudentHelpPage> createState() => _StudentHelpPageState();
}

class _StudentHelpPageState extends State<StudentHelpPage> {
  final List<Map<String, String>> helpList = [
    {
      'question': 'How do I mark attendance?',
      'answer':
          'Attendance is marked by scanning your face or fingerprint. Make sure you have completed the registration for facial recognition or fingerprint scanning before marking your attendance.'
    },
    {
      'question': 'Attendance records not showing?',
      'answer':
          'Check your internet connectivity. Ensure the device is properly connected to the network.'
    },
    {
      'question': 'How can I troubleshoot Bluetooth connectivity issues?',
      'answer': '''
        1. Ensure Bluetooth is turned on and the app has the required permissions.
        2. Stay within 10 meters of the device and check for obstructions.
        3. Restart Bluetooth and your device.
        4. Update the app or device firmware if necessary.
  '''
    },
    {
      'question': 'System crashing, what to do?',
      'answer': 'Restart the app and check your internet connection.'
    },
    {
      'question': 'Attendance not marked, what to do?',
      'answer':
          'Make sure you have completed registration with facial recognition or fingerprint data. Also, ensure Bluetooth is on and the internet connection is stable.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: helpList.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ExpansionTile(
                title: Text(
                  item['question']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['answer']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
