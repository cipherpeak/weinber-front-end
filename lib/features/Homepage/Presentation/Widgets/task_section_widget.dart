import 'package:flutter/material.dart';
import 'package:weinber/features/Homepage/Presentation/Widgets/task_widget_homepage.dart';

import '../../../../core/constants/constants.dart';
import '../../Model/homepage_response.dart';

class TaskSectionWidget extends StatelessWidget {
  final List<Task> tasks;

  const TaskSectionWidget({required this.tasks, super.key});

  IconData _getTaskIcon(String type) {
    switch (type.toLowerCase()) {
      case "car_wash":
        return Icons.local_car_wash_outlined;
      case "cleaning":
        return Icons.cleaning_services_outlined;
      case "delivery":
        return Icons.delivery_dining_outlined;
      default:
        return Icons.task_alt_rounded;
    }
  }

  Color _getTaskColor(String type) {
    switch (type.toLowerCase()) {
      case "car_wash":
        return iconBlue;
      case "cleaning":
        return iconOrange;
      case "delivery":
        return Colors.green;
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
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'TASKS ASSIGNED',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black54,
                letterSpacing: -0.3,
              ),
            ),
          ),

          // Summary Text
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'You have ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: '${tasks.length} tasks ',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
                const TextSpan(
                  text: 'to complete today.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Dynamic Task List
          ...tasks.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: taskCard(
                icon: _getTaskIcon(task.type),
                color: _getTaskColor(task.type),
                title: task.heading,
                subtitle: "${task.details} • ${task.time}",
              ),
            );
          }),

          // View All Button
          if (tasks.isNotEmpty)
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
