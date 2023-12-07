AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end Wait(2000) TriggerServerEvent("jim-mechanic:server:getStatusList", true) end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() Wait(5000) TriggerServerEvent("jim-mechanic:server:getStatusList", true) end)

function GetVehicleStatus(plate, part)
    return ((VehicleStatus[plate] and VehicleStatus[plate][part]) or nil)
end

function SetVehicleStatus(plate, part, level, all)
    if Config.System.Debug then print("^5Debug^7: ^2Updating ^4VehicleStatus^7[^6"..plate.."^7][^6"..part.."^7] = ^6"..json.encode(level).."^7"..(all == true and " (^1SYNCED^7)" or "")) end
    VehicleStatus[plate][part] = level
    TriggerServerEvent("jim-mechanic:server:updatePart", plate, part, level, all)
end

local DamageComponents = { "oil", "axle", "battery", "fuel", "spark" }

function DamageRandomComponent(plate, engHealth, bodyHealth)
    if Config.Repairs.ExtraDamages then
        if not VehicleStatus[plate] then TriggerServerEvent("jim-mechanic:server:setupVehicleStatus", plate, engHealth, bodyHealth) Wait(2000) end
        local dmgFctr = math.random() + math.random(0, 2)
        local randomComponent = DamageComponents[math.random(1, #DamageComponents)]
        local durabilityTable = { ["oil"] = "oillevel", ["axle"] = "shaftlevel", ["battery"] = "cylinderlevel", ["spark"] = "cablelevel", ["fuel"] = "fuellevel", }
        local randomDamage = (math.random() + math.random(0, 1)) * dmgFctr
        for i = 1, VehicleStatus[plate][durabilityTable[randomComponent]] do randomDamage -= ((randomDamage / 2) - VehicleStatus[plate][durabilityTable[randomComponent]] / 4) end
        SetVehicleStatus(plate, randomComponent, GetVehicleStatus(plate, randomComponent) - randomDamage)
    else
        if Config.System.Debug then
            print("^5Debug^7: ^4Vehicle damaged and tried to change ^6ExtraDamages^2 but it was disabled^7")
        end
    end
end
exports('GetVehicleStatus', GetVehicleStatus)
exports('SetVehicleStatus', SetVehicleStatus)
exports('DamageRandomComponent', DamageRandomComponent)

RegisterNetEvent('jim-mechanic:client:setVehicleStatus', function(plate, status)
    VehicleStatus[plate] = status
    if type(VehicleStatus[plate]["oriWheelX"]) == "string" then VehicleStatus[plate]["oriWheelX"] = json.decode(VehicleStatus[plate]["oriWheelX"]) end
end)

RegisterNetEvent('jim-mechanic:client:getStatusList', function(newList) VehicleStatus = newList end)

--=== ADD/REMOVE UPGRADE PARTS ===--
RegisterNetEvent('jim-mechanic:client:applyExtraPart', function(data) local Ped = PlayerPedId() emptyHands(Ped)
    if not enforceRestriction("perform") then return end
    if not Checks() then return end
    local vehicle = vehChecks() local above = isVehicleLift(vehicle)
    local cam = createTempCam(vehicle, Ped)
    if not enforceClassRestriction(getClass(vehicle)) then return end
    if DoesEntityExist(vehicle) then
        local emote = { anim = above and "idle_b" or "fixing_a_ped", dict = above and "amb@prop_human_movie_bulb@idle_a" or "mini@repair", flag = above and 1 or 16 }
        local plate = trim(GetVehicleNumberPlateText(vehicle))
        if not VehicleStatus[plate] then
            if Config.System.Debug then print("^5Debug^7: ^4VehicleStatus^7[^6"..plate.."^7]^2 not found^7,^2 loading^7...") end
            TriggerServerEvent("jim-mechanic:server:setupVehicleStatus", plate, GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle))
            while not VehicleStatus[plate] do Wait(10) end
        else TriggerServerEvent("jim-mechanic:server:getStatusList", true, plate) Wait(1000) end
        local extrapart = ""
        if data.mod == "oilp" then extrapart = "oillevel"
        elseif data.mod == "drives" then extrapart = "shaftlevel"
        elseif data.mod == "cylind" then extrapart = "cylinderlevel"
        elseif data.mod == "cables" then extrapart = "cablelevel"
        elseif data.mod == "fueltank" then extrapart = "fuellevel" end

        local currentLevel = VehicleStatus[plate][extrapart]
        if not lookAtEngine(vehicle) then return end
        SetVehicleEngineOn(vehicle, false, false, true)
        if Config.Overrides.DoorAnimations then SetVehicleDoorOpen(vehicle, 4, false, false) end
        if data.remove ~= true then
            if currentLevel == data.level then triggerNotify(nil, "LVL: "..data.level..Loc[Config.Lan]["common"].already, "error") else
                if progressBar({label = Loc[Config.Lan]["common"].installing.." LVL: "..data.level, time = math.random(7000,10000), cancel = true, anim = emote.anim, dict = emote.dict, flag = emote.flag, cam = cam }) then
                    if (VehicleStatus[plate][extrapart] ~= currentLevel) or (not HasItem(data.mod..data.level, 1)) then TriggerServerEvent("jim-mechanic:server:DupeWarn", data.mod..data.level) emptyHands(Ped) return end
                    qblog("`"..QBCore.Shared.Items[data.mod..data.level].label.." - "..data.mod..data.level.."` installed [**"..trim(GetVehicleNumberPlateText(vehicle)).."**]")
                    SetVehicleStatus(plate, extrapart, data.level)
                    updateCar(vehicle)
                    toggleItem(false, data.mod..data.level, 1)
                    if currentLevel ~= 0 then toggleItem(true, data.mod..currentLevel, 1) end
                    triggerNotify(nil, QBCore.Shared.Items[data.mod..data.level].label.." "..Loc[Config.Lan]["common"].installed, "success")
                else
                    triggerNotify(nil, Loc[Config.Lan]["common"].instfail, "error")
                end
            end
        else
            if progressBar({label = Loc[Config.Lan]["common"].removing, time = math.random(7000,10000), cancel = true, anim = emote.anim, dict = emote.dict, flag = emote.flag, cam = cam }) then
                if VehicleStatus[plate][extrapart] ~= currentLevel then emptyHands(Ped) TriggerServerEvent("jim-mechanic:server:DupeWarn", data.mod..currentLevel) return end
                SetVehicleStatus(plate, extrapart, 0)
                    qblog("`"..QBCore.Shared.Items[data.mod..currentLevel].label.." - "..data.mod..currentLevel.."` removed [**"..trim(GetVehicleNumberPlateText(vehicle)).."**]")
                    updateCar(vehicle)
                    toggleItem(true, data.mod..currentLevel, 1)
                    triggerNotify(nil, QBCore.Shared.Items[data.mod..currentLevel].label.." "..Loc[Config.Lan]["common"].removed, "success")
            else
                triggerNotify(nil, Loc[Config.Lan]["common"].remfail, "error")
            end
        end
        SetVehicleDoorShut(vehicle, 4, false)
        emptyHands(Ped)
    end
end)

--=== Damage Handling ===--
local function oilEffect(vehicle, plate)
    triggerNotify(nil, "Your engine is overheating")
    local engineHealth = GetVehicleEngineHealth(vehicle)
    local partLvl, effect, effectTable = VehicleStatus[plate]["axle"], 0, { [1] = math.random(10, 15), [2] = math.random(15, 20), [3] = math.random(20, 30), [4] = math.random(30, 40), [5] = math.random(40, 50), }
    if partLvl <= 80 and partLvl >= 60 then effect = effectTable[1]
    elseif partLvl <= 59 and partLvl >= 40 then effect = effectTable[2]
    elseif partLvl <= 39 and partLvl >= 20 then effect = effectTable[3]
    elseif partLvl <= 19 and partLvl >= 6 then effect = effectTable[4]
    else effect = effectTable[5] end
    SetVehicleEngineHealth(vehicle, engineHealth - effect)
end

local function axleEffect(vehicle, plate)
    triggerNotify(nil, "The steering feels wrong..")
    local partLvl, effect, effectTable = VehicleStatus[plate]["axle"], 0, { [1] = 5, [2] = 10, [3] = 15, [4] = 20, [5] = 25, }
    if partLvl <= 80 and partLvl >= 60 then effect = effectTable[1]
    elseif partLvl <= 59 and partLvl >= 40 then effect = effectTable[2]
    elseif partLvl <= 39 and partLvl >= 20 then effect = effectTable[3]
    elseif partLvl <= 19 and partLvl >= 6 then effect = effectTable[4]
    else effect = effectTable[5] end
    for i=0,360 do SetVehicleSteeringScale(vehicle,i) Wait(effect) end
end

local function sparkEffect(vehicle, plate)
    triggerNotify(nil, "The Engine has stalled")
    local partLvl, effect, effectTable = VehicleStatus[plate]["spark"], 0, { [1] = 300, [2] = 600, [3] = 900, [4] = 1200, [5] = 1500, }
    if partLvl <= 80 and partLvl >= 60 then effect = effectTable[1]
    elseif partLvl <= 59 and partLvl >= 40 then effect = effectTable[2]
    elseif partLvl <= 39 and partLvl >= 20 then effect = effectTable[3]
    elseif partLvl <= 19 and partLvl >= 6 then effect = effectTable[4]
    else effect = effectTable[5] end
    SetVehicleEngineOn(vehicle, 0, 0, 1)
    SetVehicleUndriveable(vehicle, true)
    Wait(effect*6)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, 1, 0, 0)
