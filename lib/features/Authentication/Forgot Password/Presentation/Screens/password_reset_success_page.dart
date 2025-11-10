import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';

class PasswordResetSuccessScreen extends StatefulWidget {
  const PasswordResetSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetSuccessScreen> createState() => _PasswordResetSuccessScreenState();
}

class _PasswordResetSuccessScreenState extends State<PasswordResetSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 🔹 Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // 🔹 Scale animation (zoom in)
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // 🔹 Fade animation (opacity)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Start the animation when screen appears
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/logos/password_reset_success.png',
                  height: height * 0.25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: height * 0.04),
            const Text(
              'Password Reset Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: appFont,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can now log in with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontFamily: appFont,
              ),
            ),
            SizedBox(height: height * 0.06),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go(routerLoginPage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: appFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
