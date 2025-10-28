import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weinber/core/constants/constants.dart';
import '../Widgets/check_in_out_card.dart';
import '../Widgets/percentageIndicatorSemi.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  bool showMonthlyReview = false;

  List<Map<String, dynamic>> taskList = [
    {"time": "10:30 AM", "title": "Checked In"},
    {
      "time": "06:30 PM",
      "title": "Checked Out",
      "reason": "Left early for hospital emergency",
    },
  ];

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
              // 🔽 DROPDOWN TILE
              GestureDetector(
                onTap: () {
                  setState(() {
                    showMonthlyReview = !showMonthlyReview;
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

                          showMonthlyReview
                              ? "Hide Monthly Review"
                              : "View Monthly Review",
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
              ),

              // Animated Monthly Review Section
              // Wrap the AnimatedSwitcher with a ClipRect to avoid overflow issues
              ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    // Combine Fade + Size animation
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0, // makes it grow from top
                        child: child,
                      ),
                    );
                  },
                  child: showMonthlyReview
                      ? _buildMonthlyReviewSection()
                      : const SizedBox.shrink(),
                ),
              ),



              const SizedBox(height: 25),

              // Calendar section
              Container(
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
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  activeColor: primaryColor,
                  headerProps: EasyHeaderProps(
                    selectedDateFormat: SelectedDateFormat.fullDateDMY,
                    selectedDateStyle: TextStyle(
                      fontFamily: appFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
              ),

              const SizedBox(height: 20),

              //  Attendance List
              ListView.builder(
                itemCount: taskList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return checkInOutCard(task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Monthly Review Section Widget
  Widget _buildMonthlyReviewSection() {
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MONTHLY REVIEW",
              style: TextStyle(
                fontFamily: appFont,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 15),

            // Progress Indicator
            Center(
              child: SemiCircularProgress(
                progress: 0.76,
                gradientColors: const [
                  Color(0xFF5563DE),
                  Color(0xFF00C6FB),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              childAspectRatio: 2,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildStatCard("Total Days Present", "20", const Color(0xFF4A5CF0)),
                _buildStatCard("Leave Taken", "2", Colors.red),
                _buildStatCard("Tasks Completed", "100", const Color(0xFF00C853)),
                _buildStatCard("Pending Tasks", "8", const Color(0xFFFFA000)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: appFont,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: appFont,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
