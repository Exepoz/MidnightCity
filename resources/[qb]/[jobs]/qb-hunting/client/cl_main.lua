local QBCore = exports['qb-core']:GetCoreObject()

local spawnDistanceRadius = 35
local baitPlaced = false
local spawnedAnimal = nil

local animals = {
    'a_c_deer',
    'a_c_mtlion',
    'a_c_coyote',
    'a_c_boar'
}

--- Functions

local placeBaitAnimation = function()
	local ped = cache.ped

	lib.requestAnimDict('amb@medic@standing@kneel@base', 1500)
    lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 1500)

	TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
	TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0, false, false, false)
end

local slaughterAnimal = function(entity)
	local ped = cache.ped

	if HuntingZone:contains(GetEntityCoords(ped)) then

		if Config.OnlyHuntingRifle and GetPedCauseOfDeath(entity) ~= -1327835241 then
			Utils.Notify(Locales['notify_ruined'], 'error', 2500)
			spawnedAnimal = nil
			baitPlaced = false
			return 
		end
		
		if cache.weapon == `WEAPON_KNIFE` then
			lib.requestAnimDict('amb@medic@standing@kneel@base', 1500)
			lib.requestAnimDict('anim@gangops@facility@servers@bodysearch@', 1500)

			TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0, false, false, false)

			local netId = NetworkGetNetworkIdFromEntity(entity)

			if lib.progressBar({
				duration = 6000,
				label = Locales['progressbar_animal'],
				useWhileDead = false,
				canCancel = true,
				disable = { car = true, move = true, combat = true, mouse = false },
			}) then
				TriggerServerEvent('qb-hunting:server:slaughterAnimal', netId)
				spawnedAnimal = nil
				baitPlaced = false
				ClearPedTasks(ped)
			else
				ClearPedTasks(ped)
				Utils.Notify(Locales['notify_canceled'], 'error', 2500)
			end
		else
			Utils.Notify(Locales['notify_knife'], 'error', 2500)
		end
	else
		Utils.Notify(Locales['notify_cant_hunt'], 'error', 2500)
	end
end

