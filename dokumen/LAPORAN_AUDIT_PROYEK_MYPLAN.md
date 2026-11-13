# LAPORAN AUDIT ARSITEKTUR & RENCANA PENGEMBANGAN FITUR
# APLIKASI MYPLAN

**Nama Produk:** MyPlan  
**Repositori Proyek:** `apk_myplant`  
**Tanggal Audit:** 30 Oktober 2026  
**Status Audit:** Selesai (Menunggu Persetujuan Sebelum Tahap Implementasi)  
**Tujuan Dokumen:** Memberikan audit komprehensif terhadap kondisi source code, 5 antarmuka UI, database, gamifikasi, state management, dependensi, serta menganalisis rencana implementasi 4 fitur baru tanpa merusak fungsionalitas dan estetika yang sudah ada.

---

## DAFTAR ISI
1. [Ringkasan Eksekutif](#1-ringkasan-eksekutif)
2. [Audit Struktur Source Code & Arsitektur Aplikasi](#2-audit-struktur-source-code--arsitektur-aplikasi)
3. [Audit 5 Halaman UI yang Berjalan](#3-audit-5-halaman-ui-yang-berjalan)
4. [Audit Struktur Database SQLite (Drift) & Relasi Tabel](#4-audit-struktur-database-sqlite-drift--relasi-tabel)
5. [Audit Implementasi Tugas, Sub-tugas, XP, Streak, dan Achievement](#5-audit-implementasi-tugas-sub-tugas-xp-streak-dan-achievement)
6. [Audit State Management & Mekanisme Navigasi](#6-audit-state-management--mekanisme-navigasi)
7. [Audit Dependensi (pubspec.yaml)](#7-audit-dependensi-pubspecyaml)
8. [Analisis Empat Fitur Pengembangan Baru](#8-analisis-empat-fitur-pengembangan-baru)
   - 8.1 Custom Task Category
   - 8.2 Late Task Warning (Toleransi 30 Menit)
   - 8.3 Menambahkan Sub-tugas dari Detail Tugas
   - 8.4 Export Laporan Tugas ke TXT
9. [Matriks File yang Perlu Diubah](#9-matriks-file-yang-perlu-diubah)
10. [Analisis Risiko terhadap Fitur yang Ada](#10-analisis-risiko-terhadap-fitur-yang-ada)
11. [Rencana & Langkah Implementasi Terperinci](#11-rencana--langkah-implementasi-terperinci)
12. [Strategi Mempertahankan Estetika 5 UI Eksisting](#12-strategi-mempertahankan-estetika-5-ui-eksisting)

---

## 1. RINGKASAN EKSEKUTIF

MyPlan adalah aplikasi perencana harian dan manajemen produktivitas pribadi berbasis Flutter dengan sistem gamifikasi terintegrasi (*Streak, XP, Level, Achievement/Badge*). Aplikasi dirancang mengacu pada prinsip offline-first berbasis SQLite (Drift) dan gaya visual premium *Azure Slate / Calm Blue* sesuai mock-up Google Stitch (`ui_1_referensi` s.d. `ui_4_referensi`).

Hasil audit membuktikan bahwa:
- Seluruh fondasi P0 (CRUD tugas, gamifikasi, navigasi shell, database Drift, kalkulasi streak 70%) telah diimplementasikan dan berjalan dengan baik.
- Terdapat 5 halaman UI aktif yang konsisten secara visual: **HomeScreen**, **CalendarScreen**, **AddTaskModal**, **TaskDetailScreen**, dan **ProfileScreen**.
- Struktur database sudah memiliki tabel yang diperlukan untuk kategori (`TaskLists`), tugas (`Tasks`), dan subtugas (`Subtasks`).
- Keempat fitur baru yang diajukan (**Custom Task Category**, **Late Task Warning 30m**, **Tambah Sub-tugas dari Detail**, **Export TXT**) dapat diimplementasikan secara mulus tanpa melakukan *breaking changes* pada skema database inti maupun merusak UI yang sudah ada.

---

## 2. AUDIT STRUKTUR SOURCE CODE & ARSITEKTUR APLIKASI

### 2.1 Struktur Direktori Proyek
```text
lib/
├── core/
│   ├── app_router.dart           # Konfigurasi GoRouter dan MainShell navigasi
│   ├── design_tokens.dart        # Token warna, tipografi, dan padding
│   └── uuid_generator.dart       # Generator ID stabil untuk entitas
├── database/
│   ├── app_database.dart         # Entrypoint Drift Database (SQLite)
│   ├── app_database.g.dart       # Berkas hasil kode generator Drift
│   └── tables/                   # 10 tabel Drift individual
│       ├── task_lists_table.dart
│       ├── tasks_table.dart
│       ├── subtasks_table.dart
│       ├── task_occurrences_table.dart
│       ├── xp_transactions_table.dart
│       ├── user_progress_table.dart
│       ├── daily_records_table.dart
│       ├── achievements_table.dart
│       ├── rewards_table.dart
│       └── app_settings_table.dart
├── features/
│   ├── gamification/
│   │   └── domain/gamification_service.dart  # Logika XP, Level, Streak 70%, Badge
│   └── tasks/
│       ├── data/
│       │   ├── task_repository.dart          # CRUD Tugas ke Drift
│       │   └── task_list_repository.dart     # CRUD Kategori ke Drift
│       └── providers/
│           └── tasks_provider.dart           # Provider alternatif (belum dikonsumsi UI)
├── l10n/
│   └── app_localizations.dart    # Kamus lokalisasi (ID / EN)
├── models/
│   ├── models.dart               # TaskModel, SubTaskModel, UserModel yang digunakan UI
│   ├── task_model.dart           # Model serialisasi data Drift
│   ├── subtask_model.dart
│   └── task_list_model.dart
├── providers/
│   ├── task_provider.dart        # State management aktif utama untuk seluruh 5 UI
│   └── language_provider.dart    # State pengaturan bahasa
├── screens/
│   ├── home_screen.dart          # Layar Beranda / Hari Ini
│   ├── calendar_screen.dart      # Layar Kalender & Timeline
│   ├── add_task_modal.dart       # Modal Bottom Sheet Tambah Tugas
│   ├── task_detail_screen.dart   # Layar Rincian Tugas & Checklist Subtugas
│   └── profile_screen.dart       # Layar Profil Pengguna, Gamifikasi & Statistik
├── theme/
│   └── app_theme.dart            # Tema visual, AppColors, Material 3
├── widgets/
│   └── app_widgets.dart          # Komponen UI bersama (EnergyTagWidget, dll)
└── main.dart                     # Inisialisasi dependensi & runner aplikasi
```

### 2.2 Temuan Khusus Arsitektur
- **Dual Model:** Terdapat dua definisi `TaskModel`: satu di `lib/models/models.dart` (model UI berbasis `EnergyLevel`, `startTime`, dan `subtasks`) dan satu di `lib/models/task_model.dart` (model tabel Drift). `TaskProvider` di `lib/providers/task_provider.dart` bertindak sebagai *adapter/bridge* yang memetakan baris SQLite ke model UI `lib/models/models.dart`.
- **Konsumsi Provider:** Seluruh 5 layar UI saat ini terikat secara eksklusif ke `TaskProvider` (`lib/providers/task_provider.dart`).

---

## 3. AUDIT 5 HALAMAN UI YANG BERJALAN

| No | Halaman | Berkas Kode | Karakteristik & Status Saat Ini |
|---|---|---|---|
| 1 | **Beranda (Hari Ini)** | `lib/screens/home_screen.dart` | Ambient radial glow, personal greeting (Rani), gamification card (Streak api, Level, Badge +10 XP), progress bar 70% harian, filter chips energi, pending & completed list, FAB tambah tugas. **Status: Sangat Baik.** |
| 2 | **Kalender & Timeline** | `lib/screens/calendar_screen.dart` | Slider tanggal 14 hari horizontal, filter tugas per tanggal, timeline terurut jam (`startTime`), pemisahan tugas terjadwal vs tanpa jadwal. **Status: Sangat Baik.** |
| 3 | **Tambah Tugas (Modal)** | `lib/screens/add_task_modal.dart` | Bottom sheet draggable, input nama tugas, chip tingkat energi (Fokus Tinggi, Sedang, Santai), Date & Time picker, input catatan, dan penambahan subtugas dinamis. **Status: Sangat Baik.** |
| 4 | **Detail Tugas** | `lib/screens/task_detail_screen.dart` | Header card dengan badge status, Circular Progress Indicator (0–100%) dengan hitungan subtugas selesai/total, daftar checklist interaktif dengan coret teks, catatan teks multiline. **Status: Sangat Baik (Belum ada tombol tambah subtugas).** |
| 5 | **Profil & Statistik** | `lib/screens/profile_screen.dart` | Kartu profil gradien biru, progres level XP, 4 grid metrik (Streak, XP, Selesai, Rasio), daftar achievement interaktif (locked/unlocked), pengaturan bahasa. **Status: Sangat Baik.** |

---

## 4. AUDIT STRUKTUR DATABASE SQLITE (DRIFT) & RELASI TABEL

Database menggunakan SQLite lokal melalui Drift dengan berkas skema di `lib/database/tables/`:

1. **`TaskLists` (Kategori/Daftar):**
   - Kolom: `id` (Text PK, UUID), `name` (Text), `colorHex` (Text), `iconName` (Text, nullable), `sortOrder` (Int), `isDeleted` (Bool), `createdAt`, `updatedAt`.
2. **`Tasks` (Tugas Utama):**
   - Kolom: `id` (Text PK, UUID), `title` (Text), `description` (Text, nullable), `listId` (Text FK ke `TaskLists`), `scheduledDate` (Text ISO YYYY-MM-DD), `scheduledTime` (Text HH:mm, nullable), `priority` (low/medium/high), `isStarred` (Bool), `status` (pending/completed/cancelled), `completedAt`, `isDeleted`.
3. **`Subtasks` (Subtugas/Checklist):**
   - Kolom: `id` (Text PK, UUID), `taskId` (Text FK ke `Tasks`), `title` (Text), `isCompleted` (Bool), `sortOrder` (Int), `isDeleted` (Bool).
4. **`TaskOccurrences`:**
   - Pencatatan kejadian tugas harian untuk mendukung perulangan tanpa merusak status historis.
5. **`XpTransactions` (Buku Besar XP):**
   - Kolom: `id`, `taskId`, `xpAmount`, `reason`, `transactedAt`. Menjamin sifat idempoten (+10 XP per tugas selesai pertama kali).
6. **`UserProgress`:**
   - Kolom: `id`, `totalXp`, `currentLevel`, `currentStreak`, `bestStreak`, `lastEvaluatedDate`.
7. **`DailyRecords`:**
   - Kolom: `localDate` (PK), `eligibleTaskCount`, `completedEligibleCount`, `completionPercentage`, `targetMet` (ambang $\ge 70\%$), `streakValueAtEod`.
8. **`Achievements` & `UserAchievements`:**
   - Definisi badge standar dan relasi status unlock per pengguna.

---

## 5. AUDIT IMPLEMENTASI TUGAS, SUB-TUGAS, XP, STREAK, DAN ACHIEVEMENT

- **Penyelesaian Tugas & XP:** Dikelola oleh `GamificationService.onTaskCompleted()`. Menggunakan pengecekan ke tabel `XpTransactions`. Jika tugas sudah pernah diselesaikan, uncheck dan recheck tidak memberikan XP berulang.
- **Logika Streak (Aturan PRD FR-17):**
  - Ambang batas: $\ge 70\%$ tugas harian yang eligible.
  - Rumus target minimum: `ceil(0.70 * totalEligible)`.
  - Jika tugas hari ini 3 dan selesai 2, persentase = 66,7% (Streak belum tercapai karena butuh 3 tugas).
  - Evaluasi streak berjalan mundur memeriksa riwayat `DailyRecords` tanpa manipulasi.
- **Subtugas:** Sesuai PRD FR-04 & FR-15, subtugas saat ini tidak memberikan XP terpisah untuk mencegah eksploitasi poin. Subtugas memperbarui persentase tugas induk; jika seluruh subtugas tercentang, tugas induk otomatis tertandai selesai.

---

## 6. AUDIT STATE MANAGEMENT & MEKANISME NAVIGASI

- **State Management:**
  - `TaskProvider` terdaftar di tingkat akar (`main.dart`) sebagai `ChangeNotifierProvider`.
  - Mengelola sinkronisasi reaktif antara data memori UI dengan eksekusi query Drift SQLite secara *asynchronous*.
- **Navigasi:**
  - Menggunakan `GoRouter` dengan rute utama:
    - `/` $\rightarrow$ `HomeScreen`
    - `/calendar` $\rightarrow$ `CalendarScreen`
    - `/profile` $\rightarrow$ `ProfileScreen`
    - `/task/:id` $\rightarrow$ `TaskDetailScreen` (Push rute bertumpuk)
  - Modal tambah tugas dipicu via `showModalBottomSheet` dengan transisi mulus dan *safe-area handling*.

---

## 7. AUDIT DEPENDENSI (PUBSPEC.YAML)

| Paket | Versi | Status & Relevansi |
|---|---|---|
| `flutter` | SDK | Inti framework |
| `provider` | `^6.1.2` | State management aktif |
| `go_router` | `^14.6.2` | Deklaratif routing & shell navigation |
| `drift` & `drift_flutter` | `^2.22.0` / `^0.2.0` | ORM SQLite lokal reaktif |
| `sqlite3_flutter_libs` | `^0.5.0` | Driver SQLite lintas platform |
| `path_provider` | `^2.1.5` | **Sudah tersedia; siap digunakan untuk Export TXT** |
| `intl` | `^0.19.0` | Format kalender, jam, dan bahasa Indonesia |
| `uuid` | `^4.5.1` | ID entitas stabil |
| `shared_preferences` | `^2.3.3` | Penyimpanan preferensi ringan |
| `google_fonts` | `^6.2.1` | Tipografi Plus Jakarta Sans |

*Kesimpulan dependensi:* Tidak diperlukan paket eksternal baru untuk keempat fitur pengembangan. Seluruh pustaka sudah mencukupi.

---

## 8. ANALISIS EMPAT FITUR PENGEMBANGAN BARU

### 8.1 Custom Task Category (Kategori Tugas Kustom)
- **Kondisi:** Tabel `TaskLists` sudah memiliki skema yang tepat, namun `TaskModel` di `models.dart` belum memiliki atribut `category`/`listId`.
- **Solusi:**
  1. Tambahkan `category` (nama kategori) dan `categoryColor` pada `TaskModel`.
  2. Di `TaskProvider`, tambahkan pembacaan daftar kategori dari SQLite, serta fungsi `createCategory(String name, String colorHex)`.
  3. Pada `AddTaskModal`, sediakan pemilih chip kategori horizontal dan tombol `+ Kategori` untuk menambah kategori baru secara langsung.
  4. Tampilkan pill kategori pada kartu tugas di `HomeScreen`, `CalendarScreen`, dan `TaskDetailScreen`.

### 8.2 Early Warning (Peringatan 30 Menit Sebelum Deadline) & Fleksibilitas Pengerjaan
- **Kondisi:** Pengguna membutuhkan peringatan proaktif sebelum batas waktu berakhir agar tugas tidak terlewat, serta kepastian bahwa tugas yang terlambat tetap dapat diselesaikan.
- **Aturan Bisnis:**
  - **Peringatan Mendekati Deadline:** Jika waktu sekarang berada dalam rentang $\le$ 30 menit sebelum `scheduledDateTime` dan tugas belum selesai (`!isCompleted`), sistem memicu badge warning proaktif (*"Deadline sisa Xm • Segera kerjakan!"*).
  - **Status Terlambat:** Begitu waktu melewati `scheduledDateTime` dan tugas belum selesai, tugas langsung berstatus **Terlambat** tanpa masa toleransi.
  - **Fleksibilitas Pengerjaan:** Tugas yang terlambat **tetap aktif dan dapat diselesaikan kapan saja**. Saat dicentang setelah deadline, tugas tercatat sebagai **Selesai Terlambat** dan pengguna tetap memperoleh apresiasi XP.
- **Solusi:**
  1. Tambahkan getter `isApproachingDeadline`, `minutesUntilDeadline`, `isLate`, dan `elapsedLateMinutes` pada `TaskModel`.
  2. Tampilkan badge peringatan dini di `HomeScreen`, `CalendarScreen`, dan alert banner peringatan di `TaskDetailScreen`.
  3. Perbarui `ReportExportService` untuk mencakup ringkasan tugas mendekati deadline dan selesai terlambat.

### 8.3 Menambahkan Sub-tugas dari Detail Tugas
- **Kondisi:** Method `addSubtaskToTask(String taskId, String title)` di `TaskProvider` **sudah ada dan berfungsi ke SQLite**, tetapi `TaskDetailScreen` belum memiliki tombol atau input penambahan.
- **Solusi:**
  1. Pada `TaskDetailScreen` di bawah daftar checklist subtugas, tambahkan baris aksi:
     - Tombol `+ Tambah Sub-tugas`.
     - Ketika ditekan, muncul input inline atau dialog ringkas modern.
     - Menyimpan langsung via `context.read<TaskProvider>().addSubtaskToTask(...)`.
  2. Secara instan memperbarui *circular progress*, indikator rasio `x/y`, dan status tugas.

### 8.4 Export Laporan Tugas ke TXT
- **Kondisi:** Belum tersedia fungsi ekspor laporan produktivitas.
- **Solusi:**
  1. Buat service `ReportExportService` yang memformat ringkasan produktivitas ke dalam teks terstruktur (.txt):
     - Metadata: Tanggal cetak, Nama Pengguna, Level, Streak, Total XP.
     - Metrik: Total tugas, tugas selesai, rasio keberhasilan, tugas tertunda, tugas terlambat.
     - Daftar rinci: Dikelompokkan per tanggal dan kategori, status centang `[✓]` / `[ ]`, dan checklist subtugas.
  2. Simpan berkas TXT ke direktori dokumen lokal menggunakan `path_provider` (`getApplicationDocumentsDirectory`).
  3. Berikan tombol aksi "Ekspor Laporan (.txt)" di `ProfileScreen`.
  4. Tampilkan dialog sukses dengan pratinjau teks dan opsi salin ke clipboard (*Copy to Clipboard*).

---

## 9. MATRIKS FILE YANG PERLU DIUBAH

| File | Tipe Perubahan | Deskripsi Perubahan |
|---|---|---|
| `lib/models/models.dart` | Modifikasi | Menambahkan field `category`, `categoryColor`, serta getter `isLate` (toleransi 30 menit). |
| `lib/providers/task_provider.dart` | Modifikasi | Menghubungkan pembacaan kategori dari database, penyimpanan `listId` dinamis, fungsi tambah kategori kustom, dan sinkronisasi. |
| `lib/screens/add_task_modal.dart` | Modifikasi | Menambahkan pemilihan kategori dinamis dan dialog tambah kategori baru. |
| `lib/screens/task_detail_screen.dart` | Modifikasi | Menambahkan badge kategori, badge peringatan terlambat, dan UI tombol/input tambah subtugas. |
| `lib/screens/home_screen.dart` | Modifikasi | Menampilkan badge kategori dan badge peringatan terlambat pada baris metadata kartu tugas. |
| `lib/screens/calendar_screen.dart` | Modifikasi | Menampilkan badge peringatan terlambat pada item timeline yang belum selesai. |
| `lib/screens/profile_screen.dart` | Modifikasi | Menambahkan opsi/tombol "Ekspor Laporan (.txt)" dan dialog interaktif hasil ekspor. |
| `lib/core/services/report_export_service.dart` | File Baru | Generator teks laporan produktivitas & penulisan berkas `.txt` ke local storage. |

---

## 10. ANALISIS RISIKO TERHADAP FITUR YANG ADA

1. **Integritas Gamifikasi (XP & Streak):**
   - *Risiko:* Penambahan subtugas baru berpotensi memicu pemberian XP ganda jika tidak hati-hati.
   - *Mitigasi:* Subtugas baru dipastikan **tidak** memberi XP langsung. XP hanya diberikan satu kali ketika tugas induk tuntas melalui catatan idempoten di `XpTransactions`.
2. **Kompatibilitas Data Lama SQLite:**
   - *Risiko:* Tugas-tugas lama yang belum memiliki kategori kustom dapat menyebabkan nilai `null`.
   - *Mitigasi:* Berikan nilai bawaan (fallback) ke kategori `'Umum'` (warna `#42BCEB`) sehingga data lama tetap terbaca sempurna tanpa migrasi skema yang merusak.
3. **Risiko Regresi Estetika UI:**
   - *Risiko:* Penambahan tombol subtugas, pemilih kategori, atau badge terlambat merusak proporsi tata letak.
   - *Mitigasi:* Seluruh elemen baru mengadopsi token desain yang sudah ada di `AppTheme` (`AppColors`, border radius 12–20px, font Plus Jakarta Sans, dan padding yang proporsional).

---

## 11. RENCANA & LANGKAH IMPLEMENTASI TERPERINCI

Tahap implementasi akan dijalankan secara terstruktur setelah persetujuan:
1. **Langkah 1 (Data & Model):**
   - Memperbarui `lib/models/models.dart` dengan atribut kategori dan logika toleransi 30 menit (`isLate`).
   - Menyediakan `ReportExportService` di `lib/core/services/report_export_service.dart`.
2. **Langkah 2 (State Management):**
   - Memperbarui `TaskProvider` untuk memuat dan menyimpan kategori kustom dari tabel `TaskLists` SQLite, serta memastikan integrasi data subtugas tetap utuh.
3. **Langkah 3 (UI Enhancement - Detail & Modal):**
   - Mengimplementasikan penambahan subtugas langsung pada `TaskDetailScreen`.
   - Menambahkan pemilih kategori kustom pada `AddTaskModal`.
4. **Langkah 4 (UI Enhancement - Warning & Export):**
   - Menampilkan badge *Late Task Warning* pada `HomeScreen`, `CalendarScreen`, dan `TaskDetailScreen`.
   - Menambahkan tombol dan dialog Ekspor TXT pada `ProfileScreen`.
5. **Langkah 5 (Validasi & Pengujian):**
   - Pengujian fungsionalitas CRUD kategori, subtugas, peringatan terlambat, ekspor berkas TXT, serta kestabilan gamifikasi XP dan streak.

---

## 12. STRATEGI MEMPERTAHANKAN ESTETIKA 5 UI EKSISTING

- **HomeScreen:** Header glow, kartu streak api, circular progress 70%, filter energi, dan tombol FAB dipertahankan 100%. Peringatan terlambat hanya disematkan sebagai badge status halus di samping jam tugas.
- **CalendarScreen:** Navigasi 14 hari dan layout timeline tetap sama persis.
- **AddTaskModal:** Menjaga kebersihan layout modal bottom sheet; selector kategori diletakkan secara harmonis di antara tingkat energi dan baris tanggal/jam.
- **TaskDetailScreen:** Header card, indikator bulat progres, dan area catatan tetap konsisten. Tombol tambah subtugas dirancang menyatu secara estetis dengan daftar checklist yang ada.
- **ProfileScreen:** Gradien kartu profil, kartu level, 4 grid metrik, dan daftar achievement tetap utuh. Tombol ekspor disajikan sebagai kartu aksi sekunder yang elegan.

---

*Laporan audit ini disusun dan disahkan untuk dijadikan acuan implementasi.*  
*Status: Menunggu instruksi dan persetujuan pengguna untuk memulai penulisan kode.*
