if not Shared.Enable.Methcamper then return end

local minPure = 8
local maxPure = 40
local optimumValue = 484
local CurrentCooks = {}

local opLabTemp = 625
local opLabPress = 459

local MethLabs = {}

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

Citizen.CreateThread(function()
    Citizen.Wait(100)

    for k, v in pairs(Shared.MethLabs) do
        GlobalState['methProduction:'..k..':fumesLevel'] = 0
        GlobalState['methProduction:'..k..':ingredients'] = false
        GlobalState['methProduction:'..k..':settingsEnabled'] = false
        GlobalState['methProduction:'..k..':temperature'] = 0
        GlobalState['methProduction:'..k..':pressure'] = 0
        GlobalState['methProduction:'..k..':cookProgress'] = 0
        GlobalState['methProduction:'..k..':cooking'] = false
        GlobalState['methProduction:'..k..':neededIngredient'] = nil
        GlobalState['methProduction:'..k..':addedIngredient'] = nil
        GlobalState['methProduction:'..k..':eventControl'] = 0
        GlobalState['methProduction:'..k..':activePanel'] = 0
        GlobalState['methProduction:'..k..':strainName'] = nil
        GlobalState['methProduction:'..k..':cookDone'] = false
        GlobalState['methProduction:'..k..':sparkHydro'] = false
        GlobalState['methProduction:'..k..':brokenHydro'] = false
        GlobalState['methProduction:'..k..':sparkProd'] = false
        GlobalState['methProduction:'..k..':brokenProd'] = false
    end

    local LabJson = CustomSQL('fetchAll', 'SELECT * from `malmo_meth_labs`', {})
    if LabJson then for _, v in ipairs(LabJson) do
        local Lab = tonumber(v.Lab)
        if not Lab then return end
        local Fridge1 = json.decode(v.Fridge1) or {}
        local Fridge2 = json.decode(v.Fridge2) or {}
        local Fridge3 = json.decode(v.Fridge3) or {}
        MethLabs[Lab] = {Fridge1 = Fridge1, Fridge2 = Fridge2, Fridge3 = Fridge3}
    end end

    for k, v in pairs(Shared.MethLabs) do
        if not MethLabs[k] then
            MethLabs[k] = {
                ['Fridge1'] = {[1] = {}, [2] = {}, [3] = {},  [4] = {}, [5] = {}},
                ['Fridge2'] = {[1] = {}, [2] = {}, [3] = {},  [4] = {}, [5] = {}},
                ['Fridge3'] = {[1] = {}, [2] = {}, [3] = {},  [4] = {}, [5] = {}}
            }
        end
    end
    --print_table(MethLabs)
end)

----------
-- Util --
----------
QBCore.Functions.CreateCallback('qb-drugsystem:server:getLabTables', function(_, cb) cb(MethLabs) end)
QBCore.Functions.CreateCallback('qb-drugsystem:server:getTime', function(_, cb) cb(os.time()) end)

-- Removing an item from someone's inventory
RegisterNetEvent('qb-drugsystem:server:remItem', function(item, dontShowImage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, 1)
    if not dontShowImage then TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove', 1) end
end)

-----------------
-- Meth Camper --
-----------------

-- Meth Camper Cook Finished
RegisterNetEvent('qb-drugsystem:server:methcamperReward', function(temp)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if type(temp) ~= 'number' then return end
    local ped = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(ped)
    if veh == 0 or GetEntityModel(veh) ~= `journey` then return end
    if GetPedInVehicleSeat(veh, -1) == 0 and (GetPedInVehicleSeat(veh, 1) == ped or GetPedInVehicleSeat(veh, 2) == ped) then
        local dist = math.abs(temp - optimumValue) -- optimumValue is the optimal temperature, the further you are away from this, the worse your meth purity will be
        local pure = 100 - dist -- Function that defines the purity, here it's just 1-1, if you are 1 degree away of 484, you lose 1% purity
        if pure > maxPure then pure = maxPure end -- maxPure is the maximum purity you can get via methcamper
        if pure < minPure then pure = minPure end -- minPure is the minimum purity you can get via methcamper
        local amount = Shared.MethcamperRewardAmount
        for _, v in pairs(CurrentCooks[Player.PlayerData.citizenid]) do
            if v[1] == 'purity' then pure = pure + v[2]
            elseif v[2] == 'amount' then amount = amount + v[2] end
        end
        if pure < 5 then pure = 5 end
        if amount < 5 then amount = 5 end
        local info = { purity = pure }
        Player.Functions.AddItem(Shared.MethcamperRewardItem, amount, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.MethcamperRewardItem], 'add', amount)
        CurrentCooks[Player.PlayerData.citizenid] = nil
    end
