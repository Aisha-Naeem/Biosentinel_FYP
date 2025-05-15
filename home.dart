// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:ui'; // Import this for the BackdropFilter widget

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          // Upper Portion: 20%
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the text
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center text vertically
                    children: [
                      // Glassmorphism effect applied here
                      BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 12.0,
                            sigmaY: 12.0), // Increased blur for better effect
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            // Applying a more colorful glassmorphism effect
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.blue.withOpacity(0.15),
                                Colors.purple.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(15), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 12,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Text(
                                'Welcome to BioSentinel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      22, // Slightly bigger font size for emphasis
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'A Smart Attendance App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18, // Slightly smaller font size
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Card Portion: 80%
          Expanded(
            child: Container(
              width: double.infinity, // Full width card
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // The 4 Clickable Boxes with Icons
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two boxes per row
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return _buildClickableBox(
                            context,
                            index == 0
                                ? 'Attendance'
                                : index == 1
                                    ? 'Daily Attendance List'
                                    : index == 2
                                        ? 'Enrolled Courses'
                                        : 'Help',
                            index == 0
                                ? Icons.check_circle_outline
                                : index == 1
                                    ? Icons.list_alt
                                    : index == 2
                                        ? Icons.book
                                        : Icons.help_outline,
                            index == 0
                                ? '/attendance' // Changed from '/attendance' to '/registration'
                                : index == 1
                                    ? '/dailyAttendance'
                                    : index == 2
                                        ? '/enrolledCourses'
                                        : '/student_help',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableBox(
    BuildContext context,
    String label,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () {
        try {
          Navigator.pushNamed(context, route);
        } catch (e) {
          log('Navigation error: $e');
          // Show error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Navigation Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue), // Larger icon
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/home', // Home
    '/search', // Search (create this page if needed)
    '/dailyAttendance', // Changed from '/record' to '/dailyAttendance'
    '/notifications', // Notifications (create this page if needed)
    '/search', // Search
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      Navigator.pushNamed(context, _routes[index]);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F), // Header color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Menu icon
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        centerTitle: true,
        title: const Text(
          'BioSentinel',
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontSize: 24,
            color: Colors.white, // White text for the app name
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Tooltip(
            message: 'User Account', // Tooltip message
            child: IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/account');
              },
            ),
          ),
        ],
      ),
      body: const GradientContainer(), // Updated body content
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E3A5F), // Footer color
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD7B67A), // Highlighted item color
        unselectedItemColor: const Color(0xFF8397A3), // Muted item color
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: true, // Show label when selected
        showUnselectedLabels: true, // Show labels for all
        items: const [
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Home', // Tooltip for Home
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Search', // Tooltip for Search
              child: Icon(Icons.search),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Record', // Tooltip for Record
              child: Icon(Icons.receipt),
            ),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Tooltip(
              message: 'Notification', // Tooltip for Notification
              child: Icon(Icons.notifications),
            ),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
