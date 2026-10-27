import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// Tasks table - Tugas utama
/// 
/// Sesuai PRD FR-02: Setiap tugas minimal memiliki ID, judul, tanggal, status, dll
class Tasks extends Table {
  /// UUID primary key
  TextColumn get id => text().clientDefault(UuidGenerator.generateTaskId)();
  
  /// Judul tugas (WAJIB)
  TextColumn get title => text().withLength(min: 1, max: 500)();
  
  /// Deskripsi/catatan (opsional)
  TextColumn get description => text().nullable()();
  
  /// Foreign key ke TaskLists
  TextColumn get listId => text()();
  
  /// Tanggal tugas (LocalDate as ISO string)
  TextColumn get scheduledDate => text()();
  
  /// Waktu tugas (HH:mm format, opsional)
  TextColumn get scheduledTime => text().nullable()();
  
  /// Prioritas: 'low', 'medium', 'high'
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  
  /// Bintang/favorit flag
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  
  /// Status: 'pending', 'completed', 'cancelled'
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// Recurrence rule (JSON string, opsional)
  /// Format: {"type": "daily|weekly|monthly", "interval": 1, "endDate": "..."}
  TextColumn get recurrenceRule => text().nullable()();
  
  /// Parent task ID untuk subtask (opsional)
  TextColumn get parentTaskId => text().nullable()();
  
  /// Soft delete flag
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


