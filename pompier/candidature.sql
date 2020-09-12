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

-- Export de la structure de la table fivem. candidature
CREATE TABLE IF NOT EXISTS `candidature` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(11) NOT NULL DEFAULT '0',
  `prenom` tinytext,
  `nom` tinytext,
  `telephone` varchar(50) DEFAULT NULL,
  `motivation` longtext,
  `metier_name` tinytext,
  `metier` int(11) DEFAULT NULL,
  `parcours` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Export de données de la table fivem.candidature : 2 rows
/*!40000 ALTER TABLE `candidature` DISABLE KEYS */;
INSERT INTO `candidature` (`ID`, `job_id`, `prenom`, `nom`, `telephone`, `motivation`, `metier_name`, `metier`, `parcours`) VALUES
	(1, 20, 'mike', 'brown', '0602361234', 'j\'aime bien les pompier du coup je voudrais vous rejoindre pour sauver des vie et roulez a fond', 'ambulancier', 15, 'pompier dans une autre ville'),
	(2, 20, 'dfgdg', 'dfgd', '4454', 'hjgjghj', 'policier', 2, 'dgfdgg');
/*!40000 ALTER TABLE `candidature` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
