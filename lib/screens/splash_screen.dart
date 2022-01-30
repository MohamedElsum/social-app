import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/iii.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Positioned(
              child: Image.asset(
                'assets/images/insta.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
