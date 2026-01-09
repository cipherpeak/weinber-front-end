import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Model/homepage_response.dart';
import '../Widgets/announcement_section_widget.dart';
import '../Widgets/attendace_card_full_section.dart';
import '../Widgets/break_timer_widget_homepage.dart';
import '../Widgets/break_widget.dart';
import '../Widgets/greetingWidget.dart';
import '../Widgets/ongoing task widget Homepage.dart';
import '../Widgets/task_section_widget.dart';


/// =====================================================
/// MOCK HOME PROVIDER (NO API)
/// =====================================================
final homeNotifierProvider = Provider<HomeResponse>((ref) {
  return HomeResponse(
    name: "John Doe",
    role: "Field Executive",
    employeeType: "Permanent",
    notificationCount: 3,
    ongoingTask: true,

    ongoingTasks: [
      OngoingTask(
        heading: "Example task",
        status: "In Progress",
        address: "Al Nahda, Dubai",
        taskAssignTime: "09:30 AM",
        percentageCompleted: 60,
      ),
      // OngoingTask(
      //   heading: "Stock Verification",
      //   status: "Pending",
      //   address: "Karama Store #21",
      //   taskAssignTime: "11:00 AM",
      //   percentageCompleted: 0,
      // ),
    ],

    /// ✅ KEEP CHECK-IN / CHECK-OUT STRUCTURE
    statusOfCheck: "Checked In",
    checkInOutTime: CheckInOut(
      checkIn: CheckTime(
        time: "09:05 AM",
        timeZone: "GST",
        location: "Al Nahda",
      ),
      checkOut: CheckTime(
        time: null,
        timeZone: null,
        location: null,
      ),
    ),

    totalTasksToday: 3,

    tasks: [
      Task(
        type: "Task 1 ",
        heading: "Example task title",
        details: "Near Union Coop, Karama",
        time: "12:00 PM",
      ),
      // Task(
      //   type: "Collection",
      //   heading: "Collect Payment",
      //   details: "Store #14 – AED 1,200",
      //   time: "02:00 PM",
      // ),
      Task(
        type: "Task 2",
        heading: "Example task title",
        details: "Daily sales summary",
        time: "05:30 PM",
      ),
    ],

    announcements: [
      Announcement(
        id: 1,
        heading: "Monthly Meeting",
        description: "Company-wide meeting on Friday at 10 AM",
        date: "10 July 2025",
      ),
      Announcement(
        id: 2,
        heading: "Salary Credited",
        description: "June salary has been credited successfully",
        date: "05 July 2025",
      ),
    ],
  );
});

/// =====================================================
/// HOMEPAGE SCREEN
/// =====================================================
class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeNotifierProvider);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// =================================================
            /// GREETING + ATTENDANCE SECTION
            /// =================================================
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
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// 🟢 NAME FROM MODEL
                  GreetingWidget(name: home.name),

                  /// 🟢 ONGOING TASKS
                  OngoingTaskWidgetHomepage(
                    tasks: home.ongoingTasks,
                  ),

                  const SizedBox(height: 20),

                  /// 🟢 CHECK IN / CHECK OUT (REAL STRUCTURE)
                  AttendanceCardSection(
                    status: home.statusOfCheck,
                    checkInOut: home.checkInOutTime,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// =================================================
            /// BREAK SECTION (DUMMY)
            /// =================================================
            BreakTimerWidget(
              breakType: "Lunch Break",
              durationInMinutes: 30,
              onExtendBreak: () {},
              onEndBreak: () {},
            ),

            const BreakHistoryCard(
              totalBreakTime: '0h 28m',
              extendedBreaks: 2,
            ),

            const SizedBox(height: 15),

            /// =================================================
            /// TASK SECTION
            /// =================================================
            TaskSectionWidget(
              tasks: home.tasks,
            ),

            const SizedBox(height: 10),

            /// =================================================
            /// ANNOUNCEMENTS
            /// =================================================
            AnnouncementSectionWidget(
              announcements: home.announcements,
            ),
          ],
        ),
      ),
    );
  }
}
