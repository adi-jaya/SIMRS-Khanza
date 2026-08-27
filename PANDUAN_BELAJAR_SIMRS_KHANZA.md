# Panduan Komprehensif SIMRS-Khanza untuk Developer Laravel (PHP ke Java)

Dokumen ini merupakan rangkuman lengkap dari seluruh sesi diskusi dan tanya-jawab mengenai pemahaman dasar Java, ekosistem SIMRS-Khanza, perbandingan konsep dengan Laravel (PHP), kamus istilah/glosarium, setup *environment* dari titik nol di macOS, serta anatomi arsitektur kode sumber.

---

## DAFTAR ISI

1. [Peta Analogi: Laravel vs SIMRS-Khanza (Java)](#1-peta-analogi-laravel-vs-simrs-khanza-java)
2. [Glosarium Istilah & Konsep Java](#2-glosarium-istilah--konsep-java)
3. [Anatomi & Struktur Folder SIMRS-Khanza](#3-anatomi--struktur-folder-simrs-khanza)
4. [Misteri Folder `lib/` & Penanganan Dependensi](#4-misteri-folder-lib--penanganan-dependensi)
5. [Kompatibilitas Versi Java: Java 15 vs Java 8](#5-kompatibilitas-versi-java-java-15-vs-java-8)
6. [Panduan Setup dari Titik Nol di macOS (Bare Metal ke VSCode)](#6-panduan-setup-dari-titik-nol-di-macos-bare-metal-ke-vscode)
7. [Alur Eksekusi & Troubleshooting Umum](#7-alur-eksekusi--troubleshooting-umum)
8. [Roadmap Pembelajaran Fitur & Modifikasi](#8-roadmap-pembelajaran-fitur--modifikasi)

---

## 1. Peta Analogi: Laravel vs SIMRS-Khanza (Java)

| Aspek / Konsep | Di Laravel (PHP) | Di SIMRS-Khanza (Java Desktop) |
| :--- | :--- | :--- |
| **Siklus Eksekusi** | **Stateless:** Request HTTP $\rightarrow$ Controller $\rightarrow$ Response HTML/JSON $\rightarrow$ Selesai/Koneksi mati. | **Stateful (Event-Driven):** Aplikasi terus hidup di memori komputer, bereaksi secara langsung terhadap event aksi klik/ketik pengguna. |
| **Tampilan UI (View)** | File `.blade.php` (HTML + CSS + Tailwind/Bootstrap). | **Java Swing:** File Java UI (`Dlg*.java`) berpasangan dengan file metadata XML NetBeans Matisse (`.form`). |
| **Routing & Controller** | `routes/web.php` $\rightarrow$ `Controller@method`. | **Event Listeners:** Langsung melekat pada komponen tombol/tabel (misal: `BtnSimpanActionPerformed`, `tbObatMouseClicked`). |
| **Database & ORM** | Eloquent ORM (`User::where(...)`) atau Query Builder (`DB::table(...)`). | **Raw JDBC & Helper Class:** Query SQL dieksekusi via `fungsi.sekuel` (`Sequel.menyimpan()`, `Sequel.mengedit()`, `Sequel.cariIsi()`) dan koneksi di `fungsi.koneksiDB`. |
| **Konfigurasi Lingkungan** | File `.env` (`DB_HOST`, `DB_PASSWORD`, dll). | File `setting/database.xml` (berisi parameter host, port, database, user, password terenkripsi AES). |
| **Manajemen Paket** | Composer (`composer.json` $\rightarrow$ folder `vendor/`). | Kumpulan file biner JAR fisik di folder `lib/` yang dirangkai menggunakan **Apache Ant** (`build.xml`). |
| **Reporting / Cetak PDF** | Blade View di-render ke DomPDF / Snappy PDF. | **JasperReports:** Template laporan berformat `.jrxml` di folder `report/` yang dikompilasi menjadi binary `.jasper`. |
| **Hak Akses & Otorisasi** | Middleware / Spatie Laravel-Permission. | Class `fungsi.akses` (mengecek nilai boolean izin fitur dari tabel database `hak_akses`). |

---

## 2. Glosarium Istilah & Konsep Java

### A. Ekosistem Eksekusi Java
* **JVM (Java Virtual Machine):** Mesin virtual yang membaca dan mengeksekusi *bytecode* (`.class`). JVM membuat aplikasi Java bersifat *cross-platform* ("Write Once, Run Anywhere").
* **JRE (Java Runtime Environment):** Paket runtime minimal (JVM + Library standar) yang ditujukan untuk pengguna akhir (*end-user*) agar bisa menjalankan aplikasi Java.
* **JDK (Java Development Kit):** Paket lengkap untuk developer (berisi JRE + compiler `javac` + debugger + tools development). Wajib dimiliki untuk mengembangkan SIMRS-Khanza.
* **Bytecode (`.class`):** Kode biner perantara hasil kompilasi dari kode sumber `.java` oleh compiler `javac`.

### B. Distribusi & Pustaka
* **JAR (Java Archive - `.jar`):** File arsip (berbasis ZIP) yang membungkus kumpulan file `.class`, gambar, konfigurasi, dan manifest metadata. Mirip dengan paket package di `vendor/` atau file `.phar` di PHP.
* **Classpath:** Daftar direktori atau file `.jar` yang didaftarkan ke JVM agar Java dapat menemukan class-class saat runtime atau proses kompilasi.

### C. Database & Akses Data
* **JDBC (Java Database Connectivity):** Standar API resmi di Java untuk koneksi dan eksekusi query ke database relasional (analoginya seperti **PDO** di PHP).
* **JDBC Driver (`mysql-connector-java.jar`):** Jembatan driver penghubung antara API JDBC Java dengan server MySQL/MariaDB.
* **PreparedStatement:** Objek query SQL terparameterisasi yang mencegah SQL Injection dan mengoptimalkan performa eksekusi query berulang.
* **ResultSet:** Objek kursor penampung data baris-per-baris hasil query `SELECT` (dibaca menggunakan iterasi `while (rs.next())`).

### D. Build System & Desktop UI
* **Apache Ant (`build.xml`):** Build automation tool berbasis XML yang bertugas mengompilasi file Java di `src/`, menautkan JAR di `lib/`, dan merangkai output aplikasi ke `SIMRSKhanza.jar`.
* **Java Swing & AWT:** Library GUI bawaan Java untuk merender window (`JFrame`), dialog popup (`JDialog`), tabel data (`JTable`), text field (`JTextField`), dan tombol (`JButton`).
* **NetBeans Matisse GUI (`.form`):** File XML metadata yang menyimpan koordinat dan properti visual komponen saat Anda mendesain form secara *drag-and-drop*.
* **EDT (Event Dispatch Thread):** Thread khusus tempat seluruh interaksi UI dan event klik tombol diproses. Operasi database berat yang dipanggil di EDT dapat membuat antarmuka *freeze* jika tidak dibungkus dalam background thread / `SwingWorker`.

### E. Pelaporan (Reporting)
* **JasperReports:** Library Java untuk mencetak dokumen, nota kasir, resep obat, surat rujukan, dan resume medis ke printer maupun format PDF.
* **JRXML (`.jrxml`):** File source template laporan berbasis XML yang didesain menggunakan Jaspersoft Studio atau iReport.
* **Jasper (`.jasper`):** File biner hasil kompilasi dari `.jrxml` agar rendering laporan saat runtime berlangsung cepat.

---

## 3. Anatomi & Struktur Folder SIMRS-Khanza

Berikut struktur folder utama dalam project SIMRS-Khanza:

```
SIMRS-Khanza/
├── src/                          # Seluruh kode sumber Java (.java dan .form)
│   ├── simrskhanza/              # Form inti: Menu Utama (frmUtama), Pasien (DlgPasien), Registrasi (DlgReg), Ralan/Ranap
│   ├── rekammedis/               # Modul RME, SOAP, Asesmen Awal Medis & Keperawatan, Skrining Klinis
│   ├── inventory/                # Modul Farmasi, Gudang Obat, Pengadaan, Resep & Stok Opname
│   ├── fungsi/                   # Core Engine:
│   │   ├── koneksiDB.java        # Pengelola koneksi database MySQL & pooling
│   │   ├── sekuel.java           # Helper operasi CRUD SQL (menyimpan, mengedit, hapus, cariIsi)
│   │   ├── validasi.java         # Helper validasi input text, format tanggal, pembuatan tabel
│   │   └── akses.java            # Pengelola login session dan permission pengguna
│   ├── bridging/                 # Integrasi Web Service REST API (BPJS VClaim/PCare, SatuSehat Kemenkes, Bank)
│   ├── keuangan/                 # Modul Akuntansi, Jurnal, Pembayaran, Kasir & Billing
│   └── kepegawaian/              # Modul Manajemen SDM, Presensi & Penggajian
├── report/                       # Template laporan JasperReports (.jrxml dan .jasper)
├── lib/                          # Pustaka dependency fisik (.jar)
├── setting/                      # File konfigurasi:
│   └── database.xml              # Konfigurasi koneksi MySQL (Host, Port, Database, User, Pass terenkripsi AES)
├── .vscode/                      # Konfigurasi workspace Visual Studio Code (settings.json, tasks.json)
├── build.xml                     # Skrip instruksi build Apache Ant
├── sik.sql                       # Dump skema database MySQL dan data awal SIMRS
└── nbproject/                    # Konfigurasi proyek Apache NetBeans
```

---

## 4. Misteri Folder `lib/` & Penanganan Dependensi

Saat pertama kali melakukan `git clone` dari repositori GitHub resmi SIMRS-Khanza, folder `lib/` tidak disertakan (kosong).

### Mengapa folder `lib/` di-ignore?
Di dalam file `.gitignore` terdapat baris:
```gitignore
# Root library directory (physical copy)
/lib/
```
Total ukuran file library JAR pihak ketiga pada SIMRS-Khanza mencapai lebih dari **300 MB (berisi 318+ file JAR)**. Karena Git tidak dirancang untuk menangani binary besar, folder ini dikeluarkan dari version control.

### Solusi Standar:
Folder `lib/` disalin dari bundle instalasi resmi Khanza (misalnya dari paket bawaan XAMPP KhanzaHMSMac):
```bash
cp -r /Applications/XAMPP/xamppfiles/htdocs/KhanzaHMSMac/lib ./lib
```

---

## 5. Kompatibilitas Versi Java: Java 15 vs Java 8

Saat ini sistem berjalan menggunakan **Java 15.0.1**.

### Poin Penting:
1. **Pondasi Awal:** SIMRS-Khanza awalnya dibangun dan didesain secara native di atas **Java 8 (JDK 1.8)**.
2. **Java 9+ (Modul & Enkapsulasi):** Pada Java 9 ke atas (termasuk Java 15), sistem modul (*Project Jigsaw*) diberlakukan secara ketat dan beberapa modul bawaan seperti JAXB dihapus dari JDK standar.
3. **Kondisi Saat Ini:** Folder `lib/` yang disalin telah memiliki pustaka penyesuaian seperti `jaxb-api-2.3.0.jar` dan library tema `flatlaf`, sehingga aplikasi **dapat dicompile dan dijalankan**.
4. **Rekomendasi Pemeliharaan:** Jika suatu saat ditemui *runtime error* (khususnya *IllegalAccessError* atau kegagalan kompilasi JasperReports/grafik), solusi paling stabil adalah memasang JDK 8 (`brew install --cask temurin@8`).

---

## 6. Panduan Setup dari Titik Nol di macOS (Bare Metal ke VSCode)

Berikut adalah panduan lengkap dari komputer Mac yang benar-benar bersih (*clean slate*):

### Tahap 1: Package Manager (Homebrew) & Xcode Tools
```bash
# 1. Install Command Line Tools
xcode-select --install

# 2. Install Homebrew (jika belum ada)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Tahap 2: Instalasi JDK & Konfigurasi PATH
```bash
# Install Eclipse Temurin JDK 8 (atau temurin untuk versi modern)
brew install --cask temurin@8
```

Tambahkan environment variable ke file `~/.zshrc`:
```bash
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

Verifikasi instalasi:
```bash
java -version
javac -version
```

### Tahap 3: Instalasi Apache Ant
```bash
brew install ant
ant -version
```

### Tahap 4: Database Server (MySQL / MariaDB)
* **Opsi XAMPP:** Nyalakan MySQL Database melalui XAMPP Control Panel (Port: 3306, User: `root`, Password kosong).
* **Opsi Homebrew Native:**
  ```bash
  brew install mysql
  brew services start mysql
  ```

### Tahap 5: Setup VSCode & Extensions
1. Pasang Visual Studio Code.
2. Buka menu Extensions (`Cmd + Shift + X`), lalu pasang:
   * **Extension Pack for Java** (by Microsoft).
   * **Apache Ant for Visual Studio Code** (opsional).

### Tahap 6: Clone Project & Penyiapan Berkas
```bash
# 1. Clone repository
cd ~/MyFiles/Projects
git clone https://github.com/mas-elkhanza/SIMRS-Khanza.git
cd SIMRS-Khanza

# 2. Salin folder lib fisik
cp -r /Applications/XAMPP/xamppfiles/htdocs/KhanzaHMSMac/lib ./lib

# 3. Import Database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS sik;"
mysql -u root -p sik < sik.sql
```

### Tahap 7: Konfigurasi Workspace VS Code (`.vscode`)

Pastikan file `.vscode/settings.json` berisi konfigurasi berikut:
```json
{
  "java.project.sourcePaths": [
    "src"
  ],
  "java.project.referencedLibraries": [
    "lib/**/*.jar"
  ],
  "java.jdt.ls.vmargs": "-XX:+UseG1GC -Xms1G -Xmx4G",
  "java.import.gradle.enabled": false,
  "java.import.maven.enabled": false
}
```

Dan file `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Ant: Compile",
      "type": "shell",
      "command": "ant compile",
      "problemMatcher": ["$javac"]
    },
    {
      "label": "Ant: Run",
      "type": "shell",
      "command": "ant run",
      "problemMatcher": ["$javac"]
    },
    {
      "label": "Ant: Clean & Build JAR",
      "type": "shell",
      "command": "ant clean jar",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": ["$javac"]
    }
  ]
}
```

---

## 7. Alur Eksekusi & Troubleshooting Umum

### Cara Menjalankan Aplikasi:
1. Melalui Terminal:
   ```bash
   ant compile
   ant run
   ```
2. Melalui VSCode Task:
   * Tekan `Cmd + Shift + P` $\rightarrow$ pilih **Tasks: Run Task** $\rightarrow$ pilih **Ant: Run**.

### Masalah Umum & Solusi:

1. **Gagal Koneksi Database saat Running (`Gagal koneksi ke database. Sisa percobaan: ...`)**:
   * Periksa apakah server MySQL sedang aktif di port 3306.
   * Pastikan nama database adalah `sik`.
   * Cek file `setting/database.xml`. Jika password MySQL Anda bukan kosong, perbarui enkripsi AES pada tag `<entry key="PAS">`.
2. **Class Not Found / Symbol Not Found pada VSCode**:
   * Buka Command Palette (`Cmd + Shift + P`) $\rightarrow$ ketik `Java: Clean Java Language Server Workspace` $\rightarrow$ pilih **Restart and Clean**.
3. **Tombol NetBeans GUI (`.form`) Tidak Sinkron**:
   * Jika menambahkan komponen baru secara manual di file `.java`, pastikan Anda tidak merusak blok penanda `// <editor-fold defaultstate="collapsed" desc="Generated Code">` jika form tersebut masih ingin dibuka di NetBeans GUI Builder.

---

## 8. Roadmap Pembelajaran Fitur & Modifikasi

```
[Level 1: CRUD Sederhana]
  └── Mempelajari DlgBangsal.java / DlgKabupaten.java
  └── Memahami alur: Input Field ──> Validasi ──> Sequel.menyimpan() ──> Refresh JTable

[Level 2: Alur Pasien & Pelayanan Klinis]
  └── Master Pasien (DlgPasien.java)
  └── Registrasi Pasien (DlgReg.java)
  └── Pelayanan Rawat Jalan & SOAP (DlgRawatJalan.java & RME)

[Level 3: Transaksi & Integrasi Lintas Modul]
  └── Resep Farmasi & Pengurangan Stok (DlgInputResepPulang.java / inventory)
  └── Billing & Kasir Pasien (DlgKasirRalan.java / DlgKamarInap.java)

[Level 4: Custom Reporting & Bridging API]
  └── Modifikasi template cetakan (.jrxml) dengan Jaspersoft Studio
  └── Integrasi Web Service Bridging (BPJS VClaim / SatuSehat) di package src/bridging/
```
