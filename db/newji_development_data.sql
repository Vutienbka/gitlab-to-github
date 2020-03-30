-- MySQL dump 10.13  Distrib 5.7.29, for Linux (x86_64)
--
-- Host: localhost    Database: newji_development
-- ------------------------------------------------------
-- Server version	5.7.29-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT IGNORE INTO `ar_internal_metadata` VALUES ('environment','development','2020-03-23 01:41:11','2020-03-23 01:41:11');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `draw_categories`
--

LOCK TABLES `draw_categories` WRITE;
/*!40000 ALTER TABLE `draw_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `draw_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `file_draws`
--

LOCK TABLES `file_draws` WRITE;
/*!40000 ALTER TABLE `file_draws` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_draws` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `file_images`
--

LOCK TABLES `file_images` WRITE;
/*!40000 ALTER TABLE `file_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `file_samples`
--

LOCK TABLES `file_samples` WRITE;
/*!40000 ALTER TABLE `file_samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_samples` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `image_categories`
--

LOCK TABLES `image_categories` WRITE;
/*!40000 ALTER TABLE `image_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `image_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `inspection_requests`
--

LOCK TABLES `inspection_requests` WRITE;
/*!40000 ALTER TABLE `inspection_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `inspection_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_conditions`
--

LOCK TABLES `item_conditions` WRITE;
/*!40000 ALTER TABLE `item_conditions` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_drawings`
--

LOCK TABLES `item_drawings` WRITE;
/*!40000 ALTER TABLE `item_drawings` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_drawings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_images`
--

LOCK TABLES `item_images` WRITE;
/*!40000 ALTER TABLE `item_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_info`
--

LOCK TABLES `item_info` WRITE;
/*!40000 ALTER TABLE `item_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_qualities`
--

LOCK TABLES `item_qualities` WRITE;
/*!40000 ALTER TABLE `item_qualities` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_qualities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_requests`
--

LOCK TABLES `item_requests` WRITE;
/*!40000 ALTER TABLE `item_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `item_samples`
--

LOCK TABLES `item_samples` WRITE;
/*!40000 ALTER TABLE `item_samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_samples` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,NULL,NULL,1,'BuyerProfile','Nguyen','Quan','123456789','BnK','1234','','IT','Dev',NULL,'','2020-03-22 18:43:30',NULL,'2020-03-22 18:43:32',NULL),(2,NULL,2,NULL,'SupplierProfile','Man','Hp','0999999','HP','999','icon.png','Sales','Salesman',NULL,'','2020-03-22 19:13:18',NULL,'2020-03-22 19:13:21',NULL),(3,NULL,3,NULL,'SupplierProfile','Sale','Dell','01111111','Dell','222','icon.png','Sales','Salesman',NULL,'','2020-03-22 19:15:10',NULL,'2020-03-22 19:15:13',NULL),(4,NULL,4,NULL,'SupplierProfile','Center','Sony','123456789','Sony','111','logo.png','Sales Center','Salesman',NULL,'','2020-03-22 19:29:45',NULL,'2020-03-22 19:29:49',NULL),(5,5,NULL,NULL,'BuyerProfile','Nguyen','Quan','0987654321','BnK',NULL,'','IT','Dev',NULL,'','2020-03-22 21:22:34',NULL,'2020-03-22 21:22:34',NULL);
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sample_categories`
--

LOCK TABLES `sample_categories` WRITE;
/*!40000 ALTER TABLE `sample_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
-- TRUNCATE newji_development.schema_migrations;
INSERT INTO `schema_migrations` VALUES (CURRENT_TIMESTAMP);
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_calendars`
--

LOCK TABLES `user_calendars` WRITE;
/*!40000 ALTER TABLE `user_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@gmail.com','$2a$11$15wpRY6pVBJHNFuYzWi75eyRzfGEBVKyXG72jpyDiSJwnVZU.mlM6','Buyer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-03-22 18:43:21',NULL,'2020-03-22 19:10:59',NULL),(2,'hp@hp.com','$2a$11$vp6ctwdjtQwWzmi7qpJ06ew.XJ5Y/En.f6/4TzoTvafKnGemi0/bu','Supplier',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-03-22 19:11:18',NULL,'2020-03-22 19:14:03',NULL),(3,'dell@dell.com','$2a$11$jN1cVehA2f2yd.Wf8OQfsePy9QLvSQEcL1HPgIi/XmG/FOWXPrz5m','Supplier',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-03-22 19:14:22',NULL,'2020-03-22 19:18:59',NULL),(4,'sony@sony.com','$2a$11$V5QgAFHFcRg5xR8RpgcyWeQJ7OkOTzB8KeCrKjZvD/p4B0AL.0MfC','Supplier',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-03-22 19:29:03',NULL,'2020-03-22 21:21:41',NULL),(5,'quannd@gmail.com','$2a$11$vPEIty3986dRK2eXBfaHeeuNzLVkiOsOZWpoKipFNOyTm590BtVDe','Buyer',NULL,NULL,NULL,NULL,NULL,'2020-03-23 04:22:23',NULL,'2020-03-22 21:22:23',NULL,'2020-03-22 21:22:23',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-23 11:32:58
