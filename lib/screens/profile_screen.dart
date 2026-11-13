import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../features/gamification/domain/gamification_service.dart';
import '../models/models.dart';
import '../core/services/report_export_service.dart';

/// Screen 3: Profil & Statistik
/// 
/// Sesuai PRD FR-16 (Level & XP), FR-18 (Achievements), FR-20 (Profile & Settings),
/// dan DESIGN.md Section 6.6
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final lang = langProv.currentLocale;
    final taskProv = context.watch<TaskProvider>();
    final user = taskProv.currentUser;

    final completed = taskProv.tasks.where((t) => t.isCompleted).length;
    final total = taskProv.tasks.length;
    final levelProgress = GamificationService.calculateLevelProgress(user.totalXp);
    final percentInt = (levelProgress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            // Title
            Text(
              AppLocalizations.tr('profileStats', lang),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),

            // ─── User Profile Card with Blue Gradient (DESIGN.md) ───
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.brandBlueDark, AppColors.brandBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandBlueDark.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang == 'en' ? 'Level ${user.currentLevel} • Great Planner' : 'Level ${user.currentLevel} • Planner Hebat',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '🔥 ${user.streakCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              AppLocalizations.tr('streakDays', lang),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Level & XP Progress bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.bolt, color: AppColors.brandCyan, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Total ${user.totalXp} XP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$percentInt% menuju Level ${user.currentLevel + 1}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: levelProgress.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandCyan),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ─── Statistics Summary (PRD FR-08) ───
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: AppLocalizations.tr('completed', lang),
                    value: '$completed',
                    subtitle: lang == 'en' ? 'of $total tasks' : 'dari $total tugas',
                    icon: Icons.check_circle,
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: AppLocalizations.tr('highFocusShort', lang),
                    value: '${taskProv.highFocusTasksCount}',
                    subtitle: AppLocalizations.tr('priorityTasks', lang),
                    icon: Icons.priority_high,
                    iconColor: AppColors.brandBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: AppLocalizations.tr('chillShort', lang),
                    value: '${taskProv.chillTasksCount}',
                    subtitle: AppLocalizations.tr('lightTasks', lang),
                    icon: Icons.coffee,
                    iconColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ─── On-Time vs Late Completion Breakdown ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.success, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${AppLocalizations.tr('onTime', lang)}: ${taskProv.completedOnTimeCount}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 16, color: AppColors.borderLight),
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Color(0xFFB96B12), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${AppLocalizations.tr('overdueSection', lang)}: ${taskProv.completedLateCount}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ─── Achievements Showcase (PRD FR-18) — Clean Vertical Achievement Timeline ───
            _buildAchievementSection(
              context: context,
              lang: lang,
              user: user,
              completed: completed,
              total: total,
            ),

            const SizedBox(height: 22),

            // ─── Custom Task Category Management (Tepat di bawah Koleksi Pencapaian) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.tr('taskCategory', lang),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${taskProv.categories.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brandBlueDark,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showAddCategoryDialog(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(AppLocalizations.tr('addBtn', lang), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brandBlueDark,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: taskProv.categories.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.borderLight),
                itemBuilder: (context, index) {
                  final cat = taskProv.categories[index];
                  final catColor = cat.colorValue;
                  final taskCount = taskProv.tasks.where((t) => t.listId == cat.id).length;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: catColor, width: 1.5),
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: catColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      cat.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      lang == 'en' ? '$taskCount tasks' : '$taskCount tugas',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                          onPressed: () => _showEditCategoryDialog(context, cat),
                          visualDensity: VisualDensity.compact,
                        ),
                        if (cat.id != 'default-list')
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFC53D4B)),
                            onPressed: () => _confirmDeleteCategory(context, cat),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            // ─── Settings Section (PRD FR-20) ───
            Text(
              AppLocalizations.tr('settingsServices', lang),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  // Language Switcher
                  ListTile(
                    leading: Container(
                       padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.language, color: AppColors.brandBlueDark, size: 20),
                    ),
                    title: Text(AppLocalizations.tr('language', lang), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(langProv.isIndonesian ? 'Bahasa Indonesia' : 'English', style: const TextStyle(fontSize: 12)),
                    trailing: Switch(
                      value: !langProv.isIndonesian,
                      activeThumbColor: AppColors.brandBlue,
                      onChanged: (_) => langProv.toggleLanguage(),
                    ),
                  ),
                  const Divider(height: 1),

                  // ─── Export Laporan Tugas (.txt) (Menggantikan Cadangkan Google Drive) ───
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBlueTint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.description_outlined, color: AppColors.brandBlue, size: 20),
                    ),
                    title: Text(AppLocalizations.tr('exportReport', lang), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(AppLocalizations.tr('exportReportSub', lang), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () => _handleExportReport(context),
                  ),
                  const Divider(height: 1),

                  // About App
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                    ),
                    title: Text(AppLocalizations.tr('aboutApp', lang), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(lang == 'en' ? 'Version 1.0.0 • Personal Productivity Planner' : 'Versi 1.0.0 • Personal Productivity Planner', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Category Dialogs ───

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
          title: Text(AppLocalizations.tr('addCategory', lang), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
              Text(AppLocalizations.tr('categoryColor', lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlueDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.tr('save', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryModel cat) {
    final lang = context.read<LanguageProvider>().currentLocale;
    final controller = TextEditingController(text: cat.name);
    String selectedColor = cat.colorHex;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppLocalizations.tr('editCategory', lang), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
                  hintText: AppLocalizations.tr('categoryName', lang),
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
              Text(AppLocalizations.tr('categoryColor', lang), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                if (taskProv.isCategoryNameDuplicate(name, excludeId: cat.id)) {
                  setDialogState(() => errorMessage = AppLocalizations.tr('errCategoryExists', lang));
                  return;
                }
                final success = await taskProv.updateCategory(cat.id, name, selectedColor);
                if (success && ctx.mounted) {
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlueDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.tr('update', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, CategoryModel cat) {
    final lang = context.read<LanguageProvider>().currentLocale;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang == 'en' ? 'Delete Category?' : 'Hapus Kategori?', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(
          lang == 'en'
              ? 'Category "${cat.name}" will be deleted. Tasks in this category will not be deleted and will be moved to "General".'
              : 'Kategori "${cat.name}" akan dihapus. Tugas yang menggunakan kategori ini tidak akan dihapus dan dialihkan ke kategori "Umum".',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.tr('cancel', lang), style: const TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskProvider>().deleteCategory(cat.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC53D4B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.tr('delete', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ─── Export Report Flow ───

  void _handleExportReport(BuildContext context) async {
    final lang = context.read<LanguageProvider>().currentLocale;
    final taskProv = context.read<TaskProvider>();
    final user = taskProv.currentUser;
    final tasks = taskProv.tasks;
    final categories = taskProv.categories;

    try {
      final file = await ReportExportService.saveReportToFile(
        user: user,
        tasks: tasks,
        categories: categories,
      );

      final reportText = ReportExportService.generateReportText(
        user: user,
        tasks: tasks,
        categories: categories,
      );

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBlueTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description, color: AppColors.brandBlue, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lang == 'en' ? 'Task Report (.txt)' : 'Laporan Tugas (.txt)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${lang == 'en' ? 'Saved to:' : 'Tersimpan di:'} ${file.path.split('/').last.split('\\').last}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  lang == 'en' ? 'Report Content Preview:' : 'Pratinjau Isi Laporan:',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 180,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      reportText,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.tr('close', lang), style: const TextStyle(color: AppColors.textMuted)),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                await ReportExportService.copyReportToClipboard(
                  user: user,
                  tasks: tasks,
                  categories: categories,
                );
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.tr('copiedClipboard', lang)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy, size: 16),
              label: Text(AppLocalizations.tr('copyText', lang)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.brandBlueDark,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await ReportExportService.shareReport(
                  user: user,
                  tasks: tasks,
                  categories: categories,
                );
              },
              icon: const Icon(Icons.share, size: 16, color: Colors.white),
              label: Text(AppLocalizations.tr('share', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlueDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengekspor laporan: $e')),
      );
    }
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  KOLEKSI PENCAPAIAN — CLEAN VERTICAL ACHIEVEMENT TIMELINE
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAchievementSection({
    required BuildContext context,
    required String lang,
    required UserModel user,
    required int completed,
    required int total,
  }) {
    final achievements = [
      _AchievementItemData(
        id: 'first-step',
        name: AppLocalizations.tr('achFirstStep', lang),
        desc: lang == 'en' ? 'Complete your first task' : 'Selesaikan tugas pertama Anda',
        requirement: lang == 'en' ? 'Complete at least 1 task' : 'Selesaikan minimal 1 tugas',
        icon: Icons.star_rounded,
        isUnlocked: completed >= 1,
        badgeColor: AppColors.achievement,
        hasProgressBar: false,
      ),
      _AchievementItemData(
        id: 'streak-7',
        name: AppLocalizations.tr('ach7DayStreak', lang),
        desc: lang == 'en' ? 'Maintain 7-day streak' : 'Pertahankan 7 hari streak',
        requirement: lang == 'en'
            ? 'Maintain 70% daily target for 7 consecutive days'
            : 'Pertahankan target 70% harian selama 7 hari berturut-turut',
        icon: Icons.local_fire_department_rounded,
        isUnlocked: user.streakCount >= 7,
        badgeColor: AppColors.streak,
        hasProgressBar: true,
        currentProgress: user.streakCount,
        targetProgress: 7,
      ),
      _AchievementItemData(
        id: 'task-master',
        name: AppLocalizations.tr('achTaskMaster', lang),
        desc: lang == 'en' ? 'Complete 50 tasks' : 'Selesaikan 50 tugas',
        requirement: lang == 'en'
            ? 'Complete a total of 50 productive tasks'
            : 'Selesaikan total 50 tugas produktif',
        icon: Icons.workspace_premium_rounded,
        isUnlocked: completed >= 50,
        badgeColor: AppColors.level,
        hasProgressBar: true,
        currentProgress: completed,
        targetProgress: 50,
      ),
      _AchievementItemData(
        id: 'perfect-day',
        name: AppLocalizations.tr('achPerfectDay', lang),
        desc: lang == 'en' ? '100% daily tasks today' : '100% target tugas hari ini',
        requirement: lang == 'en'
            ? 'Complete 100% of tasks scheduled for today'
            : 'Selesaikan 100% tugas yang dijadwalkan hari ini',
        icon: Icons.verified_rounded,
        isUnlocked: completed > 0 && completed == total,
        badgeColor: AppColors.success,
        hasProgressBar: false,
      ),
    ];

    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final totalCount = achievements.length;
    final overallRatio = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Koleksi Pencapaian ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.military_tech_rounded,
                            size: 17,
                            color: AppColors.brandBlueDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.tr('achievementCollection', lang),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Text(
                        '$unlockedCount/$totalCount ${AppLocalizations.tr('unlocked', lang)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brandBlueDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar horizontal tipis keseluruhan
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 5,
                    width: double.infinity,
                    color: const Color(0xFFF1F5F9),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: overallRatio.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.brandBlue, AppColors.brandBlueDark],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),

          // ─── Vertical Achievement Timeline ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: List.generate(achievements.length, (index) {
                final item = achievements[index];
                final isLast = index == achievements.length - 1;
                return _buildTimelineItem(
                  context: context,
                  item: item,
                  isLast: isLast,
                  lang: lang,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required _AchievementItemData item,
    required bool isLast,
    required String lang,
  }) {
    final showProgress = !item.isUnlocked && item.hasProgressBar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAchievementDetail(context, item, lang),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Kolom Kiri: Ikon Lingkaran + Garis Vertikal Timeline ───
                SizedBox(
                  width: 38,
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.isUnlocked
                              ? item.badgeColor.withValues(alpha: 0.15)
                              : const Color(0xFFF1F5F9),
                          border: Border.all(
                            color: item.isUnlocked
                                ? item.badgeColor.withValues(alpha: 0.5)
                                : const Color(0xFFCBD5E1),
                            width: item.isUnlocked ? 1.5 : 1.0,
                          ),
                          boxShadow: item.isUnlocked
                              ? [
                                  BoxShadow(
                                    color: item.badgeColor.withValues(alpha: 0.22),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            item.icon,
                            size: 19,
                            color: item.isUnlocked ? item.badgeColor : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: item.isUnlocked
                                ? item.badgeColor.withValues(alpha: 0.35)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ─── Kolom Tengah: Nama, Deskripsi, dan Selective Progress Bar ───
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.isUnlocked ? AppColors.textPrimary : const Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.desc,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Progress Bar Selektif (hanya jika target bertahap dan belum terbuka)
                        if (showProgress) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 6,
                                    color: const Color(0xFFF1F5F9),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: item.progressRatio,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.brandBlue,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${min(item.currentProgress, item.targetProgress)}/${item.targetProgress}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandBlueDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ─── Kolom Kanan: Status Badge (Terbuka / Terkunci) ───
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    if (item.isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                            const SizedBox(width: 3),
                            Text(
                              AppLocalizations.tr('unlocked', lang),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, size: 11, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 3),
                            Text(
                              AppLocalizations.tr('locked', lang),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    _AchievementItemData item,
    String lang,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final percent = (item.progressRatio * 100).toInt();

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              // Big Circular Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isUnlocked
                      ? item.badgeColor.withValues(alpha: 0.16)
                      : const Color(0xFFF1F5F9),
                  border: Border.all(
                    color: item.isUnlocked
                        ? item.badgeColor.withValues(alpha: 0.5)
                        : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                  boxShadow: item.isUnlocked
                      ? [
                          BoxShadow(
                            color: item.badgeColor.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    size: 32,
                    color: item.isUnlocked ? item.badgeColor : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isUnlocked ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.isUnlocked ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isUnlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
                      size: 13,
                      color: item.isUnlocked ? AppColors.success : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isUnlocked
                          ? AppLocalizations.tr('unlocked', lang)
                          : AppLocalizations.tr('locked', lang),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: item.isUnlocked ? AppColors.success : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info Box (Description & Requirement)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.desc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: AppColors.brandBlueDark,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${AppLocalizations.tr('requirement', lang)}: ${item.requirement}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Progress Bar if applicable
              if (item.hasProgressBar) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.tr('achProgressLabel', lang),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${min(item.currentProgress, item.targetProgress)}/${item.targetProgress} ($percent%)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandBlueDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 8,
                          width: double.infinity,
                          color: const Color(0xFFF1F5F9),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: item.progressRatio,
                            child: Container(
                              decoration: BoxDecoration(
                                color: item.isUnlocked ? AppColors.success : AppColors.brandBlue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Tombol Tutup
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlueDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.tr('close', lang),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AchievementItemData {
  final String id;
  final String name;
  final String desc;
  final String requirement;
  final IconData icon;
  final bool isUnlocked;
  final Color badgeColor;
  final bool hasProgressBar;
  final int currentProgress;
  final int targetProgress;

  const _AchievementItemData({
    required this.id,
    required this.name,
    required this.desc,
    required this.requirement,
    required this.icon,
    required this.isUnlocked,
    required this.badgeColor,
    this.hasProgressBar = false,
    this.currentProgress = 0,
    this.targetProgress = 1,
  });

  double get progressRatio {
    if (targetProgress <= 0) return 0.0;
    return (currentProgress / targetProgress).clamp(0.0, 1.0);
  }
}

