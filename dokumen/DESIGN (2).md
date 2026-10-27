# DESIGN.md — MyPlan

**Produk:** MyPlan — Personal Productivity Planner  
**Versi dokumen:** 1.1 — Design brief berdasarkan diskusi dan hasil Google Stitch terbaru  
**Platform utama:** Android mobile  
**Status:** Arah visual telah dipilih; screenshot Stitch terbaru menjadi mockup acuan untuk iterasi dan validasi, belum menjadi spesifikasi final setiap piksel.  
**Dokumen terkait:** `PRD.md`

---

## 1. Tujuan Dokumen

Dokumen ini menjelaskan bagaimana MyPlan harus terlihat dan terasa ketika digunakan. Gunakan dokumen ini bersama `PRD.md` untuk melakukan iterasi desain di Google Stitch dan sebagai acuan implementasi UI oleh Antigravity.

- `PRD.md` adalah sumber utama untuk **fitur, perilaku, aturan bisnis, dan kriteria penerimaan**.
- `DESIGN.md` adalah sumber utama untuk **tata letak, sistem visual, komponen UI, navigasi, dan pengalaman pengguna**.
- `TECH_STACK.md` nantinya menentukan teknologi serta pendekatan implementasi.

Apabila deskripsi visual bertentangan dengan kebutuhan fungsional pada PRD, pertahankan kebutuhan PRD dan sesuaikan desainnya. Jangan menghilangkan fitur yang wajib hanya agar mockup terlihat lebih sederhana.

## 2. Acuan Desain yang Harus Digunakan

Saat mengembangkan desain, gunakan tiga acuan berikut dengan peran yang berbeda.

### 2.1 Screenshot MyPlan hijau awal — acuan tata letak

Screenshot MyPlan versi hijau yang diberikan pengguna adalah **acuan utama untuk struktur dan susunan halaman**. Pertahankan karakter layout-nya sejauh masuk akal, termasuk:

- Beranda/My Day dengan sapaan, ringkasan harian, dan daftar kegiatan.
- Kalender & Timeline dengan kalender tanggal dan agenda berdasarkan waktu.
- Detail Tugas dengan informasi kegiatan, progres subtask, catatan, dan tindakan utama.
- Profil & Statistik dengan informasi profil, statistik, koleksi pencapaian, dan pengaturan.
- Pola kartu, hierarki informasi, alur penggunaan, serta navigasi yang familiar.

Jangan mempertahankan warna hijau hanya karena terdapat pada desain lama. Layout merupakan acuan; identitas warna harus diganti.

### 2.2 Screenshot Google Stitch biru terbaru — acuan visual

Screenshot biru terbaru yang dihasilkan Google Stitch merupakan **acuan suasana visual** untuk arah desain baru. Gunakan sebagai referensi bagi:

- Palet biru langit dan cyan.
- Latar biru muda dengan blue gradient blur/glow.
- Kartu terang, sudut membulat, border halus, dan bayangan lembut.
- Glassmorphism pada komponen tertentu.
- Gaya ikon, tombol, indikator progres, dan aksen visual.

Screenshot ini boleh disempurnakan. Terutama, sederhanakan label dan teks kecil yang berlebihan serta jangan biarkan semua informasi menjadi kartu yang bersaing.

### 2.3 PRD.md — acuan fitur dan perilaku

PRD.md menentukan cakupan fitur MyPlan, seperti pengelolaan tugas, kategori, prioritas, subtask, kalender, pengingat, statistik, penyimpanan lokal, backup/sinkronisasi Google Drive, serta sistem gamifikasi Streak, XP, Level, Achievement/Badge, dan Reward. Fitur lanjutan seperti widget, AI planner, dan Wear OS harus tetap diperlakukan sesuai prioritas dan kesiapan implementasi yang dijelaskan di PRD.

**Urutan prioritas jika ada konflik:**
1. Aturan dan fitur `PRD.md`.
2. Layout dari screenshot hijau awal, disesuaikan bila diperlukan agar fitur PRD dapat digunakan.
3. Arah visual dari screenshot biru terbaru dan design tokens pada dokumen ini.

---

## 3. Identitas Produk dan Arah Visual

MyPlan adalah aplikasi untuk merencanakan kegiatan sehari-hari, menjadwalkan tugas, mencentang pekerjaan yang telah selesai, serta menjaga motivasi dan konsistensi produktivitas.

