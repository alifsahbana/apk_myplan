# TECH_STACK.md — MyPlan

**Versi:** 1.0 (rancangan awal)  
**Status:** Rekomendasi teknologi sebelum implementasi  
**Target utama:** Android  
**Dokumen terkait:** `PRD.md`, `DESIGN.md`, dan desain layar hasil Google Stitch

---

## 1. Tujuan dokumen

Dokumen ini menentukan teknologi, arsitektur, penyimpanan data, integrasi perangkat, dan aturan teknis untuk membangun MyPlan. Tujuannya agar implementasi di Antigravity konsisten dengan PRD serta desain yang sudah disepakati.

### Sumber acuan

- `PRD.md` adalah sumber utama kebutuhan fitur dan aturan produk.
- `DESIGN.md` dan mockup Google Stitch adalah sumber utama sistem visual serta tata letak.
- Dokumen ini menentukan cara teknis untuk mewujudkan keduanya.

Jika ada konflik, jangan mengubah fitur atau desain secara diam-diam. Jelaskan konflik dan ajukan keputusan sebelum melakukan perubahan besar.

## 2. Ringkasan keputusan teknologi

| Area | Pilihan | Alasan |
|---|---|---|
| Framework aplikasi | Flutter | Satu codebase Dart, cocok untuk UI custom, animasi ringan, dan aplikasi Android. |
| Bahasa | Dart | Bahasa utama untuk implementasi Flutter. |
| UI | Flutter Material 3 + komponen custom MyPlan | Komponen standar membantu aksesibilitas, sedangkan komponen custom menjaga desain MyPlan tetap konsisten. |
| Manajemen state | Riverpod (`flutter_riverpod`) | Memisahkan state/UI dari logika fitur serta memudahkan pengujian. |
| Navigasi | `go_router` | Mengelola halaman utama, detail, form, dan navigasi bertingkat. |
| Database lokal | SQLite melalui Drift (`drift`, `drift_flutter`) | Data relasional, query kalender/tugas, transaksi, migrasi skema, dan aliran data reaktif. |
| Format tanggal | `intl` | Format tanggal dan waktu dalam bahasa Indonesia secara konsisten. |
| ID data | UUID | ID stabil untuk task, occurrence, transaksi XP, dan data yang kelak dicadangkan/sinkronkan. |
| Notifikasi | `flutter_local_notifications` + `timezone` | Pengingat lokal yang terjadwal berdasarkan waktu lokal pengguna. |
| Widget Android | `home_widget` + implementasi widget native Android | Menyambungkan data Flutter dengan widget layar utama; tampilan widget tetap memerlukan kode native Android. |
| Pengaturan ringan | `shared_preferences` | Preferensi sederhana seperti tema dan opsi UI; bukan untuk data utama tugas. |
| Backup Google Drive | Google Sign-In + Google Drive API (`google_sign_in`, `googleapis`) | Mendukung alur autentikasi dan backup/restore yang dikendalikan pengguna. |
| Pengujian | `flutter_test`, unit test, widget test, integration test | Menguji logika, UI, dan alur penting aplikasi. |

**Kebijakan versi:** gunakan rilis stable Flutter/Dart dan versi package yang saling kompatibel pada saat proyek dimulai. Jangan menyalin nomor versi dari contoh lama secara membabi buta. Periksa dokumentasi package, jalankan `flutter pub get`, lalu commit `pubspec.lock`.

## 3. Platform dan batasan proyek

- Target versi pertama adalah **Android**.
- Flutter memungkinkan pengembangan ke platform lain kemudian, tetapi dukungan iOS tidak termasuk target rilis awal kecuali diputuskan secara terpisah.
- Aplikasi harus berfungsi untuk tugas, kalender, statistik, XP, level, dan streak tanpa koneksi internet.
- Jangan menambahkan backend, login wajib, analytics, iklan, atau layanan berbayar tanpa kebutuhan yang jelas di PRD.
- Hindari membuat arsitektur terlalu kompleks; gunakan pemisahan fitur dan lapisan logika yang cukup untuk menjaga kode mudah dipelihara.

