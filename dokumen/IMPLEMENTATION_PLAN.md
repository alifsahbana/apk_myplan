# IMPLEMENTATION_PLAN.md — MyPlan

**Versi dokumen:** 1.0  
**Status:** Rencana implementasi awal untuk Antigravity  
**Target platform:** Android  
**Dokumen acuan:** `PRD.md`, `DESIGN.md`, `TECH_STACK.md`, dan aset/screenshot Google Stitch  

---

## 1. Tujuan Dokumen

Dokumen ini membagi pembangunan MyPlan menjadi tahapan kecil yang dapat dikerjakan dan diuji satu per satu. Tujuannya agar Antigravity tidak mencoba membangun seluruh aplikasi dalam satu perubahan besar, menjaga fitur tetap sesuai PRD, dan mempertahankan desain yang telah disepakati.

Dokumen ini adalah urutan kerja yang direncanakan, bukan klaim bahwa fitur telah dibuat atau diuji.

### Sumber acuan

- `PRD.md` menentukan kebutuhan produk, fitur, aturan bisnis, prioritas, dan kriteria penerimaan.
- `DESIGN.md` menentukan struktur/layout, sistem visual, komponen, navigasi, dan pengalaman pengguna.
- `TECH_STACK.md` menentukan teknologi dan arsitektur yang diusulkan.
- Screenshot MyPlan versi hijau adalah acuan layout yang perlu dipertahankan selama masuk akal untuk fitur yang diwajibkan.
- Screenshot Google Stitch versi biru terbaru adalah acuan visual untuk blue gradient blur dan glassmorphism.

Jika ada konflik antardokumen, Antigravity harus mencatat konflik serta rekomendasi sebelum mengubah kebutuhan, teknologi, atau desain secara besar. Jangan menghilangkan fitur PRD hanya demi mempermudah UI.

---

## 2. Prinsip Pelaksanaan

1. **Periksa sebelum mengubah:** audit kondisi proyek, file, dependency, konfigurasi Android, dan status build sebelum menulis atau menghapus kode.
2. **Bangun bertahap:** setiap milestone harus menghasilkan aplikasi yang dapat dijalankan.
3. **Offline-first:** operasi tugas dan gamifikasi inti harus bekerja tanpa internet.
4. **Satu sumber kebenaran:** data tugas dan catatan gamifikasi disimpan di database lokal; UI tidak boleh menjadi satu-satunya tempat menyimpan data.
5. **Pisahkan domain dari UI:** perhitungan XP, level, streak, achievement, reward, dan recurrence harus berada di layer domain/service yang bisa diuji.
6. **Pertahankan desain yang disepakati:** struktur layout mengacu pada screenshot hijau awal, sedangkan identitas visual memakai desain Stitch biru terbaru dan `DESIGN.md`.
7. **Tidak ada kontrol palsu:** tombol atau fitur tidak boleh tampak berfungsi bila aksi sebenarnya belum diimplementasikan.
8. **Uji sebelum lanjut:** jalankan formatter, analyzer, test, dan build yang sesuai setelah setiap milestone.
9. **Jangan destruktif:** jangan mengganti framework, menghapus proyek, mereset database, atau menimpa pekerjaan yang ada tanpa persetujuan eksplisit.
10. **Laporkan status dengan jujur:** pisahkan fitur selesai, belum selesai, mockup saja, dan yang belum dapat diuji.

---

## 3. Gambaran Milestone

