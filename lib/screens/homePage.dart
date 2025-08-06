import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/userModel.dart';
import '../services/authService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  String _firstName = '';

  Future<void> _loadUserData() async {
    try {
      if (_authService.currentUser != null) {
        UserModel? userData = await _authService.getUserData(_authService.currentUser!.uid);
        setState(() {
          _currentUser = userData;
          if (userData?.fullName != null && userData!.fullName.isNotEmpty) {
            _firstName = userData.fullName.split(' ').first;
          }
        });
      }
    } catch (e) {
      print('Error loading user data: ${e.toString()}');
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2F4771),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFF3D69B)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first
                try {
                  await _authService.signOut();
                  Get.offNamed('/Login');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error logging out'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2F4771),
        appBar: AppBar(
          backgroundColor: const Color(0xFF122247),
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color(0xFFF3D69B),
                size: 24,
              ),
              onPressed: _handleLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading state
                if (_currentUser == null)
                  const CircularProgressIndicator(
                    color: Color(0xFFF3D69B),
                  )
                else
                // Greeting with first name
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _firstName.isNotEmpty ? 'Hi $_firstName!, You’re successfully logged in' : 'Hi There!',
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 20),

                // Welcome message
                if (_currentUser != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Welcome to your dashboard!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
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