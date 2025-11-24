-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2025 at 03:00 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ime`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`, `deleted_at`) VALUES
('cyra.cacho@gmail.com|127.0.0.1', 'i:1;', 1759505193, NULL),
('cyra.cacho@gmail.com|127.0.0.1:timer', 'i:1759505193;', 1759505193, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campuses`
--

CREATE TABLE `campuses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `campus` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `campuses`
--

INSERT INTO `campuses` (`id`, `campus`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2, 'Echague', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(3, 'Cabagan', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(4, 'Cauayan', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(5, 'Ilagan', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(6, 'Roxas', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(7, 'Angadanan', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(8, 'Jones', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(9, 'San Mateo', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL),
(10, 'San Mariano', '2025-06-06 10:28:06', '2025-06-06 10:28:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `creditors`
--

CREATE TABLE `creditors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expenses_id` bigint(20) UNSIGNED DEFAULT NULL,
  `creditor_name` varchar(255) DEFAULT NULL,
  `reference_date` date DEFAULT NULL,
  `reference_serial_number` varchar(255) DEFAULT NULL,
  `utilization` decimal(10,2) DEFAULT 0.00,
  `disbursements` decimal(10,2) DEFAULT 0.00,
  `uu_due_and_demandable` decimal(10,2) DEFAULT 0.00,
  `uu_not_yet_due_and_demandable` decimal(10,2) DEFAULT 0.00,
  `check_number` varchar(255) DEFAULT NULL,
  `check_date` date DEFAULT NULL,
  `particulars` text DEFAULT NULL,
  `total_mooe` decimal(10,2) DEFAULT 0.00,
  `total_co` decimal(10,2) DEFAULT 0.00,
  `overall_total` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `creditors`
--

INSERT INTO `creditors` (`id`, `expenses_id`, `creditor_name`, `reference_date`, `reference_serial_number`, `utilization`, `disbursements`, `uu_due_and_demandable`, `uu_not_yet_due_and_demandable`, `check_number`, `check_date`, `particulars`, `total_mooe`, `total_co`, `overall_total`, `created_at`, `updated_at`, `updated_by`, `deleted_at`) VALUES
(4, 1, 'Juan Dela Cruz', '2025-10-13', '123456789', 12000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 12000.00, 0.00, 12000.00, '2025-10-12 09:42:27', '2025-10-12 09:42:27', 4, NULL),
(5, 1, 'Anna Garcia', '2025-10-13', '12345', 25000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 0.00, 25000.00, 25000.00, '2025-10-12 09:46:24', '2025-10-12 09:46:24', 4, NULL),
(6, 1, 'Anna Garcia', '2025-01-02', '12345', 6000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 1000.00, 5000.00, 6000.00, '2025-10-12 23:12:25', '2025-10-12 23:12:25', 4, NULL),
(7, 50, 'Test Name', '2025-10-24', '12345', 10000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 10000.00, 0.00, 10000.00, '2025-10-23 21:27:57', '2025-10-23 21:27:57', 8, NULL),
(8, 50, 'Test 3', '2025-10-24', '12345', 12000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 0.00, 12000.00, 12000.00, '2025-10-23 21:33:24', '2025-10-23 21:33:24', 8, NULL),
(9, 50, 'Anna Garcia', '2025-01-23', '12345', 15000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 5000.00, 10000.00, 15000.00, '2025-10-23 21:42:29', '2025-10-23 21:42:29', 8, NULL),
(10, 50, 'Test Name', '2025-02-12', NULL, 5000.00, 0.00, 0.00, 0.00, NULL, NULL, 'Test particular', 5000.00, 0.00, 5000.00, '2025-10-23 21:44:39', '2025-10-23 21:44:39', 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `creditor_has_uacs`
--

CREATE TABLE `creditor_has_uacs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `creditor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `uacs_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `creditor_has_uacs`
--

INSERT INTO `creditor_has_uacs` (`id`, `creditor_id`, `uacs_id`, `amount`, `created_at`, `updated_at`, `updated_by`, `deleted_at`) VALUES
(6, 4, 23, 10000.00, '2025-10-12 09:42:27', '2025-10-12 09:42:27', 4, NULL),
(7, 4, 24, 2000.00, '2025-10-12 09:42:27', '2025-10-12 09:42:27', 4, NULL),
(8, 5, 29, 25000.00, '2025-10-12 09:46:24', '2025-10-12 09:46:24', 4, NULL),
(9, 6, 30, 5000.00, '2025-10-12 23:12:25', '2025-10-12 23:12:25', 4, NULL),
(10, 6, 25, 1000.00, '2025-10-12 23:12:25', '2025-10-12 23:12:25', 4, NULL),
(11, 7, 23, 10000.00, '2025-10-23 21:27:57', '2025-10-23 21:27:57', 8, NULL),
(12, 8, 29, 12000.00, '2025-10-23 21:33:24', '2025-10-23 21:33:24', 8, NULL),
(13, 9, 23, 5000.00, '2025-10-23 21:42:29', '2025-10-23 21:42:29', 8, NULL),
(14, 9, 29, 10000.00, '2025-10-23 21:42:29', '2025-10-23 21:42:29', 8, NULL),
(15, 10, 25, 5000.00, '2025-10-23 21:44:39', '2025-10-23 21:44:39', 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `designations`
--

CREATE TABLE `designations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `designation` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `enterprises`
--

CREATE TABLE `enterprises` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `enterprise` varchar(255) NOT NULL,
  `category` enum('Agri-based','Non agri-based') NOT NULL,
  `inventory` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enterprises`
--

INSERT INTO `enterprises` (`id`, `campus_id`, `user_id`, `enterprise`, `category`, `inventory`, `created_at`, `updated_at`, `updated_by`, `deleted_at`) VALUES
(1, 4, 4, 'CORN PRODUCTION', 'Agri-based', 1, '2025-07-21 15:36:48', '2025-07-21 15:36:48', NULL, NULL),
(2, 4, 4, 'PE UNIFORM', 'Non agri-based', 0, '2025-07-21 15:37:01', '2025-07-21 15:37:01', NULL, NULL),
(3, 4, 4, 'VAN RENTAL', 'Non agri-based', 0, '2025-07-21 15:37:08', '2025-07-21 15:37:08', NULL, NULL),
(4, 4, 4, 'ID LACE', 'Non agri-based', 0, '2025-07-29 09:45:51', '2025-07-29 09:45:51', NULL, NULL),
(5, 4, 4, 'RICE PROJECT', 'Agri-based', 0, '2025-08-12 10:10:58', '2025-08-12 10:10:58', NULL, NULL),
(6, 2, 4, 'Advertising Billboard', 'Non agri-based', 0, '2025-10-05 05:12:16', '2025-10-05 05:12:16', NULL, NULL),
(7, 2, 4, 'Amphitheater Rental', 'Non agri-based', 0, '2025-10-05 05:13:03', '2025-10-05 05:13:03', NULL, NULL),
(8, 2, 4, 'Biazon Hostel Rental', 'Non agri-based', 0, '2025-10-05 05:13:35', '2025-10-05 05:13:35', NULL, NULL),
(9, 2, 4, 'Cap and Gown (Deposit/Refund)', 'Non agri-based', 0, '2025-10-05 05:14:25', '2025-10-05 05:14:25', NULL, NULL),
(10, 2, 4, 'Cap and Gown Rental', 'Non agri-based', 1, '2025-10-05 05:14:46', '2025-10-05 05:14:46', NULL, NULL),
(11, 2, 4, 'Carabao CBAO', 'Agri-based', 0, '2025-10-05 05:15:22', '2025-10-05 05:15:22', NULL, NULL),
(12, 2, 4, 'Carabao Stud Farm', 'Agri-based', 0, '2025-10-05 05:15:43', '2025-10-05 05:15:43', NULL, NULL),
(13, 2, 4, 'CAS Reference/Book', 'Non agri-based', 0, '2025-10-05 05:16:08', '2025-10-05 05:16:08', NULL, NULL),
(14, 2, 4, 'CBAO Bamboo', 'Agri-based', 0, '2025-10-05 05:16:28', '2025-10-05 05:16:28', NULL, NULL),
(15, 2, 4, 'CBAO Training', 'Non agri-based', 0, '2025-10-05 05:16:51', '2025-10-05 05:16:51', NULL, NULL),
(16, 2, 4, 'Computerized ID', 'Non agri-based', 1, '2025-10-05 05:17:24', '2025-10-05 05:17:24', NULL, NULL),
(17, 2, 4, 'De Venecia Rental', 'Non agri-based', 0, '2025-10-05 05:17:52', '2025-10-05 05:17:52', NULL, NULL),
(18, 2, 4, 'Desktop Publishing Center', 'Non agri-based', 0, '2025-10-05 05:18:13', '2025-10-05 05:18:13', NULL, NULL),
(19, 2, 4, 'Dragon Fruit', 'Agri-based', 0, '2025-10-05 05:18:34', '2025-10-05 05:18:34', NULL, NULL),
(20, 2, 4, 'Fishpond Rental', 'Non agri-based', 0, '2025-10-05 05:18:56', '2025-10-05 05:18:56', NULL, NULL),
(21, 2, 4, 'Foodcourt/Stall Rental', 'Non agri-based', 0, '2025-10-05 05:19:22', '2025-10-05 05:19:22', NULL, NULL),
(22, 2, 4, 'Foodcourt/Stall Water Bill', 'Non agri-based', 0, '2025-10-05 05:20:10', '2025-10-05 05:20:10', NULL, NULL),
(23, 2, 4, 'Gatepass Sticker (New)/Share', 'Non agri-based', 1, '2025-10-05 05:20:46', '2025-10-05 05:20:46', NULL, NULL),
(24, 2, 4, 'Guesthouse', 'Non agri-based', 0, '2025-10-05 05:21:01', '2025-10-05 05:21:01', NULL, NULL),
(25, 2, 4, 'Hostel Manila', 'Non agri-based', 0, '2025-10-05 05:21:18', '2025-10-05 05:21:18', NULL, NULL),
(26, 2, 4, 'HVC CBAO', 'Non agri-based', 0, '2025-10-05 05:21:34', '2025-10-05 05:21:34', NULL, NULL),
(27, 2, 4, 'Land Rental', 'Non agri-based', 0, '2025-10-05 05:22:08', '2025-10-05 05:22:08', NULL, NULL),
(28, 2, 4, 'Marketing Center E-Bill', 'Non agri-based', 0, '2025-10-05 05:22:29', '2025-10-05 05:22:29', NULL, NULL),
(29, 2, 4, 'Meat Processing', 'Non agri-based', 0, '2025-10-05 05:22:45', '2025-10-05 05:22:45', NULL, NULL),
(30, 2, 4, 'Miscellaneous Income', 'Non agri-based', 0, '2025-10-05 05:23:01', '2025-10-05 05:23:01', NULL, NULL),
(31, 2, 4, 'New Dormitories (Staff Housing)', 'Non agri-based', 0, '2025-10-05 05:23:24', '2025-10-05 05:23:24', NULL, NULL),
(32, 2, 4, 'NPGC Rental', 'Non agri-based', 0, '2025-10-05 05:23:54', '2025-10-05 05:23:54', NULL, NULL),
(33, 2, 4, 'NSTP T-Shirt Share', 'Non agri-based', 1, '2025-10-05 05:24:14', '2025-10-05 05:24:14', NULL, NULL),
(34, 2, 4, 'Orchard (Mango) Production', 'Agri-based', 0, '2025-10-05 05:24:42', '2025-10-05 05:24:42', NULL, NULL),
(35, 2, 4, 'Overhead Cost', 'Non agri-based', 0, '2025-10-05 05:24:58', '2025-10-05 05:24:58', NULL, NULL),
(36, 2, 4, 'Palayamanan', 'Non agri-based', 0, '2025-10-05 05:25:20', '2025-10-05 05:25:20', NULL, NULL),
(37, 2, 4, 'Pasada', 'Non agri-based', 0, '2025-10-05 05:25:35', '2025-10-05 05:25:35', NULL, NULL),
(38, 2, 4, 'Pavement Construction', 'Non agri-based', 0, '2025-10-05 05:25:55', '2025-10-05 05:25:55', NULL, NULL),
(39, 2, 4, 'Public Admin Group', 'Non agri-based', 0, '2025-10-05 05:26:15', '2025-10-05 05:26:15', NULL, NULL),
(40, 2, 4, 'Refund/Disallowance', 'Non agri-based', 0, '2025-10-05 05:26:33', '2025-10-05 05:26:33', NULL, NULL),
(41, NULL, 4, 'Renovation/Repair of the BLDG (From SB164)', 'Non agri-based', 0, '2025-10-05 05:28:37', '2025-10-05 05:28:37', NULL, NULL),
(42, 2, 4, 'Scheme Rice Rental', 'Non agri-based', 0, '2025-10-05 05:29:13', '2025-10-05 05:29:13', NULL, NULL),
(43, 2, 4, 'School Uniform', 'Non agri-based', 1, '2025-10-05 05:29:39', '2025-10-05 05:29:39', NULL, NULL),
(44, 2, 4, 'Sheep CBAO', 'Non agri-based', 0, '2025-10-05 05:29:56', '2025-10-05 05:29:56', NULL, NULL),
(45, 2, 4, 'Sound System', 'Non agri-based', 0, '2025-10-05 05:30:09', '2025-10-05 05:30:09', NULL, NULL),
(46, 2, 4, 'Sponsorship', 'Non agri-based', 0, '2025-10-05 05:30:23', '2025-10-05 05:30:23', NULL, NULL),
(47, 2, 4, 'Staff Housing Rental', 'Non agri-based', 0, '2025-10-05 05:30:39', '2025-10-05 05:30:39', NULL, NULL),
(48, 2, 4, 'Staff Housing Water Bill', 'Non agri-based', 0, '2025-10-05 05:30:59', '2025-10-05 05:30:59', NULL, NULL),
(49, 2, 4, 'Swine Production', 'Non agri-based', 0, '2025-10-05 05:31:17', '2025-10-05 05:31:17', NULL, NULL),
(50, 2, 4, 'Tilapia Production', 'Non agri-based', 0, '2025-10-05 05:31:31', '2025-10-05 05:31:31', NULL, NULL),
(51, 2, 4, 'Tractor', 'Non agri-based', 0, '2025-10-05 05:31:42', '2025-10-05 05:31:42', NULL, NULL),
(52, 2, 4, 'Univ. Env. Off.', 'Non agri-based', 0, '2025-10-05 05:32:03', '2025-10-05 05:32:03', NULL, NULL),
(53, 2, 4, 'VAN/BUS Maintenance', 'Non agri-based', 0, '2025-10-05 05:32:25', '2025-10-05 05:32:25', NULL, NULL),
(54, 2, 4, 'Water Refilling Station', 'Non agri-based', 0, '2025-10-05 05:32:40', '2025-10-05 05:32:40', NULL, NULL),
(55, 2, 4, 'Test Edited', 'Agri-based', 0, '2025-10-05 16:28:04', '2025-10-05 16:28:39', 4, NULL),
(56, 4, 8, 'Test for Cauayan', 'Non agri-based', 1, '2025-10-05 18:35:32', '2025-10-05 18:35:32', NULL, NULL),
(57, 4, 8, 'Test for Cauayan', 'Non agri-based', 1, '2025-10-05 18:36:01', '2025-10-05 18:36:01', NULL, NULL),
(58, 4, 8, 'Test 3', 'Agri-based', 1, '2025-10-05 18:43:15', '2025-10-05 18:43:15', NULL, NULL),
(59, 4, 8, 'Test 4', 'Non agri-based', 1, '2025-10-05 18:44:17', '2025-10-05 18:44:17', NULL, NULL),
(60, 4, 8, 'Test 5', 'Agri-based', 1, '2025-10-23 19:23:04', '2025-10-23 19:23:04', NULL, NULL),
(61, 4, 8, 'Test 6', 'Non agri-based', 1, '2025-10-23 19:27:52', '2025-10-23 19:27:52', NULL, NULL),
(62, 4, 8, 'Test 7', 'Non agri-based', 1, '2025-10-23 21:21:27', '2025-10-23 21:21:27', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `year_id` bigint(20) UNSIGNED DEFAULT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `enterprise_id` bigint(20) UNSIGNED DEFAULT NULL,
  `budgeted_amount` decimal(10,2) DEFAULT 0.00,
  `january` decimal(10,2) DEFAULT 0.00,
  `february` decimal(10,2) DEFAULT 0.00,
  `march` decimal(10,2) DEFAULT 0.00,
  `april` decimal(10,2) DEFAULT 0.00,
  `may` decimal(10,2) DEFAULT 0.00,
  `june` decimal(10,2) DEFAULT 0.00,
  `july` decimal(10,2) DEFAULT 0.00,
  `august` decimal(10,2) DEFAULT 0.00,
  `september` decimal(10,2) DEFAULT 0.00,
  `october` decimal(10,2) DEFAULT 0.00,
  `november` decimal(10,2) DEFAULT 0.00,
  `december` decimal(10,2) DEFAULT 0.00,
  `total_mooe` decimal(10,2) DEFAULT 0.00,
  `total_co` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `year_id`, `campus_id`, `enterprise_id`, `budgeted_amount`, `january`, `february`, `march`, `april`, `may`, `june`, `july`, `august`, `september`, `october`, `november`, `december`, `total_mooe`, `total_co`, `created_at`, `updated_at`, `updated_by`, `deleted_at`) VALUES
(1, 2025, 2, 6, 30000.00, 6000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 37000.00, NULL, NULL, 13000.00, 30000.00, '2025-10-10 08:20:50', '2025-10-12 23:12:26', 4, NULL),
(2, 2025, 2, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(3, 2025, 2, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(4, 2025, 2, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(5, 2025, 2, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(6, 2025, 2, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(7, 2025, 2, 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(8, 2025, 2, 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(9, 2025, 2, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(10, 2025, 2, 15, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(11, 2025, 2, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(12, 2025, 2, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(13, 2025, 2, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(14, 2025, 2, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(15, 2025, 2, 20, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(16, 2025, 2, 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(17, 2025, 2, 22, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(18, 2025, 2, 23, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(19, 2025, 2, 24, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(20, 2025, 2, 25, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(21, 2025, 2, 26, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(22, 2025, 2, 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(23, 2025, 2, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(24, 2025, 2, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(25, 2025, 2, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(26, 2025, 2, 31, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(27, 2025, 2, 32, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(28, 2025, 2, 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(29, 2025, 2, 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(30, 2025, 2, 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(31, 2025, 2, 36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(32, 2025, 2, 37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(33, 2025, 2, 38, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(34, 2025, 2, 39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(35, 2025, 2, 40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(36, 2025, 2, 42, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(37, 2025, 2, 43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(38, 2025, 2, 44, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(39, 2025, 2, 45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(40, 2025, 2, 46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(41, 2025, 2, 47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(42, 2025, 2, 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(43, 2025, 2, 49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(44, 2025, 2, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(45, 2025, 2, 50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(46, 2025, 2, 51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(47, 2025, 2, 52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(48, 2025, 2, 53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(49, 2025, 2, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 08:20:50', '2025-10-10 08:20:50', 4, NULL),
(50, 2025, 4, 1, 40000.00, 15000.00, 5000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 22000.00, 0.00, 0.00, 20000.00, 22000.00, '2025-10-23 19:32:54', '2025-10-23 21:44:39', 8, NULL),
(51, 2025, 4, 4, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(52, 2025, 4, 2, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(53, 2025, 4, 5, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(54, 2025, 4, 58, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(55, 2025, 4, 59, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(56, 2025, 4, 60, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(57, 2025, 4, 61, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(58, 2025, 4, 56, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(59, 2025, 4, 57, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL),
(60, 2025, 4, 3, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, '2025-10-23 19:32:54', '2025-10-23 19:32:54', 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expense_budgetary_requirements`
--

CREATE TABLE `expense_budgetary_requirements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expense_id` bigint(20) UNSIGNED DEFAULT NULL,
  `particular_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expense_budget_particulars`
--

CREATE TABLE `expense_budget_particulars` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expense_id` bigint(20) UNSIGNED DEFAULT NULL,
  `particular_name` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expense_budget_particulars`
--

INSERT INTO `expense_budget_particulars` (`id`, `expense_id`, `particular_name`, `amount`, `created_at`, `updated_at`, `updated_by`) VALUES
(1, 1, 'Particular 1', 10000.00, '2025-10-12 06:45:27', '2025-10-12 06:45:27', NULL),
(2, 1, 'Particular 2', 10000.00, '2025-10-12 06:45:27', '2025-10-12 06:45:27', NULL),
(3, 1, 'Particular 3', 10000.00, '2025-10-12 06:45:27', '2025-10-12 06:45:27', NULL),
(4, 50, 'Maintenance', 10000.00, '2025-10-23 21:26:40', '2025-10-23 21:26:40', NULL),
(5, 50, 'Particular 2', 20000.00, '2025-10-23 21:26:40', '2025-10-23 21:26:40', NULL),
(6, 50, 'Particular 3', 10000.00, '2025-10-23 21:26:40', '2025-10-23 21:26:40', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expense_particulars`
--

CREATE TABLE `expense_particulars` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `particular_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `incomes`
--

CREATE TABLE `incomes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `year_id` bigint(20) UNSIGNED DEFAULT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `enterprise_id` bigint(20) UNSIGNED DEFAULT NULL,
  `continuing` decimal(10,2) DEFAULT NULL,
  `january` decimal(10,2) DEFAULT NULL,
  `february` decimal(10,2) DEFAULT NULL,
  `march` decimal(10,2) DEFAULT NULL,
  `april` decimal(10,2) DEFAULT NULL,
  `may` decimal(10,2) DEFAULT NULL,
  `june` decimal(10,2) DEFAULT NULL,
  `july` decimal(10,2) DEFAULT NULL,
  `august` decimal(10,2) DEFAULT NULL,
  `september` decimal(10,2) DEFAULT NULL,
  `october` decimal(10,2) DEFAULT NULL,
  `november` decimal(10,2) DEFAULT NULL,
  `december` decimal(10,2) DEFAULT NULL,
  `current` decimal(10,0) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `incomes`
--

INSERT INTO `incomes` (`id`, `year_id`, `campus_id`, `enterprise_id`, `continuing`, `january`, `february`, `march`, `april`, `may`, `june`, `july`, `august`, `september`, `october`, `november`, `december`, `current`, `created_at`, `updated_at`, `updated_by`, `deleted_at`) VALUES
(10, 2025, 4, 1, 234567.00, 5680.00, 34567.00, 12345.00, 23456.00, 12350.00, 6789.00, 7890.00, 4567.00, 6790.00, 8906.00, 0.00, 0.00, 123340, '2025-10-06 18:01:26', '2025-10-07 03:40:15', 4, NULL),
(11, 2025, 4, 4, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(12, 2025, 4, 2, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(13, 2025, 4, 5, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(14, 2025, 4, 58, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(15, 2025, 4, 59, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(16, 2025, 4, 56, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(17, 2025, 4, 57, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(18, 2025, 4, 3, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-06 18:01:26', '2025-10-06 18:01:26', 4, NULL),
(19, 2025, 2, 6, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(20, 2025, 2, 7, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(21, 2025, 2, 8, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(22, 2025, 2, 9, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(23, 2025, 2, 10, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(24, 2025, 2, 11, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(25, 2025, 2, 12, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(26, 2025, 2, 13, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(27, 2025, 2, 14, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(28, 2025, 2, 15, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(29, 2025, 2, 16, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(30, 2025, 2, 17, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(31, 2025, 2, 18, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(32, 2025, 2, 19, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(33, 2025, 2, 20, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(34, 2025, 2, 21, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(35, 2025, 2, 22, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(36, 2025, 2, 23, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(37, 2025, 2, 24, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(38, 2025, 2, 25, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(39, 2025, 2, 26, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(40, 2025, 2, 27, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(41, 2025, 2, 28, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(42, 2025, 2, 29, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(43, 2025, 2, 30, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(44, 2025, 2, 31, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(45, 2025, 2, 32, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(46, 2025, 2, 33, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(47, 2025, 2, 34, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(48, 2025, 2, 35, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(49, 2025, 2, 36, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(50, 2025, 2, 37, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(51, 2025, 2, 38, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(52, 2025, 2, 39, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(53, 2025, 2, 40, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(54, 2025, 2, 42, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(55, 2025, 2, 43, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(56, 2025, 2, 44, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(57, 2025, 2, 45, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(58, 2025, 2, 46, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(59, 2025, 2, 47, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(60, 2025, 2, 48, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(61, 2025, 2, 49, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(62, 2025, 2, 55, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(63, 2025, 2, 50, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(64, 2025, 2, 51, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(65, 2025, 2, 52, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(66, 2025, 2, 53, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-07 16:30:11', '2025-10-07 16:30:11', 4, NULL),
(67, 2025, 2, 54, 25000.00, 7200.00, 5500.00, 1200.00, 6700.00, 3456.01, 6789.00, 9765.00, 3456.00, 4567.00, 6789.01, 0.00, 0.00, 55422, '2025-10-07 16:30:11', '2025-10-12 20:36:34', 4, NULL),
(68, 2025, 4, 60, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-23 19:28:55', '2025-10-23 19:28:55', 8, NULL),
(69, 2025, 4, 61, 12000.00, 10000.00, 10000.00, 5000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 25000, '2025-10-23 19:28:55', '2025-10-23 21:24:58', 8, NULL),
(70, 2025, 4, 62, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, '2025-10-23 21:23:43', '2025-10-23 21:23:43', 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inventories`
--

CREATE TABLE `inventories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT 'product_placeholder.jpg',
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `enterprise_id` bigint(20) UNSIGNED DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `unit` enum('pc','kg','m','l') DEFAULT NULL,
  `quantity` int(10) NOT NULL,
  `status` enum('Available','Not Available') DEFAULT 'Available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventories`
--

INSERT INTO `inventories` (`id`, `image`, `campus_id`, `enterprise_id`, `price`, `unit`, `quantity`, `status`, `created_at`, `updated_at`, `deleted_at`, `updated_by`) VALUES
(1, 'product_placeholder.jpg', 4, 1, 55.00, 'kg', 100, 'Available', '2025-07-29 09:43:05', '2025-07-29 09:43:05', NULL, 8),
(2, 'product_placeholder.jpg', 4, 4, 100.00, 'pc', 500, 'Available', '2025-07-29 09:45:51', '2025-07-29 09:45:51', NULL, 8),
(3, 'product_placeholder.jpg', 4, 57, NULL, NULL, 0, 'Available', '2025-10-05 18:36:01', '2025-10-05 18:36:01', NULL, 0),
(4, 'product_placeholder.jpg', 4, 58, NULL, NULL, 0, 'Available', '2025-10-05 18:43:15', '2025-10-05 18:43:15', NULL, 0),
(5, 'product_placeholder.jpg', 4, 59, NULL, NULL, 0, 'Available', '2025-10-05 18:44:17', '2025-10-05 18:44:17', NULL, 0),
(6, 'product_placeholder.jpg', 4, 56, NULL, NULL, 0, 'Available', '2025-10-07 21:22:42', '2025-10-07 21:22:42', NULL, 0),
(7, 'product_placeholder.jpg', 2, 10, 500.00, 'pc', 1000, 'Available', '2025-10-07 21:23:11', '2025-10-07 21:58:46', NULL, 4),
(8, 'product_placeholder.jpg', 2, 16, 200.00, 'pc', 1000, 'Available', '2025-10-07 21:23:11', '2025-10-07 23:15:09', NULL, 4),
(9, 'product_placeholder.jpg', 2, 23, NULL, NULL, 0, 'Available', '2025-10-07 21:23:11', '2025-10-07 21:23:11', NULL, 0),
(10, 'product_placeholder.jpg', 2, 33, NULL, NULL, 0, 'Available', '2025-10-07 21:23:11', '2025-10-07 21:23:11', NULL, 0),
(11, 'product_placeholder.jpg', 2, 43, NULL, NULL, 0, 'Available', '2025-10-07 21:23:11', '2025-10-07 21:23:11', NULL, 0),
(12, 'product_placeholder.jpg', 4, 60, NULL, NULL, 0, 'Available', '2025-10-23 19:23:04', '2025-10-23 19:23:04', NULL, 8),
(13, 'product_placeholder.jpg', 4, 61, NULL, NULL, 0, 'Available', '2025-10-23 19:27:52', '2025-10-23 19:27:52', NULL, 8),
(14, 'product_placeholder.jpg', 4, 62, 100.00, 'pc', 1000, 'Available', '2025-10-23 21:21:27', '2025-10-23 21:21:54', NULL, 8);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_00_00_000000_create_campuses_table', 1),
(2, '0001_01_01_000000_create_users_table', 1),
(3, '0001_01_01_000001_create_cache_table', 1),
(4, '0001_01_01_000002_create_jobs_table', 1),
(5, '2025_01_31_053059_create_designations_table', 1),
(6, '2025_07_21_001950_create_enterprises_table', 1),
(7, '2025_07_22_041453_create_inventories_table', 1),
(8, '2025_09_05_013743_create_proposals_table', 1),
(9, '2025_10_03_103925_create_proposal_remarks', 1),
(10, '2025_10_03_104445_create_user_logs', 1),
(11, '2025_10_05_122227_create_years_table', 1),
(12, '2025_10_06_120937_create_incomes_table', 1),
(13, '2025_10_08_152625_add_soft_deletes_to_all_tables', 1),
(14, '2025_10_09_104606_create_uacs_types_table', 1),
(15, '2025_10_09_104628_create_uacs_groups_table', 1),
(16, '2025_10_09_104629_create_uacs_table', 1),
(17, '2025_10_10_152122_create_expenses_table', 1),
(18, '2025_10_10_230736_create_creditors_table', 1),
(19, '2025_10_10_235047_create_creditor_has_uacs_table', 1),
(20, '2025_10_12_210822_create_expense_particulars_table', 1),
(21, '2025_10_12_210859_create_expense_budgetary_requirements_table', 1),
(22, '2025_10_12_221342_create_expense_budget_particulars_table', 1),
(23, '2025_11_05_112117_create_product_inventory_table', 1),
(24, '2025_11_07_142736_create_transaction_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_inventory`
--

CREATE TABLE `product_inventory` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `campus_id` bigint(11) UNSIGNED NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `low` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(255) NOT NULL,
  `status` enum('Available','Not Available') DEFAULT 'Available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_inventory`
--

INSERT INTO `product_inventory` (`id`, `campus_id`, `product_name`, `quantity`, `low`, `price`, `category`, `status`, `created_at`, `updated_at`) VALUES
(8, 3, 'asd', 0, 0, 0.00, 'Non - Agri Based', 'Available', '2025-11-05 06:05:58', '2025-11-05 06:05:58'),
(9, 2, 'asdas', 0, 0, 10.00, 'Agri-based', 'Available', '2025-11-05 06:06:29', '2025-11-06 02:36:18'),
(10, 2, 'asdas', 118, 123, 123.00, 'Non Agri-based', 'Available', '2025-11-05 06:07:20', '2025-11-23 15:26:13'),
(11, 2, 'dasd', 119, 123, 123.00, 'Agri-based', 'Available', '2025-11-05 06:41:52', '2025-11-23 15:30:31');

-- --------------------------------------------------------

--
-- Table structure for table `proposals`
--

CREATE TABLE `proposals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `proposal_title` varchar(255) DEFAULT NULL,
  `proposal_file` text NOT NULL,
  `category` enum('Agri-based','Non Agri-based') DEFAULT NULL,
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT 'Pending',
  `evaluated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `evaluated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_ats` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `proposals`
--

INSERT INTO `proposals` (`id`, `campus_id`, `user_id`, `proposal_title`, `proposal_file`, `category`, `status`, `evaluated_by`, `evaluated_at`, `created_at`, `updated_at`, `updated_by`, `updated_ats`, `deleted_at`) VALUES
(1, 4, 8, 'adadads', 'proposals/2025-09-30_064617_CAROLINE-P-RUIZ-CERTIFICATE-OF-APPEARANCE.pdf', 'Agri-based', 'Approved', 4, '2025-10-03 19:00:37', '2025-09-29 14:46:18', '2025-10-03 19:00:37', NULL, NULL, NULL),
(2, 4, 8, 'Smart Water System', 'proposals/2025-10-01_012414_FILE-EXAMPLE-PDF-1MB.pdf', 'Agri-based', 'Declined', 4, '2025-10-03 18:53:04', '2025-09-30 09:24:14', '2025-10-03 18:53:04', NULL, NULL, NULL),
(3, 2, 4, 'Eco-Friendly Packaging', 'proposals/2025-10-04_194942_FILE-EXAMPLE-PDF-1MB.pdf', 'Agri-based', 'Approved', 4, '2025-10-04 07:00:28', '2025-10-04 03:49:42', '2025-10-04 07:00:28', NULL, NULL, NULL),
(4, 4, 8, 'Solar Microgrid Design', 'proposals/2025-10-04_225001_SEARCH-AND-CALL-FOR-APPLICATIONS.pdf', 'Agri-based', 'Declined', 4, '2025-10-04 07:56:05', '2025-10-04 06:50:01', '2025-10-04 07:56:05', NULL, NULL, NULL),
(5, 4, 8, 'Asdjkjdfkkf', 'proposals/2025-10-04_225125_ISU-ENTERPRISE-REPORT.pdf', 'Agri-based', 'Approved', 4, '2025-10-04 07:56:28', '2025-10-04 06:51:25', '2025-10-04 07:56:28', NULL, NULL, NULL),
(6, 4, 8, 'EDITED', 'proposals/2025-10-05_015424_FILE-EXAMPLE-PDF-1MB.pdf', 'Non Agri-based', 'Pending', NULL, NULL, '2025-10-04 06:57:03', '2025-10-04 09:54:24', NULL, NULL, NULL),
(7, 7, 4, 'EDITED 2', 'proposals/2025-10-04_231451_FILE-EXAMPLE-PDF-1MB.pdf', 'Agri-based', 'Pending', NULL, NULL, '2025-10-04 07:14:51', '2025-10-04 18:54:27', NULL, NULL, NULL),
(8, 2, 4, 'Test 2', 'proposals/2025-10-08_130719_FILE-EXAMPLE-PDF-1MB.pdf', 'Agri-based', 'Pending', NULL, NULL, '2025-10-07 21:07:19', '2025-10-07 21:07:19', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `proposal_remarks`
--

CREATE TABLE `proposal_remarks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `proposal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `proposal_remarks`
--

INSERT INTO `proposal_remarks` (`id`, `proposal_id`, `user_id`, `remark`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 4, 'Pls resubmit. Details are lacking.', '2025-10-02 23:42:47', '2025-10-02 23:42:47', NULL),
(2, 2, 4, 'Submit until Oct. 10, 2025. 12 nn', '2025-10-03 08:01:36', '2025-10-03 08:01:36', NULL),
(3, 4, 4, 'Not feasible.', '2025-10-04 07:48:00', '2025-10-04 07:48:00', NULL),
(4, 4, 4, 'Test', '2025-10-04 07:53:47', '2025-10-04 07:53:47', NULL),
(5, 4, 4, 'Test 2', '2025-10-04 07:54:43', '2025-10-04 07:54:43', NULL),
(6, 4, 4, 'Test 3', '2025-10-04 07:55:32', '2025-10-04 07:55:32', NULL),
(7, 4, 4, 'Test 4', '2025-10-04 07:55:45', '2025-10-04 07:55:45', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`, `deleted_at`) VALUES
('7Y9sCFwbxMd7GxkfbP9ZNHTINU4CKKVfoD0WkbmV', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoia3NUTno5eGtFZ2JOZXB5ZVQ5Vzg3UkJNMEJwWDI4aXRmZXBFMUN3aCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjU0OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvaW50ZWdyYXRlZC9pbnZlbnRvcnkvdHJhbnNhY3Rpb24iO31zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxMDt9', 1763911833, NULL),
('xkrRd9o2Qk21kxs017cVyfcKhLCxVBsN8vqE7B9j', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiV0hxa0xuTHNacElicDFNWUNzSzUxVkZ0YTFMMDVJd1ZnSGx4NFVvUyI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjU0OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvaW50ZWdyYXRlZC9pbnZlbnRvcnkvdHJhbnNhY3Rpb24iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxMDt9', 1763900212, NULL),
('YHHdaCuBGNvXO64YsJxbBN5suLJv87QapT3WTG1A', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiSXZ2ZkVjWEdGczdVREtLaFFWZXdOelNqc0F5YWprdG5SUThkaU5SZSI7czozOiJ1cmwiO2E6MDp7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjEwO3M6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjU0OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvaW50ZWdyYXRlZC9pbnZlbnRvcnkvdHJhbnNhY3Rpb24iO319', 1763898557, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `category` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `id_number` varchar(255) DEFAULT NULL,
  `date_purchase` timestamp NULL DEFAULT NULL,
  `status` enum('paid','unpaid','cancelled') DEFAULT NULL,
  `date_paid` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `campus_id`, `product_id`, `quantity`, `category`, `name`, `id_number`, `date_purchase`, `status`, `date_paid`, `created_at`, `updated_at`) VALUES
(1, 2, 9, 3, 'asd', 'chris', '22-2533', '2025-11-10 04:13:14', 'paid', '2025-11-22 08:00:57', '2025-11-10 04:18:03', '2025-11-22 08:00:57'),
(2, 2, 10, 1, 'Default', 'a', '10', '2025-11-14 02:39:03', 'unpaid', NULL, '2025-11-14 02:39:03', '2025-11-14 02:39:03'),
(3, 2, 9, 2, 'Default', 'dasdasd', '123123', '2025-11-14 03:32:22', 'unpaid', NULL, '2025-11-14 03:32:22', '2025-11-14 03:32:22'),
(4, 2, 10, 1, 'Default', 'dadsasd', '10', '2025-11-22 07:59:08', 'paid', '2025-11-22 08:11:36', '2025-11-22 07:59:08', '2025-11-22 07:59:08'),
(5, 2, 11, 2, 'Default', 'dsad', '123', '2025-11-22 03:48:14', 'paid', '2025-11-23 03:30:15', '2025-11-22 08:48:14', '2025-11-23 03:30:15'),
(7, 2, 10, 1, 'Reserve', 'Director University', '', '2025-11-23 10:21:24', 'paid', '2025-11-23 15:21:24', '2025-11-23 15:21:24', '2025-11-23 15:21:24'),
(8, 2, 10, 1, 'Reserve', 'Director University', '', '2025-11-23 10:26:13', 'paid', '2025-11-23 15:26:13', '2025-11-23 15:26:13', '2025-11-23 15:26:13'),
(9, 9, 11, 2, 'Reserve', 'Milo Zulueta', '', '2025-11-23 10:30:31', 'paid', '2025-11-23 15:30:31', '2025-11-23 15:30:31', '2025-11-23 15:30:31');

-- --------------------------------------------------------

--
-- Table structure for table `uacs`
--

CREATE TABLE `uacs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uacs_group_id` bigint(20) UNSIGNED DEFAULT NULL,
  `uacs_code` varchar(255) NOT NULL,
  `object_code` varchar(255) NOT NULL,
  `sub_object_code` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `uacs_status` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `uacs`
--

INSERT INTO `uacs` (`id`, `uacs_group_id`, `uacs_code`, `object_code`, `sub_object_code`, `description`, `uacs_status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 151, '1010101000\r\n', 'Cash - Collecting Officers\r\n', 'Cash - Collecting Officers\r\n', NULL, 'Active', '2025-10-09 00:21:49', '2025-10-09 00:21:49', NULL),
(2, 151, '1010102000\r\n', 'Petty cash', 'Petty cash', NULL, 'Active', '2025-10-09 00:21:49', '2025-10-09 00:21:49', NULL),
(3, 152, '1010201000', 'Cash in Bank - Local Currency, Bangko Sentral ng Pilipinas', 'Cash in Bank - Local Currency, Bangko Sentral ng Pilipinas', NULL, 'Active', '2025-10-11 15:51:02', '2025-10-11 15:51:02', NULL),
(4, 152, '1010202001', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Allied Bank', NULL, 'Active', '2025-10-11 15:51:02', '2025-10-11 15:51:02', NULL),
(5, 152, '1010202002', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Amanah Bank', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(6, 152, '1010202003', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Asia United Bank Corporation', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(7, 152, '1010202004\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Australia and New Zealand Bank\r\n', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(8, 152, '1010202005\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Banco de Oro (BDO)\r\n', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(9, 152, '1010202006\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bangkok Bank\r\n', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(10, 152, '1010202007\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bangkok Bank Public Company Limited', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(11, 152, '1010202008', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bank of China\r\n', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(12, 152, '1010202009\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bank of Commerce', NULL, 'Active', '2025-10-11 15:53:04', '2025-10-11 15:53:04', NULL),
(13, 152, '1010202010', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bank of the Philippine Islands (BPI)', NULL, 'Active', '2025-10-11 16:09:36', '2025-10-11 16:09:36', NULL),
(14, 152, '1010202011', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Bank of Tokyo', NULL, 'Active', '2025-10-11 16:09:36', '2025-10-11 16:09:36', NULL),
(15, 152, '1010202012', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - China Banking Corporation', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(16, 152, '1010202013', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Chinatrust Commercial Bank', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(17, 152, '1010202014', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Citibank', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(18, 152, '1010202015', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Deutsche Bank AG\r\n', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(19, 152, '1010202016', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Development Bank of the Philippines (DBP)\r\n', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(20, 152, '1010202017', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - East-West Banking Corporation\r\n', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(21, 152, '1010202018\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - Equitable PCI Bank\r\n', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(22, 152, '1010202019\r\n', 'Cash in Bank - Local Currency, Current Account', 'Cash in Bank - Local Currency, Current Account - First Consolidated Bank (FCB)\r\n', NULL, 'Active', '2025-10-11 16:10:28', '2025-10-11 16:10:28', NULL),
(23, 193, '5020101000\r\n', 'Traveling Expenses - Local\r\n', 'Traveling Expenses - Local\r\n', NULL, 'Active', '2025-10-12 08:25:19', '2025-10-12 08:25:19', NULL),
(24, 193, '5020102000\r\n', 'Traveling Expenses - Foreign\r\n', 'Traveling Expenses - Foreign\r\n', NULL, 'Active', '2025-10-12 08:25:19', '2025-10-12 08:25:19', NULL),
(25, 194, '5020201001\r\n', 'Training Expenses\r\n', 'ICT Training Expenses\r\n', NULL, 'Active', '2025-10-12 08:26:41', '2025-10-12 08:26:41', NULL),
(26, 194, '5020201002\r\n', 'Training Expenses\r\n', 'Training Expenses\r\n', NULL, 'Active', '2025-10-12 08:26:41', '2025-10-12 08:26:41', NULL),
(27, 194, '5020202000\r\n', 'Scholarship Grants/Expenses\r\n', 'Scholarship Grants/Expenses\r\n', NULL, 'Active', '2025-10-12 08:26:41', '2025-10-12 08:26:41', NULL),
(28, 200, '5060301000\r\n', 'Land and Buildings Outlay\r\n', NULL, NULL, 'Active', '2025-10-12 08:28:58', '2025-10-12 08:28:58', NULL),
(29, 200, '5060301001\r\n', 'Land and Buildings Outlay\r\n', 'Investment Property - Land\r\n', NULL, 'Active', '2025-10-12 08:28:58', '2025-10-12 08:28:58', NULL),
(30, 200, '5060301002\r\n', 'Land and Buildings Outlay\r\n', 'Investment Property - Buildings\r\n', NULL, 'Active', '2025-10-12 08:30:17', '2025-10-12 08:30:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `uacs_groups`
--

CREATE TABLE `uacs_groups` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uacs_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `uacs_groups`
--

INSERT INTO `uacs_groups` (`id`, `uacs_type_id`, `name`, `code`, `created_at`, `updated_at`, `deleted_at`) VALUES
(151, 2, 'Cash on Hand', '1010100000', '2025-10-08 23:44:56', '2025-10-08 23:44:56', NULL),
(152, 2, 'Cash in Bank - Local Currency\r\n', '1010200000', '2025-10-08 23:44:56', '2025-10-08 23:44:56', NULL),
(153, 2, 'Cash in Bank - Foreign Currency\r\n', '1010300000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(154, 2, 'Treasury/Agency Cash Accounts\r\n', '1010400000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(155, 2, 'Cash Equivalents\r\n', '1010500000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(156, 2, 'Financial Assets at Fair Value Through Surplus or Deficit\r\n', '1020100000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(157, 2, 'Financial Assets - Held to Maturity\r\n', '1020200000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(158, 2, 'Financial Assets - Others\r\n', '1020300000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(159, 2, 'Investments in GOCCs\r\n', '1020400000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(160, 2, 'Investments in Joint Venture\r\n', '1020500000', '2025-10-08 23:45:44', '2025-10-08 23:45:44', NULL),
(161, 2, 'Investments in Associates\r\n', '1020600000', '2025-10-08 23:48:51', '2025-10-08 23:48:51', NULL),
(162, 2, 'Sinking Fund', '1020701000', '2025-10-08 23:48:51', '2025-10-08 23:48:51', NULL),
(163, 2, 'Loans and Receivable Accounts\r\n', '1030100000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(164, 2, 'Lease Receivable\r\n', '1030200000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(165, 2, 'Inter-Agency Receivables\r\n', '1030300000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(166, 2, 'Intra-Agency Receivables\r\n', '1030400000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(167, 2, 'Other Recievables', '1030500000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(168, 2, 'Inventory Held for Sale', '1040100000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(169, 2, 'Inventory Held for Distribution', '1040200000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(170, 2, 'Inventory Held for Manufacturing', '1040300000', '2025-10-08 23:50:08', '2025-10-08 23:50:08', NULL),
(171, 2, 'Inventory Held for Consumption', '1040400000', '2025-10-08 23:53:18', '2025-10-08 23:53:18', NULL),
(172, 2, 'Land and Buildings', '1050100000', '2025-10-08 23:53:18', '2025-10-08 23:53:18', NULL),
(173, 2, 'Land', '1060100000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(174, 2, 'Land Improvements', '1060200000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(175, 2, 'Infrastructure Assets', '1060300000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(176, 2, 'Buildings and Other Assets', '1060400000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(177, 2, 'Machinery and Equipment', '1060500000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(178, 2, 'Transportation Equipment', '1060600000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(179, 2, 'Furniture, Fixtures and Books\r\n', '1060700000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(180, 2, 'Leased Assets', '1060800000', '2025-10-08 23:54:13', '2025-10-08 23:54:13', NULL),
(181, 2, 'Leased Assets - Improvements', '1060900000', '2025-10-08 23:57:50', '2025-10-08 23:57:50', NULL),
(182, 2, 'Construction in Progress', '1061000000', '2025-10-08 23:57:50', '2025-10-08 23:57:50', NULL),
(183, 2, 'Heritage Assets', '1061100000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(184, 2, 'Service Concession Assets\r\n', '1061200000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(185, 2, 'Other Property, Plant and Equipment\r\n', '1069900000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(186, 2, 'Bearer Biological Assets\r\n', '1070100000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(187, 2, 'Consumable Biological Assets\r\n', '1070200000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(188, 2, 'Intangible Assets', '1080100000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(189, 2, 'Advances', '1990100000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(190, 2, 'Prepayments', '1990200000', '2025-10-08 23:58:35', '2025-10-08 23:58:35', NULL),
(191, 2, 'Deposits', '1990300000', '2025-10-09 00:01:04', '2025-10-09 00:01:04', NULL),
(192, 2, 'Other Assets', '1999900000', '2025-10-09 00:01:04', '2025-10-09 00:01:04', NULL),
(193, 7, 'Traveling Expenses', '5020100000', '2025-10-12 08:19:05', '2025-10-12 08:19:05', NULL),
(194, 7, 'Training and Scholarship Expenses', '5020200000', '2025-10-12 08:19:05', '2025-10-12 08:19:05', NULL),
(195, 7, 'Supplies and Materials Expenses\r\n', '5020300000', '2025-10-12 08:20:27', '2025-10-12 08:20:27', NULL),
(196, 7, 'Utility Expenses\r\n', '5020400000', '2025-10-12 08:20:27', '2025-10-12 08:20:27', NULL),
(197, 7, 'Communication Expenses\r\n', '5020500000', '2025-10-12 08:20:27', '2025-10-12 08:20:27', NULL),
(198, 11, 'Investment Outlay\r\n', '5060100000', '2025-10-12 08:22:38', '2025-10-12 08:22:38', NULL),
(199, 11, 'Loans Outlay\r\n', '5060200000', '2025-10-12 08:22:38', '2025-10-12 08:22:38', NULL),
(200, 11, 'Investment Property Outlay\r\n', '5060300000', '2025-10-12 08:23:10', '2025-10-12 08:23:10', NULL),
(201, 11, 'Property, Plant and Equipment Outlay\r\n', '5060400000', '2025-10-12 08:23:10', '2025-10-12 08:23:10', NULL),
(202, 11, 'Biological Assets Outlay\r\n', '5060500000', '2025-10-12 08:23:10', '2025-10-12 08:23:10', NULL),
(203, 11, 'Intangible Assets Outlay\r\n', '5060600000', '2025-10-12 08:23:59', '2025-10-12 08:23:59', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `uacs_types`
--

CREATE TABLE `uacs_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `uacs_types`
--

INSERT INTO `uacs_types` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'General', '2025-10-08 22:00:45', '2025-10-08 22:00:45', NULL),
(2, 'Assets', '2025-10-08 22:01:14', '2025-10-08 22:01:14', NULL),
(3, 'Liabilities', '2025-10-08 22:01:14', '2025-10-08 22:01:14', NULL),
(4, 'Accumulated Surplus', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(5, 'Income', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(6, 'Personal Services', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(7, 'MOOE', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(8, 'Financial Expenses', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(9, 'Direct Costs', '2025-10-08 22:02:14', '2025-10-08 22:02:14', NULL),
(10, 'Non-Cash Expenditures', '2025-10-08 22:06:13', '2025-10-08 22:06:13', NULL),
(11, 'Capital Outlay', '2025-10-08 22:06:13', '2025-10-08 22:06:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `avatar` varchar(255) NOT NULL DEFAULT 'default_avatar.jpg',
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(255) NOT NULL,
  `sex` enum('Male','Female') NOT NULL,
  `designation` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `campus_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` enum('Admin','VP','Director','User','President') NOT NULL DEFAULT 'User',
  `accounts` tinyint(1) NOT NULL DEFAULT 0,
  `reports` tinyint(1) NOT NULL DEFAULT 0,
  `enterprises` tinyint(1) NOT NULL DEFAULT 0,
  `inventory` tinyint(1) NOT NULL DEFAULT 0,
  `income` tinyint(1) NOT NULL DEFAULT 0,
  `expenses` tinyint(1) NOT NULL DEFAULT 0,
  `proposals` tinyint(1) NOT NULL DEFAULT 0,
  `account_status` enum('Verified','Not Verified') NOT NULL,
  `last_modified_at` datetime DEFAULT NULL,
  `last_modified_by` datetime DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `avatar`, `last_name`, `first_name`, `middle_name`, `sex`, `designation`, `email`, `email_verified_at`, `password`, `campus_id`, `role`, `accounts`, `reports`, `enterprises`, `inventory`, `income`, `expenses`, `proposals`, `account_status`, `last_modified_at`, `last_modified_by`, `user_id`, `remember_token`, `updated_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(4, 'default_avatar.jpg', 'Cacho', 'Cyra', 'Castillo', 'Female', 'System Administrator', 'cyra@isu.edu.ph', '2025-06-06 10:29:37', '$2y$12$EogIhs/mbkcnQgmmJNqR0ejiBnRO0Z.Qtcv9IAWQ6wMET632bAuu.', 2, 'Admin', 1, 1, 1, 1, 1, 1, 1, 'Not Verified', '2025-07-14 15:44:43', NULL, NULL, 'h81cy6v1NFsgYQNAjKFOjKiICsiIixTWH7rg508uzL2HYeJ1g0zU0uDjFH7o', NULL, NULL, '2025-06-06 10:29:37', '2025-06-06 10:29:37'),
(7, 'default_avatar.jpg', 'Zulueta', 'Milo', 'Tan', 'Male', 'San Mateo CBAO Director', 'milo.zulueta@isu.edu.ph', NULL, '$2y$12$DeVhs.Nm/p70K38iZWycR.dBq5R/gR9IRWxnvkC/oqZcNzUWg7WWq', 9, 'User', 0, 1, 0, 0, 0, 0, 0, 'Verified', NULL, NULL, NULL, NULL, 4, NULL, '2025-07-17 09:14:57', '2025-07-17 16:21:43'),
(8, 'default_avatar.jpg', 'Doe', 'John', '', 'Male', 'Cauayan CBAO Director', 'john.doe@isu.edu.ph', NULL, '$2y$12$B/X2JkK2c557JwobPiZO3OS1rRG8vyXCUiJlE7CHKtWAuKSGUsGfe', 4, 'User', 0, 0, 0, 0, 0, 0, 0, 'Not Verified', NULL, NULL, NULL, NULL, 4, NULL, '2025-07-17 09:41:50', '2025-07-17 09:41:50'),
(9, 'default_avatar.jpg', 'Sy', 'Josefa', 'Batumbakal', 'Female', 'Ilagan CBAO Director', 'josefa.b.sy@isu.edu.ph', NULL, '$2y$12$0m2PuVk489vbHyGGO8BuOeXoXUjFoZT2G935tlPrOKTRhftgzTEAa', 5, 'User', 0, 0, 0, 0, 0, 0, 0, 'Not Verified', NULL, NULL, NULL, NULL, 4, NULL, '2025-07-17 09:45:37', '2025-07-17 09:45:37'),
(10, 'default_avatar.jpg', 'University', 'Director', '', 'Male', 'University Director', 'university.director@isu.edu.ph', NULL, '$2y$12$sEUj6TuR3H5tNqEP1pudh.t7j.O/3ihny8U4ltVrkWxggmiAOEkbK', 2, 'User', 1, 1, 1, 1, 1, 1, 1, 'Not Verified', NULL, NULL, NULL, NULL, 4, NULL, '2025-10-23 18:36:53', '2025-11-05 05:04:25');

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

CREATE TABLE `user_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`id`, `user_id`, `action`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-03 16:59:02', '2025-10-03 16:59:02', NULL),
(2, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-03 17:05:53', '2025-10-03 17:05:53', NULL),
(3, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-03 17:07:48', '2025-10-03 17:07:48', NULL),
(4, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-03 17:09:20', '2025-10-03 17:09:20', NULL),
(5, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-03 17:09:25', '2025-10-03 17:09:25', NULL),
(6, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-03 17:30:32', '2025-10-03 17:30:32', NULL),
(9, 4, 'Evaluate Proposal', 'Declined proposal: \"Smart Water System\"', '2025-10-03 18:53:04', '2025-10-03 18:53:04', NULL),
(10, 4, 'Evaluate Proposal', 'Approved proposal: \"adadads\"', '2025-10-03 18:58:54', '2025-10-03 18:58:54', NULL),
(11, 4, 'Evaluate Proposal', 'Approved proposal: \"adadads\"', '2025-10-03 19:00:37', '2025-10-03 19:00:37', NULL),
(12, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-04 01:34:01', '2025-10-04 01:34:01', NULL),
(13, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-04 06:46:26', '2025-10-04 06:46:26', NULL),
(14, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-04 06:46:33', '2025-10-04 06:46:33', NULL),
(15, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-04 07:00:01', '2025-10-04 07:00:01', NULL),
(16, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-04 07:00:07', '2025-10-04 07:00:07', NULL),
(17, 4, 'Evaluate Proposal', 'Approved proposal: \"Eco-Friendly Packaging\"', '2025-10-04 07:00:28', '2025-10-04 07:00:28', NULL),
(18, 4, 'Add Remark', 'Added a remark on proposal: \"Solar Microgrid Design\"', '2025-10-04 07:48:00', '2025-10-04 07:48:00', NULL),
(19, 4, 'Add Remark', 'Added a remark on proposal: \"Solar Microgrid Design\"', '2025-10-04 07:53:47', '2025-10-04 07:53:47', NULL),
(20, 4, 'Add Remark', 'Added a remark on proposal: \"Solar Microgrid Design\"', '2025-10-04 07:54:43', '2025-10-04 07:54:43', NULL),
(21, 4, 'Add Remark', 'Added a remark on proposal: \"Solar Microgrid Design\"', '2025-10-04 07:55:32', '2025-10-04 07:55:32', NULL),
(22, 4, 'Add Remark', 'Added a remark on proposal: \"Solar Microgrid Design\"', '2025-10-04 07:55:45', '2025-10-04 07:55:45', NULL),
(23, 4, 'Evaluate Proposal', 'Declined proposal: \"Solar Microgrid Design\"', '2025-10-04 07:56:05', '2025-10-04 07:56:05', NULL),
(24, 4, 'Evaluate Proposal', 'Approved proposal: \"Asdjkjdfkkf\"', '2025-10-04 07:56:28', '2025-10-04 07:56:28', NULL),
(25, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-04 08:12:16', '2025-10-04 08:12:16', NULL),
(26, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-04 08:12:22', '2025-10-04 08:12:22', NULL),
(27, 8, 'Updated Proposal', 'User John Doe updated the proposal: Edited Title.', '2025-10-04 09:40:19', '2025-10-04 09:40:19', NULL),
(28, 8, 'Updated Proposal', 'User John Doe updated the proposal: Edited.', '2025-10-04 09:40:39', '2025-10-04 09:40:39', NULL),
(29, 8, 'Updated Proposal', 'User John Doe updated the proposal: Edited.', '2025-10-04 09:48:59', '2025-10-04 09:48:59', NULL),
(30, 8, 'Updated Proposal', 'User John Doe updated the proposal: EDITED.', '2025-10-04 09:49:09', '2025-10-04 09:49:09', NULL),
(31, 8, 'Updated Proposal', 'User John Doe updated the proposal: EDITED.', '2025-10-04 09:49:36', '2025-10-04 09:49:36', NULL),
(32, 8, 'Updated Proposal', 'User John Doe updated the proposal: EDITED.', '2025-10-04 09:52:20', '2025-10-04 09:52:20', NULL),
(33, 8, 'Updated Proposal', 'User John Doe updated the proposal: EDITED.', '2025-10-04 09:54:24', '2025-10-04 09:54:24', NULL),
(34, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-04 17:37:48', '2025-10-04 17:37:48', NULL),
(35, 4, 'Updated Proposal', 'User Cyra Cacho updated the proposal: Edited 2.', '2025-10-04 18:54:08', '2025-10-04 18:54:08', NULL),
(36, 4, 'Updated Proposal', 'User Cyra Cacho updated the proposal: EDITED 2.', '2025-10-04 18:54:19', '2025-10-04 18:54:19', NULL),
(37, 4, 'Updated Proposal', 'User Cyra Cacho updated the proposal: EDITED 2.', '2025-10-04 18:54:27', '2025-10-04 18:54:27', NULL),
(38, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-05 00:04:10', '2025-10-05 00:04:10', NULL),
(39, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-05 04:11:34', '2025-10-05 04:11:34', NULL),
(40, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Advertising Billboard.', '2025-10-05 05:12:16', '2025-10-05 05:12:16', NULL),
(41, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Amphitheater Rental.', '2025-10-05 05:13:03', '2025-10-05 05:13:03', NULL),
(42, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Biazon Hostel Rental.', '2025-10-05 05:13:35', '2025-10-05 05:13:35', NULL),
(43, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Cap and Gown (Deposit/Refund).', '2025-10-05 05:14:25', '2025-10-05 05:14:25', NULL),
(44, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Cap and Gown Rental.', '2025-10-05 05:14:46', '2025-10-05 05:14:46', NULL),
(45, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Carabao CBAO.', '2025-10-05 05:15:22', '2025-10-05 05:15:22', NULL),
(46, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Carabao Stud Farm.', '2025-10-05 05:15:43', '2025-10-05 05:15:43', NULL),
(47, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: CAS Reference/Book.', '2025-10-05 05:16:08', '2025-10-05 05:16:08', NULL),
(48, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: CBAO Bamboo.', '2025-10-05 05:16:28', '2025-10-05 05:16:28', NULL),
(49, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: CBAO Training.', '2025-10-05 05:16:51', '2025-10-05 05:16:51', NULL),
(50, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Computerized ID.', '2025-10-05 05:17:24', '2025-10-05 05:17:24', NULL),
(51, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: De Venecia Rental.', '2025-10-05 05:17:52', '2025-10-05 05:17:52', NULL),
(52, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Desktop Publishing Center.', '2025-10-05 05:18:13', '2025-10-05 05:18:13', NULL),
(53, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Dragon Fruit.', '2025-10-05 05:18:34', '2025-10-05 05:18:34', NULL),
(54, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Fishpond Rental.', '2025-10-05 05:18:56', '2025-10-05 05:18:56', NULL),
(55, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Foodcourt/Stall Rental.', '2025-10-05 05:19:22', '2025-10-05 05:19:22', NULL),
(56, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Foodcourt/Stall Water Bill.', '2025-10-05 05:20:10', '2025-10-05 05:20:10', NULL),
(57, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Gatepass Sticker (New)/Share.', '2025-10-05 05:20:46', '2025-10-05 05:20:46', NULL),
(58, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Guesthouse.', '2025-10-05 05:21:01', '2025-10-05 05:21:01', NULL),
(59, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Hostel Manila.', '2025-10-05 05:21:18', '2025-10-05 05:21:18', NULL),
(60, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: HVC CBAO.', '2025-10-05 05:21:34', '2025-10-05 05:21:34', NULL),
(61, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Land Rental.', '2025-10-05 05:22:08', '2025-10-05 05:22:08', NULL),
(62, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Marketing Center E-Bill.', '2025-10-05 05:22:29', '2025-10-05 05:22:29', NULL),
(63, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Meat Processing.', '2025-10-05 05:22:45', '2025-10-05 05:22:45', NULL),
(64, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Miscellaneous Income.', '2025-10-05 05:23:01', '2025-10-05 05:23:01', NULL),
(65, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: New Dormitories (Staff Housing).', '2025-10-05 05:23:24', '2025-10-05 05:23:24', NULL),
(66, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: NPGC Rental.', '2025-10-05 05:23:54', '2025-10-05 05:23:54', NULL),
(67, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: NSTP T-Shirt Share.', '2025-10-05 05:24:14', '2025-10-05 05:24:14', NULL),
(68, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Orchard (Mango) Production.', '2025-10-05 05:24:42', '2025-10-05 05:24:42', NULL),
(69, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Overhead Cost.', '2025-10-05 05:24:58', '2025-10-05 05:24:58', NULL),
(70, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Palayamanan.', '2025-10-05 05:25:20', '2025-10-05 05:25:20', NULL),
(71, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Pasada.', '2025-10-05 05:25:35', '2025-10-05 05:25:35', NULL),
(72, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Pavement Construction.', '2025-10-05 05:25:55', '2025-10-05 05:25:55', NULL),
(73, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Public Admin Group.', '2025-10-05 05:26:15', '2025-10-05 05:26:15', NULL),
(74, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Refund/Disallowance.', '2025-10-05 05:26:33', '2025-10-05 05:26:33', NULL),
(75, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Renovation/Repair of the BLDG (From SB164).', '2025-10-05 05:28:37', '2025-10-05 05:28:37', NULL),
(76, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Scheme Rice Rental.', '2025-10-05 05:29:13', '2025-10-05 05:29:13', NULL),
(77, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: School Uniform.', '2025-10-05 05:29:39', '2025-10-05 05:29:39', NULL),
(78, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Sheep CBAO.', '2025-10-05 05:29:56', '2025-10-05 05:29:56', NULL),
(79, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Sound System.', '2025-10-05 05:30:09', '2025-10-05 05:30:09', NULL),
(80, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Sponsorship.', '2025-10-05 05:30:23', '2025-10-05 05:30:23', NULL),
(81, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Staff Housing Rental.', '2025-10-05 05:30:39', '2025-10-05 05:30:39', NULL),
(82, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Staff Housing Water Bill.', '2025-10-05 05:30:59', '2025-10-05 05:30:59', NULL),
(83, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Swine Production.', '2025-10-05 05:31:17', '2025-10-05 05:31:17', NULL),
(84, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Tilapia Production.', '2025-10-05 05:31:31', '2025-10-05 05:31:31', NULL),
(85, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Tractor.', '2025-10-05 05:31:42', '2025-10-05 05:31:42', NULL),
(86, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Univ. Env. Off..', '2025-10-05 05:32:04', '2025-10-05 05:32:04', NULL),
(87, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: VAN/BUS Maintenance.', '2025-10-05 05:32:25', '2025-10-05 05:32:25', NULL),
(88, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Water Refilling Station.', '2025-10-05 05:32:40', '2025-10-05 05:32:40', NULL),
(89, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-05 05:58:02', '2025-10-05 05:58:02', NULL),
(90, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-05 16:03:25', '2025-10-05 16:03:25', NULL),
(91, 4, 'Added Business Enterprise', 'User Cyra Cacho added a new business enterprise: Test.', '2025-10-05 16:28:04', '2025-10-05 16:28:04', NULL),
(92, 4, 'Updated a business enterprise', 'User Cyra Cacho has updated the business enterprise: Test Edited.', '2025-10-05 16:28:26', '2025-10-05 16:28:26', NULL),
(93, 4, 'Updated a business enterprise', 'User Cyra Cacho has updated the business enterprise: Test Edited.', '2025-10-05 16:28:39', '2025-10-05 16:28:39', NULL),
(94, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-05 17:49:27', '2025-10-05 17:49:27', NULL),
(95, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-05 17:49:36', '2025-10-05 17:49:36', NULL),
(96, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test for Cauayan.', '2025-10-05 18:36:01', '2025-10-05 18:36:01', NULL),
(97, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test 3.', '2025-10-05 18:43:15', '2025-10-05 18:43:15', NULL),
(98, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test 4.', '2025-10-05 18:44:17', '2025-10-05 18:44:17', NULL),
(99, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-05 19:40:32', '2025-10-05 19:40:32', NULL),
(100, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-05 19:40:37', '2025-10-05 19:40:37', NULL),
(101, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-05 19:49:58', '2025-10-05 19:49:58', NULL),
(102, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-05 19:50:09', '2025-10-05 19:50:09', NULL),
(103, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-05 20:24:20', '2025-10-05 20:24:20', NULL),
(104, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-05 20:24:29', '2025-10-05 20:24:29', NULL),
(105, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-06 00:55:08', '2025-10-06 00:55:08', NULL),
(106, 4, 'Imported Business Enterprises', 'User Cyra Cacho imported enterprises for campus Cauayan.', '2025-10-06 04:20:13', '2025-10-06 04:20:13', NULL),
(107, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-06 17:09:36', '2025-10-06 17:09:36', NULL),
(108, 4, 'Imported Business Enterprises', 'User Cyra Cacho imported enterprises for campus Cauayan.', '2025-10-06 18:01:26', '2025-10-06 18:01:26', NULL),
(109, 4, 'Imported Business Enterprises', 'User Cyra Cacho imported enterprises for campus Cauayan.', '2025-10-06 18:25:10', '2025-10-06 18:25:10', NULL),
(110, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-06 21:25:10', '2025-10-06 21:25:10', NULL),
(111, 4, 'Updated Income Record', 'User Cyra Cacho updated income record for enterprise CORN PRODUCTION.', '2025-10-07 03:36:49', '2025-10-07 03:36:49', NULL),
(112, 4, 'Updated Income Record', 'User Cyra Cacho updated income record for enterprise CORN PRODUCTION.', '2025-10-07 03:37:33', '2025-10-07 03:37:33', NULL),
(113, 4, 'Updated Income Record', 'User Cyra Cacho updated income record for enterprise CORN PRODUCTION.', '2025-10-07 03:40:15', '2025-10-07 03:40:15', NULL),
(114, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-07 16:07:51', '2025-10-07 16:07:51', NULL),
(115, 4, 'Imported Business Enterprises', 'User Cyra Cacho imported enterprises for campus Echague.', '2025-10-07 16:30:11', '2025-10-07 16:30:11', NULL),
(116, 4, 'Imported Business Enterprises to Inventory', 'User Cyra Cacho imported enterprises with inventories for campus Cauayan.', '2025-10-07 21:22:42', '2025-10-07 21:22:42', NULL),
(117, 4, 'Imported Business Enterprises to Inventory', 'User Cyra Cacho imported enterprises with inventories for campus Echague.', '2025-10-07 21:23:11', '2025-10-07 21:23:11', NULL),
(118, 4, 'Updated Inventory Item', 'User Cyra Cacho updated inventory item for enterprise: Cap and Gown Rental.', '2025-10-07 21:58:40', '2025-10-07 21:58:40', NULL),
(119, 4, 'Updated Inventory Item', 'User Cyra Cacho updated inventory item for enterprise: Cap and Gown Rental.', '2025-10-07 21:58:46', '2025-10-07 21:58:46', NULL),
(120, 4, 'Updated Inventory Item', 'User Cyra Cacho updated inventory item for enterprise: Computerized ID.', '2025-10-07 23:15:09', '2025-10-07 23:15:09', NULL),
(121, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-08 17:03:23', '2025-10-08 17:03:23', NULL),
(122, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-09 00:19:41', '2025-10-09 00:19:41', NULL),
(123, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-09 16:04:48', '2025-10-09 16:04:48', NULL),
(124, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-09 17:05:33', '2025-10-09 17:05:33', NULL),
(125, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-09 17:05:40', '2025-10-09 17:05:40', NULL),
(126, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-09 17:07:03', '2025-10-09 17:07:03', NULL),
(127, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-09 17:07:08', '2025-10-09 17:07:08', NULL),
(128, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-09 20:27:10', '2025-10-09 20:27:10', NULL),
(129, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-10 06:56:53', '2025-10-10 06:56:53', NULL),
(130, 4, 'Imported Business Enterprises', 'User Cyra Cacho imported enterprises for campus Echague in Expenses table.', '2025-10-10 08:20:50', '2025-10-10 08:20:50', NULL),
(131, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-11 03:26:34', '2025-10-11 03:26:34', NULL),
(132, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-11 15:45:33', '2025-10-11 15:45:33', NULL),
(133, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-12 00:55:35', '2025-10-12 00:55:35', NULL),
(134, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-12 03:43:08', '2025-10-12 03:43:08', NULL),
(135, 4, 'Updated Expense and Budgetary Particulars', 'User Cyra Cacho updated expense ID 1 with new budgeted amount and particulars.', '2025-10-12 06:45:27', '2025-10-12 06:45:27', NULL),
(137, 4, 'Added Creditor Record', 'User Cyra Cacho added a new creditor record.', '2025-10-12 08:44:06', '2025-10-12 08:44:06', NULL),
(138, 4, 'Added Creditor Record', 'User Cyra Cacho added a new creditor record.', '2025-10-12 09:21:40', '2025-10-12 09:21:40', NULL),
(139, 4, 'Added Creditor Record', 'User Cyra Cacho added a new creditor record.', '2025-10-12 09:42:27', '2025-10-12 09:42:27', NULL),
(140, 4, 'Added Creditor Record', 'User Cyra Cacho added a new creditor record.', '2025-10-12 09:46:24', '2025-10-12 09:46:24', NULL),
(141, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-12 16:08:47', '2025-10-12 16:08:47', NULL),
(142, 4, 'Updated Income Record', 'User Cyra Cacho updated income record for enterprise Water Refilling Station.', '2025-10-12 20:36:34', '2025-10-12 20:36:34', NULL),
(143, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-12 23:11:16', '2025-10-12 23:11:16', NULL),
(144, 4, 'Added Creditor Record', 'User Cyra Cacho added a new creditor record.', '2025-10-12 23:12:26', '2025-10-12 23:12:26', NULL),
(145, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-13 17:23:11', '2025-10-13 17:23:11', NULL),
(146, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-13 22:34:13', '2025-10-13 22:34:13', NULL),
(147, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-14 16:09:59', '2025-10-14 16:09:59', NULL),
(148, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-15 00:36:57', '2025-10-15 00:36:57', NULL),
(149, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-15 16:12:30', '2025-10-15 16:12:30', NULL),
(150, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-15 21:57:54', '2025-10-15 21:57:54', NULL),
(151, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-16 16:26:03', '2025-10-16 16:26:03', NULL),
(152, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-16 19:49:57', '2025-10-16 19:49:57', NULL),
(153, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-20 16:01:29', '2025-10-20 16:01:29', NULL),
(154, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-23 16:12:03', '2025-10-23 16:12:03', NULL),
(155, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-23 19:18:50', '2025-10-23 19:18:50', NULL),
(156, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-23 19:18:58', '2025-10-23 19:18:58', NULL),
(157, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-23 19:19:13', '2025-10-23 19:19:13', NULL),
(158, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-23 19:19:21', '2025-10-23 19:19:21', NULL),
(159, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-23 19:21:15', '2025-10-23 19:21:15', NULL),
(160, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-23 19:21:22', '2025-10-23 19:21:22', NULL),
(161, 8, 'Logout', 'User John Doe logged out of the system.', '2025-10-23 19:21:49', '2025-10-23 19:21:49', NULL),
(162, 4, 'Login', 'User Cyra Cacho logged in to the system.', '2025-10-23 19:21:54', '2025-10-23 19:21:54', NULL),
(163, 4, 'Logout', 'User Cyra Cacho logged out of the system.', '2025-10-23 19:22:45', '2025-10-23 19:22:45', NULL),
(164, 8, 'Login', 'User John Doe logged in to the system.', '2025-10-23 19:22:51', '2025-10-23 19:22:51', NULL),
(165, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test 5.', '2025-10-23 19:23:04', '2025-10-23 19:23:04', NULL),
(166, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test 6.', '2025-10-23 19:27:52', '2025-10-23 19:27:52', NULL),
(167, 8, 'Imported Business Enterprises', 'User John Doe imported enterprises for campus Cauayan.', '2025-10-23 19:28:55', '2025-10-23 19:28:55', NULL),
(168, 8, 'Imported Business Enterprises', 'User John Doe imported enterprises for campus Cauayan in Expenses table.', '2025-10-23 19:32:54', '2025-10-23 19:32:54', NULL),
(169, 8, 'Updated Income Record', 'User John Doe updated income record for enterprise Test 6.', '2025-10-23 19:41:27', '2025-10-23 19:41:27', NULL),
(170, 8, 'Updated Income Record', 'User John Doe updated income record for enterprise Test 6.', '2025-10-23 19:52:45', '2025-10-23 19:52:45', NULL),
(171, 8, 'Added Business Enterprise', 'User John Doe added a new business enterprise: Test 7.', '2025-10-23 21:21:27', '2025-10-23 21:21:27', NULL),
(172, 8, 'Updated Inventory Item', 'User John Doe updated inventory item for enterprise: Test 7.', '2025-10-23 21:21:54', '2025-10-23 21:21:54', NULL),
(173, 8, 'Imported Business Enterprises', 'User John Doe imported enterprises for campus Cauayan.', '2025-10-23 21:23:43', '2025-10-23 21:23:43', NULL),
(174, 8, 'Updated Income Record', 'User John Doe updated income record for enterprise Test 6.', '2025-10-23 21:24:58', '2025-10-23 21:24:58', NULL),
(175, 8, 'Updated Expense and Budgetary Particulars', 'User John Doe updated expense ID 50 with new budgeted amount and particulars.', '2025-10-23 21:26:40', '2025-10-23 21:26:40', NULL),
(176, 8, 'Added Creditor Record', 'User John Doe added a new creditor record.', '2025-10-23 21:27:57', '2025-10-23 21:27:57', NULL),
(177, 8, 'Added Creditor Record', 'User John Doe added a new creditor record.', '2025-10-23 21:33:24', '2025-10-23 21:33:24', NULL),
(178, 8, 'Added Creditor Record', 'User John Doe added a new creditor record.', '2025-10-23 21:42:29', '2025-10-23 21:42:29', NULL),
(179, 8, 'Added Creditor Record', 'User John Doe added a new creditor record.', '2025-10-23 21:44:39', '2025-10-23 21:44:39', NULL),
(180, 10, 'Login', 'User Director University logged in to the system.', '2025-11-05 05:04:25', '2025-11-05 05:04:25', NULL),
(181, 10, 'Login', 'User Director University logged in to the system.', '2025-11-05 22:47:13', '2025-11-05 22:47:13', NULL),
(182, 10, 'Updated Inventory Item', 'User Director University updated inventory item for enterprise: N/A.', '2025-11-06 02:28:53', '2025-11-06 02:28:53', NULL),
(183, 10, 'Updated Inventory Item', 'User Director University updated inventory item for enterprise: N/A.', '2025-11-06 02:31:37', '2025-11-06 02:31:37', NULL),
(184, 10, 'Updated Inventory Item', 'User Director University updated inventory item for enterprise: N/A.', '2025-11-06 02:31:49', '2025-11-06 02:31:49', NULL),
(185, 10, 'Updated Inventory Item', 'User Director University updated inventory item for enterprise: N/A.', '2025-11-06 02:36:18', '2025-11-06 02:36:18', NULL),
(186, 10, 'Login', 'User Director University logged in to the system.', '2025-11-06 12:53:20', '2025-11-06 12:53:20', NULL),
(187, 10, 'Login', 'User Director University logged in to the system.', '2025-11-06 23:39:48', '2025-11-06 23:39:48', NULL),
(188, 10, 'Login', 'User Director University logged in to the system.', '2025-11-08 01:36:13', '2025-11-08 01:36:13', NULL),
(189, 10, 'Login', 'User Director University logged in to the system.', '2025-11-08 09:53:22', '2025-11-08 09:53:22', NULL),
(190, 10, 'Login', 'User Director University logged in to the system.', '2025-11-08 15:48:41', '2025-11-08 15:48:41', NULL),
(191, 10, 'Login', 'User Director University logged in to the system.', '2025-11-09 01:25:43', '2025-11-09 01:25:43', NULL),
(192, 10, 'Login', 'User Director University logged in to the system.', '2025-11-10 04:04:00', '2025-11-10 04:04:00', NULL),
(193, 10, 'Login', 'User Director University logged in to the system.', '2025-11-12 08:23:51', '2025-11-12 08:23:51', NULL),
(194, 10, 'Login', 'User Director University logged in to the system.', '2025-11-13 04:55:09', '2025-11-13 04:55:09', NULL),
(195, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:09:31', '2025-11-13 05:09:31', NULL),
(196, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:09:54', '2025-11-13 05:09:54', NULL),
(197, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:11:58', '2025-11-13 05:11:58', NULL),
(198, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:16:33', '2025-11-13 05:16:33', NULL),
(199, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:16:37', '2025-11-13 05:16:37', NULL),
(200, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:16:42', '2025-11-13 05:16:42', NULL),
(201, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:17:41', '2025-11-13 05:17:41', NULL),
(202, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:18:48', '2025-11-13 05:18:48', NULL),
(203, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:19:12', '2025-11-13 05:19:12', NULL),
(204, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:19:18', '2025-11-13 05:19:18', NULL),
(205, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:22:07', '2025-11-13 05:22:07', NULL),
(206, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:22:13', '2025-11-13 05:22:13', NULL),
(207, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:23:00', '2025-11-13 05:23:00', NULL),
(208, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-13 05:23:04', '2025-11-13 05:23:04', NULL),
(209, 10, 'Login', 'User Director University logged in to the system.', '2025-11-13 10:07:53', '2025-11-13 10:07:53', NULL),
(210, 10, 'Login', 'User Director University logged in to the system.', '2025-11-14 01:57:30', '2025-11-14 01:57:30', NULL),
(211, 10, 'Login', 'User Director University logged in to the system.', '2025-11-15 08:18:56', '2025-11-15 08:18:56', NULL),
(212, 10, 'Login', 'User Director University logged in to the system.', '2025-11-15 13:11:07', '2025-11-15 13:11:07', NULL),
(213, 10, 'Login', 'User Director University logged in to the system.', '2025-11-16 06:24:20', '2025-11-16 06:24:20', NULL),
(214, 10, 'Login', 'User Director University logged in to the system.', '2025-11-16 11:34:19', '2025-11-16 11:34:19', NULL),
(215, 10, 'Login', 'User Director University logged in to the system.', '2025-11-17 00:36:48', '2025-11-17 00:36:48', NULL),
(216, 10, 'Login', 'User Director University logged in to the system.', '2025-11-17 12:14:01', '2025-11-17 12:14:01', NULL),
(217, 10, 'Login', 'User Director University logged in to the system.', '2025-11-18 11:58:56', '2025-11-18 11:58:56', NULL),
(218, 10, 'Login', 'User Director University logged in to the system.', '2025-11-18 16:11:05', '2025-11-18 16:11:05', NULL),
(219, 10, 'Login', 'User Director University logged in to the system.', '2025-11-19 00:27:03', '2025-11-19 00:27:03', NULL),
(220, 10, 'Login', 'User Director University logged in to the system.', '2025-11-20 13:26:45', '2025-11-20 13:26:45', NULL),
(221, 10, 'Login', 'User Director University logged in to the system.', '2025-11-22 05:54:49', '2025-11-22 05:54:49', NULL),
(222, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-22 08:00:52', '2025-11-22 08:00:52', NULL),
(223, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-22 08:00:57', '2025-11-22 08:00:57', NULL),
(224, 10, 'Login', 'User Director University logged in to the system.', '2025-11-22 22:49:18', '2025-11-22 22:49:18', NULL),
(225, 10, 'Login', 'User Director University logged in to the system.', '2025-11-23 02:54:47', '2025-11-23 02:54:47', NULL),
(226, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-23 03:30:09', '2025-11-23 03:30:09', NULL),
(227, 10, 'Updated Transcation Status', 'User Director University updated transaction status for enterprise: N/A.', '2025-11-23 03:30:15', '2025-11-23 03:30:15', NULL),
(228, 10, 'Login', 'User Director University logged in to the system.', '2025-11-23 11:51:11', '2025-11-23 11:51:11', NULL),
(229, 10, 'Login', 'User Director University logged in to the system.', '2025-11-23 14:56:19', '2025-11-23 14:56:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `years`
--

CREATE TABLE `years` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `year` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `years`
--

INSERT INTO `years` (`id`, `year`, `created_at`, `updated_at`, `deleted_at`) VALUES
(2024, 2024, '2025-10-05 20:47:45', '2025-10-05 21:02:06', NULL),
(2025, 2025, '2025-10-05 21:02:13', '2025-10-05 21:02:13', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `campuses`
--
ALTER TABLE `campuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `creditors`
--
ALTER TABLE `creditors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `creditors_expenses_id_foreign` (`expenses_id`),
  ADD KEY `creditors_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `creditor_has_uacs`
--
ALTER TABLE `creditor_has_uacs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `creditor_has_uacs_creditor_id_foreign` (`creditor_id`),
  ADD KEY `creditor_has_uacs_uacs_id_foreign` (`uacs_id`),
  ADD KEY `creditor_has_uacs_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `designations`
--
ALTER TABLE `designations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `enterprises`
--
ALTER TABLE `enterprises`
  ADD PRIMARY KEY (`id`),
  ADD KEY `enterprises_campus_id_foreign` (`campus_id`),
  ADD KEY `enterprises_user_id_foreign` (`user_id`),
  ADD KEY `enterprises_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_year_id_foreign` (`year_id`),
  ADD KEY `expenses_campus_id_foreign` (`campus_id`),
  ADD KEY `expenses_enterprise_id_foreign` (`enterprise_id`),
  ADD KEY `expenses_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `expense_budgetary_requirements`
--
ALTER TABLE `expense_budgetary_requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_budgetary_requirements_expense_id_foreign` (`expense_id`),
  ADD KEY `expense_budgetary_requirements_particular_id_foreign` (`particular_id`),
  ADD KEY `expense_budgetary_requirements_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `expense_budget_particulars`
--
ALTER TABLE `expense_budget_particulars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expense_budget_particulars_expense_id_foreign` (`expense_id`),
  ADD KEY `expense_budget_particulars_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `expense_particulars`
--
ALTER TABLE `expense_particulars`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `expense_particulars_particular_name_unique` (`particular_name`),
  ADD KEY `expense_particulars_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `incomes`
--
ALTER TABLE `incomes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `incomes_year_id_foreign` (`year_id`),
  ADD KEY `incomes_campus_id_foreign` (`campus_id`),
  ADD KEY `incomes_enterprise_id_foreign` (`enterprise_id`),
  ADD KEY `incomes_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventories_campus_id_foreign` (`campus_id`),
  ADD KEY `inventories_enterprise_id_foreign` (`enterprise_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus_id` (`campus_id`);

--
-- Indexes for table `proposals`
--
ALTER TABLE `proposals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposals_campus_id_foreign` (`campus_id`),
  ADD KEY `proposals_user_id_foreign` (`user_id`),
  ADD KEY `proposals_evaluated_by_foreign` (`evaluated_by`),
  ADD KEY `proposals_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `proposal_remarks`
--
ALTER TABLE `proposal_remarks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposal_remarks_proposal_id_foreign` (`proposal_id`),
  ADD KEY `proposal_remarks_user_id_foreign` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_campus_id_foreign` (`campus_id`),
  ADD KEY `transaction_product_id_foreign` (`product_id`);

--
-- Indexes for table `uacs`
--
ALTER TABLE `uacs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uacs_uacs_code_unique` (`uacs_code`),
  ADD KEY `uacs_uacs_group_id_foreign` (`uacs_group_id`);

--
-- Indexes for table `uacs_groups`
--
ALTER TABLE `uacs_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uacs_groups_name_unique` (`name`),
  ADD UNIQUE KEY `uacs_groups_code_unique` (`code`),
  ADD KEY `uacs_groups_uacs_type_id_foreign` (`uacs_type_id`);

--
-- Indexes for table `uacs_types`
--
ALTER TABLE `uacs_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uacs_types_name_unique` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_campus_id_foreign` (`campus_id`),
  ADD KEY `users_user_id_foreign` (`user_id`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `years`
--
ALTER TABLE `years`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `campuses`
--
ALTER TABLE `campuses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `creditors`
--
ALTER TABLE `creditors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `creditor_has_uacs`
--
ALTER TABLE `creditor_has_uacs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `designations`
--
ALTER TABLE `designations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `enterprises`
--
ALTER TABLE `enterprises`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `expense_budgetary_requirements`
--
ALTER TABLE `expense_budgetary_requirements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expense_budget_particulars`
--
ALTER TABLE `expense_budget_particulars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `expense_particulars`
--
ALTER TABLE `expense_particulars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `incomes`
--
ALTER TABLE `incomes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `inventories`
--
ALTER TABLE `inventories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `product_inventory`
--
ALTER TABLE `product_inventory`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `proposals`
--
ALTER TABLE `proposals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `proposal_remarks`
--
ALTER TABLE `proposal_remarks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `uacs`
--
ALTER TABLE `uacs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `uacs_groups`
--
ALTER TABLE `uacs_groups`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=204;

--
-- AUTO_INCREMENT for table `uacs_types`
--
ALTER TABLE `uacs_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;

--
-- AUTO_INCREMENT for table `years`
--
ALTER TABLE `years`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2026;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `creditors`
--
ALTER TABLE `creditors`
  ADD CONSTRAINT `creditors_expenses_id_foreign` FOREIGN KEY (`expenses_id`) REFERENCES `expenses` (`id`),
  ADD CONSTRAINT `creditors_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `creditor_has_uacs`
--
ALTER TABLE `creditor_has_uacs`
  ADD CONSTRAINT `creditor_has_uacs_creditor_id_foreign` FOREIGN KEY (`creditor_id`) REFERENCES `creditors` (`id`),
  ADD CONSTRAINT `creditor_has_uacs_uacs_id_foreign` FOREIGN KEY (`uacs_id`) REFERENCES `uacs` (`id`),
  ADD CONSTRAINT `creditor_has_uacs_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `enterprises`
--
ALTER TABLE `enterprises`
  ADD CONSTRAINT `enterprises_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `enterprises_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `enterprises_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `expenses_enterprise_id_foreign` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`),
  ADD CONSTRAINT `expenses_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `expenses_year_id_foreign` FOREIGN KEY (`year_id`) REFERENCES `years` (`id`);

--
-- Constraints for table `expense_budgetary_requirements`
--
ALTER TABLE `expense_budgetary_requirements`
  ADD CONSTRAINT `expense_budgetary_requirements_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`),
  ADD CONSTRAINT `expense_budgetary_requirements_particular_id_foreign` FOREIGN KEY (`particular_id`) REFERENCES `expense_particulars` (`id`),
  ADD CONSTRAINT `expense_budgetary_requirements_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `expense_budget_particulars`
--
ALTER TABLE `expense_budget_particulars`
  ADD CONSTRAINT `expense_budget_particulars_expense_id_foreign` FOREIGN KEY (`expense_id`) REFERENCES `expenses` (`id`),
  ADD CONSTRAINT `expense_budget_particulars_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `expense_particulars`
--
ALTER TABLE `expense_particulars`
  ADD CONSTRAINT `expense_particulars_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `incomes`
--
ALTER TABLE `incomes`
  ADD CONSTRAINT `incomes_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `incomes_enterprise_id_foreign` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`),
  ADD CONSTRAINT `incomes_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `incomes_year_id_foreign` FOREIGN KEY (`year_id`) REFERENCES `years` (`id`);

--
-- Constraints for table `inventories`
--
ALTER TABLE `inventories`
  ADD CONSTRAINT `inventories_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `inventories_enterprise_id_foreign` FOREIGN KEY (`enterprise_id`) REFERENCES `enterprises` (`id`);

--
-- Constraints for table `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD CONSTRAINT `campus_id` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `proposals`
--
ALTER TABLE `proposals`
  ADD CONSTRAINT `proposals_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `proposals_evaluated_by_foreign` FOREIGN KEY (`evaluated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `proposals_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `proposals_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `proposal_remarks`
--
ALTER TABLE `proposal_remarks`
  ADD CONSTRAINT `proposal_remarks_proposal_id_foreign` FOREIGN KEY (`proposal_id`) REFERENCES `proposals` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proposal_remarks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `transaction_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `product_inventory` (`id`);

--
-- Constraints for table `uacs`
--
ALTER TABLE `uacs`
  ADD CONSTRAINT `uacs_uacs_group_id_foreign` FOREIGN KEY (`uacs_group_id`) REFERENCES `uacs_groups` (`id`);

--
-- Constraints for table `uacs_groups`
--
ALTER TABLE `uacs_groups`
  ADD CONSTRAINT `uacs_groups_uacs_type_id_foreign` FOREIGN KEY (`uacs_type_id`) REFERENCES `uacs_types` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_campus_id_foreign` FOREIGN KEY (`campus_id`) REFERENCES `campuses` (`id`),
  ADD CONSTRAINT `users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD CONSTRAINT `user_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
