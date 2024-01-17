----------
Config = {}
-- (DONT TOUCH THIS UNLESS YOU HAVE A CUSTOM FRAMEWORK)
if GetResourceState('es_extended') == 'started' then
    Framework = "ESX" -- (ESX) or (QBCore)
elseif GetResourceState('qb-core') == 'started' then
    Framework = "QBCore" -- (ESX) or (QBCore)
end
if Framework == "QBCore" then
    Config.CoreName = "qb-core" -- your core name
    FWork = exports[Config.CoreName]:GetCoreObject()
elseif Framework == "ESX" then
    Config.CoreName = "es_extended" -- your core name
    FWork = exports[Config.CoreName]:getSharedObject()
end
----------
----------
Config.Debug = false -- enables debug poly for zones and prints
----------
Config.InventoryType = 'ps' -- (qb, ox, lj, neither) What inventory you are using? if you are using a renamed resource you can adjust the event in server.lua "Pug:server:GivePaintballItems".
Config.Target = "ox_target" -- (ox_target, qb-target) if you have change the resource name of qb-target you can use there here as well
Config.InputScript = 'ox_lib' -- (ox_lib) (ps-ui) (qb-input) Make this whatever input script that you use.
Config.Menu = 'ox_lib' -- (ox_lib, ps-ui, qb-menu) if you have change the resource name of qb-menu you can use there here as well
Config.DispatchScript = "ps-dispatch" -- (ps-dispatch) This is for the police call function in open.lua CallPoliceForDrugPlaneTooHigh()
----------
Config.FuelScript = "cdn-fuel" -- (ps-fuel) (LegacyFuel) (false) Set this to your fuel script name, if you do not have one set to false
Config.VehilceKeysGivenToPlayerEvent = "vehiclekeys:client:SetOwner" -- Event used to give player keys to vehicle. If you dont have one thats fine, just leave this alone.
----------
----------
Config.DrugPlaneDepositCurrency = "cash" -- Currency that is used for drug plane deposit
Config.DrugPlaneDeposit = 10000 -- $ How much the deposit for the drug plane cost
----------
Config.Currency = "cash" -- (money, bank, cash) what currency the player needs to purchase a laboratory
Config.CokeLabCost = 500000 -- $ How much the coke lab cost to purchase
----------
Config.DropOffBoxWorthEachMin = 125 -- $ How much dropping off each box is worth as a money bonus at the end of the drug run minimum    @#NEEDS TESTED FOR PRICE BALANCING#@
Config.DropOffBoxWorthEachMax = 175 -- $ How much dropping of each box is worth as a money bonus at the end of the drug run maximum
----------
Config.BoxesToGrabMin = 6-- Minimum boxes a player has to load onto the Drug plake
Config.BoxesToGrabMax = 6 -- Mazimum boxes a player has to load onto the Drug plake (DONT GO ABOVE 6)
----------
Config.WaitTimeForNewBoatDropoffMin = 3000 -- Minimum time to wait for a new boat drop off location after dropping a box off at one when in the plane
Config.WaitTimeForNewBoatDropoffMax = 8000 -- Maximum time to wait for a new boat drop off location after dropping a box off at one when in the plane
----------
Config.DrugPlaneModel = "dodo" -- Drug run plane model (i wouldnt change this because the bone index for box placement will mess up)
----------
Config.DrugsToGive = { -- Drugs or items the player gets when completeing a plane run and the item the player needs to load into there coke lab to make Config.FinalDrugProduct
    ["coke_brick"] = {
        AmountMin = 3,
        AmountMax = 7,
    },
}
----------
Config.CokeWorkerModles = { -- Ped models of the worker peds inside the coke lab
    "mp_f_cocaine_01",
}
----------
Config.CokeWorkerModlesMale = { -- Ped models of the worker peds inside the coke lab once fully upgraded
    "mp_m_meth_01",
}
----------
----------
-- With these default setting when the player first buys there coke lab and does not upgrade it, every 10 minutes the coke lab will produce 3 coke that can be picked up inside of the coke lab and remove 3 coke supplies.
-- When the player upgrades there coke lab 1 time every 8.5 minutes the coke lab will produce 6 coke that can be picked up inside of the coke lab and remove 6 coke supplies.
-- When the player upgrades there coke lab 2 times every 8 minutes the coke lab will produce 7 coke that can be picked up inside of the coke lab and remove 7 coke supplies.
-- When the player upgrades there coke lab 3 times every 7 minutes the coke lab will produce 9 coke that can be picked up inside of the coke lab and remove 9 coke supplies.
Config.TimeDrugsTakeToProcess = 180 -- (in minutes) Starting time it takes for Config.AmountOfDrugsToProcess to process. This gets faster and faster the higher upgrades the player unlocks. This runs while the player is loaded in and owns a coke lab.
Config.AmountOfDrugsToProcess = 3 -- Starting Amount of coke that get processed at a time every Config.TimeDrugsTakeToProcess while the player is loaded in.
----------
Config.TimePercentIncreaseUpgrade1 = 0.15 -- % faster the Config.TimeDrugsTakeToProcess will be when the player has upgraded there coke lab 1 time  27 minutes saved
Config.TimePercentIncreaseUpgrade2 = 0.20 -- % faster the Config.TimeDrugsTakeToProcess will be when the player has upgraded there coke lab 2 times 36 minutes saved
Config.TimePercentIncreaseUpgrade3 = 0.30 -- % faster the Config.TimeDrugsTakeToProcess will be when the player has upgraded there coke lab 3 times 54 minutes saved
----------
Config.ProductPercentIncreaseUpgrade1 = 1.0 -- % more product the player will get when the player has upgraded there coke lab 1 time
Config.ProductPercentIncreaseUpgrade2 = 1.30 -- % more product the player will get when the player has upgraded there coke lab 2 times
Config.ProductPercentIncreaseUpgrade3 = 2.00 -- % more product the player will get when the player has upgraded there coke lab 3 times
----------
Config.CokeBrickToSuppliesTanslation = {Min = 8, Max = 15} -- How much coke each coke brick turns into when you store it in your coke lab for the workers to break down into sellable coke.
----------
Config.MaxMembers = 3 -- The maximum amount of members that can own a coke lab together. (i would keep this low because the more members online the faster product is made)
Config.MaxPlaneRunsAtOne = 2 -- The max amount of coke plane runs the player can choose to do back to back to back.
----------
Config.CanRemoveLabOwner = false -- If the members of the garage can remove the owner or not
Config.ShowBlipOfOwnedCokeLab = true -- Show the blip of the players owned coke lab on the map (only shows your coke lab).
Config.UseProgressBar = true -- Some esx servers may not use a progress bar. (ignore this if you are qbcore)
----------
Config.UsePedToDoDrugRuns = false -- Make this true if you want players to find a ped to start the coke plane run instead of starting it through there laptop.
Config.PedLocation = vector4(-3202.97, 1205.99, 11.82, 87.06) -- Drug ped start location (this is not used and does not matter if Config.UsePedToDoDrugRuns is false)
Config.DrugPed = "s_m_m_pilot_02" -- Drug ped model (this is not used and does not matter if Config.UsePedToDoDrugRuns is false)
----------
Config.UpgradeCokeLabCost = 33000 -- $ cost to upgrade your coke lab workers (this is multiplied buy one more then the amount of times you have upgraded already when upgrading - starts at 0 upgrades so first upgrade will cost whatever Config.UpgradeCokeLabCost is)
Config.UpgradeCokeLabMembersCost = 27000 -- $ cost to upgrade your coke lab Members capacity. (this is multiplied buy the current members capacity number)
Config.KickMemberPrice = 90000 -- Cost of kicking a member (to prevent members being constantly swapped out and abused)
----------
Config.UpgradeCokeLabRequirement1 = 50 -- Minimum amount of supplies needed activly in the supplies storage for the player to be able to upgrade there coke lab members and the planes the 1st time
Config.UpgradeCokeLabRequirement2 = 125 -- Minimum amount of supplies needed activly in the supplies storage for the player to be able to upgrade there coke lab members and the planes the 2nd times
Config.UpgradeCokeLabRequirement3 = 255 -- Minimum amount of supplies needed activly in the supplies storage for the player to be able to upgrade there coke lab members and the planes the 3rd time
----------
Config.PlaneAltitudeToCallPolice = 70 -- If players fly above this altitude number while delivering packages it will call the police on them and give them an item with their cokelab password on it for the police to find on them and use to raid there coke lab.
Config.TimeItTakesToShutDownCokeLab = 10 -- Time in minutes it takes to shut down a coke lab as an officer (when a player with the police job enters a coke lab using there password they will have the option to shut the lab down forever on the laptop).
----------
Config.ProductSupplies = "coke_brick" -- The product supplies that are required to make Config.FinalDrugProduct in the coke lab every Config.TimeDrugsTakeToProcess minutes
Config.FinalDrugProduct = "cokebaggy" -- The product that is created over time by the workers in the cokelab every Config.TimeDrugsTakeToProcess minutes
----------
----------
Config.CokeLabDoors = { -- All of the door locations where players can go to buy there very own coke lab. (once a coke lab door is purchased by someone no one else can purchase that.)
    -- 5
    vector4(967.85, -1829.45, 31.24, 355.53),
    --vector4(1021.52, -1694.83, 33.57, 267.53),
    --vector4(1002.44, -1527.53, 30.98, 178.13),
    --vector4(873.0, -1579.56, 30.97, 0.86),
    --vector4(909.65, -1491.79, 30.31, 90.76),
    -- 10
    --vector4(979.32, -1982.47, 30.65, 316.92),
    --vector4(994.71, -2209.24, 31.66, 263.06),
    --vector4(1108.88, -2256.89, 30.94, 88.5),
    --vector4(1085.88, -2400.11, 30.67, 268.74),
    --vector4(975.37, -2430.07, 30.19, 265.64),
    -- 15
    --vector4(883.82, -2328.05, 30.59, 177.85),
    --vector4(818.58, -2365.14, 30.14, 267.76),
    --vector4(861.19, -2535.48, 28.45, 177.67),
    --vector4(719.09, -2102.92, 29.65, 265.06),
    --vector4(750.48, -1707.63, 29.45, 84.87),
    -- 20
    --vector4(925.79, -1292.55, 34.98, 217.51),
    --vector4(734.38, -1295.01, 27.04, 87.28),
    --vector4(895.96, -896.22, 27.8, 92.28),
    --vector4(727.47, -777.9, 25.43, 95.29),
    --vector4(689.22, -689.78, 26.38, 45.16),
    -- 25
    --vector4(400.01, 67.11, 97.98, 161.81),
    --vector4(260.22, 2.84, 79.62, 159.15),
    --vector4(25.22, 129.49, 97.21, 159.68),
    --vector4(-77.09, 14.1, 71.73, 157.48),
    --vector4(50.45, -108.45, 56.0, 342.04),
    -- 30
    --vector4(-1280.88, -1329.25, 4.2, 289.57),
    --vector4(-1132.54, -1433.91, 5.04, 215.98),
    --vector4(-1148.25, -1431.41, 11.43, 35.72),
    --vector4(-1083.31, -1262.03, 5.59, 299.52),
    --vector4(-1174.66, -1153.53, 5.66, 286.02),
}
----------
Config.CokePlanes = {
    --⚠️ DO NOT CHANGE ANYTHING ABOUT OPTION 0 ⚠️
    [0] = { -- ⚠️ DO NOT CHANGE THIS ⚠️
        model = "dodo", --⚠️ DO NOT CHANGE THIS ⚠️
        price = 0,
        bone1 = 39, -- bone index of the plane to attach the boxes too.
        bone2 = 40, -- other side of the plane bone index of the plane to attach the boxes too.
        xaxis = 0.0, -- this is set to 0.0 so that there is data. If this was nil it would move the box on the x axis.
        yaxis = nil, -- this is set to nil so that the box moves + 1 on the y axis.
        zaxis = -0.9,
    },
    --⚠️ DO NOT CHANGE THIS ^^^ ⚠️

    -- YOU CAN CHANGE ANYTHING BELOW THIS BUT YOU WILL NEED TO FIND THE POSITIONS YOURSELF IF YOU WANT TO CHANGE THEM.
    -- ALSO DO NOT CHANGE THIS AFTER PEOPLE HAVE ALREADY BEEN USING THE SCRIPT BECAUSE THEN EVERYTHING WILL BE OUT OF SYNC.
    -- TO FIND THE RIGHT POSITIONS I MADE A TESTING TEMPLATE AT THE BOTTOM OF THE OPEN.LUA CHANGE THIS AT YOUR OWN DISCRETION! (SUPPORT IS NOT PROVIDED TO CHANGE THESE AS IT IS VERY DIFFICULT AND HOURS OF WORK)
    [1] = {
        model = "seabreeze",
        price = 5500,
        bone1 = 33, -- bone index of the plane to attach the boxes too.
        bone2 = 43, -- other side of the plane bone index of the plane to attach the boxes too.
        xaxis = nil, -- this is set to nil so that the box moves + 1 on the x axis.
        yaxis = 0.5, -- this is set to 0.0 so that there is data. If this was nil it would move the box +1 on the y axis.
        zaxis = 0.22,
    },
    [2] = {
        model = "vestra",
        price = 12000,
        bone1 = 22, -- bone index of the plane to attach the boxes too.
        bone2 = 33, -- other side of the plane bone index of the plane to attach the boxes too.
        xaxis = nil, -- this is set to nil so that the box moves + 1 on the x axis.
        yaxis = 0.0, -- this is set to 0.0 so that there is data. If this was nil it would move the box +1 on the y axis.
        zaxis = 0.2,
    },
}
----------
Config.DrugBoatPedModel = { -- Drug boat ped model (there are a lot of these because this ped speaks and it gives a veriety of different speaches)
    "ig_fbisuit_01",
    "ig_floyd",
    "ig_hao",
    "ig_djgeneric_01",
    "ig_davenorton",
    "s_m_m_lifeinvad_01",
    "s_m_m_ammucountry",
    "s_m_m_autoshop_02",
    "s_m_m_bouncer_01",
    "s_m_m_chemsec_01",
    "s_m_m_gaffer_01",
}
----------
Config.RandomBoatModel = { -- Random boat models that spawn when you do coke plane runs. (just gives veriety)
    "squalo",
    "suntrap",
    "tropic",
    "jetmax",
    "toro",
    "toro2",
    "longfin",
    "speeder",
}
----------
Config.RandomBoatSpawns = { -- Random Boad spawns out in the middle of the map lake while doing coke plane runs.
    vector4(2231.02, 4082.23, 30.38, 330.19),
    vector4(2297.06, 4334.5, 30.26, 357.91),
    vector4(2096.13, 4505.92, 29.87, 113.29),
    vector4(1981.92, 4211.05, 29.88, 206.26),
    vector4(1682.17, 4106.25, 29.63, 107.08),
    vector4(1519.05, 4241.71, 30.66, 165.71),
    vector4(1312.99, 3900.73, 29.5, 157.63),
    vector4(988.88, 3816.76, 30.53, 91.94),
    vector4(967.3, 4231.25, 31.05, 172.64),
    vector4(729.21, 4003.89, 30.42, 109.72),
    vector4(425.51, 3764.99, 30.25, 329.65),
    vector4(208.39, 3908.43, 30.69, 307.75),
    vector4(348.83, 4059.51, 31.5, 212.73),
    vector4(132.8, 4049.57, 30.9, 237.73),
    vector4(-127.54, 4072.26, 29.6, 244.96),
    vector4(-4.64, 4263.46, 31.86, 211.63),
}
----------
Config.PickupPlaneLocations = { -- This table handles the random boat spawns table, Plane pickup location, and boxes pickup locations.
    [1] = {
        BoatsSpawns = Config.RandomBoatSpawns,
        PlaneLoc = vector4(2133.0, 4785.41, 40.78, 26.4),
        Boxes = {
            vector4(2139.79, 4791.22, 40.97, 11.41),
            vector4(2140.84, 4790.36, 40.97, 322.81),
            vector4(2145.17, 4777.23, 40.97, 296.65),
            vector4(2146.94, 4774.49, 41.03, 267.0),
            vector4(2138.01, 4771.42, 41.01, 201.93),
            vector4(2133.11, 4769.17, 41.01, 189.67),
            vector4(2128.16, 4769.13, 40.97, 114.51),
            vector4(2127.57, 4770.89, 40.97, 120.05),
            vector4(2125.59, 4774.83, 40.97, 126.34),
        },
    },
    [2] = {
        BoatsSpawns = Config.RandomBoatSpawns,
        PlaneLoc = vector4(1732.21, 3307.29, 42.03, 195.98),
        Boxes = {
            vector4(1725.43, 3294.2, 41.22, 107.28),
            vector4(1722.31, 3302.89, 41.22, 110.36),
            vector4(1720.92, 3304.51, 41.22, 109.81),
            vector4(1720.27, 3306.63, 41.22, 110.48),
            vector4(1720.0, 3308.68, 41.22, 113.35),
            vector4(1719.14, 3310.61, 41.22, 110.1),
            vector4(1722.84, 3324.63, 41.22, 19.75),
            vector4(1724.53, 3325.93, 41.22, 17.49),
            vector4(1726.61, 3326.49, 41.22, 15.91),
            vector4(1728.63, 3326.7, 41.22, 16.2),
            vector4(1730.97, 3326.52, 41.22, 25.88),
            vector4(1734.48, 3329.52, 41.22, 287.34),
            vector4(1739.22, 3323.06, 41.22, 287.53),
            vector4(1740.54, 3321.58, 41.22, 288.26),
            vector4(1741.15, 3319.33, 41.22, 287.92),
            vector4(1741.36, 3317.28, 41.22, 289.49),
            vector4(1741.55, 3314.72, 41.22, 288.5),
            vector4(1742.61, 3312.95, 41.22, 295.78),
            vector4(1743.33, 3311.48, 41.22, 279.9),

        },
    },
}
----------
Config.ReturnPlaneLocations = { -- Random location where you return the plane to and the peds location to take the plane and exchange the drugs.
    [1] = {
        PedLocation = vector4(1700.72, 3286.77, 41.15, 201.88),
        PlaneLocation = vector4(1702.45, 3273.56, 41.16, 238.97),
    },
    [2] = {
        PedLocation = vector4(2097.78, 4774.58, 41.14, 151.24),
        PlaneLocation = vector4(2092.76, 4768.21, 41.21, 262.15),
    }
}
----------
----------
Config.PickupPlaneBlip = { -- Picking up plane blip
    Type = 9,
    Size = 0.2,
    Color = 3,
    Opacity = 120,
}
----------
Config.PickupBoxBlip = { -- Picking up box blip
    Type = 9,
    Size = 0.1,
    Color = 3,
    Opacity = 150,
}
----------
Config.BoatDropOffBlip = { -- Boat drop off blip
    Type = 9,
    Size = 0.55,
    Color = 3,
    Opacity = 120,
}
----------
Config.PlaneDropOffBlip = { -- Dropping off plane blip
    Type = 9,
    Size = 0.1,
    Color = 3,
    Opacity = 150,
}
----------
Config.PersonalCokeLabBlip = { -- Players personal coke lab blip
    Type = 497,
    Size = 0.7,
    Color = 0,
    Opacity = 500,
}
----------
----------
Config.MarkerBoxLocations = { -- The draw marker where you pickup boxes at
    ShowDrawMarker = true, -- Make this false if you do not want the draw marker to show.
    Type = 25,
    Scale = {x = 1.0, y = 1.0, z = 1.0},
    Color ={r = 51, g = 153, b = 255, a = 200}, -- Marker configuration
}
----------
Config.MarkerBoatLocations = { -- The draw marker where drop the boxes off at above the boats
    ShowDrawMarker = true, -- Make this false if you do not want the draw marker to show.
    Type = 6,
    Scale = {x = 4.0, y = 4.0, z = 4.0},
    Color ={r = 37, g = 150, b = 190, a = 180}, -- Marker configuration
}
----------
Config.LangT = { -- All translation options are here.
    -- Menu
    ["DrugRunMenuHeader"] = "Drug running",
    ["DrugRunMenuOption"] = "Start drug running",
    ["DrugRunMenuDescription"] = "$"..Config.DrugPlaneDeposit.." deposit to start run",
    ["CokeDoorDescription"] = "Production Laboratory",
    ["BuyCokeLab"] = "Purchase Laboratory",
    ["EnterPassword"] = "Enter Password",
    ["EnterPasswordDescription"] = "This Laboratory is owned.",
    ["EnterLab"] = "Enter Laboratory",
    ["CloseMenu"] = "Close",
    ["SuppliesAmount"] = "Supplies Amount",
    ["CollectProduct"] = "Collect Product",
    ["HireWorkers"] = "Hire more workers",
    ["AddLabMember"] = "Add members",
    ["AddLabMemberDescription"] = "/"..Config.MaxMembers .." members | Add members to your laboratory!",
    ["UpgradeMembers"] = "Upgrade members capacity",
    ["PickupSupplies"] = "Pickup supplies",
    ["PickupSuppliesDescription"] = "supplies | Pickup a plane to deliver some packages and earn some supplies!",
    ["MaxedOut"] = "(Maxed Out)",
    ["+1For"] = "+1 for $",
    ["ManageCokeLab"] = "Manage CokeLab",
    ["AddAMember"] = "Add A Member",
    ["CurrentCapacity"] = "Current capacity ",
    ["ChangePassword"] = "Change password",
    ["CurrentPassword"] = "Current password: ",
    ["AddMember"] = "Add Member",
    ["PlayersId"] = "(PLAYERS ID)",
    ["ChooseAmountOfRuns"] = "Choose Amount Of Runs",
    ["ShutDownCokeLab"] = "Shut Down Coke Lab",
    ["ShutDownCokeLabDescription"] = "Shut Down Coke Lab PERMANENTLY!",
    ["ShuttingDownCokeLab"] = "Shutting Down Coke Lab PERMANENTLY...",
    ["Amount"] = "(Max is "..Config.MaxPlaneRunsAtOne..")",
    ["ManageMembers"] = "Manage Members",
    ["ManageMembersDescription"] = " Members",
    ["Back"] = "< back",
    ["KickMember"] = "Kick Member ($",
    ["MaxMembers"] = "Your max members count is ",
    ["AreYouSureYouWantToRemove"] = "Are You Sure You Want ToRemove ",
    ["UpgradeMemberSlots"] = "Upgrade Member Slots",
    ["ForMoney"] = " for $",
    ["Yes"] = "Yes",
    ["No"] = "No",
    ["CurrentprocessTime"] = "Current process time: ",
    ["MinutesAndprocess"] = " minutes | Current process amount: ",
    ["UpgradePlane"] = "Plane Management",
    ["CurentPlane"] = "Curent plane: ",
    ["NextPlane"] = "| Next plane: ",
    ["ChoosePlane"] = "Choose Plane",
    ["SelectedPlane"] = "has been selected",
    ["SelectOrUpgradePlane"] = "Select or upgrade plane | Current plane: ",
    ["PurchasePlane"] = "Purchase plane for $",
    ["Owned"] = "(OWNED)",
    ["UpgradePlanes"] = "(Upgradable planes ↓)",
    ["SuppliesRequired"] = "Supplies required",
    ["YouNeed"] = "You need",
    ["SuppliesNeeded"] = "supplies to do this upgrade...",
    -- Notifications
    ["StartedDrugRun"] = "Go load that plane",
    ["AreaNotClear"] = "The plane is trying to spawn but the area is not clear yet",
    ["YouLefTheDrugPlane"] = "You have gone to far from the Drug plane..",
    ["FinishedLoadingPlane"] = "You have finished loading the plane..",
    ["HeadToPackageDropOffs"] = "Head to the packages drop off locations",
    ["BoxesIntoPlain"] = "boxes into the plane",
    ["OtherSideOfPlane"] = "You need to go to the other side of the plane",
    ["ActiveJobAlready"] = "You already have an active job and need to wait to do your next one.",
    ["PlaneDestroyed"] = "Your plane hase been detroyed..",
    ["NotEnoughMoney"] = "You do not have enough money..",
    ["YouEarned"] = "You earned",
    ["BonusForBoxes"] = "bonus from the boxes you dropped off",
    ["LoadUp"] = "Load up",
    ["GetCloserToTheDoor"] = "Get closer to the door",
    ["PurchaseLaboratory"] = "You have successfully purchased a coke lab",
    ["YouAreMissing"]  = "you are missing ",
    ["AlreadyApartOfLab"]  = "you are already apart of a lab",
    ["AlreadyApartOfLabMember"]  = "they are already apart of a lab",
    ["AlreadyAMember"]  = "This person is already a member",
    ["InTheLab"]  = " Product in the laboratory",
    ["NoInput"] = "No input entered",
    ["NotEnough"]  = "You do not have this much product...",
    ["AlreadyAddingOrRemovingProduct"]  = "You are already adding or removeing product. Wait...",
    ["SuppliesAdded"] = "Supplies Added",
    ["TotalSupplies"] = "Total Supplies",
    ["ProductRemoved"] = "Product Removed",
    ["NoSuppliesInLab"] = "Not enough supplies in the lab to make product..",
    ["SuccessUpgrade"] = "Successful Upgrade of coke lab + 1",
    ["SuccessUpgradeMembers"] = "Successful Upgrade of coke lab + 1 members",
    ["LabNotFound"] = "Lab Not Found",
    ["NoID"] = "No ID entered",
    ["MaxCapacity"]  = "You are at max capacity",
    ["NotInCity"]  = "This person is not in city",
    ["NoPassword"] = "No password entered",
    ["ChangedPassword"]  = "succesfully changed password to ",
    ["CantDoThisMany"]  = "The max amount of runs you can do at once is "..Config.MaxPlaneRunsAtOne,
    ["WrongPassword"]  = "Wrong password",
    ["SuccessAddedMember"]  = "Successfuly Added Member",
    ["SuccessShutDownLab"]  = "Successfuly Shut Down Lab",
    ["YourCokeLabHasBeenRaided"]  = "Your coke lab has been raided and shut down!",
    ["CantRemoveOwner"] = "You cannot remove the garage owner",
    ["SuccessUpgradeAirPlane"] = "Successfuly ugraded airplane to",
    ["NeedToUpgadeFirst"] = "You need to upgrade to the plane before this one before you can buy this",
    ["CanNotDoThis"] = "Can not do this",
    ["AlreadyHaveThisPlane"] = "You already have this plane..",
    ["CokeLab"] = "Coke Lab",
    ["PlaneHasGoneHigh"] = "You dont want to fly too high there pal...",
    -- DrawText
    ["PickupBox"] = "[E] Pickup Box",
    ["LoadBoxToPlane"] = "[E] Load Box",
    ["ParkVehicle"] = "[E] Store Plane",
    -- Target
    ["CokeDoorText"] = "Laboratory",
    ["LeaveCokeLab"] = "Leave Laboratory",
    ["Supplies"] = "Supplies",
    ["Product"] = "Product",
    ["CollectProduct"] = "Collect Product",
    ["AddSupplies"] = "Add Supplies",
    ["Laptop"] = "Laptop",
}

