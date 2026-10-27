import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/tasks/data/task_repository.dart';
import 'package:apk_myplant/features/tasks/data/task_list_repository.dart';
import 'package:apk_myplant/features/gamification/domain/gamification_service.dart';

void main() {
  late AppDatabase db;
  late TaskRepository taskRepo;
  late TaskListRepository listRepo;
  late GamificationService gamificationService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    taskRepo = TaskRepository(db);
    listRepo = TaskListRepository(db);
    gamificationService = GamificationService(db);

    await listRepo.ensureDefaultList();
  });

  tearDown(() async {
    await db.close();
  });

  group('Gamification: Level calculation tests (FR-16)', () {
    test('Level 1 for 0 - 99 XP', () {
      expect(GamificationService.calculateLevel(0), 1);
      expect(GamificationService.calculateLevel(50), 1);
      expect(GamificationService.calculateLevel(99), 1);
    });

    test('Level 2 starts at 100 XP (100 required)', () {
      expect(GamificationService.calculateLevel(100), 2);
      expect(GamificationService.calculateLevel(249), 2);
    });

    test('Level 3 starts at 250 XP (100 + 150)', () {
      expect(GamificationService.calculateLevel(250), 3);
      expect(GamificationService.calculateLevel(449), 3);
    });
  });

  group('Gamification: XP Ledger idempotency tests (FR-15)', () {
    test('Completing a task awards exactly 10 XP once', () async {
      final task = await taskRepo.createTask(
        title: 'Belajar Flutter',
        listId: 'default-list',
        scheduledDate: DateTime.now(),
      );

      final xpFirst = await gamificationService.onTaskCompleted(task.id);
      expect(xpFirst, 10);

      final user = await gamificationService.getUserProgress();
      expect(user.totalXp, 10);

      // Selesaikan lagi (misal uncheck lalu check ulang) -> tidak dapat XP kedua
      final xpSecond = await gamificationService.onTaskCompleted(task.id);
      expect(xpSecond, 0);

      final userAfter = await gamificationService.getUserProgress();
      expect(userAfter.totalXp, 10); // Tetap 10, tidak menjadi 20
    });
  });

  group('Gamification: Streak 70% threshold tests (FR-17)', () {
    test('7 out of 10 tasks (70%) meets streak target', () async {
      final today = TaskRepository.formatDate(DateTime.now());

      // Buat 10 tugas
      for (int i = 1; i <= 10; i++) {
        final t = await taskRepo.createTask(
          title: 'Tugas $i',
          listId: 'default-list',
          scheduledDate: DateTime.now(),
        );
        // Selesaikan 7 tugas pertama
        if (i <= 7) {
          await taskRepo.toggleTaskCompletion(t.id);
        }
      }

      final record = await gamificationService.updateDailyRecord(today);
      expect(record.eligibleTaskCount, 10);
      expect(record.completedEligibleCount, 7);
      expect(record.completionPercentage, 70.0);
      expect(record.targetMet, true);
    });

    test('2 out of 3 tasks (66.7%) DOES NOT meet streak target (needs ceil: 3)', () async {
      final today = TaskRepository.formatDate(DateTime.now());

      // Buat 3 tugas
      for (int i = 1; i <= 3; i++) {
        final t = await taskRepo.createTask(
          title: 'Tugas $i',
          listId: 'default-list',
          scheduledDate: DateTime.now(),
        );
        // Selesaikan 2 tugas
        if (i <= 2) {
          await taskRepo.toggleTaskCompletion(t.id);
        }
      }

      final record = await gamificationService.updateDailyRecord(today);
      expect(record.eligibleTaskCount, 3);
      expect(record.completedEligibleCount, 2);
      expect(record.targetMet, false); // Harus 3 tugas untuk mencapai 70%
    });

    test('3 out of 4 tasks (75%) meets streak target', () async {
      final today = TaskRepository.formatDate(DateTime.now());

      for (int i = 1; i <= 4; i++) {
        final t = await taskRepo.createTask(
          title: 'Tugas $i',
          listId: 'default-list',
          scheduledDate: DateTime.now(),
        );
        if (i <= 3) {
          await taskRepo.toggleTaskCompletion(t.id);
        }
      }

      final record = await gamificationService.updateDailyRecord(today);
      expect(record.eligibleTaskCount, 4);
      expect(record.completedEligibleCount, 3);
      expect(record.targetMet, true);
    });

    test('Adding a task mid-day increases denominator and recalculates progress', () async {
      final today = TaskRepository.formatDate(DateTime.now());

      // Awalnya 1 dari 1 tugas selesai (100% target met)
      final t1 = await taskRepo.createTask(
        title: 'Tugas 1',
        listId: 'default-list',
        scheduledDate: DateTime.now(),
      );
      await taskRepo.toggleTaskCompletion(t1.id);
      var record = await gamificationService.updateDailyRecord(today);
      expect(record.targetMet, true);

      // Tambah tugas kedua di tengah hari tapi belum selesai (1 dari 2 = 50%, target not met)
      await taskRepo.createTask(
        title: 'Tugas 2',
        listId: 'default-list',
        scheduledDate: DateTime.now(),
      );
      record = await gamificationService.updateDailyRecord(today);
      expect(record.eligibleTaskCount, 2);
      expect(record.completedEligibleCount, 1);
      expect(record.completionPercentage, 50.0);
      expect(record.targetMet, false);
    });
  });
}
