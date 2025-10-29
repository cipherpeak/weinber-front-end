
import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../Model/TaskItemStartTask.dart';

class TaskCheckboxTile extends StatelessWidget {
  final TaskItem task;
  final ValueChanged<bool?> onChanged;

  const TaskCheckboxTile({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: task.isCompleted,
      onChanged: onChanged,
      title: RichText(
        text: TextSpan(
          text: task.title,
          style: TextStyle(
              color: task.isCompleted ? Colors.grey : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null),
          children: task.isMandatory
              ? const [
            TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
          ]
              : [],
        ),
      ),
      activeColor: primaryColor,
      controlAffinity: ListTileControlAffinity.trailing,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(
        width: 0.8,
        color: primaryColor
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}