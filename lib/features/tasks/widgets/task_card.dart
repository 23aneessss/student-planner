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
    final bool isDone = task.status == TaskStatus.done;
    return Semantics(
      button: true,
      label: task.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: kCardRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: kCardSurface,
            borderRadius: kCardRadius,
            border: Border.all(color: kCardBorder),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: kInk.withValues(alpha: 0.1),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(24),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: isDone,
                      onChanged: (_) => onToggle?.call(),
                      activeColor: kLavenderBright,
                      side: BorderSide(
                        color: kCardSubtext.withValues(alpha: 0.34),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  task.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        decoration: isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: isDone
                                            ? kCardSubtext.withValues(
                                                alpha: 0.64,
                                              )
                                            : kCardText,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _PriorityHalo(priority: task.priority),
                            ],
                          ),
                          if (task.description?.isNotEmpty ??
                              false) ...<Widget>[
                            const SizedBox(height: 8),
                            Text(
                              task.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: kCardSubtext),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Text(
                            isDone ? 'Completed' : 'Next up',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: kCardSubtext,
                                  letterSpacing: 1,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              if (task.dueDate != null)
                                _Pill(
                                  label: task.dueDate!.weekdayAndDate,
                                  background: kCardSurfaceSoft,
                                  icon: Icons.event_outlined,
                                  textColor: kCardText,
                                ),
                              _Pill(
                                label: task.priority.name.capitalized,
                                background: _priorityColor(task.priority),
                                textColor: task.priority == TaskPriority.medium
                                    ? kInk
                                    : Colors.white,
                              ),
                              if (task.description?.isNotEmpty ?? false)
                                _Pill(
                                  label: 'Has notes',
                                  background: kCardSurfaceSoft,
                                  icon: Icons.notes_rounded,
                                  textColor: kCardText,
                                ),
                            ],
                          ),
                        ],
                      ),
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
        return kCardSurfaceSoft;
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
    this.icon,
    this.textColor = Colors.white,
  });

  final String label;
  final Color background;
  final IconData? icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityHalo extends StatelessWidget {
  const _PriorityHalo({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (priority) {
      TaskPriority.low => kCardBorder,
      TaskPriority.medium => kLavenderBright,
      TaskPriority.high => kCoral,
      TaskPriority.urgent => kError,
    };

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
