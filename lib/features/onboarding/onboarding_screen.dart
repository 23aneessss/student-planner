// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../providers/app_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<({String title, String subtitle})>
  _pages = <({String title, String subtitle})>[
    (
      title: 'Plan your semester',
      subtitle: 'Map classes, deadlines, and routines in one calm workspace.',
    ),
    (
      title: 'Stay focused',
      subtitle:
          'Move from task lists into deep work with built-in Pomodoro timing.',
    ),
    (
      title: 'Track progress',
      subtitle:
          'See streaks, grades, and focus time without leaving the planner.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      usePrimaryBackground: false,
      clouds: const <CloudPosition>[
        CloudPosition.topRight,
        CloudPosition.bottomLeft,
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (int value) => setState(() => _page = value),
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Lottie.asset(
                        'assets/lottie/pomodoro_fire.json',
                        width: 220,
                        repeat: true,
                        errorBuilder:
                            (
                              BuildContext _,
                              Object error,
                              StackTrace? stackTrace,
                            ) => const Icon(
                              Icons.auto_awesome_rounded,
                              size: 160,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page.subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _pages.length,
                (int index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: _page == _pages.length - 1 ? 'Get started' : 'Next',
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: () async {
                if (_page == _pages.length - 1) {
                  await ref
                      .read(sharedPreferencesProvider)
                      .setBool(kOnboardingDoneKey, true);
                  ref.read(onboardingProvider.notifier).state = true;
                  if (!context.mounted) return;
                  context.go('/sign-in');
                  return;
                }
                await _controller.nextPage(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                );
              },
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(sharedPreferencesProvider)
                    .setBool(kOnboardingDoneKey, true);
                ref.read(onboardingProvider.notifier).state = true;
                if (!context.mounted) return;
                context.go('/sign-in');
              },
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
