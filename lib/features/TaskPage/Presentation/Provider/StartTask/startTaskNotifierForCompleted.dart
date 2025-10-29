import 'package:flutter_riverpod/legacy.dart';

import '../../../Model/TaskItemStartTask.dart';

class TaskListNotifier extends StateNotifier<List<TaskItem>> {
  TaskListNotifier(super.state);

  void toggleTask(int index) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(
      isCompleted: !updated[index].isCompleted,
    );
    state = updated;
  }
}