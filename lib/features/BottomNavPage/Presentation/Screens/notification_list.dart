import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../Api/notification_repo.dart';
import '../../Model/notification_model.dart';

class GeneralNotificationList extends StatefulWidget {
  const GeneralNotificationList({super.key});

  @override
  State<GeneralNotificationList> createState() =>
      _GeneralNotificationListState();
}

class _GeneralNotificationListState extends State<GeneralNotificationList> {
  final repo = NotificationRepository();

  List<NotificationItem> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final now = DateTime.now();

      final res = await repo.fetchNotifications(
        date: now.day,
        month: now.month,
        year: now.year,
      );

      if (!mounted) return;

      setState(() {
        notifications = res;
        loading = false;
      });
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifications.isEmpty) {
      return const Center(child: Text("No notifications"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final n = notifications[index];

        return _notificationTile(
          title: n.title,
          subtitle: n.message,
          time: _formatTime(n.createdAt),
          width: width,
          isNew: !n.isRead,
        );
      },
    );
  }

  // ---------------- UI ----------------

  Widget _notificationTile({
    required String title,
    required String subtitle,
    required String time,
    required double width,
    bool isNew = false,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: appFont,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
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
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }
}
