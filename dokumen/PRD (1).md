# PRD — MyPlan

**Nama produk:** MyPlan  
**Dokumen:** Product Requirements Document (PRD)  
**Versi:** 1.0 (rancangan awal untuk validasi)  
**Tanggal:** 22 Oktober 2026  
**Platform utama:** Android  
**Status:** Spesifikasi fitur disusun; detail implementasi akan ditentukan di `TECH_STACK.md` dan `IMPLEMENTATION_PLAN.md`.

---

## 1. Ringkasan Produk

MyPlan adalah aplikasi perencana kegiatan dan pengelola tugas pribadi. Pengguna dapat membuat rencana harian, mengatur jadwal dan pengingat, mengelompokkan kegiatan, menandai tugas yang selesai, serta melihat perkembangan produktivitasnya.

MyPlan menggunakan aplikasi **Todoery: To Do List & Planner** di Google Play sebagai referensi fitur dan alur. Tujuannya adalah mencapai cakupan fitur yang sebanding, dengan nama, identitas visual, dan implementasi MyPlan sendiri. MyPlan menambahkan sistem gamifikasi yang terintegrasi: **Streak, XP, Level, Achievement/Badge, dan Reward**.

### 1.1 Visi

Membantu pengguna merencanakan hari dengan lebih teratur dan menjalankan kegiatan positif secara konsisten, melalui alat perencanaan yang praktis dan motivasi yang sehat.

### 1.2 Tagline kerja

**Plan it. Do it. Grow every day.**

Tagline dapat diubah kemudian dan bukan persyaratan fungsional.

### 1.3 Prinsip produk

1. **Mudah digunakan:** menambah atau menyelesaikan tugas harus membutuhkan langkah sesedikit mungkin.
2. **Terencana:** mendukung tugas hari ini, agenda mendatang, kalender, dan pengingat.
3. **Memotivasi, bukan menghukum:** gamifikasi memberi dorongan tanpa membuat pengguna merasa gagal berlebihan.
4. **Data tetap aman:** data lokal tetap dapat digunakan tanpa internet; fitur cloud harus memiliki proses backup dan pemulihan yang jelas.
5. **Konsisten:** XP, streak, level, statistik, dan status tugas harus mengikuti aturan bisnis yang sama.
6. **Identitas sendiri:** MyPlan boleh mengambil inspirasi fungsi dari produk referensi, tetapi tidak menyalin nama, logo, ilustrasi, teks pemasaran, atau aset visual milik aplikasi tersebut.

---

## 2. Referensi Produk

**Aplikasi referensi:** Todoery: To Do List & Planner  
**Google Play:** https://play.google.com/store/apps/details?id=todolist.scheduleplanner.dailyplanner.todo.reminders

Fitur acuan yang dijelaskan pada halaman Google Play mencakup daftar tugas, kategori, prioritas/highlight, subtask/checklist, tampilan kalender, pengingat berulang, widget harian, tema dan mode gelap, progres/statistik, backup/sinkronisasi Google Drive, AI planner, dan dukungan Wear OS.

Referensi digunakan untuk memahami cakupan fitur dan pola penggunaan. MyPlan harus mempunyai desain dan implementasi sendiri. Detail fitur yang hanya terlihat setelah instalasi atau memerlukan akun/layanan eksternal harus divalidasi pada tahap riset teknis sebelum dinyatakan selesai.

---

## 3. Target Pengguna dan Masalah

### 3.1 Target pengguna

- Pelajar dan mahasiswa yang ingin mengatur kegiatan belajar dan tugas.
- Pengguna yang ingin mengelola pekerjaan, kegiatan pribadi, olahraga, ibadah, dan kebiasaan positif.
- Pengguna yang sering lupa rencana atau kesulitan menjaga konsistensi.
- Pengguna yang termotivasi oleh progres visual, pencapaian, dan reward virtual.

### 3.2 Masalah pengguna

- Kegiatan harian tersebar di ingatan, catatan, atau banyak aplikasi.
- Pengguna kesulitan menentukan prioritas dan melihat agenda berdasarkan tanggal.
- Pengguna lupa menyelesaikan kegiatan pada waktu yang ditentukan.
- Pengguna tidak mudah melihat perkembangan produktivitas dari waktu ke waktu.
- Checklist saja kadang terasa kurang memotivasi untuk membangun konsistensi.

### 3.3 Manfaat yang diharapkan

Pengguna dapat merencanakan kegiatan dengan jelas, mengingat agenda penting, melihat apa yang telah diselesaikan, dan terdorong untuk konsisten melalui sistem gamifikasi.

---

## 4. Sasaran dan Indikator Keberhasilan

### 4.1 Sasaran produk

1. Pengguna dapat membuat dan mengelola tugas dengan cepat.
2. Pengguna dapat melihat rencana melalui daftar maupun kalender.
3. Pengguna memperoleh pengingat yang dapat diandalkan.
4. Pengguna dapat melihat progres tugas serta statistik dasar.
5. Pengguna mendapat XP dan pencapaian secara konsisten ketika menyelesaikan kegiatan.
6. Data tetap tersimpan setelah aplikasi ditutup atau perangkat dimulai ulang.
7. Aplikasi memiliki jalur pengembangan menuju backup/sinkronisasi cloud, widget Android, AI planner, dan Wear OS.

