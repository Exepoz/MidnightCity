QBCore = exports[Config.CoreFolderName]:GetCoreObject()
local WeedPlants, GrowLabs, OutsideRacks = {}, {}, {}
local DryZones = {}
local Padlocks = {}
local maxId = 0

-----------------------------------
-- Initial Data & Data Callbacks --
-----------------------------------

-- Initial Loading Thread
Citizen.CreateThread(function()
    Citizen.Wait(100)

    local LabJson = CustomSQL('fetchAll', 'SELECT * from `malmo_w_labs`', {})
    if LabJson then for _, v in ipairs(LabJson) do
        local Lab = tonumber(v.Lab)
        if not Lab then return end
        local Humidity = v.Humidity or 0
        local WaterSettings = json.decode(v.WaterSettings) or {
            waterLvl = 0,
            acid = 0,
            alka = 0,
            fert = 0,
        }
        local GrowLights = json.decode(v.GrowLights) or {}
        local LightSettings = json.decode(v.LightSettings) or {}
        local DryHooks = json.decode(v.DryHooks) or {}
        local Padlock = json.decode(v.Padlock) or {}
        GrowLabs[Lab] = {Humidity = Humidity, WaterSettings = WaterSettings, GrowLights = GrowLights, LightSettings = LightSettings, DryHooks = DryHooks, Padlock = Padlock}
    end end

    local pJson = CustomSQL('fetchAll', 'SELECT * from `malmo_w_plants`', {})
    if pJson then for k, v in ipairs(pJson) do
        local PlantID = tonumber(k)
        if not PlantID then return end
        local dbId = v.plant
        local coords = json.decode(v.coords)
        local soil = v.soil
        local state = v.state
        local progress = v.progress
        local InsideLab = v.InsideLab
        local health = v.health
        local seed = v.seed
        local label = v.label
        local insects = v.insects == 1 and true or false
        local water = v.water
        local gang = v.gang
        local planterID = v.planterID
        local planterSpot = v.planterSpot
        local CurrentLab = v.CurrentLab
        local wQual, intQual, humQual, lightQual = v.wQual, v.intQual, v.humQual, v.lightQual
        local whitewidow = v.whitewidow
        local waterTime = v.waterTime
        WeedPlants[PlantID] = {coords = vector3(coords.x, coords.y, coords.z), soil = soil, state = state, progress = progress, InsideLab = InsideLab, health = health,
        seed = seed, label = label, insects = insects, water = water, gang = gang, planterID = planterID, planterSpot = planterSpot, CurrentLab = CurrentLab, wQual = wQual,
        intQual = intQual, humQual = humQual, lightQual = lightQual, whitewidow = whitewidow, waterTime = waterTime, dbId = dbId}
        StorePlantsTable(PlantID)
    end end

    -- local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'plants.json'))
    -- for k,v in ipairs(LoadJson) do v.coords = vector3(v.coords['x'], v.coords['y'], v.coords['z']) end
    -- WeedPlants = LoadJson

    local DZjson = CustomSQL('fetchAll', 'SELECT * from `malmo_w_drying_zones`', {})
    if DZjson then DZJson = json.decode(DZJson)
        for _, v in ipairs(DZjson) do
            local Zone = tonumber(v["Zones"])
            if not Zone then return end
            local SpotInfo = {}
            for i = 1, 3 do
                SpotInfo[i] = {}
                SpotInfo[i] = json.decode(v['Rack'..i])
            end
            DryZones[Zone] = {[1] = SpotInfo[1], [2] = SpotInfo[2], [3] = SpotInfo[3]}
        end
    end

    if not DryZones then DryZones = {} end
    for k, _ in ipairs(Config.DryingZones) do if not DryZones[k] then DryZones[k] = {} end
        for i = 1, 3 do if not DryZones[k][i] then DryZones[k][i] = {} end
            for i_ = 1, 3 do if not DryZones[k][i][i_] then DryZones[k][i][i_] = {} end end
        end
    end
    TriggerClientEvent(Config.Foldername..':client:updateDryZones', -1, DryZones)

    for k, v in pairs(GrowLabs) do
        for i = 1, 15 do
            i = tostring(i)
            if not GrowLabs[k].DryHooks[i] then
                GrowLabs[k].DryHooks[i] = {
                    state = 'empty',
                    gang = 'none',
                    time = 0,
                }
            end
        end

        if v.Padlock.gang and os.time() < v.Padlock.time + 259200 then
            local padLockNum = #Padlocks+1
            Padlocks[padLockNum] = {k}
            GrowLabs[k].Padlock.num = padLockNum
            local door = exports['ox_doorlock']:getDoorFromName('Weedlab_'..k)
            exports['ox_doorlock']:setDoorState(door.id, 1)
        else
            local door = exports['ox_doorlock']:getDoorFromName('Weedlab_'..k)
            door['groups'] = nil
            door.locked = false
            exports['ox_doorlock']:editDoor(door.id, door)
            exports['ox_doorlock']:setDoorState(door.id, 0)
        end
    end

    GlobalState['wildPlant:hiker'] =  math.random(3)
    GenerateWildPlant()
end)

function GenerateWildPlant()
    print("Wild Plant Loop Started")
    Wait(math.random(20*60000, 40*60000))
    print("Generating Wild Plant...")
    for k, v in pairs(Config.Seed) do
        local loc = math.random(#v.wildPlants)
        GlobalState['wildPlant:strain'] = k
        GlobalState['wildPlant:coords'] = v.wildPlants[loc]
        GlobalState['wildPlant:time'] = os.time() - (math.random(5,10)*60)
        GlobalState['wildPlant:ripe'] = math.random(10,20)*60
        GlobalState['wildPlant:emailLoc'] = vector3(v.wildPlants[loc].x+math.random(-75, 75), v.wildPlants[loc].y+math.random(-75,75), 64)
        break
    end
    print(
        GlobalState['wildPlant:strain'],
        GlobalState['wildPlant:coords'],
        GlobalState['wildPlant:time'],
        GlobalState['wildPlant:ripe'],
        GlobalState['wildPlant:emailLoc']
    )
    Wait(1000)
    TriggerClientEvent(Config.Foldername..':client:generateWildPlant', -1)

    local str = "Hey! I spotted a Wild Plant while trekking. I sent the approximate GPS location in the attachments if you want to look for it!"
    local emailData = {
        sender = 'Friendly Hiker',
        subject = 'Wild Plant Spotted',
        message = str,
        button = {enabled = true, buttonEvent = 'malmo-weedharvest:client:wildPing'}
    }
    print("Fetching Players")
    local players = QBCore.Functions.GetQBPlayers()

    for _, v in pairs(players) do
        print(v.PlayerData.metadata.wildplantemails)
        if v.PlayerData.metadata.wildplantemails then
        print("Sending Email...", v.PlayerData.citizenid)
        TriggerEvent('qs-smartphone:server:sendNewMailToOffline', v.PlayerData.citizenid, emailData)
    end end

    Wait(60 * 60000)
    print("Removing Wild Plant")
    if GlobalState['wildPlant:strain'] then
        GlobalState['wildPlant:strain'] = nil
        GlobalState['wildPlant:coords'] = nil
        GlobalState['wildPlant:time'] = nil
        GlobalState['wildPlant:ripe'] = nil
        GlobalState['wildPlant:emailLoc'] = nil
        TriggerClientEvent(Config.Foldername..':client:clearWildPlant', -1)
        TriggerClientEvent(Config.Foldername..':client:clearWildPing', -1)
    end
    GenerateWildPlant()
end


RegisterServerEvent(Config.Foldername..':server:toggleWildPlantEmails', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local s, st = 'Perfect, I\'ll be sending you emails when I find some wild cannabis plants!', 'success'
    if Player.PlayerData.metadata['wildplantemails'] then s, st = 'Alright, I won\'t be sending you any more emails regarding wild cannabis plants!', 'error' end

    Player.Functions.SetMetaData('wildplantemails', not Player.PlayerData.metadata['wildplantemails'])
    TriggerClientEvent('QBCore:Notify', src, s, st)
end)

-- Remove Plant from table
local busyPlant = false
RegisterServerEvent(Config.Foldername..':server:takeWildPlant', function()
    local src = source
    if not GlobalState['wildPlant:strain'] or busyPlant then return end
    if os.time() < GlobalState['wildPlant:time'] + GlobalState['wildPlant:ripe'] then TriggerClientEvent('QBCore:Notify', src, "The plant is not ready yet...", 'error') return end
    busyPlant = true
    local strain = GlobalState['wildPlant:strain']
    local Player = QBCore.Functions.GetPlayer(src)
    local seedAmount = math.random(2,3)
    local info = {decay = 2*24*3600}
    local info2 = {purity = math.random(25,35), isWeedPlant = true, small = true}
    if Player.Functions.AddItem(strain, seedAmount, false, info) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[strain], "add", seedAmount)
        GlobalState['wildPlant:strain'], GlobalState['wildPlant:coords'], GlobalState['wildPlant:time'], GlobalState['wildPlant:ripe'] = nil, nil, nil, nil
        busyPlant = false
        TriggerClientEvent(Config.Foldername..':client:clearWildPlant', -1)
        TriggerClientEvent(Config.Foldername..':client:clearWildPing', src)
        if Player.Functions.AddItem(Config.Seed[strain].finalItem, 1, false, info2) then
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Seed[strain].finalItem], "add", 1)
        else TriggerClientEvent('QBCore:Notify', src, "You couldn't carry the plant...", 'error') return end
    else busyPlant = false TriggerClientEvent('QBCore:Notify', src, "You can't carry this!", 'error') return end
