-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 27, 2025 at 03:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `apt2`
--

-- --------------------------------------------------------

--
-- Table structure for table `batch_obat`
--

CREATE TABLE `batch_obat` (
  `id_batch` int(11) NOT NULL,
  `id_obat` int(11) NOT NULL,
  `id_pemasok` int(11) DEFAULT NULL,
  `no_batch` varchar(50) NOT NULL,
  `tgl_kedaluwarsa` date NOT NULL,
  `harga_beli` decimal(12,2) NOT NULL,
  `harga_jual` decimal(12,2) NOT NULL,
  `stok_awal` int(11) NOT NULL,
  `stok_tersedia` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `batch_obat`
--

INSERT INTO `batch_obat` (`id_batch`, `id_obat`, `id_pemasok`, `no_batch`, `tgl_kedaluwarsa`, `harga_beli`, `harga_jual`, `stok_awal`, `stok_tersedia`) VALUES
(1, 3, 2, 'CET-14-11', '2027-11-16', 15000.00, 12000.00, 0, 250),
(2, 2, 1, 'AMB-14-11', '2026-11-14', 14500.00, 16000.00, 0, 200),
(3, 3, 1, 'CET-17-11', '2027-11-01', 14000.00, 15000.00, 250, 350),
(4, 1, 5, 'PAR-26-11', '2030-11-26', 10000.00, 10500.00, 0, 180),
(5, 2, 2, 'AMB-28-11', '2029-11-21', 20000.00, 21000.00, 200, 300);

--
-- Triggers `batch_obat`
--
DELIMITER $$
CREATE TRIGGER `rollback_stok_batch` AFTER DELETE ON `batch_obat` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = stok - OLD.stok_tersedia
  WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_stok_batch` AFTER INSERT ON `batch_obat` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = NEW.stok_tersedia
  WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_stok_batch` AFTER UPDATE ON `batch_obat` FOR EACH ROW BEGIN
  DECLARE selisih INT;
  SET selisih = NEW.stok_tersedia - OLD.stok_tersedia;

  UPDATE obat
  SET stok = stok + selisih
  WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_obat` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `subtotal` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail`, `id_transaksi`, `id_obat`, `jumlah`, `subtotal`) VALUES
(1, 1, 3, 250, 0);

--
-- Triggers `detail_transaksi`
--
DELIMITER $$
CREATE TRIGGER `kurang_stok_transaksi` AFTER INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = stok - NEW.jumlah
  WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `rollback_stok_transaksi` AFTER DELETE ON `detail_transaksi` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = stok + OLD.jumlah
  WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_stok_transaksi` AFTER UPDATE ON `detail_transaksi` FOR EACH ROW BEGIN
  DECLARE selisih INT;
  SET selisih = NEW.jumlah - OLD.jumlah;

  UPDATE obat
  SET stok = stok - selisih
  WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` int(11) NOT NULL,
  `nama_obat` varchar(100) NOT NULL,
  `bentuk` varchar(50) NOT NULL,
  `kandungan` varchar(150) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `kategori` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama_obat`, `bentuk`, `kandungan`, `satuan`, `kategori`, `stok`) VALUES
(1, 'Paracetamol 500mg', 'Tablet', 'Obat Pereda Demam', 'Strip', 'Generik', 180),
(2, 'Ambroxol', 'Sirup', 'Batuk Flu', 'Botol', 'Generik', 300),
(3, 'Cetirizine', 'Tablet', 'Antihistamin', 'Strip', 'Paten', 350),
(6, 'Ranitidine', 'Tablet', 'Asam Lambung', 'Strip', 'Paten', 0);

-- --------------------------------------------------------

--
-- Table structure for table `pemasok`
--

CREATE TABLE `pemasok` (
  `id_pemasok` int(11) NOT NULL,
  `nama_pemasok` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `kontak` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemasok`
--

INSERT INTO `pemasok` (`id_pemasok`, `nama_pemasok`, `alamat`, `kontak`) VALUES
(1, 'PT Kimia Farma Trading', 'Jl. Veteran No. 10, Jakarta', '0215678901'),
(2, 'PT Hexpharm Jaya', 'Jl. Industri No. 7, Bekasi', '0215678902'),
(3, 'PT Sanbe Farma', 'Jl. Soekarno Hatta No. 88, Bandung', '0225678904'),
(5, 'PT Soho Global Health', 'Jl. Pulogadung Industrial Estate, Jakarta', 'soho@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id_staff` int(11) NOT NULL,
  `nama_staff` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id_staff`, `nama_staff`, `username`, `password`) VALUES
(1, 'Andi Saputra', 'Andi S', '$2y$10$KmcmhNrMtMp4IPyGxuRikuM2U6tvq7NBf7eEDg4SxpQDDFnryzOYG'),
(2, 'Siti Rahmawati', 'Siti R', '$2y$10$jJSBSbZKkzD8z4QP/YyM2uJdC/ik7j4Fvyp4yjzWZFl89c/uh7/0e'),
(3, 'Dewi Lestari', 'Dewi L', '$2y$10$H8pJ5xDB6cgUKeKp22cm2u8hP53ZvPiyVXNw6LUETqJ/UlpAKjWBe'),
(5, 'Fajar Nugraha', 'Fajar N', '$2y$10$pxxMtU1AmqcC8OkLjjZ.N.DqAsPQsRn.bh70UX30PMmB0O2vEaoKS');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `tgl_transaksi` date NOT NULL,
  `id_staff` int(11) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `tgl_transaksi`, `id_staff`, `keterangan`) VALUES
(1, '2025-11-14', 2, 'Obat Cetirizine Keluar Per Tanggal Sekian');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `batch_obat`
--
ALTER TABLE `batch_obat`
  ADD PRIMARY KEY (`id_batch`),
  ADD KEY `fk_batch_obat` (`id_obat`),
  ADD KEY `idx_batch_no` (`no_batch`),
  ADD KEY `fk_pemasok` (`id_pemasok`);

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`),
  ADD KEY `idx_obat_nama` (`nama_obat`);

--
-- Indexes for table `pemasok`
--
ALTER TABLE `pemasok`
  ADD PRIMARY KEY (`id_pemasok`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id_staff`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_staff` (`id_staff`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `batch_obat`
--
ALTER TABLE `batch_obat`
  MODIFY `id_batch` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `obat`
--
ALTER TABLE `obat`
  MODIFY `id_obat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pemasok`
--
ALTER TABLE `pemasok`
  MODIFY `id_pemasok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id_staff` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `batch_obat`
--
ALTER TABLE `batch_obat`
  ADD CONSTRAINT `fk_batch_obat` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`),
  ADD CONSTRAINT `fk_pemasok` FOREIGN KEY (`id_pemasok`) REFERENCES `pemasok` (`id_pemasok`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_fk_obat` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_transaksi_fk_transaksi` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_staff`) REFERENCES `staff` (`id_staff`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
