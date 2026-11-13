import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/task_completion_experience.dart';

/// Screen 1: Beranda / Home ("Hari Ini")
/// 
/// Mengimplementasikan Blue Gradient Blur + Glassmorphism sesuai DESIGN.md dan ui_1_referensi
class HomeScreen extends StatefulWidget {
  final VoidCallback onAddTask;
  final Function(TaskModel) onTaskTapped;

  const HomeScreen({
    super.key,
    required this.onAddTask,
    required this.onTaskTapped,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCompletedExpanded = true;

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final lang = langProv.currentLocale;
    final taskProv = context.watch<TaskProvider>();
    final user = taskProv.currentUser;
    final allToday = taskProv.todayTasks;
    final overdueTasks = taskProv.filteredOverdueTasks;
    final todayPendingTasks = taskProv.filteredTodayPendingTasks;
    final upcomingTasks = taskProv.filteredUpcomingTasks;
    final completedTasks = taskProv.filteredCompletedTasks;

    // Perhitungan target 70% (PRD FR-17)
    final totalCount = allToday.length;
    final doneTodayCount = allToday.where((t) => t.isCompleted).length;
    final percent = totalCount > 0 ? (doneTodayCount / totalCount) : 0.0;
    final percentInt = (percent * 100).toInt();
    final minRequired = (totalCount * 0.70).ceil();
    final remainingForStreak = (minRequired - doneTodayCount).clamp(0, totalCount);

    final now = DateTime.now();
    String dateFormatted;
    try {
      dateFormatted = DateFormat('EEEE, d MMM', langProv.currentLocale).format(now);
    } catch (_) {
      try {
        dateFormatted = DateFormat('EEEE, d MMM').format(now);
      } catch (_) {
        dateFormatted = '${now.day}/${now.month}/${now.year}';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Ambient Blue Blur Glow (DESIGN.md) ───
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gradientStart.withValues(alpha: 0.5),
                    AppColors.gradientMiddle.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brandCyan.withValues(alpha: 0.35),
                    AppColors.gradientEnd.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ─── Main Content ───
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              children: [
                // Top App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.brandBlue, AppColors.brandCyan],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brandBlue.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.checklist_rtl, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 10),
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
                              AppLocalizations.tr('navToday', lang),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Language toggle
                        GestureDetector(
                          onTap: () => langProv.toggleLanguage(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              langProv.isIndonesian ? '🇮🇩 ID' : '🇬🇧 EN',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSoft,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.person, color: AppColors.brandBlueDark, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Greeting & Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.wb_sunny_rounded, size: 15, color: AppColors.brandBlueDark),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateFormatted,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBlueTint,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.brandBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.tr('productiveDay', lang),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brandBlueDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Selamat pagi, ${user.name} ✨',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Apa satu hal penting yang ingin kamu selesaikan hari ini?',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 18),

                // ─── Glassmorphic Gamification & Streak Panel (DESIGN.md) ───
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brandBlue.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Streak + XP Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.streak.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Icon(Icons.local_fire_department, color: AppColors.streak, size: 26),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Streak ${user.streakCount} hari',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.streak.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'On Fire!',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.streak,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Level ${user.currentLevel} • Planner Hebat',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt, color: AppColors.xp, size: 15),
                                const SizedBox(width: 2),
                                Text(
                                  '+10 XP / tugas',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.brandBlueDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Progress Bar Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.verified, size: 15, color: AppColors.brandBlue),
                              const SizedBox(width: 6),
                              Text(
                                '$doneTodayCount dari $totalCount tugas harian',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Text(
                            '$percentInt% selesai',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandBlueDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Gradient Progress Track
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBlueTint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percent.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.brandBlue, AppColors.brandCyan],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandBlue.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Streak Threshold note (FR-17)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Target harian (FR-17: 70% threshold)',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          Text(
                            remainingForStreak > 0
                                ? 'Tinggal $remainingForStreak tugas lagi 🚀'
                                : 'Target hari ini tercapai! 🎉',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: remainingForStreak > 0 ? AppColors.brandBlueDark : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ─── Filter Baris 1: Kategori (Dinamis dari Database) ───
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskProv.categories.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isSelected = taskProv.selectedCategoryFilter == 'all';
                        return _categoryFilterChip(
                          label: AppLocalizations.tr('allCategories', lang),
                          isSelected: isSelected,
                          onTap: () => taskProv.setCategoryFilter('all'),
                        );
                      }
                      final cat = taskProv.categories[index - 1];
                      final isSelected = taskProv.selectedCategoryFilter == cat.id;
                      final count = taskProv.tasks.where((t) => t.listId == cat.id).length;
                      return _categoryFilterChip(
                        label: cat.name,
                        dotColor: cat.colorValue,
                        isSelected: isSelected,
                        count: count,
                        onTap: () => taskProv.setCategoryFilter(cat.id),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // ─── Filter Baris 2: Tingkat Energi (Semua, Fokus Tinggi, Sedang, Santai) ───
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _energyFilterChip(
                        label: AppLocalizations.tr('allFilter', lang),
                        isSelected: taskProv.selectedEnergyFilter == 'all',
                        onTap: () => taskProv.setEnergyFilter('all'),
                      ),
                      const SizedBox(width: 8),
                      _energyFilterChip(
                        label: AppLocalizations.tr('highFocus', lang),
                        isSelected: taskProv.selectedEnergyFilter == 'high',
                        count: taskProv.highFocusTasksCount,
                        onTap: () => taskProv.setEnergyFilter('high'),
                      ),
                      const SizedBox(width: 8),
                      _energyFilterChip(
                        label: AppLocalizations.tr('medium', lang),
                        isSelected: taskProv.selectedEnergyFilter == 'medium',
                        count: taskProv.mediumFocusTasksCount,
                        onTap: () => taskProv.setEnergyFilter('medium'),
                      ),
                      const SizedBox(width: 8),
                      _energyFilterChip(
                        label: AppLocalizations.tr('chill', lang),
                        isSelected: taskProv.selectedEnergyFilter == 'chill',
                        count: taskProv.chillTasksCount,
                        onTap: () => taskProv.setEnergyFilter('chill'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ─── KELOMPOK 1: TERLAMBAT ───
                if (overdueTasks.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFC53D4B)),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.tr('overdueSection', lang),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFC53D4B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3E3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFA5252), width: 0.5),
                        ),
                        child: Text(
                          '${overdueTasks.length} terlambat',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC53D4B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...overdueTasks.map((task) => _buildTaskRow(task, taskProv, lang: lang)),
                  const SizedBox(height: 22),
                ],

                // ─── KELOMPOK 2: HARI INI ───
                Row(
                  children: [
                    const Icon(Icons.today, size: 19, color: AppColors.brandBlueDark),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.tr('todaySection', lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBlueTint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${todayPendingTasks.length} fokus',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandBlueDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (todayPendingTasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 36, color: AppColors.success),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.tr('noTasksToday', lang),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Semua tugas hari ini telah diselesaikan atau dijadwalkan.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                else
                  ...todayPendingTasks.map((task) => _buildTaskRow(task, taskProv, lang: lang)),

                const SizedBox(height: 22),

                // ─── KELOMPOK 3: AKAN DATANG ───
                Row(
                  children: [
                    const Icon(Icons.upcoming_outlined, size: 19, color: AppColors.brandBlueDark),
                    const SizedBox(width: 6),
                    Text(
                      AppLocalizations.tr('upcomingSection', lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${upcomingTasks.length} tugas',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (upcomingTasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      lang == 'en' ? 'No upcoming tasks scheduled.' : 'Belum ada tugas terjadwal mendatang.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  )
                else
                  ...upcomingTasks.map((task) => _buildTaskRow(task, taskProv, lang: lang)),

                const SizedBox(height: 22),

                // ─── Collapsible Selesai Section ───
                if (completedTasks.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () => setState(() => _isCompletedExpanded = !_isCompletedExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Text(
                            '${AppLocalizations.tr('completedSection', lang)} (${completedTasks.length})',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            _isCompletedExpanded ? Icons.expand_more : Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isCompletedExpanded)
                    ...completedTasks.map((task) => _buildTaskRow(task, taskProv, isDone: true, lang: lang)),
                ],
              ],
            ),
          ),

          // ─── Floating Action Button (+) ───
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: widget.onAddTask,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.brandBlue, AppColors.brandSky],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandBlue.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryFilterChip({
    required String label,
    Color? dotColor,
    required bool isSelected,
    int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlueDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brandBlueDark : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandBlueDark.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : dotColor,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.brandBlueDark,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _energyFilterChip({
    required String label,
    required bool isSelected,
    int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlueDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brandBlueDark : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandBlueDark.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.brandBlueDark,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskRow(TaskModel task, TaskProvider taskProv, {bool isDone = false, required String lang}) {
    final now = DateTime.now();
    final isToday = task.date.year == now.year &&
        task.date.month == now.month &&
        task.date.day == now.day;
    final datePrefix = !isToday ? '${task.date.day}/${task.date.month} • ' : '';
    final timeStr = task.startTime != null
        ? '$datePrefix${task.startTime!.hour.toString().padLeft(2, '0')}.${task.startTime!.minute.toString().padLeft(2, '0')}'
        : (!isToday ? '${task.date.day}/${task.date.month} • 23.59' : null);

    final subDone = task.subtasks.where((s) => s.isCompleted).length;
    final subTotal = task.subtasks.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: isDone ? Colors.white.withValues(alpha: 0.85) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? AppColors.borderLight : AppColors.border,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDone ? 0.01 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => widget.onTaskTapped(task),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox Circle (Proporsional 24x24)
            GestureDetector(
              onTap: () => TaskCompletionExperience.startFlow(context, task),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
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
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris 1: Judul Tugas (Expanded) & Waktu/Tanggal (Kanan Atas)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timeStr != null) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.schedule, size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 3),
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Baris 2: Metadata Badges (Status, Kategori, Prioritas, Subtugas) & Tag XP
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // 1. Badge Status Khusus (Terlambat / Mendekati Deadline)
                            if (isDone && task.isCompletedLate)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3DC),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE59900), width: 0.5),
                                ),
                                child: Text(
                                  AppLocalizations.tr('completedLateTag', lang),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFB96B12)),
                                ),
                              )
                            else if (!isDone && task.isApproachingDeadline)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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
                                      '${AppLocalizations.tr('deadlineApproach', lang)} ${task.minutesUntilDeadline}m ${AppLocalizations.tr('doNow', lang)}',
                                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFFB96B12)),
                                    ),
                                  ],
                                ),
                              )
                            else if (!isDone && task.isLate)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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
                                      '${AppLocalizations.tr('lateMinutes', lang)} ${task.formattedLateDuration(lang)}',
                                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFFC53D4B)),
                                    ),
                                  ],
                                ),
                              ),

                            // 2. Category badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSoft,
                                borderRadius: BorderRadius.circular(8),
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

                            // 3. Priority badge
                            if (task.energyLevel == EnergyLevel.high)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceBlueTint,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.priority_high, size: 12, color: AppColors.brandBlueDark),
                                    const SizedBox(width: 2),
                                    Text(
                                      AppLocalizations.tr('highFocusShort', lang),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.brandBlueDark,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (task.energyLevel == EnergyLevel.medium)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppLocalizations.tr('mediumShort', lang),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                                ),
                              )
                            else if (task.energyLevel == EnergyLevel.chill)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppLocalizations.tr('chillShort', lang),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                              ),

                            // 4. Subtasks badge
                            if (subTotal > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceSoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.checklist, size: 12, color: AppColors.textSecondary),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${lang == 'en' ? 'Subtasks' : 'Subtugas'} $subDone/$subTotal',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // 5. XP Tag (Kanan Bawah)
                      Text(
                        isDone ? '+10 XP Didapat' : '+10 XP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDone ? AppColors.brandBlue : AppColors.brandSky,
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
    );
  }
}