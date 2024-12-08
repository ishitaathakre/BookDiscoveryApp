import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart'; // Import your HomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Navigate to home screen after a delay
  void _navigateToHome() {
    Timer(Duration(seconds: 3), () {
      // After 3 seconds, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, 
      body: Center(
        child: Text(
          'Book Discovery App', 
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Allura',
            // fontFamily: 'GreatVibes',

          ),
        ),
      ),
    );
  }
}
