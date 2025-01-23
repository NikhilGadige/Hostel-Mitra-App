import 'package:flutter/material.dart';
import 'dart:async';
import 'features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Controller for the animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Text animation control
  String _text = "Hostel Mitra";
  String _displayedText = "";

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale animation (logo will start small and scale up)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Fade animation (logo will fade in)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start the image animation
    _controller.forward();

    // Delay for the text typing animation
    Future.delayed(const Duration(seconds: 2), () {
      _startTypingAnimation();
    });

    // Navigate to the next screen after the splash duration
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  void _startTypingAnimation() {
    // Delayed typing effect
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_displayedText.length < _text.length) {
          _displayedText = _text.substring(0, _displayedText.length + 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 195, 167, 1.0), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated widget: scales and fades the image
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/img.png', // Path to your image asset
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space below the image

            // Typewriter effect for the text
            // Text(
            //   _displayedText, // Displays progressively the text "Hostel Mitra"
            //   style: const TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.w500,
            //     color: Color.fromRGBO(5, 79, 43, 1.0),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}