import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// Rewards table - Definisi reward virtual
/// 
/// Sesuai PRD FR-19: Reward virtual nonfinansial
class Rewards extends Table {
  /// Reward ID
  TextColumn get id => text()();
  
  /// Nama reward (English)
  TextColumn get name => text()();
  
  /// Nama reward (Indonesian)
  TextColumn get nameId => text()();
  
  /// Deskripsi
  TextColumn get description => text().nullable()();
  
  /// Deskripsi (Indonesian)
  TextColumn get descriptionId => text().nullable()();
  
  /// Tipe: 'badge', 'title', 'bonus_xp', 'theme'
  TextColumn get rewardType => text()();
  
  /// Nilai reward (e.g., bonus XP amount)
  TextColumn get rewardValue => text().nullable()();
  
  /// Syarat unlock (foreign key ke achievement ID atau kriteria)
  TextColumn get unlockCriteria => text()();
  
  /// Nama ikon
  TextColumn get iconName => text()();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

/// UserRewards table - Reward yang sudah diklaim user
class UserRewards extends Table {
  /// UUID
  TextColumn get id => text().clientDefault(UuidGenerator.generateUserRewardId)();
  
  /// Foreign key ke Rewards
  TextColumn get rewardId => text()();
  
  /// User ID
  TextColumn get userId => text().withDefault(const Constant('user-default'))();
  
  /// Status: 'locked', 'available', 'claimed'
  TextColumn get status => text().withDefault(const Constant('locked'))();
  
  /// Tanggal diklaim
  DateTimeColumn get claimedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {rewardId, userId}, // Satu reward per user
  ];
}


