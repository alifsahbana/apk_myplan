import 'package:flutter/material.dart';

/// Enum for task energy levels
enum EnergyLevel { high, medium, chill }

/// User model – profile and gamification
class UserModel {
  final String uid;
  String name;
  int streakCount;
  int plantLevel;
  int totalXp;
  int currentLevel;

  UserModel({
    required this.uid,
    required this.name,
    this.streakCount = 0,
    this.plantLevel = 1,
    this.totalXp = 0,
    this.currentLevel = 1,
  });
}

/// SubTask model
class SubTaskModel {
  final String subtaskId;
  final String taskId;
  String title;
  bool isCompleted;

  SubTaskModel({
    required this.subtaskId,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
  });
}

/// Category model
class CategoryModel {
  final String id;
  String name;
  String colorHex;
  String? iconName;
  int sortOrder;

  CategoryModel({
    required this.id,
    required this.name,
    this.colorHex = '#42BCEB',
    this.iconName,
    this.sortOrder = 0,
  });

  Color get colorValue {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16));
    } catch (_) {
      return const Color(0xFF42BCEB);
    }
  }
}

/// Task model
class TaskModel {
  final String taskId;
  final String userId;
  String title;
  EnergyLevel energyLevel;
  DateTime date;
  bool isCompleted;
  String notes;
  TimeOfDay? startTime;
  int? durationMinutes;
  List<SubTaskModel> subtasks;
  String listId;
  String categoryName;
  String categoryColor;
  DateTime? completedAt;

  TaskModel({
    required this.taskId,
    required this.userId,
    required this.title,
    required this.energyLevel,
    required this.date,
    this.isCompleted = false,
    this.notes = '',
    this.startTime,
    this.durationMinutes,
    List<SubTaskModel>? subtasks,
    this.listId = 'default-list',
    this.categoryName = 'Umum',
    this.categoryColor = '#42BCEB',
    this.completedAt,
  }) : subtasks = subtasks ?? [];

  double get completionPercent {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final done = subtasks.where((s) => s.isCompleted).length;
    return done / subtasks.length;
  }

  int get completedSubtaskCount =>
      subtasks.where((s) => s.isCompleted).length;

  Color get categoryColorValue {
    try {
      final hex = categoryColor.replaceAll('#', '');
      return Color(int.parse(hex.length == 6 ? 'FF$hex' : hex, radix: 16));
    } catch (_) {
      return const Color(0xFF42BCEB);
    }
  }

  /// Rekonstruksi jadwal tanggal dan jam tugas
  DateTime get scheduledDateTime {
    if (startTime != null) {
      return DateTime(date.year, date.month, date.day, startTime!.hour, startTime!.minute);
    }
    // Untuk tugas tanpa waktu spesifik, batas jadwal adalah akhir hari 23:59:59
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Batas waktu mulai peringatan (30 menit sebelum deadline)
  DateTime get warningStartDateTime {
    return scheduledDateTime.subtract(const Duration(minutes: 30));
  }

  /// Apakah saat ini berada dalam rentang peringatan 30 menit sebelum deadline
  bool get isApproachingDeadline {
    if (isCompleted) return false;
    final now = DateTime.now();
    return now.isAfter(warningStartDateTime) && !now.isAfter(scheduledDateTime);
  }

  /// Sisa waktu menuju deadline dalam menit (1 s.d. 30 menit)
  int get minutesUntilDeadline {
    if (!isApproachingDeadline) return 0;
    final diff = scheduledDateTime.difference(DateTime.now()).inMinutes;
    return diff < 1 ? 1 : diff.clamp(1, 30);
  }

  /// Apakah tugas berstatus terlambat (sudah melewati deadline dan belum selesai, atau diselesaikan terlambat)
  bool get isLate {
    if (isCompleted) return isCompletedLate;
    return DateTime.now().isAfter(scheduledDateTime);
  }

  /// Menit keterlambatan yang sudah berjalan sejak deadline
  int get elapsedLateMinutes {
    final now = DateTime.now();
    if (!now.isAfter(scheduledDateTime)) return 0;
    final diff = now.difference(scheduledDateTime).inMinutes;
    return diff < 1 ? 1 : diff;
  }

  /// Format durasi keterlambatan (hari, jam, menit) untuk badge/chip
  /// Contoh: "2 hari 12 jam", "2 hari", "3 jam 15m", "45m"
  String formattedLateDuration([String lang = 'id']) {
    final total = elapsedLateMinutes;
    if (total <= 0) return '0m';

    final days = total ~/ (24 * 60);
    final remMinutes = total % (24 * 60);
    final hours = remMinutes ~/ 60;
    final minutes = remMinutes % 60;
    final isEn = lang == 'en';

    if (days > 0) {
      if (hours > 0) {
        return isEn ? '$days d $hours h' : '$days hari $hours jam';
      }
      return isEn ? '$days d' : '$days hari';
    }

    if (hours > 0) {
      if (minutes > 0) {
        return isEn ? '$hours h $minutes m' : '$hours jam $minutes m';
      }
      return isEn ? '$hours h' : '$hours jam';
    }

    return '$minutes m';
  }

  /// Format durasi keterlambatan versi teks lengkap (hari, jam, menit)
  /// Contoh: "2 hari 12 jam", "1 jam 15 menit", "45 menit"
  String formattedLateDurationFull([String lang = 'id']) {
    final total = elapsedLateMinutes;
    final isEn = lang == 'en';
    if (total <= 0) return isEn ? '0 minutes' : '0 menit';

    final days = total ~/ (24 * 60);
    final remMinutes = total % (24 * 60);
    final hours = remMinutes ~/ 60;
    final minutes = remMinutes % 60;

    if (days > 0) {
      if (hours > 0) {
        return isEn
            ? '$days day${days > 1 ? 's' : ''} $hours hr${hours > 1 ? 's' : ''}'
            : '$days hari $hours jam';
      }
      return isEn ? '$days day${days > 1 ? 's' : ''}' : '$days hari';
    }

    if (hours > 0) {
      if (minutes > 0) {
        return isEn
            ? '$hours hr${hours > 1 ? 's' : ''} $minutes min${minutes > 1 ? 's' : ''}'
            : '$hours jam $minutes menit';
      }
      return isEn
          ? '$hours hr${hours > 1 ? 's' : ''}'
          : '$hours jam';
    }

    return isEn
        ? '$minutes min${minutes > 1 ? 's' : ''}'
        : '$minutes menit';
  }

  /// Teks format warning peringatan mendekati deadline atau keterlambatan
  String get deadlineWarningText {
    if (isApproachingDeadline) {
      return 'Deadline kurang $minutesUntilDeadline menit — segera kerjakan kegiatanmu!';
    } else if (!isCompleted && isLate) {
      return 'Terlambat ${formattedLateDuration('id')} (Melewati deadline)';
    }
    return '';
  }

  /// Alias getter untuk kompatibilitas
  String get lateWarningText => deadlineWarningText;

  /// Tercatat selesai terlambat (diselesaikan setelah waktu jadwal / deadline)
  bool get isCompletedLate {
    if (!isCompleted || completedAt == null) return false;
    return completedAt!.isAfter(scheduledDateTime);
  }

  /// Tercatat selesai tepat waktu
  bool get isCompletedOnTime {
    if (!isCompleted) return false;
    if (completedAt == null) return true;
    return !completedAt!.isAfter(scheduledDateTime);
  }
}
