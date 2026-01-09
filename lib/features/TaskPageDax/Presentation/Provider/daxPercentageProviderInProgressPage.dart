import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskChecklistProvider = StateProvider<List<bool>>((ref) {
  return [true, false, false, false]; // First item already completed
});

final percentageProgressProvider = Provider<double>((ref) {
  final list = ref.watch(taskChecklistProvider);
  final completed = list.where((e) => e).length;
  return completed / list.length;
});
