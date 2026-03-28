// lib/providers/sync_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

enum SyncPhase { idle, syncing, error, done }

class SyncState {
  const SyncState({
    this.phase = SyncPhase.idle,
    this.message,
    this.lastSyncedAt,
  });

  final SyncPhase phase;
  final String? message;
  final DateTime? lastSyncedAt;

  SyncState copyWith({
    SyncPhase? phase,
    String? message,
    DateTime? lastSyncedAt,
  }) {
    return SyncState(
      phase: phase ?? this.phase,
      message: message ?? this.message,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

class SyncController extends StateNotifier<SyncState> {
  SyncController(this._ref) : super(const SyncState());

  final Ref _ref;

  Future<void> syncNow() async {
    state = state.copyWith(phase: SyncPhase.syncing, message: null);
    try {
      await _ref.read(syncRepositoryProvider).syncNow();
      state = state.copyWith(
        phase: SyncPhase.done,
        lastSyncedAt: DateTime.now(),
        message: 'Synced successfully.',
      );
    } catch (error) {
      state = state.copyWith(phase: SyncPhase.error, message: error.toString());
    }
  }
}

final syncProvider = StateNotifierProvider<SyncController, SyncState>(
  (Ref ref) => SyncController(ref),
);
