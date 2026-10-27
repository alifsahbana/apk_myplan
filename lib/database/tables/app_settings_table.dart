import 'package:drift/drift.dart';

/// AppSettings table - Pengaturan aplikasi (key-value store)
/// 
/// Untuk menyimpan preferensi seperti tema, bahasa, dll
class AppSettings extends Table {
  /// Setting key
  TextColumn get key => text()();
  
  /// Setting value (JSON string untuk complex values)
  TextColumn get value => text()();
  
  /// Timestamps
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {key};
}