## 4. Struktur arsitektur

Gunakan **feature-first architecture** dengan pemisahan presentation, domain, dan data pada fitur yang membutuhkannya.

### Lapisan

1. **Presentation:** halaman, widget UI, tema, form, state provider, loading/error/empty states.
2. **Domain:** aturan bisnis dan use case seperti menyelesaikan tugas, menghitung progres harian, menghitung streak, memberi XP, membuka badge, membuat occurrence tugas berulang, dan memproses backup.
3. **Data:** tabel Drift, DAO/query, repository, layanan notifikasi, widget bridge, serta adapter Google Drive.

Aturan perhitungan produk tidak boleh ditulis langsung di dalam widget UI. UI memanggil provider/use case, lalu repository menyimpan perubahan ke database.

### Struktur folder yang disarankan

```text
lib/
  main.dart
  app/
    app.dart
    router.dart
    app_theme.dart
  core/
    constants/
    errors/
    utils/
    widgets/
  database/
    app_database.dart
    tables/
    daos/
    migrations/
  features/
    home/
      data/
      domain/
      presentation/
    tasks/
      data/
      domain/
      presentation/
    calendar/
      data/
      domain/
      presentation/
    reminders/
      data/
      domain/
      presentation/
    gamification/
      data/
      domain/
      presentation/
    achievements/
      data/
      domain/
      presentation/
    statistics/
      data/
      domain/
      presentation/
    profile/
      presentation/
    settings/
      presentation/
    backup/
      data/
      domain/
      presentation/
    home_widget/
      data/
      domain/
  shared/
    models/
    providers/
    widgets/
test/
```

Antigravity boleh menyesuaikan struktur jika ada alasan teknis yang kuat, tetapi harus mempertahankan pemisahan logika bisnis, UI, dan penyimpanan.

## 5. Data dan database lokal

Gunakan Drift di atas SQLite sebagai sumber kebenaran lokal. Seluruh perubahan penting harus tersimpan ke database, bukan hanya ke state sementara di memori.

### Entitas/tabel konseptual

Sesuaikan nama dan bentuk tabel dengan kebutuhan implementasi, tetapi data berikut harus dapat direpresentasikan:

- **TaskList:** daftar seperti Pribadi, Kuliah, dan Belanja.
- **Category:** kategori kegiatan.
- **Task:** judul, deskripsi, tanggal/waktu, prioritas, status, daftar/kategori, createdAt, updatedAt, dan informasi arsip/penghapusan.
- **TaskOccurrence:** kejadian tugas tertentu untuk tanggal tertentu, khususnya tugas berulang. Penyelesaian kejadian hari ini tidak boleh menghapus atau menyelesaikan kejadian minggu depan.
- **Subtask:** langkah kecil milik task atau occurrence.
- **Reminder:** waktu, aturan pengingat, status aktif, serta referensi task occurrence.
- **XPTransaction:** catatan sumber XP, besaran XP, waktu perolehan, dan ID kejadian unik agar XP tidak diberikan berulang kali.
- **UserProgress:** total XP, level, streak saat ini, streak terpanjang, dan tanggal terakhir yang memenuhi syarat streak.
- **AchievementDefinition / UserAchievement:** definisi badge dan pencapaian yang sudah dibuka.
- **Reward / UserReward:** reward yang tersedia, status terkunci/terbuka, dan waktu diperoleh.
- **AppSettings:** preferensi yang perlu disimpan secara persisten.

Gunakan ID UUID dan timestamp yang konsisten. Simpan waktu sebagai nilai yang dapat diurutkan secara stabil; konversikan ke zona waktu lokal hanya untuk tampilan dan aturan kalender harian. Tugas berulang sebaiknya menghasilkan occurrence, bukan satu task yang statusnya terus di-reset tanpa riwayat.

### Integritas dan migrasi

- Semua perubahan task, occurrence, XP, dan progres yang saling terkait harus memakai transaksi database bila diperlukan.
- Setiap perubahan skema harus memiliki migration dan pengujian.
- Jangan menghapus tabel atau data lama untuk menyelesaikan masalah migrasi.
- Gunakan soft delete/tombstone atau mekanisme setara untuk data yang mungkin perlu direkonsiliasi ketika sinkronisasi ditambahkan.
- Data tugas, XP, streak, badge, serta reward harus tetap ada setelah aplikasi ditutup atau perangkat dimulai ulang.