**Arah visual utama: Blue Gradient Blur + Glassmorphism + Clean Productivity UI.**

Karakter desain yang ingin dicapai:
- Modern, segar, ringan, bersih, dan teratur.
- Dominan biru cerah, dengan gradasi biru muda/cyan yang lembut.
- Efek blur terlihat jelas pada area latar/header terpilih, bukan sebagai lapisan kabur di seluruh layar.
- Glassmorphism elegan sebagai aksen; bukan setiap komponen harus transparan.
- Kartu tugas dan formulir tetap terang, solid, dan mudah dibaca.
- Gamifikasi terasa menyenangkan, tetapi MyPlan tetap terlihat seperti aplikasi produktivitas, bukan game penuh.
- Teks ringkas dan hierarki visual jelas; desain jangan terlalu ramai.

Tagline kerja: **Plan it. Do it. Grow every day.** Tagline dapat diubah kemudian dan bukan persyaratan fungsional.

### Prinsip desain

1. **Pertahankan struktur yang familiar:** jangan mendesain ulang seluruh layout jika tidak diperlukan.
2. **Task-first:** kegiatan, jadwal, status, dan tombol tambah harus mudah ditemukan.
3. **Clarity over decoration:** efek blur dan kaca tidak boleh mengurangi kontras atau keterbacaan.
4. **One coherent system:** semua halaman berbagi token warna, tipografi, radius, ikon, dan pola interaksi yang konsisten.
5. **Positive motivation:** gamifikasi merayakan kemajuan tanpa mempermalukan pengguna saat target tidak tercapai.
6. **Mobile-first:** rancang untuk ponsel Android dan penggunaan satu tangan.
7. **Original identity:** referensi membantu mengarahkan desain, tetapi hasil akhir harus tetap menjadi identitas MyPlan, bukan salinan persis produk lain.

---

## 4. Sistem Visual

Nilai warna dan ukuran berikut merupakan design tokens awal berdasarkan arah visual yang disepakati. Sesuaikan sedikit jika hasil mockup membutuhkan penyempurnaan, tetapi pertahankan karakter biru, latar sejuk, dan teks yang kontras.

### 4.1 Palet warna

| Token | Hex | Fungsi |
|---|---|---|
| `brand.sky` | `#42BCEB` | Biru utama untuk tombol, progres, tab aktif, dan komponen interaktif |
| `brand.blue` | `#179FD2` | Biru pendukung untuk ikon aktif dan elemen interaksi |
| `brand.blueStrong` | `#087FA8` | Biru yang lebih pekat untuk teks/ikon pada latar terang |
| `brand.cyan` | `#64D5F2` | Sorotan cyan lembut |
| `gradient.start` | `#A8E5F8` | Awal gradasi blur |
| `gradient.middle` | `#63C8EF` | Tengah gradasi biru |
| `gradient.end` | `#D8F2FC` | Transisi gradasi menuju latar terang |
| `background` | `#F0F7FC` | Latar umum aplikasi mode terang |
| `surface` | `#FFFFFF` | Kartu tugas, formulir, dialog, dan permukaan utama |
| `surface.soft` | `#E7F4FA` | Permukaan sekunder, chip lembut, dan panel sekunder |
| `surface.blueTint` | `#DDF2FB` | Latar ikon atau komponen kecil bernuansa biru |
| `text.primary` | `#172B3A` | Judul dan teks utama |
| `text.secondary` | `#5D7484` | Deskripsi, waktu, dan metadata |
| `text.muted` | `#72899A` | Informasi sekunder yang tidak kritis |
| `border` | `#D9E8F0` | Garis tepi/pemisah halus |
| `success` | `#16865C` | Status selesai/sukses; gunakan seperlunya |
| `warning` | `#B96B12` | Peringatan atau prioritas, bila diperlukan |
| `danger` | `#C53D4B` | Error dan tindakan destruktif |
| `streak` | `#F28C45` | Aksen api/streak |
| `xp` | `#258CCB` | XP dan progres pengalaman |
| `level` | `#3478D4` | Informasi level |
| `achievement` | `#D49A24` | Badge/pencapaian |
| `reward` | `#8C70D6` | Reward virtual atau item yang dibuka |

**Aturan warna:** biru adalah warna identitas utama. Warna hijau tidak lagi menjadi warna branding; gunakan warna status selesai hanya ketika maknanya jelas. Oranye, emas, dan ungu hanyalah aksen gamifikasi, bukan warna dominan di setiap kartu.

