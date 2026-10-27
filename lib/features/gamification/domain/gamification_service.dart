import 'dart:math';
import 'package:drift/drift.dart';
import 'package:apk_myplant/core/uuid_generator.dart';
import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/tasks/data/task_repository.dart';

/// Service untuk menangani logika bisnis gamifikasi MyPlan
/// Sesuai PRD FR-15 (XP), FR-16 (Level), FR-17 (Streak 70%), FR-18 (Achievement), FR-19 (Reward)
class GamificationService {
  final AppDatabase _db;

  GamificationService(this._db);

  /// Default XP per kejadian tugas yang diselesaikan pertama kali (PRD FR-15)
  static const int xpPerTask = 10;

  /// Ambang batas target harian untuk streak (PRD FR-17: 70%)
  static const double streakThreshold = 0.70;

  /// Hitung level berdasarkan total XP:
  /// Level 1: 0 - 99 XP
  /// Kebutuhan XP untuk naik dari level L ke L+1: 100 + 50 * (L - 1)
  static int calculateLevel(int totalXp) {
    if (totalXp <= 0) return 1;
    int lvl = 1;
    int xpForNext = 100;
    int remainingXp = totalXp;

    while (remainingXp >= xpForNext) {
      remainingXp -= xpForNext;
      lvl++;
      xpForNext = 100 + 50 * (lvl - 1);
    }
    return lvl;
  }

  /// Hitung progres XP menuju level berikutnya [0.0 - 1.0]
  static double calculateLevelProgress(int totalXp) {
    if (totalXp <= 0) return 0.0;
    int lvl = 1;
    int xpForNext = 100;
    int remainingXp = totalXp;

    while (remainingXp >= xpForNext) {
      remainingXp -= xpForNext;
      lvl++;
      xpForNext = 100 + 50 * (lvl - 1);
    }
    return remainingXp / xpForNext;
  }

  /// Dapatkan data profil pengguna saat ini
  Future<UserProgressData> getUserProgress() async {
    final existing = await (_db.select(_db.userProgress)..limit(1)).getSingleOrNull();
    if (existing != null) return existing;

    // Buat profil default jika belum ada
    await _db.into(_db.userProgress).insert(
      UserProgressCompanion.insert(
        id: const Value('user-default'),
        totalXp: const Value(0),
        currentLevel: const Value(1),
        currentStreak: const Value(0),
        bestStreak: const Value(0),
        lastEvaluatedDate: Value(DateTime.now()),
      ),
    );
    return (await (_db.select(_db.userProgress)..limit(1)).getSingle());
  }

