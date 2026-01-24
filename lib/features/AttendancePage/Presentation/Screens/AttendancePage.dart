import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/features/AttendancePage/Api/attendance_repo.dart';
import '../../Model/attendance_day_details_model.dart';
import '../../Model/attendance_monthly_model.dart';
import '../Widgets/check_in_out_card.dart';
import '../Widgets/percentageIndicatorSemi.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();
  bool showMonthlyReview = false;

  final repo = AttendanceRepositoryReview();

  MonthlyReviewResponse? monthlyData;
  AttendanceDayDetail? dayDetail;

  bool loadingMonthly = true;
  bool loadingDay = false;

  @override
  void initState() {
    super.initState();
    _loadMonthly();
    _loadAttendanceByDate(selectedDate); // 🔥 load today by default
  }

  // ================= API CALLS =================

  Future<void> _loadMonthly() async {
    try {
      final res = await repo.fetchMonthlyReview();
      if (!mounted) return;

      setState(() {
        monthlyData = res;
        loadingMonthly = false;
      });
    } catch (e) {
      loadingMonthly = false;
      debugPrint(e.toString());
    }
  }

  Future<void> _loadAttendanceByDate(DateTime date) async {
    setState(() => loadingDay = true);

    try {
      final res = await repo.fetchAttendanceByDate(
        date: date.day,
        month: date.month,
        year: date.year,
      );

      if (!mounted) return;

      setState(() {
        dayDetail = res;
        loadingDay = false;
      });
    } catch (e) {
      loadingDay = false;
      debugPrint(e.toString());
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _monthlyToggle(),

              ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: showMonthlyReview
                      ? _buildMonthlyReviewSection()
                      : const SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 25),

              _calendar(),

              const SizedBox(height: 20),

              _attendanceList(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MONTHLY TOGGLE =================

  Widget _monthlyToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showMonthlyReview = !showMonthlyReview;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                showMonthlyReview ? "Hide Monthly Review" : "View Monthly Review",
                style: TextStyle(
                  fontFamily: appFont,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            AnimatedRotation(
              turns: showMonthlyReview ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 26, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CALENDAR =================

  Widget _calendar() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: EasyDateTimeLine(
        initialDate: selectedDate,
        onDateChange: (date) {
          setState(() => selectedDate = date);
          _loadAttendanceByDate(date); // 🔥 API call
        },
        activeColor: primaryColor,

        headerProps: EasyHeaderProps(
          selectedDateFormat: SelectedDateFormat.fullDateDMY,
          selectedDateStyle: TextStyle(
            fontFamily: appFont,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          height: 70,

          todayStyle: DayStyle(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(40),
            ),
            dayNumStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            dayStrStyle: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(40),
            ),
            dayNumStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            dayStrStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),

          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            dayNumStyle: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            dayStrStyle: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ================= ATTENDANCE LIST =================

  Widget _attendanceList() {
    if (loadingDay) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dayDetail == null || dayDetail!.history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text("No attendance data")),
      );
    }

    // ✅ COPY + SORT (latest first)
    final sortedHistory = List.of(dayDetail!.history);

    sortedHistory.sort((a, b) {
      try {
        final t1 = _parseTime(a.time);
        final t2 = _parseTime(b.time);
        return t2.compareTo(t1); // 🔥 DESCENDING
      } catch (_) {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: sortedHistory.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final h = sortedHistory[index];

        return checkInOutCard({
          "time": h.time,
          "title": h.type == "in" ? "Checked In" : "Checked Out",
          "reason": h.reason,
          "location": h.location,
        });
      },
    );
  }

  DateTime _parseTime(String time) {
    // supports "18:00" or "18:00:00"
    final parts = time.split(":");

    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }



  // ================= MONTHLY REVIEW =================

  Widget _buildMonthlyReviewSection() {
    if (loadingMonthly) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (monthlyData == null) {
      return const SizedBox();
    }

    final m = monthlyData!;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF6F8FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${m.currentMonthName.toUpperCase()} ${m.currentYear}",
              style: TextStyle(
                fontFamily: appFont,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 15),

            Center(
              child: SemiCircularProgress(
                progress: m.monthlyProgressPercentage / 100,
                gradientColors: const [
                  Color(0xFF5563DE),
                  Color(0xFF00C6FB),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              childAspectRatio: 2,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildStatCard("Total Days Present", m.totalDaysPresent.toString(), const Color(0xFF4A5CF0)),
                _buildStatCard("Leave Taken", m.leaveTaken.toString(), Colors.red),
                _buildStatCard("Tasks Completed", m.tasksCompleted.toString(), const Color(0xFF00C853)),
                _buildStatCard("Pending Tasks", m.pendingTasks.toString(), const Color(0xFFFFA000)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 14,
                color: Colors.grey[700],
              )),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: color,
              )),
        ],
      ),
    );
  }
}
