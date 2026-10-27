import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../core/uuid_generator.dart';
import 'tables/task_lists_table.dart';
import 'tables/tasks_table.dart';
import 'tables/subtasks_table.dart';
import 'tables/task_occurrences_table.dart';
import 'tables/xp_transactions_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/daily_records_table.dart';
import 'tables/achievements_table.dart';
import 'tables/rewards_table.dart';
import 'tables/app_settings_table.dart';

part 'app_database.g.dart';

/// MyPlan main database
/// 
/// Single source of truth for all local data:
/// - Tasks, categories, subtasks, occurrences
/// - Gamification: XP, level, streak, achievements, rewards
/// - Daily productivity records
/// - App settings
@DriftDatabase(tables: [
  TaskLists,
  Tasks,
  Subtasks,
  TaskOccurrences,
  XpTransactions,
  UserProgress,
  DailyRecords,
  Achievements,
  UserAchievements,
  Rewards,
  UserRewards,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will be handled here
      },
    );
  }

  /// Query: Get all task lists
  Future<List<TaskList>> getAllTaskLists() {
    return (select(taskLists)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Query: Get user progress
  Future<UserProgressData?> getUserProgress() {
    return (select(userProgress)..limit(1)).getSingleOrNull();
  }

  /// Query: Get app setting by key
  Future<String?> getSetting(String key) async {
    final setting = await (select(appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return setting?.value;
  }

  /// Update app setting
  Future<void> updateSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        key: key,
        value: value,
      ),
    );
  }
}

/// Open database connection
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'myplan_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
