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
        color: kGlassSurface,
        borderRadius: kCardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Today\'s summary', style: textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              _StatChip(label: 'Due', value: '$tasksDueToday'),
              const SizedBox(width: 12),
              _StatChip(label: 'Sessions', value: '$sessionsLogged'),
              const SizedBox(width: 12),
              _StatChip(label: 'Streak', value: '$streakDays'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: textTheme.titleLarge?.copyWith(color: kLavender),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
