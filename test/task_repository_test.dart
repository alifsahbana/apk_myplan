import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/tasks/data/task_repository.dart';
import 'package:apk_myplant/features/tasks/data/task_list_repository.dart';

void main() {
  late AppDatabase db;
  late TaskRepository taskRepo;
  late TaskListRepository listRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    taskRepo = TaskRepository(db);
    listRepo = TaskListRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TaskListRepository tests', () {
    test('ensureDefaultList creates default category if none exists', () async {
      await listRepo.ensureDefaultList();
      final lists = await listRepo.getAllLists();
      expect(lists.isNotEmpty, isTrue);
      expect(lists.first.name, equals('Umum'));
    });

    test('createList creates custom list and can retrieve it', () async {
      final list = await listRepo.createList(
        name: 'Kuliah',
        colorHex: '#42BCEB',
        iconName: 'school',
      );
      expect(list.name, equals('Kuliah'));

      final retrieved = await listRepo.getListById(list.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, equals('Kuliah'));
    });

    test('deleteList soft-deletes the list', () async {
      final list = await listRepo.createList(name: 'Proyek Sampingan');
      await listRepo.deleteList(list.id);

      final activeLists = await listRepo.getAllLists();
      expect(activeLists.any((l) => l.id == list.id), isFalse);
    });
  });

  group('TaskRepository tests', () {
    test('createTask saves task to database and returns it', () async {
      final today = DateTime.now();
      final task = await taskRepo.createTask(
        title: 'Menyelesaikan Tugas Akhir',
        description: 'Bab 1 dan Bab 2',
        listId: 'default-list',
        scheduledDate: today,
        scheduledTime: '09:00',
        priority: 'high',
        isStarred: true,
      );

      expect(task.title, equals('Menyelesaikan Tugas Akhir'));
      expect(task.status, equals('pending'));
      expect(task.isStarred, isTrue);

      final byDate = await taskRepo.getTasksByDate(today);
      expect(byDate.any((t) => t.id == task.id), isTrue);
    });

    test('toggleTaskCompletion switches between pending and completed', () async {
      final today = DateTime.now();
      final task = await taskRepo.createTask(
        title: 'Beli Pupuk',
        listId: 'default-list',
        scheduledDate: today,
      );

      expect(task.status, equals('pending'));

      final completedTask = await taskRepo.toggleTaskCompletion(task.id);
      expect(completedTask, isNotNull);
      expect(completedTask!.status, equals('completed'));
      expect(completedTask.completedAt, isNotNull);

      final revertedTask = await taskRepo.toggleTaskCompletion(task.id);
      expect(revertedTask, isNotNull);
      expect(revertedTask!.status, equals('pending'));
      expect(revertedTask.completedAt, isNull);
    });

    test('deleteTask performs soft deletion', () async {
      final today = DateTime.now();
      final task = await taskRepo.createTask(
        title: 'Tugas yang akan dihapus',
        listId: 'default-list',
        scheduledDate: today,
      );

      await taskRepo.deleteTask(task.id);

      final allActive = await taskRepo.getAllTasks();
      expect(allActive.any((t) => t.id == task.id), isFalse);

      final byDate = await taskRepo.getTasksByDate(today);
      expect(byDate.any((t) => t.id == task.id), isFalse);
    });

    test('getStarredTasks only retrieves starred tasks', () async {
      final today = DateTime.now();
      final t1 = await taskRepo.createTask(
        title: 'Tugas Bintang',
        listId: 'default-list',
        scheduledDate: today,
        isStarred: true,
      );
      await taskRepo.createTask(
        title: 'Tugas Biasa',
        listId: 'default-list',
        scheduledDate: today,
        isStarred: false,
      );

      final starred = await taskRepo.getStarredTasks();
      expect(starred.length, equals(1));
      expect(starred.first.id, equals(t1.id));
    });
  });
}
