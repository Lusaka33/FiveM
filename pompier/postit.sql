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

-- Export de la structure de la table fivem. post_it
CREATE TABLE IF NOT EXISTS `post_it` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `writer` text,
  `job_id` int(11) NOT NULL DEFAULT '0',
  `text` longtext,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Export de données de la table fivem.post_it : 0 rows
/*!40000 ALTER TABLE `post_it` DISABLE KEYS */;
INSERT INTO `post_it` (`ID`, `writer`, `job_id`, `text`) VALUES
	(1, 'Mike Aratchis', 20, 'Fifi il est passer tt a l\'heure est il reparer le FPT :)'),
	(2, 'Morgan Braco', 20, 'Arrete de jouer avec les post-it ;)');
/*!40000 ALTER TABLE `post_it` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
