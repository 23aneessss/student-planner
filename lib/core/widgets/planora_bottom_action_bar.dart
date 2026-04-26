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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
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
      color: isSelected ? kDark : Colors.white,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      height: 52,
      width: isSelected ? 124 : 52,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ]
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 14 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon,
                if (isSelected) ...<Widget>[
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kDark,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.1,
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
    required this.color,
  });

  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext _, Object error, StackTrace? stackTrace) =>
          Icon(fallbackIcon, size: size, color: color),
    );
  }
}
