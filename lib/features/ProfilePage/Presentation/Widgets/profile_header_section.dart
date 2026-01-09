import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/features/ProfilePage/Model/profile_api_model.dart'; // remove this import if you don't use primaryColor constant

class ProfileHeaderSection extends StatelessWidget {
  final ProfileResponse? profile;

  const ProfileHeaderSection({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = profile?.profilePic ?? "";

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [

        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 55),
          padding: const EdgeInsets.only(top: 70, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDCE3FA), Color(0xFFEDF2FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(45),
              topLeft: Radius.circular(45),
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Text(
                profile?.employeeName ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                profile?.employeeId ?? "",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),

        // Floating profile avatar
        Positioned(
          top: 0,
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.grey[200],
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

