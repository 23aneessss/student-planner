// lib/data/local/daos/grades_dao.dart
import 'package:drift/drift.dart';

import '../../../domain/models/grade.dart' as model;
import '../database.dart';
import '../tables/grades_table.dart';

part 'grades_dao.g.dart';

@DriftAccessor(tables: <Type>[Grades])
class GradesDao extends DatabaseAccessor<AppDatabase> with _$GradesDaoMixin {
  GradesDao(super.db);

  Stream<List<model.Grade>> watchAll() {
    final Selectable<Grade> query = (select(grades)
      ..where((Grades tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function(Grades)>[
        (Grades tbl) => OrderingTerm.desc(tbl.gradedAt),
      ]));
    return query.watch().map((List<Grade> rows) => rows.map(_mapRow).toList());
  }

  Future<model.Grade?> getById(String id) async {
    final Grade? row = await (select(
      grades,
    )..where((Grades tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapRow(row);
  }

  Future<void> upsert(model.Grade grade) {
    return into(grades).insertOnConflictUpdate(_toCompanion(grade));
  }

  Future<void> softDelete(String id, DateTime updatedAt) {
    return (update(grades)..where((Grades tbl) => tbl.id.equals(id))).write(
      GradesCompanion(
        deletedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
        updatedAt: Value<int>(updatedAt.millisecondsSinceEpoch),
      ),
    );
  }

  model.Grade _mapRow(Grade row) {
    return model.Grade(
      id: row.id,
      courseId: row.courseId,
      title: row.title,
      score: row.score,
      maxScore: row.maxScore,
      weight: row.weight,
      type: _typeFromDb(row.type),
      gradedAt: DateTime.fromMillisecondsSinceEpoch(row.gradedAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
      deletedAt: row.deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.deletedAt!),
    );
  }

  GradesCompanion _toCompanion(model.Grade grade) {
    return GradesCompanion(
      id: Value<String>(grade.id),
      courseId: Value<String>(grade.courseId),
      title: Value<String>(grade.title),
      score: Value<double>(grade.score),
      maxScore: Value<double>(grade.maxScore),
      weight: Value<double>(grade.weight),
      type: Value<String>(grade.type.name),
      gradedAt: Value<int>(grade.gradedAt.millisecondsSinceEpoch),
      updatedAt: Value<int>(grade.updatedAt.millisecondsSinceEpoch),
      deletedAt: Value<int?>(grade.deletedAt?.millisecondsSinceEpoch),
    );
  }

  model.GradeType _typeFromDb(String value) {
    return model.GradeType.values.firstWhere(
      (model.GradeType type) => type.name == value,
      orElse: () => model.GradeType.assignment,
    );
  }
}
