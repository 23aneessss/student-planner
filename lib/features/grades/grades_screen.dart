// lib/features/grades/grades_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../core/widgets/planora_input.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGradeSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: coursesAsync.when(
        data: (List<Course> courses) {
          _selectedCourseId ??= courses.isNotEmpty ? courses.first.id : null;
          return StreamBuilder<List<Grade>>(
            stream: gradesStream,
            builder: (BuildContext context, AsyncSnapshot<List<Grade>> snapshot) {
              final List<Grade> grades = snapshot.data ?? <Grade>[];
              final List<Grade> filtered = _selectedCourseId == null
                  ? grades
                  : grades
                        .where(
                          (Grade grade) => grade.courseId == _selectedCourseId,
                        )
                        .toList();
              final double weightedTotal = filtered.fold<double>(
                0,
                (double value, Grade grade) =>
                    value + ((grade.score / grade.maxScore) * grade.weight),
              );
              final double weightSum = filtered.fold<double>(
                0,
                (double value, Grade grade) => value + grade.weight,
              );
              final double gpa = weightSum == 0
                  ? 0
                  : (weightedTotal / weightSum) * 20;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                children: <Widget>[
                  Text('Grades', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: courses
                          .map(
                            (Course course) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(course.name),
                                selected: _selectedCourseId == course.id,
                                selectedColor: kLavender,
                                labelStyle: TextStyle(
                                  color: _selectedCourseId == course.id
                                      ? kDark
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.08,
                                ),
                                onSelected: (_) => setState(
                                  () => _selectedCourseId = course.id,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
                          'Weighted GPA',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: kCardText),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          gpa.toStringAsFixed(2),
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(color: kLavender),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ...filtered.map(
                    (Grade grade) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                                Text(
                                  grade.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: kCardText),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${grade.type.name} • ${grade.gradedAt.day}/${grade.gradedAt.month}/${grade.gradedAt.year}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: kCardSubtext),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${grade.score.toStringAsFixed(1)}/${grade.maxScore.toStringAsFixed(0)}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(color: kLavender),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                  PlanoraTextField(label: 'Title', controller: titleController),
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
                              score: double.tryParse(scoreController.text) ?? 0,
                              maxScore:
                                  double.tryParse(maxController.text) ?? 100,
                              weight:
                                  double.tryParse(weightController.text) ?? 1,
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
              );
            },
          ),
        );
      },
    );
  }
}
