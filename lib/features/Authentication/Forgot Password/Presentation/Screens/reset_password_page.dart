import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.03),

              /// 🔹 Title
              const Text(
                'Set a New Password',
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              /// 🔹 Subtitle
              const Text(
                "Create a new password. Make sure it's strong and something you can remember.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: appFont,
                  fontSize: 13,
                  color: Color(0xFF8890A6),
                ),
              ),

              SizedBox(height: height * 0.05),

              /// 🔹 New Password Field
              TextField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: appFont,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8890A6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () => setState(() => obscureNew = !obscureNew),
                  ),
                  hintText: 'Enter your new password here',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                    fontFamily: appFont,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryColor, width: 1.6),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// 🔹 Confirm Password Field
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: appFont,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8890A6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                  ),
                  hintText: 'Re-enter your password here',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                    fontFamily: appFont,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: primaryColor, width: 1.6),
                  ),
                ),
              ),

              SizedBox(height: height * 0.08),

              /// 🔹 Reset Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (newPasswordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (newPasswordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    // ✅ Navigate to Success Page
                    context.push(routerPasswordResetSuccessPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B7CFE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: appFont,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Reset Password'),
                ),
              ),

              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
