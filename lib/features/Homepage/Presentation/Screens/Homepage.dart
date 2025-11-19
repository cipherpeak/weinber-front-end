import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Provider/home_notifier.dart';
import '../Widgets/announcement_section_widget.dart';
import '../Widgets/attendace_card_full_section.dart';
import '../Widgets/break_timer_widget_homepage.dart';
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
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final homeState = ref.watch(homeNotifierProvider);

    return homeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error: $e")),
      data: (home) {
        if (home == null) {
          return const Center(child: Text("No data found"));
        }

        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      /// 🟢 PASS VALUE TO GREETING WIDGET
                      GreetingWidget(name: home.name),

                      /// 🟢 PASS ONGOING TASKS
                      OngoingTaskWidgetHomepage(tasks: home.ongoingTasks),

                      const SizedBox(height: 20),

                      /// 🟢 PASS ATTENDANCE STATUS
                      AttendanceCardSection(
                        status: home.statusOfCheck,
                        checkInOut: home.checkInOutTime,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BreakTimerWidget(
                  breakType: "Lunch Break",
                  durationInMinutes: 1,
                  onExtendBreak: () {},
                  onEndBreak: () {},
                ),

                const BreakHistoryCard(
                  totalBreakTime: '0h 28m',
                  extendedBreaks: 2,
                ),

                const SizedBox(height: 15),

                /// 🟢 PASS TASKS
                TaskSectionWidget(tasks: home.tasks),

                const SizedBox(height: 10),

                /// 🟢 PASS ANNOUNCEMENTS
                AnnouncementSectionWidget(
                  announcements: home.announcements,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