### 4.2 Indikator penerimaan awal

- Semua operasi inti tugas (buat, lihat, ubah, hapus, selesaikan) berfungsi.
- Data tugas, kategori, pengaturan, dan riwayat gamifikasi bertahan setelah aplikasi ditutup dan dibuka kembali.
- XP tidak diberikan berulang kali untuk penyelesaian kejadian tugas yang sama.
- Rumus streak memberikan hasil yang sama pada dashboard dan halaman statistik.
- Pengingat diuji pada kondisi aplikasi terbuka, latar belakang, dan setelah perangkat dimulai ulang jika platform mendukungnya.
- Proses backup dan pemulihan tidak menggandakan data serta memberi pesan yang jelas ketika gagal.
- Tidak terdapat navigasi utama yang buntu atau kontrol yang tampak aktif tetapi tidak berfungsi.

---

## 5. Ruang Lingkup

### 5.1 Fitur produk yang ditargetkan

MyPlan menargetkan fitur inti dan cakupan fitur yang sebanding dengan aplikasi referensi:

1. Pengelolaan tugas dan banyak daftar.
2. Kategori, prioritas, bintang/highlight, checklist, dan subtask.
3. Penjadwalan tugas berdasarkan tanggal dan waktu.
4. Kalender harian, mingguan, bulanan, dan agenda mendatang.
5. Pengingat/notifikasi dan tugas berulang.
6. Widget Android untuk melihat, menambah, dan mencentang tugas.
7. Statistik/progres produktivitas.
8. Tema yang dapat disesuaikan dan mode terang/gelap.
9. Backup dan sinkronisasi Google Drive.
10. AI planner untuk membantu menyusun rencana.
11. Dukungan Wear OS sebagai target kesetaraan lanjutan, jika ruang lingkup dan kemampuan teknis memungkinkan.
12. Gamifikasi MyPlan: streak, XP, level, achievement/badge, dan reward virtual.

### 5.2 Urutan pengembangan yang disarankan

**Tahap A — Fondasi wajib**
- Navigasi dan desain dasar.
- Penyimpanan lokal.
- Daftar tugas, CRUD, kategori/list, prioritas, tanggal/waktu, checklist, dan subtask.
- Dashboard hari ini dan status selesai/belum selesai.
- XP, level dasar, streak, achievement, reward virtual.

**Tahap B — Perencanaan lanjutan**
- Kalender.
- Pengingat/notifikasi.
- Tugas berulang.
- Statistik mingguan/bulanan.
- Tema dan mode gelap.

**Tahap C — Integrasi platform**
- Widget Android.
- Backup dan pemulihan Google Drive.
- Sinkronisasi lintas perangkat.
- AI planner.
- Wear OS.

Urutan ini adalah urutan kerja, bukan penghapusan fitur dari target jangka panjang. Antigravity harus meninjau kompleksitas dan dependensi sebelum implementasi tiap tahap.

### 5.3 Di luar cakupan versi awal

- Jejaring sosial, feed publik, dan mengikuti pengguna lain.
- Papan peringkat publik atau kompetisi antarpengguna.
- Pembelian uang nyata, hadiah uang, atau reward yang memiliki nilai finansial.
- Pelacakan lokasi atau pengumpulan data yang tidak diperlukan untuk fungsi perencana.
- Fitur sosial/cloud yang tidak memiliki desain autentikasi, keamanan, dan privasi yang jelas.

---

## 6. Persyaratan Fungsional

Prioritas: **P0** = wajib untuk fondasi; **P1** = target tahap berikutnya; **P2** = lanjutan/integrasi.

### FR-01 — Dashboard / Home (P0)
- Menampilkan tanggal dan ringkasan kegiatan hari ini.
- Menampilkan daftar tugas hari ini, status selesai/belum selesai, dan progres penyelesaian.
- Menampilkan streak saat ini, total XP, level, serta ringkasan misi/pencapaian yang relevan.
- Menyediakan akses cepat untuk menambah tugas.
- Menyediakan navigasi yang mudah menuju Tasks, Calendar, Achievements, dan Profile/Settings.
- Dashboard harus tetap bermakna ketika tidak ada tugas: tampilkan empty state dan ajakan membuat rencana.

### FR-02 — Membuat dan mengelola tugas (P0)
Setiap tugas minimal memiliki:
- ID unik.
- Judul wajib.
- Deskripsi opsional.
- Tanggal tugas.
- Waktu mulai/jatuh tempo opsional.
- Status selesai/belum selesai.
- Daftar/kategori.
- Prioritas.
- Penanda bintang/favorit.
- Informasi pengingat opsional.
- Informasi pengulangan opsional.
- Waktu pembuatan dan waktu perubahan.

