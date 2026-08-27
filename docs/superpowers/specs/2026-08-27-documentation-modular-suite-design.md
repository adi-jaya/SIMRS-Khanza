# Spesifikasi Desain: Dokumentasi Modular Terstruktur SIMRS-Khanza

**Tanggal:** 27 Agustus 2026  
**Status:** Approved for Implementation  
**Tujuan:** Merestrukturisasi dokumentasi di folder `docs/` menjadi rangkaian modul dokumentasi profesional (*Progressive Modular Suite*) yang terintegrasi, bebas dari inkonsistensi teknis, dan ramah bagi pengembang web (khususnya berlatar belakang PHP / Laravel) yang ingin mempelajari, memelihara, dan mengembangkan SIMRS-Khanza.

---

## 1. Latar Belakang & Ringkasan Eksekutif

Dokumentasi awal pada direktori `docs/` terdiri dari dua file besar:
1. `PANDUAN_BELAJAR_SIMRS_KHANZA.md`
2. `PANDUAN_KONFIGURASI.md`

Meskipun memuat informasi yang kaya, terdapat kelemahan arsitektur dokumentasi:
- **Inkonsistensi Teknis**: Penyebutan target Java yang kontradiktif (JDK 15 vs JDK 8) dan penamaan file output JAR (`dist/SIMRS-Khanza.jar` vs `dist/SIMRSKhanza.jar`).
- **Redudansi Konten**: Tahapan instalasi tools (Homebrew, Ant, MySQL, dan folder `lib/`) terduplikasi di kedua file.
- **Navigasi & Kemudahan Pemeliharaan**: Berkas monolitik sulit ditelusuri per topik saat tim melakukan *onboarding* atau mencari solusi spesifik.

Solusinya adalah menerapkan **Pendekatan Progressive Modular Suite** dengan strategi **Clean Replace** (menyerap seluruh materi lama, memutakhirkannya, memecahnya ke dalam 6 modul tematik bernomor urut, dan menghapus berkas monolitik lama).

---

## 2. Arsitektur Informasi & Struktur Berkas

Struktur baru di dalam direktori `docs/` adalah sebagai berikut:

```
docs/
├── README.md                              # Modul 0: Hub Navigasi Utama & Indeks
├── 01-getting-started.md                  # Modul 1: Setup Environment dari Nol (macOS/Linux/Windows)
├── 02-laravel-to-java-guide.md            # Modul 2: Jembatan Konsep Laravel vs Java & Glosarium
├── 03-architecture-and-codebase.md        # Modul 3: Arsitektur Aplikasi, Core Engine, Database & Bridging
├── 04-development-workflow.md             # Modul 4: Alur Build Ant, VSCode Tasks, Git & Troubleshooting
├── 05-feature-roadmap-and-recipes.md      # Modul 5: Roadmap Belajar & Resep Pengembangan Fitur
└── superpowers/
    └── specs/
        └── 2026-08-27-documentation-modular-suite-design.md
```

---

## 3. Spesifikasi Rinci Setiap Modul

### Modul 0: `docs/README.md` (Indeks Navigasi & Cheatsheet)
* **Header & Pengantar Proyek:** Ringkasan SIMRS-Khanza, arsitektur desktop Java Swing, lisensi, dan peruntukan dokumentasi.
* **Tabel Navigasi Terpadu:**
  | Modul | Nama Panduan | Target Pembaca & Cakupan | Tautan |
  | :--- | :--- | :--- | :--- |
  | **01** | Setup Environment dari Nol | Instalasi JDK 8, Ant, MySQL, penyiapan `lib/`, dan VSCode | [Buka Panduan](01-getting-started.md) |
  | **02** | Panduan Konsep (Laravel $\rightarrow$ Java) | Mental model web vs desktop, perbandingan arsitektur, glosarium | [Buka Panduan](02-laravel-to-java-guide.md) |
  | **03** | Arsitektur & Anatomi Kode Sumber | Struktur package, bedah `fungsi.*`, database `sik`, enkripsi AES, & Bridging | [Buka Panduan](03-architecture-and-codebase.md) |
  | **04** | Alur Kerja Pengembangan & Troubleshooting | Build lifecycle Ant, shortcut VSCode, Git workflow, & katalog solusi error | [Buka Panduan](04-development-workflow.md) |
  | **05** | Roadmap Pembelajaran & Resep Fitur | 4 level roadmap, alur transaksi RS, resep CRUD, & JasperReports | [Buka Panduan](05-feature-roadmap-and-recipes.md) |