end)

-- Syncing Meth Camper PfX
RegisterNetEvent('qb-drugsystem:server:ptfx', function(coords) TriggerClientEvent('qb-drugsystem:client:ptfx', -1, coords) end)

-- Modify Meth Camper's
RegisterNetEvent('qb-drugsystem:server:modCook', function(modType, am)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    if not CurrentCooks[cid] then CurrentCooks[cid] = {} end
    CurrentCooks[cid][#CurrentCooks[cid]+1] = {modType, am}
end)

-- Meth Camper Beaker Break Event
RegisterNetEvent('qb-drugsystem:server:beakerBreak', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(Shared.MethcamperPortableItem)
    if not item then TriggerClientEvent('qb-drugsystem:client:lostLab', src) return end
    local uses = type(Player.PlayerData.items[item.slot].info) == 'table' and Player.PlayerData.items[item.slot].info.uses or 0
    if not type(Player.PlayerData.items[item.slot].info) == 'table' then Player.PlayerData.items[item.slot].info = {} end
    uses = uses + 1
    Player.PlayerData.items[item.slot].info.uses = uses
    if uses >= 3 then
        Player.Functions.RemoveItem(Shared.MethcamperPortableItem, 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.MethcamperRequiredItem], 'remove', 1)
    else Player.Functions.SetInventory(Player.PlayerData.items) end
end)

-- Check if player has all the required items and starts the cook.
QBCore.Functions.CreateCallback('qb-drugsystem:server:hasMethCamperItems', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if QBCore.Functions.HasItem(src, Shared.MethcamperPortableItem, 1) then
        if Player.Functions.RemoveItem(Shared.MethcamperRequiredItem, 5, false) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Shared.MethcamperRequiredItem], 'remove', 1)
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', src, _U('methcamper_need_pseudo'), 'error', 2500)
            cb(false)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, _U('methcamper_need_lab'), 'error', 2500)
        cb(false)
    end
end)

-- Rent the van used to cook meth.
QBCore.Functions.CreateCallback('qb-drugsystem:server:JourneyRenting', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.Functions.RemoveMoney('cash', 1250, "Journey Van Renting") then cb(true)
    else cb(false) end
end)

--------------------
-- Lab Production --
--------------------

-- Checks if player has all the ingredients needed for the cook.
QBCore.Functions.CreateCallback('qb-drugsystem:server:hasMethLabItems', function(source, cb, lab)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local allu = Player.Functions.GetItemByName('shredded_aluminum')
    local methylamine = Player.Functions.GetItemByName('methylamine')
    local thorium = Player.Functions.GetItemByName('thorium_oxide')
    if not allu or allu.info.qty == 0 then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough shredded alluminum...', 'error', 2500) cb(false) return end
    if not methylamine or methylamine.info.qty == 0 then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough Methylamine...', 'error', 2500) cb(false) return end
    if not thorium or thorium.info.qty == 0 then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough Thorium Oxide..', 'error', 2500) cb(false) return end
    Player.PlayerData.items[allu.slot].info.qty = allu.info.qty - 1
    Player.PlayerData.items[methylamine.slot].info.qty = methylamine.info.qty - 1
    Player.PlayerData.items[thorium.slot].info.qty = thorium.info.qty - 1
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['shredded_aluminum'], 'used', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['methylamine'], 'used', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['thorium_oxide'], 'used', 1)
    Player.Functions.SetInventory(Player.PlayerData.items)
    GlobalState['methProduction:'..lab..':ingredients'] = true
    cb(true)
end)

-- Enable the settings pannel once the ingredients are put in
RegisterNetEvent('qb-drugsystem:server:enableMethProdSettings', function(lab)
    local src = source
    if not GlobalState['methProduction:'..lab..':ingredients'] then return --[[ ExploitCheck ]] end
    GlobalState['methProduction:'..lab..':settingsEnabled'] = true
end)

-- Cook Settings
RegisterNetEvent('qb-drugsystem:server:SetProdSettings', function(lab, s, a)
    local src = source
    GlobalState['methProduction:'..lab..':'..s] = a
    if s == 'strainName' then  return end
    TriggerClientEvent('QBCore:Notify', src, 'The '..s..' for the cook has been set to '..a, 'success', 2500)
end)

