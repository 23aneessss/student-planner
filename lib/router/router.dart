// lib/router/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/sign_in_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/grades/grades_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/pomodoro/pomodoro_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/stats/stats_screen.dart';
import '../features/tasks/task_detail_screen.dart';
import '../features/tasks/tasks_screen.dart';
import '../core/constants.dart';
import '../core/widgets/planora_bottom_action_bar.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';

GoRouter createRouter(WidgetRef ref) {
  final AsyncValue<AuthState> auth = ref.watch(authProvider);
  final bool onboardingDone = ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final String location = state.matchedLocation;
      final bool authPath = location == '/sign-in' || location == '/sign-up';
      if (!onboardingDone && location != '/onboarding') {
        return '/onboarding';
      }
      if (auth.isLoading) {
        return null;
      }
      final bool isAuthenticated = auth.valueOrNull?.isAuthenticated ?? false;
      if (!isAuthenticated && !authPath && location != '/onboarding') {
        return '/sign-in';
      }
      if (isAuthenticated && authPath) {
        return '/';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (BuildContext context, GoRouterState state) =>
            const SignUpScreen(),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainShellScaffold(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) =>
                const HomeScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (BuildContext context, GoRouterState state) =>
                const TasksScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: ':id',
                builder: (BuildContext context, GoRouterState state) =>
                    TaskDetailScreen(taskId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/calendar',
            builder: (BuildContext context, GoRouterState state) =>
                const CalendarScreen(),
          ),
          GoRoute(
            path: '/pomodoro',
            builder: (BuildContext context, GoRouterState state) =>
                const PomodoroScreen(),
          ),
          GoRoute(
            path: '/stats',
            builder: (BuildContext context, GoRouterState state) =>
                const StatsScreen(),
          ),
          GoRoute(
            path: '/grades',
            builder: (BuildContext context, GoRouterState state) =>
                const GradesScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    final List<PlanoraNavItem> tabs = <PlanoraNavItem>[
      const PlanoraNavItem(
        label: 'Home',
        route: '/',
        assetPath: kNavHomeIconAsset,
        fallbackIcon: Icons.home_outlined,
      ),
      const PlanoraNavItem(
        label: 'Tasks',
        route: '/tasks',
        assetPath: kNavTasksIconAsset,
        fallbackIcon: Icons.task_alt_outlined,
      ),
      const PlanoraNavItem(
        label: 'Calendar',
        route: '/calendar',
        assetPath: kNavCalendarIconAsset,
        fallbackIcon: Icons.calendar_month_outlined,
      ),
      const PlanoraNavItem(
        label: 'Stats',
        route: '/stats',
        assetPath: kNavStatsIconAsset,
        fallbackIcon: Icons.bar_chart_rounded,
      ),
      const PlanoraNavItem(
        label: 'Profile',
        route: '/profile',
        assetPath: kNavProfileIconAsset,
        fallbackIcon: Icons.person_outline_rounded,
      ),
    ];
    final int index = tabs.indexWhere(
      (PlanoraNavItem tab) => tab.route == '/'
          ? location == tab.route
          : location == tab.route || location.startsWith('${tab.route}/'),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: child,
      bottomNavigationBar: PlanoraBottomActionBar(
        items: tabs,
        currentIndex: index < 0 ? 0 : index,
        onSelected: (int value) => context.go(tabs[value].route),
      ),
    );
  }
}