* **Quick Reference Cheatsheet:** Perintah CLI paling sering digunakan (`ant compile`, `ant run`, `ant clean jar`, git push).

---

### Modul 1: `docs/01-getting-started.md` (Setup Environment dari Nol)
* **Prasyarat Sistem Minimal:** macOS (Apple Silicon / Intel), Linux, Windows.
* **Instalasi Java 8 (JDK 1.8):**
  * Rekomendasi resmi: Eclipse Temurin JDK 8 (`brew install --cask temurin@8`).
  * Penjelasan mengapa Java 8 adalah target stabil Khanza.
  * Konfigurasi permanen `JAVA_HOME` dan `PATH` pada shell (`~/.zshrc` / `~/.bashrc`).
  * Verifikasi `java -version` dan `javac -version`.
* **Instalasi Apache Ant:** Instalasi via Homebrew / package manager dan verifikasi `ant -version`.
* **Setup Database MySQL / MariaDB:**
  * Menjalankan service MySQL (port default 3306).
  * Pembuatan database `sik` dengan charset `utf8mb4`.
  * Import file `sik.sql` (dan file SQL pendukung seperti `sik_bridging_lab.sql` & `sik_bridging_radiologi.sql`).
* **Manajemen Dependensi Fisik (`lib/`):**
  * Alasan teknis folder `lib/` di-ignore oleh Git (.gitignore 300MB+ binary).
  * Sumber pengadaan resmi (Google Drive resmi komunitas dan bundle instalasi KhanzaHMSMac).
  * Cara verifikasi kelengkapan folder `lib/` (~318 file `.jar`).
* **Konfigurasi VS Code:**
  * Ekstensi wajib: *Extension Pack for Java*.
  * Konfigurasi `.vscode/settings.json` (termasuk `java.configuration.runtimes` untuk JavaSE-1.8).
  * Konfigurasi `.vscode/tasks.json` (dengan environment variable `JAVA_HOME`).
* **Verifikasi Akhir:** Eksekusi `ant compile` dan `ant run` hingga jendela GUI login muncul.

---

### Modul 2: `docs/02-laravel-to-java-guide.md` (Jembatan Konsep Laravel vs Java)
* **Peta Analogi Konseptual (Tabel 8 Pilar):**
  1. *Siklus Eksekusi*: Stateless HTTP Request-Response vs Stateful Event-Driven Desktop Application.
  2. *View / UI*: Blade Template (`.blade.php`) vs Java Swing (`Dlg*.java` + NetBeans Matisse `.form`).
  3. *Routing & Controller*: `routes/web.php` $\rightarrow$ Controller vs Event Listener (`ActionPerformed`, `MouseClicked`).
  4. *Akses Data*: Eloquent ORM / Query Builder vs Raw JDBC via `fungsi.sekuel` & `fungsi.koneksiDB`.
  5. *Konfigurasi*: `.env` vs `setting/database.xml` (AES-128).
  6. *Paket Dependensi*: Composer `vendor/` vs Physical JARs di `lib/` dikelola Apache Ant.
  7. *Laporan / Dokumen*: DomPDF / Snappy PDF vs JasperReports (`.jrxml` $\rightarrow$ `.jasper`).
  8. *Hak Akses / Otorisasi*: Middleware / Spatie vs Class `fungsi.akses` & tabel database `hak_akses`.
