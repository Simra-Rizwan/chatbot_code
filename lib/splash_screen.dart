import 'dart:async';
import 'package:custfyp/widgets/animation.dart';
import 'package:flutter/material.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to FirstScreen after a 3-second delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        Navigation.navigate(const AuthGate()),
        // MaterialPageRoute(
        //   builder: (context) => const AuthGate(),
        // ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F00FF),
              Color(0xFFE100FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Teacher\'s Pet!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.white, // Text color
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white), // Indicator color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
