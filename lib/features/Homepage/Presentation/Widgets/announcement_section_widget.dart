import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import 'announcement_card_widget.dart';

class AnnouncementSectionWidget extends StatelessWidget {
  const AnnouncementSectionWidget({super.key});

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
          announcementCard(
            icon: Icons.campaign_outlined,
            color: iconPink,
            title: 'New Leave Policy Updates',
            date: 'Oct 15, 2025',
          ),
          const SizedBox(height: 10),
          announcementCard(
            icon: Icons.event_note_outlined,
            color: iconOrange,
            title: 'Team Building Event - Oct 20',
            date: 'Oct 14, 2025',
          ),
          const SizedBox(height: 10),
          announcementCard(
            icon: Icons.build_circle_outlined,
            color: iconBlue,
            title: 'System Maintenance Notice',
            date: 'Oct 13, 2025',
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black54,),
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
