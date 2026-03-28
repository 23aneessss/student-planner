// lib/features/stats/stats_screen.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
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
        data: (StatsSnapshot stats) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
          children: <Widget>[
            Text('Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCardSurface,
                borderRadius: kCardRadius,
                border: Border.all(color: kCardBorder),
              ),
              child: SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: Colors.white.withValues(alpha: 0.25)),
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
                          getTitlesWidget: (double value, TitleMeta meta) =>
                              Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: kCardSubtext,
                                  fontSize: 11,
                                ),
                              ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) =>
                              Text(
                                const <String>[
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S',
                                ][value.toInt()],
                                style: const TextStyle(color: kCardSubtext),
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
                                color: entry.key == DateTime.now().weekday - 1
                                    ? kCoral
                                    : kLavender,
                                width: 18,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: _InfoCard(
                    title: 'Streak',
                    value: '${stats.currentStreak} days',
                    accent: kCoral,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(
                    title: 'Focus time',
                    value: '${stats.totalFocusMinutes} mins',
                    accent: kLavender,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCardSurface,
                borderRadius: kCardRadius,
                border: Border.all(color: kCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tasks completed',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: kCardText),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 48,
                        sections: <PieChartSectionData>[
                          PieChartSectionData(
                            value: stats.completedTasks.toDouble(),
                            color: kLavender,
                            title: 'Done',
                            titleStyle: const TextStyle(
                              color: kDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          PieChartSectionData(
                            value: stats.pendingTasks.toDouble(),
                            color: kNavy,
                            title: 'Pending',
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: kCardSubtext),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}