### 4.2 Blue gradient blur / glow

Gradasi utama yang disarankan:

`linear-gradient(135deg, #A8E5F8 0%, #63C8EF 48%, #D8F2FC 100%)`

Penggunaan yang disarankan:
- Latar atau header atas pada Beranda, Kalender, dan Profil.
- Glow lembut di belakang kartu ringkasan Streak/XP/Level.
- Sorotan pada bagian terpilih dari Detail Tugas.
- Empty state atau onboarding tertentu.

Panduan penerapan:
- Glow harus berupa cahaya biru/cyan yang lembut dan melebar, bukan lingkaran bertepi keras.
- Buat transisi yang halus ke `background`; jangan menutupi seluruh isi halaman dengan gradasi pekat.
- Gunakan sekitar 1–2 area glow utama per layar, bukan banyak lapisan yang saling bersaing.
- Jangan menerapkan gradasi mencolok pada setiap kartu tugas.
- Jangan membuat teks penting ikut blur; blur hanya diterapkan pada lapisan latar.
- Untuk perangkat yang kurang bertenaga, gunakan gradasi statis yang ringan jika blur kompleks mengganggu performa.

### 4.3 Glassmorphism

Glassmorphism adalah aksen visual yang terlihat seperti kaca buram di atas latar biru blur.

Gaya yang disarankan:
- Permukaan putih dengan transparansi sekitar 72–88%, sesuai kebutuhan kontras.
- Blur latar lembut jika didukung implementasi.
- Border putih tipis/transparan sekitar 1 px.
- Bayangan lembut dengan opacity rendah.
- Radius sudut sekitar 16–24 dp.
- Teks utama gelap dan tetap memiliki kontras yang baik.

Komponen yang cocok memakai glass:
- Kartu ringkasan Streak/XP/Level.
- Kartu progres utama di Beranda.
- Panel sorotan di header atau bagian atas layar.
- Floating control atau bottom navigation, hanya jika tetap mudah dibaca.
- Popup/overlay tertentu.

Komponen yang sebaiknya tetap solid:
- Baris tugas/checklist yang padat.
- Form input, pemilih tanggal/waktu, dan detail subtask.
- Kalender yang berisi banyak informasi.
- Dialog konfirmasi penting.

Jangan membuat semua kartu transparan. Jika latar belakang mengganggu teks, tingkatkan opacity permukaan atau hilangkan efek kaca.

### 4.4 Tipografi

- Gunakan satu keluarga font sans-serif yang mudah dibaca dan tersedia baik di Android. Font sistem dapat menjadi pilihan awal; font final boleh dipastikan saat implementasi.
- Judul halaman: sekitar 24–28 sp, semibold/bold.
- Judul seksi: 18–20 sp, semibold.
- Judul tugas/kartu: 15–16 sp, medium.
- Isi utama: 14–16 sp.
- Metadata: 12–13 sp; jangan gunakan ukuran kecil untuk informasi penting.
- Angka progres, XP, dan streak boleh lebih besar sebagai fokus visual.
- Hindari all caps yang berlebihan, campuran terlalu banyak font, dan teks dekoratif yang tidak membantu pengguna.

### 4.5 Spasi, radius, dan elevasi

Gunakan skala spasi berbasis kelipatan 4 dp: `4`, `8`, `12`, `16`, `20`, `24`, `32`.

- Padding horizontal layar: sekitar 16–20 dp.
- Padding kartu: sekitar 12–16 dp.
- Jarak antarseksi: 20–24 dp.
- Jarak antarbaris tugas: 8–12 dp.
- Tombol utama: tinggi 48–54 dp, radius 14–16 dp.
- Kartu: radius 16–20 dp.
- Chip: radius pill atau 10–12 dp.
- Bottom sheet/dialog: radius sudut atas 20–24 dp.
- Gunakan bayangan tipis dan menyebar; hindari bayangan hitam yang berat.
- Target sentuh ideal minimal 48 × 48 dp.

### 4.6 Ikon dan komponen

- Gunakan ikon outline sederhana dengan ketebalan dan gaya yang konsisten.
- Bottom navigation harus memiliki ikon dan label teks.
- Gunakan makna yang konsisten: api untuk Streak, petir untuk XP, bintang/piala untuk Achievement, hadiah untuk Reward, kalender untuk agenda.
- Hindari terlalu banyak emoji atau ikon dekoratif kecil pada baris tugas.
- Hindari setiap kategori memiliki warna mencolok sendiri. Kategori dapat menggunakan label netral dengan satu aksen kecil.

