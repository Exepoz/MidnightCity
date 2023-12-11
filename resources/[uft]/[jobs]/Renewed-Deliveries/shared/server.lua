Config = Config or {}

Config.RenewedBanking = true
Config.PriceBrackets = {
    ["small"] = 200,
    ["medium"] = 250,
    ["large"] = 350,
}

Config.MaxMembers = 3 -- How many people can be in a group during the runs?
Config.MaxDeliver = 8 -- How many MAXIMUM Packages per location
Config.Deliver = {min = 2, max = 4} -- How many garbage bags per location?

Config.GroupPay = 1.10 -- How much more you get paid for doing a group run (5% more)
Config.GroupPayLimit = 2 -- How many people to get the Config.GroupPay bonus?

Config.Buffs = false -- Do u use ps or tnj buffs then enable this
Config.BuffExport = "tnj-buffs" -- Some people still use tnj-buffs some uses ps-buffs they are the just edit the BuffExport to whatever you use
Config.BuffType = "luck" -- What buff type do u use for players to recieve more money?
Config.BuffPay = 1.15 -- How much more do they get paid for having the buff? (10% more)


Config.LeaderReturn = true -- If you want to make it so ONLY the group leader can return the truck and get paid, ON BY DEFAULT