-- All Lab Events
local LabEvents = {
    -- Lab fumes
    [1] = function(lab)
        print("Labs Fumes Event")
        GlobalState['methProduction:'..lab..':fumesLevel'] = 1
        GlobalState['methProduction:'..lab..':eventControl'] = 1
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 1)
        Citizen.CreateThread(function()
            Wait(15000)
            if GlobalState['methProduction:'..lab..':fumesLevel'] >= 1 then
                GlobalState['methProduction:'..lab..':fumesLevel'] = 2
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -5)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -3)
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Missing Methylamine
    [2] = function(lab)
        print("Methylamine Event")
        GlobalState['methProduction:'..lab..':neededIngredient'] = 'methylamine'
        GlobalState['methProduction:'..lab..':eventControl'] = 2
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 2)
        Citizen.CreateThread(function()
            Wait(15000)
            if GlobalState['methProduction:'..lab..':addedIngredient'] ~= 'methylamine' then
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The solution seems a bit odd....', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -3)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -7)
            end
            GlobalState['methProduction:'..lab..':neededIngredient'] = nil
            GlobalState['methProduction:'..lab..':addedIngredient'] = nil
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Missing Aluminum
    [3] = function(lab)
        print("Aluminum Event")
        GlobalState['methProduction:'..lab..':neededIngredient'] = 'shredded_aluminum'
        GlobalState['methProduction:'..lab..':eventControl'] = 3
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 3)
        Citizen.CreateThread(function()
            Wait(15000)
            if GlobalState['methProduction:'..lab..':addedIngredient'] ~= 'shredded_aluminum' then
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The solution seems a bit odd....', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -3)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -7)
            end
            GlobalState['methProduction:'..lab..':neededIngredient'] = nil
            GlobalState['methProduction:'..lab..':addedIngredient'] = nil
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Missing Thorium
    [4] = function(lab)
        print("Thorium Event")
        GlobalState['methProduction:'..lab..':neededIngredient'] = 'thorium_oxide'
        GlobalState['methProduction:'..lab..':eventControl'] = 4
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 4)
        Citizen.CreateThread(function()
            Wait(15000)
            if GlobalState['methProduction:'..lab..':addedIngredient'] ~= 'thorium_oxide' then
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The solution seems a bit odd....', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -3)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -7)
            end
            GlobalState['methProduction:'..lab..':neededIngredient'] = nil
            GlobalState['methProduction:'..lab..':addedIngredient'] = nil
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Hydrogene Adujstment
    [5] = function(lab)
        print("Hydrogene Event")
        GlobalState['methProduction:'..lab..':eventControl'] = 5
        Wait(100)
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 5)
        Citizen.CreateThread(function()
            Wait(20000)
            if GlobalState['methProduction:'..lab..':eventControl'] ~= 0 then
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'You notice chucks forming in the solution..', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -5)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -5)
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Pannel Needs Attention
    [6] = function(lab)
        print("Pannel Light Event")
        GlobalState['methProduction:'..lab..':eventControl'] = 6
        local panel = math.random(6)
        GlobalState['methProduction:'..lab..':activePanel'] = panel
        Wait(100)
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 6)
        Citizen.CreateThread(function()
            Wait(20000)
            if GlobalState['methProduction:'..lab..':eventControl'] ~= 0 then
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The solution seems to bubble a bit too much...', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -10)
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -10)
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
            GlobalState['methProduction:'..lab..':activePanel'] = 0
        end)
    end,
    -- Minigame
    [7] = function(lab)
        print("Production Panel Light Event")
        GlobalState['methProduction:'..lab..':eventControl'] = 7
        Wait(100)
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 7)
        Citizen.CreateThread(function()
            Wait(120000)
            if GlobalState['methProduction:'..lab..':eventControl'] ~= 0 then
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', math.random(-5,-2))
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', math.random(-5,-2))
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Broken Hydro
    [8] = function(lab)
        print("Broken Hydro Event")
        GlobalState['methProduction:'..lab..':eventControl'] = 8
        GlobalState['methProduction:'..lab..':sparkHydro'] = true
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 8)
        Citizen.CreateThread(function()
            Wait(20000)
            if GlobalState['methProduction:'..lab..':eventControl'] ~= 0 then
                GlobalState['methProduction:'..lab..':sparkHydro'] = false
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The broken panel becomes unresponsive', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -10)
                GlobalState['methProduction:'..lab..':brokenHydro'] = true
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Broken Minigame
    [9] = function(lab)
        print("Broken Production Panel Event")
        GlobalState['methProduction:'..lab..':eventControl'] = 9
        GlobalState['methProduction:'..lab..':sparkProd'] = true
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 9)
        Citizen.CreateThread(function()
            Wait(20000)
            if GlobalState['methProduction:'..lab..':eventControl'] ~= 0 then
                GlobalState['methProduction:'..lab..':sparkProd'] = false
                TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The broken panel becomes unresponsive', 'error')
                TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -10)
                GlobalState['methProduction:'..lab..':brokenProd'] = true
            end
            GlobalState['methProduction:'..lab..':eventControl'] = 0
        end)
    end,
    -- Breaker Blew
    [10] = function(lab)
        print("Breaker Blew")
        GlobalState['methProduction:'..lab..':eventControl'] = 10
        GlobalState['methProduction:'..lab..':breakerBlew'] = true
        TriggerClientEvent('qb-drugsystem:client:LabEvents', -1, lab, 10)
        lib.waitFor(function()
            GlobalState['methProduction:'..lab..':breakerBlew'] = false
        end, "Meth Lab "..lab.." lost all power, fridges turn bad", 60*60000)
        if GlobalState['methProduction:'..lab..':breakerBlew'] then
            GlobalState['methProduction:'..lab..':lostAllPower'] = true

            GlobalState['methProduction:'..lab..':fumesLevel'] = 0
            GlobalState['methProduction:'..lab..':ingredients'] = false
            GlobalState['methProduction:'..lab..':settingsEnabled'] = false
            GlobalState['methProduction:'..lab..':temperature'] = 0
            GlobalState['methProduction:'..lab..':pressure'] = 0
            GlobalState['methProduction:'..lab..':cookProgress'] = 0
            GlobalState['methProduction:'..lab..':cooking'] = false
            GlobalState['methProduction:'..lab..':neededIngredient'] = nil
            GlobalState['methProduction:'..lab..':addedIngredient'] = nil
            GlobalState['methProduction:'..lab..':eventControl'] = 0
            GlobalState['methProduction:'..lab..':activePanel'] = 0
            GlobalState['methProduction:'..lab..':strainName'] = nil
            GlobalState['methProduction:'..lab..':currentCook'] = {}
            GlobalState['methProduction:'..lab..':cookDone'] = false
            GlobalState['methProduction:'..lab..':sparkHydro'] = false
            GlobalState['methProduction:'..lab..':sparkProd'] = false
        end
        GlobalState['methProduction:'..lab..':eventControl'] = 0
