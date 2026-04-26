// lib/features/grades/grades_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../core/widgets/planora_input.dart';
import '../../core/widgets/planora_screen_header.dart';
import '../../domain/models/course.dart';
import '../../domain/models/grade.dart';
import '../../domain/models/outbox_event.dart';
import '../../providers/app_providers.dart';
import '../../providers/courses_provider.dart';
import '../../theme/tokens.dart';

class GradesScreen extends ConsumerStatefulWidget {
  const GradesScreen({super.key});

  @override
  ConsumerState<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends ConsumerState<GradesScreen> {
  String? _selectedCourseId;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Course>> coursesAsync = ref.watch(
      coursesStreamProvider,
    );
    final Stream<List<Grade>> gradesStream = ref
        .watch(gradesRepositoryProvider)
        .watchAll();

    return GradientScaffold(
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: coursesAsync.when(
        data: (List<Course> courses) {
          _selectedCourseId ??= courses.isNotEmpty ? courses.first.id : null;
          return StreamBuilder<List<Grade>>(
            stream: gradesStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Grade>> snapshot) {
                  final List<Grade> grades = snapshot.data ?? <Grade>[];
                  final List<Grade> filtered = _selectedCourseId == null
                      ? grades
                      : grades
                            .where(
                              (Grade grade) =>
                                  grade.courseId == _selectedCourseId,
                            )
                            .toList();
                  final double weightedTotal = filtered.fold<double>(
                    0,
                    (double value, Grade grade) =>
                        value +
                        ((grade.score / grade.maxScore) * grade.weight),
                  );
                  final double weightSum = filtered.fold<double>(
                    0,
                    (double value, Grade grade) => value + grade.weight,
                  );
                  final double gpa = weightSum == 0
                      ? 0
                      : (weightedTotal / weightSum) * 20;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                    children: <Widget>[
                      PlanoraScreenHeader(
                        eyebrow: 'Performance',
                        title: 'Grades',
                        subtitle: 'Track your weighted average per course.',
                        action: PlanoraHeaderAction(
                          icon: Icons.add_rounded,
                          tooltip: 'Add grade',
                          onTap: courses.isEmpty
                              ? () {}
                              : () => _showAddGradeSheet(context),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (courses.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: EmptyState(
                            title: 'No courses yet.',
                            subtitle:
                                'Add a course first to start tracking grades.',
                          ),
                        )
                      else ...<Widget>[
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: courses.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(width: 8),
                            itemBuilder: (BuildContext context, int index) {
                              final Course course = courses[index];
                              final bool selected =
                                  _selectedCourseId == course.id;
                              final Color color = _parseColor(course.colorHex);
                              return InkWell(
                                borderRadius: BorderRadius.circular(999),
                                onTap: () => setState(
                                  () => _selectedCourseId = course.id,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? color
                                        : Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: selected
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : Colors.white.withValues(
                                              alpha: 0.14,
                                            ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? Colors.white
                                              : color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        course.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: selected
                                                  ? Colors.white
                                                  : Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        _GpaCard(gpa: gpa, count: filtered.length),
                        const SizedBox(height: 18),
                        if (filtered.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: kCardRadius,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Icon(
                                  Icons.school_outlined,
                                  color: kLavenderBright,
                                  size: 22,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No grades for this course yet.',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap the + above to record your first grade.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: kMutedText),
                                ),
                              ],
                            ),
                          )
                        else
                          ...filtered.map(
                            (Grade grade) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _GradeCard(grade: grade),
                            ),
                          ),
                      ],
                    ],
                  );
                },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return kLavender;
    }
  }

  Future<void> _showAddGradeSheet(BuildContext context) async {
    final List<Course> courses = await ref.read(coursesStreamProvider.future);
    if (courses.isEmpty) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    String courseId = _selectedCourseId ?? courses.first.id;
    final TextEditingController titleController = TextEditingController();
    final TextEditingController scoreController = TextEditingController();
    final TextEditingController maxController = TextEditingController(
      text: '100',
    );
    final TextEditingController weightController = TextEditingController(
      text: '1',
    );
    GradeType type = GradeType.assignment;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DefaultTextStyle.merge(
                style: const TextStyle(color: kCardText),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: Theme.of(context).inputDecorationTheme
                        .copyWith(
                          fillColor: kCardSurfaceSoft,
                          labelStyle: const TextStyle(color: kCardSubtext),
                        ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: kCardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'New grade',
                        style: TextStyle(
                          color: kCardText,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      PlanoraDropdown<String>(
                        label: 'Course',
                        value: courseId,
                        items: courses
                            .map(
                              (Course course) => DropdownMenuItem<String>(
                                value: course.id,
                                child: Text(course.name),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) =>
                            setState(() => courseId = value ?? courseId),
                      ),
                      const SizedBox(height: 12),
                      PlanoraTextField(
                        label: 'Title',
                        controller: titleController,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PlanoraTextField(
                              label: 'Score',
                              controller: scoreController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PlanoraTextField(
                              label: 'Max',
                              controller: maxController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PlanoraTextField(
                              label: 'Weight',
                              controller: weightController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PlanoraDropdown<GradeType>(
                              label: 'Type',
                              value: type,
                              items: GradeType.values
                                  .map(
                                    (GradeType gradeType) =>
                                        DropdownMenuItem<GradeType>(
                                          value: gradeType,
                                          child: Text(gradeType.name),
                                        ),
                                  )
                                  .toList(),
                              onChanged: (GradeType? value) {
                                if (value != null) {
                                  setState(() => type = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: 'Add grade',
                        onPressed: () async {
                          await ref
                              .read(gradesRepositoryProvider)
                              .save(
                                Grade(
                                  id: const Uuid().v4(),
                                  courseId: courseId,
                                  title: titleController.text.trim(),
                                  score:
                                      double.tryParse(scoreController.text) ??
                                      0,
                                  maxScore:
                                      double.tryParse(maxController.text) ??
                                      100,
                                  weight:
                                      double.tryParse(weightController.text) ??
                                      1,
                                  type: type,
                                  gradedAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                ),
                                operation: SyncOperation.create,
                              );
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GpaCard extends StatelessWidget {
  const _GpaCard({required this.gpa, required this.count});

  final double gpa;
  final int count;

  @override
  Widget build(BuildContext context) {
    final double progress = (gpa / 20).clamp(0, 1).toDouble();
    final Color accent = gpa >= 14
        ? kSuccess
        : gpa >= 10
        ? kLavender
        : kCoral;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Weighted average',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: kCardText),
                ),
              ),
              Text(
                '$count entries',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: kCardSubtext),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                gpa.toStringAsFixed(2),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: accent,
                  fontSize: 44,
                  letterSpacing: -1.4,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '/ 20',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: kCardSubtext),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: kCardSurfaceSoft,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.grade});

  final Grade grade;

  @override
  Widget build(BuildContext context) {
    final double percent = grade.maxScore == 0
        ? 0
        : grade.score / grade.maxScore;
    final Color accent = percent >= 0.7
        ? kSuccess
        : percent >= 0.5
        ? kLavender
        : kCoral;
    final Color typeAccent = _typeColor(grade.type);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeAccent.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        grade.type.name,
                        style: textTheme.labelMedium?.copyWith(
                          color: typeAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  grade.title,
                  style: textTheme.titleMedium?.copyWith(color: kCardText),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${grade.gradedAt.day}/${grade.gradedAt.month}/${grade.gradedAt.year} • weight ${grade.weight.toStringAsFixed(1)}',
                  style: textTheme.bodyMedium?.copyWith(color: kCardSubtext),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  grade.score.toStringAsFixed(1),
                  style: textTheme.titleMedium?.copyWith(
                    color: accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '/ ${grade.maxScore.toStringAsFixed(0)}',
                  style: textTheme.labelMedium?.copyWith(color: kCardSubtext),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(GradeType type) {
    switch (type) {
      case GradeType.exam:
        return kCoral;
      case GradeType.quiz:
        return kLavender;
      case GradeType.assignment:
        return const Color(0xFF4FA8E0);
      case GradeType.project:
        return const Color(0xFFE0A04F);
    }
  }
}
