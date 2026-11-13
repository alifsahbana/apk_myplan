import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apk_myplant/models/models.dart';
import 'package:apk_myplant/core/services/report_export_service.dart';

void main() {
  group('CategoryModel Tests', () {
    test('colorValue parses hex string correctly', () {
      final cat1 = CategoryModel(id: '1', name: 'Kuliah', colorHex: '#42BCEB');
      expect(cat1.colorValue, const Color(0xFF42BCEB));

      final cat2 = CategoryModel(id: '2', name: 'Kerja', colorHex: '#E53E3E');
      expect(cat2.colorValue, const Color(0xFFE53E3E));

      final catFallback = CategoryModel(id: '3', name: 'Invalid', colorHex: 'not-a-color');
      expect(catFallback.colorValue, const Color(0xFF42BCEB));
    });
  });

  group('TaskModel Pre-deadline Warning & Late Tests', () {
    test('Task with startTime: scheduledDateTime and warningStartDateTime reconstructs correctly', () {
      final date = DateTime(2026, 10, 30);
      final task = TaskModel(
        taskId: 't1',
        userId: 'u1',
        title: 'Meeting',
        energyLevel: EnergyLevel.high,
        date: date,
        startTime: const TimeOfDay(hour: 14, minute: 0),
      );

      expect(task.scheduledDateTime, DateTime(2026, 10, 30, 14, 0));
      expect(task.warningStartDateTime, DateTime(2026, 10, 30, 13, 30));
    });

    test('Task without startTime: deadline is 23:59:59 and warning starts at 23:29:59', () {
      final date = DateTime(2026, 10, 30);
      final task = TaskModel(
        taskId: 't2',
        userId: 'u1',
        title: 'Tugas Harian',
        energyLevel: EnergyLevel.medium,
        date: date,
        startTime: null,
      );

      expect(task.scheduledDateTime, DateTime(2026, 10, 30, 23, 59, 59));
      expect(task.warningStartDateTime, DateTime(2026, 10, 30, 23, 29, 59));
    });

    test('On-time vs Late completion flags', () {
      final date = DateTime(2026, 10, 30);
      final scheduledTime = const TimeOfDay(hour: 10, minute: 0);

      // Selesai tepat waktu (sebelum deadline)
      final taskOnTime = TaskModel(
        taskId: 't3',
        userId: 'u1',
        title: 'Tugas Tepat Waktu',
        energyLevel: EnergyLevel.chill,
        date: date,
        startTime: scheduledTime,
        isCompleted: true,
        completedAt: DateTime(2026, 10, 30, 9, 55),
      );
      expect(taskOnTime.isCompletedOnTime, isTrue);
      expect(taskOnTime.isCompletedLate, isFalse);

      // Selesai terlambat (setelah deadline 10:00)
      final taskLate10Min = TaskModel(
        taskId: 't4',
        userId: 'u1',
        title: 'Tugas Terlambat 10 Mnt',
        energyLevel: EnergyLevel.chill,
        date: date,
        startTime: scheduledTime,
        isCompleted: true,
        completedAt: DateTime(2026, 10, 30, 10, 10),
      );
      expect(taskLate10Min.isCompletedOnTime, isFalse);
      expect(taskLate10Min.isCompletedLate, isTrue);

      // Selesai terlambat 45 menit
      final taskLate45Min = TaskModel(
        taskId: 't5',
        userId: 'u1',
        title: 'Tugas Terlambat 45 Mnt',
        energyLevel: EnergyLevel.chill,
        date: date,
        startTime: scheduledTime,
        isCompleted: true,
        completedAt: DateTime(2026, 10, 30, 10, 45),
      );
      expect(taskLate45Min.isCompletedOnTime, isFalse);
      expect(taskLate45Min.isCompletedLate, isTrue);
    });
  });

  group('ReportExportService Tests', () {
    test('generateReportText contains user information and task breakdown', () {
      final user = UserModel(
        uid: 'user-1',
        name: 'Ahmad User',
        currentLevel: 3,
        plantLevel: 2,
        totalXp: 350,
        streakCount: 5,
      );

      final categories = [
        CategoryModel(id: 'default-list', name: 'Umum'),
        CategoryModel(id: 'cat-2', name: 'Tugas Kuliah'),
      ];

      final tasks = [
        TaskModel(
          taskId: 't1',
          userId: 'user-1',
          title: 'Belajar Drift SQLite',
          energyLevel: EnergyLevel.high,
          date: DateTime(2026, 10, 30),
          isCompleted: true,
          listId: 'cat-2',
          categoryName: 'Tugas Kuliah',
          completedAt: DateTime(2026, 10, 30, 8, 0),
        ),
      ];

      final report = ReportExportService.generateReportText(
        user: user,
        tasks: tasks,
        categories: categories,
      );

      expect(report.contains('LAPORAN PRODUKTIVITAS MYPLAN'), isTrue);
      expect(report.contains('Ahmad User'), isTrue);
      expect(report.contains('Level 3'), isTrue);
      expect(report.contains('350 XP'), isTrue);
      expect(report.contains('Tugas Kuliah'), isTrue);
      expect(report.contains('Belajar Drift SQLite'), isTrue);
    });
  });
}
