-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 02, 2025 at 08:16 AM
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
(2, 4, 1, 'BCH-2025-1', '2027-11-01', 12000.00, 13000.00, 0, 80);

--
-- Triggers `batch_obat`
--
DELIMITER $$
CREATE TRIGGER `after_batch_delete` AFTER DELETE ON `batch_obat` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = (
    SELECT COALESCE(SUM(stok_tersedia), 0)
    FROM batch_obat
    WHERE id_obat = OLD.id_obat
  )
  WHERE id_obat = OLD.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_batch_insert` AFTER INSERT ON `batch_obat` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = (
    SELECT COALESCE(SUM(stok_tersedia), 0)
    FROM batch_obat
    WHERE id_obat = NEW.id_obat
  )
  WHERE id_obat = NEW.id_obat;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_batch_update` AFTER UPDATE ON `batch_obat` FOR EACH ROW BEGIN
  UPDATE obat
  SET stok = (
    SELECT COALESCE(SUM(stok_tersedia), 0)
    FROM batch_obat
    WHERE id_obat = NEW.id_obat
  )
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
  `id_batch` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `subtotal` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail`, `id_transaksi`, `id_batch`, `jumlah`, `subtotal`) VALUES
(4, 4, 2, 10, 130000);

--
-- Triggers `detail_transaksi`
--
DELIMITER $$
CREATE TRIGGER `kurang_stok_obat` BEFORE INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
  DECLARE v_stok INT;
  DECLARE v_id_obat INT;

  SELECT stok_tersedia, id_obat INTO v_stok, v_id_obat
  FROM batch_obat
  WHERE id_batch = NEW.id_batch;

  IF v_stok < NEW.jumlah THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = '❌ Stok batch tidak mencukupi!';
  ELSE
    UPDATE batch_obat
    SET stok_tersedia = stok_tersedia - NEW.jumlah
    WHERE id_batch = NEW.id_batch;

    UPDATE obat
    SET stok = stok - NEW.jumlah
    WHERE id_obat = v_id_obat;
  END IF;
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
(2, 'Tolak Angin Cair', 'Sirup', 'Untuk meredakan masuk angin dan meningkatkan daya tahan tubuh', 'Tube', 'Herbal', 0),
(4, 'Paracetamol 500mg', 'Tablet', 'Untuk menurunkan demam dan meredakan nyeri ringan', 'Strip', 'Generik', 80),
(5, 'Amoxicillin 400mg', 'Kapsul', 'Untuk mengobati infeksi bakteri seperti infeksi saluran pernapasan dan telinga', 'Strip', 'Generik', 0),
(7, 'tesa', 'Kapsul', 'e', 'Strip', 'Generik', 0),
(8, 'Milanta', 'Sirup', 'Obat Pereda Magh', 'Botol', 'Generik', 0);

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
(1, 'PT. Jaya Sehat Sejahtera', 'Jl.Jatiwaringin No.2 Bekasi', 'jayasehat@gmail.com'),
(3, 'PT. Sinar Sehat', 'Jl. Meruya Jakarta Barat No.8', 'sinar@gmail.com'),
(4, 'PT Sanbe Farma', 'Jl. Industri No. 10, Bandung', 'contact@sanbefarma.com'),
(5, 'CV Herbalindo Nusantara', 'Jl. Raya Sukabumi No. 15, Bogor', 'cs@herbalindo.co.id'),
(7, 'PT. Healthy Jaya 1', 'Jl. Sejahtera Jatiwaringin No.21', 'hekthy@gmail.com');

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
(1, 'Andi Pratama', 'andi.pr', '$2y$10$X3rUWXU6yCd/dIr3tfI5E.QmS2BTvr4.SxM9.cfdJEPs1K/nFw4b6'),
(2, 'Ayuna Putri', 'ayput', '$2y$10$0kFEtdUisZrMJuX0aBDQruUsnp4Qt8z8nKlcQBgeJGtoHf5yOmdvG'),
(4, 'Siti Rahmawati', 'siti', '$2y$10$mbBRpWC8/VzJeTZaVrKbvO1hNESqOK5VETj.DcAa8YRCJKQLTXHmC'),
(5, 'Dewi Lestari', 'dewi', '$2y$10$u/r/gASJqjspwm7pRZiAJOkE8AUjnykr/uLZcCPVVWKTC4w117FKK'),
(6, 'Khoirunnisa Caca', 'caca', '$2y$10$yogrnBv1aTds/dh1Zw7FmuPlQzzFsR7GQbIgsYr/l.zO0/3H/xDzO'),
(8, 'Hafiza Bilqis', 'hafida', '$2y$10$OlWtuO.RrK5vH4k7oGj.RePDZWT9Uh4NXEMvsGbO57IV77LEEj9Yi');

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
(4, '2025-10-31', 6, 'Pengeluaran Tanggal 10');

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
  ADD KEY `id_batch` (`id_batch`);

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
  MODIFY `id_batch` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `obat`
--
ALTER TABLE `obat`
  MODIFY `id_obat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pemasok`
--
ALTER TABLE `pemasok`
  MODIFY `id_pemasok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id_staff` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_batch`) REFERENCES `batch_obat` (`id_batch`) ON DELETE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_staff`) REFERENCES `staff` (`id_staff`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
