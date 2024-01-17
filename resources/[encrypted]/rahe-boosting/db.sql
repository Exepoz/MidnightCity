CREATE TABLE `ra_boosting_contracts`
(
    `id`                    INT(10) UNSIGNED                                                                 NOT NULL AUTO_INCREMENT,
    `owner_identifier`      VARCHAR(100)                                                                     NOT NULL DEFAULT '',
    `status`                ENUM ('AVAILABLE','BOUGHT','IN_PROGRESS','IN_PROGRESS_VIN','COMPLETED','FAILED') NOT NULL,
    `price`                 INT(10) UNSIGNED                                                                 NOT NULL,
    `experience_gain`       INT(10) UNSIGNED                                                                 NOT NULL,
    `payout_cash`           INT(10) UNSIGNED                                                                 NOT NULL DEFAULT 0,
    `payout_crypto`         INT(10) UNSIGNED                                                                 NOT NULL DEFAULT 0,
    `employer`              VARCHAR(100)                                                                     NOT NULL DEFAULT 'Anonymous',
    `vehicle_model`         VARCHAR(100)                                                                     NOT NULL,
    `vehicle_model_name`    VARCHAR(100)                                                                     NOT NULL,
    `vehicle_license_plate` VARCHAR(10)                                                                      NOT NULL,
    `vehicle_class`         VARCHAR(10)                                                                      NOT NULL DEFAULT '',
    `is_vehicle_tuned`      TINYINT(4)                                                                       NOT NULL DEFAULT 0,
    `expiration_date`       DATETIME                                                                         NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    INDEX `FK_boosting_contracts_characters` (`owner_identifier`)
);

CREATE TABLE `ra_boosting_user_settings`
(
    `player_identifier` VARCHAR(100) NOT NULL,
    `alias`             VARCHAR(40)  NULL     DEFAULT 'Unnamed',
    `profile_picture`   VARCHAR(100) NOT NULL DEFAULT 'https://i.imgur.com/Lu9dGJH.png',
    `experience`        FLOAT        NOT NULL DEFAULT 0,
    `crypto`            INT(11)      NOT NULL DEFAULT 0,
    `is_initialized`    INT(11)      NOT NULL DEFAULT 0,
    `created_at`        DATETIME     NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`player_identifier`)
);

