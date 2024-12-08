import 'package:book_discovery_app/splash.dart';
import 'package:flutter/material.dart';
import 'home.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(BookDiscoveryApp());
}

class BookDiscoveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Discovery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePage(),
      home: SplashScreen(),
    );
  }
}



