import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'bottom_nav_notifier.dart';

final bottomNavProvider = StateNotifierProvider.autoDispose<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});