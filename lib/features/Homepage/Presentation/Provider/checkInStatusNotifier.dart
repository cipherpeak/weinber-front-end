import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CheckInStatusNotifier extends StateNotifier<AsyncValue<bool>> {
  CheckInStatusNotifier() : super(const AsyncValue.loading()) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('checkInStatus') ?? false;
    state = AsyncValue.data(value);
  }

  Future<void> setCheckInStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkInStatus', value);
    state = AsyncValue.data(value);
  }
}

final checkInStatusProvider =
StateNotifierProvider<CheckInStatusNotifier, AsyncValue<bool>>((ref) {
  return CheckInStatusNotifier();
});
