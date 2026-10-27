import 'package:drift/drift.dart';
import 'package:apk_myplant/core/uuid_generator.dart';
import 'package:apk_myplant/database/app_database.dart';

/// Repository untuk task operations
/// 
/// Handles CRUD operations untuk tasks dengan database Drift
class TaskRepository {
  final AppDatabase _db;

  TaskRepository(this._db);

  /// Get all tasks
  Future<List<Task>> getAllTasks() async {
    return await (_db.select(_db.tasks)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get tasks by date
  Future<List<Task>> getTasksByDate(DateTime date) async {
    final dateStr = formatDate(date);
    return await (_db.select(_db.tasks)
          ..where((t) => t.scheduledDate.equals(dateStr))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledTime)]))
        .get();
  }

  /// Get today's tasks
  Future<List<Task>> getTodayTasks() async {
    return getTasksByDate(DateTime.now());
  }

  /// Get task by ID
  Future<Task?> getTaskById(String id) async {
    return await (_db.select(_db.tasks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create new task
  Future<Task> createTask({
    required String title,
    String? description,
    required String listId,
    required DateTime scheduledDate,
    String? scheduledTime,
    String priority = 'medium',
    bool isStarred = false,
  }) async {
    final taskId = UuidGenerator.generateTaskId();
    final companion = TasksCompanion.insert(
      id: Value(taskId),
      title: title,
      description: Value(description),
      listId: listId,
      scheduledDate: formatDate(scheduledDate),
      scheduledTime: Value(scheduledTime),
      priority: Value(priority),
      isStarred: Value(isStarred),
    );

    await _db.into(_db.tasks).insert(companion);
    return (await getTaskById(taskId))!;
  }

  /// Update task
  Future<bool> updateTask(Task task) async {
    return await _db.update(_db.tasks).replace(task);
  }

  /// Toggle task completion
  Future<Task?> toggleTaskCompletion(String taskId) async {
    final task = await getTaskById(taskId);
    if (task == null) return null;

    final isNowCompleted = task.status != 'completed';
    final newStatus = isNowCompleted ? 'completed' : 'pending';
    final completedAt = isNowCompleted ? Value(DateTime.now()) : const Value<DateTime?>(null);

    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        status: Value(newStatus),
        completedAt: completedAt,
        updatedAt: Value(DateTime.now()),
      ),
    );

    return await getTaskById(taskId);
  }

  /// Delete task (soft delete)
  Future<void> deleteTask(String taskId) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(taskId))).write(
      TasksCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Hard delete task
  Future<void> hardDeleteTask(String taskId) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(taskId))).go();
  }

  /// Get tasks by list
  Future<List<Task>> getTasksByList(String listId) async {
    return await (_db.select(_db.tasks)
          ..where((t) => t.listId.equals(listId))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    return await (_db.select(_db.tasks)
          ..where((t) => t.status.equals(status))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get starred tasks
  Future<List<Task>> getStarredTasks() async {
    return await (_db.select(_db.tasks)
          ..where((t) => t.isStarred.equals(true))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Format date to ISO string (YYYY-MM-DD)
  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