---

## 5. Layout dan Navigasi

### 5.1 Prinsip layout

Struktur halaman mengikuti screenshot MyPlan hijau awal sejauh memungkinkan, dengan penyederhanaan untuk meningkatkan keterbacaan. Jangan memenuhi satu layar dengan terlalu banyak kartu atau deskripsi. Gunakan hierarki: judul halaman → informasi/progres utama → konten inti → tindakan sekunder.

### 5.2 Navigasi utama

Rancangan yang disarankan menggunakan bottom navigation dengan empat tab agar fitur penting mudah dicapai:

1. **Beranda** — ringkasan hari ini dan akses cepat ke kegiatan.
2. **Kalender** — kalender tanggal dan timeline agenda.
3. **Tugas** — semua tugas, kategori/list, filter, dan pencarian.
4. **Profil** — ringkasan profil, statistik, koleksi Achievement/Badge, pengaturan, dan backup.

Achievement dapat diakses dari kartu ringkasan di Beranda atau bagian Profil; tidak harus menjadi tab navigasi tersendiri. Halaman detail tugas dan tambah/edit tugas dibuka dari Beranda, Kalender, atau Tugas.

Jika hasil uji desain menunjukkan pola navigasi yang lebih sesuai dengan screenshot hijau awal, navigasi boleh disesuaikan selama semua fitur tetap mudah ditemukan. Tab aktif harus terlihat jelas tanpa hanya bergantung pada warna.

### 5.3 Tombol tambah kegiatan

- Tombol tambah harus mudah ditemukan di Beranda dan Tugas.
- Gunakan satu tombol utama yang jelas dalam satu area; hindari dua tombol yang bersaing.
- Floating action button boleh digunakan jika tidak menutupi daftar tugas, bottom navigation, atau konten penting.
- Setelah pengguna memilih tambah, buka form yang ringkas, dengan field opsional tersedia tanpa membuat proses tambah tugas terasa berat.

### 5.4 Responsivitas dan safe area

- Rancang untuk Android portrait dengan lebar layar kecil hingga besar.
- Hormati status bar, navigation bar, keyboard, dan safe area.
- Pastikan CTA tidak tertutup keyboard atau bottom navigation.
- Untuk layar kecil, prioritaskan scroll vertikal dan hindari mengecilkan font secara berlebihan.
- Pertahankan komposisi utama layout ketika ukuran perangkat berubah.

---

## 6. Spesifikasi Halaman

Halaman berikut harus membentuk satu aplikasi yang koheren. Gunakan data contoh berbahasa Indonesia. Jangan membuat halaman terasa seperti poster dekoratif; semua elemen harus memiliki fungsi yang jelas.

### 6.1 Beranda / My Day

**Tujuan:** pengguna langsung memahami rencana hari ini, progres, dan kegiatan berikutnya.

Struktur yang disarankan:
1. Header dengan sapaan, tanggal, ikon notifikasi bila didukung, dan blue blur gradient lembut.
2. Ringkasan Streak, Level, dan XP yang ringkas; glassmorphism boleh digunakan di sini.
3. Kartu progres harian yang menampilkan tugas selesai dari total yang dihitung serta progress bar.
4. Bagian kegiatan hari ini dengan baris tugas solid berwarna putih.
5. Setiap baris tugas menampilkan judul dan waktu; kategori/prioritas hanya bila membantu.
6. Bagian tugas selesai dapat dilipat atau dibuat lebih ringkas.
7. Tombol tambah kegiatan yang jelas.
8. Bottom navigation yang konsisten.

Aturan visual dan keadaan:
- Checklist selesai harus jelas melalui ikon/status; jangan hanya mengubah warna teks.
- Gunakan empty state sederhana saat belum ada tugas, dengan ajakan membuat rencana pertama.
- Tugas terlambat ditandai dengan bahasa netral, bukan menghakimi.
- Jangan memenuhi area awal layar dengan terlalu banyak kartu atau teks kecil.
- Angka streak mengikuti aturan PRD: streak bertambah bila target minimal 70% tugas eligible hari itu tercapai, termasuk tugas tambahan yang dimasukkan pada hari yang sama sesuai keputusan produk.