local spawnAnimal = function(baitLocation)
	local offSetX = math.random(-spawnDistanceRadius, spawnDistanceRadius)
	local offSetY = math.random(-spawnDistanceRadius, spawnDistanceRadius)
	local coordZ = GetHeightmapBottomZForPosition(baitLocation.x + offSetX, baitLocation.y + offSetY)
	local modelName = animals[math.random(#animals)]

	RequestModel(modelName)
	while not HasModelLoaded(modelName) do Wait(0) end

	spawnedAnimal = CreatePed(30, GetHashKey(modelName), baitLocation.x + offSetX, baitLocation.y + offSetY, coordZ, 0, true, false)
	TaskGoStraightToCoord(spawnedAnimal, baitLocation, 1.0, -1, 0.0, 0.0)
	SetPedKeepTask(spawnedAnimal, true)
	SetModelAsNoLongerNeeded(modelName)

	CreateThread(function()
		local finished = false

		while not IsPedDeadOrDying(spawnedAnimal) and not finished do
			Wait(100)

			local ped = cache.ped
			local spawnedAnimalCoords = GetEntityCoords(spawnedAnimal)

			-- Animal flees if too close to player
			if #(spawnedAnimalCoords - GetEntityCoords(ped)) < 20.0 then
				Utils.Notify(Locales['notify_spotted'], 'error', 2500)
				ClearPedTasks(spawnedAnimal)
				TaskSmartFleePed(spawnedAnimal, ped, 600.0, -1)
				finished = true
				baitPlaced = false
			end

			-- Animal reaches destination
			if #(spawnedAnimalCoords - baitLocation) < 0.5 then
				lib.requestAnimDict('creatures@deer@amb@world_deer_grazing@base', 1500)
				TaskPlayAnim(spawnedAnimal, 'creatures@deer@amb@world_deer_grazing@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

				Utils.Notify(Locales['notify_shoot'], 'error', 2500)
				Wait(4000)
				ClearPedTasks(spawnedAnimal)

				if not IsEntityDead(spawnedAnimal) then
					Utils.Notify(Locales['notify_spotted'], 'error', 2500)
					Wait(100)
					TaskSmartFleePed(spawnedAnimal, ped, 600.0, -1)
				end

				finished = true
				baitPlaced = false
			end
		end
	end)
end

local placeProp = function(coords)
	local object_model = 'prop_peanut_bowl_01'

	RequestModel(object_model)
	while not HasModelLoaded(object_model) do Wait(10) end
	if not HasModelLoaded(object_model) then
		SetModelAsNoLongerNeeded(object_model)
	else
		local created_object = CreateObjectNoOffset(object_model, coords, 1, 0, 1)
		PlaceObjectOnGroundProperly(created_object)
		FreezeEntityPosition(created_object,true)
		SetModelAsNoLongerNeeded(object_model)
	end
end

--- Events

RegisterNetEvent('qb-hunting:client:Reset', function()
    DeleteEntity(spawnedAnimal)
	baitPlaced = false
	spawnedAnimal = nil

	Utils.Notify(Locales['notify_reset'], 'success', 2500)
end)

RegisterNetEvent('qb-hunting:client:PlaceBait', function()
	local ped = cache.ped

	if HuntingZone:contains(GetEntityCoords(ped)) then
		local day = false
		local hours = GetClockHours()

		if hours > 6 and hours < 23 then day = true end -- Between 6 and 23

        if day then
			if not cache.vehicle then
				if not baitPlaced then
					local baitLocation = GetEntityCoords(ped)

					placeBaitAnimation()

					if lib.progressBar({
						duration = 3500,
						label = Locales['progressbar_bait'],
						useWhileDead = false,
						canCancel = true,
						disable = { car = true, move = true, combat = true, mouse = false },
					}) then
						baitPlaced = true
						Utils.Notify(Locales['notify_bait_placed'], 'success', 2500)
						TriggerServerEvent('qb-hunting:server:removeBait')
						placeProp(baitLocation)
						ClearPedTasks(ped)
						Wait(10 * 1000) -- Timer between placing bait and spawning animal
						spawnAnimal(baitLocation)
					else
						ClearPedTasks(ped)
						Utils.Notify(Locales['notify_canceled'], 'error', 2500)
					end
				else
					Utils.Notify(Locales['notify_already_bait'], 'error', 2500)
				end
			else
				Utils.Notify(Locales['notify_on_bike'], 'error', 2500)
			end
		else
			Utils.Notify(Locales['notify_too_dark'], 'error', 2500)
		end
	else
		Utils.Notify(Locales['notify_cant_hunt'], 'error', 2500)
	end
end)

RegisterNetEvent('qb-hunting:client:sellHuntingItems', function()
	if lib.progressBar({
		duration = 8500,
		label = Locales['progressbar_selling'],
		useWhileDead = false,
		canCancel = true,
		disable = { car = true, move = true, combat = true, mouse = false },
	}) then
		TriggerServerEvent('qb-hunting:server:sellItems')
	else
		Utils.Notify(Locales['notify_canceled'], 'error', 2500)
	end
end)

--- Threads

CreateThread(function()
	-- Blips
	local blip = AddBlipForCoord(Config.Area)
	SetBlipSprite(blip, 141)
	SetBlipColour(blip, 25)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(Locales['blip_area'])
	EndTextCommandSetBlipName(blip)

	local blip2 = AddBlipForRadius(Config.Area, 300.00)
    SetBlipHighDetail(blip2, true)
    SetBlipAlpha(blip2, 100)
    SetBlipColour(blip2, 10)
	
	local blip3 = AddBlipForCoord(Config.Sell.xyz)
	SetBlipSprite(blip3, 463)
	SetBlipColour(blip3, 25)
	SetBlipScale(blip3, 0.8)
	SetBlipAsShortRange(blip3, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(Locales['blip_sale'])
	EndTextCommandSetBlipName(blip3)

	-- Sale Ped
	local pedModel = `csb_chef`
    lib.requestModel(pedModel, 1500)

    local ped = CreatePed(0, pedModel, Config.Sell.x, Config.Sell.y, Config.Sell.z - 1.0, Config.Sell.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

	-- Target
    if Config.Target == 'ox' then
        exports['ox_target']:addLocalEntity(ped, {
            {
                label = Locales['target_sale'],
                name = Locales['target_sale'],
                icon = 'fas fa-paw',
                distance = 1.0,
                event = 'qb-hunting:client:sellHuntingItems',
            }
        })

		if Config.Hunting == 'all' then
			exports['ox_target']:addModel(animals, {
				{
					name = 'hunting_animal',
					icon = 'fas fa-paw',
					label = Locales['target_animal'],
					canInteract = function(entity, distance, coords, name, bone)
						return IsEntityDead(entity)
					end,
					onSelect = function(data)
						slaughterAnimal(data.entity)
					end,
				},
			})
		elseif Config.Hunting == 'bait' then
			exports['ox_target']:addModel(animals, {
				{
					name = 'hunting_animal',
					icon = 'fas fa-paw',
					label = Locales['target_animal'],
					canInteract = function(entity, distance, coords, name, bone)
						return IsEntityDead(entity) and entity == spawnedAnimal
					end,
					onSelect = function(data)
						slaughterAnimal(data.entity)
					end,
				},
			})
		end
    elseif Config.Target == 'qb' then
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = 'client',
                    event = 'qb-hunting:client:sellHuntingItems',
                    icon = 'fas fa-paw',
                    label = Locales['target_sale']
                }
			},
            distance = 1.0
        })

		if Config.Hunting == 'all' then
			exports['qb-target']:AddTargetModel(animals, {
				options = {
					{
						action = function(entity)
							slaughterAnimal(entity)
						end,
						icon = 'fas fa-paw',
						label = Locales['target_animal'],
						canInteract = function(entity)
							return IsEntityDead(entity)
						end,
					}
				},
				distance = 1.5, 
			})
		elseif Config.Hunting == 'bait' then
			exports['qb-target']:AddTargetModel(animals, {
				options = {
					{
						action = function(entity)
							slaughterAnimal(entity)
						end,
						icon = 'fas fa-paw',
						label = Locales['target_animal'],
						canInteract = function(entity)
							return IsEntityDead(entity) and entity == spawnedAnimal
						end,
					}
				},
				distance = 1.5, 
			})
		end
    end
end)
