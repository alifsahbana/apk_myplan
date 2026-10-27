import 'package:flutter/foundation.dart';
import 'package:apk_myplant/database/app_database.dart';
import 'package:apk_myplant/features/gamification/domain/gamification_service.dart';
import '../data/task_repository.dart';
import '../data/task_list_repository.dart';

/// Task Provider untuk state management
/// 
/// Mengintegrasikan TaskRepository, TaskListRepository, dan GamificationService
class TasksProvider with ChangeNotifier {
  final TaskRepository _taskRepo;
  final TaskListRepository _listRepo;
  final GamificationService _gamificationService;

  List<Task> _tasks = [];
  List<TaskList> _taskLists = [];
  UserProgressData? _userProgress;
  DailyRecord? _todayRecord;
  final List<Achievement> _achievements = [];
  final List<UserAchievement> _userAchievements = [];
  bool _isLoading = false;
  String? _error;

  TasksProvider({
    required TaskRepository taskRepository,
    required TaskListRepository listRepository,
    // ignore: prefer_initializing_formals
    required GamificationService gamificationService,
  })  : _taskRepo = taskRepository,
        _listRepo = listRepository,
        // ignore: prefer_initializing_formals
        _gamificationService = gamificationService {
    _init();
  }

  // Getters
  List<Task> get tasks => _tasks;
  List<TaskList> get taskLists => _taskLists;
  UserProgressData? get userProgress => _userProgress;
  DailyRecord? get todayRecord => _todayRecord;
  List<Achievement> get achievements => _achievements;
  List<UserAchievement> get userAchievements => _userAchievements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get currentStreak => _userProgress?.currentStreak ?? 0;
  int get currentLevel => _userProgress?.currentLevel ?? 1;
  int get totalXp => _userProgress?.totalXp ?? 0;
  double get levelProgress => GamificationService.calculateLevelProgress(totalXp);

  List<Task> get todayTasks {
    final today = TaskRepository.formatDate(DateTime.now());
    return _tasks
        .where((t) => t.scheduledDate == today && t.status != 'completed')
        .toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((t) => t.status == 'completed').toList();
  }

  List<Task> get todayCompletedTasks {
    final today = TaskRepository.formatDate(DateTime.now());
    return _tasks
        .where((t) => t.scheduledDate == today && t.status == 'completed')
        .toList();
  }

  /// Initialize
  Future<void> _init() async {
    await _listRepo.ensureDefaultList();
    await loadAll();
  }

  /// Load all data
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskRepo.getAllTasks();
      _taskLists = await _listRepo.getAllLists();
      _userProgress = await _gamificationService.getUserProgress();
      
      final todayStr = TaskRepository.formatDate(DateTime.now());
      _todayRecord = await _gamificationService.updateDailyRecord(todayStr);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create task
  Future<Task?> createTask({
    required String title,
    String? description,
    required String listId,
    required DateTime scheduledDate,
    String? scheduledTime,
    String priority = 'medium',
    bool isStarred = false,
  }) async {
    try {
      final task = await _taskRepo.createTask(
        title: title,
        description: description,
        listId: listId,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        priority: priority,
        isStarred: isStarred,
      );
      
      final todayStr = TaskRepository.formatDate(DateTime.now());
      if (TaskRepository.formatDate(scheduledDate) == todayStr) {
        await _gamificationService.updateDailyRecord(todayStr);
      }
      
      await loadAll();
      return task;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Toggle task completion and award XP
  Future<void> toggleTask(String taskId) async {
    try {
      final task = await _taskRepo.getTaskById(taskId);
      if (task == null) return;

      final isCompleting = task.status != 'completed';
      await _taskRepo.toggleTaskCompletion(taskId);

      if (isCompleting) {
        // Berikan XP (idempoten) dan perbarui streak/achievement
        await _gamificationService.onTaskCompleted(taskId, occurrenceDate: task.scheduledDate);
      } else {
        // Pembatalan checklist: perbarui statistik harian
        await _gamificationService.updateDailyRecord(task.scheduledDate);
      }

      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      final task = await _taskRepo.getTaskById(taskId);
      await _taskRepo.deleteTask(taskId);
      if (task != null) {
        await _gamificationService.updateDailyRecord(task.scheduledDate);
      }
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Create task list
  Future<void> createTaskList({
    required String name,
    String colorHex = '#42BCEB',
    String? iconName,
  }) async {
    try {
      await _listRepo.createList(
        name: name,
        colorHex: colorHex,
        iconName: iconName,
        sortOrder: _taskLists.length,
      );
      await loadAll();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