Pengguna dapat membuat, melihat, mengedit, menyelesaikan, membatalkan status selesai, memindahkan tanggal, dan menghapus tugas. Validasi mencegah tugas tanpa judul disimpan. Aplikasi harus meminta konfirmasi untuk tindakan hapus yang berpotensi menghilangkan data penting.

### FR-03 — Daftar dan kategori (P0)
- Pengguna dapat membuat beberapa daftar, misalnya Kuliah, Pribadi, Ibadah, Olahraga, atau Belanja.
- Pengguna dapat mengganti nama, memberi warna/ikon jika didukung desain, serta menghapus daftar.
- Saat sebuah daftar dihapus, aplikasi harus menjelaskan apakah tugas ikut dihapus atau dipindahkan; pilihan aman yang disarankan adalah memberi kesempatan memindahkan tugas ke daftar lain.
- Tugas dapat difilter menurut daftar/kategori.

### FR-04 — Prioritas, bintang, checklist, dan subtask (P0/P1)
- Tugas dapat memiliki prioritas rendah, sedang, atau tinggi.
- Pengguna dapat memberi atau menghapus bintang pada tugas penting.
- Tugas dapat memiliki checklist/subtask.
- Perilaku progres subtask harus konsisten dan dijelaskan pada UI.
- Pada versi dasar, XP dan streak dihitung berdasarkan tugas induk yang memenuhi syarat, bukan setiap subtask satu per satu, untuk mencegah perhitungan ganda.

### FR-05 — Tanggal, waktu, kalender, dan navigasi tanggal (P0/P1)
- Pengguna dapat menetapkan tanggal tugas dan waktu opsional.
- Kalender menyediakan tampilan harian, mingguan, dan bulanan.
- Memilih tanggal di kalender menampilkan tugas terkait tanggal tersebut.
- Pengguna dapat berpindah ke tanggal sebelumnya/berikutnya dan kembali ke hari ini.
- Tugas tanpa waktu tetap terlihat di daftar tanggalnya.
- Statistik menggunakan zona waktu lokal perangkat untuk menentukan pergantian hari.

### FR-06 — Pengingat dan notifikasi (P1)
- Pengguna dapat mengatur satu atau lebih pengingat bila didukung implementasi.
- Notifikasi menampilkan informasi ringkas tentang tugas dan waktu yang relevan.
- Pengguna dapat mengubah atau mematikan pengingat.
- Untuk tugas berulang, pengingat mengikuti kejadian tugas yang benar.
- Aplikasi menjelaskan bila izin notifikasi tidak diberikan.
- Jadwal pengingat dijadwalkan ulang setelah perangkat dimulai ulang jika teknologi yang dipilih mendukungnya.

### FR-07 — Tugas berulang (P1)
- Mendukung pola berulang yang lazim, sekurang-kurangnya harian dan mingguan.
- Setiap tanggal berulang menghasilkan kejadian tugas tersendiri agar status dan XP tidak tercampur antarhari.
- Menyelesaikan kejadian hari ini tidak otomatis menyelesaikan kejadian di masa mendatang.
- Pengguna dapat mengubah satu kejadian atau seluruh pola berulang; UI harus menjelaskan cakupan perubahan.

### FR-08 — Statistik produktivitas (P1)
- Menampilkan jumlah tugas selesai dan belum selesai.
- Menampilkan persentase penyelesaian harian.
- Menampilkan ringkasan mingguan dan grafik berdasarkan data yang benar-benar tersimpan.
- Statistik harus menggunakan aturan hitung yang konsisten dengan dashboard dan streak.
- Hindari klaim produktivitas berlebihan; tampilkan angka dan periode secara jelas.

### FR-09 — Widget Android (P2)
- Menampilkan daftar tugas hari ini di layar utama.
- Mendukung akses cepat untuk membuka aplikasi, menambah tugas, dan/atau mencentang tugas sesuai dukungan platform.
- Perubahan di widget dan aplikasi harus tersinkron secara lokal.
- Widget menampilkan empty state bila belum ada tugas.
- Widget harus diuji terhadap pembatasan versi Android dan perilaku refresh.

### FR-10 — Tema dan tampilan (P0/P1)
- Menyediakan tema terang dan gelap.
- Menyediakan pilihan warna/tema sesuai desain yang disepakati.
- Pilihan tema tersimpan dan diterapkan konsisten pada seluruh halaman.
- Kontras, keterbacaan teks, area sentuh, dan status selesai harus tetap jelas di semua tema.

### FR-11 — Backup dan pemulihan Google Drive (P2)
- Data lokal merupakan sumber data utama untuk penggunaan offline.
- Menyediakan alur untuk menghubungkan akun Google dan meminta izin seperlunya.
- Menyediakan backup manual dan/atau terjadwal setelah kebijakan backup ditetapkan.
- Menyediakan pemulihan data dengan konfirmasi sebelum menimpa atau menggabungkan data lokal.
- Menampilkan waktu backup terakhir, status, dan pesan error yang dapat dipahami.
- Sinkronisasi lintas perangkat memerlukan identitas data, strategi konflik, serta perlindungan dari duplikasi.
- Jangan menganggap file backup di Drive otomatis sama dengan sinkronisasi real-time; keduanya harus dijelaskan sebagai perilaku terpisah jika implementasinya berbeda.

