import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // ✅ Pin theme customization
    final defaultPinTheme = PinTheme(
      width: width * 0.13,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontFamily: appFont,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 1.6),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: primaryColor),
        color: primaryColor.withOpacity(0.1),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify OTP', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: height * 0.04),
            const Text(
              'Enter One Time Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: appFont,
              ),
            ),
            SizedBox(height: height * 0.02),
            const Text(
              'We have sent the OTP to your email. Please enter it below to verify your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontFamily: appFont),
            ),
            SizedBox(height: height * 0.06),

            /// ✅ Pinput widget
            Pinput(
              controller: otpController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              keyboardType: TextInputType.number,
              showCursor: true,
              autofocus: true,
              cursor: Container(
                height: 22,
                width: 1.5,
                color: primaryColor,
              ),
              onCompleted: (pin) {
                debugPrint('OTP entered: $pin');
              },
            ),

            SizedBox(height: height * 0.06),
            TextButton(
              onPressed: () {
                // TODO: Resend OTP API call
              },
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: appFont,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Verify OTP logic
                  context.push(routerResetPasswordPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: appFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Verify OTP'),
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}
