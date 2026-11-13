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
  String? _selectedCategoryId;

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

  void _removeSubtaskField(int index) {
    if (index >= 0 && index < _subtaskControllers.length) {
      _subtaskControllers[index].dispose();
      _subtaskControllers.removeAt(index);
      if (index < _subtaskDone.length) {
        _subtaskDone.removeAt(index);
      }
      setState(() {});
    }
  }

  static const List<String> _categoryColors = [
    '#42BCEB', // Biru Muda
    '#087FA8', // Biru Tua
    '#16865C', // Hijau
    '#D49A24', // Emas
    '#F28C45', // Oranye
    '#8C70D6', // Ungu
    '#C53D4B', // Merah
  ];

  void _showAddCategoryDialog(BuildContext context) {
    final lang = context.read<LanguageProvider>().currentLocale;
    final controller = TextEditingController();
    String selectedColor = _categoryColors.first;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            AppLocalizations.tr('addCategory', lang),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                onChanged: (_) {
                  if (errorMessage != null) {
                    setDialogState(() => errorMessage = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: lang == 'en' ? 'Category Name (e.g. Shopping)' : 'Nama Kategori (e.g. Belanja)',
                  filled: true,
                  fillColor: AppColors.background,
                  errorText: errorMessage,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.tr('categoryColor', lang),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _categoryColors.map((hex) {
                  final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                  final isSelected = selectedColor == hex;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = hex),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.white,
                          width: isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.tr('cancel', lang), style: const TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                final taskProv = context.read<TaskProvider>();
                if (name.isEmpty) {
                  setDialogState(() => errorMessage = AppLocalizations.tr('errCategoryEmpty', lang));
                  return;
                }
                if (taskProv.isCategoryNameDuplicate(name)) {
                  setDialogState(() => errorMessage = AppLocalizations.tr('errCategoryExists', lang));
                  return;
                }
                final success = await taskProv.addCategory(name, colorHex: selectedColor);
                if (success && ctx.mounted) {
                  Navigator.pop(ctx);
                  final newCat = taskProv.categories.lastWhere(
                    (c) => c.name.toLowerCase() == name.toLowerCase(),
                    orElse: () => taskProv.categories.last,
                  );
                  setState(() {
                    _selectedCategoryId = newCat.id;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlueDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                AppLocalizations.tr('save', lang),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
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
    final lang = context.read<LanguageProvider>().currentLocale;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.tr('pleaseEnterTitle', lang))),
      );
      return;
    }

    final taskProv = context.read<TaskProvider>();
    final categories = taskProv.categories;
    final selectedCat = categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => categories.isNotEmpty
          ? categories.first
          : CategoryModel(id: 'default-list', name: 'Umum', colorHex: '#42BCEB'),
    );

    final taskId = 't_${DateTime.now().millisecondsSinceEpoch}';
    final task = TaskModel(
      taskId: taskId,
      userId: widget.initialUserId,
      title: title,
      energyLevel: _selectedEnergy,
      date: _selectedDate ?? DateTime.now(),
      startTime: _selectedTime,
      notes: _notesController.text.trim(),
      listId: selectedCat.id,
      categoryName: selectedCat.name,
      categoryColor: selectedCat.colorHex,
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
    final taskProv = context.watch<TaskProvider>();
    final categories = taskProv.categories;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Drag Handle ───
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ─── Header: Judul & Tombol Tutup ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.tr('addNewTask', lang),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Field Nama Tugas ───
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.tr('taskTitle', lang),
                  hintText: 'e.g., Finalize Q4 Product Vision',
                  labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  hintStyle: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.brandBlue),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                ),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // ─── Kategori Tugas ───
              Text(
                AppLocalizations.tr('taskCategory', lang),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      return GestureDetector(
                        onTap: () => _showAddCategoryDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFCBD5E1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_rounded, size: 15, color: AppColors.brandBlueDark),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.tr('addBtn', lang),
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandBlueDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final cat = categories[index];
                    final isSelected = (_selectedCategoryId ?? (categories.isNotEmpty ? categories.first.id : 'default-list')) == cat.id;
                    final catColor = cat.colorValue;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryId = cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? catColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? catColor : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: catColor.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : catColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ─── Tingkat Energi ───
              Text(
                AppLocalizations.tr('energyLevel', lang),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _energyChip(EnergyLevel.high, AppLocalizations.tr('highFocus', lang)),
                  const SizedBox(width: 8),
                  _energyChip(EnergyLevel.medium, AppLocalizations.tr('medium', lang)),
                  const SizedBox(width: 8),
                  _energyChip(EnergyLevel.chill, AppLocalizations.tr('chill', lang)),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Deadline / Batas Waktu ───
              Row(
                children: [
                  Text(
                    AppLocalizations.tr('deadline', lang),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    lang == 'en' ? '(Time optional)' : '(Jam opsional)',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Tombol Date & Time
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showDatePicker,
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: _selectedDate != null ? AppColors.brandBlueDark : AppColors.textSecondary,
                      ),
                      label: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : AppLocalizations.tr('selectDate', lang),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: _selectedDate != null ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedDate != null ? AppColors.surfaceSoft : const Color(0xFFF8FAFC),
                        side: BorderSide(
                          color: _selectedDate != null ? AppColors.brandBlue.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                      icon: Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: _selectedTime != null ? AppColors.brandBlueDark : AppColors.textSecondary,
                      ),
                      label: Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                            : '--:--',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: _selectedTime != null ? FontWeight.w600 : FontWeight.w500,
                          color: _selectedTime != null ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedTime != null ? AppColors.surfaceSoft : const Color(0xFFF8FAFC),
                        side: BorderSide(
                          color: _selectedTime != null ? AppColors.brandBlue.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Catatan Tambahan ───
              Text(
                AppLocalizations.tr('additionalNotes', lang),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: AppLocalizations.tr('optional', lang),
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                ),
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // ─── Sub-tugas ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.tr('subtasks', lang),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (_subtaskControllers.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_subtaskControllers.length}',
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.brandBlueDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                  InkWell(
                    onTap: _addSubtaskField,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded, size: 15, color: AppColors.brandBlueDark),
                          const SizedBox(width: 3),
                          Text(
                            AppLocalizations.tr('addSubtask', lang),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandBlueDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_subtaskControllers.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Text(
                    AppLocalizations.tr('subtaskHint', lang),
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ..._subtaskControllers.map((controller) {
                final index = _subtaskControllers.indexOf(controller);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Sub-task ${index + 1}',
                            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                            prefixIcon: const Icon(
                              Icons.radio_button_unchecked_rounded,
                              size: 16,
                              color: AppColors.brandBlue,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        onPressed: () => _removeSubtaskField(index),
                        splashRadius: 18,
                        tooltip: 'Hapus sub-tugas',
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 22),

              // ─── Tombol Simpan Tugas ───
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlueDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                    shadowColor: AppColors.brandBlueDark.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.tr('saveTask', lang),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Tombol Batal / Discard ───
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.tr('discardDraft', lang),
                    style: const TextStyle(
                      fontSize: 13,
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
    Color activeBg;
    Color activeText;
    Color activeBorder;

    switch (level) {
      case EnergyLevel.high:
        activeBg = AppColors.highFocusBg;
        activeText = AppColors.highFocusText;
        activeBorder = AppColors.highFocusText.withValues(alpha: 0.4);
        break;
      case EnergyLevel.medium:
        activeBg = AppColors.mediumBg;
        activeText = AppColors.mediumText;
        activeBorder = AppColors.mediumText.withValues(alpha: 0.4);
        break;
      case EnergyLevel.chill:
        activeBg = AppColors.chillBg;
        activeText = AppColors.chillText;
        activeBorder = AppColors.chillText.withValues(alpha: 0.4);
        break;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedEnergy = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? activeBorder : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeText.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? activeText : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
