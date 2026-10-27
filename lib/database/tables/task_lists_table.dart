import 'package:drift/drift.dart';
import '../../core/uuid_generator.dart';

/// TaskLists table - Kategori/daftar tugas (Pribadi, Kuliah, Belanja, dll)
/// 
/// Sesuai PRD FR-03: Pengguna dapat membuat beberapa daftar
class TaskLists extends Table {
  /// UUID primary key
  TextColumn get id => text().clientDefault(UuidGenerator.generateTaskListId)();
  
  /// Nama daftar (e.g., "Kuliah", "Pribadi")
  TextColumn get name => text().withLength(min: 1, max: 100)();
  
  /// Warna hex untuk UI (e.g., "#42BCEB")
  TextColumn get colorHex => text().withDefault(const Constant('#42BCEB'))();
  
  /// Nama ikon (Material Icons)
  TextColumn get iconName => text().nullable()();
  
  /// Urutan tampilan
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  
  /// Soft delete flag
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  /// Timestamps
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