end,
    --[[ leak
        one of the hoses under the flashing panels start leaking
        steam pfx coming out of it
        need duct tape to fix it
    ]]
    --[[ breaker fuse broken
        Lights turn off  (1 emergency  red spotligth turns on)
        cook pauses until fixed
        if not fixed within 1 hour, all the meth in the fridges turn bad
        need a fuse to repair the panel
        not affected by spark evemt
    ]]
    --[[ pressure rises quicly
        the pressure starts rising quicly
        go to settings panel to fix quickly
        oxlib skillcheck
        either mods the cook, or big fumes leak, ruins the cook, 10 secs blackout, wake up on the floor at 1 hp
    ]]
}

local checkBrokenPanel = function(lab, e)
    if e == 8 and GlobalState['methProduction:'..lab..':brokenHydro'] then return true
    elseif e == 9 and GlobalState['methProduction:'..lab..':brokenProd'] then return true
    else return false end
end

-- Events who shouldn't happen twice
local noRepeats = {
    [2] = true, [3] = true, [4] = true
}

-- Meth Lab Cooking Loop
RegisterNetEvent('qb-drugsystem:server:startProduction', function(lab)
    if GlobalState['methProduction:'..lab..':cooking'] then return end
    GlobalState['methProduction:'..lab..':cooking'] = true
    print("Production Starting at lab "..lab)
    local src = source
    local progress = 0

    Citizen.CreateThread(function()
        local loc = Shared.MethLabs[lab].fumes
        while progress <= 100 do
            TriggerClientEvent('qb-drugsystem:client:labPfx', -1, loc)
            Citizen.Wait(30000)
            if progress == 100 then break end
        end
    end)

    Citizen.CreateThread(function()
        local EventsDone = {}
        local Events = {}
        Events[math.random(1,18)] = true
        Events[math.random(19,36)] = true
        Events[math.random(37,54)] = true
        Events[math.random(55,72)] = true
        Events[math.random(73,90)] = true
        Events[math.random(91,108)] = true
        Events[math.random(109,126)] = true
        Events[math.random(127,144)] = true
        Events[math.random(145,162)] = true
        Events[math.random(163,180)] = true
        -- Cooking Loop
        for i = 1, 180 do
            if not GlobalState['methProduction:'..lab..':cooking'] then break end
            progress = progress + 100/180
            GlobalState['methProduction:'..lab..':cookProgress'] = progress
            Wait(10000)
            if progress > 100 then GlobalState['methProduction:'..lab..':cookDone'] = true break end
            if Events[i] then
                ::start::
                local ran = math.random(#LabEvents)
                if EventsDone[ran] then goto start end
                if checkBrokenPanel(lab, ran) then print("Event already done") goto start end
                if noRepeats[ran] then EventsDone[2], EventsDone[3], EventsDone[4] = true, true, true end
                while GlobalState['methProduction:'..lab..':breakerBlew'] do Wait(5000) end
                while GlobalState['methProduction:'..lab..':eventControl'] ~= 0 do Wait(0) end
                LabEvents[ran](lab)
            end
        end
        TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The production is done! You can pour it onto a tray.', 'success')
        GlobalState['methProduction:'..lab..':cookDone'] = true
        EventsDone = {}
    end)
end)

-- Missing Ingredient Event
QBCore.Functions.CreateCallback('qb-drugsystem:server:hasIngredient', function(source, cb, lab)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local ingredient = GlobalState['methProduction:'..lab..':neededIngredient']
    local allu = Player.Functions.GetItemByName(ingredient)
    if not allu or allu.info.qty == 0 then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough '..QBCore.Shared.Items[ingredient].label..'...', 'error', 2500) cb(false) return end
    Player.PlayerData.items[allu.slot].info.qty = allu.info.qty - 1
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient], 'used', 1)
    GlobalState['methProduction:'..lab..':addedIngredient'] = ingredient
    Player.Functions.SetInventory(Player.PlayerData.items)
    TriggerClientEvent('QBCore:Notify', src, 'You add some '..QBCore.Shared.Items[ingredient].label, 'success', 5000)
    GlobalState['methProduction:'..lab..':neededIngredient'] = nil
    cb(true)