| Milestone | Fokus | Prioritas | Hasil utama |
|---|---|---|---|
| M0 | Audit proyek dan validasi dokumen | Wajib sebelum coding | Laporan kondisi proyek, asumsi, risiko, dan backlog yang disepakati |
| M1 | Fondasi Flutter, tema, navigasi, database | P0 | Aplikasi dapat berjalan, tema konsisten, database lokal siap |
| M2 | Fitur inti tugas dan daftar | P0 | CRUD tugas, checklist, kategori/list, prioritas, subtask, penyimpanan nyata |
| M3 | Dashboard dan gamifikasi | P0 | Home, XP, level, streak 70%, badge, reward dan profil dasar |
| M4 | Kalender dan pengelolaan waktu | P0/P1 | Kalender, timeline, recurrence dan pengingat lokal |
| M5 | Statistik, tema lengkap, penyempurnaan UX | P1 | Statistik berdasarkan data nyata, tema terang/gelap, empty/error states |
| M6 | Widget dan backup/restore Google Drive | P2 | Widget Android dan alur backup/pemulihan yang benar-benar diuji |
| M7 | Evaluasi AI planner dan Wear OS | P2 / keputusan lanjutan | Keputusan kelayakan, spesifikasi tambahan, atau implementasi terpisah |
| M8 | Audit kualitas dan build rilis internal | Wajib sebelum rilis uji | Laporan QA dan APK uji internal |

Urutan dapat disesuaikan apabila audit M0 menemukan proyek yang sudah berisi implementasi berguna. Jangan mengulang pekerjaan yang sudah ada tanpa alasan.

---

## 4. M0 — Audit Proyek dan Validasi Sebelum Coding

### Tujuan

Memahami kondisi nyata workspace sebelum Antigravity mengubah file apa pun.

### Tugas

1. Periksa apakah workspace sudah berupa proyek Flutter atau masih kosong.
2. Jika proyek sudah ada, baca `pubspec.yaml`, `lib/`, `test/`, `android/`, aset, konfigurasi, dan file dokumentasi yang relevan.
3. Periksa versi Flutter/Dart yang tersedia, target Android, dependency saat ini, dan apakah proyek berhasil dibangun.
4. Jalankan pemeriksaan non-destruktif seperti `flutter --version`, `flutter doctor`, `flutter pub get` (jika sesuai), `flutter analyze`, serta test yang sudah tersedia.
5. Pastikan tiga dokumen utama tersedia dan bisa dibaca: `PRD.md`, `DESIGN.md`, `TECH_STACK.md`.
6. Identifikasi screenshot/ekspor Google Stitch yang tersedia. Bila belum ada di workspace, minta pengguna menyalin aset ke folder `design/references/`; jangan mengarang bahwa aset telah ditemukan.
7. Periksa apakah dependency yang diusulkan kompatibel dengan Flutter/Dart stable yang terpasang. Gunakan versi kompatibel terbaru saat proyek dimulai, lalu simpan `pubspec.lock`.
8. Tulis daftar konflik, keputusan yang belum final, risiko integrasi, dan urutan pekerjaan yang disesuaikan dengan keadaan proyek.

### Gerbang kelulusan M0

- Kondisi awal proyek terdokumentasi.
- Tidak ada file atau pekerjaan yang dihapus.
- Masalah build awal dibedakan dari masalah yang muncul setelah perubahan.
- Dependensi dan batasan teknis yang diketahui dicatat.
- Antigravity memberikan ringkasan dan rekomendasi sebelum melakukan perubahan besar.

### Artefak

- Pembaruan bagian status dan catatan risiko pada dokumen rencana, bila diperlukan.
- Daftar backlog implementasi yang mengikuti milestone di bawah.

---

## 5. M1 — Fondasi Aplikasi, Design System, dan Database

### Tujuan

Membangun kerangka yang stabil sebelum mengembangkan fitur produk.

### Implementasi

