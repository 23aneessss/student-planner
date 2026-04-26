// lib/features/tasks/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../core/widgets/planora_input.dart';
import '../../domain/models/course.dart';
import '../../domain/models/task.dart';
import '../../providers/courses_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../theme/tokens.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  String? _courseId;
  DateTime? _dueDate;
  DateTime? _remindAt;
  double _priority = 1;
  String _frequency = 'None';
  bool _hydrated = false;

  bool get isNew => widget.taskId == 'new';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Course>> courses = ref.watch(coursesStreamProvider);
    final AsyncValue<List<Task>> tasks = ref.watch(rawTasksProvider);

    return GradientScaffold(
      appBar: AppBar(title: const Text('Task details')),
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: tasks.when(
        data: (List<Task> list) {
          final Task? existing = isNew
              ? null
              : list
                    .where((Task task) => task.id == widget.taskId)
                    .cast<Task?>()
                    .firstOrNull;
          if (!_hydrated) {
            _titleController.text = existing?.title ?? '';
            _descriptionController.text = existing?.description ?? '';
            _tagsController.text = existing?.tags.join(', ') ?? '';
            _courseId = existing?.courseId;
            _dueDate = existing?.dueDate;
            _remindAt = existing?.remindAt;
            _priority = (existing?.priority.index ?? 1).toDouble();
            _frequency = existing?.recurring?['freq'] as String? ?? 'None';
            _hydrated = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _FieldLabel('Title'),
                  PlanoraTextField(
                    hint: 'Task title',
                    controller: _titleController,
                    validator: (String? value) =>
                        validateRequired(value, label: 'Title'),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Description'),
                  PlanoraTextField(
                    hint: 'Describe the task',
                    controller: _descriptionController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Course'),
                  courses.when(
                    data: (List<Course> items) => PlanoraDropdown<String>(
                      value: _courseId,
                      hint: 'Select course',
                      items: items
                          .map(
                            (Course course) => DropdownMenuItem<String>(
                              value: course.id,
                              child: Text(course.name),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) =>
                          setState(() => _courseId = value),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (Object error, StackTrace stackTrace) =>
                        Text(error.toString()),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _FieldLabel('Due date'),
                            PlanoraTextField(
                              hint: 'Pick a date',
                              controller: TextEditingController(
                                text: _dueDate == null
                                    ? ''
                                    : '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}',
                              ),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2035),
                                  initialDate: _dueDate ?? DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => _dueDate = picked);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _FieldLabel('Time'),
                            PlanoraTextField(
                              hint: 'Pick time',
                              controller: TextEditingController(
                                text: _dueDate == null
                                    ? ''
                                    : '${_dueDate!.hour.toString().padLeft(2, '0')}:${_dueDate!.minute.toString().padLeft(2, '0')}',
                              ),
                              readOnly: true,
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    _dueDate ?? DateTime.now(),
                                  ),
                                );
                                if (picked != null) {
                                  final DateTime base =
                                      _dueDate ?? DateTime.now();
                                  setState(() {
                                    _dueDate = DateTime(
                                      base.year,
                                      base.month,
                                      base.day,
                                      picked.hour,
                                      picked.minute,
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _ReminderTile(
                    enabled: _remindAt != null,
                    subtitle: _remindAt == null
                        ? 'No reminder scheduled'
                        : 'Notify at ${_remindAt!.hour.toString().padLeft(2, '0')}:${_remindAt!.minute.toString().padLeft(2, '0')}',
                    onChanged: (bool value) {
                      setState(() {
                        _remindAt = value && _dueDate != null
                            ? _dueDate!.subtract(const Duration(minutes: 30))
                            : null;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Priority'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Slider(
                      value: _priority,
                      min: 0,
                      max: 3,
                      divisions: 3,
                      label: TaskPriority.values[_priority.round()].name,
                      onChanged: (double value) =>
                          setState(() => _priority = value),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const _FieldLabel('Tags'),
                  PlanoraTextField(
                    hint: 'Comma separated',
                    controller: _tagsController,
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Recurrence'),
                  PlanoraDropdown<String>(
                    value: _frequency,
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem(value: 'None', child: Text('None')),
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() => _frequency = value);
                      }
                    },
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Save',
                    trailingIcon: Icons.check_rounded,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final Task task = Task(
                          id: existing?.id ?? const Uuid().v4(),
                          title: _titleController.text.trim(),
                          description:
                              _descriptionController.text.trim().isEmpty
                              ? null
                              : _descriptionController.text.trim(),
                          courseId: _courseId,
                          priority: TaskPriority.values[_priority.round()],
                          dueDate: _dueDate,
                          remindAt: _remindAt,
                          tags: _tagsController.text
                              .split(',')
                              .map((String tag) => tag.trim())
                              .where((String tag) => tag.isNotEmpty)
                              .toList(),
                          recurring: _frequency == 'None'
                              ? null
                              : <String, dynamic>{'freq': _frequency},
                          updatedAt: DateTime.now(),
                          status: existing?.status ?? TaskStatus.todo,
                          deletedAt: existing?.deletedAt,
                        );
                        await ref
                            .read(taskActionsProvider)
                            .saveTask(task, isNew: existing == null);
                        if (!context.mounted) return;
                        context.go('/tasks');
                      }
                    },
                  ),
                  if (existing != null) ...<Widget>[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(taskActionsProvider)
                            .deleteTask(existing);
                        if (!context.mounted) return;
                        context.go('/tasks');
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 0, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.enabled,
    required this.subtitle,
    required this.onChanged,
  });

  final bool enabled;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reminder',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            activeThumbColor: Colors.white,
            activeTrackColor: kLavender,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.18),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