end)

-- Air Vents Event
RegisterNetEvent('qb-drugsystem:server:activateAirVents', function(lab)
    local src = source
    GlobalState['methProduction:'..lab..':fumesLevel'] = 0
    TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The air in the lab is starting to clear up...', 'success')
    local loc = Shared.MethLabs[lab].fumes
    Citizen.CreateThread(function() for _ = 1, 10 do TriggerClientEvent('qb-drugsystem:client:labFlare', -1, loc) Wait(30000) end end)
end)

-- Hydrogene Event
RegisterNetEvent('qb-drugsystem:server:adjustHydrogene', function(lab)
    local src = source
    if GlobalState['methProduction:'..lab..':eventControl'] == 5 then
        GlobalState['methProduction:'..lab..':eventControl'] = 0
    end
    TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The hydrogene levels seem on point now.', 'success')
end)

-- Fixing Hydrogene Event
RegisterNetEvent('qb-drugsystem:server:fixHydrogene', function(lab)
    local src = source
    if GlobalState['methProduction:'..lab..':eventControl'] == 8 then
        GlobalState['methProduction:'..lab..':eventControl'] = 0
        GlobalState['methProduction:'..lab..':sparkHydro'] = false
    else
        GlobalState['methProduction:'..lab..':brokenHydro'] = false
    end
    TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The hydrogene control panel is now functionning properly', 'success')
end)

-- Fixing Production Event
RegisterNetEvent('qb-drugsystem:server:fixProduction', function(lab)
    local src = source
    if GlobalState['methProduction:'..lab..':eventControl'] == 9 then
        GlobalState['methProduction:'..lab..':eventControl'] = 0
        GlobalState['methProduction:'..lab..':sparkProd'] = false
    else
        GlobalState['methProduction:'..lab..':brokenProd'] = false
    end
    TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The production panel is now functionning properly', 'success')
end)

