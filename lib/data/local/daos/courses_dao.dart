// lib/data/local/daos/courses_dao.dart
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/models/course.dart' as model;
import '../database.dart';
import '../tables/courses_table.dart';

part 'courses_dao.g.dart';

@DriftAccessor(tables: <Type>[Courses])
class CoursesDao extends DatabaseAccessor<AppDatabase> with _$CoursesDaoMixin {
  CoursesDao(super.db);

  Stream<List<model.Course>> watchAll() {
    final Selectable<Course> query = (select(courses)
      ..where((Courses tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function(Courses)>[
        (Courses tbl) => OrderingTerm.asc(tbl.name),
      ]));
    return query.watch().map((List<Course> rows) => rows.map(_mapRow).toList());
  }

  Future<model.Course?> getById(String id) async {
    final Course? row = await (select(
      courses,
    )..where((Courses tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> upsert(model.Course course) {
    return into(courses).insertOnConflictUpdate(_toCompanion(course));
  }

  Future<void> softDelete(String id, DateTime updatedAt) {
    return (update(courses)..where((Courses tbl) => tbl.id.equals(id))).write(
      CoursesCompanion(
        deletedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
        updatedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
      ),
    );
  }

  model.Course _mapRow(Course row) {
    return model.Course(
      id: row.id,
      name: row.name,
      colorHex: row.colorHex,
      instructor: row.instructor,
      schedule: (jsonDecode(row.schedule) as List<dynamic>)
          .map(
            (dynamic item) => model.CourseScheduleEntry.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      semester: row.semester,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      deletedAt: row.deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.deletedAt!),
    );
  }

  CoursesCompanion _toCompanion(model.Course course) {
    return CoursesCompanion(
      id: Value<String>(course.id),
      name: Value<String>(course.name),
      colorHex: Value<String>(course.colorHex),
      instructor: Value<String?>(course.instructor),
      schedule: Value<String>(
        jsonEncode(
          course.schedule
              .map((model.CourseScheduleEntry entry) => entry.toJson())
              .toList(),
        ),
      ),
      semester: Value<String>(course.semester),
      updatedAt: Value<int>(course.updatedAt.millisecondsSinceEpoch),
      deletedAt: Value<int?>(course.deletedAt?.millisecondsSinceEpoch),
    );
  }
}
