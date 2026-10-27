/// Model data untuk Task List / Kategori
class TaskListModel {
  final String id;
  final String name;
  final String colorHex;
  final String? iconName;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  TaskListModel({
    required this.id,
    required this.name,
    required this.colorHex,
    this.iconName,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['color_hex'] as String,
      iconName: json['icon_name'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color_hex': colorHex,
      'icon_name': iconName,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }
}