### FR-12 — AI planner (P2)
- Membantu pengguna mengubah permintaan atau tujuan menjadi usulan jadwal/tugas.
- AI harus menampilkan usulan untuk ditinjau pengguna sebelum membuat atau mengubah banyak tugas.
- Pengguna tetap memegang kendali untuk menerima, mengubah, atau menolak usulan.
- AI planner memerlukan penentuan penyedia model, biaya, koneksi internet, privasi input, dan penanganan error pada `TECH_STACK.md`.
- Jika integrasi AI belum tersedia, jangan tampilkan tombol AI palsu yang tidak bekerja; fitur dapat ditandai sebagai belum tersedia atau ditunda.

### FR-13 — Wear OS (P2)
- Menjadi target kompatibilitas lanjutan berdasarkan fitur aplikasi referensi.
- Cakupan minimum perlu divalidasi dahulu: melihat agenda, memeriksa tugas, atau sinkronisasi tugas tertentu.
- Jangan menyatakan dukungan Wear OS selesai sebelum alur perangkat dan sinkronisasinya diuji.

### FR-14 — Penyimpanan lokal dan persistensi (P0)
- Semua tugas, daftar/kategori, pengaturan penting, dan catatan gamifikasi disimpan secara lokal.
- Data bertahan saat aplikasi ditutup, dibuka kembali, atau perangkat dimulai ulang.
- Model data menyediakan ID unik dan waktu pembuatan/perubahan.
- Perhitungan XP, streak, dan pencapaian sebaiknya mencatat peristiwa agar tidak terjadi hadiah ganda.
- Struktur data harus disiapkan agar ekspor, backup, dan sinkronisasi dapat ditambahkan tanpa menulis ulang seluruh fitur inti.

### FR-15 — Gamifikasi: XP (P0)
- XP dasar rancangan awal: **10 XP untuk setiap kejadian tugas yang diselesaikan**.
- XP diberikan satu kali untuk setiap kejadian tugas yang selesai.
- Membatalkan checklist setelah XP diperoleh tidak memberikan XP baru saat dicentang kembali.
- XP yang sudah diperoleh dicatat sebagai riwayat; koreksi manual hanya dapat dilakukan lewat mekanisme internal yang terkontrol, bukan dari tombol tugas biasa.
- Subtask tidak memberikan XP terpisah di versi awal, kecuali keputusan produk berikutnya mengubah aturan.
- Penyelesaian tugas berulang memperoleh XP per kejadian yang diselesaikan.
- Jika pengguna menghapus tugas setelah menyelesaikannya, XP historis tidak dihapus otomatis.

### FR-16 — Gamifikasi: Level (P0)
- Level ditentukan oleh total XP yang terkumpul.
- Level tidak turun karena streak putus.
- Dashboard dan halaman Achievement menampilkan level serta progres menuju level berikutnya.
- Usulan kurva awal: kebutuhan XP untuk naik satu level adalah `100 + 50 × (level saat ini − 1)` XP. Contoh: dari Level 1 ke 2 memerlukan 100 XP; Level 2 ke 3 memerlukan 150 XP tambahan.
- Kurva level harus dipusatkan dalam konfigurasi agar mudah diseimbangkan tanpa mengubah banyak bagian kode.
- Nilai kurva di atas adalah nilai awal produk dan dapat disesuaikan setelah pengujian.

### FR-17 — Gamifikasi: Streak (P0)
- Streak bertambah ketika pengguna memenuhi minimal **70% target tugas harian**.
- Rumus progres: `jumlah tugas eligible yang selesai ÷ jumlah seluruh tugas eligible hari itu × 100%`.
- Syarat jumlah minimum selesai menggunakan pembulatan ke atas: `ceil(70% × jumlah tugas eligible)`.
- Contoh: 7 dari 10 tugas = 70% dan memenuhi target; 2 dari 3 tugas = 66,7% dan tidak memenuhi target karena perlu 3 tugas.
- Semua tugas yang ditetapkan untuk hari tersebut masuk perhitungan, termasuk tugas yang baru ditambahkan di tengah hari. Penambahan tugas dapat menaikkan target minimum dan UI perlu memperbarui progresnya.
- Hari dengan nol tugas eligible tidak menambah streak secara otomatis dan tidak dianggap sebagai keberhasilan target.
- Zona waktu perangkat menjadi dasar pergantian hari.
- Streak dihitung untuk satu hari kalender lokal. Ketika target terpenuhi, hari tersebut ditandai sukses; streak untuk hari berurutan dihitung berdasarkan catatan harian, bukan sekadar status dashboard saat ini.
- Untuk mengurangi manipulasi, tugas yang sudah masuk hitungan hari itu tidak boleh dihapus begitu saja untuk menurunkan denominator streak; bila dihapus, catatan historis perencanaannya tetap harus dipertahankan atau ditangani lewat kebijakan audit yang konsisten.
- Target 70% dapat dijadikan pengaturan/konstanta produk agar mudah dikalibrasi di masa depan.
- Aturan perlindungan streak (misalnya freeze/repair) belum termasuk versi awal.

