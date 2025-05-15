import 'package:flutter/material.dart';

class EnterCourseCode extends StatefulWidget {
  const EnterCourseCode({super.key});

  @override
  State<EnterCourseCode> createState() => _EnterCourseCodeState();
}

class _EnterCourseCodeState extends State<EnterCourseCode> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _instructorController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Course Code',
          style: TextStyle(color: Colors.white), // Header text color set to white
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back icon color set to white
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school, // Replaced with a better education-themed icon
                  size: 80,
                  color: Color(0xFF1E3A5F),
                ),
                const SizedBox(height: 20), // Spacing below the icon
                const Text(
                  'Enter the course details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Course Code Input Field
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Course Code',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your course code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Course Name Input Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the course name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Instructor Input Field
                TextFormField(
                  controller: _instructorController,
                  decoration: const InputDecoration(
                    labelText: 'Instructor',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the instructor name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter instructor name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Enroll Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A5F),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded edges for the button
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Pop-up Message for Successful Enrollment
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You enrolled successfully!'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Return course data
                        Navigator.pop(context, {
                          'courseCode': _codeController.text,
                          'courseName': _nameController.text,
                          'instructor': _instructorController.text,
                        });

                        // Clear the form after successful submission
                        _codeController.clear();
                        _nameController.clear();
                        _instructorController.clear();
                      }
                    },
                    child: const Text(
                      'Enroll',
                      style: TextStyle(color: Colors.white), // Button text color set to white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
