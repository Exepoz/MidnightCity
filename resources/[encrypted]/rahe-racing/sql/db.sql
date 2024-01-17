-- Running db.sql is required in order for the racing application to work.
-- Running tracks.sql is voluntary, only run that if you wish to get some pre-made tracks into the application.

CREATE TABLE `ra_racing_events`
(
    `id`                INT(11)      NOT NULL AUTO_INCREMENT,
    `player_identifier` VARCHAR(60)  NOT NULL,
    `text`              VARCHAR(100) NOT NULL,
    `created_at`        DATETIME     NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
);

CREATE TABLE `ra_racing_races`
(
    `id`                    INT(11)     NOT NULL AUTO_INCREMENT,
    `track_id`              INT(11)     NOT NULL,
    `started_by_identifier` VARCHAR(60) NOT NULL,
    `participant_amount`    INT(11)     NULL DEFAULT NULL,
    `is_competition`        TINYINT(2)  NOT NULL,
    `prize_money`           INT(11)     NULL DEFAULT 0,
    `start_time`            DATETIME    NULL DEFAULT NULL,
    `vehicle_class`         VARCHAR(4)  NULL DEFAULT NULL,
    `lap_amount`            TINYINT(4)  NULL DEFAULT NULL,
    `finished_at`           DATETIME    NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `ra_racing_tracks`
(
    `id`                 INT(11)                   NOT NULL AUTO_INCREMENT,
    `creator_identifier` VARCHAR(60)               NOT NULL,
    `name`               VARCHAR(100)              NOT NULL,
    `description`        VARCHAR(100)              NOT NULL,
    `type`               ENUM ('SPRINT','CIRCUIT') NOT NULL,
    `checkpoints`        LONGTEXT                  NOT NULL,
    `objects`            LONGTEXT                  NOT NULL,
    `is_verified`        TINYINT                   NOT NULL DEFAULT 0,
    `is_deleted`         TINYINT(4)                NOT NULL DEFAULT 0,
    `created_at`         DATETIME                  NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
);

CREATE TABLE `ra_racing_results`
(
    `id`                 INT(11)      NOT NULL AUTO_INCREMENT,
    `race_id`            INT(11)      NOT NULL,
    `track_id`           INT(11)      NOT NULL,
    `player_identifier`  VARCHAR(60)  NOT NULL DEFAULT '',
    `position`           INT(11)      NULL     DEFAULT NULL,
    `prize_money`        INT(11)      NULL     DEFAULT 0,
    `rating_gain`        INT(3)       NULL     DEFAULT 0,
    `vehicle_model`      VARCHAR(100) NULL     DEFAULT NULL,
    `vehicle_model_name` VARCHAR(100) NULL     DEFAULT NULL,
    `vehicle_class`      VARCHAR(100) NULL     DEFAULT NULL,
    `best_time`          INT(11)      NULL     DEFAULT NULL,
    `best_time_string`   VARCHAR(40)  NOT NULL,
    `total_time`         INT(11)      NULL     DEFAULT NULL,
    `total_time_string`  VARCHAR(40)  NOT NULL,
    `finished_at`        DATETIME     NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    INDEX `FK_ra_racing_results_ra_racing_races` (`race_id`),
    INDEX `FK_ra_racing_results_ra_racing_tracks` (`track_id`),
    CONSTRAINT `FK_ra_racing_results_ra_racing_races` FOREIGN KEY (`race_id`) REFERENCES `ra_racing_races` (`id`),
    CONSTRAINT `FK_ra_racing_results_ra_racing_tracks` FOREIGN KEY (`track_id`) REFERENCES `ra_racing_tracks` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE `ra_racing_user_settings`
(
    `player_identifier` VARCHAR(60)  NOT NULL,
    `alias`             VARCHAR(40)  NULL     DEFAULT 'Unnamed',
    `profile_picture`   VARCHAR(100) NOT NULL DEFAULT 'https://i.imgur.com/Lu9dGJH.png',
    `rating`            SMALLINT(6)  NULL     DEFAULT 1400,
    `favorite_tracks`   LONGTEXT     NOT NULL DEFAULT '{}',
    `created_at`        DATETIME     NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`player_identifier`)
);

INSERT INTO `ra_racing_user_settings` (`player_identifier`, `alias`, `profile_picture`, `rating`) VALUES ('0', 'Anonymous', 'https://i.imgur.com/Lu9dGJH.png', 1400);