end

local function batteryEffect(vehicle, plate)
    local partLvl, effect, effectTable = VehicleStatus[plate]["battery"], 0, { [1] = 300, [2] = 600, [3] = 900, [4] = 1200, [5] = 1500, }
    if partLvl <= 80 and partLvl >= 60 then effect = effectTable[1]
    elseif partLvl <= 59 and partLvl >= 40 then effect = effectTable[2]
    elseif partLvl <= 39 and partLvl >= 20 then effect = effectTable[3]
    elseif partLvl <= 19 and partLvl >= 6 then effect = effectTable[4]
    else effect = effectTable[5] end
    local lightLvl = 1.0
    for i = 0, 1000 do lightLvl -= 0.003
        SetVehicleLightMultiplier(vehicle, lightLvl)
        Wait(0)
        if lightLvl <= 0 then break end
    end
    SetVehicleBrakeLights(vehicle, false)
    triggerNotify(nil, "The Engine has stalled")
    SetVehicleEngineOn(vehicle, 0, 0, 1)
    SetVehicleUndriveable(vehicle, true)
    SetVehicleLights(vehicle, 0)
    SetVehicleLightMultiplier(vehicle, 1.0)
    Wait(effect*3)
    SetVehicleLights(vehicle, 2)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, 1, 0, 0)
    for i=1,360 do SetVehicleSteeringScale(vehicle, i) Wait(5) end
