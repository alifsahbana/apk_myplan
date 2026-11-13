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
    'navToday': {'id': 'Beranda', 'en': 'Home'},
    'navCalendar': {'id': 'Kalender', 'en': 'Calendar'},
    'navProfile': {'id': 'Profil', 'en': 'Profile'},
    'today': {'id': 'Hari Ini', 'en': 'Today'},

    // ─── Home Screen ───
    'productiveDay': {'id': 'Hari Produktif', 'en': 'Productive Day'},
    'allCategories': {'id': 'Semua Kategori', 'en': 'All Categories'},
    'allFilter': {'id': 'Semua', 'en': 'All'},
    'overdueSection': {'id': 'Terlambat', 'en': 'Overdue'},
    'todaySection': {'id': 'Hari Ini', 'en': 'Today'},
    'upcomingSection': {'id': 'Akan Datang', 'en': 'Upcoming'},
    'noTasksToday': {'id': 'Tidak ada tugas tertunda untuk hari ini', 'en': 'No pending tasks for today'},
    'completedSection': {'id': 'Selesai', 'en': 'Completed'},
    'completedLateTag': {'id': 'Selesai Terlambat', 'en': 'Completed Late'},
    'deadlineApproach': {'id': 'Deadline sisa', 'en': 'Deadline in'},
    'doNow': {'id': '• Segera kerjakan!', 'en': '• Do it now!'},
    'lateMinutes': {'id': 'Terlambat', 'en': 'Late'},

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
    'taskCategory': {'id': 'Kategori Tugas', 'en': 'Task Category'},
    'generalCategory': {'id': 'Kategori Umum', 'en': 'General'},
    'deadline': {'id': 'Deadline / Batas Waktu', 'en': 'Deadline'},
    'optional': {'id': 'Opsional...', 'en': 'Optional...'},
    'pleaseEnterTitle': {'id': 'Mohon isi nama tugas', 'en': 'Please enter a task title'},
    'newSubtaskHint': {'id': 'Nama sub-tugas baru...', 'en': 'New sub-task name...'},

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
    'completedLate': {'id': 'Selesai Terlambat', 'en': 'Completed Late'},
    'onTime': {'id': 'Tepat Waktu', 'en': 'On Time'},
    'markDone': {'id': 'Tandai Selesai', 'en': 'Mark as Done'},
    'undoCompletion': {'id': 'Batalkan Penyelesaian', 'en': 'Undo Completion'},
    'addSubtaskBtn': {'id': 'Tambah Sub-tugas', 'en': 'Add Sub-task'},
    'deadlineLabel': {'id': 'Deadline:', 'en': 'Deadline:'},
    'warningDeadlineSoon': {'id': 'menit lagi. Silakan selesaikan kegiatanmu!', 'en': 'minutes left. Please finish your activity!'},
    'warningDeadlinePassed': {'id': 'mnt lewat deadline. Anda tetap dapat menyelesaikannya sekarang.', 'en': 'min past deadline. You can still complete it now.'},
    'warningDeadlineTitle': {'id': 'Warning! Deadline kurang', 'en': 'Warning! Deadline in'},
    'warningLateTitle': {'id': 'Tugas telah melewati deadline (', 'en': 'Task is past deadline ('},

    // ─── Calendar ───
    'calendarTitle': {'id': 'Kalender & Agenda', 'en': 'Calendar & Agenda'},
    'noActivities': {'id': 'Tidak ada kegiatan', 'en': 'No activities'},
    'noAgendaYet': {'id': 'Tanggal ini belum memiliki agenda.', 'en': 'No agenda for this date yet.'},
    'allDay': {'id': 'Sepanjang hari', 'en': 'All day'},
    'onSchedule': {'id': 'JADWAL TEPAT WAKTU', 'en': 'ON SCHEDULE'},
    'allDayLabel': {'id': 'SEPANJANG HARI', 'en': 'ALL DAY'},
    'calendarFlowday': {'id': 'Kalender Flowday', 'en': 'Calendar Flowday'},
    'focusBlocks': {'id': 'blok fokus', 'en': 'focus blocks'},
    'scheduled': {'id': 'terjadwal', 'en': 'scheduled'},
    'scheduleBlock': {'id': '+ Jadwalkan Blok', 'en': '+ Schedule Block'},
    'dayNames': {'id': 'MIN,SEN,SEL,RAB,KAM,JUM,SAB', 'en': 'SUN,MON,TUE,WED,THU,FRI,SAT'},

    // ─── Profile & Stats ───
    'profileStats': {'id': 'Profil & Statistik', 'en': 'Profile & Stats'},
    'streakDays': {'id': 'hari streak', 'en': 'day streak'},
    'tasksDoneCount': {'id': 'Selesai', 'en': 'Done'},
    'highFocusTasks': {'id': 'Fokus Tinggi', 'en': 'High Focus'},
    'priorityTasks': {'id': 'tugas prioritas', 'en': 'priority tasks'},
    'chillTasks': {'id': 'Santai', 'en': 'Chill'},
    'lightTasks': {'id': 'tugas ringan', 'en': 'light tasks'},
    'achievementCollection': {'id': 'Koleksi Pencapaian', 'en': 'Achievement Collection'},
    'addBtn': {'id': 'Tambah', 'en': 'Add'},
    'settingsServices': {'id': 'Pengaturan & Layanan', 'en': 'Settings & Services'},
    'language': {'id': 'Bahasa', 'en': 'Language'},
    'languageName': {'id': 'Bahasa Indonesia', 'en': 'English'},
    'exportReport': {'id': 'Export Laporan Tugas (.txt)', 'en': 'Export Task Report (.txt)'},
    'exportReportSub': {'id': 'Simpan berkas TXT dan bagikan rekap produktivitas', 'en': 'Save TXT file and share productivity recap'},
    'aboutApp': {'id': 'Tentang MyPlan', 'en': 'About MyPlan'},
    'addCategory': {'id': 'Tambah Kategori Baru', 'en': 'Add New Category'},
    'editCategory': {'id': 'Ubah Kategori', 'en': 'Edit Category'},
    'categoryColor': {'id': 'Warna Kategori', 'en': 'Category Color'},
    'categoryName': {'id': 'Nama Kategori', 'en': 'Category Name'},
    'save': {'id': 'Simpan', 'en': 'Save'},
    'update': {'id': 'Perbarui', 'en': 'Update'},
    'close': {'id': 'Tutup', 'en': 'Close'},
    'delete': {'id': 'Hapus', 'en': 'Delete'},
    'cancel': {'id': 'Batal', 'en': 'Cancel'},
    'errCategoryEmpty': {'id': 'Nama kategori tidak boleh kosong', 'en': 'Category name cannot be empty'},
    'errCategoryExists': {'id': 'Nama kategori sudah digunakan', 'en': 'Category name already exists'},
    'copyText': {'id': 'Salin Teks', 'en': 'Copy Text'},
    'share': {'id': 'Bagikan', 'en': 'Share'},
    'copiedClipboard': {'id': 'Teks laporan berhasil disalin ke clipboard!', 'en': 'Report text copied to clipboard!'},
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
    'deleteTask': {'id': 'Hapus Tugas', 'en': 'Delete Task'},
    'deleteConfirm': {
      'id': 'Yakin ingin menghapus tugas ini?',
      'en': 'Are you sure you want to delete this task?',
    },

    // ─── Achievement names & details ───
    'achFirstStep': {'id': 'Langkah Pertama', 'en': 'First Step'},
    'ach7DayStreak': {'id': 'Streak 7 Hari', 'en': '7-Day Streak'},
    'achTaskMaster': {'id': 'Ahli Tugas', 'en': 'Task Master'},
    'achPerfectDay': {'id': 'Hari Sempurna', 'en': 'Perfect Day'},
    'unlocked': {'id': 'Terbuka', 'en': 'Unlocked'},
    'locked': {'id': 'Terkunci', 'en': 'Locked'},
    'requirement': {'id': 'Persyaratan', 'en': 'Requirement'},
    'achievementDetail': {'id': 'Detail Pencapaian', 'en': 'Achievement Details'},
    'achProgressLabel': {'id': 'Progres Target', 'en': 'Target Progress'},
    'achOverallProgress': {'id': 'Progres Koleksi', 'en': 'Collection Progress'},
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
