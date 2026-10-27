import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// XpTransactions table - Ledger transaksi XP
/// 
/// Sesuai PRD FR-15: XP diberikan satu kali per kejadian tugas yang diselesaikan
/// Ledger ini mencegah XP ganda untuk occurrence yang sama
class XpTransactions extends Table {
  /// UUID primary key
  TextColumn get id => text().clientDefault(UuidGenerator.generateXpTransactionId)();
  
  /// Foreign key ke TaskOccurrences (bisa null untuk XP dari sumber lain)
  TextColumn get occurrenceId => text().nullable()();
  
  /// Foreign key ke Tasks (optional, untuk referensi)
  TextColumn get taskId => text().nullable()();
  
  /// Jumlah XP (positif atau negatif)
  IntColumn get xpAmount => integer()();
  
  /// Alasan: 'task_completed', 'achievement_unlocked', 'reward_claimed', etc
  TextColumn get reason => text()();
  
  /// Deskripsi tambahan
  TextColumn get description => text().nullable()();
  
  /// Timestamp transaksi
  DateTimeColumn get transactedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}


