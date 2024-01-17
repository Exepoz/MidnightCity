if not (GetResourceState('sd_lib') == 'started') then
    print("^1Error: sd_lib isn't installed or this resource has been started before sd_lib.")
end

local SD = exports['sd_lib']:getLib()

SD.VersionCheck() -- Version Check

local cooldown = false

local bobcatPlayers = {}
local lootedBoxes = { smgs = true, explosives = true, rifles = true, ammo = true }

-- Item Creation
if not Config.UseTargetForDoors then
SD.RegisterUsableItem(Config.Items.Thermite, function(source) 
	TriggerClientEvent('sd-bobcat:client:startHeist', source) 
end) 

SD.RegisterUsableItem(Config.Items.Keycard, function(source)
	TriggerClientEvent('sd-bobcat:client:openThirdDoor', source)
end)
end

-- Event to sync door states
RegisterServerEvent('sd-bobcat:server:changeState', function(locationKey, stateType, stateValue)
    if locationKey == nil or stateType == nil or stateValue == nil then return end
    TriggerClientEvent('sd-bobcat:client:changeState', -1, locationKey, stateType, stateValue)
end)

-- Events to sync particles.
RegisterNetEvent('sd-bobcat:server:particles', function()
    TriggerClientEvent('sd-bobcat:client:particles', -1)
end)

RegisterNetEvent('sd-bobcat:server:particles2', function()
    TriggerClientEvent('sd-bobcat:client:particles2', -1)
end)

-- Removing Items
RegisterNetEvent('sd-bobcat:server:removeItem', function(item)
	SD.RemoveItem(source, item, 1)
end)

-- Check for items listed in Config.Items
SD.RegisterCallback('sd-bobcat:server:hasItem', function(source, cb, item)
    if SD.HasItem(source, item) > 0 then
        cb(true)
    else
        cb(false)
    end
end)

-- Callback to check cop count
SD.RegisterCallback('sd-bobcat:server:getCops', function(source, cb)
    local players = GetPlayers()
    local amount = 0
    for i=1, #players do
        local player = tonumber(players[i])
        if SD.HasGroup(player, SD.PoliceJobs) then
            amount = amount + 1
        end
    end
    cb(amount)
end)

-- Callback to check cooldown
SD.RegisterCallback('sd-bobcat:server:cooldown', function(source, cb)
    cb(cooldown)
end)

-- Callback to add player to bobcatplayers table
SD.RegisterCallback('sd-bobcat:server:addPlayerCallback', function(source, cb)
	local added = false
    local src = source
    local identifier = SD.GetIdentifier(source)
    bobcatPlayers[#bobcatPlayers+1] = {
        id = src,
        citizenid = identifier
    }
    added = true
    cb(added)

end)