end)

-- Info Callback
QBCore.Functions.CreateCallback(Config.Foldername..':server:getPadlocks', function(_, cb) cb(Padlocks) end)
QBCore.Functions.CreateCallback(Config.Foldername..':server:getTables', function(_, cb) cb(WeedPlants) end)
QBCore.Functions.CreateCallback(Config.Foldername..':server:getLabTables', function(_, cb) cb(GrowLabs) end)
QBCore.Functions.CreateCallback(Config.Foldername..':server:getDryZones', function(_, cb) cb(DryZones) end)
QBCore.Functions.CreateCallback(Config.Foldername..':server:getOsTime2', function(_, cb) cb(os.time()) end)

-- New Plant Planted
RegisterServerEvent(Config.Foldername..':server:addWeedPlant', function(loc, soilHash, seed, label, planterID, planterSpot, CurrentLab, WW)
    local Player = QBCore.Functions.GetPlayer(source)
    local item = nil
    local InsideLab = false
    if soilHash == 'InsideLab' then InsideLab = true
    elseif WW then soilHash = 'InsideLab'
    elseif Config.Soil[soilHash].ph == "acidic" then item = Config.Items["acidic_soil_item"]
    elseif Config.Soil[soilHash].ph == "basic" then  item =  Config.Items["alkaline_soil_item"] end

    if Config.Soil[soilHash].ph == "neutral" or Player.Functions.RemoveItem(item, 1) then
        if item then TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "remove") end
        if Player.Functions.RemoveItem(seed, 1) then
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[seed], "remove")
            local gang = Player.PlayerData.gang
            local plantInfo = {}
            plantInfo.coords = loc
            plantInfo.soil = soilHash
            plantInfo.state = Config.Stages[1].state
            plantInfo.progress = 0
            plantInfo.InsideLab = InsideLab
            plantInfo.health = 100
            plantInfo.seed = seed
            plantInfo.label = label
            plantInfo.insects = false
            plantInfo.water = Config.StartingWaterLevel
            plantInfo.gang = gang.name or "none"
            plantInfo.planterID = planterID or nil
            plantInfo.planterSpot = planterSpot or nil
            plantInfo.CurrentLab = CurrentLab or nil
            plantInfo.wQual = 0
            plantInfo.intQual = 0
            plantInfo.humQual = 0
            plantInfo.lightQual = 0
            plantInfo.whitewidow = WW
            plantInfo.waterTime = os.time()-3600
            local id = #WeedPlants + 1
            print('NEW ID : '..id)
            WeedPlants[id] = plantInfo
            --table.insert(WeedPlants, plantInfo)
            StorePlantsTable(id)
            plantInfo.dbId = FetchDBId(id)
            WeedPlants[id] = plantInfo
            TriggerClientEvent(Config.Foldername..':client:addWeedPlant', -1, plantInfo, id)
            if planterSpot and planterID then
                TriggerClientEvent(Config.Foldername..':client:syncPlanterPos', -1, planterID, planterSpot, WW)
            end
        end
    end
end)

-- Remove Plant from table
RegisterServerEvent(Config.Foldername..':server:deleteWeedPlant', function(id, loc, action)
    if WeedPlants[id] then
        if WeedPlants[id].coords==loc then
            RemovePlant(WeedPlants[id].dbId)
            WeedPlants[id] = nil
    TriggerClientEvent(Config.Foldername..':client:deleteWeedPlant', -1, id, action)
        else
            for k,v in pairs(WeedPlants) do
                if v.coords==loc then
                    RemovePlant(WeedPlants[k].dbId)
                    WeedPlants[k] = nil
                    --StorePlantsTable()
                    TriggerClientEvent(Config.Foldername..':client:deleteWeedPlant', -1, k, action)
                    return
                end
            end
        end
    end
end)

RegisterServerEvent(Config.Foldername..":server:removeInsecticide", function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(itemName, 1) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[itemName], "remove")
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have any "..QBCore.Shared.Items[itemName]["label"], "error")
    end
end)

RegisterServerEvent(Config.Foldername..':server:updateWeedPlantInsects', function(id, loc)
    local returnData = {}
    if WeedPlants[id] then
        if WeedPlants[id].coords==loc then
            if WeedPlants[id].insects then WeedPlants[id].insects = false
            else WeedPlants[id].health = WeedPlants[id].health - 10 end
            returnData.insects = WeedPlants[id].insects
            returnData.health = WeedPlants[id].health
            StorePlantsTable(id)
            TriggerClientEvent(Config.Foldername..':client:updatePlantInsects', -1, WeedPlants[id].coords, returnData)
        else
            for k,v in pairs(WeedPlants) do
                if v.coords==loc then
                    if WeedPlants[k].insects then WeedPlants[k].insects = false
                    else WeedPlants[k].health = WeedPlants[k].health - 10 end
                    returnData.insects = WeedPlants[k].insects
                    returnData.health = WeedPlants[k].health
                    StorePlantsTable(k)
                    TriggerClientEvent(Config.Foldername..':client:updatePlantInsects', -1, WeedPlants[k].coords, returnData)
                    return
                end
            end
        end
    end
end)

