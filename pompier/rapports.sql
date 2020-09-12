-- --------------------------------------------------------
-- Hôte :                        127.0.0.1
-- Version du serveur:           5.7.14 - MySQL Community Server (GPL)
-- SE du serveur:                Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Export de la structure de la table fivem. pompier_rapport
CREATE TABLE IF NOT EXISTS `pompier_rapport` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Writer` text,
  `IsSigned` int(11) DEFAULT NULL,
  `Participant` longtext,
  `Raison` longtext,
  `Inter_ID` int(11) DEFAULT NULL,
  `Text` longtext,
  `Lieu` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Export de données de la table fivem.pompier_rapport : 0 rows
/*!40000 ALTER TABLE `pompier_rapport` DISABLE KEYS */;
INSERT INTO `pompier_rapport` (`ID`, `Writer`, `IsSigned`, `Participant`, `Raison`, `Inter_ID`, `Text`, `Lieu`) VALUES
	(1, 'Mike Aratchis', 0, 'Mike Aratchis, Morgan Braco', 'DEV', 1, 'Ceci est un test lol', 'Sur discord');
/*!40000 ALTER TABLE `pompier_rapport` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
