import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  // PUBLIC_INTERFACE
  /// Minimal profile screen placeholder.
  ///
  /// This screen exists because Settings navigates to it. The original project
  /// referenced it, but the file was missing, causing build/analyzer failures.
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'User profile coming soon.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
