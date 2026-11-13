import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/task_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════
//  TASK COMPLETION EXPERIENCE
//  Menyediakan alur lengkap: Konfirmasi → Proses → Popup Apresiasi
//  Dipanggil via TaskCompletionExperience.startFlow(context, task)
// ═══════════════════════════════════════════════════════════════════

class TaskCompletionExperience {
  /// Titik masuk utama untuk alur penyelesaian tugas.
  /// Panggil ini sebagai pengganti langsung toggleTaskCompletion().
  static Future<void> startFlow(BuildContext context, TaskModel task) async {
    if (task.isCompleted) {
      // Jika sudah selesai → konfirmasi uncheck biasa tanpa efek
      final confirmed = await _showUncheckDialog(context, task);
      if (confirmed == true && context.mounted) {
        HapticFeedback.lightImpact();
        await context.read<TaskProvider>().toggleTaskCompletion(task.taskId);
      }
      return;
    }

    // Langkah 1: Dialog Konfirmasi
    final confirmed = await _showConfirmationDialog(context, task);
    if (confirmed != true || !context.mounted) return;

    // Langkah 2: Haptic + Proses Simpan
    HapticFeedback.mediumImpact();
    final provider = context.read<TaskProvider>();

    // Ambil snapshot XP & streak sebelum selesai
    final xpBefore = provider.currentUser.totalXp;
    final streakBefore = provider.currentUser.streakCount;
    final todayRecordBefore = provider.todayRecord;
    final wasTargetMet = todayRecordBefore?.targetMet ?? false;

    await provider.toggleTaskCompletion(task.taskId);

    if (!context.mounted) return;

    // Ambil snapshot setelah selesai
    final xpAfter = provider.currentUser.totalXp;
    final xpGained = (xpAfter - xpBefore).clamp(0, 100);
    final streakAfter = provider.currentUser.streakCount;
    final todayRecordAfter = provider.todayRecord;
    final isNowTargetMet = todayRecordAfter?.targetMet ?? false;
    final streakJustUnlocked = !wasTargetMet && isNowTargetMet;
    final streakIncreased = streakAfter > streakBefore;

    // Langkah 3: Popup Apresiasi
    await _showAppreciationDialog(
      context,
      task: task,
      xpGained: xpGained,
      streakCount: streakAfter,
      streakJustUnlocked: streakJustUnlocked || streakIncreased,
      todayPercent: todayRecordAfter?.completionPercentage ?? 0.0,
      targetMet: isNowTargetMet,
    );
  }

