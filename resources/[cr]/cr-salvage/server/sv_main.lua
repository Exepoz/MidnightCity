local isTruck = false
local SalvageInfo = {}
local WorldWreckInteracted = false
SalvageInfo.ShopItems = Config.ScrapyardPed.ShopItems
GlobalState.CRSalvage = SalvageInfo
local isFlightBoxThere = false

local function VersionCheck()
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        local function ToNumber(cd) return tonumber(cd) end
        local resource_name = GetCurrentResourceName()
        local current_version = GetResourceMetadata(resource_name, 'version', 0)
        PerformHttpRequest('https://github.com/Constant-Development/cr-versions/blob/main/'..resource_name..'.txt?raw=true',function(_, r, _)
            if not r then print('^8Cannot Reach GitHub, Updater Disabled^0') return end
            local result = json.decode(r:sub(1, -1))
            local color = '^9'--'^'..math.random(2,9)
            local symbols = color..'~= ^5Constant Development Updater '..color
            local suffix = ""
            for _ = 1, 26+#resource_name do
                suffix = suffix..'='
            end
            symbols = symbols..suffix..'~^0'
            if ToNumber(result.version:gsub('%.', '')) > ToNumber(current_version:gsub('%.', '')) then
                print(symbols)
                print('^1 ['..resource_name..'] - Update Available!\n'..color..'^0 You are using: ^3'..current_version..'^0\n Version Available: ^3'..result.version..'\n^0 Changelog: ^3'..result.notes..'^0\n See Discord for full changelog ^3(https://discord.gg/5Trc4nEuga)')
                print(symbols)
            else
                --print(symbols)
                print('^2 ['..resource_name..'] ~ v'..current_version..' ~ Up to Date!^0')
                --print(symbols)
            end
        end,'GET')
    end)
end

