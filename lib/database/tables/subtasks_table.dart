import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// Subtasks table - Checklist items dalam tugas
/// 
/// Sesuai PRD FR-04: Tugas dapat memiliki checklist/subtask
class Subtasks extends Table {
  /// UUID primary key
  TextColumn get id => text().clientDefault(UuidGenerator.generateSubtaskId)();
  
  /// Foreign key ke Tasks
  TextColumn get taskId => text()();
  
  /// Judul subtask
  TextColumn get title => text().withLength(min: 1, max: 300)();
  
  /// Status selesai
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  
  /// Urutan tampilan
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  
  /// Soft delete flag
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


