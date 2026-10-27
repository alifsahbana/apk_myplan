import 'package:uuid/uuid.dart';

/// UUID Generator untuk database entities
class UuidGenerator {
  static const _uuid = Uuid();
  
  static String generate() {
    return _uuid.v4();
  }
  
  // Specific generators dengan prefix untuk readability
  static String generateTaskListId() => 'list-${generate()}';
  static String generateTaskId() => 'task-${generate()}';
  static String generateSubtaskId() => 'subtask-${generate()}';
  static String generateOccurrenceId() => 'occ-${generate()}';
  static String generateXpTransactionId() => 'xp-${generate()}';
  static String generateUserAchievementId() => 'uach-${generate()}';
  static String generateUserRewardId() => 'urwd-${generate()}';
}