### FR-18 — Gamifikasi: Achievement / Badge (P0)
Achievement awal yang disarankan:
- **First Step:** menyelesaikan satu kejadian tugas pertama.
- **7-Day Streak:** mencapai streak 7 hari.
- **Task Master:** menyelesaikan 50 kejadian tugas.
- **Perfect Day:** menyelesaikan 100% tugas eligible pada satu hari dengan setidaknya satu tugas.
- **Level Up:** mencapai level tertentu.
- **Early Planner:** membuat rencana untuk hari berikutnya atau lebih awal, jika definisi dan tracking disetujui.

Ketentuan:
- Achievement memiliki ID, nama, deskripsi, kriteria, ikon, dan status terkunci/terbuka.
- Badge yang sudah diperoleh hanya dibuka sekali.
- Achievement diperiksa saat kejadian relevan terjadi dan juga dapat direkonsiliasi saat aplikasi memuat data.
- UI menjelaskan syarat pencapaian; jangan membuat kriteria tersembunyi yang membingungkan.

### FR-19 — Gamifikasi: Reward (P0/P1)
- Reward awal berupa hadiah virtual nonfinansial: badge, gelar profil, bonus XP satu kali, atau tema kosmetik.
- Reward diberikan berdasarkan pencapaian yang jelas dan tidak memerlukan pembayaran.
- Setiap reward mempunyai ID dan riwayat klaim untuk mencegah hadiah ganda.
- Reward tidak boleh menghapus atau mengurangi XP yang sudah didapat.
- Tema terkunci hanya boleh diterapkan setelah syarat unlock terpenuhi dan harus tetap dapat digunakan setelah aplikasi dimulai ulang.
- Reward sistem ekonomi kompleks, toko berbayar, dan transaksi uang nyata berada di luar cakupan versi awal.

### FR-20 — Profile dan Settings (P0/P1)
- Menampilkan ringkasan level, total XP, streak, dan badge.
- Menyediakan pengaturan tema, notifikasi, dan preferensi yang tersedia.
- Menyediakan bagian backup/sinkronisasi ketika fitur tersebut sudah diimplementasikan.
- Menyediakan informasi versi aplikasi, kebijakan privasi, dan opsi pengelolaan data bila relevan.

---

## 7. Aturan Bisnis Gamifikasi — Ringkasan

| Kejadian | Hasil yang diharapkan |
|---|---|
| Satu kejadian tugas selesai untuk pertama kali | Tambah 10 XP dan catat kejadian penyelesaian |
| Tugas yang sama dicentang ulang setelah dibatalkan | Tidak ada XP kedua untuk kejadian tugas yang sama |
| Kejadian baru dari tugas berulang selesai | Tambah XP untuk kejadian baru tersebut |
| Total XP melewati ambang level berikutnya | Level bertambah dan progres level diperbarui |
| Target harian mencapai 70% atau lebih | Hari dicatat sukses untuk perhitungan streak |
| Target harian di bawah 70% | Hari tidak memenuhi target streak |
| Semua tugas eligible selesai | Progres 100%; periksa achievement Perfect Day |
| Syarat achievement terpenuhi | Badge terbuka satu kali dan dapat memicu reward terkait |
| Aplikasi ditutup lalu dibuka kembali | XP, level, streak, dan achievement tetap sama sesuai data yang tersimpan |

**Catatan definisi:** sebuah *kejadian tugas* adalah tugas pada tanggal terjadwal tertentu. Tugas berulang memiliki kejadian berbeda untuk setiap tanggal pelaksanaan.

---

## 8. Alur Pengguna Utama

### Alur 1 — Membuat rencana
1. Pengguna membuka Home atau Tasks.
2. Pengguna menekan tombol tambah.
3. Pengguna memasukkan judul dan detail opsional seperti tanggal, waktu, kategori, prioritas, subtask, dan pengingat.
4. Aplikasi memvalidasi lalu menyimpan tugas secara lokal.
5. Tugas muncul pada daftar dan tanggal terkait.
6. Jika tanggalnya hari ini, tugas ikut masuk target streak harian sesuai aturan.

### Alur 2 — Menyelesaikan rencana
1. Pengguna menandai tugas selesai.
2. Aplikasi mencatat waktu dan identitas kejadian penyelesaian.
3. Aplikasi memberikan XP hanya jika kejadian tersebut belum pernah memberi XP.
4. Aplikasi memperbarui progres, level, achievement, dan reward bila syarat tercapai.
5. Dashboard, daftar tugas, kalender, dan statistik menampilkan status yang konsisten.

### Alur 3 — Melihat streak
1. Dashboard menunjukkan progres target harian.
2. Saat progres mencapai sekurang-kurangnya 70%, hari ditandai sukses.
3. Sistem memperbarui streak berurutan berdasarkan tanggal lokal.
4. Pengguna dapat melihat streak saat ini dan catatan streak terbaik jika metrik tersebut diimplementasikan.

