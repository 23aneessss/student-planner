// lib/core/widgets/gradient_scaffold.dart
import 'package:flutter/material.dart';

import '../constants.dart';
import '../../theme/tokens.dart';
import 'cloud_decoration.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.clouds = const <CloudPosition>[],
    this.resizeToAvoidBottomInset = true,
    this.backgroundImageAsset,
    this.usePrimaryBackground = true,
    this.showCloudsWithBackground = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<CloudPosition> clouds;
  final bool resizeToAvoidBottomInset;
  final String? backgroundImageAsset;
  final bool usePrimaryBackground;
  final bool showCloudsWithBackground;

  @override
  Widget build(BuildContext context) {
    final String? effectiveBackgroundImageAsset =
        backgroundImageAsset ??
        (usePrimaryBackground ? kPrimaryBackgroundAsset : null);
    final bool renderClouds =
        clouds.isNotEmpty &&
        (effectiveBackgroundImageAsset == null || showCloudsWithBackground);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: kBgGradient),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (effectiveBackgroundImageAsset != null)
            Positioned.fill(
              child: IgnorePointer(
                child: Image.asset(
                  effectiveBackgroundImageAsset,
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  filterQuality: FilterQuality.high,
                  errorBuilder:
                      (BuildContext _, Object error, StackTrace? stackTrace) =>
                          const SizedBox.shrink(),
                ),
              ),
            ),
          if (renderClouds)
            ...clouds.map(
              (CloudPosition cloud) => CloudDecoration(position: cloud),
            ),
          Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: appBar,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            body: SafeArea(child: body),
          ),
        ],
      ),
    );
  }
}
