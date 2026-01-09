import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';
import 'package:weinber/features/ProfilePage/Presentation/Widgets/profile_header_section.dart';

import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../../Api/profile_api.dart';
import '../../Model/profile_api_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // 🔹 Hardcoded Profile Data (matches your model exactly)
  ProfileResponse? profile;
  bool isLoading = true;
  String? error;
  final ProfileRepository _repo = ProfileRepository();

  final List<Map<String, dynamic>> options = [
    {
      'title': 'Employee Information',
      'icon': Icons.work_outline,
      'color': Colors.orange.shade100,
    },
    {
      'title': 'Personal Information',
      'icon': Icons.person_outline,
      'color': Colors.purple.shade100,
    },
    {
      'title': 'Visa & Document Details',
      'icon': Icons.article_outlined,
      'color': Colors.green.shade100,
    },
    {
      'title': 'Vehicle Details',
      'icon': Icons.directions_car_outlined,
      'color': Colors.blue.shade100,
    },
    {
      'title': 'Settings',
      'icon': Icons.settings_outlined,
      'color': Colors.yellow.shade100,
    },
  ];

  @override
  void initState() {
    super.initState();
    initializeFunctions();
  }

 void initializeFunctions()async{
   await _loadProfile();

 }
  Future<void> _loadProfile() async {
    try {
      final res = await _repo.fetchProfile();
      setState(() {
        profile = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load profile";
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Your Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // 🔹 Profile Header
          ProfileHeaderSection(profile: profile),

          const SizedBox(height: 20),

          // 🔹 Leave Management
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.red.shade100, width: .2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_month_outlined,
                      color: Colors.black87, size: 20),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Leave Management",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black45, size: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ADDITIONAL SETTINGS",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Options List
          ...options.map((item) {
            return GestureDetector(
              onTap: () {
                switch (item['title']) {
                  case 'Employee Information':
                    router.push(routerEmployeeInformationPage);
                    break;
                  case 'Personal Information':
                    router.push(routerPersonalInformationPage);
                    break;
                  case 'Visa & Document Details':
                    router.push(routerVisaAndDocumentPage);
                    break;
                  case 'Vehicle Details':
                    router.push(routerVehicleDetailsPage);
                    break;
                  case 'Settings':
                    router.push(routerSettingsPage);
                    break;
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: item['color'] as Color,
                      child: Icon(
                        item['icon'] as IconData,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black45, size: 16),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 30),

          // 🔹 Logout
          GestureDetector(
            onTap: () async {
              // 1️⃣ Clear all local auth data
              await AuthLocalStorage.instance.clear();

              // 2️⃣ Navigate to login (replace stack)
              router.go(routerLoginPage);
              // ref.invalidateAll(); //

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully"),
                ),
              );
            },

            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
