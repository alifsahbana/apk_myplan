import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// TaskOccurrences table - Kejadian tugas untuk tanggal tertentu
/// 
/// Sesuai PRD FR-07: Tugas berulang menghasilkan occurrence terpisah per tanggal
/// Ini penting agar penyelesaian hari ini tidak menyelesaikan kejadian berikutnya
class TaskOccurrences extends Table {
  /// UUID primary key
  TextColumn get id => text().clientDefault(UuidGenerator.generateOccurrenceId)();
  
  /// Foreign key ke Tasks
  TextColumn get taskId => text()();
  
  /// Tanggal occurrence ini (LocalDate as ISO string)
  TextColumn get occurrenceDate => text()();
  
  /// Status: 'pending', 'completed', 'cancelled', 'skipped'
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// XP sudah diberikan untuk occurrence ini?
  BoolColumn get xpAwarded => boolean().withDefault(const Constant(false))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {taskId, occurrenceDate}, // Satu occurrence per task per tanggal
  ];
}


