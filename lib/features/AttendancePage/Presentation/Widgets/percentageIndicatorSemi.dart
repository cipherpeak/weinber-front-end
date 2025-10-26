import 'package:flutter/material.dart';
import 'dart:math';

class SemiCircularProgress extends StatelessWidget {
  final double progress; // from 0.0 to 1.0
  final double size;
  final List<Color> gradientColors;

  const SemiCircularProgress({
    super.key,
    required this.progress,
    this.size = 200,
    this.gradientColors = const [
      Color(0xFF5563DE),
      Color(0xFF00C6FB),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return SizedBox(
      width: size,
      height: size / 1.5,
      child: Stack(
        // alignment: Alignment.center,
        children: [
          // Semi-circle progress indicator
          CustomPaint(
            size: Size(size, size / 2),
            painter: _SemiCirclePainter(progress, gradientColors),
          ),

          // Centered texts (percentage + label)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$percentage%",
                  style: TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: gradientColors.first,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Monthly Progress",
                  style: TextStyle(
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;

  _SemiCirclePainter(this.progress, this.gradientColors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final startAngle = pi; // start from left
    final sweepAngle = pi * progress;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Gradient progress arc
    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: gradientColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Draw arcs
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