-- Production Panel Event
RegisterNetEvent('qb-drugsystem:server:adjustMinigames', function(lab)
    local src = source
    if GlobalState['methProduction:'..lab..':eventControl'] == 7 then GlobalState['methProduction:'..lab..':eventControl'] = 0 end
    TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The production pannel light turns off.', 'success')
end)

-- Flashing Panel Event
RegisterNetEvent('qb-drugsystem:server:adjustPanel', function(lab, panel)
    local src = source
    if GlobalState['methProduction:'..lab..':eventControl'] == 6 and GlobalState['methProduction:'..lab..':activePanel'] == panel then
        TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'The flashing red light stops.', 'success')
        GlobalState['methProduction:'..lab..':eventControl'] = 0
        GlobalState['methProduction:'..lab..':activePanel'] = 0
    else
        TriggerClientEvent('qb-drugsystem:client:labNotify', -1, lab, 'You\'re unsure of what you just did...', 'info')
        TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'purity', -1)
        TriggerEvent('qb-drugsystem:server:modLabCook', lab, 'amount', -1)
    end
end)

-- Modify Purity & Amount of Lab Cooks
RegisterNetEvent('qb-drugsystem:server:modLabCook', function(lab, modType, am)
    if not GlobalState['methProduction:'..lab..':currentCook'] then GlobalState['methProduction:'..lab..':currentCook'] = {} end
    GlobalState['methProduction:'..lab..':currentCook'][#GlobalState['methProduction:'..lab..':currentCook']+1] = {modType, am}
end)

-- Pouring Finished Meth Solution on Trays
local pourBusy = false
RegisterNetEvent('qb-drugsystem:server:methLabPour', function(lab)
    if not GlobalState['methProduction:'..lab..':cookDone'] or pourBusy then return end
    pourBusy = true
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local t = GlobalState['methProduction:'..lab..':temperature']
    local p = GlobalState['methProduction:'..lab..':pressure']
    local n = GlobalState['methProduction:'..lab..':strainName']

    local dist1 = math.abs(t - opLabTemp) -- optimumValue is the optimal temperature, the further you are away from this, the worse your meth purity will be
    local dist2 = math.abs(p - opLabPress) -- optimumValue is the optimal pressure, the further you are away from this, the worse your meth purity will be
    local pure = 100 - dist1 - dist2 -- Function that defines the purity, here it's just 1-1, if you are 1 degree away of 484, you lose 1% purity
    if pure > 100 then pure = 100 end -- maxPure is the maximum purity you can get via methcamper
    if pure < 50 then pure = 50 end -- minPure is the minimum purity you can get via methcamper
    local amount = 60
    for _, v in pairs(GlobalState['methProduction:'..lab..':currentCook']) do
        if v[1] == 'purity' then pure = pure + v[2]
        elseif v[2] == 'amount' then amount = amount + v[2] end
    end
    if pure < 20 then pure = 20 end
    if amount < 5 then amount = 5 end
    local info = {isWeedPlant = true,  purity = pure , methAmt = amount, methStrainName = n}

    if Player.Functions.AddItem('meth_tray', 1, false, info) then
        pourBusy = false TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth_tray'], 'add', 1)

        local gInfo = exports['av_gangs']:getGang(src)
        if gInfo then
            TriggerEvent('av_gangs:addXP', gInfo.name, 1)
            TriggerClientEvent('QBCore:Notify', src, "You get some gang reputation from doing this...", 'success')
        end

        GlobalState['methProduction:'..lab..':fumesLevel'] = 0
        GlobalState['methProduction:'..lab..':ingredients'] = false
        GlobalState['methProduction:'..lab..':settingsEnabled'] = false
        GlobalState['methProduction:'..lab..':temperature'] = 0
        GlobalState['methProduction:'..lab..':pressure'] = 0
        GlobalState['methProduction:'..lab..':cookProgress'] = 0
        GlobalState['methProduction:'..lab..':cooking'] = false
        GlobalState['methProduction:'..lab..':neededIngredient'] = nil
        GlobalState['methProduction:'..lab..':addedIngredient'] = nil
        GlobalState['methProduction:'..lab..':eventControl'] = 0
        GlobalState['methProduction:'..lab..':activePanel'] = 0
        GlobalState['methProduction:'..lab..':strainName'] = nil
        GlobalState['methProduction:'..lab..':currentCook'] = {}
        GlobalState['methProduction:'..lab..':cookDone'] = false
        GlobalState['methProduction:'..lab..':sparkHydro'] = false
        GlobalState['methProduction:'..lab..':sparkProd'] = false

    else pourBusy = false TriggerClientEvent('QBCore:Notify', src, 'You can\'t carry the tray...', 'error', 2500) end
end)

-- Placing cured meth in a fridge
RegisterNetEvent('qb-drugsystem:server:depoMethTray', function(lab, fridge, tray, slot)
    if MethLabs[lab]['Fridge'..fridge][tray].state == 'occupied' then return end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.items[slot].info
    if info == "" or info == nil then return end
    if Player.PlayerData.items[slot].name ~= 'meth_tray' then return end
    if not Player.Functions.RemoveItem('meth_tray', 1, slot) then return end
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['meth_tray'], "remove", 1)
    MethLabs[lab]['Fridge'..fridge][tray] = {strain = info.methStrainName, purity = info.purity, time = os.time(), gang = Player.PlayerData.gang.name, state = 'occupied', methAmt = info.methAmt}
    StoreLabsData(lab)
    TriggerClientEvent('qb-drugsystem:client:updateLabsData', -1, MethLabs)
end)

