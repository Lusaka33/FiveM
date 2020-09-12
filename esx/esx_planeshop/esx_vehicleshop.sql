USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_planedealer','Concessionnaire',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_planedealer','Concesionnaire',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('planedealer','Concessionnaire')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('planedealer',0,'recruit','Recrue',10,'{}','{}'),
  ('planedealer',1,'novice','Novice',25,'{}','{}'),
  ('planedealer',2,'experienced','Experimente',40,'{}','{}'),
  ('planedealer',3,'boss','Patron',0,'{}','{}')
;

CREATE TABLE `planedealer_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `owned_planes` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` longtext NOT NULL,
  `owner` varchar(60) NOT NULL,

  PRIMARY KEY (`id`)
);

CREATE TABLE `plane_categories` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO `plane_categories` (name, label) VALUES
  ('avions','Avions'),
  ('heli','Hélicoptére'),
  ('society','Société')
;

CREATE TABLE `plane` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `plane` (name, model, price, category) VALUES
  ('Buzzard2', 'buzzard2', 750000, 'avions'),
  ('Frogger', 'frogger', 900000, 'avions'),
  ('Maverick', 'maverick', 1000000, 'avions'),
  ('Supervolito2', 'supervolito2', 1600000, 'avions'),
  ('Swift', 'swift', 2000000, 'avions'),
  ('Swift2', 'swift2', 2400000, 'avions'),
  ('Volatus', 'volatus', 2800000, 'avions'),
  ('Stunt', 'stunt', 1200000, 'avions'),
  ('Cuban800', 'cuban800', 1600000, 'avions'),
  ('Mammatus', 'mammatus', 2000000, 'avions'),
  ('Dodo',  'dodo', 2200000, 'avions'),
  ('Vestra', 'vestra', 2500000, 'avions'),
  ('Nimbus', 'nimbus', 3000000, 'avions'),
  ('Luxor2', 'luxor2', 6000000, 'avions')
;
