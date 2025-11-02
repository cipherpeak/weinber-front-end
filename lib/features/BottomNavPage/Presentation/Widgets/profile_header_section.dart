import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart'; // remove this import if you don't use primaryColor constant

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Background container
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 55), // space for floating avatar
          padding: const EdgeInsets.only(top: 70, bottom: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDCE3FA),
                Color(0xFFEDF2FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(topRight: Radius.circular(45), topLeft: Radius.circular(45), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
          ),
          child: Column(
            children: const [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Employee ID: EMP-00-123',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Car Service Associate',
                style: TextStyle(
                  fontSize: 13,
                  color: primaryColor, // or Colors.blueAccent
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Floating profile avatar
        const Positioned(
          top: 0,
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ),
      ],
    );
  }
}