-- Taking Cured Meth from a fridge
RegisterNetEvent('qb-drugsystem:server:takeMethTray', function(lab, fridge, tray)
    if MethLabs[lab]['Fridge'..fridge][tray].state == 'empty' then return end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentTray = MethLabs[lab]['Fridge'..fridge][tray]
    if not currentTray.state or currentTray.state ~= 'occupied' then return end
    if os.time() < currentTray.time + 21600 then TriggerClientEvent('QBCore:Notify', src, 'The meth isn\'t cured yet...', 'error', 2500) return end
    local info = {isWeedPlant = true, methStrainName = currentTray.strain, purity = currentTray.purity, gang = currentTray.gang, methAmt = currentTray.methAmt}
    if not Player.Functions.AddItem('meth_cured', 1, false, info) then TriggerClientEvent('QBCore:Notify', src, 'You can\'t carry the tray...', 'error', 2500) return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth_cured'], 'add', 1)
    MethLabs[lab]['Fridge'..fridge][tray] = {strain = 'None.', purity = 0, time = 0, gang = 'none', state = 'empty', methAmt = 0}
    StoreLabsData(lab)
    TriggerClientEvent('qb-drugsystem:client:updateLabsData', -1, MethLabs)
end)

-- Scale meth into bags
RegisterServerEvent('qb-drugsystem:server:ScaleMeth', function(amount, slot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.PlayerData.items[slot]
    local methItem = item.name
    local remItem = amount == 'baggies' and "emptybaggy"
    local remAmount = (amount == 'batch' and 1) or item.info.methAmt
    local recItem = amount == 'batch' and "meth_batch" or Shared.MethcamperRewardItem

    if not remItem and Player.Functions.RemoveItem(methItem, 1, slot) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[methItem], "remove")
        local info = {methStrainName = item.info.methStrainName, purity = item.info.purity, isWeedPlant = true, gang = item.info.gang, methAmt = recItem == 'meth_batch' and item.info.methAmt or nil}
        Player.Functions.AddItem(recItem, remAmount, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[recItem], "add", remAmount)
    return end

    local container = Player.Functions.GetItemByName(remItem)
    if container.amount < remAmount then TriggerClientEvent('QBCore:Notify', src, "You don't have enough items to do this!", 'error') return end
    if Player.Functions.RemoveItem(methItem, 1, slot) and Player.Functions.RemoveItem(remItem, remAmount) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[methItem], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[remItem], "remove", remAmount)
        local info = {methStrainName = item.info.methStrainName, purity = item.info.purity, isWeedPlant = true, gang = item.info.gang}
        Player.Functions.AddItem(recItem, remAmount, false, info)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[recItem], "add", remAmount)
    else TriggerClientEvent('QBCore:Notify', src, "Something went wrong...", 'error') return end
end)

function StoreLabsData(lab)
    local cLab = MethLabs[lab]
    local f1, f2, f3 = json.encode(cLab.Fridge1), json.encode(cLab.Fridge2), json.encode(cLab.Fridge3)
    CustomSQL('execute', 'INSERT INTO malmo_meth_labs (Lab, Fridge1, Fridge2, Fridge3) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE Fridge1 = ?, Fridge2 = ?, Fridge3 = ?;',
    {lab, f1, f2, f3, f1, f2, f3})
    --SaveResourceFile(GetCurrentResourceName(), "growlabs.json", json.encode(GrowLabs), -1)
