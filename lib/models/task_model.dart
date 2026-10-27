/// Model untuk Task
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String listId;
  final String scheduledDate; // ISO format YYYY-MM-DD
  final String? scheduledTime;
  final String priority; // 'low', 'medium', 'high'
  final bool isStarred;
  final String status; // 'pending', 'completed', 'cancelled'
  final String? recurrenceRule;
  final String? parentTaskId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final bool isDeleted;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.listId,
    required this.scheduledDate,
    this.scheduledTime,
    this.priority = 'medium',
    this.isStarred = false,
    this.status = 'pending',
    this.recurrenceRule,
    this.parentTaskId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.isDeleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      listId: json['list_id'] as String,
      scheduledDate: json['scheduled_date'] as String,
      scheduledTime: json['scheduled_time'] as String?,
      priority: json['priority'] as String? ?? 'medium',
      isStarred: json['is_starred'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      recurrenceRule: json['recurrence_rule'] as String?,
      parentTaskId: json['parent_task_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String) 
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'list_id': listId,
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'priority': priority,
      'is_starred': isStarred,
      'status': status,
      'recurrence_rule': recurrenceRule,
      'parent_task_id': parentTaskId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    String? listId,
    String? scheduledDate,
    String? scheduledTime,
    String? priority,
    bool? isStarred,
    String? status,
    String? recurrenceRule,
    String? parentTaskId,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      listId: listId ?? this.listId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      priority: priority ?? this.priority,
      isStarred: isStarred ?? this.isStarred,
      status: status ?? this.status,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      completedAt: completedAt,
      isDeleted: isDeleted,
    );
  }
}
