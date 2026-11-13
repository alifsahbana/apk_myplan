import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../models/models.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../widgets/task_completion_experience.dart';

/// Screen 3: Task Detail Screen
class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel _task;
  late TextEditingController _notesController;
  final TextEditingController _newSubtaskController = TextEditingController();
  bool _isAddingSubtask = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _notesController = TextEditingController(text: _task.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _newSubtaskController.dispose();
    super.dispose();
  }

  void _addNewSubtask() {
    final title = _newSubtaskController.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskProvider>().addSubtaskToTask(_task.taskId, title);
      _newSubtaskController.clear();
      setState(() {
        _isAddingSubtask = false;
      });
    }
  }

  void _updateTaskNotes(String newNotes) {
    context.read<TaskProvider>().updateTaskNotes(_task.taskId, newNotes);
    _task.notes = newNotes;
  }

  /// Handles subtask toggle — jika semua subtask selesai, tampilkan apresiasi
  Future<void> _handleSubtaskToggle(String taskId, String subtaskId) async {
    final provider = context.read<TaskProvider>();

    // Ambil task sebelum toggle
    final taskBefore = provider.tasks.firstWhere((t) => t.taskId == taskId, orElse: () => _task);
    final wasAlreadyCompleted = taskBefore.isCompleted;

    final allDone = await provider.toggleSubtask(taskId, subtaskId);
    if (!mounted) return;

    // Jika semua subtask selesai dan tugas baru saja selesai → tampilkan popup apresiasi
    if (allDone && !wasAlreadyCompleted) {
      final updatedTask = provider.tasks.firstWhere((t) => t.taskId == taskId, orElse: () => _task);
      await TaskCompletionExperience.startFlow(context, updatedTask);
    }
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.tr(
              'deleteTask',
              Provider.of<LanguageProvider>(
                context,
                listen: false,
              ).currentLocale,
            ),
          ),
          content: Text(
            AppLocalizations.tr(
              'deleteConfirm',
              Provider.of<LanguageProvider>(
                context,
                listen: false,
              ).currentLocale,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.tr(
                  'cancel',
                  Provider.of<LanguageProvider>(
                    context,
                    listen: false,
                  ).currentLocale,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TaskProvider>().deleteTask(_task.taskId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highFocusText,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final lang = langProv.currentLocale;
    final provider = context.watch<TaskProvider>();

    // Refresh local task data from provider
    final currentTask = provider.tasks.firstWhere(
      (t) => t.taskId == _task.taskId,
      orElse: () => _task,
    );
    _task = currentTask;

    final percent = currentTask.completionPercent;
    final isDone = currentTask.isCompleted;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textSecondary,
            ),
            onPressed: _deleteTask,
          ),
        ],
        title: Text(
          AppLocalizations.tr('taskDetail', lang),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Card ───
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      EnergyTagWidget(level: currentTask.energyLevel),
                      const SizedBox(width: 8),
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.brandBlue,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              currentTask.categoryName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: currentTask.isCompletedLate
                                ? const Color(0xFFFFF3DC)
                                : const Color(0xFFD3F9D8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: currentTask.isCompletedLate
                                  ? const Color(0xFFE59900)
                                  : const Color(0xFF2B8A3E),
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            currentTask.isCompletedLate ? AppLocalizations.tr('completedLate', lang) : AppLocalizations.tr('onTime', lang),
                            style: TextStyle(
                              color: currentTask.isCompletedLate
                                  ? const Color(0xFFB96B12)
                                  : const Color(0xFF2B8A3E),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        )
                      else if (currentTask.isApproachingDeadline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3DC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE59900), width: 0.6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_rounded, size: 12, color: Color(0xFFB96B12)),
                              const SizedBox(width: 3),
                              Text(
                                '${AppLocalizations.tr('deadlineApproach', lang)} < 30m (${currentTask.minutesUntilDeadline}m)',
                                style: const TextStyle(
                                  color: Color(0xFFB96B12),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (currentTask.isLate)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE3E3),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFA5252), width: 0.6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded, size: 12, color: Color(0xFFC53D4B)),
                              const SizedBox(width: 3),
                              Text(
                                '${AppLocalizations.tr('lateMinutes', lang)} ${currentTask.formattedLateDuration(lang)}',
                                style: const TextStyle(
                                  color: Color(0xFFC53D4B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentTask.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${AppLocalizations.tr('deadlineLabel', lang)} ${currentTask.date.day}/${currentTask.date.month}/${currentTask.date.year}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (currentTask.startTime != null) ...[
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${currentTask.startTime!.hour.toString().padLeft(2, '0')}:${currentTask.startTime!.minute.toString().padLeft(2, '0')} • ${currentTask.durationMinutes ?? 45} min',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!currentTask.isCompleted && currentTask.isApproachingDeadline) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD591)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm, size: 18, color: Color(0xFFD46B08)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lang == 'en'
                                  ? 'Warning! Deadline in ${currentTask.minutesUntilDeadline} minutes. Please finish your activity!'
                                  : 'Warning! Deadline kurang ${currentTask.minutesUntilDeadline} menit. Silakan selesaikan kegiatanmu!',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD46B08),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (!currentTask.isCompleted && currentTask.isLate) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFA39E)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFCF1322)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lang == 'en'
                                  ? 'Task is past deadline (${currentTask.formattedLateDurationFull('en')} ago). You can still complete it now.'
                                  : 'Tugas telah melewati deadline (${currentTask.formattedLateDurationFull('id')} yang lalu). Anda tetap dapat menyelesaikannya sekarang.',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFCF1322),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Progress Section ───
            Text(
              AppLocalizations.tr('completionProgress', lang),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFE9ECEF),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percent == 1.0
                                ? AppColors.accentGreen
                                : AppColors.primarySage,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(percent * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            percent == 1.0
                                ? AppLocalizations.tr('completed', lang)
                                : AppLocalizations.tr('done', lang),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.borderSubtle),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.tr('subtasks', lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${currentTask.completedSubtaskCount}/${currentTask.subtasks.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primarySage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Subtasks List ───
            Text(
              AppLocalizations.tr('subtasks', lang),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...currentTask.subtasks.map((subtask) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => _handleSubtaskToggle(
                        currentTask.taskId,
                        subtask.subtaskId,
                      ),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: subtask.isCompleted
                              ? AppColors.accentGreen
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: subtask.isCompleted
                                ? AppColors.accentGreen
                                : const Color(0xFFCED4DA),
                            width: 1.8,
                          ),
                        ),
                        child: subtask.isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    title: Text(
                      subtask.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subtask.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        decoration: subtask.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            // ─── Add Subtask Field or Button ───
            if (_isAddingSubtask)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.brandBlue, width: 1.2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newSubtaskController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.tr('newSubtaskHint', lang),
                          hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                        onSubmitted: (_) => _addNewSubtask(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: AppColors.brandBlue),
                      onPressed: _addNewSubtask,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () {
                        setState(() {
                          _isAddingSubtask = false;
                          _newSubtaskController.clear();
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: () => setState(() => _isAddingSubtask = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 18, color: AppColors.brandBlueDark),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.tr('addSubtaskBtn', lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandBlueDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ─── Tombol Tandai Selesai / Batalkan ───
            if (!isDone)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => TaskCompletionExperience.startFlow(context, currentTask),
                  icon: const Icon(Icons.task_alt_rounded, size: 20),
                  label: Text(
                    AppLocalizations.tr('markDone', lang),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => TaskCompletionExperience.startFlow(context, currentTask),
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: Text(
                    AppLocalizations.tr('undoCompletion', lang),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ─── Notes Section ───
            Text(
              AppLocalizations.tr('additionalNotes', lang),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 8,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add notes here...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: _updateTaskNotes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
