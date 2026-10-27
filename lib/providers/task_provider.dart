import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/gamification/domain/gamification_service.dart';
import 'package:apk_myplant/features/tasks/data/task_repository.dart';
import '../models/models.dart';

/// TaskProvider - State Management terintegrasi dengan AppDatabase (Drift SQLite)
/// dan GamificationService (XP, Level, Streak 70%, Achievements).
/// Sesuai PRD FR-02 (CRUD Tasks), FR-14 (Offline-first Persistence), FR-15-17 (Gamification).
class TaskProvider extends ChangeNotifier {
  final AppDatabase? _database;
  final GamificationService? _gamificationService;

  late UserModel _currentUser;
  final List<TaskModel> _tasks = [];
  String _selectedFilter = 'all'; // 'all', 'high', 'chill'
  DailyRecord? _todayRecord;

  UserModel get currentUser => _currentUser;
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  String get selectedFilter => _selectedFilter;
  DailyRecord? get todayRecord => _todayRecord;

  TaskProvider({AppDatabase? database, GamificationService? gamificationService})
      // ignore: prefer_initializing_formals
      : _database = database,
        // ignore: prefer_initializing_formals
        _gamificationService = gamificationService {
    _currentUser = UserModel(
      uid: 'user_001',
      name: 'Rani',
      streakCount: 0,
      plantLevel: 1,
      totalXp: 0,
      currentLevel: 1,
    );
    _initData();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<TaskModel> get filteredTasks {
    if (_selectedFilter == 'high') {
      return _tasks.where((t) => t.energyLevel == EnergyLevel.high).toList();
    } else if (_selectedFilter == 'chill') {
      return _tasks.where((t) => t.energyLevel == EnergyLevel.chill).toList();
    }
    return _tasks;
  }

  List<TaskModel> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((t) {
      return t.date.year == now.year &&
          t.date.month == now.month &&
          t.date.day == now.day;
    }).toList();
  }

  int get totalTasksCount => _tasks.length;
  int get highFocusTasksCount =>
      _tasks.where((t) => t.energyLevel == EnergyLevel.high).length;
  int get chillTasksCount =>
      _tasks.where((t) => t.energyLevel == EnergyLevel.chill).length;

  int get completedTodayCount {
    return todayTasks.where((t) => t.isCompleted).length;
  }

  double get todayCompletionRate {
    if (todayTasks.isEmpty) return 0.0;
    return completedTodayCount / todayTasks.length;
  }