### 6.2 Kalender & Timeline

**Tujuan:** melihat agenda per tanggal dan berdasarkan waktu.

Komponen:
- Header “Kalender” dan kontrol bulan/tanggal.
- Tampilan kalender bulanan serta indikator tanggal yang memiliki tugas.
- Tanggal terpilih terlihat jelas dengan warna brand biru.
- Timeline agenda tanggal terpilih di bawah kalender.
- Setiap item agenda menampilkan waktu, judul, dan metadata penting secukupnya.
- Tombol tambah kegiatan yang menggunakan tanggal terpilih sebagai default.

Aturan:
- Bedakan hari ini, tanggal dipilih, dan tanggal yang memiliki agenda tanpa terlalu banyak warna.
- Gunakan warna brand untuk tanggal terpilih; gunakan titik/garis kecil untuk menandai agenda lain.
- Tugas tanpa waktu tetap tampil pada bagian agenda tanggalnya.
- Jika tanggal kosong, sediakan empty state dengan akses untuk menambah kegiatan.
- Timeline tidak boleh terlalu padat; kelompokkan kegiatan yang terkait bila perlu.

### 6.3 Detail Tugas

**Tujuan:** menampilkan detail kegiatan dan membantu pengguna menyelesaikan seluruh langkahnya.

Komponen:
- Tombol kembali dan judul “Detail Tugas”.
- Judul kegiatan serta label kategori/prioritas bila ada.
- Tanggal, waktu, dan pengingat.
- Ringkasan progres subtask jika kegiatan memiliki langkah-langkah.
- Daftar subtask/checklist yang mudah dicentang.
- Catatan/deskripsi.
- Tindakan utama “Tandai Selesai” atau status selesai yang sesuai.
- Tindakan sekunder seperti edit, jadwalkan ulang, pindahkan, dan hapus pada menu yang mudah ditemukan.

Aturan:
- Pertahankan hierarki pada screenshot hijau awal: informasi tugas → progres → langkah-langkah → catatan → tindakan utama.
- Gunakan kartu putih solid untuk subtask agar status mudah dibaca.
- Blue blur boleh muncul di bagian header atau satu kartu ringkasan, bukan di belakang seluruh teks.
- Tombol utama biru dan jelas; jangan membuat tombol sekunder sama dominannya.

### 6.4 Tugas / Tasks List

**Tujuan:** mengelola semua tugas secara cepat.

Komponen:
- Header “Tugas” dan tombol tambah.
- Pencarian.
- Filter seperti Semua, Hari Ini, Mendatang, Terjadwal, dan Selesai.
- Daftar kategori/list bila digunakan.
- Baris tugas dengan checkbox, judul, waktu/tanggal, dan metadata seperlunya.
- Menu tindakan untuk edit, pindahkan, dan hapus.

Aturan:
- Satu baris tugas harus dapat dipindai dengan cepat.
- Jangan tampilkan semua metadata sekaligus jika membuat daftar terlalu ramai.
- Ketuk baris membuka Detail Tugas; checkbox menandai selesai tanpa harus membuka detail.
- Tampilkan empty state dan hasil pencarian kosong.

### 6.5 Tambah/Edit Kegiatan

Gunakan halaman form atau bottom sheet yang lapang dan mudah discan. Pertahankan susunan field dari desain lama bila praktis.

Field:
- Judul kegiatan (wajib).
- Catatan/deskripsi (opsional).
- Tanggal dan waktu.
- Kategori/list.
- Prioritas dan bintang/favorit.
- Pengingat.
- Pengulangan.
- Subtask/checklist bila diperlukan.

Aturan:
- Pengguna boleh menyimpan tugas sederhana hanya dengan mengisi judul dan menambahkan detail lain kemudian.
- Field dikelompokkan secara logis dan tidak semuanya diberi kartu dekoratif.
- Tombol “Simpan Rencana”/“Simpan Kegiatan” adalah CTA utama dan mudah dijangkau.
- Pesan validasi muncul dekat field yang bermasalah.
- Saat mengedit, form harus memuat nilai yang sudah tersimpan.

### 6.6 Profil & Statistik

**Tujuan:** menampilkan identitas pengguna, ringkasan kemajuan, pencapaian, serta pengaturan.