## 6. Aturan domain penting

Aturan ini harus diimplementasikan di domain/use case dan diuji secara otomatis.

### Tugas dan occurrence

- Tugas dapat dibuat, dibaca, diperbarui, diarsipkan/dihapus, dan ditandai selesai/belum selesai.
- Perubahan status harus langsung tercermin pada Home, Tasks, Calendar, dan Statistics.
- Tugas berulang harus memiliki occurrence per tanggal/jadwal yang dapat diselesaikan secara terpisah.
- Jika pengguna membatalkan centang, UI memperbarui status penyelesaian. Sistem XP tetap mencegah pengulangan pemberian poin untuk occurrence yang sama.

### XP dan level

- Nilai rancangan awal adalah **10 XP untuk satu occurrence tugas yang berhasil diselesaikan**, kecuali PRD final menetapkan angka lain.
- XP diberikan satu kali per occurrence. Gunakan ledger `XPTransaction` dan kunci unik/event ID; jangan hanya mengandalkan tombol disable di UI.
- Jika tugas ditandai belum selesai lagi, jangan memberikan XP tambahan ketika dicentang kembali untuk occurrence yang sama.
- Total XP dan level dihitung dari data ledger/aturan domain, bukan angka hardcoded di halaman.
- Rumus level harus disimpan di satu fungsi/domain service dan ditulis dalam tes; jangan menyebarkan angka level ke berbagai widget.

### Streak

- Ambang rancangan awal: **minimal 70% dari tugas/occurrence aktif yang jatuh tempo pada tanggal lokal tersebut harus selesai** agar hari itu memenuhi syarat streak.
- Tugas yang ditambahkan pada hari yang sedang berjalan tetap masuk dalam denominator hari tersebut, sesuai keputusan produk.
- Tugas/occurrence yang benar-benar dibatalkan atau diarsipkan sebelum dihitung dapat dikecualikan sesuai aturan produk; jangan membuat pengecualian baru tanpa mendokumentasikannya.
- Hari tanpa tugas yang memenuhi syarat tidak otomatis menambah streak.
- Aturan memakai tanggal lokal pengguna dan harus menangani pergantian hari serta perubahan zona waktu secara hati-hati.
- Progres streak hari ini boleh ditampilkan sebagai sementara; streak final diperbarui dengan aturan hari yang konsisten.
- Jangan menghitung streak hanya berdasarkan jumlah XP.

### Achievement dan reward

- Pencapaian dibuka berdasarkan kondisi yang eksplisit, misalnya menyelesaikan tugas pertama, mencapai jumlah task tertentu, atau memenuhi streak selama beberapa hari.
- Satu badge hanya dibuka sekali untuk kondisi pencapaian yang sama, kecuali pencapaian memang dirancang berulang.
- Reward harus memiliki kondisi unlock/claim yang jelas. Klaim ganda tidak boleh memberi hadiah ganda.
- Tampilkan state terkunci, tersedia, dan sudah diklaim dengan jelas.

## 7. Sistem desain dan performa UI

Ikuti `DESIGN.md` dan screenshot Google Stitch terbaru.

### Token visual awal

Palet ini adalah nilai awal dan dapat disesuaikan saat mockup difinalisasi:

- Primary Sky Blue: `#42BCEB`
- Soft Blue: `#BDE9FA`
- Ice Blue background: `#F0F7FC`
- Surface: `#FFFFFF`
- Main text: `#334155`
- Orange: aksen khusus status yang bermakna, misalnya streak; bukan warna utama kedua.

### Blue gradient blur dan glassmorphism

