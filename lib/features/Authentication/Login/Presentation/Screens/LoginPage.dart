import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../Provider/login_notifier.dart';
import '../Provider/login_provider.dart' hide loginNotifierProvider;

class LoginPage extends ConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final loginState = ref.watch(loginNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.13),

              /// LOGO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.05),

              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              const Text(
                'Enter your login information',
                style: TextStyle(fontSize: 15, color: Color(0xFF8890A6)),
              ),

              SizedBox(height: screenHeight * 0.04),

              /// USERNAME
              SizedBox(
                height: screenHeight * 0.055,
                child: TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    labelStyle: const TextStyle(fontSize: 13),
                    hintText: 'Enter your username here',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8890A6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// PASSWORD
              SizedBox(
                height: screenHeight * 0.055,
                child: TextField(
                  controller: passController,
                  obscureText: !ref.watch(passwordVisibilityProvider),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontSize: 13),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8890A6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ref.watch(passwordVisibilityProvider)
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      onPressed: () {
                        ref.read(passwordVisibilityProvider.notifier).state =
                        !ref.read(passwordVisibilityProvider.notifier).state;
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => router.go(routerForgotPassword),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.08),

              /// LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.055,
                child: ElevatedButton(
                  onPressed: loginState.isLoading
                      ? null
                      : () {
                          final employeeId = userController.text.trim();
                          final password = passController.text.trim();
                          ref
                              .read(loginNotifierProvider.notifier)
                              .login(
                                employeeId: employeeId,
                                password: password,
                                context: context,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7CFE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: loginState.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text('Login'),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// SUPPORT SECTION
              Text.rich(
                TextSpan(
                  text: 'Need access or facing login issues? \t',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => _showSupportBottomSheet(context),
                        child: const Text(
                          'Contact Support.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B7CFE),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  /// SUPPORT BOTTOM SHEET
  void _showSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Need Support?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: appFont,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "We’re here to support you anytime.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8890A6),
                  fontFamily: appFont,
                ),
              ),
              const SizedBox(height: 24),

              _supportOptionTile(
                context,
                icon: Icons.chat_bubble_outline,
                color: iconOrange,
                title: "Chat With Us",
                subtitle: "Chat with our agents to fix the issue",
                onTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),
              _supportOptionTile(
                context,
                icon: Icons.call_outlined,
                color: iconGreen,
                title: "Call Us",
                subtitle: "Available from 09:00 AM to 05:00 PM",
                onTap: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),
              _supportOptionTile(
                context,
                icon: Icons.email_outlined,
                color: iconPink,
                title: "Email Support",
                subtitle: "We’ll get back to you within 24 hours",
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _supportOptionTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: appFont,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8890A6),
                      fontFamily: appFont,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
