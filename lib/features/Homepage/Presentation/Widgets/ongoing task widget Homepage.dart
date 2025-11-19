import 'package:flutter/material.dart';
import '../../../../utils/Common Functions/format_date_time.dart';
import '../../../../utils/Common Widgets/percentageBarHomepage.dart';
import '../../Model/homepage_response.dart';

class OngoingTaskWidgetHomepage extends StatelessWidget {
  final List<OngoingTask> tasks;

  const OngoingTaskWidgetHomepage({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffe4e9ff),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ONGOING TASKS",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 12),

          Column(
            children: tasks.map((task) {
              return _buildTaskCard(context, task);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, OngoingTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Heading + Status Row

          Row(
            children: [
              Expanded(
                child: Text(
                  task.heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.status.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Address

          Text(
            task.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          /// Time - Formatted

          Text(
            formatDateTime(task.taskAssignTime),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 10),

          /// Progress %
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${task.percentageCompleted}%",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// Percentage Bar

          PercentageBarHomepage(task.percentageCompleted),
        ],
      ),
    );
  }
}
