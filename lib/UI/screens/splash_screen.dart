import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chuyển sang màn hình Home sau 3 giây
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF1),
      body: Stack(
        children: [
          // Logo ở giữa màn hình
          Center(
            child: Image.asset(
              'assets/logo.png',
              height: 260,
              width: 260,
            ),
          ),

          // Text "iFarm" ở cuối màn hình
          Positioned(
            bottom: 40, // Cách bottom 40px
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'iFarm',
                style: TextStyle(
                  fontFamily: 'Fuzzy Bubbles',
                  fontWeight: FontWeight.w700,
                  fontSize: 60,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Color(0xFF00C788),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
