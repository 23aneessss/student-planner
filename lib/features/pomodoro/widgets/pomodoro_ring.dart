// lib/features/pomodoro/widgets/pomodoro_ring.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

class PomodoroRing extends StatelessWidget {
  const PomodoroRing({
    super.key,
    required this.progress,
    required this.timeLabel,
    required this.subtitle,
  });

  final double progress;
  final String timeLabel;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 248,
      height: 248,
      child: CustomPaint(
        painter: _RingPainter(progress),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                timeLabel,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 - 14;
    final Paint basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    final Paint progressPaint = Paint()
      ..color = kLavenderBright
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
