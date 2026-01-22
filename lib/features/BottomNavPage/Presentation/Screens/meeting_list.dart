import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../Authentication/Login/Model/hive_login_model.dart';

class MeetingNotificationList extends StatefulWidget {
  const MeetingNotificationList({super.key});

  @override
  State<MeetingNotificationList> createState() =>
      _MeetingNotificationListState();
}

class _MeetingNotificationListState extends State<MeetingNotificationList> {
  String? role;
  late AuthLocalStorage _local;

  @override
  void initState() {
    super.initState();
    initializeFunctions();
  }

  Future<void> initializeFunctions() async {
    _local = AuthLocalStorage.instance;
    await _local.init();
    final r = _local.getRole();

    if (!mounted) return;

    setState(() {
      role = r?.toLowerCase();
    });
  }

  bool get isAdmin => role == "admin";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        /// 🔹 Meeting List
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          children: [
            _notificationTile(
              title: "Design Team Bi-Weekly",
              subtitle: "11 December 2025 • 2:30 PM • Office Bay 2",
              time: "Nov 20",
              width: width,
            ),
            _notificationTile(
              title: "Client Review Meeting",
              subtitle: "15 December 2025 • 11:00 AM • Conference Hall",
              time: "Nov 18",
              width: width,
            ),
          ],
        ),

        /// 🔥 Schedule Meeting Button (ADMIN ONLY)
        // if (isAdmin)
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              backgroundColor: primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Schedule Meeting",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: appFont,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                debugPrint("Schedule Meeting clicked");
              },
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------------

  Widget _notificationTile({
    required String title,
    required String subtitle,
    required String time,
    required double width,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: appFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: appFont,
                    fontSize: 12,
                    color: Color(0xFF8890A6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            time,
            style: const TextStyle(
              fontFamily: appFont,
              fontSize: 12,
              color: Color(0xFFB0B5C0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
