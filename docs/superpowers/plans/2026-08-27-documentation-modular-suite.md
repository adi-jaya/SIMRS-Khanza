# Rencana Implementasi: Dokumentasi Modular Terstruktur SIMRS-Khanza

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Membangun rangkaian dokumentasi modular profesional (*Progressive Modular Suite*) berformat Markdown di direktori `docs/` yang menggantikan berkas monolitik lama dengan materi yang terstruktur, akurat secara teknis (target Java 8), dan ramah bagi developer berlatar belakang PHP/Laravel.

**Architecture:** Dokumentasi dibagi menjadi 6 berkas tematik berurutan (`docs/README.md`, `docs/01-*.md` s/d `docs/05-*.md`) yang saling terhubung menggunakan navigasi tautan relatif (*header* dan *footer*), format GitHub Flavored Markdown, dan diagram visual Mermaid.

**Tech Stack:** GitHub Flavored Markdown, Mermaid Diagram, Shell Scripting, Java 8 (JDK 1.8 / Eclipse Temurin), Apache Ant, MySQL/MariaDB, VSCode.

**Spec:** [docs/superpowers/specs/2026-08-27-documentation-modular-suite-design.md](file:///Users/adijaya/MyFiles/Projects/SIMRS-Khanza/docs/superpowers/specs/2026-08-27-documentation-modular-suite-design.md)

## Global Constraints

- Semua panduan wajib konsisten menggunakan target **JDK 8 (JavaSE-1.8)**.
- Nama biner file build yang dihasilkan Apache Ant wajib konsisten sebagai `dist/SIMRSKhanza.jar` (tanpa tanda strip).
- Setiap file wajib menyertakan navigasi tautan relatif di bagian atas dan bawah: `[← Sebelumnya] | [Daftar Isi (README)] | [Selanjutnya →]`.
- Gaya peringatan menggunakan callout alert standar GitHub: `> [!NOTE]`, `> [!TIP]`, `> [!IMPORTANT]`, `> [!WARNING]`.
- Bahasa pengantar utama adalah Bahasa Indonesia formal-teknis yang komunikatif dan terstruktur.

---

### Task 1: Modul 1 — Setup Environment dari Nol (`01-getting-started.md`)

**Files:**
- Create: `docs/01-getting-started.md`

**Interfaces:**
- Produces: Panduan setup lengkap bare-metal macOS/Linux/Windows, instalasi JDK 8, Apache Ant, database `sik`, penempatan folder `lib/`, dan konfigurasi VSCode.

- [ ] **Step 1: Tulis isi file `docs/01-getting-started.md`**
  Memuat:
  - Header navigasi: `[Daftar Isi (README.md)](README.md) | [Selanjutnya: Konsep Laravel ke Java (02-laravel-to-java-guide.md) →](02-laravel-to-java-guide.md)`
  - Prasyarat sistem (macOS, Linux, Windows).
  - Instalasi Eclipse Temurin JDK 8 & export `JAVA_HOME` permanen di `~/.zshrc` / `~/.bashrc`.
  - Instalasi Apache Ant via Homebrew / apt.
  - Setup database MySQL `sik`, import `sik.sql`, dan file SQL bridging.
  - Misteri folder `lib/`, alasan `.gitignore`, tautan unduh Google Drive resmi, dan instruksi penempatan di root project.
  - Konfigurasi `.vscode/settings.json` (termasuk `java.configuration.runtimes` untuk JavaSE-1.8) dan `.vscode/tasks.json` (dengan `JAVA_HOME`).
  - Verifikasi build & eksekusi pertama (`ant compile` dan `ant run`).
  - Footer navigasi.

- [ ] **Step 2: Verifikasi rendering dan kelengkapan konten**
  Pastikan seluruh blok kode terminal zsh/bash dan JSON konfigurasi valid dan siap pakai.

- [ ] **Step 3: Commit**
  ```bash
  git add docs/01-getting-started.md
  git commit -m "docs: add 01-getting-started module"
  ```

---

### Task 2: Modul 2 — Jembatan Konsep Laravel vs Java (`02-laravel-to-java-guide.md`)

**Files:**
- Create: `docs/02-laravel-to-java-guide.md`

**Interfaces:**
- Consumes: Navigasi dari `01-getting-started.md`
- Produces: Peta analogi Laravel ke Java, glosarium istilah Java komprehensif, dan penjelasan siklus Event-Driven & EDT.

- [ ] **Step 1: Tulis isi file `docs/02-laravel-to-java-guide.md`**
  Memuat:
  - Header navigasi: `[← Sebelumnya: Setup Environment](01-getting-started.md) | [Daftar Isi](README.md) | [Selanjutnya: Arsitektur & Kode Sumber →](03-architecture-and-codebase.md)`
  - Tabel analogi 8 pilar arsitektur Laravel vs Java Swing Khanza (Stateless vs Stateful, Blade vs Swing Form, Eloquent vs `sekuel.java`, Middleware vs `fungsi.akses`, Composer vs `lib/*.jar`, `.env` vs `database.xml`, DomPDF vs JasperReports).
  - Glosarium istilah lengkap: JVM, JRE, JDK, Bytecode, JAR, Classpath, JDBC (Connection, PreparedStatement, ResultSet), Apache Ant, Swing/AWT, `.form` Matisse, JasperReports (`.jrxml` & `.jasper`), POJO, NullPointerException.
  - Paradigma pemrograman desktop: Event Dispatch Thread (EDT) vs Background Worker (`SwingWorker`) untuk mencegah antarmuka *freeze*.
  - Footer navigasi.

- [ ] **Step 2: Verifikasi tabel markdown dan keterbacaan konsep**
  Pastikan tabel komparasi rapi dan format teks glosarium jelas.

- [ ] **Step 3: Commit**
  ```bash
  git add docs/02-laravel-to-java-guide.md
  git commit -m "docs: add 02-laravel-to-java-guide module"
  ```

---

### Task 3: Modul 3 — Arsitektur & Anatomi Kode Sumber (`03-architecture-and-codebase.md`)

**Files:**
- Create: `docs/03-architecture-and-codebase.md`

**Interfaces:**
- Consumes: Konsep dari `02-laravel-to-java-guide.md`
- Produces: Dokumentasi mendalam tentang pembagian direktori, core engine `src/fungsi/`, keamanan enkripsi AES `database.xml`, form Swing Matisse, arsitektur REST API bridging, dan optimasi database.

- [ ] **Step 1: Tulis isi file `docs/03-architecture-and-codebase.md`**
  Memuat:
  - Header navigasi: `[← Sebelumnya: Konsep Laravel ke Java](02-laravel-to-java-guide.md) | [Daftar Isi](README.md) | [Selanjutnya: Alur Kerja & Troubleshooting →](04-development-workflow.md)`
  - Pohon direktori proyek dan penjelasan package (`simrskhanza`, `rekammedis`, `inventory`, `keuangan`, `kepegawaian`, `bridging`, `fungsi`, `report`, `lib`, `setting`).
  - Bedah Core Engine di `src/fungsi/`:
    - `koneksiDB.java` (JDBC pooling, validation `SELECT 1`, auto-reconnect).
    - `sekuel.java` (Helper CRUD: `menyimpan`, `mengedit`, `hapus`, `cariIsi`).
    - `validasi.java` (Validasi input & manipulasi tabel).
    - `akses.java` (Matriks hak akses user).
  - Keamanan & Konfigurasi: format `setting/database.xml`, enkripsi AES-128, dan tool `KhanzaPengenkripsiTeks/`.
  - Anatomi Form Swing: Sinkronisasi `.java` & `.form`, batas aman pengeditan blok `Generated Code`.
  - Arsitektur Web Service Bridging (`src/bridging/`): Pola REST API, HMAC-SHA256 & LZ-String (BPJS), OAuth2 & FHIR JSON (Kemenkes SatuSehat).
  - Best Practices Database `sik`: Indeks tabel penting untuk lingkungan produksi rumah sakit.
  - Footer navigasi.

- [ ] **Step 2: Verifikasi diagram struktur dan penjelasan fungsi Java**
  Pastikan contoh potongan kode dan penjelasan class engine akurat dengan file asli di repo.

- [ ] **Step 3: Commit**
  ```bash
  git add docs/03-architecture-and-codebase.md
  git commit -m "docs: add 03-architecture-and-codebase module"
  ```

---

### Task 4: Modul 4 — Alur Kerja Pengembangan & Troubleshooting (`04-development-workflow.md`)

**Files:**
- Create: `docs/04-development-workflow.md`

**Interfaces:**
- Consumes: Navigasi dari `03-architecture-and-codebase.md`
- Produces: Panduan siklus build Apache Ant, VSCode Tasks, Git upstream workflow, dan katalog solusi error.

- [ ] **Step 1: Tulis isi file `docs/04-development-workflow.md`**
  Memuat:
  - Header navigasi: `[← Sebelumnya: Arsitektur & Kode Sumber](03-architecture-and-codebase.md) | [Daftar Isi](README.md) | [Selanjutnya: Roadmap & Resep Fitur →](05-feature-roadmap-and-recipes.md)`
  - Siklus Build & Packaging Apache Ant (`ant compile`, `ant run`, `ant clean jar` $\rightarrow$ output biner `dist/SIMRSKhanza.jar`).
  - Fast-iteration & debugging di VSCode (`Cmd+Shift+B`, VSCode debugger config `.vscode/launch.json`).
  - Git Workflow & Upstream Collaboration:
    - Model Branching: `upstream/master` $\rightarrow$ `origin/master` $\rightarrow$ `development`.
    - Diagram Mermaid alur sinkronisasi.
    - Panduan langkah mengambil update harian & resolusi *merge conflict*.
  - Katalog Troubleshooting Komprehensif:
    1. Gagal koneksi database (`Gagal koneksi ke database. Sisa percobaan: ...`).
    2. Symbol / Package Not Found di VSCode.
    3. `OutOfMemoryError: Java heap space` saat kompilasi Ant.
    4. Peringatan font (Times / Serif) di macOS.
  - Footer navigasi.

- [ ] **Step 2: Verifikasi sintaks Mermaid diagram dan perintah Git**
  Pastikan diagram alur Git render dengan benar di GitHub Markdown.

- [ ] **Step 3: Commit**
  ```bash
  git add docs/04-development-workflow.md
  git commit -m "docs: add 04-development-workflow module"
  ```

---

### Task 5: Modul 5 — Roadmap Pembelajaran & Resep Fitur (`05-feature-roadmap-and-recipes.md`)

**Files:**
- Create: `docs/05-feature-roadmap-and-recipes.md`

**Interfaces:**
- Consumes: Navigasi dari `04-development-workflow.md`
- Produces: Roadmap belajar bertahap dan 4 resep implementasi praktis (CRUD form master baru, alur transaksi pelayanan pasien, JasperReports, dan bridging).

- [ ] **Step 1: Tulis isi file `docs/05-feature-roadmap-and-recipes.md`**
  Memuat:
  - Header navigasi: `[← Sebelumnya: Alur Kerja & Troubleshooting](04-development-workflow.md) | [Daftar Isi](README.md)`
  - Roadmap 4 Level Pembelajaran & Pengembangan SIMRS-Khanza.
  - Resep Praktik 1: Langkah detail membuat Form CRUD Master Baru dari nol (Tabel DB $\rightarrow$ Form Swing $\rightarrow$ Event CRUD $\rightarrow$ Menu Utama & Izin Akses).
  - Resep Praktik 2: Menelusuri alur transaksi pelayanan pasien (`DlgReg.java` $\rightarrow$ `DlgRawatJalan.java` $\rightarrow$ `DlgKasirRalan.java`).
  - Resep Praktik 3: Panduan kustomisasi laporan JasperReports (`.jrxml` $\rightarrow$ `.jasper` via Jaspersoft Studio 6.x) dan pemanggilan via Java.
  - Resep Praktik 4: Dasar implementasi integrasi API baru di package `src/bridging/`.
  - Footer navigasi.

- [ ] **Step 2: Verifikasi alur resep praktik dan referensi class Java**
  Pastikan nama-nama class dialog Khanza yang direferensikan sesuai dengan file fisik di `src/`.

- [ ] **Step 3: Commit**
  ```bash
  git add docs/05-feature-roadmap-and-recipes.md
  git commit -m "docs: add 05-feature-roadmap-and-recipes module"
  ```

---

### Task 6: Modul 0 — Hub Navigasi Utama (`docs/README.md`)

**Files:**
- Create: `docs/README.md`

**Interfaces:**
- Produces: Berkas indeks dokumentasi utama yang merangkum dan menautkan seluruh modul 01 s/d 05.

- [ ] **Step 1: Tulis isi file `docs/README.md`**
  Memuat:
  - Judul Dokumentasi Resmi SIMRS-Khanza.
  - Ikhtisar Proyek & Arsitektur Monolitik Java Desktop.
  - Tabel Peta Navigasi Modul (Modul 01 s/d 05 dengan link langsung).
  - Panduan Memulai Cepat (*Quick Start in 3 Steps*).
  - Cheatsheet Perintah CLI Esensial.
  - Kontribusi & Konvensi Dokumentasi.

- [ ] **Step 2: Verifikasi seluruh tautan markdown di `README.md`**
  Pastikan semua tautan relatif mengarah ke berkas modul yang tepat (`01-getting-started.md` s/d `05-feature-roadmap-and-recipes.md`).

- [ ] **Step 3: Commit**
  ```bash
  git add docs/README.md
  git commit -m "docs: add README documentation hub and index"
  ```

---

### Task 7: Verifikasi Lintas-Berkas & Pembersihan Berkas Lama (*Clean Replace*)

**Files:**
- Delete: `docs/PANDUAN_BELAJAR_SIMRS_KHANZA.md`
- Delete: `docs/PANDUAN_KONFIGURASI.md`

**Interfaces:**
- Consumes: Seluruh modul baru `01` s/d `05` dan `README.md`.
- Produces: Folder `docs/` yang bersih, modular, dan terverifikasi 100%.

- [ ] **Step 1: Audit tautan dan referensi antar-berkas**
  Verifikasi tidak ada *broken link* di setiap header dan footer navigasi di seluruh 6 file dokumentasi.

- [ ] **Step 2: Hapus file monolitik lama**
  ```bash
  rm docs/PANDUAN_BELAJAR_SIMRS_KHANZA.md docs/PANDUAN_KONFIGURASI.md
  ```

- [ ] **Step 3: Verifikasi struktur akhir direktori `docs/`**
  Jalankan listing direktori untuk memastikan hanya ada berkas baru dan subfolder `superpowers/`.

- [ ] **Step 4: Commit akhir**
  ```bash
  git add docs/
  git commit -m "docs: complete migration to progressive modular suite and remove legacy guides"
  ```