Struktur yang disarankan:
1. Header profil dan nama pengguna.
2. Ringkasan Level, XP, Streak, atau statistik utama dalam beberapa kartu ringkas.
3. Grafik aktivitas mingguan dengan label yang mudah dibaca.
4. Koleksi Achievement/Badge dengan status diperoleh/terkunci.
5. Ringkasan Reward virtual yang telah dibuka.
6. Menu pengaturan: notifikasi, tema, backup/sinkronisasi, bantuan, dan informasi aplikasi.

Aturan:
- Pertahankan gagasan layout Profil & Statistik dari desain hijau, tetapi rapikan informasi dan kurangi kartu yang berulang.
- Grafik sederhana, minim dekorasi, dan memiliki label.
- Badge boleh menggunakan aksen warna berbeda sesuai makna, tetapi palet keseluruhan tetap biru.
- Jangan sertakan koleksi atau mekanisme seperti tanaman yang bukan bagian dari PRD, kecuali nanti disepakati sebagai fitur MyPlan.

### 6.7 Achievement, Streak, XP, Level, dan Reward

Gamifikasi harus menyatu dengan pengalaman produktivitas dan dapat dilihat melalui ringkasan Beranda serta bagian Profil/Achievement.

- **Streak:** tampilkan jumlah hari konsisten dan progres target harian secara ringkas; ikon api boleh memakai aksen oranye.
- **XP:** tampilkan total XP dan progres menuju level berikutnya.
- **Level:** tampilkan level pengguna dengan hierarki jelas tetapi tidak memenuhi seluruh halaman.
- **Achievement/Badge:** tampilkan grid kartu badge dengan ikon, nama, kondisi pencapaian, dan status terkunci/terbuka.
- **Reward:** tampilkan koleksi hadiah virtual yang diperoleh serta syarat membuka item berikutnya bila fitur ini tersedia.
- Feedback pencapaian harus positif, singkat, dan tidak mengganggu alur menyelesaikan tugas.

Aturan angka dan perhitungan harus mengikuti PRD. DESIGN.md hanya menentukan penyajian visual; dokumen ini tidak mengganti aturan bisnis pada PRD.

### 6.8 Settings, Backup, AI Planner, dan fitur lanjutan

- **Settings:** kelompokkan preferensi dengan judul seksi yang jelas; hindari satu kartu terpisah untuk setiap baris menu.
- **Tema:** sediakan mode terang/gelap sesuai cakupan PRD. Versi mockup pertama boleh berfokus pada mode terang.
- **Backup/Restore:** tunjukkan status, waktu backup terakhir jika ada, tindakan Backup/Restore, serta status loading, berhasil, gagal, dan offline.
- **AI Planner:** jika dirancang, pengguna harus dapat meninjau dan mengubah saran AI sebelum rencana disimpan. Jangan mengarang tindakan otomatis tanpa konfirmasi.
- **Widget Android/Wear OS:** bukan fokus utama layar aplikasi, tetapi pola task row, checkbox, dan warna harus dapat diadaptasi pada ukuran kecil.
- Fitur yang belum tersedia secara teknis jangan ditampilkan sebagai tombol palsu yang seolah-olah berfungsi.

---

## 7. Interaksi dan State UI

Pertimbangkan state berikut pada layar yang relevan:
- Default/normal.
- Tugas belum selesai dan sudah selesai.
- Item terpilih, tab aktif, atau filter aktif.
- Loading/skeleton untuk proses yang benar-benar memerlukan waktu.
- Empty state: belum ada tugas, daftar kosong, atau pencarian tanpa hasil.
- Error state dengan penjelasan singkat dan langkah pemulihan.
- Success feedback setelah tugas disimpan, tugas diselesaikan, backup berhasil, atau achievement terbuka.
- Form invalid/field wajib belum diisi.
- Dialog konfirmasi sebelum tindakan destruktif atau restore.
- Offline state untuk fitur yang memerlukan koneksi.

### Aturan gamifikasi yang harus konsisten secara visual

- XP, level, streak, achievement, dan reward mengikuti aturan bisnis pada `PRD.md`.
- Nilai awal XP adalah 10 XP untuk setiap kejadian tugas yang pertama kali diselesaikan, sesuai PRD.
- Menyelesaikan ulang kejadian tugas yang sama tidak memberikan XP kedua.
- Tugas berulang dapat memberi XP untuk kejadian baru setelah diselesaikan.
- Level didasarkan pada akumulasi XP dan tidak turun hanya karena streak terputus.
- Streak bertambah saat target minimal 70% tugas eligible harian tercapai.
- Reward versi awal bersifat virtual/nonfinansial.
- Jangan menambah sistem misi, mata uang virtual, atau bonus XP yang belum ditetapkan dalam PRD tanpa revisi produk.

