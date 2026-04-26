// lib/features/profile/profile_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/cloud_decoration.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/planora_screen_header.dart';
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
    final DateTime? lastSync = ref.watch(syncProvider).lastSyncedAt;
    final String lastSyncLabel = lastSync == null
        ? 'Not synced yet'
        : 'Synced ${_relativeTime(lastSync)}';

    return GradientScaffold(
      clouds: const <CloudPosition>[CloudPosition.topRight],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          const PlanoraScreenHeader(eyebrow: 'You', title: 'Profile'),
          const SizedBox(height: 20),
          _ProfileHero(
            name: user?.fullName ?? 'PLANORA Student',
            email: user?.email ?? 'No email',
            year: user?.scholarYear ?? 'Student',
            avatarUrl: user?.avatarUrl,
            lastSyncLabel: lastSyncLabel,
          ),
          const SizedBox(height: 18),
          _Section(
            title: 'Preferences',
            child: Column(
              children: <Widget>[
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                const _Divider(),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  value: user?.syncEnabled ?? true,
                  title: const Text('Cloud sync'),
                  subtitle: Text(lastSyncLabel),
                  onChanged: (bool value) {
                    if (user != null) {
                      ref
                          .read(authProvider.notifier)
                          .updateProfile(user.copyWith(syncEnabled: value));
                    }
                  },
                ),
                const _Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Grade scale',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment(value: '20', label: Text('/20')),
                          ButtonSegment(value: '100', label: Text('/100')),
                          ButtonSegment(value: '4.0', label: Text('GPA 4.0')),
                        ],
                        selected: <String>{user?.gradeScale ?? '20'},
                        showSelectedIcon: false,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Data',
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.file_open_outlined),
                  title: const Text('Import'),
                  subtitle: const Text('CSV or ICS file'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final String message = await ref
                        .read(taskActionsProvider)
                        .importTasks();
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                    }
                  },
                ),
                const _Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.ios_share_rounded),
                  title: const Text('Export'),
                  subtitle: const Text('Generate tasks.csv and calendar.ics'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final List<Task> tasks = await ref.read(
                      rawTasksProvider.future,
                    );
                    await ref.read(taskActionsProvider).exportTasks(tasks);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Account',
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.delete_outline_rounded),
                  textColor: kCoral,
                  iconColor: kCoral,
                  title: const Text('Delete all data'),
                  subtitle: const Text('Wipes local database'),
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
                const _Divider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: const Icon(Icons.logout_rounded),
                  textColor: kCoral,
                  iconColor: kCoral,
                  title: const Text('Sign out'),
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

  String _relativeTime(DateTime time) {
    final Duration delta = DateTime.now().difference(time);
    if (delta.inMinutes < 1) return 'just now';
    if (delta.inMinutes < 60) return '${delta.inMinutes}m ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    return '${delta.inDays}d ago';
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.name,
    required this.email,
    required this.year,
    required this.avatarUrl,
    required this.lastSyncLabel,
  });

  final String name;
  final String email;
  final String year;
  final String? avatarUrl;
  final String lastSyncLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: kInk.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: <Color>[kLavenderBright, kLavender],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: kLavender.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl!,
                          fit: BoxFit.cover,
                          errorWidget:
                              (BuildContext _, String url, Object error) =>
                                  _initials(name),
                        )
                      : _initials(name),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        color: kCardText,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: textTheme.bodyMedium?.copyWith(
                        color: kCardSubtext,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              _Tag(
                icon: Icons.school_outlined,
                label: year,
                accent: kLavender,
              ),
              const SizedBox(width: 8),
              _Tag(
                icon: Icons.cloud_sync_outlined,
                label: lastSyncLabel,
                accent: kSuccess,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    final String initials = parts
        .take(2)
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0])
        .join()
        .toUpperCase();
    return Center(
      child: Text(
        initials.isEmpty ? 'PL' : initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label, required this.accent});

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14, color: accent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: kCardBorder,
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
        color: kCardSurface,
        borderRadius: kCardRadius,
        border: Border.all(color: kCardBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: kCardText),
          listTileTheme: const ListTileThemeData(
            textColor: kCardText,
            iconColor: kCardText,
            subtitleTextStyle: TextStyle(color: kCardSubtext, fontSize: 12),
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return kLavenderBright;
                }
                return kCardSurfaceSoft;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return kInk;
                }
                return kCardText;
              }),
              side: const WidgetStatePropertyAll(
                BorderSide(color: kCardBorder),
              ),
            ),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return kSuccess;
              }
              return kCardBorder;
            }),
          ),
        ),
        child: DefaultTextStyle.merge(
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: kCardText),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: kCardSubtext,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              child,
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