-- (DONT TOUCH THIS. THESE ARE MAIN FRAMEWORK FUNCTIONS!!)
Config.FrameworkFunctions = {
    -- Client-side trigger callback
    TriggerCallback = function(...)
        if Framework == 'QBCore' then
            FWork.Functions.TriggerCallback(...)
        else
            FWork.TriggerServerCallback(...)
        end
    end,

    -- Server-side register callback
    CreateCallback = function(...)
        if Framework == 'QBCore' then
            FWork.Functions.CreateCallback(...)
        else
            FWork.RegisterServerCallback(...)
        end
    end,

    -- Server-side get player data
    GetPlayer = function(source, cid)
        if Framework == 'QBCore' then
            local self = {}
            local player = nil
            if cid then
                player = FWork.Functions.GetPlayerByCitizenId(source)
            else
                player = FWork.Functions.GetPlayer(source)
            end

            if(player ~= nil) then
                self.source = source
                self.PlayerData = { charinfo = { firstname = player.PlayerData.charinfo.firstname, lastname = player.PlayerData.charinfo.lastname}, money = player.PlayerData.money, citizenid = player.PlayerData.citizenid, source =  player.PlayerData.source, items = player.PlayerData.items, job = {name = player.PlayerData.job.name }}
                self.AddMoney = function(currency, amount)
                    player.Functions.AddMoney(currency, amount)
                end
                self.RemoveMoney = function(currency, amount)
                    player.Functions.RemoveMoney(currency, amount)
                end

                self.RemoveItem = function(item, amount)
                    player.Functions.RemoveItem(item, amount, false)
                end

                self.AddItem = function(item, amount, info)
                    player.Functions.AddItem(item, amount, false, info)
                end


                return self
            end
        else
            local self = {}
            local player = nil
            if cid then
                player = PugFindPlayersByItentifier(source)
                if player then
                    self.PlayerData = {source = PugFindPlayersByItentifier(source, true), charinfo = { firstname = player.get('firstName'), lastname = player.get('lastName')} }
                    return self
                else
                    return nil
                end
            else
                player = FWork.GetPlayerFromId(source)
            end

            if (player ~= nil) then
                self.source = source
                self.PlayerData = { charinfo = { firstname = player.get('firstName'), lastname = player.get('lastName')}, money = {cash = player.getAccount('money').money, bank = player.getAccount('bank').money}, job = { name = player.job.name }, citizenid = FWork.GetIdentifier(source)}
                self.AddMoney = function(currency, amount)
                    player.addMoney(amount)
                end
                self.RemoveMoney = function(currency, amount)
                    player.removeMoney(amount)
                end

                self.RemoveItem = function(item, amount)
                    player.removeInventoryItem(item, amount)
                end

                self.AddItem = function(item, amount, info)
                    player.addInventoryItem(item, amount, false, info)
                end

                return self
            end
        end

        return nil
    end,
}