import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/announcement_section_widget.dart';
import '../Widgets/attendace_card_full_section.dart';
import '../Widgets/break_widget.dart';
import '../Widgets/greetingWidget.dart';
import '../Widgets/ongoing task widget Homepage.dart';
import '../Widgets/task_section_widget.dart';


class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Greeting & Attendance Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF0F6FF), Color(0xFFF8FAFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GreetingWidget,
                  const OngoingTaskWidgetHomepage(),
                  const SizedBox(height: 20),
                  AttendanceCardSection(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// Break History Section
            const BreakHistoryCard(
              totalBreakTime: '0h 28m',
              extendedBreaks: 2,
            ),

            const SizedBox(height: 15),

            /// Tasks Section
            const TaskSectionWidget(),

            const SizedBox(height: 10),

            /// Announcements Section
            const AnnouncementSectionWidget(),
          ],
        ),
      ),
    );
  }
}
