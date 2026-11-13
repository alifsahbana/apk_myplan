import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/task_completion_experience.dart';
import 'task_detail_screen.dart';

/// Screen 2: Kalender & Timeline
/// 
/// Sesuai PRD FR-05 dan DESIGN.md Section 6.2:
/// - Melihat agenda per tanggal
/// - Navigasi tanggal yang responsif
/// - Timeline tugas terjadwal
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _selectedDayIndex = 0; // Index hari yang dipilih (0 = hari ini)
  static const int _daysCount = 14; // Tampilkan 2 minggu

  late final DateTime _startDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Mulai dari 3 hari lalu hingga 10 hari ke depan
    _startDate = DateTime(now.year, now.month, now.day - 3);
    _selectedDayIndex = 3; // Default pilih hari ini
  }

  List<DateTime> get _days {
    return List.generate(
      _daysCount,
      (i) => DateTime(_startDate.year, _startDate.month, _startDate.day + i),
    );
  }

  DateTime get _selectedDate => _days[_selectedDayIndex];

  String _formatMonth(DateTime dt, String locale) {
    try {
      return DateFormat('MMMM yyyy', locale).format(dt);
    } catch (_) {
      try {
        return DateFormat('MMMM yyyy').format(dt);
      } catch (_) {
        return '${dt.month}/${dt.year}';
      }
    }
  }

  String _formatDayName(DateTime dt, String locale) {
    try {
      return DateFormat('E', locale).format(dt);
    } catch (_) {
      try {
        return DateFormat('E').format(dt);
      } catch (_) {
        const days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
        return days[dt.weekday % 7];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final taskProv = context.watch<TaskProvider>();
    final locale = langProv.currentLocale;

    final selectedDate = _selectedDate;
    final isTodaySelected = selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day;

    // Filter tugas berdasarkan tanggal yang dipilih
    final tasksForSelectedDate = taskProv.tasks.where((t) {
      return t.date.year == selectedDate.year &&
          t.date.month == selectedDate.month &&
          t.date.day == selectedDate.day;
    }).toList();

    final scheduledTasks = tasksForSelectedDate.where((t) => t.startTime != null).toList()
      ..sort((a, b) {
        final aMinutes = a.startTime!.hour * 60 + a.startTime!.minute;
        final bMinutes = b.startTime!.hour * 60 + b.startTime!.minute;
        return aMinutes.compareTo(bMinutes);
      });

    final unscheduledTasks = tasksForSelectedDate.where((t) => t.startTime == null).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MYPLAN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.brandBlueDark,
                        ),
                      ),
                      Text(
                        AppLocalizations.tr('calendarTitle', locale),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlueTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      locale == 'en' ? '${tasksForSelectedDate.length} tasks' : '${tasksForSelectedDate.length} tugas',
                      style: TextStyle(
                        color: AppColors.brandBlueDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Month & Navigation Bar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatMonth(selectedDate, locale),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (!isTodaySelected)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDayIndex = 3; // Kembali ke hari ini
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          AppLocalizations.tr('today', locale),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandBlueDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ─── Horizontal Date Picker Strip ───
            SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final isSelected = index == _selectedDayIndex;
                  final isToday = day.year == DateTime.now().year &&
                      day.month == DateTime.now().month &&
                      day.day == DateTime.now().day;

                  final hasTasks = taskProv.tasks.any((t) =>
                      t.date.year == day.year &&
                      t.date.month == day.month &&
                      t.date.day == day.day);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDayIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.brandBlueDark
                            : isToday
                                ? AppColors.surfaceBlueTint
                                : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandBlueDark
                              : isToday
                                  ? AppColors.brandBlue
                                  : AppColors.borderLight,
                          width: isToday || isSelected ? 1.5 : 0.8,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.brandBlueDark.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDayName(day, locale).toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (hasTasks)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.brandCyan : AppColors.brandBlue,
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ─── Timeline / Agenda Body ───
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  // Date Header
                  Row(
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM yyyy', locale).format(selectedDate),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (tasksForSelectedDate.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoft,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.event_available, color: AppColors.brandBlue, size: 32),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            AppLocalizations.tr('noActivities', locale),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.tr('noAgendaYet', locale),
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    // Scheduled tasks timeline
                    if (scheduledTasks.isNotEmpty) ...[
                      Text(
                        AppLocalizations.tr('onSchedule', locale),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...scheduledTasks.map((t) => _timelineItem(t, taskProv, locale: locale)),
                      const SizedBox(height: 14),
                    ],

                    // Unscheduled tasks
                    if (unscheduledTasks.isNotEmpty) ...[
                      Text(
                        AppLocalizations.tr('allDayLabel', locale),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...unscheduledTasks.map((t) => _timelineItem(t, taskProv, locale: locale)),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(TaskModel task, TaskProvider taskProv, {required String locale}) {
    final timeStr = task.startTime != null
        ? '${task.startTime!.hour.toString().padLeft(2, '0')}:${task.startTime!.minute.toString().padLeft(2, '0')}'
        : AppLocalizations.tr('allDay', locale);

    final isDone = task.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? AppColors.borderLight : AppColors.border,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => TaskCompletionExperience.startFlow(context, task),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.brandBlue : AppColors.surfaceSoft,
                      border: Border.all(
                        color: isDone ? AppColors.brandBlue : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          if (isDone && task.isCompletedLate) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3DC),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFE59900), width: 0.5),
                              ),
                              child: Text(
                                AppLocalizations.tr('completedLateTag', locale),
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFB96B12)),
                              ),
                            ),
                          ] else if (!isDone && task.isApproachingDeadline) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3DC),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFE59900), width: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 11, color: Color(0xFFB96B12)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${AppLocalizations.tr('deadlineApproach', locale)} ${task.minutesUntilDeadline}m ${AppLocalizations.tr('doNow', locale)}',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFFB96B12)),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (!isDone && task.isLate) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFA5252), width: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 11, color: Color(0xFFC53D4B)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${AppLocalizations.tr('lateMinutes', locale)} ${task.formattedLateDuration(locale)}',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFFC53D4B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.schedule, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                timeStr,
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          // Category chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: task.categoryColorValue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task.categoryColorValue,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.categoryName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (task.energyLevel == EnergyLevel.high)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceBlueTint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.tr('highFocusShort', locale),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandBlueDark,
                                ),
                              ),
                            )
                          else if (task.energyLevel == EnergyLevel.medium)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.tr('mediumShort', locale),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            )
                          else if (task.energyLevel == EnergyLevel.chill)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.tr('chillShort', locale),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
