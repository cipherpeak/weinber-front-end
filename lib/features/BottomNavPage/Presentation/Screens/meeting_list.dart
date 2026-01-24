import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../../Api/meeting_repository.dart';
import '../../Model/meeting_list_model.dart';


class MeetingNotificationList extends StatefulWidget {
  const MeetingNotificationList({super.key});

  @override
  State<MeetingNotificationList> createState() =>
      _MeetingNotificationListState();
}

class _MeetingNotificationListState extends State<MeetingNotificationList> {
  String? role;
  late AuthLocalStorage _local;

  final repo = MeetingRepository();

  bool loading = true;
  List<MeetingModel> meetings = [];

  @override
  void initState() {
    super.initState();
    initializeFunctions();
  }

  Future<void> initializeFunctions() async {
    _local = AuthLocalStorage.instance;
    await _local.init();

    final r = _local.getRole();
    final m = await repo.fetchMeetings();

    // ✅ Sort latest first
    m.sort((a, b) {
      final aDateTime = DateTime.parse("${a.date} ${a.time}");
      final bDateTime = DateTime.parse("${b.date} ${b.time}");
      return bDateTime.compareTo(aDateTime); // DESCENDING
    });

    if (!mounted) return;

    setState(() {
      role = r?.toLowerCase();
      meetings = m;
      loading = false;
    });
  }


  bool get isAdmin => role == "admin";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 Meeting List
        loading
            ? const Center(child: CircularProgressIndicator())
            : meetings.isEmpty
            ? const Center(child: Text("No meetings found"))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15),
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final m = meetings[index];

            return _notificationTile(
              title: m.title,
              subtitle:
              "${_formatDate(m.date)} • ${_formatTime(m.time)} • ${m.location}",
              time: _shortDate(m.date),
            );
          },
        ),

        /// 🔥 Schedule Meeting Button (ADMIN ONLY)
        if (isAdmin)
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
                router.push(routerScheduleMeetingPage);
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

  // ------------------------------------------------------------------
  // Helpers

  String _formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day} ${_month(d.month)} ${d.year}";
  }

  String _shortDate(String date) {
    final d = DateTime.parse(date);
    return "${_month(d.month)} ${d.day}";
  }

  String _formatTime(String time) {
    final t = time.split(":");
    int hour = int.parse(t[0]);
    final minute = t[1];
    final ampm = hour >= 12 ? "PM" : "AM";
    hour = hour > 12 ? hour - 12 : hour;
    return "$hour:$minute $ampm";
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}
