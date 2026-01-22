import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

class GeneralNotificationList extends StatelessWidget {
  const GeneralNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      children: [
        _notificationTile(
          title: "You successfully Checked In",
          subtitle: "At 08:15 AM",
          time: "New",
          width: width,
          isNew: true,
        ),
        _notificationTile(
          title: "Leave Request Approved",
          subtitle: "Your leave request has been approved",
          time: "Yesterday",
          width: width,
        ),
        _notificationTile(
          title: "Reminder",
          subtitle: "Remember to check in before 09:00 AM",
          time: "3d ago",
          width: width,
        ),
      ],
    );
  }

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
}
