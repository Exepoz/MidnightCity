CREATE TABLE IF NOT EXISTS `pd_extra` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `player` varchar(256) DEFAULT '0',
    `tag` varchar(50) DEFAULT '0',
    `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4;