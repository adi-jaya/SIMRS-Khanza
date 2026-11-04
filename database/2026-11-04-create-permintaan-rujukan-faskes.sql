-- SQL Script: Pembuatan Tabel permintaan_rujukan_faskes
-- Database: sik (SIMRS Khanza)
-- Tanggal: 2026-11-04
-- Kebutuhan: Modul Permintaan Rujukan Faskes (Web Official & SIMRS Khanza)

CREATE TABLE IF NOT EXISTS `permintaan_rujukan_faskes` (
  `no_rujukan` varchar(20) NOT NULL COMMENT 'Format: RF-YYYYMMDD-XXXX',
  `tanggal_rujukan` date NOT NULL,
  `jam_rujukan` time NOT NULL,
  `nama_fktp` varchar(100) NOT NULL,
  `nama_perujuk` varchar(60) NOT NULL COMMENT 'Nama dokter/bidan/perawat FKTP',
  `no_telp_perujuk` varchar(20) NOT NULL COMMENT 'No WA/HP kontak perujuk',
  `nama_pasien` varchar(100) NOT NULL,
  `no_ktp` varchar(20) NOT NULL COMMENT 'NIK 16 digit',
  `jk` enum('L','P') NOT NULL,
  `tgl_lahir` date DEFAULT NULL,
  `umur` varchar(15) DEFAULT NULL COMMENT 'Contoh: 35 Th / 6 Bl',
  `no_telp_pasien` varchar(20) DEFAULT NULL,
  `diagnosa` text NOT NULL COMMENT 'Diagnosa kerja/awal perujuk',
  `keluhan_utama` text DEFAULT NULL COMMENT 'Keluhan & alasan rujukan',
  `tanda_vital_kesadaran` varchar(30) DEFAULT NULL COMMENT 'Compos Mentis / Apatis / Somnolen / Sopor / Koma',
  `tanda_vital_td` varchar(15) DEFAULT NULL COMMENT 'Tekanan Darah, misal: 120/80',
  `tanda_vital_nadi` varchar(10) DEFAULT NULL COMMENT 'x/menit',
  `tanda_vital_rr` varchar(10) DEFAULT NULL COMMENT 'x/menit',
  `tanda_vital_suhu` varchar(10) DEFAULT NULL COMMENT 'Derajat celcius',
  `tanda_vital_spo2` varchar(10) DEFAULT NULL COMMENT 'Saturasi O2 (%)',
  `tindakan_diberikan` text DEFAULT NULL COMMENT 'Terapi, oksigen, obat yang sudah diberi',
  `transportasi` varchar(50) DEFAULT NULL COMMENT 'Ambulans FKTP / Mobil Pribadi / dll',
  `kebutuhan_khusus` varchar(100) DEFAULT NULL COMMENT 'Resusitasi / Isolasi / Inkubator / Oksigen Lanjutan',
  `estimasi_tiba` varchar(50) DEFAULT NULL COMMENT 'Contoh: 15 menit / Pukul 17:30',
  `status` enum('Menunggu','Sudah Datang','Batal') NOT NULL DEFAULT 'Menunggu',
  `catatan_igd` text DEFAULT NULL COMMENT 'Catatan tindak lanjut petugas IGD',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`no_rujukan`),
  KEY `idx_tgl_status` (`tanggal_rujukan`, `status`),
  KEY `idx_no_ktp` (`no_ktp`),
  KEY `idx_nama_pasien` (`nama_pasien`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