RegisterServerEvent(Config.Foldername..':server:updateWeedPlantHealth')
AddEventHandler(Config.Foldername..':server:updateWeedPlantHealth', function(id, loc)
    local returnData = {}
    local src = source
    if WeedPlants[id] then
        if WeedPlants[id].coords==loc then
            if WeedPlants[id].progress > 95 then TriggerClientEvent('QBCore:Notify', src, "The plant\'s health won't go higher than it is!", 'error') return end
            WeedPlants[id].health = WeedPlants[id].health + Config.InsecticideEffect
            if WeedPlants[id].health > 100 then WeedPlants[id].health = 100 end
            returnData.health = WeedPlants[id].health
            StorePlantsTable(id)
            TriggerClientEvent(Config.Foldername..':client:updatePlantHealth', -1, WeedPlants[id].coords, returnData)
        else
            for k,v in pairs(WeedPlants) do
                if v.coords==loc then
                    if WeedPlants[k].progress > 95 then TriggerClientEvent('QBCore:Notify', src, "The plant\'s health won't go higher than it is!", 'error') return end
                    WeedPlants[k].health = WeedPlants[k].health + Config.InsecticideEffect
                    if WeedPlants[k].health > 100 then
                        WeedPlants[k].health = 100
                    end
                    returnData.health = WeedPlants[k].health
                    StorePlantsTable(k)
                    TriggerClientEvent(Config.Foldername..':client:updatePlantHealth', -1, WeedPlants[k].coords, returnData)
                    return
                end
            end
        end
    end
end)

RegisterServerEvent(Config.Foldername..':server:updateWeedPlantWater')
AddEventHandler(Config.Foldername..':server:updateWeedPlantWater', function(id, loc, amt)
    local returnData = {}
    if WeedPlants[id] then
        if WeedPlants[id].coords==loc then
            WeedPlants[id].water = WeedPlants[id].water + amt
            local overWater = WeedPlants[id].water - 100
            WeedPlants[id].health = WeedPlants[id].health - overWater
            local waterTime = os.time()
            WeedPlants[id].waterTime = waterTime
            if WeedPlants[id].water > 100 then
                WeedPlants[id].water = 100
            end
            returnData.water = WeedPlants[id].water
            returnData.health = WeedPlants[id].health
            returnData.waterTime = os.time()
            StorePlantsTable(id)
            TriggerClientEvent(Config.Foldername..':client:updatePlantWater', -1, WeedPlants[id].coords, returnData)
            TriggerClientEvent(Config.Foldername..':client:updatePlantHealth', -1, WeedPlants[id].coords, returnData)
        else
            for k,v in pairs(WeedPlants) do
                if v.coords==loc then
                    WeedPlants[k].water = WeedPlants[k].water + amt
                    local overWater = WeedPlants[k].water - 100
                    WeedPlants[k].health = WeedPlants[k].health - overWater
                    local waterTime = os.time()
                    WeedPlants[k].waterTime = waterTime
                    if WeedPlants[k].water > 100 then
                        WeedPlants[k].water = 100
                    end
                    returnData.water = WeedPlants[k].water
                    returnData.health = WeedPlants[k].health
                    returnData.waterTime = os.time()

                    StorePlantsTable(k)
                    TriggerClientEvent(Config.Foldername..':client:updatePlantWater', -1, WeedPlants[k].coords, returnData)
                    TriggerClientEvent(Config.Foldername..':client:updatePlantHealth', -1, WeedPlants[k].coords, returnData)

                    return
                end
            end
        end
    end
end)

RegisterServerEvent(Config.Foldername..':server:fillWateringCan')
AddEventHandler(Config.Foldername..':server:fillWateringCan', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.PlayerData.items[item.slot].name == 'wateringcan'then return end
    if not Player.PlayerData.items[item.slot].info or Player.PlayerData.items[item.slot].info == '' then Player.PlayerData.items[item.slot].info = {} end
    Player.PlayerData.items[item.slot].info.uses = 50
    Player.Functions.SetInventory(Player.PlayerData.items)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['wateringcan'], "add")
end)

RegisterServerEvent(Config.Foldername..':server:SetupHumidity')
AddEventHandler(Config.Foldername..':server:SetupHumidity', function(lab, humidity)
    if not GrowLabs[lab] then GrowLabs[lab] = {} end
    GrowLabs[lab].Humidity = humidity
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
end)

RegisterServerEvent(Config.Foldername..':server:InstallGrowLight')
AddEventHandler(Config.Foldername..':server:InstallGrowLight', function(lab, loc, state)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not GrowLabs[lab] then GrowLabs[lab] = {} end
    local GrowLights = GrowLabs[lab].GrowLights or {}
    if state then if not Player.Functions.RemoveItem('weedgrowlight', 1) then return
    else TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['weedgrowlight'], "remove", 1) end
    else
        if math.random(10) == 1 then TriggerClientEvent('QBCore:Notify', src, "The light breaks down when you take it from the wall..", 'error') else
        if Player.Functions.AddItem('weedgrowlight', 1) then TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['weedgrowlight'], "add", 1)
        else TriggerClientEvent('QBCore:Notify', src, "You can\'t carry the light.", 'error') return end end
    end
    GrowLights[loc] = state
    GrowLabs[lab].GrowLights = GrowLights
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
    if state then TriggerClientEvent(Config.Foldername..':client:SyncGrowLight', -1, lab, loc)
    else TriggerClientEvent(Config.Foldername..':client:deleteGrowLight', -1, lab, loc) end
end)

RegisterServerEvent(Config.Foldername..':server:FillVatWater')
AddEventHandler(Config.Foldername..':server:FillVatWater', function(lab)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Player.Functions.GetItemByName('wateringcan')
    local itemInfo =  Player.PlayerData.items[item.slot].info
    if itemInfo == "" or not itemInfo.uses then itemInfo.uses = 0 end
    if Player.PlayerData.items[item.slot].info.uses < 50 then TriggerClientEvent('QBCore:Notify', src, "Your watering can needs to be full...") return end
    Player.PlayerData.items[item.slot].info.uses = 0
    Player.Functions.SetInventory(Player.PlayerData.items)
    if not GrowLabs[lab] then GrowLabs[lab] = {} end
    local WaterSettings = {
        waterLvl = 30,
        acid = 0,
        alka = 0,
        fert = 0,
    }
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['wateringcan'], "remove")
    GrowLabs[lab].WaterSettings = WaterSettings
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
end)

RegisterServerEvent(Config.Foldername..':server:DestroyPlant_rack')
AddEventHandler(Config.Foldername..':server:DestroyPlant_rack', function(zone, rack, pos)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name ~= 'police' then return end
    DryZones[zone][rack][pos] = {
        time = os.time(),
        state = 'empty',
        strain = nil,
        purity = nil,
        owner = nil
    }
    StoreRacksData(zone)
    TriggerClientEvent(Config.Foldername..':client:updateDryZones', -1, DryZones)
    TriggerClientEvent(Config.Foldername..':client:syncPlantRack', -1, false, zone, rack, pos)
end)

RegisterServerEvent(Config.Foldername..':server:PlaceDryPlant_rack')
AddEventHandler(Config.Foldername..':server:PlaceDryPlant_rack', function(zone, rack, pos, state, strain)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plant = Player.Functions.GetItemByName(Config.Seed[strain].finalItem)
    if not plant then TriggerClientEvent('QBCore:Notify', src, "Something went wrong!", 'error') return end
    local purity = Player.PlayerData.items[plant.slot].info.purity
    local small = Player.PlayerData.items[plant.slot].info.small or false
    if not Player.Functions.RemoveItem(Config.Seed[strain].finalItem, 1, plant.slot) then
        TriggerClientEvent('QBCore:Notify', src, "Something went wrong!", 'error') return end
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Seed[strain].finalItem], "remove")
    if state == "hooked" then
        DryZones[zone][rack][pos] = {
            time = os.time(),
            state = 'hooked',
            strain = strain,
            purity = purity,
            owner = Player.PlayerData.citizenid,
            small = small
        }
    end
    StoreRacksData(zone)
    TriggerClientEvent(Config.Foldername..':client:updateDryZones', -1, DryZones)
    TriggerClientEvent(Config.Foldername..':client:syncPlantRack', -1, true, zone, rack, pos)
end)

