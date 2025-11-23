import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/features/ProfilePage/Model/profile_api_model.dart'; // remove this import if you don't use primaryColor constant

class ProfileHeaderSection extends StatelessWidget {
  final ProfileResponse? profile;

  const ProfileHeaderSection({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [

        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 55),

          padding: const EdgeInsets.only(top: 70, bottom: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
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
                profile!.employeeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                profile!.employeeId,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 3),
              Text(
                profile!.designation,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor, // or Colors.blueAccent
                  fontWeight: FontWeight.w600,
                ),
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
            child: (profile?.profilePic ?? '').isEmpty
                ? CircleAvatar(
                    radius: 52,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  )
                : CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage(profile!.profilePic),
                    onBackgroundImageError: (_, _) {},
                    child: Builder(
                      builder: (context) {
                        return CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
