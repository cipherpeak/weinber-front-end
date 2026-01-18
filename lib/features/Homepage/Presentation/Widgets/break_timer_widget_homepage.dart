import 'dart:async';
import 'package:flutter/material.dart';
import '../../Database/breakTimerHive.dart';

class BreakTimerWidget extends StatefulWidget {
  final VoidCallback onEndBreak;
  final VoidCallback onExtendBreak;

  const BreakTimerWidget({
    super.key,
    required this.onEndBreak,
    required this.onExtendBreak,
  });

  @override
  State<BreakTimerWidget> createState() => _BreakTimerWidgetState();
}

class _BreakTimerWidgetState extends State<BreakTimerWidget> {
  Timer? _timer;
  int totalSeconds = 0;
  bool isExceeded = false;

  DateTime? startTime;
  int allowedMinutes = 0;
  String breakType = "";

  DateTime get endTime =>
      startTime!.add(Duration(minutes: allowedMinutes));

  @override
  void initState() {
    super.initState();
    _loadBreakFromHive();
  }

  void _loadBreakFromHive() {
    if (!BreakLocalStorage.hasBreak()) return;

    final s = BreakLocalStorage.getStartTime();
    if (s == null) return;

    startTime = s;
    allowedMinutes = BreakLocalStorage.getAllowedMinutes();
    breakType = BreakLocalStorage.getBreakType();

    _syncTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _syncTimer());
  }

  void _syncTimer() {
    if (startTime == null) return;

    final now = DateTime.now().toUtc();
    final diff = endTime.toUtc().difference(now).inSeconds;

    if (!mounted) return;

    setState(() {
      totalSeconds = diff;
      isExceeded = diff < 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final s = seconds.abs();
    final minutes = (s ~/ 60).toString().padLeft(2, '0');
    final secs = (s % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    if (!BreakLocalStorage.hasBreak() || startTime == null) {
      _timer?.cancel();
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: !isExceeded ? _normalCard() : _exceededCard(),
        ),
        const SizedBox(height: 25),
        !isExceeded ? _buttons() : _endNow(),
      ],
    );
  }

  // ================= UI =================

  Widget _normalCard() {
    return Container(
      key: const ValueKey('normal'),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9152F4), Color(0xFF7187FA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text("$breakType Timer",
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(formatTime(totalSeconds),
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text("${(totalSeconds ~/ 60).abs()} min remaining",
              style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _exceededCard() {
    return Container(
      key: const ValueKey('exceeded'),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Text("Break Time Exceeded !!",
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(formatTime(totalSeconds),
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          const Text("Please return to your daily work",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onExtendBreak,
              child: const Text("Extend Break"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: widget.onEndBreak,
              child: const Text("End Break"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _endNow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onEndBreak,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text("End Break Now"),
        ),
      ),
    );
  }
}