end

local function fuelEffect(vehicle, plate)
    triggerNotify(nil, "You hear something dripping..")
    local fuel = GetVehicleFuelLevel(vehicle)
    local partLvl, effect, effectTable = VehicleStatus[plate]["fuel"], 0, { [1] = 2.0, [2] = 4.0, [3] = 6.0, [4] = 8.0, [5] = 10.0 }
    if partLvl <= 80 and partLvl >= 60 then effect = effectTable[1]
    elseif partLvl <= 59 and partLvl >= 40 then effect = effectTable[2]
    elseif partLvl <= 39 and partLvl >= 20 then effect = effectTable[3]
    elseif partLvl <= 19 and partLvl >= 6 then effect = effectTable[4]
    else effect = effectTable[5] end

    SetVehicleFuelLevel(vehicle, fuel - effect)
end

function ApplyEffects(vehicle)
    local plate = QBCore.Functions.GetPlate(vehicle)
    local noEffect = { "Vans", "Cycles", "Boats", "Helicopters", "Commercial", "Trains" }
    local canEffect = true
    for _, class in pairs(noEffect) do if getClass(vehicle) == class then canEffect = false end end
    if canEffect then
        if VehicleStatus[plate] then
            local chance = math.random(1, 100)
            if VehicleStatus[plate]["oil"] <= 80 and (chance >= 1 and chance <= 20) then oilEffect(vehicle, plate) end
            if VehicleStatus[plate]["axle"] <= 80 and (chance >= 21 and chance <= 40) then axleEffect(vehicle, plate) end
            if VehicleStatus[plate]["spark"] <= 80 and (chance >= 41 and chance <= 60) then sparkEffect(vehicle, plate) end
            if VehicleStatus[plate]["battery"] <= 80 and (chance >= 61 and chance <= 80) then batteryEffect(vehicle, plate) end
            if VehicleStatus[plate]["fuel"] <= 80 and (chance >= 81 and chance <= 100) then fuelEffect(vehicle, plate) end
        end
    end
end