RegisterServerEvent(Config.Foldername..':server:TakeDryPlant_rack')
AddEventHandler(Config.Foldername..':server:TakeDryPlant_rack', function(zone, rack, pos)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    -- print(zone, rack, pos)
    local Hook = DryZones[zone][rack][pos]
    if os.time() >= Hook.time+21600 then
        if not Player.Functions.AddItem('malmo_dry_weed', 1, false,
            {strain = Hook.strain, purity = Hook.purity, isWeedPlant = true, dry = true, strainlbl = Config.Seed[Hook.strain].label, small = Hook.small})
        then TriggerClientEvent('QBCore:Notify', src, "You cant carry this!", 'error') return end
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['malmo_dry_weed'], "add")
        DryZones[zone][rack][pos] = {time = os.time(), state = 'empty', strain = nil, purity = nil, small = false }
        StoreRacksData(zone)
        TriggerClientEvent(Config.Foldername..':client:updateDryZones', -1, DryZones)
        TriggerClientEvent(Config.Foldername..':client:syncPlantRack', -1, false, zone, rack, pos)
    else TriggerClientEvent('QBCore:Notify', src, "The plant is not ready yet!", 'error') return end
end)

RegisterServerEvent(Config.Foldername..':server:PlaceDryPlant')
AddEventHandler(Config.Foldername..':server:PlaceDryPlant', function(lab, hook, state, strain)
    local src = source
    if not GrowLabs[lab] then GrowLabs[lab] = {} end
    if not GrowLabs[lab].DryHooks then GrowLabs[lab].DryHooks = {} end
    if not GrowLabs[lab].DryHooks[hook] then GrowLabs[lab].DryHooks[hook] = {} end
    local Player = QBCore.Functions.GetPlayer(src)
    local plant = Player.Functions.GetItemByName(Config.Seed[strain].finalItem)
    if not plant then TriggerClientEvent('QBCore:Notify', src, "Something went wrong!", 'error') return end
    local purity = Player.PlayerData.items[plant.slot].info.purity
    local small = Player.PlayerData.items[plant.slot].info.small or false
    if not Player.Functions.RemoveItem(Config.Seed[strain].finalItem, 1, plant.slot) then
        TriggerClientEvent('QBCore:Notify', src, "Something went wrong!", 'error') return end
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[Config.Seed[strain].finalItem], "remove")
    if state == "hooked" then
        GrowLabs[lab].DryHooks[hook] = {
            time = os.time(),
            state = 'hooked',
            strain = strain,
            purity = purity,
            gang = Player.PlayerData.gang.name,
            small = small
        }
    end
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
end)

RegisterServerEvent(Config.Foldername..':server:TakeDryPlant')
AddEventHandler(Config.Foldername..':server:TakeDryPlant', function(lab, hook)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Hook = GrowLabs[lab].DryHooks[hook]
    if os.time() >= Hook.time+60 then
        if not Player.Functions.AddItem('malmo_dry_weed', 1, false,
            {strain = Hook.strain, purity = Hook.purity, isWeedPlant = true, dry = true, strainlbl = Config.Seed[Hook.strain].label, small = Hook.small})
        then TriggerClientEvent('QBCore:Notify', src, "You cant carry this!", 'error') return end
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['malmo_dry_weed'], "add")
        GrowLabs[lab].DryHooks[hook] = {time = os.time(), state = 'empty', strain = nil, purity = nil, small = false}
        StoreLabsData(lab)
        TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
    else TriggerClientEvent('QBCore:Notify', src, "The plant is not ready yet!", 'error') return end
end)

RegisterServerEvent(Config.Foldername..':server:TrimWeed', function(amount, slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.PlayerData.items[slot]
    local remItem = amount == 28.0 and "empty_weed_jar" or "emptybaggy"
    local remAmount = amount == 224.0 and 1 or amount == 112.0 and 2 or amount == 28.0 and 8 or amount == 7.0 and 32 or amount == 3.5 and 64.
    local recItem = amount == 224.0 and "malmo_weed_brick" or amount == 112.0 and "malmo_weed_qp" or
                    amount == 28.0 and "malmo_weed_oz" or amount == 7.0 and 'malmo_weed_7g' or amount == 3.5 and 'malmo_weed_35g'

    local ranSeedAm = 1
    local ranSeed = math.random(100)
    if ranSeed > 90 then ranSeedAm = 2
    elseif ranSeed < 20 then ranSeedAm = 0 end
    if item.info.small then remAmount = remAmount / 2 ranSeedAm = 0  end

    if not remItem and Player.Functions.RemoveItem('malmo_dry_weed', 1, slot) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['malmo_dry_weed'], "remove")
        local info = {strain = item.info.strain, purity = item.info.purity, isWeedPlant = true, dry = true, strainlbl = Config.Seed[item.info.strain].label}
        Player.Functions.AddItem(recItem, remAmount, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[recItem], "add", remAmount)
        if ranSeedAm > 0 then
            local i = {decay = 2*24*3600}
            Player.Functions.AddItem(item.info.strain, ranSeedAm, false, i)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item.info.strain], "add", ranSeedAm)
        end
    return end

    local container = Player.Functions.GetItemByName(remItem)
    if container.amount < remAmount then TriggerClientEvent('QBCore:Notify', src, "You don't have enough items to do this!", 'error') return end
    if Player.Functions.RemoveItem('malmo_dry_weed', 1, slot) and Player.Functions.RemoveItem(remItem, remAmount) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['malmo_dry_weed'], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[remItem], "remove", remAmount)
        local info = {strain = item.info.strain, purity = item.info.purity, isWeedPlant = true, dry = true, strainlbl = Config.Seed[item.info.strain].label}
        Player.Functions.AddItem(recItem, remAmount, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[recItem], "add", remAmount)
        if ranSeedAm > 0 then
            local i = {decay = 2*24*3600}
            Player.Functions.AddItem(item.info.strain, ranSeedAm, false, i)
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item.info.strain], "add", ranSeedAm)
        end
    else TriggerClientEvent('QBCore:Notify', src, "Something went wrong...", 'error') return end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Seed) do
        QBCore.Functions.CreateUseableItem(k, function(source, item)
            local source = source
            local Player = QBCore.Functions.GetPlayer(source)
            if item.info.fromWW then TriggerClientEvent('QBCore:Notify', source, "You can only plant these at White Widow...", 'error') return end
            if Player.PlayerData.metadata["farmingrep"] >= v.rep then
                TriggerClientEvent(Config.Foldername..':client:placeWeedPlant', source, k, v.label)
            else
                ShowNotification(source, Config.Locale["need_reputation"], "error")
            end
        end)
    end

    QBCore.Functions.CreateUseableItem('wateringcan', function(source, item)
        local source = source
        local Player = QBCore.Functions.GetPlayer(source)
        TriggerClientEvent(Config.Foldername..':client:fillWateringCan', source, item)
    end)
end)

QBCore.Commands.Add("farmrep", "Check your reputation", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local fishing = Player.PlayerData.metadata["farmingrep"]
    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, "Farming reputation is "..fishing)
end)

QBCore.Commands.Add("illfarm", "Check your reputation", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local fishing = Player.PlayerData.metadata["illegalfarming"]
    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, "Illegal Farming reputation is "..fishing)
end)

local function processWaterQuality(Lab, gangRecipe)
    local labSettings = Lab and Lab.WaterSettings or nil
    if not labSettings or not gangRecipe then return 0, 0 end
    local water = labSettings['waterLvl'] - 1
    if water <= 0 then water = 0 return 0, 0 end
    local acid = 10-math.abs(labSettings['acid'] - tonumber(string.sub(tostring(gangRecipe), 1, 1)))
    local alka = 10-math.abs(labSettings['alka'] - tonumber(string.sub(tostring(gangRecipe), 2, 2)))
    local fert = 10-math.abs(labSettings['fert'] - tonumber(string.sub(tostring(gangRecipe), 3, 3)))
    return acid + alka + fert, water
