import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo Row
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logos/logo.png',
                      height: 80,
                      width: 195,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              // Login title
              const Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'Enter your login information',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8890A6),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Username/Email Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Enter your userID here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 18),
              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'enter your password here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
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
                      color: Color(0xFF5B7CFE),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Login button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {/* TODO: Implement */},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7CFE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16),
              // Support text
              Text.rich(
                TextSpan(
                  text: 'Need access or facing login issues? ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {/* TODO: Contact support action */},
                        child: const Text(
                          'Contact Support.',
                          style: TextStyle(
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

