import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../utils/Common Functions/format_date_time.dart';
import '../../Model/homepage_response.dart';
import 'announcement_card_widget.dart';

class AnnouncementSectionWidget extends StatelessWidget {
  final List<Announcement> announcements;

  const AnnouncementSectionWidget({required this.announcements, super.key});

  IconData _getAnnouncementIcon(int index) {
    switch (index % 3) {
      case 0:
        return Icons.campaign_outlined;
      case 1:
        return Icons.event_note_outlined;
      case 2:
        return Icons.build_circle_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getAnnouncementColor(int index) {
    switch (index % 3) {
      case 0:
        return iconPink;
      case 1:
        return iconOrange;
      case 2:
        return iconBlue;
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'COMPANY ANNOUNCEMENTS',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Dynamic List
          ...announcements.asMap().entries.map((entry) {
            final index = entry.key;
            final ann = entry.value;

            // Format using your own function
            final formattedDate = formatDateTime(ann.date);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: announcementCard(
                icon: _getAnnouncementIcon(index),
                color: _getAnnouncementColor(index),
                title: ann.heading,
                date: formattedDate,
              ),
            );
          }),

          if (announcements.isNotEmpty)
            // View All Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.black54,
                ),
                label: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
