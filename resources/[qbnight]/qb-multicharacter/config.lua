Config = {}
Config.StartingApartment = true -- Enable/disable starting apartments (make sure to set default spawn coords)
Config.EnableDeleteButton = true -- Define if the player can delete the character or not

Config.Interior = vector3(-8.88, 512.91, 174.63) -- Interior to load where characters are previewed
Config.DefaultSpawn = vector3(-1786.8, -870.39, 7.39) -- Default spawn coords if you have start apartments disabled
Config.PedCoords = vector4(-628.95, 4393.19, 24.93, 115.39) -- Create preview ped at these coordinates
Config.HiddenCoords = vector4(-616.91, 4400.52, 17.32, 107.33) -- Hides your actual ped Ma-cro guapo while you are in selection
Config.CamCoords = vector4(-633.04, 4390.77, 25.5, 301.0) -- Camera coordinates for character preview screen vector3(-633.04, 4390.77, 26.2)
Config.Weather = {time = {7, 46, 0}, weather = 'RAIN'}
Config.Scenarios = {
    "WORLD_HUMAN_HANG_OUT_STREET",
    "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_STAND_MOBILE",
    --"WORLD_HUMAN_SMOKING_POT",
    "WORLD_HUMAN_TOURIST_MAP",
    "WORLD_HUMAN_BINOCULARS",
    "WORLD_HUMAN_STUPOR",
    "WORLD_HUMAN_BUM_STANDING",
}


Config.DefaultNumberOfCharacters = 5 -- Define maximum amount of default characters (maximum 5 characters defined by default)
Config.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
    { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 2 },
}

-- old malmo (roof)
-- Config.Interior = vector3(-8.88, 512.91, 174.63) -- Interior to load where characters are previewed
-- Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled -- vector3(-1035.71, -2731.87, 12.86)
-- Config.PedCoords = vector4(-8.55, 508.84, 174.63, 19.81) -- Create preview ped at these coordinates --vector4(-8.55, 508.84, 174.63, 19.81)
-- Config.HiddenCoords = vector4(3.3, 523.88, 170.62, 70.87) -- Hides your actual ped Ma-cro guapo while you are in selection --vector4(3.3, 523.88, 170.62, 70.87)
-- Config.CamCoords = vector4(-1782.26, -864.38, 7.8, 106.56) -- Camera coordinates for character preview screen
-- Config.Weather = {time = {18, 0, 0}, weather = 'CLEAR'}


-- Beach
-- Config.Interior = vector3(-8.88, 512.91, 174.63) -- Interior to load where characters are previewed
-- Config.DefaultSpawn = vector3(-1786.8, -870.39, 7.39) -- Default spawn coords if you have start apartments disabled -- vector3(-1035.71, -2731.87, 12.86)
-- Config.PedCoords = vector4(-1785.95, -865.25, 7.45, 281.93) -- Create preview ped at these coordinates --vector4(-8.55, 508.84, 174.63, 19.81)
-- Config.HiddenCoords = vector4(-1773.86, -862.3, 7.75, 291.34) -- Hides your actual ped Ma-cro guapo while you are in selection --vector4(3.3, 523.88, 170.62, 70.87)
-- Config.CamCoords = vector4(-1782.26, -864.38, 7.8, 106.56) -- Camera coordinates for character preview screen
-- Config.Weather = {time = {20, 0, 0}, weather = 'CLEAR'}
-- Config.Scenarios = {
--     "WORLD_HUMAN_SMOKING_POT",
--     "WORLD_HUMAN_MUSICIAN",
--     "WORLD_HUMAN_PARTYING",
-- }


--halloween
-- Config.Interior = vector3(-8.88, 512.91, 174.63) -- Interior to load where characters are previewed
-- Config.DefaultSpawn = vector3(-1786.8, -870.39, 7.39) -- Default spawn coords if you have start apartments disabled -- vector3(-1035.71, -2731.87, 12.86)
-- Config.PedCoords = vector4(-545.85, -256.49, 35.99, 228.88) -- Create preview ped at these coordinates --vector4(-8.55, 508.84, 174.63, 19.81)
-- Config.HiddenCoords = vector4(-559.32, -236.14, 46.17, 304.92) -- Hides your actual ped Ma-cro guapo while you are in selection --vector4(3.3, 523.88, 170.62, 70.87)
-- Config.CamCoords = vector4(-542.01, -259.31, 35.8, 53.00) -- Camera coordinates for character preview screen vvector4(-545.46, -256.04, 36.01, 74.52)
-- Config.Weather = {time = {21, 30, 0}, weather = 'HALLOWEEN'}
-- Config.Scenarios = {
--     "WORLD_HUMAN_HANG_OUT_STREET",
--     "WORLD_HUMAN_STAND_IMPATIENT",
--     "WORLD_HUMAN_DRUG_DEALER",
--     "WORLD_HUMAN_SECURITY_SHINE_TORCH",
-- }
