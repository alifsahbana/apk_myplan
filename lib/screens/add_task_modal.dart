import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../models/models.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Screen 2: Add Task Modal (Bottom Sheet)
class AddTaskModal extends StatefulWidget {
  final String initialUserId;

  const AddTaskModal({super.key, required this.initialUserId});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [];
  final List<bool> _subtaskDone = [];
  EnergyLevel _selectedEnergy = EnergyLevel.high;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _showDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _addSubtaskField() {
    _subtaskControllers.add(TextEditingController());
    _subtaskDone.add(false);
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    for (var c in _subtaskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    final taskId = 't_${DateTime.now().millisecondsSinceEpoch}';
    final task = TaskModel(
      taskId: taskId,
      userId: widget.initialUserId,
      title: title,
      energyLevel: _selectedEnergy,
      date: _selectedDate ?? DateTime.now(),
      startTime: _selectedTime,
      notes: _notesController.text.trim(),
      subtasks: List.generate(
        _subtaskControllers.length,
        (i) => SubTaskModel(
          subtaskId: 'st_${taskId}_$i',
          taskId: taskId,
          title: _subtaskControllers[i].text.trim(),
          isCompleted: false,
        ),
      ).where((s) => s.title.isNotEmpty).toList(),
    );

    context.read<TaskProvider>().addTask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final lang = langProv.currentLocale;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                AppLocalizations.tr('addNewTask', lang),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // Task Title Input
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.tr('taskTitle', lang),
                  hintText: 'e.g., Finalize Q4 Product Vision',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Energy Level Chips
              Text(
                AppLocalizations.tr('energyLevel', lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _energyChip(EnergyLevel.high, '⚡ Fokus Tinggi'),
                  const SizedBox(width: 8),
                  _energyChip(EnergyLevel.medium, '🔋 Sedang'),
                  const SizedBox(width: 8),
                  _energyChip(EnergyLevel.chill, '☕ Santai'),
                ],
              ),
              const SizedBox(height: 16),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showDatePicker,
                      icon: const Icon(Icons.calendar_today,
                          size: 18, color: AppColors.textSecondary),
                      label: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : AppLocalizations.tr('selectDate', lang),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showTimePicker,
                      icon: const Icon(Icons.access_time,
                          size: 18, color: AppColors.textSecondary),
                      label: Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                            : '--:--',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.tr('additionalNotes', lang),
                  hintText: 'Optional...',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Subtasks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.tr('subtasks', lang),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addSubtaskField,
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(
                      AppLocalizations.tr('addSubtask', lang),
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primarySage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_subtaskControllers.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    AppLocalizations.tr('subtaskHint', lang),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ..._subtaskControllers.map((controller) {
                final index = _subtaskControllers.indexOf(controller);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Sub-task ${index + 1}',
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.star,
                          size: 18, color: AppColors.accentGreen),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.tr('saveTask', lang),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Discard button
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.tr('discardDraft', lang),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _energyChip(EnergyLevel level, String label) {
    final isSelected = _selectedEnergy == level;
    Color bgColor;
    Color textColor;
    switch (level) {
      case EnergyLevel.high:
        bgColor = isSelected ? AppColors.highFocusBg : Colors.grey.shade100;
        textColor = isSelected ? AppColors.highFocusText : AppColors.textSecondary;
        break;
      case EnergyLevel.medium:
        bgColor = isSelected ? AppColors.mediumBg : Colors.grey.shade100;
        textColor = isSelected ? AppColors.mediumText : AppColors.textSecondary;
        break;
      case EnergyLevel.chill:
        bgColor = isSelected ? AppColors.chillBg : Colors.grey.shade100;
        textColor = isSelected ? AppColors.chillText : AppColors.textSecondary;
        break;
    }
    return GestureDetector(
      onTap: () => setState(() => _selectedEnergy = level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
