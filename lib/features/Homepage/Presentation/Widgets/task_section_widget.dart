import 'package:flutter/material.dart';
import 'package:weinber/features/Homepage/Presentation/Widgets/task_widget_homepage.dart';

import '../../../../core/constants/constants.dart';

class TaskSectionWidget extends StatelessWidget {
  const TaskSectionWidget({super.key});

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
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'TASKS ASSIGNED',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Colors.black54,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: const [
                TextSpan(
                  text: 'You have ',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
                TextSpan(
                  text: '4 tasks ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: 'to complete today.',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          taskCard(
            icon: Icons.local_car_wash_outlined,
            color: iconBlue,
            title: 'Car Wash – Sedan',
            subtitle: '123 Main Street · 10:00 AM',
          ),
          const SizedBox(height: 10),
          taskCard(
            icon: Icons.cleaning_services_outlined,
            color: iconOrange,
            title: 'Interior Detailing – SUV',
            subtitle: '456 Oak Ave · 10:00 AM',
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              label: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
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
