import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

class PlanoraScreenHeader extends StatelessWidget {
  const PlanoraScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.action,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? action;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (onBack != null) ...<Widget>[
                _IconBubble(icon: Icons.arrow_back_rounded, onTap: onBack!),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (eyebrow != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          eyebrow!.toUpperCase(),
                          style: textTheme.labelMedium?.copyWith(
                            color: kLavenderBright,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    Text(title, style: textTheme.titleLarge),
                  ],
                ),
              ),
              if (action != null) ...<Widget>[
                const SizedBox(width: 12),
                action!,
              ],
            ],
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(color: kMutedText),
            ),
          ],
        ],
      ),
    );
  }
}

class PlanoraHeaderAction extends StatelessWidget {
  const PlanoraHeaderAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return _IconBubble(icon: icon, onTap: onTap, tooltip: tooltip);
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.onTap, this.tooltip});

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Widget bubble = InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Ink(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: bubble);
    }
    return bubble;
  }
}
