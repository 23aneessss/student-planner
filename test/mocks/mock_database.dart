// test/mocks/mock_database.dart
import 'package:drift/native.dart';
import 'package:planora/data/local/database.dart';

AppDatabase buildTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
