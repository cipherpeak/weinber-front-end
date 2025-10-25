import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo Row
              SizedBox(height: screenHeight * 0.13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              // Login title
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // fontFamily: 'Lato',
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Subtitle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'Enter your login information',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8890A6),
                    // fontFamily: 'Lato',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              // Username/Email Field
              SizedBox(
                height: screenHeight * 0.055,
                child: TextField(
                  decoration: InputDecoration(
                    // alignLabelWithHint: true,
                    labelText: 'User ID',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'Enter your username here',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      // fontFamily: 'Lato',
                      color: Color(0xFF8890A6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Password Field
              SizedBox(
                height: screenHeight * 0.055,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 12),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      // fontFamily: 'Lato',
                      color: Color(0xFF8890A6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    /*TODO: Fucntion to implement forgot password */
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      // fontFamily: 'Lato',
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
                  onPressed: () {
                    context.go(routerBottomNav);
                    /* TODO: Implement */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7CFE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'CroissantOne',
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Support text
              Text.rich(
                TextSpan(
                  text: 'Need access or facing login issues? \t',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          /* TODO: Contact support action */
                        },
                        child: const Text(
                          'Contact Support.',
                          style: TextStyle(
                            fontSize: 10,
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
      backgroundColor: Colors.white,
    );
  }
}