-- Loot Giving Event for Boxes
RegisterNetEvent('sd-bobcat:giveRandomBox', function(box)
    if not isBobcatPlayer(source) then return end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distanceThreshold = 4.0 -- Distance threshold in meters
    
    local distances = {
        smgs = #(playerCoords - Config.Locations[Config.MLOType].SMGs.location),
        explosives = #(playerCoords - Config.Locations[Config.MLOType].Explosives.location),
        rifles = #(playerCoords - Config.Locations[Config.MLOType].Rifles.location),
        ammo = #(playerCoords - Config.Locations[Config.MLOType].Ammo.location)
    }
    
    if cooldown and distances[box] <= distanceThreshold and not lootedBoxes[box] then
        lootedBoxes[box] = true
        
        local boxConfig = Config.Crates[box]
        for i = 1, math.random(boxConfig.Amount[1], boxConfig.Amount[2]) do
            local randomItem = boxConfig.Items[math.random(1, #boxConfig.Items)]
            local amount = math.random(1, 1)
            SD.AddItem(source, randomItem, amount)
        end
        Wait(300)
    end
end)

-- Loot giving event for Guard Peds
RegisterNetEvent('sd-bobcat:server:Reward', function()
    local numItems = math.random(Config.Rewards.itemRange.min, Config.Rewards.itemRange.max)

    local rewardsCopy = {}
    local overallWeaponChance = math.random(1, 100)
    local guaranteedWeaponChance = Config.Rewards.weaponChance

    -- Copy rewards configuration
    for k, v in pairs(Config.Rewards) do
        if k ~= 'weaponChance' and k ~= 'itemRange' then
            rewardsCopy[k] = v
        end
    end

    local gunRewards = {}
    for k, reward in pairs(rewardsCopy) do
        if reward.isGunReward then
            gunRewards[k] = reward
            rewardsCopy[k] = nil  -- Remove gun rewards from the rewardsCopy table
        end
    end

    if overallWeaponChance <= guaranteedWeaponChance then
        local selectedGunRewardKey = SD.utils.WeightedChance(gunRewards)
        if selectedGunRewardKey then
            local selectedGunReward = gunRewards[selectedGunRewardKey]
            local itemIndex = math.random(1, #selectedGunReward.items)
            if cooldown and isBobcatPlayer(source) then
            SD.AddItem(source, selectedGunReward.items[itemIndex], 1)
            numItems = numItems - 1
            end
        end
    end

    for i = 1, numItems do
        local selectedRewardKey = SD.utils.WeightedChance(rewardsCopy)
        if selectedRewardKey then
            local selectedReward = rewardsCopy[selectedRewardKey]
            local itemIndex = math.random(1, #selectedReward.items)
            -- Determine item amount.
            local itemAmount = 1  -- Set item amount to 1 by default
            if selectedReward.amount and selectedReward.amount.min and selectedReward.amount.max then
                -- If an amount range is specified, use it to determine the item amount.
                itemAmount = math.random(selectedReward.amount.min, selectedReward.amount.max)
            end
            if cooldown and isBobcatPlayer(source) then
            SD.AddItem(source, selectedReward.items[itemIndex], itemAmount)
            end
        end
    end
end)

spawnedGuards = {}

--- @return nil
RemoveGuards = function()
    for i=1, #spawnedGuards, 1 do
        if DoesEntityExist(spawnedGuards[i]) then
            DeleteEntity(spawnedGuards[i])
        end
    end
    spawnedGuards = {}
end

SpawnGuards = function()
    local netIds = {}
    local netId

    for _, v in pairs(Config.Guards[Config.MLOType]) do
        for _, coord in pairs(v.coords) do
            local ped = Config.PedParameters.Ped or "s_m_y_marine_01"
            local weapon = Config.PedParameters.Weapon[math.random(1, #Config.PedParameters.Weapon)] or GetHashKey("WEAPON_PISTOL")
            local guard = CreatePed(30, GetHashKey(ped), coord.x, coord.y, coord.z, coord.w, true, false)
            GiveWeaponToPed(guard, weapon, 255, false, true)
            local armor = math.random(Config.PedParameters.MinArmor, Config.PedParameters.MaxArmor) or 0
            SetPedArmour(guard, armor)
            spawnedGuards[#spawnedGuards+1] = guard
            while not DoesEntityExist(guard) do Wait(25) end
            netId = NetworkGetNetworkIdFromEntity(guard)
            netIds[#netIds+1] = netId
            Wait(25)
        end
    end

    TriggerClientEvent('sd-bobcat:client:SpawnGuards', -1 ,netIds)
end

RegisterNetEvent('sd-bobcat:server:startCooldown', function()
	cooldown = true 
	local timer = Config.Cooldown * 60000
	print(Lang:t('prints.cooldown_started'))
    SpawnGuards()
	while timer > 0 do 
		Wait(1000)
		timer = timer - 1000
		if timer == 0 then
			print(Lang:t('prints.cooldown_finished'))
			TriggerEvent('sd-bobcat:server:resetVault')
			cooldown = false 
		end 
	end
end)

--- @param playerId number - The players server id
--- @return nil
local RemovePlayer = function(playerId)
    for i=1, #bobcatPlayers do
        if bobcatPlayers[i].id == playerId then
            table.remove(bobcatPlayers, i)
            break
        end
    end
end

--- @param src number
--- @return retval bool 
isBobcatPlayer = function(src)
    local retval = false
    for i=1, #bobcatPlayers do
        if bobcatPlayers[i].id == src then
            retval = true
            break
        end
    end
    return retval
end

AddEventHandler('playerDropped', function()
    local src = source
    if isBobcatPlayer(src) then
        local name = GetPlayerName(src)
        local cid
        for i=1, #bobcatPlayers do
            if bobcatPlayers[i].id == src then
                cid = bobcatPlayers[i].citizenid
                break
            end
        end

        RemovePlayer(src)
    end
end)

RegisterNetEvent('sd-bobcat:server:removePlayer', function()
    local src = source
    RemovePlayer(src)
end)

RegisterNetEvent('sd-bobcat:server:LootGuards', function(netId)
    local Player = SD.GetPlayer(source)
    if not Player then return end

    local guard = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(guard) then
        DeleteEntity(guard)
    end

    TriggerClientEvent('sd-bobcat:client:Reward', source)
end)

-- Reset Vault Event
RegisterNetEvent('sd-bobcat:server:resetVault', function()
    lootedBoxes.smgs = true lootedBoxes.explosives = true lootedBoxes.rifles = true lootedBoxes.ammo = true
    RemoveGuards()
    TriggerClientEvent('sd-bobcat:client:resetVault', -1)
end)

-- Explode Vault Door Sync Event
RegisterNetEvent("sd-bobcat:server:explodeVaultDoorSync", function()
    lootedBoxes.smgs = false lootedBoxes.explosives = false lootedBoxes.rifles = false lootedBoxes.ammo = false
    TriggerClientEvent("sd-bobcat:client:updateIPL", -1)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    RemoveGuards()
end)