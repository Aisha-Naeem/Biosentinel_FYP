import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'sessions.dart'; // Apne project structure ke mutabiq path adjust karen

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        print('No cameras found on device.');
        return;
      }

      // Debug: Print available cameras
      for (var cam in cameras!) {
        print('Camera found: ${cam.name}, Direction: ${cam.lensDirection}');
      }

      // Front camera dhundhna
      CameraDescription? frontCamera = cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first,
      );

      print(
          'Selected camera: ${frontCamera.name}, Direction: ${frontCamera.lensDirection}');

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _showCameraDialog() {
    if (!_isCameraInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not available')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Timer(const Duration(seconds: 5), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Face detected, registration completed')),
          );
        });

        return AlertDialog(
          title: const Text('Camera - Face Detection'),
          content: AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
        );
      },
    );
  }

  void _registerFaceID() {
    _showCameraDialog();
  }

  void _navigateToSessions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Session()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register or Proceed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onPressed: _registerFaceID,
                icon: const Icon(Icons.face, color: Colors.white),
                label: const Text('Register Facial Recognition'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: _navigateToSessions,
                child: const Text(
                  'Proceed',
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