end

local function processIntensityQuality(Lab, gangRecipe)
    local Intensity = Lab and Lab.LightSettings and Lab.LightSettings.Intensity or nil
    if not Intensity or not gangRecipe then return 0 end
    gangRecipe = tonumber(string.sub(tostring(gangRecipe), 4, 5))
    local int = 100-math.abs(Intensity - gangRecipe)
    return int
end

local function processHumidityQuality(Lab, Recipe)
    local Humidity = Lab and Lab.Humidity or nil
    if not Humidity or not Recipe then return 0 end
    local int = 100-math.abs(Humidity - Recipe)
    return int
end

local function processLightAmountQuality(Lab, gangRecipe)
    local Lights = Lab and Lab.GrowLights or nil
    if not Lights or not gangRecipe then return 0 end
    gangRecipe = tonumber(string.sub(tostring(gangRecipe), 6, #tostring(gangRecipe)))
    local qual = 0
    for i = 1, 10 do
       local digit = tonumber(string.sub(tostring(gangRecipe), i, i))
       if ((digit % 2 == 0) and Lights[i]) or (not (digit % 2 == 0) and not Lights[i]) then qual = qual + 1 else end
    end
    return qual
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        local returnData = {}
        local returnLabData = {}
        if WeedPlants then
            for k,v in pairs(WeedPlants) do
                local data1 = {}

                if v.insects then
                    v.health = v.health - 1
                    if v.health < 0 then v.health = 0 end
                elseif v.soil ~= 'InsideLab' and math.random(1,100) <= Config.InfectionProbability then v.insects = true end

                local waterSettings = v.CurrentLab and GrowLabs[v.CurrentLab].WaterSettings or { waterLvl = 0, acid = 0, alka = 0, fert = 0,}
                -- If dead, destroy then skip everything else
                if v.health <= 0 then
                    RemovePlant(WeedPlants[k].dbId) WeedPlants[k] = nil TriggerClientEvent(Config.Foldername..':client:deleteWeedPlant', -1, k, "plant-dead")
                goto skip end

                if v.InsideLab == 1 and waterSettings and waterSettings.waterLvl > 0 then
                    v.water = 100
                elseif os.time() > v.waterTime+3600 then
                    v.water = v.water - 1
                    if v.water < 0 then v.water = 0 end
                end

                if v.water <= 60 then
                    v.health = v.health - Config.WaterEffect
                    if v.health < 0 then v.health = 0 end
                end

                data1.health = v.health
                data1.insects = v.insects

                v.progress = v.progress + Config.ProgressPerCycle * (Config.Soil[v.soil].fertility)
                if v.progress > 100 then v.progress = 100 v.state = Config.HarvestingState end
                if v.state == Config.HarvestingState then goto save end

                for a, b in pairs(Config.Stages) do
                    if v.progress>=b.min and v.progress<=b.max then
                        local oldState = v.state
                        v.state = b.state
                        if oldState == v.state then goto save end
                        if not v.whitewidow and v.CurrentLab and v.gang ~= "none" and QBCore.Shared.Gangs[v.gang].Weed then
                            -- Water
                            local wQual, waterLvl = processWaterQuality(GrowLabs[v.CurrentLab], QBCore.Shared.Gangs[v.gang].Weed)
                            if GrowLabs[v.CurrentLab].WaterSettings then GrowLabs[v.CurrentLab].WaterSettings.waterLvl = waterLvl end
                            v.wQual = v.wQual + wQual
                            -- Light Intensity
                            local intQual = processIntensityQuality(GrowLabs[v.CurrentLab], QBCore.Shared.Gangs[v.gang].Weed)
                            v.intQual = v.intQual + intQual
                            -- Humidity
                            local humQual = processHumidityQuality(GrowLabs[v.CurrentLab], Config.Seed[v.seed].h)
                            v.humQual = v.humQual + humQual
                            -- Light Amount
                            local lightQual = processLightAmountQuality(GrowLabs[v.CurrentLab], QBCore.Shared.Gangs[v.gang].Weed)
                            v.lightQual = v.lightQual + lightQual
                        end
                    end
                end

                ::save::
                data1.progress = v.progress
                data1.state = v.state
                data1.water = v.water
                data1.insects = v.insects
                data1.wQual = v.wQual
                data1.intQual = v.intQual
                data1.humQual = v.humQual
                data1.lightQual = v.lightQual
                returnData[k] = data1
                --table.insert(returnData, data1)
                ::skip::
                StorePlantsTable(k)
            end
            for k, v in pairs(GrowLabs) do
                if v.WaterSettings and v.WaterSettings.waterLvl <= 0 then
                    GrowLabs[k].WaterSettings = { waterLvl = 0, acid = 0, alka = 0, fert = 0 }
                end
                StoreLabsData(k)
            end
            --StorePlantsTable()
            TriggerClientEvent(Config.Foldername..':client:updatePlantStatus', -1, returnData)
            TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
        end
        Citizen.Wait(60000*Config.CycleTime)
    end
end)

QBCore.Functions.CreateCallback(Config.Foldername..':server:getOsTime', function(source, cb, lab)
    local timeCB = 1
    if not GrowLabs[lab] and lab then GrowLabs[lab] = {} end
    if not GrowLabs[lab] or not GrowLabs[lab].LightSettings or GrowLabs[lab].LightSettings.Time == 0 then timeCB = 1
    else timeCB = os.difftime(os.time(), GrowLabs[lab].LightSettings.Time + 12*60*60) end
    cb(timeCB)
end)

RegisterServerEvent(Config.Foldername..':server:hitTheBong', function(slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.PlayerData.items[slot]
    Player.Functions.RemoveItem(item.name, 1, slot)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item.name], "remove", 1)
end)


RegisterServerEvent(Config.Foldername..':server:SetupLightInt')
AddEventHandler(Config.Foldername..':server:SetupLightInt', function(lab, intensity)
    if not GrowLabs[lab] and lab then GrowLabs[lab] = {} end
    if not lab then return end
    lab = tonumber(lab)
    local LightSettings = GrowLabs[lab].LightSettings or {}
    LightSettings.Intensity = intensity
    LightSettings.Time = os.time()
    GrowLabs[lab].LightSettings = LightSettings
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
end)

