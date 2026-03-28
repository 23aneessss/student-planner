// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/app_providers.dart';
import 'providers/auth_provider.dart';
import 'router/router.dart';
import 'theme/tokens.dart';

class PlanoraApp extends ConsumerWidget {
  const PlanoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    ref.watch(appBootstrapProvider);
    ref.watch(authProvider);
    ref.watch(onboardingProvider);

    return MaterialApp.router(
      title: 'PLANORA',
      debugShowCheckedModeBanner: false,
      theme: PlanoraTheme.build(),
      routerConfig: createRouter(ref),
    );
  }
}