* **Glosarium Istilah & Konsep Java:**
  * JVM, JRE, JDK, Bytecode (`.class`).
  * JAR, Classpath.
  * JDBC, Driver, `PreparedStatement`, `ResultSet`.
  * Apache Ant, `build.xml`.
  * Java Swing, AWT, `JFrame`, `JDialog`, `JTable`, `.form` (Matisse XML).
  * JasperReports, `.jrxml`, `.jasper`.
  * POJO, NullPointerException (NPE).
* **Perbedaan Paradigma Pemrograman (Threading & UI Freeze):**
  * Penjelasan *Event Dispatch Thread (EDT)*.
  * Bahaya query berat di main thread dan penggunaan `SwingWorker` / Background Thread.

---

### Modul 3: `docs/03-architecture-and-codebase.md` (Arsitektur, Core Engine, Database & Bridging)
* **Peta Struktur Direktori & Package:**
  * Penjelasan direktori: `src/`, `report/`, `setting/`, `lib/`, `nbproject/`, `webapps/`.
  * Pembagian modul di `src/`: `simrskhanza`, `rekammedis`, `inventory`, `keuangan`, `kepegawaian`, `bridging`, `fungsi`, dll.
* **Bedah Core Engine (`src/fungsi/`):**
  * `koneksiDB.java`: Logika koneksi JDBC, connection pooling, validasi status koneksi (`SELECT 1`), dan *auto-reconnect*.
  * `sekuel.java`: Helper CRUD SQL (`menyimpan()`, `mengedit()`, `hapus()`, `cariIsi()`).
  * `validasi.java`: Helper validasi text box, format tanggal, dan manipulasi visual tabel.
  * `akses.java`: Session login aktif dan pemetaan izin pengguna.
* **Sistem Konfigurasi & Keamanan:**
  * Format `setting/database.xml`.
  * Mekanisme enkripsi AES-128 bawaan Khanza.
  * Penggunaan sub-project `KhanzaPengenkripsiTeks` untuk generate kredensial baru.
* **Anatomi Form Java Swing & NetBeans Generated Code:**
  * Pasangan file `Dlg*.java` dan `Dlg*.form`.
  * Aturan penting: Larangan mengedit blok `// <editor-fold defaultstate="collapsed" desc="Generated Code">` secara manual jika form tetap ingin bisa dibuka di NetBeans GUI Builder.
* **Arsitektur Integrasi Web Service Bridging (`src/bridging/`):**
  * Pola komunikasi REST API di Khanza.
  * Enkripsi Header HMAC-SHA256 & Dekripsi respon LZ-String (BPJS VClaim / Mobile JKN / PCare).
  * Autentikasi OAuth2 & JSON FHIR Resource (Kemenkes SatuSehat).
* **Praktik Terbaik Skalabilitas Database `sik`:**
  * Indeks pada kolom relasi penting (`no_rawat`, `no_rkm_medis`, `tgl_registrasi`, `kode_brng`).

---

### Modul 4: `docs/04-development-workflow.md` (Alur Kerja, Git, & Troubleshooting)
* **Siklus Build & Packaging Apache Ant:**
  * Target build: `ant compile`, `ant run`, `ant clean jar`.
  * Struktur hasil build di folder `dist/` (file biner `dist/SIMRSKhanza.jar` dan dependensi `dist/lib/`).
* **Optimasi Fast-Iteration & Debugging di VSCode:**
  * Menjalankan task kompilasi cepat via shortcut (`Cmd+Shift+B`).
  * Konfigurasi Java Debugger di VSCode (`.vscode/launch.json`).
* **Alur Kolaborasi Git & Sinkronisasi Upstream:**
  * Model branching: `upstream/master` (Official Khanza) $\rightarrow$ `origin/master` (Fork) $\rightarrow$ `development` (Custom RS).
  * Diagram Mermaid alur sinkronisasi.
  * Langkah mengambil update berkala dari upstream.
  * Panduan resolusi *merge conflict*.
