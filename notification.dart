import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                      message: 'Your attendance for the course "Data Structures" is marked.',
                      timeAgo: '10 minutes ago',
                    ),
                    _buildNotificationCard(
                      message: 'You have been marked present in "Artificial Intelligence".',
                      timeAgo: '1 hour ago',
                    ),
                    _buildNotificationCard(
                      message: 'Attendance for "Operating Systems" has been recorded.',
                      timeAgo: '3 hours ago',
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
