// lib/features/calendar/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../core/extensions.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_screen_header.dart';
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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: <Widget>[
              PlanoraScreenHeader(
                eyebrow: 'Schedule',
                title: 'Calendar',
                subtitle: 'Long-press a day to add a task fast.',
                action: PlanoraHeaderAction(
                  icon: Icons.today_rounded,
                  tooltip: 'Jump to today',
                  onTap: () => setState(() {
                    _selectedDay = DateTime.now();
                    _focusedDay = DateTime.now();
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
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
                              backgroundColor: kCardSurface,
                              title: const Text(
                                'Quick add task',
                                style: TextStyle(color: kCardText),
                              ),
                              content: TextField(
                                controller: controller,
                                style: const TextStyle(color: kCardText),
                                decoration: const InputDecoration(
                                  hintText: 'Task title',
                                  filled: true,
                                  fillColor: kCardSurfaceSoft,
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
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: kCardText,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left_rounded,
                      color: kInk,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right_rounded,
                      color: kInk,
                    ),
                    formatButtonVisible: false,
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: kCardSubtext,
                      fontWeight: FontWeight.w700,
                    ),
                    weekendStyle: TextStyle(
                      color: kCoral,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(
                      color: kCardText,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendTextStyle: const TextStyle(
                      color: kCoral,
                      fontWeight: FontWeight.w600,
                    ),
                    outsideTextStyle: TextStyle(
                      color: kCardSubtext.withValues(alpha: 0.5),
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: kLavender,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    todayDecoration: BoxDecoration(
                      color: kCoral.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(color: kCoral, width: 1.4),
                    ),
                    todayTextStyle: const TextStyle(
                      color: kCoral,
                      fontWeight: FontWeight.w800,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: kLavenderBright,
                      shape: BoxShape.circle,
                    ),
                    markersAlignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDay.weekdayAndDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Text(
                      '${selectedTasks.length} task${selectedTasks.length == 1 ? '' : 's'}',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: kLavenderBright),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (selectedTasks.isEmpty)
                Container(
                  width: double.infinity,
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
                        Icons.event_available_rounded,
                        color: kLavenderBright,
                        size: 22,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nothing scheduled.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Long-press this day on the calendar to add a task.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kMutedText,
                        ),
                      ),
                    ],
                  ),
                )
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