### Alur 4 — Backup dan pemulihan
1. Pengguna membuka Profile/Settings lalu bagian Backup.
2. Pengguna menghubungkan akun dan memberi izin yang diperlukan.
3. Aplikasi menjalankan backup atau pemulihan setelah menampilkan ringkasan tindakan.
4. Aplikasi menampilkan status berhasil/gagal dan waktu operasi terakhir.
5. Pemulihan tidak berjalan diam-diam jika dapat menimpa data lokal.

### Alur 5 — Menggunakan AI planner
1. Pengguna menuliskan tujuan atau kegiatan yang ingin dijadwalkan.
2. AI mengusulkan rencana.
3. Pengguna meninjau dan mengubah hasil.
4. Hanya setelah disetujui pengguna, tugas dibuat di daftar.
5. Jika koneksi atau layanan AI gagal, data tugas yang sudah ada tidak berubah.

---

## 9. Navigasi dan Halaman Utama

Susunan navigasi awal yang disarankan:

1. **Home:** ringkasan hari ini, progres, streak, XP/level, dan akses cepat tambah tugas.
2. **Tasks:** seluruh daftar tugas, filter, kategori, prioritas, checklist, dan subtask.
3. **Calendar:** tampilan agenda berdasarkan tanggal.
4. **Achievements:** level, XP, streak, badge, dan reward.
5. **Profile / Settings:** statistik, tema, notifikasi, backup, sinkronisasi, dan pengaturan lain.

Navigasi final boleh disesuaikan setelah wireframe. Gamifikasi harus tampak di Home dan memiliki halaman Achievements tersendiri; gamifikasi bukan aplikasi mini yang terpisah dari alur tugas.

---

## 10. Arahan UI/UX

- Gaya: modern, minimalis, rapi, dan terasa hidup tanpa membuat layar ramai.
- Warna referensi awal: electric indigo `#6366F1`, soft violet `#A78BFA`, cyan `#22D3EE`, background terang `#F8FAFF`, surface `#FFFFFF`, teks utama `#1E293B`.
- Warna final, tipografi, spacing, bentuk kartu, ikon, dan motion ditetapkan di `DESIGN.md`/`DESIGN_SYSTEM.md`.
- Gunakan gradasi sebagai aksen yang terarah, bukan latar gradasi pada semua elemen.
- Checklist harus mudah disentuh dan status selesai harus jelas.
- Jangan hanya mengandalkan warna untuk menjelaskan status; gunakan ikon/teks yang sesuai.
- Sediakan empty state, loading state, error state, dan konfirmasi tindakan penting.
- Hindari hukuman atau animasi yang mengganggu. Animasi level-up/reward harus singkat, dapat dilewati, dan tidak menghambat checklist.
- Desain responsif terhadap ukuran layar Android yang umum.
- Aset dan tampilan MyPlan harus dibuat sendiri; screenshot aplikasi referensi hanya menjadi bahan analisis fungsi/alur.

---

## 11. Persyaratan Nonfungsional

### NFR-01 — Kinerja
- Buka Home dan daftar tugas harus terasa responsif pada perangkat Android kelas menengah dan perangkat pengembangan yang terbatas.
- Operasi tugas biasa tidak boleh bergantung pada koneksi internet.
- Grafik dan animasi tidak boleh menghambat scrolling atau checklist.

### NFR-02 — Keandalan dan persistensi
- Data tidak boleh hilang ketika aplikasi ditutup atau perangkat dimulai ulang.
- Operasi simpan harus menangani kegagalan dengan pesan yang jelas.
- XP atau achievement tidak boleh digandakan karena retry atau proses pemuatan ulang.

### NFR-03 — Offline-first
- Semua fitur inti tugas dan gamifikasi dasar berjalan tanpa internet.
- Kebutuhan internet pada AI planner dan Google Drive dijelaskan dengan jelas.

### NFR-04 — Privasi dan keamanan
- Kumpulkan hanya data yang diperlukan untuk fungsi aplikasi.
- Jangan mengirim daftar tugas ke layanan AI tanpa tindakan/informasi yang transparan kepada pengguna.
- Kredensial dan token Google tidak boleh ditulis ke source code atau log.
- Backup perlu diberi penjelasan mengenai data yang disimpan dan akun tujuan.
- Sediakan kebijakan privasi sebelum distribusi publik.

### NFR-05 — Aksesibilitas
- Ukuran teks dapat dibaca dan mendukung pengaturan font sistem sejauh memungkinkan.
- Kontras memenuhi kebutuhan keterbacaan.
- Area sentuh tombol utama cukup besar.
- Ikon penting memiliki label aksesibilitas.

### NFR-06 — Pemeliharaan
- Pisahkan UI, logika bisnis, dan akses penyimpanan.
- Aturan XP, streak, level, dan achievement tidak tersebar di banyak widget/halaman.
- Gunakan ID stabil, data bertanggal, dan migrasi database bila skema berubah.
- Hindari menambahkan dependensi tanpa alasan dan dokumentasi.

