/// Lightweight localization dictionary for Bahasa Indonesia (default) and English.
class AppLocalizations {
  AppLocalizations._();

  static const Map<String, Map<String, String>> _translations = {
    // ─── General ───
    'appName': {'id': 'MyPlan', 'en': 'MyPlan'},

    // ─── Greeting ───
    'goodMorning': {'id': 'Selamat Pagi,', 'en': 'Good Morning,'},
    'goodAfternoon': {'id': 'Selamat Siang,', 'en': 'Good Afternoon,'},
    'goodEvening': {'id': 'Selamat Sore,', 'en': 'Good Evening,'},
    'goodNight': {'id': 'Selamat Malam,', 'en': 'Good Night,'},
    'planWithIntention': {
      'id': 'Rencanakan dengan niat',
      'en': 'Plan with intention',
    },

    // ─── Navigation ───
    'navToday': {'id': 'Hari Ini', 'en': 'My Day'},
    'navCalendar': {'id': 'Kalender', 'en': 'Calendar'},
    'navProfile': {'id': 'Profil', 'en': 'Profile'},
    'today': {'id': 'Hari Ini', 'en': 'Today'},

    // ─── Filter Chips ───
    'allTasks': {'id': 'Semua Tugas', 'en': 'All Tasks'},

    // ─── Energy Levels ───
    'highFocus': {'id': '⚡ Fokus Tinggi', 'en': '⚡ High Focus'},
    'medium': {'id': '🔋 Sedang', 'en': '🔋 Medium'},
    'chill': {'id': '☕ Santai', 'en': '☕ Chill'},
    'highFocusShort': {'id': 'Fokus Tinggi', 'en': 'High Focus'},
    'mediumShort': {'id': 'Sedang', 'en': 'Medium'},
    'chillShort': {'id': 'Santai', 'en': 'Chill'},

    // ─── Add Task Modal ───
    'addNewTask': {'id': 'Tugas Baru', 'en': 'New Task'},
    'taskTitle': {'id': 'Nama Tugas', 'en': 'Task Title'},
    'energyLevel': {'id': 'Tingkat Energi', 'en': 'Energy Level'},
    'saveTask': {'id': 'Simpan Tugas', 'en': 'Save Task'},
    'selectDate': {'id': 'Pilih Tanggal', 'en': 'Select Date'},
    'addSubtask': {'id': 'Tambah Sub-tugas', 'en': 'Add Sub-task'},
    'subtaskHint': {'id': 'Nama sub-tugas', 'en': 'Sub-task name'},
    'discardDraft': {'id': 'Buang Draft', 'en': 'Discard Draft'},

    // ─── Task Detail ───
    'taskDetail': {'id': 'Detail Tugas', 'en': 'Task Details'},
    'completionProgress': {
      'id': 'Progres Penyelesaian',
      'en': 'Completion Progress',
    },
    'subtasks': {'id': 'Sub-tugas', 'en': 'Sub-tasks'},
    'additionalNotes': {'id': 'Catatan Tambahan', 'en': 'Additional Notes'},
    'notesHint': {
      'id': 'Tambahkan catatan di sini...',
      'en': 'Add notes here...',
    },
    'completed': {'id': 'Selesai', 'en': 'Completed'},
    'taskCompleted': {
      'id': '🎉 Tugas selesai! Kerja bagus!',
      'en': '🎉 Task complete! Great job!',
    },
    'done': {'id': 'Selesai', 'en': 'Done'},

    // ─── Calendar ───
    'calendarFlowday': {'id': 'Kalender Flowday', 'en': 'Calendar Flowday'},
    'focusBlocks': {'id': 'blok fokus', 'en': 'focus blocks'},
    'scheduled': {'id': 'terjadwal', 'en': 'scheduled'},
    'scheduleBlock': {'id': '+ Jadwalkan Blok', 'en': '+ Schedule Block'},

    // ─── Profile & Stats ───
    'productivityStats': {
      'id': 'Statistik Produktivitas',
      'en': 'Productivity Stats',
    },
    'dailyStreak': {'id': 'Streak Harian', 'en': 'Daily Streak'},
    'virtualPlantLevel': {
      'id': 'Level Tanaman Virtual',
      'en': 'Virtual Plant Level',
    },
    'languageSettings': {'id': 'Pengaturan Bahasa', 'en': 'Language Settings'},
    'mindfulGrowth': {'id': 'Pertumbuhan Mindful', 'en': 'Mindful Growth'},
    'bloomReadiness': {'id': 'Kesiapan Mekar', 'en': 'Bloom Readiness'},
    'dayFlowStreak': {'id': 'Streak Flow Harian', 'en': 'Day Flow Streak'},
    'constantMomentum': {'id': 'Momentum konstan', 'en': 'Constant momentum'},
    'tasksRelated': {'id': 'Tugas Selesai', 'en': 'Tasks Completed'},
    'focusTime': {'id': 'Waktu Fokus', 'en': 'Focus Time'},
    'weeklyCadence': {'id': 'Irama Mingguan', 'en': 'Weekly Cadence'},
    'deepFocus': {'id': 'Fokus Mendalam', 'en': 'Deep Focus'},
    'steadyFlow': {'id': 'Alur Stabil', 'en': 'Steady Flow'},
    'chillLight': {'id': 'Santai / Ringan', 'en': 'Chill / Light'},
    'pacingHealth': {'id': 'Kesehatan Pace', 'en': 'Pacing Health'},
    'balanced': {'id': 'Seimbang', 'en': 'Balanced'},
    'openReflection': {
      'id': '📖 Buka Jurnal Refleksi',
      'en': '📖 Open Reflection Journal',
    },
    'exportDigest': {
      'id': '📤 Ekspor Ringkasan Mingguan',
      'en': '📤 Export Weekly Digest',
    },

    // ─── Days of week short ───
    'mon': {'id': 'Sen', 'en': 'Mon'},
    'tue': {'id': 'Sel', 'en': 'Tue'},
    'wed': {'id': 'Rab', 'en': 'Wed'},
    'thu': {'id': 'Kam', 'en': 'Thu'},
    'fri': {'id': 'Jum', 'en': 'Fri'},
    'sat': {'id': 'Sab', 'en': 'Sat'},
    'sun': {'id': 'Min', 'en': 'Sun'},

    // ─── Months ───
    'january': {'id': 'Januari', 'en': 'January'},
    'february': {'id': 'Februari', 'en': 'February'},
    'march': {'id': 'Maret', 'en': 'March'},
    'april': {'id': 'April', 'en': 'April'},
    'may': {'id': 'Mei', 'en': 'May'},
    'june': {'id': 'Juni', 'en': 'June'},
    'july': {'id': 'Juli', 'en': 'July'},
    'august': {'id': 'Agustus', 'en': 'August'},
    'september': {'id': 'September', 'en': 'September'},
    'october': {'id': 'Oktober', 'en': 'October'},
    'november': {'id': 'November', 'en': 'November'},
    'december': {'id': 'Desember', 'en': 'December'},

    // ─── Misc ───
    'prioritiesFlow': {'id': 'Prioritas & Alur', 'en': 'Priorities & Flow'},
    'inProgress': {'id': 'dalam progres', 'en': 'in progress'},
    'streakReached': {'id': 'streak tercapai', 'en': 'streak reached'},
    'delete': {'id': 'Hapus', 'en': 'Delete'},
    'cancel': {'id': 'Batal', 'en': 'Cancel'},
    'deleteTask': {'id': 'Hapus Tugas', 'en': 'Delete Task'},
    'deleteConfirm': {
      'id': 'Yakin ingin menghapus tugas ini?',
      'en': 'Are you sure you want to delete this task?',
    },
  };

  static String tr(String key, String locale) {
    return _translations[key]?[locale] ?? _translations[key]?['id'] ?? key;
  }

  static String greeting(String locale) {
    final hour = DateTime.now().hour;
    if (hour < 11) return tr('goodMorning', locale);
    if (hour < 15) return tr('goodAfternoon', locale);
    if (hour < 18) return tr('goodEvening', locale);
    return tr('goodNight', locale);
  }

  static String monthName(int month, String locale) {
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];
    return tr(months[month - 1], locale);
  }

  static String dayOfWeek(int weekday, String locale) {
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return tr(days[weekday - 1], locale);
  }
}