RegisterServerEvent(Config.Foldername..':server:SetupVat')
AddEventHandler(Config.Foldername..':server:SetupVat', function(lab, acid, alka, fert)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not GrowLabs[lab] and lab then GrowLabs[lab] = {} end
    if not lab then return end
    lab = tonumber(lab)
    local WaterSetting = GrowLabs[lab].WaterSettings
    local remItems = {}

    if acid > 0 and WaterSetting.acid - acid < 0 then
        local diff = math.abs(WaterSetting.acid - acid)
        if Player.Functions.GetItemByName('acid_bottle').amount >= diff then remItems[#remItems+1] = {i = 'acid_bottle', a = diff}
        else TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough Acid!', 'error') return end
    elseif acid ~= WaterSetting.acid then TriggerClientEvent('QBCore:Notify', src, 'You drain some of the Acid.', 'success') end

    if alka > 0 and WaterSetting.alka - alka < 0 then
        local diff = math.abs(WaterSetting.alka - alka)
        if Player.Functions.GetItemByName('alkaline_bottle').amount >= diff then remItems[#remItems+1] = {i = 'alkaline_bottle', a = diff}
        else TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough Alkaline Solution!', 'error') return end
    elseif alka ~= WaterSetting.alka then TriggerClientEvent('QBCore:Notify', src, 'You drain some of the Alkaline Solution!.', 'success') end

    if fert > 0 and WaterSetting.fert - fert < 0 then
        local diff = math.abs(WaterSetting.acid - fert)
        if Player.Functions.GetItemByName('weed_nutrition').amount >= diff then remItems[#remItems+1] = {i = 'weed_nutrition', a = diff}
        else TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough Fertilizer!', 'error') return end
    elseif fert ~= WaterSetting.fert then TriggerClientEvent('QBCore:Notify', src, 'You drain some of the Fertilizer.', 'success') end

    if #remItems > 0 then
        for _,v in pairs(remItems) do
            Player.Functions.RemoveItem(v.i, v.a)
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[v.i], "remove", v.a)
        end
    end
    WaterSetting.acid = acid
    WaterSetting.alka = alka
    WaterSetting.fert = fert
    GrowLabs[lab].WaterSettings = WaterSetting
    StoreLabsData(lab)
    TriggerClientEvent(Config.Foldername..':client:updateLabsData', -1, GrowLabs)
end)

function ShowNotification(source, msg, type)
    if Config.QBCoreNotify then
        TriggerClientEvent(Config.Core..':Notify', source, msg, type)
    elseif Config.okokNotify then
        TriggerClientEvent('okokNotify:Alert', source, Config.OkOkNotifyTitle, msg, 5000, type)
    elseif Config.pNotify then
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = msg,
            type = type,
            timeout = 10000,
            layout = Config.pNotifyLayout
        })
    end
end

QBCore.Functions.CreateCallback(Config.Foldername..":server:hasItem", function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local retval = false
    if Player.Functions.GetItemByName(item) ~= nil then
        retval = true
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback(Config.Foldername..":server:hasWateringCan", function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local retval = false
    local can = Player.Functions.GetItemByName('wateringcan')
    if not can then cb(false) return end
    cb(Player.PlayerData.items[can.slot].info and Player.PlayerData.items[can.slot].info.uses > 0 or false)
end)

RegisterServerEvent(Config.Foldername..":server:removeItem", function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(itemName, 1) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[itemName], "remove")
    else
        ShowNotification(src, "You don't have any "..QBCore.Shared.Items[itemName]["label"], "error")
    end
end)

RegisterServerEvent(Config.Foldername..":server:removeWateringcanUse", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local can = Player.Functions.GetItemByName('wateringcan')
    Player.PlayerData.items[can.slot].info.uses = Player.PlayerData.items[can.slot].info.uses - 1
    Player.Functions.SetInventory(Player.PlayerData.items)
end)

RegisterServerEvent(Config.Foldername..':server:harvestWeed')
AddEventHandler(Config.Foldername..':server:harvestWeed', function(id, loc)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if WeedPlants[id] and WeedPlants[id].coords==loc then
        local hpur = WeedPlants[id].health/2

        local humpur = (WeedPlants[id].humQual/400) * (50/4)
        local wpur = (WeedPlants[id].wQual/120) * (50/4)
        local intpur = (WeedPlants[id].intQual/400) * (50/4)
        local lightpur = (WeedPlants[id].lightQual/40) * (50/4)

        local purity = hpur + humpur + math.floor(humpur+wpur+intpur+lightpur)
        if WeedPlants[id].whitewidow then purity = hpur + 25 end
        local info = {
            isWeedPlant = true,
            purity = purity,
            small = false,
            gang = WeedPlants[id].gang
        }
        local item = Config.Seed[WeedPlants[id].seed].finalItem
        if Player.Functions.AddItem(item, 1, false, info) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "add")

            if WeedPlants[id].gang ~= "none" and not WeedPlants[id].whitewidow and WeedPlants[id].InsideLab then
                local gInfo = exports['av_gangs']:getGang(src)
                if gInfo then
                    TriggerEvent('av_gangs:addXP', gInfo.name, 0.5)
                    TriggerClientEvent('QBCore:Notify', src, "You get some gang reputation from doing this...", 'success')
                end
            end
            RemovePlant(WeedPlants[id].dbId)
            WeedPlants[id] = nil

            TriggerClientEvent(Config.Foldername..':client:deleteWeedPlant', -1, id, "harvested")
            Player.Functions.SetMetaData("illegalfarming", Player.PlayerData.metadata["illegalfarming"] + Config.RepGiven)
        else ShowNotification(src, Config.Locale["inventory_full_error"], "error") end
    else
        for id,data in pairs(WeedPlants) do
            if data.coords==loc then
                local hpur = WeedPlants[id].health/2

                local humpur = (WeedPlants[id].humQual/400) * (50/4)
                local wpur = (WeedPlants[id].wQual/120) * (50/4)
                local intpur = (WeedPlants[id].intQual/400) * (50/4)
                local lightpur = (WeedPlants[id].lightQual/40) * (50/4)

                local purity = hpur + humpur + math.floor(humpur+wpur+intpur+lightpur)
                local info = {
                    isWeedPlant = true,
                    purity = purity,
                    small = false,
                    gang = WeedPlants[id].gang
                }
                if Player.Functions.AddItem(Config.Seed[WeedPlants[id].seed].finalItem, 1, false, info) then

                    if WeedPlants[id].gang ~= "none" and not WeedPlants[id].whitewidow and WeedPlants[id].InsideLab then
                        local gInfo = exports['av_gangs']:getGang(src)
                        if gInfo then
                            TriggerEvent('av_gangs:addXP', gInfo.name, 0.5)
                            TriggerClientEvent('QBCore:Notify', src, "You get some gang reputation from doing this...", 'success')
                        end
                    end
                    RemovePlant(WeedPlants[id].dbId)
                    WeedPlants[id] = nil

                    TriggerClientEvent(Config.Foldername..':client:deleteWeedPlant', -1, id, "harvested")
                    Player.Functions.SetMetaData("illegalfarming", Player.PlayerData.metadata["illegalfarming"] + Config.RepGiven)
                else ShowNotification(src, Config.Locale["inventory_full_error"], "error") end
            end
        end
    end
end)

QBCore.Functions.CreateUseableItem("bong", function(source, item)
    TriggerClientEvent(Config.Foldername..':client:HitTheBong', source)
end)

RegisterServerEvent(Config.Foldername..':server:grindWeed', function(slot, a, i, preroll)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local papers = Player.Functions.GetItemByName('rollingpapers')
    local weed = Player.PlayerData.items[slot]
    local itemName = Config.Seed[weed.info.strain].jointItem
    --local pack = Player.Functions.GetItemByName('emptyprerollpack')
    if preroll then a = 1 itemName = 'prerollpack' if not Player.Functions.RemoveItem('emptyprerollpack', 1) then return end TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['emptyprerollpack'], "remove", 1) end
    if weed.name ~= i or papers.amount < a then return end
    if Player.Functions.RemoveItem('rollingpapers', a) and Player.Functions.RemoveItem(weed.name, 1, weed.slot) and Player.Functions.AddItem(itemName, a, false, {purity = weed.info.purity, isWeedPlant = true, strainlbl = preroll and weed.info.strainlbl or nil, dry = preroll or nil, strain = weed.info.strain, amountLeft = preroll and 8}) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['rollingpapers'], "remove", a)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[weed.name], "remove", 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[itemName], "add", a)
    else if preroll then Player.Functions.AddItem('emptyprerollpack') end end
end)

QBCore.Functions.CreateUseableItem("prerollpack", function(source, item)
    TriggerClientEvent(Config.Foldername..':client:UsePrerollPack', source, item)
end)

