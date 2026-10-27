import 'package:drift/drift.dart';

/// UserProgress table - Profil gamifikasi pengguna
/// 
/// Sesuai PRD FR-16, FR-17: Level dan Streak tracking
class UserProgress extends Table {
  /// User ID (untuk future multi-user support)
  TextColumn get id => text().withDefault(const Constant('user-default'))();
  
  /// Total XP yang terkumpul
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  
  /// Level saat ini (dihitung dari totalXp)
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  
  /// Streak saat ini (hari berturut-turut mencapai target)
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  
  /// Streak terbaik yang pernah dicapai
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  
  /// Tanggal terakhir dievaluasi untuk streak
  DateTimeColumn get lastEvaluatedDate => dateTime().clientDefault(() => DateTime.now())();
  
  /// Timestamps
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