1. Siapkan atau rapikan struktur proyek sesuai `TECH_STACK.md` tanpa mengganti teknologi proyek yang sudah ada secara diam-diam.
2. Konfigurasikan Flutter, Dart, Material 3, Riverpod, dan `go_router` sesuai versi yang kompatibel.
3. Implementasikan design tokens MyPlan: warna biru, latar ice-blue, warna teks, tipografi, spacing, radius, border, shadow, serta gaya ikon.
4. Buat komponen UI yang dapat dipakai ulang, misalnya tombol utama, kartu ringkasan, task row, checkbox, chip kategori, progress bar, dan empty state.
5. Terapkan blue gradient blur pada area header terpilih. Terapkan glassmorphism sebagai aksen dengan transparansi, border lembut, dan blur yang tetap mempertahankan kontras.
6. Gunakan kartu solid untuk daftar tugas dan form supaya keterbacaan tetap tinggi.
7. Bangun navigasi utama untuk Home, Tasks, Calendar, Achievements, serta Profile/Settings sesuai `DESIGN.md`.
8. Konfigurasikan Drift/SQLite, database access layer, repository, dan migrasi awal.
9. Sediakan skema data untuk daftar, kategori, tugas, subtask, pengaturan, kejadian penyelesaian, ledger XP, profil gamifikasi, achievement, reward, dan catatan progres harian sesuai model PRD.
10. Buat penyedia waktu/tanggal yang konsisten berdasarkan zona waktu lokal perangkat.

### Pengujian

- Aplikasi bisa dibuka dan menavigasi halaman utama tanpa crash.
- Token desain dan komponen reusable konsisten antarlayar.
- Database dapat dibuka, menulis, membaca, dan tetap menyimpan data setelah aplikasi dimulai ulang.
- Migrasi database awal berjalan pada instalasi baru.
- `flutter analyze` dan test yang relevan lulus.

### Gerbang kelulusan M1

Fondasi proyek stabil, tema dan navigasi utama bekerja, serta database lokal siap digunakan oleh fitur tugas. Jangan mulai semua fitur lanjutan sebelum syarat ini terpenuhi.

---

## 6. M2 — Fitur Inti To-Do List dan Pengelolaan Tugas

### Tujuan

Memastikan MyPlan benar-benar bisa digunakan sebagai aplikasi perencana harian sebelum gamifikasi ditambahkan.

### Implementasi

1. Buat operasi task: tambah, lihat, edit, selesaikan, batalkan status selesai, pindahkan tanggal, arsipkan/hapus sesuai kebijakan produk.
2. Validasi judul wajib dan tampilkan kesalahan form secara jelas.
3. Implementasikan daftar/list tugas dan kategori, termasuk pembuatan, pengubahan nama, dan pengelolaan penghapusan yang aman.
4. Implementasikan prioritas rendah/sedang/tinggi dan penanda bintang/favorit.
5. Implementasikan subtask/checklist dengan progres yang terlihat.
6. Simpan tanggal, waktu opsional, status, prioritas, kategori/list, waktu pembuatan, dan waktu perubahan pada database lokal.
7. Buat filter dan tampilan tugas: Hari Ini, Mendatang, Belum Selesai, Selesai, serta filter kategori/list.
8. Hubungkan form Add/Edit Task ke database nyata; jangan menggunakan dummy data sebagai penyimpanan untuk fitur yang disebut selesai.
9. Pertahankan tata letak yang familiar dari screenshot hijau, tetapi gunakan visual biru terbaru.
10. Tambahkan konfirmasi untuk penghapusan yang berisiko dan jelaskan konsekuensi terhadap tugas terkait.

### Pengujian fungsional

- Buat tugas dengan judul wajib dan kolom opsional.
- Edit tugas dan pastikan perubahan tersimpan.
- Tandai selesai lalu batalkan; status tetap sesuai setelah aplikasi dibuka kembali.
- Hapus atau arsipkan tugas sesuai tindakan yang dipilih.
- Buat daftar dan kategori, lalu pastikan filter menampilkan tugas yang benar.
- Uji subtask serta progresnya.
- Pastikan daftar kosong memiliki empty state dan ajakan membuat tugas.
- Pastikan operasi inti bekerja tanpa koneksi internet.

### Gerbang kelulusan M2

Semua operasi dasar tugas berfungsi dengan database lokal dan pengujian yang relevan lulus. Jangan menandai fitur CRUD selesai jika hanya UI atau data mockup yang bekerja.

