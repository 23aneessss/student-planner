// lib/features/stats/stats_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_screen_header.dart';
import '../../providers/stats_provider.dart';
import '../../theme/tokens.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<StatsSnapshot> statsAsync = ref.watch(statsProvider);
    return GradientScaffold(
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: statsAsync.when(
        data: (StatsSnapshot stats) {
          final int focusHours = stats.totalFocusMinutes ~/ 60;
          final int focusMins = stats.totalFocusMinutes % 60;
          final String focusLabel = focusHours > 0
              ? '${focusHours}h ${focusMins}m'
              : '${stats.totalFocusMinutes}m';
          final int totalTasks = stats.completedTasks + stats.pendingTasks;
          final double completionRate = totalTasks == 0
              ? 0
              : stats.completedTasks / totalTasks;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: <Widget>[
              const PlanoraScreenHeader(
                eyebrow: 'Progress',
                title: 'Stats',
                subtitle: 'A clear view of your weekly focus.',
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InfoCard(
                      title: 'Streak',
                      value: '${stats.currentStreak}',
                      unit: stats.currentStreak == 1 ? 'day' : 'days',
                      accent: kCoral,
                      icon: Icons.local_fire_department_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      title: 'Focus time',
                      value: focusLabel,
                      unit: 'this week',
                      accent: kLavender,
                      icon: Icons.timer_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Sessions per day',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: kCardText),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last 7 days',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: kCardSubtext),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kCardSurfaceSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: kCoral,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Today',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: kInk),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _maxYForChart(stats.sessionsPerDay),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: kCardBorder.withValues(alpha: 0.6),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                interval: 1,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) => Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        color: kCardSubtext,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) => Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        const <String>[
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat',
                                          'Sun',
                                        ][value.toInt() % 7],
                                        style: const TextStyle(
                                          color: kCardSubtext,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          barGroups: stats.sessionsPerDay
                              .asMap()
                              .entries
                              .map(
                                (MapEntry<int, int> entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: <BarChartRodData>[
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color:
                                          entry.key ==
                                              DateTime.now().weekday - 1
                                          ? kCoral
                                          : kLavender,
                                      width: 14,
                                      borderRadius: BorderRadius.circular(6),
                                      backDrawRodData:
                                          BackgroundBarChartRodData(
                                            show: true,
                                            toY: _maxYForChart(
                                              stats.sessionsPerDay,
                                            ),
                                            color: kCardSurfaceSoft,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Tasks completion',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: kCardText),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(completionRate * 100).round()}% done',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: kCardSubtext),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$totalTasks total',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: kCardSubtext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 38,
                              startDegreeOffset: -90,
                              sections: <PieChartSectionData>[
                                PieChartSectionData(
                                  value: stats.completedTasks.toDouble(),
                                  color: kLavenderBright,
                                  title: '',
                                  radius: 22,
                                ),
                                PieChartSectionData(
                                  value: stats.pendingTasks
                                      .toDouble()
                                      .clamp(0, double.infinity),
                                  color: kCardSurfaceSoft,
                                  title: '',
                                  radius: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _LegendDot(
                                color: kLavenderBright,
                                label: 'Done',
                                value: '${stats.completedTasks}',
                              ),
                              const SizedBox(height: 12),
                              _LegendDot(
                                color: kCardBorder,
                                label: 'Pending',
                                value: '${stats.pendingTasks}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
      ),
    );
  }

  double _maxYForChart(List<int> values) {
    if (values.isEmpty) return 4;
    final int peak = values.reduce((int a, int b) => a > b ? a : b);
    return (peak < 4 ? 4 : peak + 1).toDouble();
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kInk.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String value;
  final String unit;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kInk.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: accent,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            unit,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: kCardSubtext),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: kCardText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
