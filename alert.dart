import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white), // Text color set to white
        ),
        backgroundColor: const Color(0xFF1E3A5F), // Deep Blue for AppBar
        iconTheme: const IconThemeData(color: Colors.white), // Back icon set to white
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A5F), // Deep Blue
              Color(0xFF664E8C), // Soft Purple
              Color(0xFF56C6B9), // Teal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      message: 'Attendance for "Data Structures" has been uploaded successfully.',
                      timeAgo: '10 minutes ago',
                    ),
                    _buildNotificationCard(
                      message: 'Your lecture for "Artificial Intelligence" is scheduled for tomorrow at 9:00 AM.',
                      timeAgo: '1 hour ago',
                    ),
                    _buildNotificationCard(
                      message: 'Attendance for "Operating Systems" has been recorded successfully.',
                      timeAgo: '3 hours ago',
                    ),
                    _buildNotificationCard(
                      message: 'Weekly attendance report for "Machine Learning" is ready to review.',
                      timeAgo: '2 days ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({required String message, required String timeAgo}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(
          Icons.notifications,
          color: Color(0xFF1E3A5F), // Deep Blue for the icon
          size: 30,
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A5F), // Deep Blue for the text
          ),
        ),
        subtitle: Text(
          timeAgo,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