  /// Dipanggil saat tugas selesai. Memberikan 10 XP jika belum pernah diselesaikan,
  /// mengupdate level, dan mengecek achievement.
  Future<int> onTaskCompleted(String taskId, {String? occurrenceDate}) async {
    final occDate = occurrenceDate ?? TaskRepository.formatDate(DateTime.now());

    // Cek apakah sudah pernah diberi XP untuk occurrence ini (Idempoten ledger FR-15)
    final existingTx = await (_db.select(_db.xpTransactions)
          ..where((x) => x.taskId.equals(taskId))
          ..where((x) => x.reason.equals('task_completed')))
        .getSingleOrNull();

    if (existingTx != null) {
      // Sudah pernah dapat XP untuk tugas ini, jangan beri XP lagi
      return 0;
    }

    // Catat transaksi XP
    await _db.into(_db.xpTransactions).insert(
      XpTransactionsCompanion.insert(
        id: Value(UuidGenerator.generateXpTransactionId()),
        taskId: Value(taskId),
        xpAmount: xpPerTask,
        reason: 'task_completed',
        description: const Value('Menyelesaikan tugas'),
        transactedAt: Value(DateTime.now()),
      ),
    );

    // Update total XP & Level di profil
    final currentProgress = await getUserProgress();
    final newTotalXp = currentProgress.totalXp + xpPerTask;
    final newLevel = calculateLevel(newTotalXp);

    await (_db.update(_db.userProgress)..where((u) => u.id.equals(currentProgress.id))).write(
      UserProgressCompanion(
        totalXp: Value(newTotalXp),
        currentLevel: Value(newLevel),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Evaluasi Daily Streak & Achievements
    await updateDailyRecord(occDate);
    await checkAchievements();

    return xpPerTask;
  }

  /// Update catatan produktivitas harian dan evaluasi streak 70% (FR-17)
  Future<DailyRecord> updateDailyRecord(String localDate) async {
    // Ambil semua tugas untuk tanggal ini
    final allTasks = await (_db.select(_db.tasks)
          ..where((t) => t.scheduledDate.equals(localDate))
          ..where((t) => t.isDeleted.equals(false)))
        .get();

    final totalEligible = allTasks.length;
    final completedCount = allTasks.where((t) => t.status == 'completed').length;
    final percentage = totalEligible > 0 ? (completedCount / totalEligible) * 100.0 : 0.0;
    
    // Syarat streak: minimal 70% (pembulatan ke atas / ceil)
    final minRequired = (totalEligible * streakThreshold).ceil();
    final targetMet = totalEligible > 0 && completedCount >= minRequired;

    final existingRecord = await (_db.select(_db.dailyRecords)
          ..where((r) => r.localDate.equals(localDate)))
        .getSingleOrNull();

    if (existingRecord != null) {
      await (_db.update(_db.dailyRecords)..where((r) => r.localDate.equals(localDate))).write(
        DailyRecordsCompanion(
          eligibleTaskCount: Value(totalEligible),
          completedEligibleCount: Value(completedCount),
          completionPercentage: Value(percentage),
          targetMet: Value(targetMet),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.into(_db.dailyRecords).insert(
        DailyRecordsCompanion.insert(
          localDate: localDate,
          eligibleTaskCount: Value(totalEligible),
          completedEligibleCount: Value(completedCount),
          completionPercentage: Value(percentage),
          targetMet: Value(targetMet),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    // Evaluasi streak akumulatif jika target tercapai
    await _recalculateStreak();

    return (await (_db.select(_db.dailyRecords)..where((r) => r.localDate.equals(localDate))).getSingle());
  }

  /// Hitung ulang streak berturut-turut berdasarkan riwayat DailyRecords
  Future<void> _recalculateStreak() async {
    final records = await (_db.select(_db.dailyRecords)
          ..orderBy([(r) => OrderingTerm.desc(r.localDate)]))
        .get();

    int streak = 0;
    final now = DateTime.now();
    final todayStr = TaskRepository.formatDate(now);
    final yesterdayStr = TaskRepository.formatDate(now.subtract(const Duration(days: 1)));

    // Jika hari ini belum memenuhi target, streak tidak putus selama kemarin memenuhi
    // atau hari ini sudah memenuhi target
    DateTime checkDate = now;
    final todayRecord = records.where((r) => r.localDate == todayStr).firstOrNull;
    
    if (todayRecord != null && todayRecord.targetMet) {
      streak++;
      checkDate = now.subtract(const Duration(days: 1));
    } else {
      // Cek mulai dari kemarin
      final yesterdayRecord = records.where((r) => r.localDate == yesterdayStr).firstOrNull;
      if (yesterdayRecord != null && yesterdayRecord.targetMet) {
        checkDate = now.subtract(const Duration(days: 1));
      } else {
        checkDate = now; // streak 0
      }
    }

    if (checkDate != now || (todayRecord != null && todayRecord.targetMet)) {
      while (true) {
        final dateStr = TaskRepository.formatDate(checkDate);
        if (dateStr == todayStr && todayRecord != null && todayRecord.targetMet) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        final r = records.where((rec) => rec.localDate == dateStr).firstOrNull;
        if (r != null && r.targetMet) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    final user = await getUserProgress();
    final best = max(user.bestStreak, streak);

    await (_db.update(_db.userProgress)..where((u) => u.id.equals(user.id))).write(
      UserProgressCompanion(
        currentStreak: Value(streak),
        bestStreak: Value(best),
        lastEvaluatedDate: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Cek dan buka achievement yang memenuhi kriteria
  Future<List<String>> checkAchievements() async {
    final unlockedNames = <String>[];
    final user = await getUserProgress();
    
    final allCompletedTasks = await (_db.select(_db.tasks)
          ..where((t) => t.status.equals('completed'))
          ..where((t) => t.isDeleted.equals(false)))
        .get();

    final taskCount = allCompletedTasks.length;
    final streakDays = user.currentStreak;

    // Pastikan achievement default terdaftar
    final definitions = await _db.select(_db.achievements).get();
    if (definitions.isEmpty) {
      await _insertInitialAchievements();
    }

    final allDefs = await _db.select(_db.achievements).get();
    final userAchs = await _db.select(_db.userAchievements).get();

    for (final def in allDefs) {
      final alreadyUnlocked = userAchs.any((ua) => ua.achievementId == def.id && ua.status == 'unlocked');
      if (alreadyUnlocked) continue;

      bool shouldUnlock = false;

      switch (def.criteriaType) {
        case 'task_completed':
          if (taskCount >= def.criteriaValue) shouldUnlock = true;
          break;
        case 'streak_days':
          if (streakDays >= def.criteriaValue) shouldUnlock = true;
          break;
        case 'level_reached':
          if (user.currentLevel >= def.criteriaValue) shouldUnlock = true;
          break;
        case 'daily_perfect':
          final todayStr = TaskRepository.formatDate(DateTime.now());
          final rec = await (_db.select(_db.dailyRecords)..where((r) => r.localDate.equals(todayStr))).getSingleOrNull();
          if (rec != null && rec.eligibleTaskCount > 0 && rec.completedEligibleCount == rec.eligibleTaskCount) {
            shouldUnlock = true;
          }
          break;
      }

      if (shouldUnlock) {
        await _db.into(_db.userAchievements).insertOnConflictUpdate(
          UserAchievementsCompanion.insert(
            id: Value(UuidGenerator.generateUserAchievementId()),
            achievementId: def.id,
            status: const Value('unlocked'),
            unlockedAt: Value(DateTime.now()),
          ),
        );
        unlockedNames.add(def.nameId);
      }
    }

    return unlockedNames;
  }

  /// Daftar achievement awal
  Future<void> _insertInitialAchievements() async {
    final list = [
      AchievementsCompanion.insert(
        id: 'first-step',
        name: 'First Step',
        nameId: 'Langkah Pertama',
        description: 'Complete your first task',
        descriptionId: 'Selesaikan tugas pertama Anda',
        criteriaType: 'task_completed',
        criteriaValue: 1,
        iconName: 'star',
        sortOrder: const Value(1),
      ),
      AchievementsCompanion.insert(
        id: 'streak-7',
        name: '7-Day Streak',
        nameId: 'Streak 7 Hari',
        description: 'Maintain a 7-day streak',
        descriptionId: 'Pertahankan streak selama 7 hari',
        criteriaType: 'streak_days',
        criteriaValue: 7,
        iconName: 'local_fire_department',
        sortOrder: const Value(2),
      ),
      AchievementsCompanion.insert(
        id: 'task-master',
        name: 'Task Master',
        nameId: 'Ahli Produktivitas',
        description: 'Complete 50 tasks',
        descriptionId: 'Selesaikan 50 tugas secara keseluruhan',
        criteriaType: 'task_completed',
        criteriaValue: 50,
        iconName: 'workspace_premium',
        sortOrder: const Value(3),
      ),
      AchievementsCompanion.insert(
        id: 'perfect-day',
        name: 'Perfect Day',
        nameId: 'Hari Sempurna',
        description: 'Complete 100% of daily tasks',
        descriptionId: 'Selesaikan 100% target tugas dalam satu hari',
        criteriaType: 'daily_perfect',
        criteriaValue: 100,
        iconName: 'verified',
        sortOrder: const Value(4),
      ),
    ];

    for (final c in list) {
      await _db.into(_db.achievements).insertOnConflictUpdate(c);
    }
  }
}