end

QBCore.Functions.CreateUseableItem(Shared.MethcamperRewardItem, function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(Shared.MethcamperRewardItem) then
        local purity = item.info.purity or 0
        Player.Functions.RemoveItem(Shared.MethcamperRewardItem, 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Shared.MethcamperRewardItem], 'remove')
        TriggerClientEvent('qb-drugsystem:client:smokeMeth', src, purity)
    end
end)

RegisterCommand('giveTray', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem('meth_batch',1,false,{isWeedPlant = true, purity = 100, methAmt = 60, methStrainName = "Lewis", gang = "cabal"})
end)

local methTypes = {
    ['tray'] = true,
    ['cured'] = true,
    ['batch'] = true,
    ['baggies'] = true,
}
local function cmdNotif(src, txt, tpe)
    if src ~= 0 then TriggerClientEvent('QBCore:Notify', src, txt, tpe) else print(txt) end
end

QBCore.Commands.Add('giveMethItem', 'Give any type of meth to someone. (Admin Only)', {
    { name = 'id', help = 'ID of player' },
    { name = 'type', help = '(tray/cured/batch/baggies)' },
    { name = 'strain', help = 'Any Name' },
    { name = 'purity', help = '1-100' },
    { name = 'amount', help = 'Amount of Baggies Given (Metadata for trays & batches or Amount for baggies)'},
    { name = 'gang', help = 'Gang associated with the meth made. (Leave empty if none)' },
}, false, function(source, args)
    if not args[1] then cmdNotif(source, "No Player Chosen...", 'error') return end
    local target = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(target)
    if not Player then cmdNotif(source, "Invalid Player", 'error') return end

    if not args[2] then cmdNotif(source, "No Meth Type Chosen...", 'error') return end
    local meth = methTypes[args[2]] and args[2] or nil
    if not meth then cmdNotif(source, "Invalid Meth Type [tray/cured/batch/baggies]", 'error') return end

    local strain = args[3] or "Baby Blue Boy"
    if not strain then cmdNotif(source, "Invalid Strain", 'error') return end

    local purity = (tonumber(args[4]) > 0 and tonumber(args[4]) <= 100) and tonumber(args[4]) or nil
    if not purity then cmdNotif(source, "Invalid Purity [1-100]", 'error') return end

    local amount = tonumber(args[5]) or 1

    local gang = QBCore.Shared.Gangs[args[6]] and args[6] or "None"
    if not gang then cmdNotif(source, "Invalid Gang", 'error') return end

    if meth == 'tray' then
        if Player.Functions.AddItem('meth_tray', 1, false, {isWeedPlant = true,  purity = purity , methAmt = amount, methStrainName = strain}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items['meth_tray'], 'add', 1)
            cmdNotif(source, "Successfuly gave meth tray to player.", 'success')
        else cmdNotif(source, "Can't give meth tray to player...", 'error') return end
    elseif meth == 'cured' then
        if Player.Functions.AddItem('meth_cured', 1, false, {isWeedPlant = true,  purity = purity , methAmt = amount, methStrainName = strain, gang = gang}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items['meth_cured'], 'add', 1)
            cmdNotif(source, "Successfuly gave meth tray to player.", 'success')
        else cmdNotif(source, "Can't give meth tray to player...", 'error') return end
    elseif meth == 'batch' then
        if Player.Functions.AddItem('meth_batch', 1, false, {isWeedPlant = true,  purity = purity , methAmt = amount, methStrainName = strain, gang = gang}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items['meth_batch'], 'add', 1)
            cmdNotif(source, "Successfuly gave meth batch to player.", 'success')
        else cmdNotif(source, "Can't give meth batch to player...", 'error') return end
    elseif meth == 'baggies' then
        if Player.Functions.AddItem('meth', amount, false, {isWeedPlant = true,  purity = purity, methStrainName = strain, gang = gang}) then
            TriggerClientEvent('inventory:client:ItemBox', target, QBCore.Shared.Items['meth'], 'add', amount)
            cmdNotif(source, "Successfuly gave meth baggies to player.", 'success')
        else cmdNotif(source, "Can't give meth baggies to player...", 'error') return end
    end
end, 'admin')