  /// Inisialisasi data dari SQLite
  Future<void> _initData() async {
    if (_database == null) {
      _initFallbackData();
      return;
    }

    try {
      // Baca tugas dari SQLite
      final dbTasks = await (_database.select(_database.tasks)
            ..where((t) => t.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (dbTasks.isEmpty) {
        // First run: seed data awal bahasa Indonesia sesuai referensi Google Stitch & UI
        await _seedInitialTasks();
      } else {
        await _loadTasksFromDb(dbTasks);
      }

      // Muat profil gamifikasi
      if (_gamificationService != null) {
        final progress = await _gamificationService.getUserProgress();
        _currentUser.streakCount = progress.currentStreak;
        _currentUser.totalXp = progress.totalXp;
        _currentUser.currentLevel = progress.currentLevel;
        _currentUser.plantLevel = progress.currentLevel;

        final todayStr = TaskRepository.formatDate(DateTime.now());
        _todayRecord = await _gamificationService.updateDailyRecord(todayStr);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from database: $e');
      _initFallbackData();
    }
  }

  Future<void> _loadTasksFromDb(List<Task> dbTasks) async {
    final db = _database;
    if (db == null) return;
    _tasks.clear();

    for (final dbTask in dbTasks) {
      // Ambil subtasks dari SQLite
      final dbSubtasks = await (db.select(db.subtasks)
            ..where((s) => s.taskId.equals(dbTask.id))
            ..where((s) => s.isDeleted.equals(false))
            ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
          .get();

      final date = DateTime.tryParse(dbTask.scheduledDate) ?? DateTime.now();
      TimeOfDay? time;
      if (dbTask.scheduledTime != null) {
        final parts = dbTask.scheduledTime!.split(':');
        if (parts.length >= 2) {
          time = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
        }
      }

      EnergyLevel energy = EnergyLevel.medium;
      if (dbTask.priority == 'high') energy = EnergyLevel.high;
      if (dbTask.priority == 'low') energy = EnergyLevel.chill;

      _tasks.add(TaskModel(
        taskId: dbTask.id,
        userId: 'user_001',
        title: dbTask.title,
        energyLevel: energy,
        date: date,
        isCompleted: dbTask.status == 'completed',
        notes: dbTask.description ?? '',
        startTime: time,
        durationMinutes: 45,
        subtasks: dbSubtasks
            .map((s) => SubTaskModel(
                  subtaskId: s.id,
                  taskId: s.taskId,
                  title: s.title,
                  isCompleted: s.isCompleted,
                ))
            .toList(),
      ));
    }
  }

  /// Seed initial tasks in Indonesian (sesuai ui_1_referensi Stitch)
  Future<void> _seedInitialTasks() async {
    final today = DateTime.now();
    final todayStr = TaskRepository.formatDate(today);

    final initialTasks = [
      {
        'id': 't1',
        'title': 'Menulis bab 2 skripsi',
        'desc': 'Tinjauan pustaka dan perbandingan algoritma machine learning',
        'priority': 'high',
        'time': '09:00',
        'completed': false,
        'subtasks': [
          'Cari 5 jurnal terindeks Scopus',
          'Tulis kerangka teori bab 2',
          'Review sitasi Mendeley',
          'Kirim draft awal ke co-promotor',
        ],
        'subtasksDone': [true, true, false, false],
      },
      {
        'id': 't2',
        'title': 'Balas email dosen pembimbing',
        'desc': 'Konfirmasi jadwal bimbingan revisi proposal skripsi',
        'priority': 'low',
        'time': '10:00',
        'completed': false,
        'subtasks': [
          'Lampirkan revisi bab 1',
          'Ajukan slot waktu Jumat pagi',
        ],
        'subtasksDone': [true, false],
      },
      {
        'id': 't3',
        'title': 'Rangkum jurnal riset AI',
        'desc': 'Analisis metode evaluasi dan benchmarking performa',
        'priority': 'high',
        'time': '13:30',
        'completed': false,
        'subtasks': [
          'Baca bab methodology',
          'Ekstrak grafik akurasi',
          'Buat summary 1 halaman',
        ],
        'subtasksDone': [false, false, false],
      },
      {
        'id': 't4',
        'title': 'Olahraga pagi 20 menit',
        'desc': 'Jogging ringan dan peregangan',
        'priority': 'low',
        'time': '06:30',
        'completed': true,
        'subtasks': <String>[],
        'subtasksDone': <bool>[],
      },
    ];

    final db = _database;
    if (db == null) {
      _initFallbackData();
      return;
    }

    for (final item in initialTasks) {
      final taskId = item['id'] as String;
      final completed = item['completed'] as bool;

      await db.into(db.tasks).insert(
        TasksCompanion.insert(
          id: Value(taskId),
          title: item['title'] as String,
          description: Value(item['desc'] as String),
          listId: 'default-list',
          scheduledDate: todayStr,
          scheduledTime: Value(item['time'] as String),
          priority: Value(item['priority'] as String),
          status: Value(completed ? 'completed' : 'pending'),
          completedAt: completed ? Value(DateTime.now()) : const Value(null),
        ),
      );

      final subtitles = item['subtasks'] as List<String>;
      final subDone = item['subtasksDone'] as List<bool>;
      for (int i = 0; i < subtitles.length; i++) {
        await db.into(db.subtasks).insert(
          SubtasksCompanion.insert(
            id: Value('st_${taskId}_$i'),
            taskId: taskId,
            title: subtitles[i],
            isCompleted: Value(subDone[i]),
            sortOrder: Value(i),
          ),
        );
      }
    }

    final dbTasks = await (db.select(db.tasks)
          ..where((t) => t.isDeleted.equals(false)))
        .get();
    await _loadTasksFromDb(dbTasks);
  }

  void _initFallbackData() {
    final today = DateTime.now();
    _tasks.addAll([
      TaskModel(
        taskId: 't1',
        userId: 'user_001',
        title: 'Menulis bab 2 skripsi',
        energyLevel: EnergyLevel.high,
        date: today,
        isCompleted: false,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        subtasks: [
          SubTaskModel(subtaskId: 's1', taskId: 't1', title: 'Cari 5 jurnal terindeks Scopus', isCompleted: true),
          SubTaskModel(subtaskId: 's2', taskId: 't1', title: 'Tulis kerangka teori bab 2', isCompleted: true),
          SubTaskModel(subtaskId: 's3', taskId: 't1', title: 'Review sitasi Mendeley', isCompleted: false),
          SubTaskModel(subtaskId: 's4', taskId: 't1', title: 'Kirim draft ke co-promotor', isCompleted: false),
        ],
      ),
      TaskModel(
        taskId: 't2',
        userId: 'user_001',
        title: 'Balas email dosen pembimbing',
        energyLevel: EnergyLevel.chill,
        date: today,
        isCompleted: false,
        startTime: const TimeOfDay(hour: 10, minute: 0),
      ),
      TaskModel(
        taskId: 't3',
        userId: 'user_001',
        title: 'Rangkum jurnal riset AI',
        energyLevel: EnergyLevel.high,
        date: today,
        isCompleted: false,
        startTime: const TimeOfDay(hour: 13, minute: 30),
      ),
      TaskModel(
        taskId: 't4',
        userId: 'user_001',
        title: 'Olahraga pagi 20 menit',
        energyLevel: EnergyLevel.chill,
        date: today,
        isCompleted: true,
        startTime: const TimeOfDay(hour: 6, minute: 30),
      ),
    ]);
  }

  /// Tambah tugas baru ke SQLite
  Future<void> addTask(TaskModel task) async {
    _tasks.insert(0, task);
    notifyListeners();

    if (_database != null) {
      try {
        final dateStr = TaskRepository.formatDate(task.date);
        String? timeStr;
        if (task.startTime != null) {
          timeStr = '${task.startTime!.hour.toString().padLeft(2, '0')}:${task.startTime!.minute.toString().padLeft(2, '0')}';
        }

        String priority = 'medium';
        if (task.energyLevel == EnergyLevel.high) priority = 'high';
        if (task.energyLevel == EnergyLevel.chill) priority = 'low';

        await _database.into(_database.tasks).insert(
          TasksCompanion.insert(
            id: Value(task.taskId),
            title: task.title,
            description: Value(task.notes),
            listId: 'default-list',
            scheduledDate: dateStr,
            scheduledTime: Value(timeStr),
            priority: Value(priority),
            status: Value(task.isCompleted ? 'completed' : 'pending'),
          ),
        );

        for (int i = 0; i < task.subtasks.length; i++) {
          final s = task.subtasks[i];
          await _database.into(_database.subtasks).insert(
            SubtasksCompanion.insert(
              id: Value(s.subtaskId),
              taskId: task.taskId,
              title: s.title,
              isCompleted: Value(s.isCompleted),
              sortOrder: Value(i),
            ),
          );
        }

        if (_gamificationService != null) {
          _todayRecord = await _gamificationService.updateDailyRecord(dateStr);
          final progress = await _gamificationService.getUserProgress();
          _currentUser.streakCount = progress.currentStreak;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error inserting task: $e');
      }
    }
  }

  /// Hapus tugas (soft-delete)
  Future<void> deleteTask(String taskId) async {
    final idx = _tasks.indexWhere((t) => t.taskId == taskId);
    if (idx != -1) {
      final task = _tasks.removeAt(idx);
      notifyListeners();

      if (_database != null) {
        try {
          await (_database.update(_database.tasks)..where((t) => t.id.equals(taskId))).write(
            TasksCompanion(
              isDeleted: const Value(true),
              updatedAt: Value(DateTime.now()),
            ),
          );

          if (_gamificationService != null) {
            final dateStr = TaskRepository.formatDate(task.date);
            _todayRecord = await _gamificationService.updateDailyRecord(dateStr);
            notifyListeners();
          }
        } catch (e) {
          debugPrint('Error deleting task: $e');
        }
      }
    }
  }

  /// Toggle status selesai tugas
  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.taskId == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    final newCompleted = !task.isCompleted;
    task.isCompleted = newCompleted;

    if (newCompleted) {
      for (var s in task.subtasks) {
        s.isCompleted = true;
      }
    }
    notifyListeners();

    if (_database != null) {
      try {
        final newStatus = newCompleted ? 'completed' : 'pending';
        final completedAt = newCompleted ? Value(DateTime.now()) : const Value<DateTime?>(null);

        await (_database.update(_database.tasks)..where((t) => t.id.equals(taskId))).write(
          TasksCompanion(
            status: Value(newStatus),
            completedAt: completedAt,
            updatedAt: Value(DateTime.now()),
          ),
        );

        if (newCompleted) {
          // Berikan XP (10 XP idempoten)
          await _gamificationService?.onTaskCompleted(taskId);
        }

        // Update catatan streak 70%
        final dateStr = TaskRepository.formatDate(task.date);
        _todayRecord = await _gamificationService?.updateDailyRecord(dateStr);

        // Refresh profil pengguna
        if (_gamificationService != null) {
          final progress = await _gamificationService.getUserProgress();
          _currentUser.streakCount = progress.currentStreak;
          _currentUser.totalXp = progress.totalXp;
          _currentUser.currentLevel = progress.currentLevel;
          _currentUser.plantLevel = progress.currentLevel;
        }

        notifyListeners();
      } catch (e) {
        debugPrint('Error toggling task: $e');
      }
    }
  }

  /// Toggle checklist subtugas
  Future<bool> toggleSubtask(String taskId, String subtaskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.taskId == taskId);
    if (taskIndex == -1) return false;

    final task = _tasks[taskIndex];
    final subtaskIndex = task.subtasks.indexWhere((s) => s.subtaskId == subtaskId);
    if (subtaskIndex == -1) return false;

    final s = task.subtasks[subtaskIndex];
    s.isCompleted = !s.isCompleted;

    final allDone = task.subtasks.isNotEmpty && task.subtasks.every((s) => s.isCompleted);
    final wasAlreadyCompleted = task.isCompleted;

    bool triggered = false;
    if (allDone && !wasAlreadyCompleted) {
      task.isCompleted = true;
      triggered = true;
      await toggleTaskCompletion(taskId);
    } else if (!allDone && wasAlreadyCompleted) {
      task.isCompleted = false;
      await toggleTaskCompletion(taskId);
    }

    notifyListeners();

    if (_database != null) {
      try {
        await (_database.update(_database.subtasks)..where((sub) => sub.id.equals(subtaskId))).write(
          SubtasksCompanion(
            isCompleted: Value(s.isCompleted),
            updatedAt: Value(DateTime.now()),
          ),
        );
      } catch (e) {
        debugPrint('Error updating subtask: $e');
      }
    }

    return triggered;
  }

  /// Tambah subtugas
  Future<void> addSubtaskToTask(String taskId, String title) async {
    final taskIndex = _tasks.indexWhere((t) => t.taskId == taskId);
    if (taskIndex == -1) return;

    final subId = 'st_${DateTime.now().millisecondsSinceEpoch}';
    final newSub = SubTaskModel(
      subtaskId: subId,
      taskId: taskId,
      title: title,
      isCompleted: false,
    );

    _tasks[taskIndex].subtasks.add(newSub);
    _tasks[taskIndex].isCompleted = false;
    notifyListeners();

    if (_database != null) {
      try {
        await _database.into(_database.subtasks).insert(
          SubtasksCompanion.insert(
            id: Value(subId),
            taskId: taskId,
            title: title,
            isCompleted: const Value(false),
            sortOrder: Value(_tasks[taskIndex].subtasks.length - 1),
          ),
        );
      } catch (e) {
        debugPrint('Error adding subtask: $e');
      }
    }
  }

  /// Update catatan tugas
  Future<void> updateTaskNotes(String taskId, String notes) async {
    final taskIndex = _tasks.indexWhere((t) => t.taskId == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].notes = notes;
      notifyListeners();

      if (_database != null) {
        try {
          await (_database.update(_database.tasks)..where((t) => t.id.equals(taskId))).write(
            TasksCompanion(
              description: Value(notes),
              updatedAt: Value(DateTime.now()),
            ),
          );
        } catch (e) {
          debugPrint('Error updating task notes: $e');
        }
      }
    }
  }
}