RegisterServerEvent('consumables:server:RemovePrerollPackUse', function(itemData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemGive = Config.Seed[itemData.info.strain].jointItem
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[itemGive], "add")
    if Player.PlayerData.items[itemData.slot].info.amountLeft == nil then
        Player.Functions.AddItem(itemGive, 1, false, itemData.info)
        Player.PlayerData.items[itemData.slot].info.amountLeft = 8
    elseif Player.PlayerData.items[itemData.slot].info.amountLeft == 1 then
        Player.Functions.AddItem(itemGive, 1, false, itemData.info)
        Wait(500)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemData.name], 'remove')
        Player.Functions.RemoveItem(itemData.name, 1)
    else
        Player.PlayerData.items[itemData.slot].info.amountLeft = Player.PlayerData.items[itemData.slot].info.amountLeft - 1
        Player.Functions.SetInventory(Player.PlayerData.items)
        Player.Functions.AddItem(itemGive, 1, false, itemData.info)
    end
end)

RegisterServerEvent('malmo-weedharvest:server:exchangeSeeds', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local e = false
    for k, v in pairs(Config.Seed) do
        local seeds = Player.Functions.GetItemsByName(v.oldName)
        local am = 0
        for _, v_ in pairs(seeds) do
            e = true
            am = am + v_.amount
            Player.Functions.RemoveItem(v.oldName, v_.amount, v_.slot)
        end
        if am ~= 0 then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.oldName], 'removed', am)
            am = math.floor(am/10)
            Player.Functions.AddItem(k, am, false, {decay = 2*24*3600})
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[k], 'add', am)
        end
    end
    if not e then ShowNotification(src, "You don't have any seeds to exchange!", "error") end
end)

RegisterServerEvent('malmo-weedharvest:server:exchangeBuds', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local e = false
    for k, v in pairs(Config.Seed) do
        local seeds = Player.Functions.GetItemsByName(v.oldBud)
        local am = 0
        for _, v_ in pairs(seeds) do
            e = true
            am = am + v_.amount
            Player.Functions.RemoveItem(v.oldBud, v_.amount, v_.slot)
        end
        if am ~= 0 then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.oldBud], 'removed', am)
            am = math.floor(am/15)
            local info = {strain = k, purity = 20, isWeedPlant = true, dry = true, strainlbl = Config.Seed[k].label}
            Player.Functions.AddItem("malmo_weed_35g", am, false, info)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["malmo_weed_35g"], 'add', am)
        end
    end
    if not e then ShowNotification(src, "You don't have any buds to exchange!", "error") end
end)

--function StorePlantsTable() SaveResourceFile(GetCurrentResourceName(), "plants.json", json.encode(WeedPlants), -1) end
function StorePlantsTable(id)
    local p = WeedPlants[id]
    if not WeedPlants[id] then print("Plant "..(id or 'nil').." doesnt exist anymore") return end
    local dbId = p.dbId
    local dbId_key = dbId and '?, ' or ''
    local dbId_SQL = dbId and 'plant, ' or ''
    local dbID_SQL2 = dbId and ' ON DUPLICATE KEY UPDATE coords = ?, soil = ?, state = ?, progress = ?, InsideLab = ?, health = ?, seed = ?, label = ?, insects = ?,' ..
    ' water = ?, gang = ?, planterID = ?, planterSpot = ?, CurrentLab = ?, wQual = ?, intQual = ?, humQual = ?, lightQual = ?, whitewidow = ?, waterTime = ?, liveId = ?;' or ''
    local c, so, st, pr, iL, h, se, l, i = json.encode(p.coords), tostring(p.soil), p.state, p.progress, p.InsideLab, p.health, p.seed, p.label, p.insects
    local w, g, pId, pSpot, cL, wQ, iQ, hQ = p.water, p.gang, p.planterID, p.planterSpot, p.CurrentLab, p.wQual, p.intQual, p.humQual
    local lQ, ww, wt = p.lightQual, p.whitewidow, p.waterTime or os.time() - 3600
    if h > 100 then h = 100 end
    local dbId_val = dbId and {dbId, c, so, st, pr, iL, h, se, l, i, w, g, pId, pSpot, cL, wQ, iQ, hQ, lQ, ww, wt, id, c, so, st, pr, iL, h, se, l, i, w, g, pId, pSpot, cL, wQ, iQ, hQ, lQ, ww, wt, id}
                    or {c, so, st, pr, iL, h, se, l, i, w, g, pId, pSpot, cL, wQ, iQ, hQ, lQ, ww, wt, id}
    CustomSQL('execute', 'INSERT INTO malmo_w_plants ('..dbId_SQL..'coords, soil, state, progress, InsideLab, health, seed, label, insects,' ..
                        ' water, gang, planterID, planterSpot, CurrentLab, wQual, intQual, humQual, lightQual, whitewidow, waterTime, liveId)' ..
                        ' VALUES ('..dbId_key..'?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)' .. dbID_SQL2,
                        dbId_val)
    -- SaveResourceFile(GetCurrentResourceName(), "growlabs.json", json.encode(GrowLabs), -1)
end

function RemovePlant(id) print("Removing Plant "..id) CustomSQL('execute', 'DELETE FROM malmo_w_plants WHERE plant = ?', {tonumber(id)}) end
function FetchDBId(id)
    Wait(1000)
    local response = MySQL.prepare.await('SELECT `plant` FROM `malmo_w_plants` WHERE `liveId` = ?', {id})
    --local json = CustomSQL('fetchAll', 'SELECT * from `malmo_w_plants` WHERE liveId = ?`', {id})
    return response --tonumber(json.plant)
end

function StoreLabsData(lab)
    local cLab = GrowLabs[lab]
    local h, w, g, l, d, p = cLab.Humidity, json.encode(cLab.WaterSettings), json.encode(cLab.GrowLights), json.encode(cLab.LightSettings), json.encode(cLab.DryHooks), json.encode(cLab.Padlock)
    CustomSQL('execute', 'INSERT INTO malmo_w_labs (Lab, Humidity, WaterSettings, GrowLights, LightSettings, DryHooks, Padlock) VALUES (?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE Humidity = ?, WaterSettings = ?, GrowLights = ?, LightSettings = ?, DryHooks = ?, Padlock = ?;',
    {lab, h, w, g, l, d, p, h, w, g, l, d, p})
    --SaveResourceFile(GetCurrentResourceName(), "growlabs.json", json.encode(GrowLabs), -1)
end

function StoreRacksData(zone)
    local Rack1, Rack2, Rack3 = json.encode(DryZones[zone][1]), json.encode(DryZones[zone][2]), json.encode(DryZones[zone][3])
    CustomSQL('execute', 'INSERT INTO malmo_w_drying_zones (Zones, Rack1, Rack2, Rack3) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE Rack1 = ?, Rack2 = ?, Rack3 = ?;', {zone, Rack1, Rack2, Rack3, Rack1, Rack2, Rack3})
end

--- Custom SQL
function CustomSQL(type, query, var)
    if type == 'execute' then
        exports.oxmysql:execute(query, var)
    end
    if type == 'fetchAll' then
        local result = exports.oxmysql:fetchSync(query, var)
        return result
    end
end

QBCore.Functions.CreateUseableItem('padlock', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('padlock') then
        for k, v in pairs(Config.GrowLabs) do
            if #(GetEntityCoords(GetPlayerPed(src)) - v.p.xyz) < 2.0 then
                if GrowLabs[k].Padlock.gang then TriggerClientEvent('QBCore:Notify', src, 'There\'s already a padlock installed on this door!', 'error') return end
                local padlockNum = #Padlocks + 1
                GrowLabs[k].Padlock.gang = Player.PlayerData.gang.name
                GrowLabs[k].Padlock.time = os.time()
                GrowLabs[k].Padlock.num = padlockNum
                Padlocks[padlockNum] = {k}
                StoreLabsData(k)
                Player.Functions.RemoveItem('padlock', 1)
                local door = exports['ox_doorlock']:getDoorFromName('Weedlab_'..k)
                door['groups'] = {[Player.PlayerData.gang.name] = 0}
                door.locked = true
                exports['ox_doorlock']:editDoor(door.id, door)
                exports['ox_doorlock']:setDoorState(door.id, 1)
                TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['padlock'], "remove", 1)
                TriggerClientEvent('malmo-weedharvest:client:installPadlock', source, k)
                TriggerClientEvent('malmo-weedharvest:client:syncPadlocks', -1, Padlocks, GrowLabs, k)
                break
            end
        end
    end
