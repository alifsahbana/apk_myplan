import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/models.dart';

/// Service untuk mengekspor laporan produktivitas tugas ke format TXT
class ReportExportService {
  ReportExportService._();

  /// Menghasilkan string teks laporan lengkap
  static String generateReportText({
    required UserModel user,
    required List<TaskModel> tasks,
    required List<CategoryModel> categories,
  }) {
    final now = DateTime.now();
    String formattedDate;
    try {
      final dateFormat = DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID');
      formattedDate = '${dateFormat.format(now)} WIB';
    } catch (_) {
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
      formattedDate = '${dateFormat.format(now)} WIB';
    }

    final totalTasks = tasks.length;
    final completedOnTime = tasks.where((t) => t.isCompletedOnTime).length;
    final completedLate = tasks.where((t) => t.isCompletedLate).length;
    final totalCompleted = tasks.where((t) => t.isCompleted).length;
    final pendingNormal = tasks.where((t) => !t.isCompleted && !t.isLate && !t.isApproachingDeadline).length;
    final pendingApproaching = tasks.where((t) => t.isApproachingDeadline).length;
    final pendingLate = tasks.where((t) => !t.isCompleted && t.isLate).length;

    final completionRate = totalTasks > 0
        ? ((totalCompleted / totalTasks) * 100).toStringAsFixed(1)
        : '0.0';

    final buffer = StringBuffer();
    buffer.writeln('======================================================================');
    buffer.writeln('                     LAPORAN PRODUKTIVITAS MYPLAN');
    buffer.writeln('======================================================================');
    buffer.writeln('Waktu Export    : $formattedDate');
    buffer.writeln('Pengguna        : ${user.name}');
    buffer.writeln('Status Level    : Level ${user.currentLevel} (Planner Hebat)');
    buffer.writeln('Total XP        : ${user.totalXp} XP');
    buffer.writeln('Streak Berjalan : ${user.streakCount} Hari');
    buffer.writeln('Target Harian   : Memenuhi ambang batas 70%');
    buffer.writeln('');
    buffer.writeln('----------------------------------------------------------------------');
    buffer.writeln('RINGKASAN TUGAS');
    buffer.writeln('----------------------------------------------------------------------');
    buffer.writeln('Total Seluruh Tugas       : $totalTasks');
    buffer.writeln('- Selesai Tepat Waktu     : $completedOnTime tugas');
    buffer.writeln('- Selesai Terlambat       : $completedLate tugas');
    buffer.writeln('- Belum Selesai (Normal)  : $pendingNormal tugas');
    buffer.writeln('- Mendekati Deadline (<30m): $pendingApproaching tugas');
    buffer.writeln('- Terlambat (Lewat Deadline): $pendingLate tugas');
    buffer.writeln('Tingkat Keberhasilan      : $completionRate%');
    buffer.writeln('');
    buffer.writeln('----------------------------------------------------------------------');
    buffer.writeln('DAFTAR KATEGORI AKTIF');
    buffer.writeln('----------------------------------------------------------------------');
    if (categories.isEmpty) {
      buffer.writeln('(Belum ada kategori kustom)');
    } else {
      for (final cat in categories) {
        final count = tasks.where((t) => t.listId == cat.id || t.categoryName == cat.name).length;
        buffer.writeln('• ${cat.name} ($count tugas)');
      }
    }
    buffer.writeln('');
    buffer.writeln('----------------------------------------------------------------------');
    buffer.writeln('RINCIAN TUGAS');
    buffer.writeln('----------------------------------------------------------------------');

    if (tasks.isEmpty) {
      buffer.writeln('Belum ada tugas yang tercatat.');
    } else {
      for (int i = 0; i < tasks.length; i++) {
        final task = tasks[i];
        final taskNum = i + 1;

        // Label status
        String statusLabel;
        if (task.isCompleted) {
          if (task.isCompletedLate) {
            statusLabel = '[!] SELESAI TERLAMBAT';
          } else {
            statusLabel = '[✓] SELESAI TEPAT WAKTU';
          }
        } else {
          if (task.isApproachingDeadline) {
            statusLabel = '[⚠️] MENDEKATI DEADLINE (Sisa ${task.minutesUntilDeadline} mnt)';
          } else if (task.isLate) {
            statusLabel = '[X] TERLAMBAT (${task.elapsedLateMinutes} mnt lewat deadline)';
          } else {
            statusLabel = '[ ] BELUM SELESAI (Aktif)';
          }
        }

        // Energy label
        String energyStr;
        switch (task.energyLevel) {
          case EnergyLevel.high:
            energyStr = 'Fokus Tinggi (⚡)';
            break;
          case EnergyLevel.medium:
            energyStr = 'Sedang (🔋)';
            break;
          case EnergyLevel.chill:
            energyStr = 'Santai (☕)';
            break;
        }

        // Scheduled time
        final timeStr = task.startTime != null
            ? '${task.startTime!.hour.toString().padLeft(2, '0')}:${task.startTime!.minute.toString().padLeft(2, '0')} WIB'
            : 'Sepanjang Hari';
        final dateStr = '${task.date.day.toString().padLeft(2, '0')}/${task.date.month.toString().padLeft(2, '0')}/${task.date.year}';

        buffer.writeln('$taskNum. $statusLabel | ${task.title}');
        buffer.writeln('    Kategori       : ${task.categoryName}');
        buffer.writeln('    Tingkat Energi : $energyStr');
        buffer.writeln('    Jadwal         : $dateStr • $timeStr');

        if (task.isCompleted && task.completedAt != null) {
          final compFormat = DateFormat('dd/MM/yyyy HH:mm');
          buffer.writeln('    Selesai Pada   : ${compFormat.format(task.completedAt!)} WIB');
        }

        if (task.notes.trim().isNotEmpty) {
          buffer.writeln('    Catatan        : ${task.notes.trim()}');
        }

        if (task.subtasks.isNotEmpty) {
          final subDone = task.completedSubtaskCount;
          buffer.writeln('    Sub-tugas ($subDone/${task.subtasks.length}):');
          for (final st in task.subtasks) {
            final check = st.isCompleted ? '[✓]' : '[ ]';
            buffer.writeln('      $check ${st.title}');
          }
        }
        buffer.writeln('');
      }
    }

    buffer.writeln('======================================================================');
    buffer.writeln('               Dicetak otomatis melalui MyPlan App');
    buffer.writeln('======================================================================');

    return buffer.toString();
  }

