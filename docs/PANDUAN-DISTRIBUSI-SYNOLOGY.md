# Panduan Strategi Distribusi & Sinkronisasi Source Code SIMRS-Khanza (via Synology)

Dokumen ini memuat panduan efisien untuk mentransfer pembaruan fitur (source code & database) dari komputer development lokal ke komputer utama (komputer build / distribusi rumah sakit) tanpa tergantung pada remote repository publik (GitHub/GitLab), dengan memanfaatkan penyimpanan bersama Synology NAS.

---

## Ringkasan Masalah

- Repositori lokal `SIMRS-Khanza` pada komputer development tidak dapat melakukan `git push` ke remote publik dan komputer utama tidak dapat melakukan `git pull`.
- Di komputer development, perubahan sering berada di staging area.
- Jika perubahan dipindahkan dengan cara copy-paste manual satu per satu:
  - Berisiko tinggi terjadi file tertinggal (*missing files*).
  - Berisiko salah meletakkan direktori package (`src/permintaan`, `src/simrskhanza`, dll).
  - Berisiko menimpa (*overwrite*) kode lain yang sedang dikembangkan di komputer utama secara tidak sengaja.

---

## Opsi 1: Paket Ekspor Otomatis (*Deployment Bundle Zip*) — Direkomendasikan ⭐

Metode ini paling aman, praktis, dan tidak memerlukan pemahaman Git di komputer utama.

### 1. Struktur Bundle yang Dihasilkan
Skrip otomasi akan mengekstrak hanya file yang ditambahkan/diubah dan mengemasnya dalam satu file `deploy-rujukan-faskes.zip` dengan struktur direktori yang identik dengan root SIMRS-Khanza:
```text
deploy-rujukan-faskes/
├── src/
│   ├── permintaan/
│   │   ├── DlgPermintaanRujukanFaskes.java
│   │   └── DlgPermintaanRujukanFaskes.form
│   ├── simrskhanza/
│   │   └── frmUtama.java
│   └── fungsi/
│       └── akses.java
├── database/
│   └── 2026-11-04-create-permintaan-rujukan-faskes.sql
└── INSTRUKSI_DEPLOY.txt
```

### 2. Skrip Otomasi Ekspor (`scripts/export-rujukan.ps1`)
Di komputer development, cukup jalankan skrip PowerShell berikut:
```powershell
# Jalankan di direktori SIMRS-Khanza
$targetZip = "deploy-rujukan-faskes.zip"
$tempDir = "temp_deploy_rujukan"

# Bersihkan direktori temp lama jika ada
if (Test-Path $tempDir) { Remove-Item -Recurse -Force $tempDir }
New-Item -ItemType Directory -Path "$tempDir\src\permintaan" -Force
New-Item -ItemType Directory -Path "$tempDir\src\simrskhanza" -Force
New-Item -ItemType Directory -Path "$tempDir\src\fungsi" -Force
New-Item -ItemType Directory -Path "$tempDir\database" -Force

# Salin file baru & modifikasi
Copy-Item "src\permintaan\DlgPermintaanRujukanFaskes.*" "$tempDir\src\permintaan\" -Force
Copy-Item "src\simrskhanza\frmUtama.java" "$tempDir\src\simrskhanza\" -Force
Copy-Item "src\fungsi\akses.java" "$tempDir\src\fungsi\" -Force
Copy-Item "database\2026-11-04-create-permintaan-rujukan-faskes.sql" "$tempDir\database\" -Force

# Kompres ke ZIP
Compress-Archive -Path "$tempDir\*" -DestinationPath $targetZip -Force
Remove-Item -Recurse -Force $tempDir

Write-Host "Paket deployment berhasil dibuat: $targetZip" -ForegroundColor Green
```

### 3. Langkah di Komputer Utama:
1. Salin `deploy-rujukan-faskes.zip` dari Synology.
2. Ekstrak langsung file zip tersebut ke dalam folder utama `SIMRS-Khanza`.
3. Buka Navicat / HeidiSQL / DBeaver yang terhubung ke database `sik`, lalu jalankan skrip `database\2026-11-04-create-permintaan-rujukan-faskes.sql`.
4. Buka NetBeans / IDE di komputer utama, lakukan *Clean & Build*, lalu uji coba modul baru.

---

## Opsi 2: Menggunakan Git Binary Patch (`git diff --binary`)

Gunakan opsi ini jika di komputer utama terpasang Git (meskipun tidak memiliki remote/koneksi internet).

### 1. Di Komputer Development:
Jalankan perintah untuk membuat satu file patch biner yang memuat seluruh perubahan kode dan file GUI NetBeans (`.form`):
```powershell
git diff --binary HEAD > rujukan-faskes.patch
```
*Catatan: Jika file baru belum di-track oleh git, lakukan `git add -N .` terlebih dahulu sebelum membuat patch.*

Salin file `rujukan-faskes.patch` ke Synology.

### 2. Di Komputer Utama:
1. Salin `rujukan-faskes.patch` dari Synology ke folder root `SIMRS-Khanza`.
2. Buka Git Bash / Terminal di folder tersebut, lalu periksa apakah patch dapat diaplikasikan tanpa konflik:
   ```bash
   git apply --check rujukan-faskes.patch
   ```
3. Jika tidak ada error, terapkan patch:
   ```bash
   git apply rujukan-faskes.patch
   ```
4. Semua file baru dan modifikasi baris kode otomatis terpasang dengan presisi 100%.

---

## Opsi 3: Menjadikan Synology sebagai Git Remote Lokal (Bare Repository)

Gunakan opsi ini untuk solusi jangka panjang jika ingin kedua komputer bisa `push` dan `pull` secara normal melalui jaringan LAN tanpa internet.

### 1. Setup di Synology:
Buat folder bersama di Synology (misal: `\\synology\repo\simrs-khanza.git` atau dipetakan ke network drive `Z:\repo\simrs-khanza.git`), lalu inisialisasi sebagai bare repository:
```bash
git init --bare Z:\repo\simrs-khanza.git
```

### 2. Di Komputer Development:
Tambahkan remote yang mengarah ke Synology:
```powershell
git remote add synology "Z:\repo\simrs-khanza.git"
# atau path UNC network:
git remote add synology "//synology/repo/simrs-khanza.git"

# Push perubahan ke Synology
git push synology master
```

### 3. Di Komputer Utama:
Tambahkan remote yang sama di komputer utama:
```powershell
git remote add synology "//synology/repo/simrs-khanza.git"

# Ambil pembaruan langsung dari Synology
git pull synology master
```

---

## Rekomendasi Alur untuk Fitur Permintaan Rujukan FASKES
Untuk pengerjaan fitur ini, kita akan menggunakan **Opsi 1**:
- Selama implementasi, perubahan dibuat dan diuji di komputer ini.
- Di akhir implementasi, kita sertakan skrip `export-rujukan.ps1` dan file SQL migrasi yang siap dijalankan.
- Anda cukup meng-copy paket zip hasil ekspor ke Synology dan mengekstraknya di komputer utama.
