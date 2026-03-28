// lib/features/home/widgets/today_summary_card.dart
import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

class TodaySummaryCard extends StatelessWidget {
  const TodaySummaryCard({
    super.key,
    required this.tasksDueToday,
    required this.sessionsLogged,
    required this.streakDays,
  });

  final int tasksDueToday;
  final int sessionsLogged;
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kGlassStroke),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kInk.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Today\'s summary',
                style: textTheme.titleMedium?.copyWith(color: kCardText),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kCardSurfaceSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Pulse',
                  style: textTheme.labelMedium?.copyWith(color: kCoral),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kGlassSurfaceStrong,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$tasksDueToday',
                        style: textTheme.displayLarge?.copyWith(
                          fontSize: 34,
                          color: kLavender,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tasks due before midnight',
                        style: textTheme.titleMedium?.copyWith(
                          color: kCardText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tasksDueToday == 0
                            ? 'You have room to focus deeper today.'
                            : 'Keep the queue light and finish the most important one first.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: kCardSubtext,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    _StatChip(
                      label: 'Sessions',
                      value: '$sessionsLogged',
                      accent: const Color(0xFFBFE5FF),
                      icon: Icons.timer_outlined,
                    ),
                    const SizedBox(height: 12),
                    _StatChip(
                      label: 'Streak',
                      value: '$streakDays',
                      accent: const Color(0xFFFFC998),
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.accent,
    required this.icon,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: kCardSurfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: accent),
          const SizedBox(height: 12),
          Text(value, style: textTheme.titleLarge?.copyWith(color: accent)),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
        ],
      ),
    );
  }
}
