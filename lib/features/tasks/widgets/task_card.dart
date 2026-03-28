// lib/features/tasks/widgets/task_card.dart
import 'package:flutter/material.dart';

import '../../../core/extensions.dart';
import '../../../domain/models/task.dart';
import '../../../theme/tokens.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap, this.onToggle});

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: task.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: kCardRadius,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kGlassSurface,
            borderRadius: kCardRadius,
            border: Border(
              left: BorderSide(color: _priorityColor(task.priority), width: 4),
            ),
          ),
          child: Row(
            children: <Widget>[
              Checkbox(
                value: task.status == TaskStatus.done,
                onChanged: (_) => onToggle?.call(),
                activeColor: kLavender,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        decoration: task.status == TaskStatus.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description?.isNotEmpty ?? false) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (task.dueDate != null)
                          _Pill(
                            label: task.dueDate!.weekdayAndDate,
                            background: Colors.white.withValues(alpha: 0.08),
                          ),
                        _Pill(
                          label: task.priority.name.capitalized,
                          background: _priorityColor(task.priority),
                          textColor: task.priority == TaskPriority.medium
                              ? kDark
                              : Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.white.withValues(alpha: 0.25);
      case TaskPriority.medium:
        return kLavender;
      case TaskPriority.high:
        return kCoral;
      case TaskPriority.urgent:
        return kError;
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    this.textColor = Colors.white,
  });

  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
