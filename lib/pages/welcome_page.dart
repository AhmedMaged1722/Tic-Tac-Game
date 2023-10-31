import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac/pages/home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start a timer to navigate to the home page after 3 seconds.
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Welcome to TIC TAC',
              speed: const Duration(
                milliseconds: 150,
              ),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'pfa',
              ),
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: false,
          displayFullTextOnTap: true,
          stopPauseOnTap: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer if it is still running.
    _timer?.cancel();

    super.dispose();
  }
}
