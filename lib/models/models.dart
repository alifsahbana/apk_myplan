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
  }) : subtasks = subtasks ?? [];

  double get completionPercent {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final done = subtasks.where((s) => s.isCompleted).length;
    return done / subtasks.length;
  }

  int get completedSubtaskCount =>
      subtasks.where((s) => s.isCompleted).length;
}