- Implementasikan gradasi dengan `LinearGradient`/`RadialGradient` Flutter dan blur seperlunya menggunakan `BackdropFilter`.
- Gunakan blur/glass pada area tertentu: header, kartu ringkasan streak/XP/progres, dan elemen mengambang yang sesuai desain.
- Daftar tugas dan formulir harus cukup solid agar mudah dibaca.
- Jangan menerapkan blur berat ke seluruh layar atau setiap kartu; jaga performa, kontras, dan keterbacaan.
- Pastikan teks dan ikon memiliki kontras memadai; glassmorphism tidak boleh membuat informasi penting sulit dibaca.
- Komponen seperti task card, chip, progress bar, tombol, bottom navigation, dan glass card harus dibuat reusable.
- Gunakan spacing, radius, typography, dan elevasi sebagai design tokens, bukan angka acak pada setiap halaman.
- Desain dibuat responsif terhadap ukuran layar Android dan mendukung system insets/keyboard.

## 8. Kalender dan tanggal

- Gunakan `intl` untuk format tanggal/waktu berbahasa Indonesia.
- Kalender, timeline, tugas jatuh tempo, dan streak harus menggunakan definisi tanggal lokal yang sama.
- Uji pergantian tanggal, tugas berulang, pengingat lintas tengah malam, serta perubahan zona waktu yang relevan.
- Jangan menyimpan tanggal lokal dengan format teks yang tidak dapat diurutkan dan kemudian mengandalkannya untuk query.

## 9. Notifikasi dan pengingat lokal

Gunakan `flutter_local_notifications` dengan dukungan zona waktu (`timezone`).

- Minta izin notifikasi pada waktu yang relevan dan jelaskan kegunaannya kepada pengguna.
- Jadwalkan ulang pengingat jika task atau waktu pengingat diubah.
- Batalkan pengingat yang terkait ketika task dihapus, dinonaktifkan, atau waktunya berubah.
- Perhatikan izin Android untuk notifikasi dan alarm presisi. Gunakan alarm presisi hanya bila kebutuhan produk memang memerlukannya; tangani kondisi ketika izin belum diberikan.
- Pastikan pengingat tetap konsisten setelah perangkat di-restart sesuai dukungan platform dan konfigurasi yang dipakai.
- Uji di perangkat Android nyata, karena perilaku penghematan baterai dan izin dapat berbeda dari emulator.

## 10. Widget layar utama Android

Gunakan `home_widget` sebagai bridge untuk pertukaran data dan memperbarui widget; implementasi UI widget Android tetap memerlukan komponen native, misalnya Jetpack Glance atau AppWidget/RemoteViews sesuai kompatibilitas proyek.

- Widget pertama fokus pada daftar tugas hari ini, status checkbox, dan akses ke aplikasi.
- Tentukan dengan jelas tindakan yang bisa dilakukan langsung di widget dan tindakan yang membuka aplikasi.
- Widget membaca data ringkas yang disinkronkan dari aplikasi lokal; jangan membuat database tugas kedua.
- Perbarui widget setelah task ditambahkan, diselesaikan, diedit, atau tanggal berganti.
- Widget merupakan integrasi Android tersendiri dan harus dibangun serta diuji setelah alur task inti stabil.

## 11. Backup dan sinkronisasi Google Drive

Aplikasi dirancang lokal-first tetapi dengan struktur data yang siap mendukung backup/sinkronisasi.

### Tahapan yang disarankan

1. **Fondasi lokal:** semua data tersimpan di SQLite, menggunakan ID stabil, timestamp perubahan, dan skema yang bisa dimigrasikan.
2. **Backup/restore manual:** pengguna menghubungkan akun Google, lalu memilih membuat backup atau memulihkan data. Beri konfirmasi sebelum restore yang dapat mengganti data di perangkat.
3. **Sinkronisasi dua arah (jika benar-benar dibutuhkan):** bangun setelah backup/restore terbukti aman, dengan aturan konflik, tombstone, versi data, dan penanganan kegagalan jaringan yang terdokumentasi.

### Keamanan