### NFR-07 — Kompatibilitas
- Target awal Android; versi minimum Android diputuskan melalui `TECH_STACK.md` setelah memeriksa dukungan framework dan plugin.
- Widget, notifikasi, Google Drive, AI, dan Wear OS harus diuji terpisah karena masing-masing memiliki batas platform dan integrasi.

---

## 12. Model Data Konseptual

Model berikut adalah gambaran kebutuhan, bukan skema database final.

### Task
- `id`
- `title`
- `description`
- `listId` / `categoryId`
- `scheduledDate`
- `scheduledTime` (opsional)
- `priority`
- `isStarred`
- `status`
- `recurrenceRule` (opsional)
- `reminders` (opsional)
- `parentTaskId` (opsional untuk subtask)
- `createdAt`, `updatedAt`, `deletedAt` (opsional untuk soft delete)

### TaskCompletionEvent
- `id`
- `taskId`
- `occurrenceDate`
- `completedAt`
- `xpAwarded`
- `xpAwardedAt`

### DailyProductivityRecord
- `localDate`
- `eligibleTaskCount`
- `completedEligibleTaskCount`
- `completionPercentage`
- `targetMet`
- `streakValueAtEndOfDay` (bila diperlukan)

### GamificationProfile
- `totalXp`
- `currentLevel`
- `currentStreak`
- `bestStreak` (opsional)
- `lastEvaluatedLocalDate`

### AchievementDefinition / UserAchievement
- Definisi badge beserta kriteria.
- Status terkunci/terbuka dan tanggal diperoleh.

### RewardDefinition / RewardClaim
- Definisi reward, syarat, tipe hadiah, dan catatan klaim.

### TaskList / Category / AppSettings
- Daftar pengguna, kategori, tema, preferensi pengingat, dan pengaturan yang dibutuhkan.

### BackupMetadata
- ID/version backup, waktu, status operasi, dan metadata sinkronisasi yang diperlukan.

---

## 13. Kriteria Penerimaan Utama

### Tugas
- Pengguna dapat membuat tugas berjudul valid dan langsung melihatnya pada daftar yang benar.
- Perubahan judul, tanggal, kategori, dan prioritas tersimpan setelah aplikasi dibuka ulang.
- Checklist dapat diubah dan semua tampilan mencerminkan status yang sama.
- Tugas berulang menghasilkan kejadian terpisah.

### XP dan level
- Menyelesaikan satu kejadian tugas yang belum pernah selesai memberikan tepat 10 XP pada aturan awal.
- Mencentang ulang kejadian yang sama setelah dibatalkan tidak menggandakan XP.
- XP dan level tetap benar setelah aplikasi ditutup atau data dimuat ulang.
- Ketika melewati ambang level, level dan progres berikutnya dihitung dengan benar.

### Streak
- 7 dari 10 tugas eligible menghasilkan target 70% tercapai.
- 2 dari 3 tugas eligible tidak memenuhi target karena pembulatan ke atas mensyaratkan 3 tugas.
- Tugas tambahan di hari yang sama ikut masuk denominator streak.
- Hari tanpa tugas tidak otomatis menghasilkan streak.
- Perhitungan menggunakan tanggal lokal perangkat dan konsisten setelah pergantian hari.

### Achievement dan reward
- Syarat achievement yang terpenuhi membuka badge sekali saja.
- Membuka ulang halaman tidak mengulangi animasi/bonus atau menambah reward.
- Reward yang telah diklaim tetap tercatat setelah aplikasi dimulai ulang.

### Data dan integrasi
- Mode offline mendukung seluruh fungsi inti.
- Kegagalan backup memberi pesan yang jelas dan tidak menghapus sumber data lokal.
- Widget dan pengingat, saat dibuat, mencerminkan data terbaru sesuai batas refresh platform.
- AI planner meminta persetujuan sebelum menulis banyak tugas.

---

## 14. Risiko, Keputusan Terbuka, dan Mitigasi

| Risiko/pertanyaan | Mitigasi atau tindakan |
|---|---|
| Terlalu banyak fitur untuk implementasi pertama | Bangun bertahap; selesaikan fondasi dan gamifikasi lebih dulu. |
| Detail internal fitur referensi belum seluruhnya terverifikasi | Validasi dengan aplikasi terpasang, screenshot tambahan, dan uji penggunaan langsung. |
| Widget Android memerlukan integrasi platform spesifik | Pisahkan sebagai milestone teknis dan uji pada perangkat nyata. |
| Google Drive backup tidak sama dengan sinkronisasi realtime | Tetapkan perilaku secara eksplisit; implementasikan backup/pemulihan sebelum sync penuh. |
| Konflik data lintas perangkat | Rancang aturan konflik, ID stabil, timestamps, dan strategi merge sebelum rilis sinkronisasi. |
| Penyedia dan biaya AI belum dipilih | Tentukan provider, privasi prompt, kebutuhan internet, dan batas pemakaian di `TECH_STACK.md`. |
| Streak dapat dimanipulasi dengan menghapus tugas | Pertahankan histori hari berjalan atau gunakan soft delete untuk perhitungan streak. |
| XP/achievement tergandakan saat aplikasi reload | Gunakan catatan kejadian dan proses pemberian reward yang idempoten. |
| Pengguna merasa tertekan oleh gamifikasi | Gunakan bahasa positif, reward virtual, dan hindari hukuman berlebihan. |
| Perubahan OS memengaruhi izin notifikasi/widget | Uji versi Android target dan jelaskan izin yang dibutuhkan. |