---

## 7. M3 — Dashboard dan Gamifikasi Inti

### Tujuan

Menghubungkan kegiatan yang benar-benar diselesaikan dengan progres harian dan sistem gamifikasi MyPlan.

### Implementasi dashboard

- Tanggal dan sapaan.
- Daftar tugas hari ini serta status selesai/belum selesai.
- Progres penyelesaian harian.
- Ringkasan Streak, total XP, dan Level.
- Tombol tambah tugas yang mudah ditemukan.
- Ringkasan pencapaian yang relevan tanpa menjejalkan terlalu banyak kartu.

### Implementasi domain gamifikasi

Buat layanan/use case yang terpisah dari UI untuk:

1. **XP:** rancangan dasar 10 XP untuk setiap kejadian tugas yang pertama kali selesai.
2. **XP ledger:** simpan setiap transaksi XP dengan ID unik, referensi kejadian tugas, nilai, waktu, dan alasan. Beri batasan unik agar kejadian yang sama tidak memberikan XP dua kali.
3. **Level:** hitung berdasarkan total XP dan aturan ambang level yang ditetapkan PRD/implementasi. Tampilkan progres menuju level berikutnya.
4. **Streak:** hari dinyatakan memenuhi target jika tugas eligible yang selesai dibagi jumlah tugas eligible pada hari itu mencapai minimal 70%.
5. **Tugas yang ditambahkan tengah hari:** tugas baru yang dijadwalkan untuk hari berjalan tetap masuk ke denominator target hari itu, sesuai keputusan pengguna. Hitung ulang progres harian saat daftar berubah.
6. **Hari tanpa tugas eligible:** jangan otomatis meningkatkan streak; tampilkan keadaan yang masuk akal dan sesuai aturan PRD.
7. **Riwayat harian:** simpan catatan produktivitas dan peristiwa yang diperlukan agar perubahan atau penghapusan tugas di kemudian hari tidak diam-diam mengubah XP historis atau merusak streak yang sudah tercatat.
8. **Subtask:** tidak memberikan XP terpisah pada versi awal; XP berdasarkan tugas induk yang memenuhi syarat.
9. **Task berulang:** setiap kejadian pada tanggal berbeda memiliki identitas dan kelayakan XP tersendiri.
10. **Achievement/badge:** definisi pencapaian tersimpan dengan syarat yang dapat diuji; badge terbuka satu kali.
11. **Reward:** reward virtual nonfinansial, dengan riwayat klaim untuk mencegah klaim ganda.
12. **Pembatalan checklist:** bila tugas dicentang kembali setelah pembatalan, kejadian yang sama tidak memperoleh XP tambahan.

### Contoh uji untuk streak 70%

- 7 selesai dari 10 tugas eligible = 70%, hari memenuhi target.
- 2 selesai dari 3 tugas eligible = sekitar 66,7%, hari belum memenuhi target.
- 3 selesai dari 4 tugas eligible = 75%, hari memenuhi target.
- Tugas baru yang ditambahkan untuk hari berjalan ikut masuk hitungan target.
- Tidak ada tugas eligible = tidak menaikkan streak secara otomatis.

### Pengujian domain wajib

- XP diberikan satu kali untuk setiap kejadian selesai.
- Toggle selesai/belum selesai berulang tidak menghasilkan XP ganda.
- Dua transaksi dari aksi berulang tidak bisa menggandakan XP.
- Total XP, Level, streak, progres dashboard, statistik, dan badge konsisten.
- Tugas berulang pada dua hari berbeda dapat memperoleh XP secara terpisah.
- Achievement/reward yang telah diperoleh tidak diduplikasi saat data dimuat ulang.
- Uji batas target streak 69,9%, 70%, dan di atas 70% berdasarkan nilai rasio yang sebenarnya; jangan membandingkan angka tampilan yang dibulatkan.

