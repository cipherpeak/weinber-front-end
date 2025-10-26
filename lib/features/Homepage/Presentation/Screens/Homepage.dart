import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/features/Homepage/Presentation/Widgets/attendace_card.dart';

import '../Widgets/announcement_card_widget.dart';
import '../Widgets/task_widget_homepage.dart';

class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👋 Greeting Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6EEFF), Color(0xFFF8FAFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Hello John 👋',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Welcome back to your workspace.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 15),

                // Attendance Status Card for check in
                attendanceCardCheckIn(),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 🧾 Tasks Section
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'You have ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const TextSpan(
                  text: '4 tasks ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text: 'to complete today.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          taskCard(
            icon: Icons.local_car_wash_outlined,
            color: iconBlue,
            title: 'Car Wash – Sedan',
            subtitle: '123 Main Street · 10:00 AM',
          ),
          const SizedBox(height: 10),
          taskCard(
            icon: Icons.cleaning_services_outlined,
            color: iconOrange,
            title: 'Interior Detailing – SUV',
            subtitle: '456 Oak Ave · 10:00 AM',
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'COMPANY ANNOUNCEMENTS',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          announcementCard(
            icon: Icons.campaign_outlined,
            color: iconPink,
            title: 'New Leave Policy Updates',
            date: 'Oct 15, 2025',
          ),
          const SizedBox(height: 10),
          announcementCard(
            icon: Icons.event_note_outlined,
            color: iconOrange,
            title: 'Team Building Event - Oct 20',
            date: 'Oct 14, 2025',
          ),
          const SizedBox(height: 10),
          announcementCard(
            icon: Icons.build_circle_outlined,
            color: iconBlue,
            title: 'System Maintenance Notice',
            date: 'Oct 13, 2025',
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Announcement Card
}
