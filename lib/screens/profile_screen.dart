import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../features/gamification/domain/gamification_service.dart';

/// Screen 3: Profil & Statistik
/// 
/// Sesuai PRD FR-16 (Level & XP), FR-18 (Achievements), FR-20 (Profile & Settings),
/// dan DESIGN.md Section 6.6
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
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
            const Text(
              'Profil & Statistik',
              style: TextStyle(
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
                              'Level ${user.currentLevel} • Planner Hebat',
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
                              'hari streak',
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
                                const Icon(Icons.bolt, color: AppColors.gradientStart, size: 16),
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
                    title: 'Selesai',
                    value: '$completed',
                    subtitle: 'dari $total tugas',
                    icon: Icons.check_circle,
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: 'Fokus Tinggi',
                    value: '${taskProv.highFocusTasksCount}',
                    subtitle: 'tugas prioritas',
                    icon: Icons.priority_high,
                    iconColor: AppColors.brandBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: 'Santai',
                    value: '${taskProv.chillTasksCount}',
                    subtitle: 'tugas ringan',
                    icon: Icons.coffee,
                    iconColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ─── Achievements Showcase (PRD FR-18) ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Koleksi Pencapaian',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  completed >= 1 ? '1/4 Terbuka' : '0/4 Terbuka',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandBlueDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _badgeCard(
                  name: 'Langkah Pertama',
                  desc: 'Selesaikan 1 tugas',
                  icon: Icons.star,
                  isUnlocked: completed >= 1,
                  badgeColor: AppColors.achievement,
                ),
                _badgeCard(
                  name: 'Streak 7 Hari',
                  desc: 'Pertahankan 7 hari streak',
                  icon: Icons.local_fire_department,
                  isUnlocked: user.streakCount >= 7,
                  badgeColor: AppColors.streak,
                ),
                _badgeCard(
                  name: 'Ahli Tugas',
                  desc: 'Selesaikan 50 tugas',
                  icon: Icons.workspace_premium,
                  isUnlocked: completed >= 50,
                  badgeColor: AppColors.level,
                ),
                _badgeCard(
                  name: 'Hari Sempurna',
                  desc: '100% tugas hari ini',
                  icon: Icons.verified,
                  isUnlocked: completed > 0 && completed == total,
                  badgeColor: AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ─── Settings Section (PRD FR-20) ───
            const Text(
              'Pengaturan & Layanan',
              style: TextStyle(
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
                    title: const Text('Bahasa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(langProv.isIndonesian ? 'Bahasa Indonesia' : 'English', style: const TextStyle(fontSize: 12)),
                    trailing: Switch(
                      value: !langProv.isIndonesian,
                      activeThumbColor: AppColors.brandBlue,
                      onChanged: (_) => langProv.toggleLanguage(),
                    ),
                  ),
                  const Divider(height: 1),

                  // Google Drive Backup (PRD FR-11)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBlueTint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.cloud_upload_outlined, color: AppColors.brandBlue, size: 20),
                    ),
                    title: const Text('Cadangkan ke Google Drive', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Sinkronisasi dan pemulihan data lokal', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Penyimpanan lokal aktif. Cadangan Google Drive siap dikonfigurasi pada Milestone berikutnya.'),
                        ),
                      );
                    },
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
                    title: const Text('Tentang MyPlan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Versi 1.0.0 • Personal Productivity Planner', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _badgeCard({
    required String name,
    required String desc,
    required IconData icon,
    required bool isUnlocked,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : AppColors.surfaceSoft.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? badgeColor.withValues(alpha: 0.4) : AppColors.borderLight,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUnlocked ? badgeColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isUnlocked ? badgeColor : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
