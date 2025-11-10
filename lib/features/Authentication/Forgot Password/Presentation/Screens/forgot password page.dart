import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../../core/constants/page_routes.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.08),
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Enter the email associated with your account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: height * 0.06),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon:  Icon(Icons.email_outlined, color: Colors.grey.shade400,),
                  hintText: 'Enter your email here',
                  hintStyle:  TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(30),
                  //   borderSide: BorderSide(
                  //     color: primaryColor, // Normal border color
                  //     width: 1.2,
                  //   ),
                  // ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.push(routerOtpVerificationPage);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7CFE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                ),
                child: const Text('Send OTP', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold
                ),),
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}