### Gerbang kelulusan M3

Dashboard menggunakan data nyata; XP, Level, Streak, Achievement, dan Reward tersimpan serta stabil setelah aplikasi dimulai ulang; test domain gamifikasi lulus.

---

## 8. M4 — Kalender, Tugas Berulang, dan Pengingat

### Tujuan

Memberikan kemampuan perencanaan waktu setelah task CRUD dan gamifikasi inti stabil.

### Implementasi kalender dan timeline

1. Kalender bulanan dengan indikator pada tanggal yang mempunyai tugas.
2. Pilihan tanggal mengubah agenda yang ditampilkan.
3. Sediakan tampilan harian/mingguan dan timeline sesuai kapasitas desain.
4. Tambahkan navigasi tanggal sebelumnya/berikutnya dan tombol kembali ke hari ini.
5. Tampilkan tugas tanpa jam di bagian yang jelas; jangan menyembunyikannya dari agenda.
6. Pastikan penghitungan hari menggunakan zona waktu lokal perangkat.

### Implementasi tugas berulang

1. Mulai dari pola harian dan mingguan.
2. Pisahkan definisi/rule pengulangan dari kejadian tugas pada tanggal tertentu.
3. Menyelesaikan kejadian hari ini tidak menyelesaikan kejadian berikutnya.
4. Perubahan pada satu kejadian atau keseluruhan rangkaian harus memiliki pilihan dan label yang jelas.
5. Periksa dampak perubahan/penghapusan terhadap pengingat dan data historis gamifikasi.

### Implementasi notifikasi

1. Minta izin notifikasi saat diperlukan dan jelaskan manfaatnya.
2. Jadwalkan pengingat berdasarkan waktu lokal dan ID yang stabil.
3. Perbarui/batalkan pengingat saat waktu, status, atau tugas berubah.
4. Tangani izin yang ditolak, notifikasi yang tidak dapat dijadwalkan, serta pembatasan Android.
5. Jadwalkan ulang setelah perangkat dimulai ulang bila didukung konfigurasi dan plugin.
6. Jangan menampilkan fitur pengingat sebagai berfungsi sebelum uji perangkat membuktikannya.

### Pengujian

- Kalender menampilkan tugas pada tanggal yang benar.
- Tugas tanpa waktu tetap terlihat.
- Perubahan zona waktu/peralihan hari tidak menghasilkan tanggal ganda atau salah.
- Kejadian tugas berulang tersimpan terpisah.
- Notifikasi diterima pada jadwal yang ditentukan pada perangkat uji dengan izin yang sesuai.
- Mengubah atau menghapus tugas tidak meninggalkan notifikasi lama yang tidak diinginkan.

### Gerbang kelulusan M4

Kalender, recurrence, dan notifikasi lokal terhubung ke database dan lulus skenario uji utama. Catat batasan yang dipengaruhi sistem operasi.

---

## 9. M5 — Statistik, Profil, Pengaturan, dan Penyempurnaan UI

### Implementasi

1. Statistik harian, mingguan, dan bulanan berdasarkan data penyelesaian nyata.
2. Pastikan rumus statistik identik dengan rumus progres dan streak.
3. Profil menampilkan level, total XP, streak, dan pencapaian yang diperoleh.
4. Pengaturan tema terang/gelap disimpan dan berlaku konsisten.
5. Sempurnakan loading state, empty state, error state, dialog konfirmasi, dan feedback setelah aksi.
6. Lakukan pass UI atas seluruh halaman: konsistensi biru, blue blur, glassmorphism yang selektif, kontras, kepadatan teks, dan ukuran area sentuh.
7. Kurangi dekorasi jika mengganggu tugas utama; jangan menghilangkan fitur wajib hanya demi tampilan.
8. Verifikasi seluruh UI menggunakan Bahasa Indonesia sesuai keputusan PRD dan DESIGN.

### Pengujian