  // ─── Dialog Konfirmasi Penyelesaian ───────────────────────────────
  static Future<bool?> _showConfirmationDialog(
    BuildContext context,
    TaskModel task,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => _ConfirmationDialog(task: task),
    );
  }

  // ─── Dialog Uncheck ───────────────────────────────────────────────
  static Future<bool?> _showUncheckDialog(
    BuildContext context,
    TaskModel task,
  ) {
    final lang = context.read<LanguageProvider>().currentLocale;
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          lang == 'en' ? 'Undo completion?' : 'Batalkan penyelesaian?',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        content: Text(
          lang == 'en' ? 'This task will be returned to pending status.' : 'Tugas ini akan dikembalikan ke status belum selesai.',
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang == 'en' ? 'No' : 'Tidak', style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(lang == 'en' ? 'Yes, undo' : 'Ya, batalkan'),
          ),
        ],
      ),
    );
  }

  // ─── Popup Apresiasi ──────────────────────────────────────────────
  static Future<void> _showAppreciationDialog(
    BuildContext context, {
    required TaskModel task,
    required int xpGained,
    required int streakCount,
    required bool streakJustUnlocked,
    required double todayPercent,
    required bool targetMet,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => _AppreciationDialog(
        task: task,
        xpGained: xpGained,
        streakCount: streakCount,
        streakJustUnlocked: streakJustUnlocked,
        todayPercent: todayPercent,
        targetMet: targetMet,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  _ConfirmationDialog — Dialog Konfirmasi (Step A)
// ═══════════════════════════════════════════════════════════════════
class _ConfirmationDialog extends StatelessWidget {
  final TaskModel task;
  const _ConfirmationDialog({required this.task});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLocale;
    final isLate = task.isLate;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Gradasi Biru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA8E5F8), Color(0xFF42BCEB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: Color(0xFF087FA8),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang == 'en' ? 'Confirm Completion' : 'Konfirmasi Penyelesaian',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Column(
                children: [
                  // Task title chip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lang == 'en'
                        ? 'Have you really completed this task?'
                        : 'Apakah kamu benar-benar sudah menyelesaikan tugas ini?',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLate
                        ? (lang == 'en'
                            ? 'You are completing this after the deadline, but it still counts! Please ensure it is truly done.'
                            : 'Kamu menyelesaikan ini setelah batas waktu, tapi itu tetap dihitung! Pastikan sudah benar-benar selesai ya.')
                        : (lang == 'en'
                            ? 'Make sure your activity is complete before proceeding.'
                            : 'Pastikan aktivitasmu sudah selesai sebelum melanjutkan.'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isLate) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFCCC7)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFFCF1322)),
                          const SizedBox(width: 6),
                          Text(
                            lang == 'en' ? 'Late by ${task.elapsedLateMinutes} minutes' : 'Terlambat ${task.elapsedLateMinutes} menit',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCF1322),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        lang == 'en' ? 'Not yet, cancel' : 'Belum, batalkan',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        lang == 'en' ? 'Yes, completed! ✓' : 'Ya, sudah selesai! ✓',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
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

// ═══════════════════════════════════════════════════════════════════
//  _AppreciationDialog — Popup Apresiasi (Step C)
//  Menampilkan XP, streak, refleksi perasaan, dan partikel confetti
// ═══════════════════════════════════════════════════════════════════
class _AppreciationDialog extends StatefulWidget {
  final TaskModel task;
  final int xpGained;
  final int streakCount;
  final bool streakJustUnlocked;
  final double todayPercent;
  final bool targetMet;

  const _AppreciationDialog({
    required this.task,
    required this.xpGained,
    required this.streakCount,
    required this.streakJustUnlocked,
    required this.todayPercent,
    required this.targetMet,
  });

  @override
  State<_AppreciationDialog> createState() => _AppreciationDialogState();
}

class _AppreciationDialogState extends State<_AppreciationDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _xpCtrl;
  late AnimationController _particleCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _xpAnim;

  int? _selectedMood; // 0=Senang 1=Lega 2=Bangga 3=Biasa
  final List<_Particle> _particles = [];
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _xpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _xpAnim = CurvedAnimation(parent: _xpCtrl, curve: Curves.easeOut);

    _generateParticles();

    _scaleCtrl.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _xpCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _particleCtrl.forward();
    });

    HapticFeedback.heavyImpact();
  }

  void _generateParticles() {
    final colors = [
      AppColors.brandSky,
      AppColors.brandBlue,
      AppColors.achievement,
      AppColors.streak,
      const Color(0xFF52C41A),
      const Color(0xFFEB2F96),
    ];
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        color: colors[_rand.nextInt(colors.length)],
        x: _rand.nextDouble() * 2 - 1,
        y: _rand.nextDouble() * -1.5 - 0.2,
        size: _rand.nextDouble() * 7 + 4,
        speed: _rand.nextDouble() * 0.5 + 0.5,
        angle: _rand.nextDouble() * pi * 2,
      ));
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _xpCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  String _headlineText(String lang) {
    if (widget.task.isCompletedLate) return lang == 'en' ? 'Good job! 💪' : 'Kerja bagus! 💪';
    if (widget.targetMet) return lang == 'en' ? 'Amazing! 🎉' : 'Luar biasa! 🎉';
    return lang == 'en' ? 'Good job! 🌟' : 'Kerja bagus! 🌟';
  }

  String _bodyText(String lang) {
    if (widget.targetMet && widget.streakJustUnlocked) {
      return lang == 'en'
          ? '70% daily target reached and your streak increased! Consistency is key. Keep it up!'
          : 'Target harian 70% tercapai dan streak kamu bertambah! Konsistensi adalah kunci sukses. Terus pertahankan!';
    }
    if (widget.targetMet) {
      return lang == 'en'
          ? 'You reached the 70% daily target! Your productivity today is impressive. Keep up the good work!'
          : 'Kamu telah mencapai target harian 70%! Produktivitas kamu hari ini sangat mengesankan. Pertahankan semangatmu!';
    }
    if (widget.task.isCompletedLate) {
      return lang == 'en'
          ? 'Better late than never! Progress is progress, and your plant continues to grow!'
          : 'Lebih baik terlambat daripada tidak selesai sama sekali. Progres tetap progres, tanamanmu tetap tumbuh!';
    }
    return lang == 'en'
        ? 'You just completed an activity. Keep maintaining positive momentum and your plant will flourish!'
        : 'Kamu baru saja menyelesaikan satu aktivitas. Terus pertahankan progres positifmu dan tanamanmu makin subur!';
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().currentLocale;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // ─── Main Card ───────────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Spacer for floating icon
                  const SizedBox(height: 44),

                  // Headline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _headlineText(lang),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _bodyText(lang),
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── XP & Streak Row ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // XP Chip
                        Expanded(
                          child: _StatChip(
                            icon: Icons.star_rounded,
                            iconColor: AppColors.achievement,
                            bgColor: const Color(0xFFFFF8E6),
                            label: lang == 'en' ? 'XP Earned' : 'XP Diperoleh',
                            valueWidget: AnimatedBuilder(
                              animation: _xpAnim,
                              builder: (_, __) {
                                final val = (widget.xpGained * _xpAnim.value).round();
                                return Text(
                                  '+$val XP',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.achievement,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Streak Chip
                        Expanded(
                          child: _StatChip(
                            icon: Icons.local_fire_department_rounded,
                            iconColor: AppColors.streak,
                            bgColor: const Color(0xFFFFF4ED),
                            label: 'Streak',
                            valueWidget: Text(
                              '${widget.streakCount} ${lang == 'en' ? 'days' : 'hari'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.streak,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─── Target Harian Banner ─────────────────────────
                  if (widget.targetMet) ...[
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF52C41A), Color(0xFF73D13D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              widget.streakJustUnlocked
                                  ? (lang == 'en' ? '🔥 70% Target reached! Streak +1!' : '🔥 Target 70% tercapai! Streak +1!')
                                  : (lang == 'en' ? '✅ 70% Target reached today!' : '✅ Target 70% hari ini tercapai!'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // ─── Refleksi Perasaan (Opsional) ────────────────
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lang == 'en' ? 'How are you feeling? (optional)' : 'Bagaimana perasaanmu? (opsional)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _MoodButton(emoji: '😊', label: lang == 'en' ? 'Happy' : 'Senang', index: 0, selected: _selectedMood == 0, onTap: () => setState(() => _selectedMood = 0)),
                        _MoodButton(emoji: '😌', label: lang == 'en' ? 'Relieved' : 'Lega', index: 1, selected: _selectedMood == 1, onTap: () => setState(() => _selectedMood = 1)),
                        _MoodButton(emoji: '💪', label: lang == 'en' ? 'Proud' : 'Bangga', index: 2, selected: _selectedMood == 2, onTap: () => setState(() => _selectedMood = 2)),
                        _MoodButton(emoji: '😐', label: lang == 'en' ? 'Neutral' : 'Biasa', index: 3, selected: _selectedMood == 3, onTap: () => setState(() => _selectedMood = 3)),
                      ],
                    ),
                  ),

                  // ─── Tombol Lanjut ────────────────────────────────
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          lang == 'en' ? 'Continue activity 🚀' : 'Lanjutkan aktivitas 🚀',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Floating Icon Bulat ──────────────────────────────
            Positioned(
              top: 0,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42BCEB), Color(0xFF087FA8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandBlue.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),

            // ─── Partikel Confetti ────────────────────────────────
            AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) {
                return IgnorePointer(
                  child: SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: CustomPaint(
                      painter: _ParticlePainter(
                        particles: _particles,
                        progress: _particleCtrl.value,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Chip ─────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final Widget valueWidget;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 4),
          valueWidget,
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: iconColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mood Button ───────────────────────────────────────────────────
class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSky.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.brandBlue : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.brandBlue : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Partikel Confetti Painter ─────────────────────────────────────
class _Particle {
  final Color color;
  final double x;    // posisi horizontal relatif terhadap center (-1 to 1)
  final double y;    // posisi vertikal awal (negatif = atas)
  final double size;
  final double speed;
  final double angle;

  const _Particle({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress >= 0.98) return;

    final paint = Paint();
    final centerX = size.width / 2;

    for (final p in particles) {
      final t = (progress * p.speed).clamp(0.0, 1.0);
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final x = centerX + p.x * size.width * 0.5 + sin(p.angle + t * pi) * 24;
      final y = p.y * size.height + t * size.height * 0.9;

      paint.color = p.color.withValues(alpha: opacity * 0.85);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * pi * 2 * p.speed);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

