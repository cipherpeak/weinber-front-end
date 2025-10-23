import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/constants/page_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      if (!mounted) return;
      if (await AuthService.instance.isLoggedIn()) {
        context.go(routerHomePage);
      } else {
        context.go(routerLoginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6C9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Replace with your logo widget as needed
            Icon(Icons.flash_on, size: 80, color: primaryColor),
            SizedBox(height: 20),
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
