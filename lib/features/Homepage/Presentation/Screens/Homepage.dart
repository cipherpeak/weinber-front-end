import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/page_routes.dart';
import '../../../../utils/Common Functions/getTaskPageRoute.dart';
import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../../Api/takeABreakRepo.dart';
import '../../Database/breakLocal.dart';
import '../../Model/homepage_response.dart';
import '../Provider/home_notifier.dart';
import '../Widgets/announcement_section_widget.dart';
import '../Widgets/attendace_card_full_section.dart';
import '../Widgets/break_timer_widget_homepage.dart';
import '../Widgets/break_widget.dart';
import '../Widgets/greetingWidget.dart';
import '../Widgets/ongoing task widget Homepage.dart';
import '../Widgets/task_section_widget.dart';

/// =====================================================
/// HOMEPAGE SCREEN
/// =====================================================
class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<HomepageScreen> {
  String taskRoutePage = '';

  @override
  void initState() {
initializeFunctions();
    super.initState();
  }

  void initializeFunctions() async {
    var local = AuthLocalStorage.instance;
    await local.init();

    var company = local.getCompany();
    var employeeType = local.getEmployeeType();

    setState(() {
      taskRoutePage = getTaskRoute(employeeType, company);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    int selectedExtendMinutes = 5;

    return SafeArea(
      bottom: false,
      child: homeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Failed to load homepage"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
        data: (home) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// GREETING + ATTENDANCE
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF0F6FF), Color(0xFFF8FAFF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 22,
                  ),
                  child: Column(
                    children: [
                      GreetingWidget(name: home.name ?? "Employee"),


                      ///Ongoing task
                      GestureDetector(
                        onTap: () {
                          router.go(taskRoutePage);
                          ref.read(bottomNavProvider.notifier).changeIndex(1);
                        },
                        child: OngoingTaskWidgetHomepage(
                          tasks: home.ongoingTasks,
                        ),
                      ),

                      const SizedBox(height: 20),

                      AttendanceCardSection(
                        status: home.statusOfCheck,
                        checkInOut: home.checkInOutTime,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔴 BREAK (later API)
                // if (home.breakTimer != null)
                if (BreakLocalStorage.hasBreak())
                  BreakTimerWidget(
                    onExtendBreak: () async {
                      final minutes = await _showExtendPicker(context);
                      if (minutes == null) return;

                      final repo = BreakRepository();
                      final now = DateTime.now();

                      try {
                        final date =
                            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                        await repo.extendBreak(
                          date: date,
                          location: "UAE",
                          extraMinutes: minutes,
                        );

                        await BreakLocalStorage.extendLocalBreak(minutes);

                        ref.read(homeNotifierProvider.notifier).refresh();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Break extended by $minutes minutes"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },

                    onEndBreak: () async {
                      final repo = BreakRepository();
                      final now = DateTime.now();

                      try {
                        await repo.endBreak(
                          date:
                              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
                          time:
                              "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00",
                          location: "UAE",
                          reason: "Completed break and ready to work",
                        );

                        await BreakLocalStorage.clear();

                        ref.read(homeNotifierProvider.notifier).refresh();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Break ended successfully"),
                          ),
                        );
                      } catch (e) {
                        debugPrint("❌ END BREAK UI ERROR => $e");

                        final errorMsg = e.toString().replaceFirst(
                          "Exception: ",
                          "",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(errorMsg),
                          ),
                        );
                      }
                    },
                  ),

                if (home.breakHistory != null)
                  BreakHistoryCard(
                    totalBreakTime: home.breakHistory!.totalTime,
                    // extendedBreaks: home.breakHistory!.extendedBreaks,
                  ),

                const SizedBox(height: 15),

                GestureDetector(onTap:(){
                  router.go(taskRoutePage);
                  ref.read(bottomNavProvider.notifier).changeIndex(1);
                },child: TaskSectionWidget(tasks: home.tasks, route: taskRoutePage)),

                const SizedBox(height: 10),

                AnnouncementSectionWidget(announcements: home.announcements),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<int?> _showExtendPicker(BuildContext context) async {
    final values = [5, 10, 15, 20];

    return showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Extend Break",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                "Choose how many minutes to extend",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              ...values.map(
                (e) => ListTile(
                  title: Text(
                    "$e minutes",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Navigator.pop(context, e),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
