import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart';
import 'select_option.dart'; // Import your select_options.dart file here

class Session extends StatefulWidget {
  const Session({super.key});
  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  List<Map<String, dynamic>> sessions = [];
  bool _isProcessing = false; // Is processing bluetooth scan
  String? _processingSessionUUID; // Which session is processing

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    try {
      final response = await http.get(Uri.parse(ApiRoutes.sessions));
      if (response.statusCode == 200) {
        final List sessionsData = jsonDecode(response.body);
        setState(() {
          sessions = sessionsData.map((session) {
            return Map<String, dynamic>.from(session);
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching sessions: $e');
    }
  }

  String _getSessionStatus(Map<String, dynamic> session) {
    try {
      final now = DateTime.now();
      final startTime = DateTime.parse(session['start_time']).toLocal();
      final endTime = startTime.add(
        Duration(minutes: int.parse(session['duration_minutes'].toString())),
      );
      return now.isBefore(endTime) ? 'Active' : 'Expired';
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    return status == 'Active' ? Colors.green : Colors.red;
  }

  void _onSessionTap(Map<String, dynamic> session) async {
    if (_isProcessing) {
      // Already processing another session
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait, scanning in progress...')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _processingSessionUUID = session['session_uuid'] ?? 'Unknown UUID';
    });

    debugPrint('Scanning for the Bluetooth signals...');
    // scanning time - 5 seconds
    await Future.delayed(const Duration(seconds: 10));
    debugPrint('Signal received for session UUID: $_processingSessionUUID');

    setState(() {
      _isProcessing = false;
      _processingSessionUUID = null;
    });

    // Navigate to RoleSelectionPage after scan complete
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleSelectionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: sessions.isEmpty
          ? const Center(child: Text('No sessions available.'))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                final startTime =
                    DateTime.parse(session['start_time']).toLocal();
                final formattedTime =
                    TimeOfDay.fromDateTime(startTime).format(context);
                final formattedDate =
                    '${startTime.year}-${startTime.month.toString().padLeft(2, '0')}-${startTime.day.toString().padLeft(2, '0')}';

                final status = _getSessionStatus(session);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Date: $formattedDate, Time: $formattedTime'),
                    subtitle: Row(
                      children: [
                        Text('Duration: ${session['duration_minutes']} min'),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    enabled: status == 'Active' && !_isProcessing,
                    onTap: status == 'Active' && !_isProcessing
                        ? () => _onSessionTap(session)
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
