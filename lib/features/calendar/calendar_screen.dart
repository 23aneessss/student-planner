// lib/features/calendar/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../domain/models/task.dart';
import '../../providers/tasks_provider.dart';
import '../../theme/tokens.dart';
import '../tasks/widgets/task_card.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Task>> tasksAsync = ref.watch(rawTasksProvider);

    return GradientScaffold(
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: tasksAsync.when(
        data: (List<Task> tasks) {
          final List<Task> selectedTasks = tasks
              .where(
                (Task task) => task.dueDate?.isSameDate(_selectedDay) ?? false,
              )
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
            children: <Widget>[
              Text('Calendar', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: kGlassSurface,
                  borderRadius: kCardRadius,
                ),
                child: TableCalendar<Task>(
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2035),
                  focusedDay: _focusedDay,
                  calendarFormat: _format,
                  selectedDayPredicate: (DateTime day) =>
                      day.isSameDate(_selectedDay),
                  eventLoader: (DateTime day) => tasks
                      .where(
                        (Task task) => task.dueDate?.isSameDate(day) ?? false,
                      )
                      .toList(),
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (CalendarFormat format) =>
                      setState(() => _format = format),
                  onPageChanged: (DateTime focusedDay) =>
                      _focusedDay = focusedDay,
                  onDayLongPressed:
                      (DateTime selectedDay, DateTime focusedDay) async {
                        final TextEditingController controller =
                            TextEditingController();
                        final bool? confirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Quick add task'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: 'Task title',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmed == true &&
                            controller.text.trim().isNotEmpty) {
                          await ref
                              .read(taskActionsProvider)
                              .saveTask(
                                Task(
                                  id: const Uuid().v4(),
                                  title: controller.text.trim(),
                                  dueDate: selectedDay,
                                  updatedAt: DateTime.now(),
                                ),
                                isNew: true,
                              );
                        }
                      },
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: kLavender),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: kLavender,
                    ),
                    formatButtonVisible: false,
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: kCoral),
                    selectedDecoration: const BoxDecoration(
                      color: kLavender,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: kCoral,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selected day',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (selectedTasks.isEmpty)
                const Text('No tasks for this day.')
              else
                ...selectedTasks.map(
                  (Task task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskCard(
                      task: task,
                      onToggle: () =>
                          ref.read(taskActionsProvider).toggleTask(task),
                    ),
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
}
