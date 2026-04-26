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
                _GlassChip(
                  label: 'All',
                  selected: selectedStatus == null,
                  onTap: () => onStatusChanged(null),
                ),
                _GlassChip(
                  label: 'Todo',
                  selected: selectedStatus == TaskStatus.todo,
                  onTap: () => onStatusChanged(TaskStatus.todo),
                ),
                _GlassChip(
                  label: 'In progress',
                  selected: selectedStatus == TaskStatus.inProgress,
                  onTap: () => onStatusChanged(TaskStatus.inProgress),
                ),
                _GlassChip(
                  label: 'Done',
                  selected: selectedStatus == TaskStatus.done,
                  onTap: () => onStatusChanged(TaskStatus.done),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TaskSort>(
              value: sort,
              dropdownColor: kInk,
              iconEnabledColor: Colors.white,
              borderRadius: BorderRadius.circular(18),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
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
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? kLavenderBright
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? kInk : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
