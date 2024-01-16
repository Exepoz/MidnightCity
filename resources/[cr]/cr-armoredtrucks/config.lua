Config = {}
Config.Debug = false
Config.DebugPrints = true


Config.Merryweather = {}
Config.Reputation = {
    DeliveryNeededForConvoy = 15,
    XPNeededForMerryweather = 30,
    DeliveryCap = 25, -- Max Rep before deliveries stop giving rep
    RoamingCap = 60
}

----------
-- Misc --
----------
Config.InitWait = 0
Config.PoliceJobs = {'police'}
Config.BombItem = 'low_explosive'

Config.TimeToAccept = 3 -- Time in minutes to accept the email before new ones get sent out.
Config.RemoveFromQueueOnEmailSend = true -- true : Removes player from queue when they receive the email, no matter if they accept the truck. | False : Only removes from queue if they player is the one doing the heist
Config.TimeToFind = 45 -- Time in minutes to find the truck (delivery or convoy) before resets.
Config.TimeToComplete = 45 -- Time to complete any of the heists once started
Config.EmailAmountSent = 3 -- Amount of people receiving an email to start a truck mission (fastest person to accept gets the heist)

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true,
    [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true,
    [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true,
    [113] = true, [114] = true, [118] = true, [125] = true, [132] = true,
}
Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true,
    [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true,
    [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true,
    [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true,
}
-----------------------------------------------------------

