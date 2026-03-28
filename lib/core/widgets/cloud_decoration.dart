// lib/core/widgets/cloud_decoration.dart
import 'package:flutter/material.dart';

enum CloudPosition { topRight, bottomLeft, bottomRight, topLeft }

class CloudDecoration extends StatelessWidget {
  const CloudDecoration({super.key, required this.position});

  final CloudPosition position;

  @override
  Widget build(BuildContext context) {
    final Positioned positioned = switch (position) {
      CloudPosition.topRight => const Positioned(
        top: -24,
        right: -28,
        child: _CloudSurface(width: 220),
      ),
      CloudPosition.bottomLeft => const Positioned(
        bottom: 64,
        left: -40,
        child: _CloudSurface(width: 200),
      ),
      CloudPosition.bottomRight => const Positioned(
        bottom: -8,
        right: -34,
        child: _CloudSurface(width: 180),
      ),
      CloudPosition.topLeft => const Positioned(
        top: -16,
        left: -36,
        child: _CloudSurface(width: 200),
      ),
    };
    return positioned;
  }
}

class _CloudSurface extends StatelessWidget {
  const _CloudSurface({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ExcludeSemantics(
        child: Image.asset(
          'assets/images/cloud.png',
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext _, Object error, StackTrace? stackTrace) =>
                  const _CloudBlob(),
        ),
      ),
    );
  }
}

class _CloudBlob extends StatelessWidget {
  const _CloudBlob();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 120,
      child: Stack(
        children: <Widget>[
          _bubble(left: 0, top: 36, width: 84, height: 48),
          _bubble(left: 42, top: 10, width: 88, height: 64),
          _bubble(left: 102, top: 22, width: 96, height: 54),
          _bubble(left: 146, top: 44, width: 58, height: 40),
        ],
      ),
    );
  }

  Widget _bubble({
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
