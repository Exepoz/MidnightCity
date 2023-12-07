Beekeeping = {}

Beekeeping.LockedToOwner = true -- If locked to owner then only the owner / placer will have access to open it. Otherwise, the hives and houses can be accessed by anyone.
Beekeeping.Max = { -- Max amount of houses/hives an individual player can have placed down at any time.    
    Hives = 5, -- Maximum
    Houses = 5, -- Maximum
}

-- PLEASE, Make sure your deadset on the value you set below. If you change it from false to true after players have already placed down hives/houses, it will cause issues. Refer to the docuemntation for more information.
Beekeeping.EnableExpiration = true -- If enabled, the houses/hives will expire, if not interacted with for the duration set below.
-- PLEASE, Make sure your deadset on the value you set above. If you change it from false to true after players have already placed down hives/houses, it will cause issues. Refer to the docuemntation for more information.

Beekeeping.ExpiryTime = 168 -- -- Expiry time for bee hives/houses in hours. If not interacted with for this duration, they are removed from the database. Example: 168 hours (1 week).

function GetInventoryIcon(item)
    local inventoryLink = 'ps-inventory' -- ox_inventory, ps-inventory etc.
    return 'nui://'..inventoryLink..'/html/images/'..item..'.png' -- File path to the item icon
    -- ox_inventory: return 'nui://'..inventoryLink..'/web/images/'..item..'.png'
end

Beekeeping.House = { -- These values are recommanded to be left at defautl to keep a balanced gameplay
    CaptureTime = 300, -- Time in seconds to capture a new bee
    QueenSpawnChance = 10, -- Chance in % to spawn a queen when capturing new bees
    BeesPerCapture = {2, 3}, -- Min and max bees to capture per capture or fix amount
    QueensPerCapture = 1, -- Min and max queens to capture per capture or fix amount
    MaxQueens = 5, -- Max queens per house
    MaxWorkers = 50, -- Max workers per house
}

Beekeeping.Hives = { -- These values are recommanded to be left at defautl to keep a balanced gameplay
    -- Honey
    HoneyTime = 600, -- Time in seconds to produce honey & wax
    HoneyPerTime = {1, 2}, -- Min and max honey to produce per time
    MaxHoney = 100, -- Max honey per hive
    -- Wax
    ChanceOfWax = 10, -- In percentage what are the chances to get wax on HoneyTime?
    WaxPerTime = {1, 2}, -- Min and max honey to produce per time
    MaxWax = 20, -- Max wax per hive
    -- Bees
    NeededQueens = 1, -- Amount of queens needed for the hive to work.
    NeededWorkers = 5, -- Amount of workers needed for the hive to work.
}

Beekeeping.Items = {
    QueenItem = 'bee-queen',
    WorkerItem = 'bee-worker',
    HoneyItem = 'bee-honey',
    WaxItem = 'bee-wax',
    HiveItem = 'bee-hive',
    HouseItem = 'bee-house',
}

--[[
    For bzzz's props (free): https://bzzz.tebex.io/package/5696199
    For nopixel's props (paid): https://3dstore.nopixel.net/package/5622378
]]

Beekeeping.Type = 'bzzz' -- 'bzzz' / 'nopixel' or 'custom'

if Beekeeping.Type == 'bzzz' then
Beekeeping.Props = {
    bee_house = 'bzzz_props_beehive_box_002',
    bee_hive = 'bzzz_props_beehive_box_001',
}
elseif Beekeeping.Type == 'nopixel' then
Beekeeping.Props = {
    bee_house = 'np_beehive',
    bee_hive = 'np_beehive02',
}
elseif Beekeeping.Type == 'custom' then
Beekeeping.Props = {
    bee_house = '',
    bee_hive = '',
}
end

Beekeeping.Grounds = { -- Acceptable materials for gound (grass, etc) [ DO NOT TOUCH IF YOU DON'T KNOW WHAT YOU ARE DOING. ]
    -2041329971, -- Leaves
    -461750719,  -- GrassLong
    1333033863,  -- Grass
    -1286696947, -- GrassShort
    1144315879,  -- ClayHard
    -1942898710, -- MudHard
    -1595148316, -- SandLoose
    -1885547121, -- DirtTrack
    -2041329971, -- Leaves
    -840216541,  -- Rock
    -700658213,  -- Soil
    -913351839,  -- Twigs
    1109728704,  -- MudDeep
    1635937914,  -- MudSoft
    2128369009,  -- GravelLarge
    951832588,   -- GravelSmall
    581794674,   -- Bushes
    510490462,   -- SandCompact
}