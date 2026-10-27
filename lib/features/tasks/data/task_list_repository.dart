import 'package:drift/drift.dart';
import 'package:apk_myplant/database/app_database.dart';

/// Repository untuk task lists/categories
class TaskListRepository {
  final AppDatabase _db;

  TaskListRepository(this._db);

  /// Get all task lists
  Future<List<TaskList>> getAllLists() async {
    return await (_db.select(_db.taskLists)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get list by ID
  Future<TaskList?> getListById(String id) async {
    return await (_db.select(_db.taskLists)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create new list
  Future<TaskList> createList({
    required String name,
    String colorHex = '#42BCEB',
    String? iconName,
    int sortOrder = 0,
  }) async {
    final companion = TaskListsCompanion.insert(
      name: name,
      colorHex: Value(colorHex),
      iconName: Value(iconName),
      sortOrder: Value(sortOrder),
    );

    await _db.into(_db.taskLists).insert(companion);
    // Find by name
    return await (_db.select(_db.taskLists)..where((t) => t.name.equals(name))).getSingle();
  }

  /// Update list
  Future<bool> updateList(TaskList list) async {
    return await _db.update(_db.taskLists).replace(list);
  }

  /// Delete list (soft delete)
  Future<void> deleteList(String listId) async {
    await (_db.update(_db.taskLists)..where((t) => t.id.equals(listId))).write(
      TaskListsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Initialize default list if none exist
  Future<void> ensureDefaultList() async {
    final lists = await getAllLists();
    if (lists.isEmpty) {
      await createList(
        name: 'Umum',
        colorHex: '#42BCEB',
        iconName: 'checklist_rtl',
        sortOrder: 0,
      );
    }
  }
}
