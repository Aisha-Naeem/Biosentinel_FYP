import 'package:flutter/material.dart';

class TeacherHelpPage extends StatefulWidget {
  const TeacherHelpPage({super.key});

  @override
  State<TeacherHelpPage> createState() => _TeacherHelpPageState();
}

class _TeacherHelpPageState extends State<TeacherHelpPage> {
  final List<Map<String, String>> helpList = [
    {
      'question':
          'Why is a student marked absent even though they marked their attendance?',
      'answer': '''
1. Bluetooth connectivity issues or being out of range.
2. Incomplete registration for facial recognition or fingerprint scanning.
3. App/system glitches causing data not to register.
4. Poor or unstable internet connection.
5. Bluetooth was off during attendance marking.
6. Incorrect session or class selection.
  '''
    },
    {
      'question': 'What to do if my session gets interrupted?',
      'answer': '''
1. Check your internet connection and make sure it's stable.
2. Restart the app to re-establish the session.
3. Verify that the system is not facing any technical issues.
  '''
    },
    {
      'question': 'Can I edit or update attendance after a session ends?',
      'answer': '''
Yes, teachers can manually mark attendance even after the session ends. 
  '''
    },
    {
      'question':
          'What should I do if the system is not responding or showing incorrect data?',
      'answer': '''
1. Check your internet connection and ensure it's stable.
2. Restart the app to refresh the system.
3. Contact the admin if the issue persists.
  '''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teacher Help & Support',
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