---

## 8. Mode Gelap

MyPlan direncanakan memiliki mode gelap sesuai cakupan PRD. Untuk desain awal, prioritaskan mode terang yang disepakati; mode gelap dapat dirancang setelah visual utama diterima.

Prinsip mode gelap:
- Gunakan navy/blue-grey gelap, bukan hitam pekat untuk semua permukaan.
- Permukaan kartu sedikit lebih terang daripada latar.
- Aksen biru/cyan tetap dipertahankan dengan kontras yang memadai.
- Kurangi opacity glass jika membuat permukaan tampak kusam atau teks sulit dibaca.
- Status tugas, prioritas, streak, XP, dan error harus tetap mudah dibedakan.

---

## 9. Aksesibilitas dan Kualitas Visual

- Target sentuh minimal sekitar 48 × 48 dp.
- Teks utama dan kontrol harus memiliki kontras yang memadai.
- Status tugas harus bisa dikenali melalui ikon/label, bukan hanya warna.
- Gunakan ukuran teks yang dapat dibaca di layar kecil dan tetap nyaman saat ukuran teks perangkat diperbesar.
- Jangan gunakan metadata kecil untuk informasi yang penting bagi tindakan pengguna.
- Hindari animasi berlebihan; efek visual tidak boleh memperlambat interaksi inti.
- Kurangi kepadatan teks dan jumlah kartu; sisakan ruang kosong agar halaman mudah dipindai.
- Utamakan performa di perangkat Android kelas menengah/bawah; efek blur kompleks dapat disederhanakan jika berat.

---

## 10. Prompt Utama untuk Google Stitch

Lampirkan tiga acuan bila Google Stitch mendukung gambar/file sekaligus:
1. **Screenshot MyPlan hijau awal** sebagai acuan tata letak.
2. **Screenshot Google Stitch biru terbaru** sebagai acuan visual blue gradient blur dan glassmorphism.
3. `PRD.md` sebagai sumber fitur dan perilaku.

Berikan `DESIGN.md` ini sebagai panduan visual. Prompt berikut dapat digunakan langsung atau dijadikan dasar prompt revisi.

### Prompt

> Refine the MyPlan Android mobile app using the attached references with clearly separated roles:
>
> **LAYOUT REFERENCE:** The original GREEN MyPlan screenshots define the preferred page structure, information hierarchy, component placement, and familiar user flow. Preserve this layout as much as practical. Do not keep the green branding.
>
> **VISUAL REFERENCE:** The latest BLUE Stitch screenshot defines the desired visual direction: bright blue and cyan, soft blue gradient blur/glow, clean light surfaces, subtle frosted-glass effects, rounded cards, fine borders, and soft shadows. Improve it where necessary to reduce clutter.
>
> **FUNCTIONAL SOURCE OF TRUTH:** Read `PRD.md` for product scope and behavior. Include all applicable required features, including task management, categories/lists, priority, subtasks, date/time, calendar and timeline, reminders, statistics, local persistence, Google Drive backup/sync planning, Streak, XP, Level, Achievement/Badge, and Reward. Treat widget, AI planner, and Wear OS according to the priorities in the PRD. Do not invent conflicting behavior or remove required features to simplify the mockup.
>
> **VISUAL SYSTEM:** Use Blue Gradient Blur + Glassmorphism + Clean Productivity UI. Use sky blue/cyan accents, a light icy-blue background, white task surfaces, dark slate text, consistent spacing, rounded corners, subtle borders, and a consistent icon family. Reference tokens include `#42BCEB`, `#179FD2`, `#64D5F2`, `#F0F7FC`, `#FFFFFF`, `#172B3A`, and gradient `#A8E5F8 → #63C8EF → #D8F2FC`.
>
> Make the blue blur visible behind selected header/summary regions, not over all content. Use glassmorphism selectively on summary/progress cards and selected floating surfaces. Keep task rows, calendars, and forms mostly solid and highly readable. Do not make every card transparent.
>
> **SIMPLICITY:** Reduce unnecessary labels, tiny metadata, duplicate cards, decorative icons, and excess colored chips. Preserve useful details, but set a clear hierarchy: page title, key summary, main task content, secondary actions. Do not cram every feature into the first screen.
>
> **SCREENS:** Design a coherent set of Indonesian-language Android portrait screens: Beranda/My Day, Kalender & Timeline, Tugas/List, Detail Tugas, Tambah/Edit Kegiatan, Profil & Statistik, Achievement/Badge and Settings. Use a four-item bottom navigation—Beranda, Kalender, Tugas, Profil—unless the layout reference proves another arrangement is clearly better. Achievement should be accessible from Beranda/Profile, not necessarily a separate bottom tab.
>
> **GAMIFICATION:** Integrate Streak, XP, Level, achievements, and rewards into the existing MyPlan layout without making it feel like a full game. Keep XP and streak values consistent with `PRD.md`; avoid duplicate XP rewards for the same task occurrence.
>
> Create a single coherent design system across all screens. Preserve the strengths of the original green layout, apply the feature requirements from the PRD, and replace the visual identity with polished blue gradient blur and tasteful glassmorphism. The result should feel spacious, calm, modern, readable, and practical for everyday use—not crowded or overly decorative.

