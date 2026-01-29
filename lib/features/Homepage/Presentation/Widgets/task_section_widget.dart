import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/features/Homepage/Presentation/Widgets/task_widget_homepage.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../../Model/homepage_response.dart';

class TaskSectionWidget extends ConsumerWidget {
  final List<Task> tasks;
  final String route;


  const TaskSectionWidget({required this.tasks, required this.route, super.key});

  // ✅ Common icon and color for all tasks
  static const IconData _commonTaskIcon =
      Icons.task_outlined;

  static const Color _commonTaskColor = primaryColor;

  @override
  Widget build( BuildContext context, WidgetRef ref) {
    // ✅ Show only max 3 tasks
    final visibleTasks =
    tasks.length > 3 ? tasks.take(3).toList() : tasks;

    return Container(
      width: double.infinity,
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

          // ✅ Summary Text
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

          // ✅ Max 3 tasks only
          ...visibleTasks.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: taskCard(
                icon: _commonTaskIcon,
                color: _commonTaskColor,
                title: task.heading,
                subtitle: "${task.details} • ${task.time}",
              ),
            );
          }),

          // ✅ View All Button
          if (tasks.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  router.go(route);
                  ref.read(bottomNavProvider.notifier).changeIndex(1);
                },
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
