import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../Provider/bottom_nav_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  static const List<String> _tabRoutes = [
    '/app/home',   // index 0
    '/app/task',   // index 1
    '/app/attendance', // index 2 (if you add route)
    '/app/report', // index 3 (if you add route)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: appFont,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            router.go(_tabRoutes[currentIndex]);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- TODAY ---
            const _SectionTitle(title: "TODAY"),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: "You successfully Checked In",
              subtitle: "At 08:15 AM",
              time: "5m ago",
              width: width,
            ),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.assignment_outlined,
              iconColor: Colors.blueAccent,
              title: "Task Started",
              subtitle: "Task ‘Car Wash - Toyota Camry’ Started at 10:00 AM",
              time: "2h ago",
              width: width,
            ),

            const SizedBox(height: 30),

            /// --- THIS WEEK ---
            const _SectionTitle(title: "This Week"),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.check_circle_outline,
              iconColor: Colors.pinkAccent,
              title: "Leave Request Approved",
              subtitle: "Your leave request from November 10–12 has been approved.",
              time: "Yesterday",
              width: width,
            ),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.notifications_none_outlined,
              iconColor: Colors.orangeAccent,
              title: "Reminder",
              subtitle: "Remember to check in before 09:30 AM.",
              time: "3d ago",
              width: width,
            ),

            const SizedBox(height: 30),

            /// --- EARLIER ---
            const _SectionTitle(title: "Earlier"),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.notifications_none_outlined,
              iconColor: Colors.amber,
              title: "You Were Marked as Present",
              subtitle: "For your shift on Mar 28",
              time: "Mar 28",
              width: width,
            ),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: "You successfully Checked In",
              subtitle: "At 08:15 AM",
              time: "Mar 12",
              width: width,
            ),
            const SizedBox(height: 10),
            _notificationTile(
              icon: Icons.assignment_outlined,
              iconColor: Colors.blueAccent,
              title: "Task Started",
              subtitle: "Task ‘Car Wash - Toyota Camry’ Started at 10:00 AM",
              time: "Feb 22",
              width: width,
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }

  /// 🔹 Notification Tile
  Widget _notificationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required double width,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon Section
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),

          /// Content Section (80%)
          SizedBox(
            width: width * 0.53, // roughly 80% excluding icon space
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: appFont,
                    fontSize: 12,
                    color: Color(0xFF8890A6),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

          /// Date/Time Section (20%)
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                time,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontFamily: appFont,
                  fontSize: 12,
                  color: Color(0xFFB0B5C0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Section Title Widget
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        fontFamily: appFont,
        color: Color(0xFF8890A6),
      ),
    );
  }
}