* **Katalog Troubleshooting Komprehensif:**
  1. *Gagal Koneksi Database (`Gagal koneksi ke database. Sisa percobaan: ...`)*: Solusi port, status MySQL, database `sik`, dan password AES.
  2. *Symbol / Package Not Found di VSCode*: Solusi membersihkan workspace Java Language Server (`Clean Java Language Server Workspace`).
  3. *OutOfMemoryError / Java heap space saat Build*: Solusi setting `export ANT_OPTS="-Xms512m -Xmx2048m"`.
  4. *Font Warning (Times / Serif di macOS)*: Penjelasan peringatan font dan cara mengabaikannya dengan aman.

---

### Modul 5: `docs/05-feature-roadmap-and-recipes.md` (Roadmap & Resep Pengembangan Fitur)
* **Roadmap Pembelajaran 4 Level:**
  * *Level 1*: Master Data CRUD Sederhana (Contoh: `DlgBangsal`, `DlgKabupaten`).
  * *Level 2*: Alur Klinis Pasien (Master Pasien $\rightarrow$ Pendaftaran $\rightarrow$ Pelayanan Poli & RME/SOAP).
  * *Level 3*: Transaksi Terintegrasi (Resep Farmasi, Tindakan Laborat/Radiologi, Billing Kasir).
  * *Level 4*: Custom Laporan (JasperReports) & Integrasi API Eksternal.
* **Resep Praktik 1: Membuat Form Master Baru:**
  * Langkah 1: Buat tabel di database `sik`.
  * Langkah 2: Buat Dialog Form (`DlgMasterBaru.java`).
  * Langkah 3: Desain UI (Input Fields, JTable, Tombol Simpan/Ubah/Hapus/Keluar).
  * Langkah 4: Tulis method `simpan()`, `ubah()`, `hapus()`, `tampil()`.
  * Langkah 5: Daftarkan form ke Menu Utama (`frmUtama.java`) dan matriks hak akses (`akses.java`).
* **Resep Praktik 2: Menelusuri Alur Transaksi Utama:**
  * Alur data dari Registrasi (DlgReg.java) $\rightarrow$ Pemeriksaan Poli (DlgRawatJalan.java) $\rightarrow$ Billing Kasir (DlgKasirRalan.java).
* **Resep Praktik 3: Kustomisasi Laporan JasperReports:**
  * Menggunakan Jaspersoft Studio 6.x.
  * Format file `.jrxml` dan kompilasi ke `.jasper`.
  * Penempatan file di folder `report/` dan pemanggilan dari kode Java (`Sequel.queryReport(...)`).

---

## 4. Rencana Migrasi & Penghapusan Berkas Lama (Clean Replace)

1. Buat direktori dan tulis seluruh 6 file modular baru (`docs/README.md`, `docs/01-*.md` s/d `docs/05-*.md`).
2. Lakukan audit mandiri (verifikasi seluruh tautan relatif antar-berkas dan konsistensi parameter teknis).
3. Hapus file lama:
   * `docs/PANDUAN_BELAJAR_SIMRS_KHANZA.md`
   * `docs/PANDUAN_KONFIGURASI.md`
4. Lakukan commit git dengan pesan: `docs: restructure documentation into progressive modular suite`.

---

## 5. Kriteria Keberhasilan (Success Criteria)

- [ ] Folder `docs/` memiliki struktur modular yang bersih dan terorganisir.
- [ ] Tidak ada lagi kontradiksi versi Java (seluruh panduan konsisten menyebut JDK 8).
- [ ] Nama file biner build konsisten dengan `build.xml` (`SIMRSKhanza.jar`).
- [ ] Navigasi *header* dan *footer* di setiap file berfungsi tanpa tautan rusak (*broken link*).
- [ ] Dokumentasi siap digunakan sebagai buku panduan mandiri (*onboarding guide*) bagi siapa pun pengembang yang baru masuk ke proyek.
