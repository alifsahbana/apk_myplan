import 'package:drift/drift.dart';

/// DailyRecords table - Catatan produktivitas harian
/// 
/// Sesuai PRD FR-17: Streak calculation dengan ambang 70%
/// Menyimpan data harian untuk mencegah manipulasi streak
class DailyRecords extends Table {
  /// Tanggal lokal (LocalDate as ISO string, e.g., "2026-10-23")
  TextColumn get localDate => text()();
  
  /// Jumlah tugas eligible pada hari itu
  IntColumn get eligibleTaskCount => integer().withDefault(const Constant(0))();
  
  /// Jumlah tugas eligible yang selesai
  IntColumn get completedEligibleCount => integer().withDefault(const Constant(0))();
  
  /// Persentase penyelesaian (0-100)
  RealColumn get completionPercentage => real().withDefault(const Constant(0.0))();
  
  /// Target 70% tercapai?
  BoolColumn get targetMet => boolean().withDefault(const Constant(false))();
  
  /// Streak value pada akhir hari (untuk referensi)
  IntColumn get streakValueAtEod => integer().withDefault(const Constant(0))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {localDate};
}