- Angka statistik sama dengan data yang tersimpan.
- Tidak ada statistik palsu atau nilai hard-coded yang ditampilkan sebagai data pengguna.
- Tema bertahan setelah aplikasi dimulai ulang.
- Semua halaman memiliki state kosong/error yang jelas.
- Kontras teks dan ukuran target sentuh dapat digunakan pada ukuran layar Android yang didukung.

### Gerbang kelulusan M5

Semua halaman utama konsisten dengan `DESIGN.md`, konten berasal dari data nyata, dan tidak ada tombol navigasi utama yang buntu.

---

## 10. M6 — Widget Android dan Backup/Pemulihan Google Drive

Fitur-fitur ini bersifat lebih kompleks dan harus dikembangkan sebagai milestone terpisah, bukan blocker untuk merilis versi internal dengan fitur lokal.

### Widget Android

1. Mulai dari widget ringkas berisi tugas hari ini dan statusnya.
2. Pastikan aplikasi dan widget membaca sumber data lokal yang sama atau sinkronisasi bridge yang terdefinisi.
3. Implementasikan refresh/update widget dengan batasan platform yang sesuai.
4. Tangani keadaan kosong dan tombol untuk membuka aplikasi.
5. Jangan menjanjikan semua operasi dapat dilakukan langsung dari widget sebelum interaksi native benar-benar didukung.

### Google Drive backup/restore

1. Bedakan backup file dan sinkronisasi lintas perangkat; jangan menyebut backup sebagai real-time sync.
2. Terapkan otentikasi dengan lingkup akses sekecil mungkin dan jangan menaruh token/secret di source code.
3. Definisikan format backup, versi skema, timestamp, ID stabil, dan validasi integritas.
4. Sediakan alur backup dan restore manual dengan progress, sukses, batal, dan error state.
5. Tampilkan waktu backup terakhir dan ringkasan status.
6. Saat restore, minta konfirmasi sebelum mengganti/menggabungkan data lokal.
7. Hindari duplikasi ketika file dipulihkan lebih dari sekali.
8. Uji backup gagal, restore gagal, jaringan putus, file rusak, dan versi skema tidak kompatibel.
9. Implementasikan sinkronisasi lintas perangkat hanya setelah strategi konflik dan merge data ditetapkan dengan jelas.

### Gerbang kelulusan M6

Widget dan backup/restore diuji di perangkat/akun uji. Jika salah satu bagian belum bekerja penuh, tandai sebagai belum selesai dan jelaskan batasannya.

---

## 11. M7 — AI Planner dan Wear OS

Keduanya termasuk fitur lanjutan. Jangan membuat integrasi semu atau menambah biaya/ketergantungan layanan tanpa keputusan.

### AI planner

1. Sebelum coding, tetapkan penyedia/model, persyaratan koneksi, estimasi biaya, batas penggunaan, dan kebijakan privasi input.
2. AI harus menghasilkan usulan rencana yang dapat ditinjau, diubah, diterima, atau ditolak pengguna.
3. Jangan otomatis membuat atau mengubah banyak tugas tanpa persetujuan pengguna.
4. Jangan menyimpan API key/secret di aplikasi klien.
5. Jika backend/proxy aman belum ditetapkan, jangan mengimplementasikan integrasi langsung yang mengekspos secret.
6. Jika keputusan penyedia/privasi belum selesai, dokumentasikan fitur sebagai ditunda, bukan sebagai fitur aktif.

### Wear OS

1. Validasi cakupan minimum yang benar-benar diperlukan, misalnya melihat tugas atau menandai status.
2. Tentukan strategi data dan komunikasi dengan aplikasi ponsel.
3. Buat rencana terpisah dan implementasikan hanya setelah versi Android utama stabil.

### Gerbang kelulusan M7

Fitur lanjutan hanya dinyatakan selesai jika mempunyai spesifikasi, implementasi nyata, pengujian, serta status privasi/akses yang jelas. Bila belum, catat sebagai backlog.

