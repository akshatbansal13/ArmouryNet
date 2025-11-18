-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: battalion_inventory
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alerts` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `alert_type` enum('Low Stock','Expiry','Maintenance Due') NOT NULL,
  `related_entity_id` int NOT NULL,
  `related_entity_type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `alert_date` date DEFAULT (curdate()),
  `is_resolved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`alert_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (1,'Low Stock',1,'Ammunition','5.56mm Ball is running low. Current stock: 4900','2025-10-14',0),(2,'Expiry',3,'Ration','Sugar at Company ID 3 has expired on 01-09-2025','2025-10-17',0),(3,'Maintenance Due',2,'Military_Transport','Vehicle No: BA-01-T-5678 requires maintenance by 20-10-2025','2025-10-17',0),(4,'Low Stock',5,'BattalionStock','Wheat Flour (Lot: 1) in QM Store is running low.','2025-11-07',1),(5,'Low Stock',5,'BattalionStock','Wheat Flour (Lot: 1) in QM Store is running low.','2025-11-07',1),(6,'Low Stock',5,'BattalionStock','Wheat Flour (Lot: 1) in QM Store is running low.','2025-11-07',1),(7,'Low Stock',4,'Ammunition','5.56mm Ball is running low. Current stock: 100','2025-11-08',1),(8,'Low Stock',4,'Fuel','oil is running low. Current stock: 5.00L','2025-11-08',1);
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ammunition`
--

DROP TABLE IF EXISTS `ammunition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ammunition` (
  `ammo_id` int NOT NULL AUTO_INCREMENT,
  `ammo_type` varchar(100) NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `lot_number` varchar(100) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `low_stock_threshold` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ammo_id`),
  CONSTRAINT `chk_ammo_quantity` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ammunition`
--

LOCK TABLES `ammunition` WRITE;
/*!40000 ALTER TABLE `ammunition` DISABLE KEYS */;
INSERT INTO `ammunition` VALUES (1,'5.56mm Ball',5700,'LOT-101/24','2034-12-31',5000),(2,'9mm Ball',2000,'LOT-202/23','2033-12-31',1000),(3,'81mm HE',100,'LOT-301/22','2032-12-31',20);
/*!40000 ALTER TABLE `ammunition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ammunition_log`
--

DROP TABLE IF EXISTS `ammunition_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ammunition_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `ammo_id` int NOT NULL,
  `transaction_type` enum('Received','Issued_Training','Issued_Operational','Returned','Expended','Audit_Correction','Issued_to_Company','Returned_from_Company','Issued_to_Soldier','Returned_from_Soldier') NOT NULL,
  `quantity_change` int NOT NULL,
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `authorizing_officer_id` int NOT NULL,
  `recipient_company_id` int DEFAULT NULL,
  `recipient_soldier_id` int DEFAULT NULL,
  `remarks` text,
  PRIMARY KEY (`log_id`),
  KEY `fk_ammolog_ammo` (`ammo_id`),
  KEY `fk_ammolog_authorizer` (`authorizing_officer_id`),
  KEY `fk_ammolog_company` (`recipient_company_id`),
  KEY `fk_ammolog_soldier` (`recipient_soldier_id`),
  CONSTRAINT `fk_ammolog_ammo` FOREIGN KEY (`ammo_id`) REFERENCES `ammunition` (`ammo_id`),
  CONSTRAINT `fk_ammolog_authorizer` FOREIGN KEY (`authorizing_officer_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `fk_ammolog_company` FOREIGN KEY (`recipient_company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `fk_ammolog_soldier` FOREIGN KEY (`recipient_soldier_id`) REFERENCES `soldiers` (`soldier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ammunition_log`
--

LOCK TABLES `ammunition_log` WRITE;
/*!40000 ALTER TABLE `ammunition_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ammunition_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battalionstock`
--

DROP TABLE IF EXISTS `battalionstock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `battalionstock` (
  `stock_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(255) NOT NULL,
  `lot_number` varchar(100) NOT NULL,
  `quantity_kg` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expiry_date` date DEFAULT NULL,
  `low_stock_threshold` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`stock_id`),
  UNIQUE KEY `uq_item_lot` (`item_name`,`lot_number`),
  CONSTRAINT `chk_battalion_stock_qty` CHECK ((`quantity_kg` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battalionstock`
--

LOCK TABLES `battalionstock` WRITE;
/*!40000 ALTER TABLE `battalionstock` DISABLE KEYS */;
INSERT INTO `battalionstock` VALUES (4,'Rice','1',100.00,'2026-09-30',0.00),(5,'Wheat Flour','1',500.00,'2026-02-15',100.00);
/*!40000 ALTER TABLE `battalionstock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `company_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) NOT NULL,
  `company_commander_id` int NOT NULL,
  PRIMARY KEY (`company_id`),
  UNIQUE KEY `company_name` (`company_name`),
  KEY `fk_companies_commander` (`company_commander_id`),
  CONSTRAINT `fk_companies_commander` FOREIGN KEY (`company_commander_id`) REFERENCES `soldiers` (`soldier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Alpha Company',101),(2,'Bravo Company',201),(3,'Charlie Company',301),(4,'Delta Company',401),(5,'Headquarter Company',1),(6,'Support Company',601);
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuel_lubricants`
--

DROP TABLE IF EXISTS `fuel_lubricants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuel_lubricants` (
  `fuel_id` int NOT NULL AUTO_INCREMENT,
  `fuel_type` varchar(100) NOT NULL,
  `quantity_liters` decimal(10,2) NOT NULL,
  `low_stock_threshold` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`fuel_id`),
  UNIQUE KEY `fuel_type` (`fuel_type`),
  CONSTRAINT `chk_fuel_quantity` CHECK ((`quantity_liters` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuel_lubricants`
--

LOCK TABLES `fuel_lubricants` WRITE;
/*!40000 ALTER TABLE `fuel_lubricants` DISABLE KEYS */;
INSERT INTO `fuel_lubricants` VALUES (1,'Diesel',1700.00,500.00),(2,'Petrol',950.50,100.00);
/*!40000 ALTER TABLE `fuel_lubricants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_records`
--

DROP TABLE IF EXISTS `leave_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_records` (
  `leave_id` int NOT NULL AUTO_INCREMENT,
  `soldier_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `leave_type` enum('Annual','Casual') NOT NULL,
  `reason` text,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `approved_by_id` int DEFAULT NULL,
  PRIMARY KEY (`leave_id`),
  KEY `fk_leave_soldier` (`soldier_id`),
  KEY `fk_leave_approver` (`approved_by_id`),
  CONSTRAINT `fk_leave_approver` FOREIGN KEY (`approved_by_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `fk_leave_soldier` FOREIGN KEY (`soldier_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `chk_leave_dates` CHECK ((`end_date` >= `start_date`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_records`
--

LOCK TABLES `leave_records` WRITE;
/*!40000 ALTER TABLE `leave_records` DISABLE KEYS */;
INSERT INTO `leave_records` VALUES (1,307,'2025-10-10','2025-10-25','Annual','as per leave plan','Approved',301),(2,107,'2025-11-07','2025-11-30','Annual','as per leave plan','Approved',3),(3,107,'2025-12-01','2025-12-15','Casual','as per leave plan','Approved',101);
/*!40000 ALTER TABLE `leave_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `military_transport`
--

DROP TABLE IF EXISTS `military_transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `military_transport` (
  `mt_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_number` varchar(50) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `odometer_reading` int NOT NULL DEFAULT '0' COMMENT 'Current (latest) odometer reading in km',
  `driver_id` int DEFAULT NULL,
  `status` enum('Operational','On-Duty','In-Repair') DEFAULT 'Operational',
  `last_maintenance` date DEFAULT NULL,
  `next_maintenance` date DEFAULT NULL,
  PRIMARY KEY (`mt_id`),
  UNIQUE KEY `vehicle_number` (`vehicle_number`),
  KEY `fk_mt_driver` (`driver_id`),
  CONSTRAINT `fk_mt_driver` FOREIGN KEY (`driver_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `chk_mt_maintenance_dates` CHECK (((`next_maintenance` is null) or (`last_maintenance` is null) or (`next_maintenance` > `last_maintenance`)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `military_transport`
--

LOCK TABLES `military_transport` WRITE;
/*!40000 ALTER TABLE `military_transport` DISABLE KEYS */;
INSERT INTO `military_transport` VALUES (1,'BA-01-G-1234','GS 4x4','Tata Safari Storme',0,504,'Operational','2025-08-10','2026-02-10'),(2,'BA-01-T-5678','Truck 5T','Ashok Leyland Stallion',0,505,'Operational','2025-09-20','2025-10-20'),(3,'BA-01-C-2222','GS 4*4','Maruti Suzuki Jeep ',0,NULL,'In-Repair',NULL,NULL);
/*!40000 ALTER TABLE `military_transport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mt_fuel_log`
--

DROP TABLE IF EXISTS `mt_fuel_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mt_fuel_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `mt_id` int NOT NULL,
  `fuel_id` int NOT NULL,
  `quantity_drawn` decimal(10,2) NOT NULL,
  `odometer_reading` int DEFAULT NULL,
  `date_drawn` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_fuellog_mt` (`mt_id`),
  KEY `fk_fuellog_fuel` (`fuel_id`),
  CONSTRAINT `fk_fuellog_fuel` FOREIGN KEY (`fuel_id`) REFERENCES `fuel_lubricants` (`fuel_id`),
  CONSTRAINT `fk_fuellog_mt` FOREIGN KEY (`mt_id`) REFERENCES `military_transport` (`mt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mt_fuel_log`
--

LOCK TABLES `mt_fuel_log` WRITE;
/*!40000 ALTER TABLE `mt_fuel_log` DISABLE KEYS */;
INSERT INTO `mt_fuel_log` VALUES (4,1,1,100.00,0,'2025-11-12 21:38:39');
/*!40000 ALTER TABLE `mt_fuel_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ration_log`
--

DROP TABLE IF EXISTS `ration_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ration_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `ration_id` int NOT NULL,
  `company_id` int NOT NULL,
  `transaction_type` enum('Received_from_QM','Consumed_Daily','Spoilage/Waste','Returned_to_QM') NOT NULL,
  `quantity_change` decimal(10,2) NOT NULL,
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `performed_by_id` int DEFAULT NULL,
  `remarks` text,
  PRIMARY KEY (`log_id`),
  KEY `fk_rationlog_item` (`ration_id`),
  KEY `fk_rationlog_company` (`company_id`),
  CONSTRAINT `fk_rationlog_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `fk_rationlog_item` FOREIGN KEY (`ration_id`) REFERENCES `rations` (`ration_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ration_log`
--

LOCK TABLES `ration_log` WRITE;
/*!40000 ALTER TABLE `ration_log` DISABLE KEYS */;
INSERT INTO `ration_log` VALUES (1,6,1,'Consumed_Daily',-100.00,'2025-11-18 18:54:30',104,'lunch for 100 men'),(2,6,1,'Returned_to_QM',-100.00,'2025-11-18 19:00:17',104,'Returned to Battalion Store');
/*!40000 ALTER TABLE `ration_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rations`
--

DROP TABLE IF EXISTS `rations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rations` (
  `ration_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(255) NOT NULL,
  `lot_number` varchar(100) NOT NULL,
  `assigned_company_id` int NOT NULL,
  `quantity_kg` decimal(10,2) NOT NULL,
  `low_stock_threshold` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expiry_date` date DEFAULT NULL,
  PRIMARY KEY (`ration_id`),
  UNIQUE KEY `uq_item_company` (`item_name`,`assigned_company_id`),
  UNIQUE KEY `uq_item_lot_company` (`item_name`,`lot_number`,`assigned_company_id`),
  KEY `fk_rations_company` (`assigned_company_id`),
  CONSTRAINT `fk_rations_company` FOREIGN KEY (`assigned_company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `chk_ration_quantity` CHECK ((`quantity_kg` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rations`
--

LOCK TABLES `rations` WRITE;
/*!40000 ALTER TABLE `rations` DISABLE KEYS */;
INSERT INTO `rations` VALUES (2,'Wheat Flour','1',2,80.00,150.00,'2026-06-30'),(3,'Sugar','1',3,150.00,50.00,'2025-09-01'),(4,'Lentils','1',4,200.00,50.00,'2027-01-01'),(6,'Rice','1',1,300.00,0.00,'2026-09-30');
/*!40000 ALTER TABLE `rations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soldier_weapon_assignments`
--

DROP TABLE IF EXISTS `soldier_weapon_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soldier_weapon_assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `soldier_id` int NOT NULL,
  `weapon_id` int NOT NULL,
  `assignment_date` date DEFAULT (curdate()),
  PRIMARY KEY (`assignment_id`),
  UNIQUE KEY `weapon_id` (`weapon_id`),
  KEY `fk_assignment_soldier` (`soldier_id`),
  CONSTRAINT `fk_assignment_soldier` FOREIGN KEY (`soldier_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `fk_assignment_weapon` FOREIGN KEY (`weapon_id`) REFERENCES `weapons` (`weapon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soldier_weapon_assignments`
--

LOCK TABLES `soldier_weapon_assignments` WRITE;
/*!40000 ALTER TABLE `soldier_weapon_assignments` DISABLE KEYS */;
INSERT INTO `soldier_weapon_assignments` VALUES (1,107,101,'2025-10-14'),(2,108,102,'2025-10-14'),(3,101,106,'2025-10-14'),(4,207,201,'2025-10-14'),(5,208,202,'2025-10-14'),(6,201,206,'2025-10-14'),(7,308,301,'2025-10-14'),(8,307,302,'2025-10-14'),(9,301,306,'2025-10-14'),(10,407,401,'2025-10-14'),(11,408,402,'2025-10-14'),(12,401,406,'2025-10-14'),(13,1,501,'2025-10-14'),(14,603,601,'2025-10-14');
/*!40000 ALTER TABLE `soldier_weapon_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `soldiers`
--

DROP TABLE IF EXISTS `soldiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `soldiers` (
  `soldier_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `rank` varchar(50) NOT NULL,
  `dob` date DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `company_id` int NOT NULL,
  `status` enum('Active','On Leave','Discharged') NOT NULL DEFAULT 'Active',
  `total_annual_leave` int DEFAULT '30',
  `remaining_annual_leave` int DEFAULT NULL,
  `total_casual_leave` int DEFAULT '15',
  `remaining_casual_leave` int DEFAULT NULL,
  PRIMARY KEY (`soldier_id`),
  UNIQUE KEY `contact` (`contact`),
  KEY `fk_soldiers_company` (`company_id`),
  CONSTRAINT `fk_soldiers_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=607 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `soldiers`
--

LOCK TABLES `soldiers` WRITE;
/*!40000 ALTER TABLE `soldiers` DISABLE KEYS */;
INSERT INTO `soldiers` VALUES (1,'Soldier 1','Lieutenant Colonel','1980-05-20','9999988888',5,'Active',30,30,15,15),(2,'Soldier 2','Major','1985-11-15',NULL,5,'Active',30,30,15,15),(3,'Soldier 3','Captain','1990-08-01',NULL,5,'Active',30,30,15,15),(4,'Soldier 4','Major','1986-02-25',NULL,5,'Active',30,30,15,15),(5,'Soldier 5','Subedar Major','1975-01-10',NULL,5,'Active',30,30,15,15),(101,'Soldier 101','Major','1987-07-22',NULL,1,'Active',30,30,15,15),(102,'Soldier 102','Subedar','1982-03-12',NULL,1,'Active',30,30,15,15),(103,'Soldier 103','Havildar','1992-06-18',NULL,1,'Active',30,30,15,15),(104,'Soldier 104','Havildar','1993-01-30',NULL,1,'Active',30,30,15,15),(105,'Soldier 105','Naik','1995-04-10',NULL,1,'Active',30,30,15,15),(106,'Soldier 106','Naik','1996-05-20',NULL,1,'Active',30,30,15,15),(107,'Soldier 107','Sepoy','2001-02-11','9898989898',1,'Active',30,6,15,0),(108,'Soldier 108','Sepoy','2002-03-22',NULL,1,'Active',30,30,15,15),(109,'Soldier 109','Sepoy','2002-07-07',NULL,1,'Active',30,30,15,15),(110,'Soldier 110','Sepoy','2003-01-01',NULL,1,'Active',30,30,15,15),(111,'Soldier 111','Sepoy','2003-08-15',NULL,1,'Active',30,30,15,15),(112,'Soldier 112','Sepoy','2004-05-09',NULL,1,'Active',30,30,15,15),(201,'Soldier 201','Major','1988-01-15',NULL,2,'Active',30,30,15,15),(202,'Soldier 202','Subedar','1983-04-20',NULL,2,'Active',30,30,15,15),(203,'Soldier 203','Havildar','1993-07-01',NULL,2,'Active',30,30,15,15),(204,'Soldier 204','Havildar','1994-02-12',NULL,2,'Active',30,30,15,15),(205,'Soldier 205','Naik','1996-09-03',NULL,2,'Active',30,30,15,15),(206,'Soldier 206','Naik','1997-10-14',NULL,2,'Active',30,30,15,15),(207,'Soldier 207','Sepoy','2002-04-25',NULL,2,'Active',30,30,15,15),(208,'Soldier 208','Sepoy','2002-09-16',NULL,2,'Active',30,30,15,15),(209,'Soldier 209','Sepoy','2003-03-27',NULL,2,'Active',30,30,15,15),(210,'Soldier 210','Sepoy','2003-11-08',NULL,2,'Active',30,30,15,15),(211,'Soldier 211','Sepoy','2004-01-19',NULL,2,'Active',30,30,15,15),(212,'Soldier 212','Sepoy','2004-06-30',NULL,2,'Active',30,30,15,15),(301,'Soldier 301','Captain','1990-12-05',NULL,3,'Active',30,30,15,15),(302,'Soldier 302','Naib Subedar','1985-06-25',NULL,3,'Active',30,30,15,15),(303,'Soldier 303','Havildar','1994-08-07',NULL,3,'Active',30,30,15,15),(304,'Soldier 304','Havildar','1995-03-18',NULL,3,'Active',30,30,15,15),(305,'Soldier 305','Naik','1997-11-20',NULL,3,'Active',30,30,15,15),(306,'Soldier 306','Naik','1998-01-21',NULL,3,'Active',30,30,15,15),(307,'Soldier 307','Sepoy','2003-05-02',NULL,3,'Active',30,30,15,15),(308,'Soldier 308','Sepoy','2003-10-13',NULL,3,'Active',30,30,15,15),(309,'Soldier 309','Sepoy','2004-02-24',NULL,3,'Active',30,30,15,15),(310,'Soldier 310','Sepoy','2004-07-05',NULL,3,'Active',30,30,15,15),(311,'Soldier 311','Sepoy','2004-12-16',NULL,3,'Active',30,30,15,15),(312,'Soldier 312','Sepoy','2005-02-27',NULL,3,'Active',30,30,15,15),(401,'Soldier 401','Captain','1991-10-10',NULL,4,'Active',30,30,15,15),(402,'Soldier 402','Naib Subedar','1986-07-17',NULL,4,'Active',30,30,15,15),(403,'Soldier 403','Havildar','1995-09-11',NULL,4,'Active',30,30,15,15),(404,'Soldier 404','Havildar','1996-04-22',NULL,4,'Active',30,30,15,15),(405,'Soldier 405','Naik','1998-12-04',NULL,4,'Active',30,30,15,15),(406,'Soldier 406','Naik','1999-02-15',NULL,4,'Active',30,30,15,15),(407,'Soldier 407','Sepoy','2004-06-07',NULL,4,'Active',30,30,15,15),(408,'Soldier 408','Sepoy','2004-11-18',NULL,4,'Active',30,30,15,15),(409,'Soldier 409','Sepoy','2005-01-29',NULL,4,'Active',30,30,15,15),(410,'Soldier 410','Sepoy','2005-04-10',NULL,4,'Active',30,30,15,15),(411,'Soldier 411','Sepoy','2005-08-21',NULL,4,'Active',30,30,15,15),(412,'Soldier 412','Sepoy','2005-10-01',NULL,4,'Active',30,30,15,15),(501,'Soldier 501','Captain','1992-02-15',NULL,5,'Active',30,30,15,15),(502,'Soldier 502','Naib Subedar','1985-10-05',NULL,5,'Active',30,30,15,15),(503,'Soldier 503','Havildar','1994-07-21',NULL,5,'Active',30,30,15,15),(504,'Soldier 504','Sepoy','2001-12-01',NULL,5,'Active',30,30,15,15),(505,'Soldier 505','Sepoy','2002-01-08',NULL,5,'Active',30,30,15,15),(601,'Soldier 601','Major','1988-09-01',NULL,6,'Active',30,30,15,15),(602,'Soldier 602','Subedar','1984-01-20',NULL,6,'Active',30,30,15,15),(603,'Soldier 603','Havildar','1993-11-11',NULL,6,'Active',30,30,15,15),(604,'Soldier 604','Naik','1997-06-06',NULL,6,'Active',30,30,15,15),(605,'Soldier 605','Sepoy','2002-10-10',NULL,6,'Active',30,30,15,15),(606,'Soldier 606','Sepoy','2000-07-07','8888899999',6,'Discharged',30,30,15,15);
/*!40000 ALTER TABLE `soldiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `soldier_id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('CO','Adjutant','QM','CompanyCommander','MTO','MT_JCO','Company_Weapon_Incharge','Battalion_Ammo_Incharge','Company_Ration_Incharge','Fuel_NCO','Soldier') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `soldier_id` (`soldier_id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `fk_users_soldier` FOREIGN KEY (`soldier_id`) REFERENCES `soldiers` (`soldier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'co.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CO'),(2,3,'adjutant.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','Adjutant'),(3,4,'qm.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','QM'),(4,101,'cc.alpha','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CompanyCommander'),(5,103,'wi.alpha','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','Company_Weapon_Incharge'),(6,104,'ri.alpha','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','Company_Ration_Incharge'),(7,201,'cc.bravo','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CompanyCommander'),(8,301,'cc.charlie','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CompanyCommander'),(9,401,'cc.delta','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CompanyCommander'),(10,501,'mto.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','MTO'),(11,502,'mtjco.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','MT_JCO'),(12,503,'fuelnco.user','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','Fuel_NCO'),(13,601,'cc.support','$2b$10$Ktb2F7HKfpd3fLMDNZl1teGPppwvZtUtZH5OMCwXlUXihLS2cMQCG','CompanyCommander'),(14,107,'soldier107','$2b$10$uk1R5pcuzPoVW4Re11DHKur9yP2I2oF5JUpsDkl7sn1hDNK.oZ0wK','Soldier'),(15,606,'soldier606','$2b$10$VGDnum5iXEwe/pYbgoLuu.ZGibEH2oB9OkdH2GvcIxOI9VrPXwhSW','Soldier');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_activealerts`
--

DROP TABLE IF EXISTS `view_activealerts`;
/*!50001 DROP VIEW IF EXISTS `view_activealerts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_activealerts` AS SELECT 
 1 AS `alert_id`,
 1 AS `alert_type`,
 1 AS `message`,
 1 AS `alert_date_formatted`,
 1 AS `related_entity_type`,
 1 AS `related_entity_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_allleaverecords`
--

DROP TABLE IF EXISTS `view_allleaverecords`;
/*!50001 DROP VIEW IF EXISTS `view_allleaverecords`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_allleaverecords` AS SELECT 
 1 AS `leave_id`,
 1 AS `soldier_id`,
 1 AS `soldier_name`,
 1 AS `rank`,
 1 AS `company_name`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `leave_type`,
 1 AS `reason`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_allpendingleaverequests`
--

DROP TABLE IF EXISTS `view_allpendingleaverequests`;
/*!50001 DROP VIEW IF EXISTS `view_allpendingleaverequests`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_allpendingleaverequests` AS SELECT 
 1 AS `leave_id`,
 1 AS `soldier_id`,
 1 AS `soldier_name`,
 1 AS `rank`,
 1 AS `company_name`,
 1 AS `company_id`,
 1 AS `start_date_formatted`,
 1 AS `end_date_formatted`,
 1 AS `leave_type`,
 1 AS `reason`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_battalionmasterinventory`
--

DROP TABLE IF EXISTS `view_battalionmasterinventory`;
/*!50001 DROP VIEW IF EXISTS `view_battalionmasterinventory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_battalionmasterinventory` AS SELECT 
 1 AS `category`,
 1 AS `total_items`,
 1 AS `serviceable_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_battalionpersonneloverview`
--

DROP TABLE IF EXISTS `view_battalionpersonneloverview`;
/*!50001 DROP VIEW IF EXISTS `view_battalionpersonneloverview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_battalionpersonneloverview` AS SELECT 
 1 AS `company_name`,
 1 AS `total_strength`,
 1 AS `officers`,
 1 AS `jcos`,
 1 AS `other_ranks`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_companyarmskote`
--

DROP TABLE IF EXISTS `view_companyarmskote`;
/*!50001 DROP VIEW IF EXISTS `view_companyarmskote`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_companyarmskote` AS SELECT 
 1 AS `assigned_company_id`,
 1 AS `company_name`,
 1 AS `weapon_id`,
 1 AS `serial_number`,
 1 AS `model`,
 1 AS `type`,
 1 AS `status`,
 1 AS `allocated_to`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_companyreadinessstatus`
--

DROP TABLE IF EXISTS `view_companyreadinessstatus`;
/*!50001 DROP VIEW IF EXISTS `view_companyreadinessstatus`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_companyreadinessstatus` AS SELECT 
 1 AS `soldier_id`,
 1 AS `name`,
 1 AS `rank`,
 1 AS `company_name`,
 1 AS `serial_number`,
 1 AS `weapon_model`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_mto_dashboard`
--

DROP TABLE IF EXISTS `view_mto_dashboard`;
/*!50001 DROP VIEW IF EXISTS `view_mto_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_mto_dashboard` AS SELECT 
 1 AS `mt_id`,
 1 AS `vehicle_number`,
 1 AS `model`,
 1 AS `odometer_reading`,
 1 AS `status`,
 1 AS `next_maintenance_date`,
 1 AS `driver_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_qmmasterlogisticsledger`
--

DROP TABLE IF EXISTS `view_qmmasterlogisticsledger`;
/*!50001 DROP VIEW IF EXISTS `view_qmmasterlogisticsledger`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_qmmasterlogisticsledger` AS SELECT 
 1 AS `asset_category`,
 1 AS `asset_id`,
 1 AS `serial_number`,
 1 AS `model`,
 1 AS `status`,
 1 AS `assigned_to`,
 1 AS `next_maintenance_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_rollcallreport`
--

DROP TABLE IF EXISTS `view_rollcallreport`;
/*!50001 DROP VIEW IF EXISTS `view_rollcallreport`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_rollcallreport` AS SELECT 
 1 AS `soldier_id`,
 1 AS `name`,
 1 AS `rank`,
 1 AS `company_id`,
 1 AS `company_name`,
 1 AS `attendance_status`,
 1 AS `assigned_weapon_sn`,
 1 AS `weapon_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_soldierpersonaldashboard`
--

DROP TABLE IF EXISTS `view_soldierpersonaldashboard`;
/*!50001 DROP VIEW IF EXISTS `view_soldierpersonaldashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_soldierpersonaldashboard` AS SELECT 
 1 AS `soldier_id`,
 1 AS `name`,
 1 AS `rank`,
 1 AS `company_id`,
 1 AS `company_name`,
 1 AS `dob`,
 1 AS `contact`,
 1 AS `remaining_annual_leave`,
 1 AS `remaining_casual_leave`,
 1 AS `allocated_weapon_sn`,
 1 AS `allocated_weapon_model`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_upcomingmaintenance`
--

DROP TABLE IF EXISTS `view_upcomingmaintenance`;
/*!50001 DROP VIEW IF EXISTS `view_upcomingmaintenance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_upcomingmaintenance` AS SELECT 
 1 AS `item_type`,
 1 AS `identifier`,
 1 AS `next_maintenance_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `weapon_issue_log`
--

DROP TABLE IF EXISTS `weapon_issue_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weapon_issue_log` (
  `issue_id` int NOT NULL AUTO_INCREMENT,
  `weapon_id` int NOT NULL,
  `soldier_id` int NOT NULL,
  `date_issued` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_returned` datetime DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  KEY `fk_issuelog_weapon` (`weapon_id`),
  KEY `fk_issuelog_soldier` (`soldier_id`),
  CONSTRAINT `fk_issuelog_soldier` FOREIGN KEY (`soldier_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `fk_issuelog_weapon` FOREIGN KEY (`weapon_id`) REFERENCES `weapons` (`weapon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weapon_issue_log`
--

LOCK TABLES `weapon_issue_log` WRITE;
/*!40000 ALTER TABLE `weapon_issue_log` DISABLE KEYS */;
INSERT INTO `weapon_issue_log` VALUES (1,101,107,'2025-10-14 22:09:56',NULL);
/*!40000 ALTER TABLE `weapon_issue_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weapons`
--

DROP TABLE IF EXISTS `weapons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weapons` (
  `weapon_id` int NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  `assigned_company_id` int NOT NULL,
  `status` enum('In-Store','Issued','In-Repair') DEFAULT 'In-Store',
  `current_allocatee_id` int DEFAULT NULL,
  `last_maintenance` date DEFAULT NULL,
  `next_maintenance` date DEFAULT NULL,
  PRIMARY KEY (`weapon_id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `fk_weapons_company` (`assigned_company_id`),
  KEY `fk_weapons_allocatee` (`current_allocatee_id`),
  CONSTRAINT `fk_weapons_allocatee` FOREIGN KEY (`current_allocatee_id`) REFERENCES `soldiers` (`soldier_id`),
  CONSTRAINT `fk_weapons_company` FOREIGN KEY (`assigned_company_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `chk_weapon_maintenance_dates` CHECK (((`next_maintenance` is null) or (`last_maintenance` is null) or (`next_maintenance` > `last_maintenance`)))
) ENGINE=InnoDB AUTO_INCREMENT=603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weapons`
--

LOCK TABLES `weapons` WRITE;
/*!40000 ALTER TABLE `weapons` DISABLE KEYS */;
INSERT INTO `weapons` VALUES (101,'RFL-A01','Rifle','INSAS 5.56mm',1,'Issued',107,NULL,NULL),(102,'RFL-A02','Rifle','INSAS 5.56mm',1,'In-Store',NULL,NULL,NULL),(103,'RFL-A03','Rifle','INSAS 5.56mm',1,'In-Store',NULL,NULL,NULL),(104,'RFL-A04','Rifle','INSAS 5.56mm',1,'In-Store',NULL,NULL,NULL),(105,'RFL-A05','Rifle','INSAS 5.56mm',1,'In-Store',NULL,NULL,NULL),(106,'PST-A01','Pistol','Pistol Auto 9mm 1A',1,'In-Store',NULL,NULL,NULL),(201,'RFL-B01','Rifle','INSAS 5.56mm',2,'In-Store',NULL,NULL,NULL),(202,'RFL-B02','Rifle','INSAS 5.56mm',2,'In-Store',NULL,NULL,NULL),(203,'RFL-B03','Rifle','INSAS 5.56mm',2,'In-Store',NULL,NULL,NULL),(204,'RFL-B04','Rifle','INSAS 5.56mm',2,'In-Store',NULL,NULL,NULL),(205,'RFL-B05','Rifle','INSAS 5.56mm',2,'In-Store',NULL,NULL,NULL),(206,'PST-B01','Pistol','Pistol Auto 9mm 1A',2,'In-Store',NULL,NULL,NULL),(301,'RFL-C01','Rifle','INSAS 5.56mm',3,'In-Store',NULL,NULL,NULL),(302,'RFL-C02','Rifle','INSAS 5.56mm',3,'In-Store',NULL,NULL,NULL),(303,'RFL-C03','Rifle','INSAS 5.56mm',3,'In-Store',NULL,NULL,NULL),(304,'RFL-C04','Rifle','INSAS 5.56mm',3,'In-Store',NULL,NULL,NULL),(305,'RFL-C05','Rifle','INSAS 5.56mm',3,'In-Store',NULL,NULL,NULL),(306,'PST-C01','Pistol','Pistol Auto 9mm 1A',3,'In-Store',NULL,NULL,NULL),(401,'RFL-D01','Rifle','INSAS 5.56mm',4,'In-Store',NULL,NULL,NULL),(402,'RFL-D02','Rifle','INSAS 5.56mm',4,'In-Store',NULL,NULL,NULL),(403,'RFL-D03','Rifle','INSAS 5.56mm',4,'In-Store',NULL,NULL,NULL),(404,'RFL-D04','Rifle','INSAS 5.56mm',4,'In-Store',NULL,NULL,NULL),(405,'RFL-D05','Rifle','INSAS 5.56mm',4,'In-Store',NULL,NULL,NULL),(406,'PST-D01','Pistol','Pistol Auto 9mm 1A',4,'In-Store',NULL,NULL,NULL),(501,'PST-HQ01','Pistol','Pistol Auto 9mm 1A',5,'In-Store',NULL,NULL,NULL),(601,'MTR-S01','Mortar','81mm Mortar',6,'In-Store',NULL,NULL,NULL);
/*!40000 ALTER TABLE `weapons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `view_activealerts`
--

/*!50001 DROP VIEW IF EXISTS `view_activealerts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_activealerts` AS select `alerts`.`alert_id` AS `alert_id`,`alerts`.`alert_type` AS `alert_type`,`alerts`.`message` AS `message`,date_format(`alerts`.`alert_date`,'%d-%m-%Y') AS `alert_date_formatted`,`alerts`.`related_entity_type` AS `related_entity_type`,`alerts`.`related_entity_id` AS `related_entity_id` from `alerts` where (`alerts`.`is_resolved` = false) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_allleaverecords`
--

/*!50001 DROP VIEW IF EXISTS `view_allleaverecords`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_allleaverecords` AS select `lr`.`leave_id` AS `leave_id`,`s`.`soldier_id` AS `soldier_id`,`s`.`name` AS `soldier_name`,`s`.`rank` AS `rank`,`c`.`company_name` AS `company_name`,date_format(`lr`.`start_date`,'%d-%m-%Y') AS `start_date`,date_format(`lr`.`end_date`,'%d-%m-%Y') AS `end_date`,`lr`.`leave_type` AS `leave_type`,`lr`.`reason` AS `reason`,`lr`.`status` AS `status` from ((`leave_records` `lr` join `soldiers` `s` on((`lr`.`soldier_id` = `s`.`soldier_id`))) join `companies` `c` on((`s`.`company_id` = `c`.`company_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_allpendingleaverequests`
--

/*!50001 DROP VIEW IF EXISTS `view_allpendingleaverequests`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_allpendingleaverequests` AS select `lr`.`leave_id` AS `leave_id`,`s`.`soldier_id` AS `soldier_id`,`s`.`name` AS `soldier_name`,`s`.`rank` AS `rank`,`c`.`company_name` AS `company_name`,`s`.`company_id` AS `company_id`,date_format(`lr`.`start_date`,'%d-%m-%Y') AS `start_date_formatted`,date_format(`lr`.`end_date`,'%d-%m-%Y') AS `end_date_formatted`,`lr`.`leave_type` AS `leave_type`,`lr`.`reason` AS `reason` from ((`leave_records` `lr` join `soldiers` `s` on((`lr`.`soldier_id` = `s`.`soldier_id`))) join `companies` `c` on((`s`.`company_id` = `c`.`company_id`))) where (`lr`.`status` = 'Pending') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_battalionmasterinventory`
--

/*!50001 DROP VIEW IF EXISTS `view_battalionmasterinventory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_battalionmasterinventory` AS select (_utf8mb4'Weapons' collate utf8mb4_unicode_ci) AS `category`,count(0) AS `total_items`,sum((case when (`weapons`.`status` = 'In-Store') then 1 else 0 end)) AS `serviceable_count` from `weapons` union all select (_utf8mb4'Ammunition' collate utf8mb4_unicode_ci) AS `category`,ifnull(sum(`ammunition`.`quantity`),0) AS `IFNULL(SUM(quantity), 0)`,NULL AS `NULL` from `ammunition` union all select (_utf8mb4'Vehicles' collate utf8mb4_unicode_ci) AS `category`,count(0) AS `total_items`,sum((case when (`military_transport`.`status` = 'Operational') then 1 else 0 end)) AS `serviceable_count` from `military_transport` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_battalionpersonneloverview`
--

/*!50001 DROP VIEW IF EXISTS `view_battalionpersonneloverview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_battalionpersonneloverview` AS select `c`.`company_name` AS `company_name`,count(`s`.`soldier_id`) AS `total_strength`,sum((case when (`s`.`rank` in ('Lieutenant Colonel','Major','Captain','Lieutenant')) then 1 else 0 end)) AS `officers`,sum((case when (`s`.`rank` in ('Subedar Major','Subedar','Naib Subedar')) then 1 else 0 end)) AS `jcos`,sum((case when (`s`.`rank` in ('Havildar','Naik','Sepoy')) then 1 else 0 end)) AS `other_ranks` from (`companies` `c` join `soldiers` `s` on((`c`.`company_id` = `s`.`company_id`))) group by `c`.`company_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_companyarmskote`
--

/*!50001 DROP VIEW IF EXISTS `view_companyarmskote`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_companyarmskote` AS select `w`.`assigned_company_id` AS `assigned_company_id`,`c`.`company_name` AS `company_name`,`w`.`weapon_id` AS `weapon_id`,`w`.`serial_number` AS `serial_number`,`w`.`model` AS `model`,`w`.`type` AS `type`,`w`.`status` AS `status`,`s`.`name` AS `allocated_to` from ((`weapons` `w` join `companies` `c` on((`w`.`assigned_company_id` = `c`.`company_id`))) left join `soldiers` `s` on((`w`.`current_allocatee_id` = `s`.`soldier_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_companyreadinessstatus`
--

/*!50001 DROP VIEW IF EXISTS `view_companyreadinessstatus`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_companyreadinessstatus` AS select `s`.`soldier_id` AS `soldier_id`,`s`.`name` AS `name`,`s`.`rank` AS `rank`,`c`.`company_name` AS `company_name`,`w`.`serial_number` AS `serial_number`,`w`.`model` AS `weapon_model` from ((`soldiers` `s` join `companies` `c` on((`s`.`company_id` = `c`.`company_id`))) left join `weapons` `w` on((`s`.`soldier_id` = `w`.`current_allocatee_id`))) where (`w`.`status` = 'Issued') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_mto_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `view_mto_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_mto_dashboard` AS select `mt`.`mt_id` AS `mt_id`,`mt`.`vehicle_number` AS `vehicle_number`,`mt`.`model` AS `model`,`mt`.`odometer_reading` AS `odometer_reading`,`mt`.`status` AS `status`,date_format(`mt`.`next_maintenance`,'%d-%m-%Y') AS `next_maintenance_date`,`s`.`name` AS `driver_name` from (`military_transport` `mt` left join `soldiers` `s` on((`mt`.`driver_id` = `s`.`soldier_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_qmmasterlogisticsledger`
--

/*!50001 DROP VIEW IF EXISTS `view_qmmasterlogisticsledger`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_qmmasterlogisticsledger` AS select (_utf8mb4'Weapon' collate utf8mb4_unicode_ci) AS `asset_category`,`w`.`weapon_id` AS `asset_id`,`w`.`serial_number` AS `serial_number`,`w`.`model` AS `model`,`w`.`status` AS `status`,`c`.`company_name` AS `assigned_to`,date_format(`w`.`next_maintenance`,'%d-%m-%Y') AS `next_maintenance_date` from (`weapons` `w` join `companies` `c` on((`w`.`assigned_company_id` = `c`.`company_id`))) union all select (_utf8mb4'Vehicle' collate utf8mb4_unicode_ci) AS `asset_category`,`mt`.`mt_id` AS `asset_id`,`mt`.`vehicle_number` AS `vehicle_number`,`mt`.`model` AS `model`,`mt`.`status` AS `status`,(_utf8mb4'Battalion' collate utf8mb4_unicode_ci) AS `assigned_to`,date_format(`mt`.`next_maintenance`,'%d-%m-%Y') AS `next_maintenance_date` from `military_transport` `mt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_rollcallreport`
--

/*!50001 DROP VIEW IF EXISTS `view_rollcallreport`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_rollcallreport` AS select `s`.`soldier_id` AS `soldier_id`,`s`.`name` AS `name`,`s`.`rank` AS `rank`,`c`.`company_id` AS `company_id`,`c`.`company_name` AS `company_name`,(case when (`lr`.`leave_id` is not null) then 'On Leave' else 'Present' end) AS `attendance_status`,`w`.`serial_number` AS `assigned_weapon_sn`,(case when (`swa`.`weapon_id` is null) then 'N/A' when ((`w`.`status` = 'Issued') and (`w`.`current_allocatee_id` = `s`.`soldier_id`)) then 'With Soldier' when ((`w`.`status` = 'Issued') and (`w`.`current_allocatee_id` <> `s`.`soldier_id`)) then 'Issued to Other' when (`w`.`status` = 'In-Store') then 'In-Store' when (`w`.`status` = 'In-Repair') then 'In-Repair' else 'N/A' end) AS `weapon_status` from ((((`soldiers` `s` join `companies` `c` on((`s`.`company_id` = `c`.`company_id`))) left join `leave_records` `lr` on(((`s`.`soldier_id` = `lr`.`soldier_id`) and (`lr`.`status` = 'Approved') and (curdate() between `lr`.`start_date` and `lr`.`end_date`)))) left join `soldier_weapon_assignments` `swa` on((`s`.`soldier_id` = `swa`.`soldier_id`))) left join `weapons` `w` on((`swa`.`weapon_id` = `w`.`weapon_id`))) where (`s`.`status` = 'Active') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_soldierpersonaldashboard`
--

/*!50001 DROP VIEW IF EXISTS `view_soldierpersonaldashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_soldierpersonaldashboard` AS select `s`.`soldier_id` AS `soldier_id`,`s`.`name` AS `name`,`s`.`rank` AS `rank`,`s`.`company_id` AS `company_id`,`c`.`company_name` AS `company_name`,date_format(`s`.`dob`,'%d-%m-%Y') AS `dob`,`s`.`contact` AS `contact`,`s`.`remaining_annual_leave` AS `remaining_annual_leave`,`s`.`remaining_casual_leave` AS `remaining_casual_leave`,`w`.`serial_number` AS `allocated_weapon_sn`,`w`.`model` AS `allocated_weapon_model`,`s`.`status` AS `status` from ((`soldiers` `s` join `companies` `c` on((`s`.`company_id` = `c`.`company_id`))) left join `weapons` `w` on(((`s`.`soldier_id` = `w`.`current_allocatee_id`) and (`w`.`status` = 'Issued')))) where (`s`.`status` = 'Active') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_upcomingmaintenance`
--

/*!50001 DROP VIEW IF EXISTS `view_upcomingmaintenance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_upcomingmaintenance` AS select 'Weapon' AS `item_type`,`weapons`.`serial_number` AS `identifier`,date_format(`weapons`.`next_maintenance`,'%d-%m-%Y') AS `next_maintenance_date` from `weapons` where (`weapons`.`next_maintenance` between curdate() and (curdate() + interval 30 day)) union all select 'Vehicle' AS `item_type`,`military_transport`.`vehicle_number` AS `identifier`,date_format(`military_transport`.`next_maintenance`,'%d-%m-%Y') AS `next_maintenance_date` from `military_transport` where (`military_transport`.`next_maintenance` between curdate() and (curdate() + interval 30 day)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-18 20:57:15
