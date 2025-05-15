import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  final LocalAuthentication auth = LocalAuthentication();

  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  bool _showResult = false;
  bool _success = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVerificationOptions(context);
    });
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription? frontCamera = cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras!.first,
    );

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
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _showCameraDialog() async {
    if (!_isCameraInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not available')),
      );
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Timer(const Duration(seconds: 3), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return AlertDialog(
          title: const Text('Face Detection'),
          content: AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
        );
      },
    );
  }

  Future<void> _authenticateWithFace() async {
    // Step 1: Show camera (front)
    await _showCameraDialog();

    // Step 2: Show "Face Recognition Failed" for 2 seconds
    setState(() {
      _showResult = true;
      _success = false;
      _statusMessage = 'Face Recognition Failed';
    });
    await Future.delayed(const Duration(seconds: 2));

    // Step 3: Show camera again (front)
    await _showCameraDialog();

    // Step 4: Show success message for 3 seconds
    setState(() {
      _showResult = true;
      _success = true;
      _statusMessage = 'Attendance Marked Successfully';
    });
    await Future.delayed(const Duration(seconds: 3));

    // Step 5: Hide messages
    setState(() {
      _showResult = false;
      _statusMessage = '';
    });
  }

  Future<void> _showVerificationOptions(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must choose
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Verification Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Fingerprint'),
                onTap: () {
                  Navigator.pop(context);
                  // Fingerprint code if any
                },
              ),
              ListTile(
                leading: const Icon(Icons.face),
                title: const Text('Facial Recognition'),
                onTap: () async {
                  Navigator.pop(context);
                  await _authenticateWithFace();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultWidget() {
    if (!_showResult) return const SizedBox.shrink();

    return Center(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _success ? Icons.check_circle : Icons.error,
              color: _success ? Colors.green : Colors.red,
              size: 120,
            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              style: TextStyle(
                color: _success ? Colors.green : Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(''),
          ),
          _buildResultWidget(),
        ],
      ),
    );
  }
}