---

## 12. M8 — Audit QA, Regresi, dan Build Internal

### 12.1 Pengujian otomatis

- Unit test logika task, filter, progress, recurrence, XP, level, streak, badge, dan reward.
- Database test untuk insert/update/delete, relasi, query kalender, persistensi, dan migrasi.
- Widget test untuk Home, task row, form, kalender, dan halaman Achievement yang memungkinkan.
- Integration test untuk alur penting: buat tugas → selesaikan → XP berubah → progres/streak diperbarui → aplikasi ditutup/dibuka kembali.

### 12.2 Skenario manual wajib

- Instalasi bersih dan peluncuran pertama.
- Menambah, mengedit, menyelesaikan, membatalkan, mengarsipkan/menghapus tugas.
- Tugas tanpa tanggal? Jika fitur mengizinkannya, pastikan muncul di daftar yang benar; jika tidak, validasi form dengan jelas.
- Tugas tanpa waktu.
- Tugas berulang dan subtask.
- Batas streak 70% dan tugas tambahan di tengah hari.
- Mencegah XP dan reward ganda.
- Izin notifikasi diizinkan/ditolak.
- Mode terang/gelap.
- Aplikasi dibuka ulang dan perangkat dimulai ulang.
- Widget serta backup/restore jika sudah termasuk build yang diuji.

### 12.3 Kualitas dan build

1. Jalankan formatter dan `flutter analyze`.
2. Jalankan unit, widget, database, dan integration test yang sudah tersedia.
3. Perbaiki error dan regresi sebelum membuat build uji.
4. Buat APK debug/internal sesuai kebutuhan pengujian.
5. Uji pada emulator Android dan, bila tersedia, satu perangkat Android fisik.
6. Catat perangkat, versi OS, langkah uji, hasil, dan bug yang belum selesai.

### Gerbang kelulusan M8

- Build dapat dipasang dan dibuka.
- Fitur P0 yang dinyatakan selesai melewati kriteria penerimaan PRD.
- Tidak ada bug kritis yang diketahui terkait kehilangan data, perhitungan XP ganda, atau crash saat alur utama.
- Batasan P1/P2 terdokumentasi secara jujur.

---

## 13. Checklist Penerimaan per Fitur

Gunakan checklist ini sebelum mengklaim sebuah fitur selesai:

- [ ] Fitur memenuhi requirement yang relevan di `PRD.md`.
- [ ] UI mengikuti `DESIGN.md` dan memakai komponen/token konsisten.
- [ ] State loading, kosong, sukses, dan error tersedia jika relevan.
- [ ] Data yang perlu disimpan benar-benar persisten.
- [ ] Logika domain dipisahkan dari widget UI.
- [ ] Unit/database/widget/integration test yang relevan ditulis dan dijalankan.
- [ ] Tidak ada tombol palsu, data mock yang disamarkan sebagai data nyata, atau pesan sukses palsu.
- [ ] Offline behavior diperiksa untuk fitur inti.
- [ ] Aksesibilitas dan kontras dasar diperiksa.
- [ ] Ringkasan perubahan dan keterbatasan dicatat.

---

## 14. Struktur Kode yang Diharapkan

Ikuti `TECH_STACK.md`. Contoh pengelompokan berikut merupakan panduan; jangan memindahkan atau menimpa file yang sudah ada tanpa audit.

```text
lib/
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
    tasks/
    calendar/
    reminders/
    gamification/
    achievements/
    statistics/
    profile/
    settings/
    backup/
    home_widget/
  shared/
test/
```

Domain logic wajib memiliki antarmuka yang dapat diuji tanpa merender UI. Contoh: `CompleteTaskUseCase`, `AwardXpService`, `CalculateDailyProgressUseCase`, `CalculateStreakUseCase`, `EvaluateAchievementsUseCase`, dan `ClaimRewardUseCase`.

---

## 15. Aturan Khusus untuk Antigravity

