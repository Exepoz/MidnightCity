CREATE TABLE IF NOT EXISTS `pug_cokebusiness` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `bucketid` int(11) DEFAULT NULL,
  `upgrades` int(11) DEFAULT NULL,
  `access` text DEFAULT NULL,
  `membercap` int(11) DEFAULT NULL,
  `supplies` int(11) DEFAULT NULL,
  `product` int(11) DEFAULT NULL,
  `password` int(11) DEFAULT NULL,
  `lablocation` text DEFAULT NULL,
  `plane` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
