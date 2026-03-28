// lib/core/widgets/gradient_scaffold.dart
import 'package:flutter/material.dart';

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
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<CloudPosition> clouds;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: kBgGradient),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ...clouds.map(
              (CloudPosition cloud) => CloudDecoration(position: cloud),
            ),
            SafeArea(child: body),
          ],
        ),
      ),
    );
  }
}
