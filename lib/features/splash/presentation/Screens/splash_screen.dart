import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../../../Authentication/Login/Presentation/Provider/login_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late Box box;
  @override
  void initState() {
    super.initState();
    initialiseFunctions();
  }
  void initialiseFunctions() async {
    await AuthLocalStorage.instance.init();

    Future.delayed(const Duration(milliseconds: 1200), () async {
      if (!mounted) return;
      ref.read(loginNotifierProvider.notifier).checkIfUserIsLoggedIn();
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
            Icon(
              Icons.flash_on,
              size: 80,
              color: primaryBackgroundColor,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
