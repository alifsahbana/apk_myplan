import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// Achievements table - Definisi achievement/badge
/// 
/// Sesuai PRD FR-18: Achievement definitions
class Achievements extends Table {
  /// Achievement ID
  TextColumn get id => text()();
  
  /// Nama (English)
  TextColumn get name => text()();
  
  /// Nama (Indonesian)
  TextColumn get nameId => text()();
  
  /// Deskripsi (English)
  TextColumn get description => text()();
  
  /// Deskripsi (Indonesian)
  TextColumn get descriptionId => text()();
  
  /// Kriteria tipe: 'task_completed', 'streak_days', 'daily_perfect', 'level_reached'
  TextColumn get criteriaType => text()();
  
  /// Kriteria value (threshold)
  IntColumn get criteriaValue => integer()();
  
  /// Nama ikon Material Icons
  TextColumn get iconName => text()();
  
  /// Urutan tampilan
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

/// UserAchievements table - Achievement yang sudah dibuka user
class UserAchievements extends Table {
  /// UUID
  TextColumn get id => text().clientDefault(UuidGenerator.generateUserAchievementId)();
  
  /// Foreign key ke Achievements
  TextColumn get achievementId => text()();
  
  /// User ID
  TextColumn get userId => text().withDefault(const Constant('user-default'))();
  
  /// Status: 'locked', 'unlocked'
  TextColumn get status => text().withDefault(const Constant('locked'))();
  
  /// Tanggal dibuka
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {achievementId, userId}, // Satu achievement per user
  ];
}


