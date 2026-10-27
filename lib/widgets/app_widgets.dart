import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Pill-shaped tag for energy levels (High Focus, Medium, Chill)
class EnergyTagWidget extends StatelessWidget {
  final EnergyLevel level;
  final bool isSmall;

  const EnergyTagWidget({super.key, required this.level, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLocale;

    Color bg;
    Color textColor;
    String label;
    IconData icon;

    switch (level) {
      case EnergyLevel.high:
        bg = AppColors.highFocusBg;
        textColor = AppColors.highFocusText;
        label = AppLocalizations.tr('highFocusShort', lang);
        icon = Icons.bolt;
        break;
      case EnergyLevel.medium:
        bg = AppColors.mediumBg;
        textColor = AppColors.mediumText;
        label = AppLocalizations.tr('mediumShort', lang);
        icon = Icons.battery_charging_full;
        break;
      case EnergyLevel.chill:
        bg = AppColors.chillBg;
        textColor = AppColors.chillText;
        label = AppLocalizations.tr('chillShort', lang);
        icon = Icons.coffee;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmall ? 12 : 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Language Toggle Pill (ID | EN)
class LanguageTogglePill extends StatelessWidget {
  const LanguageTogglePill({super.key});

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final isId = langProv.isIndonesian;

    return GestureDetector(
      onTap: () => langProv.toggleLanguage(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isId ? AppColors.primaryDark : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'ID',
                style: TextStyle(
                  color: isId ? Colors.white : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: !isId ? AppColors.primaryDark : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  color: !isId ? Colors.white : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Streak Widget with flame icon and counter
class StreakWidget extends StatelessWidget {
  final int streakCount;

  const StreakWidget({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.streakBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD8A8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streakCount-day streak',
                style: const TextStyle(
                  color: AppColors.highFocusText,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  height: 1.1,
                ),
              ),
              Text(
                '65% flow target',
                style: TextStyle(
                  color: AppColors.highFocusText.withValues(alpha: 0.8),
                  fontSize: 9,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Task Card Component replicating the screenshot exactly
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleCheck;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleCheck,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLocale;
    final isDone = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFF9FBFA) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? const Color(0xFFE2EBE5) : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Title and Energy Tag
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: onToggleCheck,
                      child: Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 12, top: 2),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppColors.accentGreen
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDone
                                ? AppColors.accentGreen
                                : const Color(0xFFCED4DA),
                            width: 1.8,
                          ),
                        ),
                        child: isDone
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDone
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (task.startTime != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 13,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${task.startTime!.hour.toString().padLeft(2, '0')}:${task.startTime!.minute.toString().padLeft(2, '0')} • ${task.durationMinutes ?? 45} min',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isDone)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD3F9D8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          AppLocalizations.tr('done', lang),
                          style: const TextStyle(
                            color: Color(0xFF2B8A3E),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      )
                    else
                      EnergyTagWidget(level: task.energyLevel, isSmall: true),
                  ],
                ),

                // Subtask mini progress bar (if has subtasks)
                if (task.subtasks.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtasks',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${task.completedSubtaskCount}/${task.subtasks.length} completed',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.completionPercent,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFE9ECEF),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.completionPercent == 1.0
                            ? AppColors.accentGreen
                            : AppColors.primarySage,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