  /// Menyimpan laporan ke file .txt di direktori dokumen lokal
  static Future<File> saveReportToFile({
    required UserModel user,
    required List<TaskModel> tasks,
    required List<CategoryModel> categories,
  }) async {
    final reportContent = generateReportText(
      user: user,
      tasks: tasks,
      categories: categories,
    );

    final directory = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final timeStamp = DateFormat('yyyyMMdd_HHmmss').format(now);
    final fileName = 'Laporan_MyPlan_$timeStamp.txt';
    final file = File('${directory.path}/$fileName');

    return await file.writeAsString(reportContent);
  }

  /// Membagikan berkas .txt melalui Android Share Sheet
  static Future<void> shareReport({
    required UserModel user,
    required List<TaskModel> tasks,
    required List<CategoryModel> categories,
  }) async {
    final file = await saveReportToFile(
      user: user,
      tasks: tasks,
      categories: categories,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/plain')],
        subject: 'Laporan Produktivitas MyPlan - ${user.name}',
        text: 'Berikut adalah laporan produktivitas tugas MyPlan.',
      ),
    );
  }

  /// Salin isi teks laporan ke clipboard
  static Future<void> copyReportToClipboard({
    required UserModel user,
    required List<TaskModel> tasks,
    required List<CategoryModel> categories,
  }) async {
    final reportContent = generateReportText(
      user: user,
      tasks: tasks,
      categories: categories,
    );
    await Clipboard.setData(ClipboardData(text: reportContent));
  }
}
