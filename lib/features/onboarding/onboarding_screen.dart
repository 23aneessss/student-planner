// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_button.dart';
import '../../providers/app_providers.dart';
import '../../theme/tokens.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_OnboardingPage> _pages = <_OnboardingPage>[
    _OnboardingPage(
      icon: Icons.calendar_month_rounded,
      accent: kLavenderBright,
      title: 'Plan your\nsemester',
      subtitle: 'Map classes, deadlines, and routines in one calm workspace.',
    ),
    _OnboardingPage(
      icon: Icons.timer_rounded,
      accent: kCoral,
      title: 'Stay\nfocused',
      subtitle:
          'Move from task lists into deep work with built-in Pomodoro timing.',
    ),
    _OnboardingPage(
      icon: Icons.insights_rounded,
      accent: Color(0xFFBFE5FF),
      title: 'Track\nprogress',
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
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  await ref
                      .read(sharedPreferencesProvider)
                      .setBool(kOnboardingDoneKey, true);
                  ref.read(onboardingProvider.notifier).state = true;
                  if (!context.mounted) return;
                  context.go('/sign-in');
                },
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (int value) => setState(() => _page = value),
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _OnboardingPageView(page: _pages[index]);
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _pages.length,
                (int index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
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
              onPressed: () => context.go('/sign-in'),
              child: const Text('I already have an account'),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    page.accent.withValues(alpha: 0.34),
                    page.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            Container(
              width: 152,
              height: 152,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1.4,
                ),
              ),
              child: Icon(page.icon, color: page.accent, size: 64),
            ),
          ],
        ),
        const SizedBox(height: 38),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 16),
        Text(
          page.subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: kMutedText),
        ),
      ],
    );
  }
}
