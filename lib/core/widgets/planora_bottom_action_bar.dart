import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

class PlanoraNavItem {
  const PlanoraNavItem({
    required this.label,
    required this.route,
    required this.assetPath,
    required this.fallbackIcon,
  });

  final String label;
  final String route;
  final String assetPath;
  final IconData fallbackIcon;
}

class PlanoraBottomActionBar extends StatelessWidget {
  const PlanoraBottomActionBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<PlanoraNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFD5C1FF).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(items.length, (int index) {
                final PlanoraNavItem item = items[index];
                final bool isSelected = index == currentIndex;
                return _PlanoraNavButton(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onSelected(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanoraNavButton extends StatelessWidget {
  const _PlanoraNavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final PlanoraNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget icon = _NavAssetIcon(
      assetPath: item.assetPath,
      fallbackIcon: item.fallbackIcon,
      size: 22,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: 48,
      width: isSelected ? 108 : 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isSelected ? 1 : 0.88),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                if (isSelected) ...<Widget>[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavAssetIcon extends StatelessWidget {
  const _NavAssetIcon({
    required this.assetPath,
    required this.fallbackIcon,
    required this.size,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: kDark,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext _, Object error, StackTrace? stackTrace) =>
          Icon(fallbackIcon, size: size, color: kDark),
    );
  }
}
