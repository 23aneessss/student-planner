// test/mocks/mock_api_client.dart
import 'package:mocktail/mocktail.dart';
import 'package:planora/data/remote/api_client.dart';
import 'package:planora/data/remote/sync_remote.dart';
import 'package:planora/providers/notifications_provider.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSyncRemote extends Mock implements SyncRemote {}

class MockNotificationsService extends Mock
    implements PlanoraNotificationsService {}
