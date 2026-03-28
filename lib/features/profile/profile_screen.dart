// lib/features/profile/profile_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../data/local/database.dart' hide Task;
import '../../domain/models/task.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../theme/tokens.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState? auth = ref.watch(authProvider).valueOrNull;
    final user = auth?.user;

    return GradientScaffold(
      appBar: AppBar(title: const Text('Profile')),
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    border: Border.all(color: kLavender, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: user?.avatarUrl != null
                        ? CachedNetworkImage(
                            imageUrl: user!.avatarUrl!,
                            fit: BoxFit.cover,
                            errorWidget:
                                (BuildContext _, String url, Object error) =>
                                    _initials(user.fullName),
                          )
                        : _initials(user?.fullName ?? 'PL'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user?.fullName ?? 'PLANORA Student',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user?.email ?? 'No email',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.scholarYear ?? 'Student',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: kLavender),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _Section(
            title: 'Settings',
            child: Column(
              children: <Widget>[
                SwitchListTile.adaptive(
                  value: user?.notificationsEnabled ?? true,
                  title: const Text('Notifications'),
                  subtitle: const Text('Task reminders and Pomodoro alerts'),
                  onChanged: (bool value) {
                    if (user != null) {
                      ref
                          .read(authProvider.notifier)
                          .updateProfile(
                            user.copyWith(notificationsEnabled: value),
                          );
                    }
                  },
                ),
                SwitchListTile.adaptive(
                  value: user?.syncEnabled ?? true,
                  title: const Text('Sync'),
                  subtitle: Text(
                    ref.watch(syncProvider).lastSyncedAt == null
                        ? 'Not synced yet'
                        : 'Last sync: ${ref.watch(syncProvider).lastSyncedAt}',
                  ),
                  onChanged: (bool value) {
                    if (user != null) {
                      ref
                          .read(authProvider.notifier)
                          .updateProfile(user.copyWith(syncEnabled: value));
                    }
                  },
                ),
                ListTile(
                  title: const Text('Grade scale'),
                  subtitle: Text(user?.gradeScale ?? '20'),
                  trailing: SegmentedButton<String>(
                    segments: const <ButtonSegment<String>>[
                      ButtonSegment(value: '20', label: Text('20')),
                      ButtonSegment(value: '100', label: Text('100')),
                      ButtonSegment(value: '4.0', label: Text('4.0')),
                    ],
                    selected: <String>{user?.gradeScale ?? '20'},
                    onSelectionChanged: (Set<String> values) {
                      if (user != null) {
                        ref
                            .read(authProvider.notifier)
                            .updateProfile(
                              user.copyWith(gradeScale: values.first),
                            );
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Import'),
                  subtitle: const Text('Pick a CSV or ICS file'),
                  trailing: IconButton(
                    onPressed: () async {
                      final String message = await ref
                          .read(taskActionsProvider)
                          .importTasks();
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                    icon: const Icon(Icons.file_open_outlined),
                  ),
                ),
                ListTile(
                  title: const Text('Export'),
                  subtitle: const Text('Generate tasks.csv and calendar.ics'),
                  trailing: IconButton(
                    onPressed: () async {
                      final List<Task> tasks = await ref.read(
                        rawTasksProvider.future,
                      );
                      await ref.read(taskActionsProvider).exportTasks(tasks);
                    },
                    icon: const Icon(Icons.ios_share_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _Section(
            title: 'Danger zone',
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Delete all data'),
                  textColor: kCoral,
                  iconColor: kCoral,
                  trailing: const Icon(Icons.delete_outline_rounded),
                  onTap: () async {
                    final AppDatabase db = ref.read(appDatabaseProvider);
                    await db.transaction(() async {
                      await db.delete(db.outboxEvents).go();
                      await db.delete(db.grades).go();
                      await db.delete(db.pomodoroSessions).go();
                      await db.delete(db.tasks).go();
                      await db.delete(db.courses).go();
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All local data deleted.'),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  title: const Text('Sign out'),
                  textColor: kCoral,
                  iconColor: kCoral,
                  trailing: const Icon(Icons.logout_rounded),
                  onTap: () async {
                    await ref.read(authProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/sign-in');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    final String initials = parts
        .take(2)
        .map((String part) => part[0])
        .join()
        .toUpperCase();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kGlassSurface,
        borderRadius: kCardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          child,
        ],
      ),
    );
  }
}
