import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/features/TaskPageDax/Presentation/Provider/StartTask/startTaskNotifierForCompleted.dart';
import '../../../Model/TaskItemStartTask.dart';

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<TaskItem>>(
      (ref) => TaskListNotifier([
    TaskItem(title: 'Exterior Wash', isCompleted: true),
    TaskItem(title: 'Wheel Clean', isMandatory: true),
    TaskItem(title: 'Interior Vacuum', isMandatory: true),
    TaskItem(title: 'Window Cleaning', isMandatory: true),
    TaskItem(title: 'Dashboard Wipe', isMandatory: true),
    TaskItem(title: 'Tire Dressing', isMandatory: true),
  ]),
);

final saveProgressPercentageProvider = Provider<double>((ref) {
  final tasks = ref.watch(taskListProvider);
  final completedCount = tasks.where((t) => t.isCompleted).length;
  return completedCount / tasks.length;
});