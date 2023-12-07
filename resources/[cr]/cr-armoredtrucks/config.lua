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
Config.InitWait = 60
Config.PoliceJobs = {'police'}
Config.BombItem = 'low_explosive'

Config.TimeToAccept = 3 -- Time in minutes to accept the email before new ones get sent out.
Config.RemoveFromQueueOnEmailSend = true -- true : Removes player from queue when they receive the email, no matter if they accept the truck. | False : Only removes from queue if they player is the one doing the heist
Config.TimeToFind = 45 -- Time in minutes to find the truck (delivery or convoy) before resets.
Config.TimeToComplete = 45 -- Time to complete any of the heists once started
Config.EmailAmountSent = 3 -- Amount of people receiving an email to start a truck mission (fastest person to accept gets the heist)


-----------------------------------------------------------