end)

QBCore.Functions.CreateUseableItem('grinder', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('grinder') then
        TriggerClientEvent('malmo-weedharvest:client:grindWeed', source)
    end
end)

RegisterServerEvent(Config.Foldername..':server:brokenLock', function(lab)
    local src = source
    if not GrowLabs[lab].Padlock.gang then return end
    GrowLabs[lab].Padlock.gang = nil
    GrowLabs[lab].Padlock.time = nil
    Padlocks[GrowLabs[lab].Padlock.num] = nil
    GrowLabs[lab].Padlock.num = nil
    local door = exports['ox_doorlock']:getDoorFromName('Weedlab_'..lab)
    door['groups'] = {}
    door.locked = false
    exports['ox_doorlock']:editDoor(door.id, door)
    exports['ox_doorlock']:setDoorState(door.id, 0)
    StoreLabsData(lab)
    TriggerClientEvent('malmo-weedharvest:client:removeSyncedPadlock', -1, lab, GrowLabs)
end)

QBCore.Functions.CreateCallback('malmo-weedharvest:server:gangOnline', function(_, cb, lab)
    local Players = QBCore.Functions.GetQBPlayers()
    local members = {}
    for k, v in pairs(Players) do if v.PlayerData.gang.name == GrowLabs[lab].Padlock.gang then members[#members+1] = v end end
    if #members >= 4 then
        for k, _ in pairs(members) do TriggerClientEvent('malmo-weedharvest:client:padlockAlert', k, lab) end
        cb(true) return
    end
    cb(false)
end)

for k, v in pairs(Config.Seed) do
    QBCore.Functions.CreateUseableItem(v.jointItem, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemByName(v.jointItem) then
            local purity = item.info.purity or 20
            local strain = k
            Player.Functions.RemoveItem(v.jointItem, 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.jointItem], 'remove')
            TriggerClientEvent('malmo-weedharvest:client:smokeJoint', src, strain, purity)
        end
    end)
end

local weedTypes = {
    ['seed'] = true,
    ['fresh'] = true,
    ['dried'] = true,
    ['pound'] = true,
    ['qp'] = true,
    ['oz'] = true,
    ['7g'] = true,
    ['35g'] = true,
    ['joint'] = true,
}

QBCore.Functions.CreateUseableItem("seedpack", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("seedpack") then
        if not item.info.strain then TriggerClientEvent('QBCore:Notify', source, "There is no seed inside the pack?", 'error') return end
        local info = {strain = item.info.strain, decay = 2*24*3600, fromWW = true}
        if Player.Functions.RemoveItem("seedpack", 1, item.slot) then
            if Player.Functions.AddItem(item.info.strain, 10, false, info) then
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['seedpack'], 'remove')
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item.info.strain], 'add', 10)
            else
                TriggerClientEvent('QBCore:Notify', source, "You can\'t carry the seeds...", 'error')
                Player.Functions.AddItem("seedpack", 1, false, {strain = item.info.strain})
            end
        else TriggerClientEvent('QBCore:Notify', source, "You don't have a seed pack?", 'error') end
    else TriggerClientEvent('QBCore:Notify', source, "You don't have a seed pack?", 'error') end
end)

QBCore.Commands.Add('giveWeedItem', 'Give any type of weed to someone. (Admin Only)', {
    { name = 'id', help = 'ID of player' },
    { name = 'type', help = '(seed/fresh/dried/pound/qp/oz/7g/35g/joint)' },
    { name = 'strain', help = 'skunk_seed/zkittles_seed/trainwreck_seed/garliccookies_seed/malmokush_seed' },
    { name = 'purity', help = '1-100' },
    { name = 'amount', help = 'Only valid for seed/qp/oz/7g/35g/joint' },
}, false, function(source, args)
    if not args[1] then TriggerClientEvent('QBCore:Notify', source, "No Player Chosen...", 'error') return end
    local target = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(target)
    if not Player then TriggerClientEvent('QBCore:Notify', source, "Invalid Player", 'error') return end
    if not args[2] or not args[3] then TriggerClientEvent('QBCore:Notify', source, "No Weed Type or Strain Chosen...", 'error') return end
    local weed = weedTypes[args[2]] and args[2] or nil
    if not weed then TriggerClientEvent('QBCore:Notify', source, "Invalid Weed Type", 'error') return end
    local strain = Config.Seed[args[3]] and args[3] or nil
    if not strain then TriggerClientEvent('QBCore:Notify', source, "Invalid Strain", 'error') return end
    local purity = (tonumber(args[4]) > 0 and tonumber(args[4]) <= 100) and tonumber(args[4]) or nil
    if not purity then TriggerClientEvent('QBCore:Notify', source, "Invalid Purity", 'error') return end
    local dryWeed = false
    local amount = tonumber(args[5]) or 1
    local item = ''
    if weed == 'seed' then
        if Player.Functions.AddItem(strain, amount, false, {decay = 2*24*3600}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items[strain], 'add', amount)
            if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Successfuly gave weed to player.", 'success') else print("Successfuly gave weed to player.") end
        else if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Can't give weed to player...", 'error') return else print("Can't give weed to player...") end end
    elseif weed == 'fresh' then
        item = Config.Seed[strain].finalItem
        amount = 1
        if Player.Functions.AddItem(item, amount, false, {strain = strain, purity = purity, isWeedPlant = true, dry = dryWeed, strainlbl = Config.Seed[strain].label}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items[item], 'add', amount)
            if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Successfuly gave weed to player.", 'success') else print("Successfuly gave weed to player.") end
        else if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Can't give weed to player...", 'error') return else print("Can't give weed to player...") end end
    elseif weed == 'joint' then
        item = Config.Seed[strain].jointItem
        if Player.Functions.AddItem(item, amount, false, {strain = strain, purity = purity, isWeedPlant = true, dry = dryWeed, strainlbl = Config.Seed[strain].label}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items[item], 'add', amount)
            if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Successfuly gave weed to player.", 'success') else print("Successfuly gave weed to player.") end
        else if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Can't give weed to player...", 'error') return else print("Can't give weed to player...") end end
    else
        dryWeed = true
        if weed == 'dried' then item = 'malmo_dry_weed' amount = 1
        elseif weed == 'pound' then item = 'malmo_weed_brick' amount = 1
        elseif weed == 'qp' then item = 'malmo_weed_qp'
        elseif weed == 'oz' then item = 'malmo_weed_oz'
        elseif weed == '7g' then item = 'malmo_weed_7g'
        elseif weed == '35g' then item = 'malmo_weed_35g'
        end
        if Player.Functions.AddItem(item, amount, false, {strain = strain, purity = purity, isWeedPlant = true, dry = dryWeed, strainlbl = Config.Seed[strain].label}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items[item], 'add', amount)
            if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Successfuly gave weed to player.", 'success') else print("Successfuly gave weed to player.") end
        else if source ~= 0 then TriggerClientEvent('QBCore:Notify', source, "Can't give weed to player...", 'error') return else print("Can't give weed to player...") end end
    end
end, 'admin')

function fetchConfig() return Config end exports('fetchConfig', fetchConfig)