Sebelum mulai coding:

1. Baca seluruh `PRD.md`, `DESIGN.md`, `TECH_STACK.md`, dan dokumen ini.
2. Audit workspace serta aset Stitch yang benar-benar tersedia.
3. Laporkan keadaan awal proyek dan dependency terlebih dahulu.
4. Konfirmasi atau tulis asumsi bagi keputusan yang belum ditetapkan; jangan diam-diam mengubah aturan bisnis.
5. Berikan ringkasan milestone pertama dan file utama yang akan dibuat/diubah.

Selama implementasi:

1. Kerjakan satu milestone pada satu waktu dan jangan lanjut ke milestone berikutnya sebelum gerbang kelulusan tercapai atau hambatan didokumentasikan.
2. Jangan menulis ulang seluruh aplikasi dalam satu prompt/perubahan besar.
3. Jangan menghapus pekerjaan pengguna, mengganti framework, atau mereset data tanpa izin eksplisit.
4. Jangan memasukkan API key, token, kredensial, atau secret ke source code.
5. Jangan mengklaim backup, notifikasi, widget, sinkronisasi, AI planner, atau Wear OS bekerja sebelum diuji.
6. Pertahankan UI dalam Bahasa Indonesia.
7. Bila membutuhkan detail dari Google Stitch yang tidak tersedia sebagai file, gunakan screenshot sebagai referensi dan tulis keterbatasan yang ada.

Setelah setiap milestone, laporkan:

- Fitur yang selesai dan cara mengujinya.
- File penting yang dibuat/diubah.
- Perintah pemeriksaan yang dijalankan beserta hasilnya.
- Fitur yang belum selesai atau masih memakai mock data.
- Risiko atau keputusan yang menunggu konfirmasi.
- Langkah berikutnya yang paling masuk akal.

---

## 16. Definition of Done untuk MyPlan

Sebuah milestone dianggap selesai jika semua syarat berikut yang relevan terpenuhi:

1. Implementasi mengikuti requirement PRD dan sistem desain.
2. Jalur pengguna utama bekerja di aplikasi yang dijalankan, bukan hanya pada mockup.
3. Data dan efek samping tersimpan dengan benar.
4. Pengujian relevan lulus; kegagalan yang belum selesai dicatat.
5. Tidak ada error analyzer/build yang diperkenalkan tanpa penjelasan.
6. Tidak ada duplikasi XP/reward atau ketidakkonsistenan antara dashboard, statistik, dan streak.
7. Status fitur dilaporkan secara jujur.

MyPlan versi awal dapat dipertimbangkan siap untuk uji internal ketika seluruh fitur P0 memenuhi kriteria penerimaan, aplikasi bisa dipasang dan dijalankan, data inti persisten, serta tidak ada masalah kritis yang diketahui. Fitur P1 dan P2 yang belum selesai harus dicatat jelas dalam daftar backlog.

---

## 17. Dokumen dan Aset yang Diharapkan di Workspace

Susunan yang disarankan:

```text
MyPlan/
  PRD.md
  DESIGN.md
  TECH_STACK.md
  IMPLEMENTATION_PLAN.md
  design/
    references/
      green_layout_reference.png
      blue_stitch_reference.png
```

Nama file screenshot hanya contoh. Gunakan nama aset yang sebenarnya tersedia di proyek. Jangan menyalin gambar jika tidak diperlukan; aset bisa disimpan di luar kode sumber dan dirujuk sebagai panduan implementasi.

---

## 18. Prinsip Akhir

**Bangun MyPlan sebagai aplikasi produktivitas yang benar-benar berfungsi, bukan sekadar mockup yang terlihat bagus.** Pertahankan layout yang disukai pengguna, ikuti aturan produk, terapkan visual biru gradient blur dan glassmorphism secara konsisten, prioritaskan data yang aman, dan selesaikan fitur secara bertahap melalui pengujian yang terukur.