- Jangan menanamkan client secret, API key privat, atau kredensial sensitif di source code aplikasi.
- Gunakan alur OAuth/Google Sign-In dan scope akses yang paling kecil dan sesuai kebutuhan.
- Jelaskan kapan data dikirim ke Drive dan berikan kontrol bagi pengguna.
- Backup harus mencakup data yang diperlukan untuk memulihkan tasks, task lists/categories, subtasks/occurrences, reminders, progres, transaksi XP, achievement, dan rewards.
- Validasi versi file backup dan isi data sebelum restore. Jika file tidak valid, batalkan restore tanpa merusak data yang sudah ada.
- Jangan menyebut backup manual sebagai sinkronisasi otomatis; keduanya fitur berbeda.

## 12. AI planner — batas teknis

AI planner tidak boleh menjadi alasan untuk memasukkan API key model AI secara langsung ke aplikasi mobile.

- Jika fitur AI diaktifkan, gunakan backend/proxy tepercaya untuk melindungi kredensial, atau pilih penyedia yang mendukung alur aman untuk klien.
- Untuk versi lokal-first, sediakan batas/adapter layanan agar fitur inti tidak bergantung pada AI atau internet.
- Jika belum ada keputusan mengenai penyedia, biaya, privasi, dan perilaku AI, tandai AI planner sebagai integrasi lanjutan; jangan membuat panggilan API palsu atau menampilkan tombol yang tidak bekerja.

## 13. Dependensi yang diusulkan

Periksa dokumentasi resmi dan kompatibilitas versi saat pemasangan.

### Dependensi runtime utama

- `flutter_riverpod`
- `go_router`
- `drift`
- `drift_flutter`
- `intl`
- `uuid`
- `flutter_local_notifications`
- `timezone`
- `home_widget`
- `shared_preferences`
- `google_sign_in` dan `googleapis` untuk integrasi Drive ketika tahapnya dimulai

### Dependensi development/testing

- `drift_dev`
- `build_runner`
- `flutter_lints`
- `flutter_test` (bagian dari SDK Flutter)
- `integration_test` (paket resmi Flutter untuk alur end-to-end bila diperlukan)

Jangan menambahkan library alternatif untuk state management, routing, atau database tanpa alasan. Hindari dua library yang mengerjakan peran inti yang sama.

## 14. Pengujian dan quality gates

### Unit tests

- Menambah/mengedit/menghapus tugas dan menghasilkan occurrence berulang.
- Perhitungan progres harian dan batas 70% streak.
- Tugas yang ditambahkan di tengah hari masuk dalam denominator streak.
- XP hanya diberikan satu kali per occurrence.
- Perhitungan level, achievement, dan reward.
- Zona waktu, batas hari, dan perubahan tanggal.

### Database tests

- Membaca/menulis data lokal.
- Relasi task, subtask, category/list, occurrence, reminder, dan XP transaction.
- Migrasi database dan skema backup.
- Restore backup yang valid, serta penolakan backup yang rusak.

### Widget tests

- Checklist, form tambah/edit, filter kategori/status, dan navigasi.
- State loading/empty/error bila relevan.
- Pembacaan teks/warna/kontras pada komponen penting.

### Integration tests/manual checks

- Jalur utama dari membuat task hingga mencentang selesai dan memperoleh XP.
- Kalender/timeline mencerminkan task yang sama dengan Home dan Tasks.
- Pengingat pada Android nyata.
- Widget Android membaca dan memperbarui data yang sama.
- Backup dan restore setelah tahap Drive selesai.
- Uji build APK release dan jalankan pada perangkat Android dengan ukuran layar berbeda.

Gunakan `flutter analyze` dan `flutter test` pada setiap milestone. Jangan menyatakan fitur selesai hanya karena halaman tampil; interaksi dan persistensi juga harus berjalan.

## 15. Urutan implementasi teknis

1. Periksa lingkungan Flutter/Dart dan siapkan proyek Android; jangan menghapus atau mengganti proyek yang sudah ada sebelum memeriksanya.
2. Bangun fondasi app: tema, navigasi, design tokens, komponen reusable, dan halaman dari mockup Stitch.
3. Implementasikan database Drift, repository, dan operasi task dasar.
4. Hubungkan Home, Tasks, Add/Edit Task, Calendar, Detail Task, Profile, dan Statistics ke data nyata.
5. Implementasikan tugas berulang, subtasks, filter, prioritas, dan progres.
6. Tambahkan domain gamifikasi: XP ledger, level, streak 70%, achievement, dan reward.
7. Implementasikan pengingat/notifikasi dan pengujian pada perangkat Android.
8. Implementasikan widget Android.
9. Implementasikan backup/restore Google Drive dengan penanganan error dan validasi.
10. Evaluasi integrasi AI planner sebagai tahap terpisah bila kebutuhan dan penyedia sudah diputuskan.
11. Jalankan audit kualitas, pengujian regresi, dan build APK release.

