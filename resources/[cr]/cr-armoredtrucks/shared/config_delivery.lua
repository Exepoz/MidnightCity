-- Config = Config or {}
Config.Delivery = {}
--------------
-- Delivery --
--------------
Config.Delivery.QueuePrice = 5000 -- Price to enter the queue (If changed, ped dialog needs changed in cr-talktopeds)
Config.Delivery.Cops = 3
Config.Delivery.Cooldown = 60
Config.Delivery.GpsTimer = 5 -- Time for police tracker to disable and receive drop off location
Config.Delivery.ThermiteHack = {CorrectBlocks = 10, IncorrectBlocks = 3, TimeToShow = 4, TimeToLose = 5}
Config.Delivery.BombTimer = 2
Config.Delivery.ThermiteItem = 'thermite'

Config.Delivery.TruckLocations = {-- where truck spawns add as many coords as you like
    vector4(-1318.5, -588.94, 28.92, 34.31), --7220/7258
    vector4(308.83, 366.49, 105.26, 345.00),   --7092
    vector4(1034.76, -142.68, 73.8, 313.86),   --7299
    vector4(140.91, -245.05, 51.52, 160.00),   --7190/7191
    vector4(148.25, -127.05, 54.83, 340.00),   --7128
    vector4(-1408.59, -637.35, 28.67, 212.79), --7219
    vector4(-673.07, -620.79, 25.31, 269.00),  --8019
    vector4(-10.49, -722.02, 32.34, 159.50),   --8030
    vector4(-5.04, -670.85, 32.34, 194.77),    --8029
    vector4(-170.81, -153.13, 43.62, 69.75),   --7202/7187
    vector4(-93.93, -67.84, 56.77, 164.35),    --7137
    vector4(-371.52, 187.72, 80.46, 90.00),    --7073/7074
    vector4(-506.69, 163.07, 70.93, 85.00),    --7070
    vector4(-667.55, -175.27, 37.68, 120.41),  --7228
    vector4(-1458.24, -388.26, 38.21, 304.28),  --7169
}

Config.Delivery.RandomDropLocation = { -- where delivery locations are, add as many as you like
    vector4(-2170.1, 4276.49, 48.57, 329.47),
    vector4(572.97, 2797.41, 42.05, 193.96),
    vector4(1263.14, -2564.7, 42.77, 117.85),
    vector4(1140.87, -2018.12, 31.02, 358.93)
}