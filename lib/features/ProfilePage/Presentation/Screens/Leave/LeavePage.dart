import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';

import '../../../../../core/constants/page_routes.dart';
import '../../../Api/leave_repo.dart';
import '../../../Model/leave_response_model.dart';


class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final LeaveRepository _repo = LeaveRepository();

  LeaveResponse? leaveData;
  bool isLoading = true;
  bool showRequests = true;

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    try {
      final res = await _repo.fetchLeaves();
      setState(() {
        leaveData = res;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Leave", style: TextStyle(color: Colors.black)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildUI(),
      floatingActionButton: SizedBox(height: 45,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: primaryColor,
          onPressed: () async {
            final res = await router.push(routerLeaveApplyPage);
            if (res == true) {
              _loadLeaves(); // refresh leave list
            }
          },

          label: const Text("Apply Leave", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
          icon: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }

  Widget _buildUI() {
    final data = leaveData!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _topCard(data),

          const SizedBox(height: 20),

          _tabBar(),

          const SizedBox(height: 15),

          ...(showRequests ? data.leaveRequests : data.leaveHistory)
              .map((e) => _leaveCard(e))
              .toList(),

          if ((showRequests ? data.leaveRequests : data.leaveHistory).isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text("No leaves found",
                    style: TextStyle(color: Colors.black45)),
              ),
            ),
        ],
      ),
    );
  }

  // ================= TOP CARD =================

  Widget _topCard(LeaveResponse data) {
    final percent = data.usedVacationDays / data.totalVacationDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF4F7FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 95,
                width: 95,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 11,
                  backgroundColor: Colors.grey.shade200,
                  color: primaryColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${data.daysLeft}",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Days Left",
                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statRow(
                  icon: Icons.calendar_month_outlined,
                  bg: const Color(0xFFFFF1DD),
                  iconColor: const Color(0xFFF4A261),
                  title: "Leave taken this month",
                  value: data.leaveTakenThisMonth.toString(),
                ),
                const SizedBox(height: 14),
                _statRow(
                  icon: Icons.event_available_outlined,
                  bg: const Color(0xFFE8F6FF),
                  iconColor: const Color(0xFF4A90E2),
                  title: "Annual leave taken",
                  value: data.annualLeaveTaken.toString(),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Used ${data.usedVacationDays}/${data.totalVacationDays} days",
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statRow({
    required IconData icon,
    required Color bg,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        )
      ],
    );
  }


  // ================= TAB BAR =================
  Widget _tabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _tab("Leave Requests", showRequests, () {
              setState(() => showRequests = true);
            }),
            const SizedBox(width: 25),
            _tab("Leave History", !showRequests, () {
              setState(() => showRequests = false);
            }),
          ],
        ),
        const SizedBox(height: 6),
        Divider(color: Colors.grey.shade200),
      ],
    );
  }


  Widget _tab(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: active ? primaryColor : Colors.black38,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: active ? 100 : 0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
          )
        ],
      ),
    );
  }


  // ================= LEAVE CARD =================

  Widget _leaveCard(LeaveItem item) {
    final color = item.status == "approved"
        ? const Color(0xFF5ED18F)
        : item.status == "pending"
        ? const Color(0xFFFFC764)
        : Colors.redAccent;

    return GestureDetector(
      onTap: () {
        router.push(routerLeaveDetailsPage, extra: item.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.reason,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.status.capitalize(),
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.startDate,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.black38)
          ],
        ),
      ),
    );
  }

}
extension Cap on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}