local function SpawnNewWreck()
    SalvageInfo.YardLocation = math.random(#Config.YardLocations)
    SalvageInfo.YardWreckMaxHealth = math.random(Config.YardWrecks.HarvestsPerWrecks.min, Config.YardWrecks.HarvestsPerWrecks.max)
    local truckChance = math.random(100)
    if truckChance <= Config.YardWrecks.TruckChance then
        local ran = math.random(#Config.WreckHash['scrapyardbig'])
        SalvageInfo.YardHash = Config.WreckHash['scrapyardbig'][ran]
        SalvageInfo.YardWreckMaxHealth = SalvageInfo.YardWreckMaxHealth * 2
    else
        local ran = math.random(#Config.WreckHash['scrapyardsmall'])
        SalvageInfo.YardHash = Config.WreckHash['scrapyardsmall'][ran]
    end
    SalvageInfo.YardWreckCurrentHealth = SalvageInfo.YardWreckMaxHealth
    SalvageInfo.YardWreckProgress = 0
    GlobalState.CRSalvage = SalvageInfo
    Wait(1000)
    return true
end

local function WreckDepleted()
    SalvageInfo.YardWreckProgress = 0
    SalvageInfo.YardHash = nil
    SalvageInfo.YardLocation = nil
    GlobalState.CRSalvage = SalvageInfo
    Wait(math.random(Config.YardWrecks.TimeBetweenSpawns.min, Config.YardWrecks.TimeBetweenSpawns.max) * 1000)
    if SpawnNewWreck() then
        if Config.Debug then print(Lcl("debug_spawningnewwreck", Config.YardLocations[SalvageInfo.YardLocation], SalvageInfo.YardHash)) end
        Wait(1000)
        TriggerClientEvent('cr-salvage:client:SpawnYardWreck', -1)
    end
end

local function SpawnNewWorldWreck()
    if Config.Debug then print(Lcl('debug_GeneratingWWInfo')) end
    isFlightBoxThere = true
    local wwType = Config.WorldWrecks.Scenarios[math.random(#Config.WorldWrecks.Scenarios)]
    local wwLoc = math.random(#Config.WorldWrecks[wwType].Locations)
    SalvageInfo.WorldWreckLocation = wwLoc
    SalvageInfo.WorlWreckType = wwType
    SalvageInfo.WorldWreckActive = true
    if Config.WorldWrecks[wwType].onSpawnEvent then SalvageInfo.isSpawnEventThere = true end
    SalvageInfo.offset = {}
    SalvageInfo.offset.x, SalvageInfo.offset.y = math.random(-750, 750), math.random(-750, 750)
    SalvageInfo.WorldWreckMaxHealth = math.random(Config.WorldWrecks[wwType].health.min, Config.WorldWrecks[wwType].health.max)
    SalvageInfo.WorldWreckCurrentHealth = SalvageInfo.WorldWreckMaxHealth
    SalvageInfo.WorldWreckProgress = 0
    GlobalState.CRSalvage = SalvageInfo
    if Config.WorldWrecks[wwType].onGenerationEvent then WorldWreckOnGenerationEventSV(wwType) end
    TriggerClientEvent('cr-salvage:client:SpawnWW', -1, wwType, wwLoc)
    DespawnTimer()
end

local function LowerWreckHealth()
    if SalvageInfo.YardWreckCurrentHealth > 0 then
        SalvageInfo.YardWreckCurrentHealth = SalvageInfo.YardWreckCurrentHealth - 1
        if SalvageInfo.YardWreckCurrentHealth == 0 then
            if Config.Debug then
                print(Lcl("debug_wreckdepleted"))
            end
            SalvageInfo.YardWreckProgress = 10
            GlobalState.CRSalvage = SalvageInfo
            TriggerClientEvent('cr-salvage:client:DeleteCurrentWreck', -1)
            WreckDepleted()
        else
            local left = SalvageInfo.YardWreckMaxHealth - SalvageInfo.YardWreckCurrentHealth
            SalvageInfo.YardWreckProgress = math.floor((left / SalvageInfo.YardWreckMaxHealth) * 10)
            GlobalState.CRSalvage = SalvageInfo
        end
    end
end

local function LowerWWHealth(TimesUp)
    if SalvageInfo.WorldWreckCurrentHealth > 0 then
        SalvageInfo.WorldWreckCurrentHealth = SalvageInfo.WorldWreckCurrentHealth - 1
        if SalvageInfo.WorldWreckCurrentHealth == 0 or TimesUp then
            if Config.Debug then print(Lcl("debug_wreckdepleted")) end
            TriggerClientEvent('cr-salvage:client:RemoveBB', -1)
            SalvageInfo.WorldWreckProgress = 10
            SalvageInfo.WorldWreckLocation = nil
            SalvageInfo.WorldWreckHealth = nil
            SalvageInfo.WorlWreckType = nil
            SalvageInfo.WorldWreckActive = false
            GlobalState.CRSalvage = SalvageInfo
            TriggerClientEvent('cr-salvage:client:DeleteWorldWreck', -1, not TimesUp)
            CreateThread(function()
                local time = math.random((Config.WorldWrecks.TimeBetweenWrecks.min), Config.WorldWrecks.TimeBetweenWrecks.max)
                if Config.Debug then print(Lcl('debug_WaitingForWW', time)) end
                Wait(time * 60000)
                SpawnNewWorldWreck()
            end)
        else
            local left = SalvageInfo.WorldWreckMaxHealth - SalvageInfo.WorldWreckCurrentHealth
            SalvageInfo.WorldWreckProgress = math.floor((left / SalvageInfo.WorldWreckMaxHealth) * 10)
            GlobalState.CRSalvage = SalvageInfo
        end
    end
end

function DespawnTimer()
    local SpawnTime = GetGameTimer()
    local DespawnTime = SpawnTime + (Config.WorldWrecks.DespawnTime * 60000)
    CreateThread(function()
        while true do
            Wait(1 * 60000)
            if not SalvageInfo.WorldWreckActive then break end
            if WorldWreckInteracted then DespawnTime = GetGameTimer() + (Config.WorldWrecks.DespawnTime * 60000) WorldWreckInteracted = false end
            if GetGameTimer() >= DespawnTime then if Config.Debug then print(Lcl('debug_WorldWreckTimesUp')) end LowerWWHealth(true) break end
        end
    end)
end

RegisterNetEvent('cr-salvage:server:ToggleEmails', function()
    local src = source
    local state = Player(src).state.cr_salvage_emails
    Player(src).state:set('cr_salvage_emails', not state, true)
    if state == false then SSUtils.SalvageNotify(2, Lcl("notif_enableemailnotification"), Lcl('salvagetitle'), src)
    else SSUtils.SalvageNotify(2, Lcl("notif_disableemailnotification"), Lcl('salvagetitle'), src) end
    if Config.EmailDataBase then SSUtils.ToggleEmails(src, state) end
end)

RegisterNetEvent('cr-salvage:server:SawPfx', function(coords)
    TriggerClientEvent('cr-salvage:client:SawPfx', -1, source, coords)
end)

RegisterNetEvent('cr-salvage:server:StopPfx', function()
    TriggerClientEvent('cr-salvage:client:StopPfx', -1, source)
end)

RegisterNetEvent('cr-salvage:server:BreakSaw', function(serversource)
    local src
    if serversource then src = serversource else src = source end
    SSUtils.RemoveItem(src, Config.PowerSawItem, 1)
    SSUtils.GiveItem(src, Config.BrokenPowerSawItem, 1)
    SSUtils.SalvageNotify(3, Lcl("notif_sawbladebroke"), Lcl("salvagetitle"), src)
end)

RegisterNetEvent('cr-salvage:server:RepairSaw', function(serversource)
    local src
    if serversource then src = serversource else src = source end
    SSUtils.RemoveItem(src, Config.BrokenPowerSawItem, 1)
    local info = {}
    info.bladequal = Config.PowerSaw.Durability
    SSUtils.GiveItem(src, Config.PowerSawItem, 1, info)
end)

RegisterNetEvent('cr-salvage:server:getScrapLoot', function(bonusrolls, world)
    local src = source
    local CurrentWreck
    local rolls = math.random(Config.YardWrecks.HarvestRolls.min, Config.YardWrecks.HarvestRolls.max)
    local logText = ""
    local wwtypename = GlobalState.CRSalvage.WorlWreckType
    SSUtils.LowerMetadata(src, Config.PowerSawItem, 'bladequal')
    WorldWreckInteracted = true
    if world then
        rolls = math.random(Config.WorldWrecks[wwtypename].HarvestRolls.min, Config.WorldWrecks[wwtypename].HarvestRolls.max)
        CurrentWreck = Config.WorldWrecks[wwtypename]
    else
        CurrentWreck = Config.YardWrecks
    end
    if bonusrolls then
        local bonus
        if world then bonus = math.random(Config.SalvageMinigame.BonusRollsSettings.BonusAmount.min, Config.SalvageMinigame.BonusRollsSettings.BonusAmount.max)
            if Config.SalvageMinigame.BonusRollsSettings.Notify then SSUtils.SalvageNotify(1, Lcl("notif_bonuslootnotif"), Lcl("salvagetitle"), src) end
        else bonus = math.random(Config.SkillCheck.Behaviour.BonusRollsSettings.BonusAmount.min, Config.SkillCheck.Behaviour.BonusRollsSettings.BonusAmount.max)
            if Config.SkillCheck.Behaviour.BonusRollsSettings.Notify then SSUtils.SalvageNotify(1, Lcl("notif_bonuslootnotif"), Lcl("salvagetitle"), src) end
        end
        if Config.Debug then
            print(Lcl("debug_bonusroll", GetPlayerName(src), bonus))
        end
        rolls = rolls + bonus
    end
    for i=1, rolls, 1 do
        local chosenloot = GenerateLoot(CurrentWreck.HarvestMaterials)
        local item = CurrentWreck.HarvestMaterials[chosenloot].item
        local qty = math.random(CurrentWreck.HarvestMaterials[chosenloot].amt.min , CurrentWreck.HarvestMaterials[chosenloot].amt.max)
        if isTruck then qty = qty * 2 end
        --print("Roll "..i.."/"..rolls.." | Rarity : "..rarity.." | Item : "..item.." | Qty : "..qty)
        SSUtils.GiveItem(src, item, qty)
        --logText = logText.."**Roll "..i.."/"..rolls.."** | **Rarity :** "..rarity.." | **Item : **"..item.." | **Qty :** "..qty.."\n"
        logText = logText..Lcl('logs_Roll', i, rolls).." **|** "..Lcl('logs_Item', item).." **|** "..Lcl('logs_Qty', qty).."\n"
    end
    if Config.Debug then
        local health = GlobalState.CRSalvage.YardWreckCurrentHealth
        local wtype = "Scrapyard"
        if world then health = GlobalState.CRSalvage.WorldWreckCurrentHealth wtype = "World Wreck" end
        print(Lcl("debug_salvagenotification", GetPlayerName(src), rolls, wtype, health))
    end
    if Config.Logs then SSUtils.Logs(Lcl('logs_title'), 'green', Lcl('logs_ItemReceived', GetPlayerName(src), logText)) end
    if world then
        LowerWWHealth()
    else
        LowerWreckHealth()
    end
end)

RegisterNetEvent('cr-salvage:server:flightboxrewards', function()
    local src = source
    if SSUtils.HasItem(src, Config.FlightBox.Item) then
        SSUtils.RemoveItem(src, Config.FlightBox.Item, 1)
        if Config.FlightBox.Reward.Cash.Enabled then
            local amount = math.random(Config.FlightBox.Reward.Cash.Amount.min, Config.FlightBox.Reward.Cash.Amount.max)
            SSUtils.AddMoney(src, Config.FlightBox.Reward.Cash.Currency, amount)
            if Config.Logs then SSUtils.Logs(Lcl('logs_FlightBoxRewardTitle'), 'green', Lcl('logs_FlightBoxMoneyReward', GetPlayerName(src), amount)) end
        end
        if Config.FlightBox.Reward.Items.Enabled then
            for _, v in pairs(Config.FlightBox.Reward.Items.Items) do
                local ran = math.random(v.min, v.max)
                SSUtils.GiveItem(src, v.item, ran)
                if Config.Logs then SSUtils.Logs(Lcl('logs_FlightBoxRewardTitle'), 'green', Lcl('logs_FlightBoxItemReward', GetPlayerName(src), v.item, ran)) end
            end
        end
    end
end)

RegisterNetEvent('cr-salvage:server:TakeBB', function(coords)
    local src = source
    local item = Config.FlightBox.Item
    if not isFlightBoxThere then return end
    isFlightBoxThere = false
    if SSUtils.GiveItem(src, item, 1) then
        SalvageInfo.isSpawnEventThere = false
        GlobalState.CRSalvage = SalvageInfo
        TriggerClientEvent('cr-salvage:client:RemoveBB', -1, coords)
        if Config.Logs then SSUtils.Logs(Lcl('logs_FlightBoxTitle'), 'green', Lcl('logs_FlightBoxItemReward', GetPlayerName(src), item, "1")) end
    else
        SSUtils.SalvageNotify(3, Lcl('notif_notenoughspace'), Lcl('salvagetitle'))
    end
end)

RegisterNetEvent('cr-salvage:server:buyItem', function(item, amount)
    local src = source
    if SalvageInfo.ShopItems[item].stock >= amount then
        local info = {}
        if SalvageInfo.ShopItems[item].name == Config.PowerSawItem then
            info.bladequal = Config.PowerSaw.Durability
        end
        local tprice = SalvageInfo.ShopItems[item].price * amount
        if not SSUtils.TakeMoney(src, 'cash', tprice) then SSUtils.SalvageNotify(3, Lcl('shop_notenoughmoney'), Lcl('salvagetitle')) return end
        if not SSUtils.GiveItem(src, SalvageInfo.ShopItems[item].name, amount, info) then SSUtils.AddMoney(src, "cash", tprice) return end
        SalvageInfo.ShopItems[item].stock = SalvageInfo.ShopItems[item].stock - amount
        GlobalState.CRSalvage = SalvageInfo
        if Config.Logs then SSUtils.Logs(Lcl('logs_ItemBoughtTitle'), 'green', Lcl('logs_ItemBought', GetPlayerName(src), item, amount)) end
    else
        SSUtils.SalvageNotify(3, Lcl('shop_notenoughstock'), Lcl('salvagetitle'))
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        VersionCheck()
        SpawnNewWreck()
        Wait(5000)
        if Config.Dev then
            SpawnNewWorldWreck()
        else
            CreateThread(function()
                Wait(math.random(Config.WorldWrecks.TimeBetweenWrecks.min, Config.WorldWrecks.TimeBetweenWrecks.max) * 60000)
                SpawnNewWorldWreck()
            end)
        end
    end
end)



-- Config
--  ['heli'] = { -- Setting for the crash plane
--  health = {min = 1, max = 1},
--  HarvestsPerWrecks = {min = 3, max = 5}, -- Global amount of "harvests" a singular wreck has before depleting.
--  HarvestRolls = {min = 1, max = 4}, -- Number of material stacks given per harvests.
--  HarvestMaterials = { -- Rarity gets rolled first, and then a random item from that rarity is selected.
--      ['common'] = {
--          {item = 'metalscrap', minQty = 2, maxQty = 3},
--          {item = 'aluminum', minQty = 3, maxQty = 5},
--          {item = 'steel', minQty = 2, maxQty = 4},
--      },
--      ['uncommon'] = {
--          {item = 'steel', minQty = 2, maxQty = 4},
--      },
--      ['rare'] = {
--          {item = 'carbon', minQty = 2, maxQty = 3},
--      },
--      ['super-rare'] = {
--          {item = 'electronics', minQty = 2, maxQty = 3},
--      },
--      ['special'] = {
--          {item = 'goldchain', minQty = 1, maxQty = 2},
--      }
--  },
-- }

-- ['heli'] = {
--     locations = {
--         { coords = vector4(-2499.19, 829.63, 282.54, 48.00)},
--     }
-- }