Setiap milestone harus menghasilkan aplikasi yang bisa dijalankan. Jangan membuat semua fitur sekaligus dalam satu perubahan besar.

## 16. Aturan untuk Antigravity

Sebelum coding:

1. Baca `PRD.md`, `DESIGN.md`, `TECH_STACK.md`, dan screenshot/asset Stitch yang tersedia.
2. Periksa apakah proyek Flutter sudah ada, cek struktur folder, `pubspec.yaml`, dan status build sebelum mengubahnya.
3. Buat `IMPLEMENTATION_PLAN.md` yang merinci milestone, file utama, dependensi, risiko, dan cara pengujian.
4. Identifikasi konflik/ambiguitas pada dokumen dan tulis pertanyaan atau asumsi terlebih dahulu.
5. Jangan menimpa file yang sudah ada, mengganti framework, atau menghapus data/proyek tanpa persetujuan eksplisit.
6. Bangun fitur per milestone; setelah tiap milestone, jalankan analyzer/test dan perbaiki error sebelum lanjut.
7. Jangan gunakan dummy data sebagai pengganti penyimpanan nyata untuk fitur yang diklaim sudah berfungsi. Dummy data boleh dipakai hanya untuk mockup atau development preview yang diberi label jelas.
8. Jangan mengklaim backup, notifikasi, widget, sinkronisasi, atau AI berfungsi sebelum benar-benar diimplementasikan dan diuji.
9. Pertahankan bahasa UI dalam Bahasa Indonesia, kecuali nama merek atau istilah teknis yang memang lebih baik tetap dalam bahasa Inggris.
10. Prioritaskan data pengguna dan stabilitas di atas animasi atau dekorasi.

## 17. Kriteria selesai untuk fondasi teknologi

Fondasi teknologi dapat dianggap siap ketika:

- Proyek berjalan dengan Flutter stable dan dependency berhasil di-resolve.
- Navigasi dan tema konsisten dengan desain MyPlan.
- Data task tersimpan di database lokal dan bertahan setelah aplikasi dimulai ulang.
- Domain logic tidak bergantung langsung pada widget UI.
- Tes untuk XP, streak, task berulang, dan migrasi database tersedia.
- Integrasi lanjutan mempunyai batas modul yang jelas dan tidak merusak penggunaan offline.
- `flutter analyze` dan pengujian yang relevan lulus tanpa error yang diketahui.

## 18. Referensi teknis resmi

Periksa referensi ini saat implementasi karena API dan kompatibilitas paket dapat berubah:

- Flutter supported platforms: https://docs.flutter.dev/reference/supported-platforms
- Flutter packages and plugins: https://docs.flutter.dev/packages-and-plugins/using-packages
- Flutter testing overview: https://docs.flutter.dev/testing/overview
- Drift: https://pub.dev/packages/drift
- Drift Flutter setup: https://pub.dev/packages/drift_flutter
- Riverpod: https://pub.dev/packages/flutter_riverpod
- go_router: https://pub.dev/packages/go_router
- Local notifications: https://pub.dev/packages/flutter_local_notifications
- Home screen widgets: https://pub.dev/packages/home_widget
- Google Sign-In: https://pub.dev/packages/google_sign_in

---

**Keputusan akhir:** Flutter + Dart, Riverpod, go_router, Drift/SQLite, local notifications, dan home_widget menjadi stack yang direkomendasikan untuk MyPlan. Arsitektur harus local-first dan siap dikembangkan untuk backup/sinkronisasi Google Drive. Semua integrasi kompleks dibangun setelah task management dan gamifikasi inti stabil.
