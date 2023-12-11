Config = Config or {}

Config.RenewedBanking = true

Config.PriceBrackets = {
    ["small"] = 100,
    ["medium"] = 150,
    ["large"] = 250,
}

-- The amount of groups stacks the Config.Deliver so if its a 2 man job its then 8, 16 per location 3 would be 16, 32 etc.
Config.Deliver = {min = 4, max = 8} -- How many garbage bags per location?
Config.MaxDeliver = 16 -- How many MAXIMUM garbage bags per location?
Config.MaterialCheck = 8 -- How many trash bags each person MUST turning in to recieve a ticket 8 = 1 ticket, scales with group so if its a 3 man group they need to turn in 24 and they will all recieve 1 ticket


Config.GroupLimit = 3 -- How many people can be in a group during the runs?
Config.GroupPay = 1.10 -- How much more you get paid for doing a group run (5% more)
Config.GroupPayLimit = 2 -- How many people to get the Config.GroupPay bonus?

Config.Buffs = false -- Do u use ps or tnj buffs then enable this
Config.BuffExport = "tnj-buffs" -- Some people still use tnj-buffs some uses ps-buffs they are the just edit the BuffExport to whatever you use
Config.BuffType = "luck" -- What buff type do u use for players to recieve more money?
Config.BuffPay = 1.15 -- How much more do they get paid for having the buff? (10% more)

Config.LeaderReturn = false -- If you want to make it so ONLY the group leader can return the truck then enable this