Keputusan yang masih dapat dikalibrasi setelah PRD:
- Formula level yang final dan nama setiap level.
- Daftar lengkap badge dan reward.
- Apakah target streak 70% dapat disetel pengguna atau tetap menjadi aturan standar.
- Kebijakan perubahan/hapus tugas yang sudah masuk perhitungan streak.
- Mekanisme backup terjadwal dan strategi konflik sinkronisasi.
- Provider dan cakupan AI planner.
- Versi minimum Android dan framework final.

---

## 15. Rencana Pengembangan Bertahap

### Milestone 1 — Fondasi aplikasi
- Siapkan struktur project, navigasi, tema awal, dan penyimpanan lokal.
- Bangun Task CRUD, daftar/kategori, tanggal, status, prioritas, checklist, subtask.
- Siapkan unit test untuk logika tugas dan penyimpanan.

### Milestone 2 — Dashboard dan gamifikasi dasar
- Dashboard progres hari ini.
- XP dan pencatatan peristiwa penyelesaian.
- Level dan progres menuju level berikutnya.
- Perhitungan streak 70% dengan aturan target harian.
- Halaman Achievement, badge awal, dan reward virtual.
- Uji kasus batas: tugas 0, 1, 3, 10; tugas ditambah di tengah hari; tugas berulang; checklist dibatalkan.

### Milestone 3 — Kalender, pengingat, dan statistik
- Kalender harian/mingguan/bulanan.
- Pengingat/notifikasi.
- Tugas berulang.
- Statistik dan tema.

### Milestone 4 — Fitur integrasi
- Widget Android.
- Backup dan pemulihan Google Drive.
- Sinkronisasi lintas perangkat setelah backup stabil.
- AI planner setelah kebijakan privasi dan provider ditentukan.
- Wear OS jika menjadi target implementasi yang realistis.

### Milestone 5 — Pengujian dan rilis
- Uji manual tiap alur pengguna utama.
- Uji regresi aturan XP, streak, level, badge, dan reward.
- Periksa empty/error/loading states, aksesibilitas, performa, dan persistensi.
- Bangun APK untuk uji coba internal.
- Dokumentasikan batasan yang belum selesai sebelum distribusi.

---

## 16. Instruksi untuk AI Coding Agent (Antigravity)

1. Baca `PRD.md` secara menyeluruh sebelum membuat perubahan kode.
2. Jangan langsung menulis semua fitur sekaligus. Buat `IMPLEMENTATION_PLAN.md` terlebih dahulu dan uraikan milestone, file yang akan dibuat, dependensi, serta strategi pengujian.
3. Baca `DESIGN.md`/`DESIGN_SYSTEM.md` dan `TECH_STACK.md` jika tersedia. Bila ada pertentangan, jelaskan sebelum mengubah keputusan produk.
4. Periksa isi project yang sudah ada sebelum mengganti framework, struktur folder, atau dependensi. Jangan menghapus pekerjaan yang sudah ada tanpa alasan dan persetujuan.
5. Implementasikan fitur dalam unit kecil dan jalankan test/build setelah tiap milestone.
6. Pisahkan logika XP, level, streak, achievement, dan reward dari UI agar mudah diuji.
7. Jangan membuat tombol palsu. Jika integrasi belum dibuat, tampilkan status belum tersedia atau biarkan fitur itu di milestone berikutnya.
8. Gunakan data lokal sebagai dasar fitur inti dan jangan mewajibkan internet untuk checklist atau perhitungan gamifikasi.
9. Jangan menyimpan secret, token, atau API key langsung di source code.
10. Buat atau perbarui test untuk kriteria penerimaan yang ada di dokumen ini.
11. Tandai fitur sebagai selesai hanya jika implementasinya benar-benar dapat digunakan dan sudah diuji.
12. Laporkan file yang berubah, hasil test, fitur yang selesai, dan hambatan yang masih ada setelah setiap milestone.

---

## 17. Referensi

1. Google Play — Todoery: To Do List & Planner: https://play.google.com/store/apps/details?id=todolist.scheduleplanner.dailyplanner.todo.reminders (diakses 22 Oktober 2026).

---

**Akhir dokumen PRD.** Dokumen ini menjadi acuan kebutuhan produk. Rincian visual masuk ke `DESIGN.md`/`DESIGN_SYSTEM.md`, rincian framework dan integrasi masuk ke `TECH_STACK.md`, dan rincian urutan coding masuk ke `IMPLEMENTATION_PLAN.md`.
