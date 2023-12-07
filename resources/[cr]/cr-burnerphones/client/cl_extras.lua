---@diagnostic disable: undefined-doc-name
local Box = {}

if Config.DevMode then -- These are used to reset the cooldowns when testing the resource
	LocalPlayer.state:set('inv_busy', false, true)
	LocalPlayer.state:set('burnerphoneCooldown', false, true)
	for k, _ in pairs(Config.Burnerphones) do
		LocalPlayer.state:set('burnerphoneCooldown_'..k, false, true)
	end
end

-- Interaction Function (Either Target or DrawText)
--- @param phone string - Phone Used
--- @param entity number - Object Spawned
--- @param reward number - Reward Chosen
--- @param loc number - Location Chosen
function SetupDropTarget(phone, entity, reward, loc)
	if Config.Framework.Interaction.UseTarget then
		local options = {
			{ name = "searchDrop", type = "client", event = "cr-burnerphones:client:PickUpDrop", onSelect = "cr-burnerphones:client:PickUpDrop", icon = "fa-solid fa-hand", label = Lcl('interact_searchbox'), phone = phone, box = entity, reward = reward, loc = loc },
		}
		if Config.Framework.Interaction.Target == "qb-target" then
			exports['qb-target']:AddEntityZone("burnerphone_"..phone..loc, entity, { name = "burnerphone_"..phone..loc, heading = GetEntityHeading(entity), debugPoly = Config.DebugPoly}, { options = options, distance = 1.5 })
		elseif Config.Framework.Interaction.Target == "oxtarget" then
			exports['ox_target']:addLocalEntity(entity, options)
		elseif Config.Framework.Interaction.Target == "metatarget" then
			target.addLocalEnt({"burnerphone_"..phone..loc, "Package", "fa-solid fa-hand", entity, 1.5, false, options})
		end
	else
		if Config.Framework.Interaction.OxLibDistanceCheck then
			local coords = GetEntityCoords(entity)
			local BoxPoint = lib.points.new(coords, 1.5)
            function BoxPoint:onEnter() BCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_searchbox')) end --47
            function BoxPoint:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then BCUtils.DrawText(false) TriggerEvent('cr-burnerphones:client:PickUpDrop', {phone = phone, box = entity, reward = reward, loc = loc}) end end
            function BoxPoint:onExit() BCUtils.DrawText(false) end
			Box[phone..loc] = BoxPoint
		else
			CreateThread(function()
				local text = false
				local ped = PlayerPedId()
				local target = GetEntityCoords(entity)
				while true do
					local wait = 10000
					local pcoords = GetEntityCoords(ped)
					local dist = #(pcoords - target)
					if not GlobalState.CRBurnerphones.Locations[Config.Burnerphones[phone].DropOffLocations[loc]] then break end
					if dist < 200 then
						wait = 1
					end
					if dist <= 2 then
						if not text then BCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_searchbox')) text = true end
						if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then BCUtils.DrawText(false) TriggerEvent('cr-burnerphones:client:PickUpDrop', {phone = phone, box = entity, reward = reward, loc = loc}) break end
					else
						if text then BCUtils.DrawText(false) text = false end
					end
					Wait(wait)
				end
			end)
		end
	end
end

-- Delete Zones or points
---@param phone string -- Phone used
function DeleteZones(phone, loc)
	if Config.Framework.Interaction.UseTarget then
		local Target = Config.Framework.Interaction.Target
		if Target == "qb-target" then
			exports['qb-target']:RemoveZone("burnerphone_"..phone..loc)
		elseif Target == "metatarget" then
			target.remove("burnerphone_"..phone..loc)
		end
	else
		if Config.Framework.Interaction.OxLibDistanceCheck then
			if Box[phone..loc] then Box[phone..loc]:remove() end
		end
	end
end

RegisterNetEvent('cr-burnerphones:client:callCops')
AddEventHandler('cr-burnerphones:client:callCops', function(coords)
    if Config.Police.Dispatch == "cd" then
        --Code Design Dispatch Call
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.Police.PoliceJobs,
            coords = coords,
            title = Config.Police.TenCode.." - "..Lcl('dispatch_title'),
            message = Lcl('dispatch_message'),
            flash = true,
            unique_id = tostring(math.random(0000000,9999999)),
            blip = {
                sprite = 207,
                scale = 1.1,
                colour = 1,
                flashes = true,
                text = Lcl('dispatch_title'),
                time = (5*60*1000),
                sound = 1,
            }
        })
    elseif Config.Police.Dispatch == "core" then
        --Core Dispatch's Call
        TriggerServerEvent("core_dispatch:addCall", Config.Police.TenCode, Lcl('dispatch_title'),
        {{icon = "fa-solid fa-box"}}, {coords}, Config.Police.PoliceJobs, 5000, 207, 1)

    elseif Config.Police.Dispatch == "ps-dispatch" then
        -- Project Sloth
        exports['ps-dispatch']:CRBurnerphones(coords, Config.Police.TenCode, Lcl('dispatch_message'), Config.Police.PoliceJobs)

    elseif Config.Police.Dispatch == "qb-policejob" then
        -- qb-policejob
        if BCUtils.IsPolice() and BCUtils.OnDuty() then
            TriggerEvent("police:client:policeAlert", coords, Lcl('dispatch_message'))
        end
	elseif Config.Police.Dispatch == "ESX" then
		TriggerServerEvent("dispatch:svNotify", {
			code = Config.Police.TenCode,
			id = math.random(1111,9999),
			priority = 2,
			title = Lcl('dispatch_title'),
			position = { x = coords.x, y = coords.y, z = coords.z },
			blipname = Lcl('dispatch_title'),
			color = 1,
			sprite = 207,
			fadeOut = 30,
			duration = 10000,
			officer = "Dispatch"
		})
    end
end)

--- Random Loot Generation (Based on weight/importance)
---@param phone string -- Phone used
function GenerateLoot(phone)
    local items = Config.Burnerphones[phone].Rewards
    local total_weight = 0
    for _, item in ipairs(items) do
        total_weight = total_weight + item.weight
    end
    local chosenLoot = math.random(total_weight)
    local chosenItem
    for k, item in ipairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end
    return chosenItem
end