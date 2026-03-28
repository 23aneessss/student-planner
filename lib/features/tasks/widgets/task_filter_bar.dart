// lib/features/tasks/widgets/task_filter_bar.dart
import 'package:flutter/material.dart';

import '../../../domain/models/task.dart';
import '../../../providers/tasks_provider.dart';
import '../../../theme/tokens.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.sort,
    required this.onSortChanged,
  });

  final TaskStatus? selectedStatus;
  final ValueChanged<TaskStatus?> onStatusChanged;
  final TaskSort sort;
  final ValueChanged<TaskSort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _chip(
                  context,
                  'All',
                  selectedStatus == null,
                  () => onStatusChanged(null),
                ),
                _chip(
                  context,
                  'Todo',
                  selectedStatus == TaskStatus.todo,
                  () => onStatusChanged(TaskStatus.todo),
                ),
                _chip(
                  context,
                  'In Progress',
                  selectedStatus == TaskStatus.inProgress,
                  () => onStatusChanged(TaskStatus.inProgress),
                ),
                _chip(
                  context,
                  'Done',
                  selectedStatus == TaskStatus.done,
                  () => onStatusChanged(TaskStatus.done),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: kGlassSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TaskSort>(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              value: sort,
              dropdownColor: kDark,
              iconEnabledColor: Colors.white,
              style: Theme.of(context).textTheme.bodyMedium,
              items: const <DropdownMenuItem<TaskSort>>[
                DropdownMenuItem(
                  value: TaskSort.dueDate,
                  child: Text('Due date'),
                ),
                DropdownMenuItem(
                  value: TaskSort.priority,
                  child: Text('Priority'),
                ),
                DropdownMenuItem(value: TaskSort.course, child: Text('Course')),
              ],
              onChanged: (TaskSort? value) {
                if (value != null) {
                  onSortChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: kLavender,
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: selected ? kDark : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