### Urutan layar yang disarankan

Untuk iterasi awal, pastikan empat layar inti terlebih dahulu:
1. Beranda/My Day.
2. Kalender & Timeline.
3. Detail Tugas.
4. Profil & Statistik.

Kemudian selesaikan Tugas/List, Tambah/Edit Kegiatan, Achievement/Badge, dan Settings. Jika Stitch menghasilkan terlalu banyak informasi kecil, minta penyederhanaan sebelum menambah layar berikutnya.

---

## 11. Checklist Review Desain

Sebelum menyatakan desain siap diimplementasikan, tinjau checklist berikut:

- [ ] Layout masih terasa dekat dengan screenshot MyPlan hijau awal.
- [ ] Tidak ada branding hijau yang tertinggal sebagai warna utama.
- [ ] Blue gradient blur terlihat jelas di area terpilih, tetapi tidak memenuhi setiap kartu.
- [ ] Glassmorphism digunakan sebagai aksen dan tidak mengganggu teks.
- [ ] Warna, radius, spacing, tipografi, ikon, dan tombol konsisten pada seluruh halaman.
- [ ] Beranda memprioritaskan rencana hari ini, bukan terlalu banyak kartu statistik.
- [ ] Baris tugas mudah dipindai dan cepat dicentang.
- [ ] Kalender membedakan tanggal hari ini, tanggal terpilih, dan tanggal beragenda.
- [ ] Detail tugas memiliki hierarki jelas: detail → progres/subtask → catatan → tindakan utama.
- [ ] Profil & Statistik tidak terlalu padat dan Achievement mudah ditemukan.
- [ ] XP, Level, Streak, Badge, dan Reward terintegrasi tetapi tidak mendominasi aplikasi.
- [ ] Form tambah/edit kegiatan mudah dipindai dan tombol simpan mudah dijangkau.
- [ ] Teks menggunakan bahasa Indonesia dan mudah dibaca.
- [ ] Empty state, error state, dan status selesai dirancang.
- [ ] Semua fitur utama yang ditentukan PRD tetap terakomodasi.
- [ ] Desain tetap dapat diterapkan pada ukuran layar Android yang berbeda.

## 12. Hal yang Masih Dapat Disempurnakan

Setelah pengguna meninjau hasil Stitch, hal berikut dapat diputuskan lebih lanjut:
- Penyesuaian kecil kode warna berdasarkan screenshot yang disukai.
- Detail intensitas blur, transparansi kaca, dan bayangan.
- Font final dan variasi bobotnya.
- Kepadatan informasi pada Beranda dan Profil & Statistik.
- Apakah Tambah/Edit Kegiatan paling sesuai sebagai halaman penuh atau bottom sheet.
- Detail mode gelap serta animasi mikro.

Perubahan ini tidak boleh mengubah kebutuhan fitur dan aturan bisnis yang sudah ditetapkan dalam PRD tanpa revisi PRD.

---

**Catatan status:** Dokumen ini menggambarkan arah desain MyPlan setelah diskusi dan revisi Google Stitch terbaru. Gunakan sebagai design brief untuk review lanjutan. Setelah mockup final disetujui, perbarui dokumen jika ada keputusan visual baru sebelum memulai implementasi penuh di Antigravity.
