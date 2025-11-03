import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/checkInStatusNotifier.dart';
import 'attendace_card_check_in.dart';
import 'attendance_card_check_out.dart';

class AttendanceCardSection extends ConsumerWidget {
  const AttendanceCardSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInStatus = ref.watch(checkInStatusProvider);

    return checkInStatus.when(
      data: (isCheckedIn) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: isCheckedIn
            ? attendanceCardCheckOut()
            : attendanceCardCheckIn(),
      ),
      loading: () =>
      const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
      error: (err, _) => Text(
        "Error: $err",
        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
      ),
    );
  }
}
