Utils = exports['lc_utils']:GetUtils()
truck,truck_blip,trailer,trailer_blip,rent_truck,route_blip = nil,nil,nil,nil,nil,nil
menu_active = false
current_location = nil
loading = false
cooldown = nil

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------	

function createMarkersThread()
	Citizen.CreateThreadNow(function()
		local timer = 2
		while true do
			timer = 3000
			for trucker_location_id,trucker_location_data in pairs(Config.trucker_locations) do
				if not menu_active then
					local x,y,z = table.unpack(trucker_location_data.menu_location)
					if Utils.Entity.isPlayerNearCoords(x,y,z,20.0) then
						timer = 2
						Utils.Markers.createMarkerInCoords(trucker_location_id,x,y,z,Utils.translate('open'),openTruckerUiCallback)
					end
				end
			end
			Citizen.Wait(timer)
		end
	end)
end

function createTargetsThread()
	Citizen.CreateThreadNow(function()
		for trucker_location_id,trucker_location_data in pairs(Config.trucker_locations) do
			local x,y,z = table.unpack(trucker_location_data.menu_location)
			Utils.Target.createTargetInCoords(trucker_location_id,x,y,z,openTruckerUiCallback,Utils.translate('open_target'),"fas fa-truck","#2986cc")
		end
	end)
end

function openTruckerUiCallback(location)
	current_location = location
	TriggerServerEvent("truck_logistics:getData",current_location)
end

RegisterNetEvent('truck_logistics:open')
AddEventHandler('truck_logistics:open', function(dados,update)
	TriggerScreenblurFadeIn(1000)
	SendNUIMessage({
		showmenu = true,
		update = update,
		dados = dados,
		utils = { config = Utils.Config, lang = Utils.Lang },
		resourceName = GetCurrentResourceName()
	})
	if update == false then
		menu_active = true
		SetNuiFocus(true,true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('post', function(body, cb)
	if cooldown == nil then
		cooldown = true
		
		if body.event == "changeTheme" then
			exports['lc_utils']:changeTheme(body.data.dark_theme)
		end
		if body.event == "close" then
			closeUI()
		elseif body.event == "startContract" and loading then
			exports['lc_utils']:notify("info",Utils.translate('loading_trailer'))
			closeUI()
		elseif body.event == "spawnTruck" and loading then
			exports['lc_utils']:notify("info",Utils.translate('loading_truck'))
			closeUI()
		elseif (body.event == "repairTruck" or body.event == "refuelTruck") and (IsEntityAVehicle(truck) and not rent_truck) then
			exports['lc_utils']:notify("error",Utils.translate('store_truck'))
		elseif body.event == "sellTruck" and (IsEntityAVehicle(truck) and not rent_truck) then
			exports['lc_utils']:notify("error",Utils.translate('store_truck_2'))
		else
			TriggerServerEvent('truck_logistics:'..body.event,current_location,body.data)
		end
		cb(200)

		SetTimeout(100,function()
			cooldown = nil
		end)
	end
end)

function closeUI()
	current_location = nil
	menu_active = false
	SetNuiFocus(false,false)
	SendNUIMessage({ hidemenu = true })
	TriggerScreenblurFadeOut(1000)
	TriggerServerEvent('truck_logistics:closeUI')
end

RegisterNetEvent('truck_logistics:closeUIToStartContract')
AddEventHandler('truck_logistics:closeUIToStartContract', function()
	menu_active = false
	SetNuiFocus(false,false)
	SendNUIMessage({ hidemenu = true })
	TriggerScreenblurFadeOut(1000)
	TriggerServerEvent('truck_logistics:closeUI')
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN OWNED TRUCK
-----------------------------------------------------------------------------------------------------------------------------------------
local update_vehicle_status = 0
RegisterNetEvent('truck_logistics:spawnTruck')
AddEventHandler('truck_logistics:spawnTruck', function(truck_data)
	if IsEntityAVehicle(truck) then
		exports['lc_utils']:notify("error",Utils.translate('already_has_truck'))
		return
	end

	Citizen.CreateThreadNow(function()
		resetLoading()
	end)

	loading = true
	local garage_to_spawn = Config.trucker_locations[current_location]['garage_location']
	local i = #garage_to_spawn
	local x,y,z,h
	while i > 0 do
		x,y,z,h = table.unpack(garage_to_spawn[i])
		if not Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001) then
			if i <= 1 then
				exports['lc_utils']:notify("error",Utils.translate('occupied_places'))
				loading = false
				return
			end
		else
			break
		end
		i = i - 1
	end

	truck_data.properties = json.decode(truck_data.properties) or {}
	truck_data.properties.plate = truck_data.properties.plate or Utils.Vehicles.generateTempVehiclePlateWithPrefix(GetCurrentResourceName())
	truck_data.properties.bodyHealth = truck_data.body
	truck_data.properties.engineHealth = truck_data.engine
	truck_data.properties.fuelLevel = truck_data.fuel

	local blip_data = { name = Utils.translate('truck_blip'), sprite = 477, color = 26 }
	truck,truck_blip = Utils.Vehicles.spawnVehicle(truck_data.truck_name,x,y,z,h,blip_data,truck_data.properties)
	if (truck_data.wheels < 400) then
		SetVehicleTyresCanBurst(truck,true)
		local arr = {0,1,2,3,4,5,6,7}
		for _,v in pairs(arr) do
			SetVehicleTyreBurst(truck,v,true,1000.0)
		end
	end
	exports['lc_utils']:notify("success",Utils.translate('already_is_in_garage'))
	loading = false

	local timer = 2
	local engine_health = GetVehicleEngineHealth(truck)
	local vehicle_fuel = GetVehicleFuelLevel(truck)
	local body_health = GetVehicleBodyHealth(truck)

	while IsEntityAVehicle(truck) do
		timer = 2000
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		if veh == truck then
			for _,v in pairs(Config.trucker_locations) do
				for _,mark in pairs(v.garage_location) do
					local x,y,z = table.unpack(mark)
					local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
					if distance <= 20.0 then
						timer = 2
						Utils.Markers.drawMarker(39,x,y,z+0.6,2.0)
						if distance <= 5.0 then
							Utils.Markers.drawText2D(Utils.translate('press_e_to_store_truck'), 8,0.5,0.95,0.50,255,255,255,180)
							if IsControlJustPressed(0,38) and IsEntityAVehicle(truck) then
								TriggerServerEvent("truck_logistics:updateTruckStatus",truck_data,GetVehicleEngineHealth(truck),GetVehicleBodyHealth(truck),vehicle_fuel,Utils.Vehicles.getVehicleProperties(truck))
								Utils.Vehicles.deleteVehicle(truck)
								Utils.Blips.removeBlip(truck_blip)
								truck = nil
								truck_blip = nil
								return
							end
						end
					end
				end
			end
		end

		if IsEntityAVehicle(truck) and update_vehicle_status == 0 and (engine_health ~= GetVehicleEngineHealth(truck) or vehicle_fuel ~= GetVehicleFuelLevel(truck)) then
			update_vehicle_status = 3
			engine_health = GetVehicleEngineHealth(truck)
			body_health = GetVehicleBodyHealth(truck)
			vehicle_fuel = GetVehicleFuelLevel(truck)
			TriggerServerEvent("truck_logistics:updateTruckStatus",truck_data,engine_health,body_health,vehicle_fuel,Utils.Vehicles.getVehicleProperties(truck))
		end
		Citizen.Wait(timer)
	end
	Utils.Vehicles.removeKeysFromPlate(truck_data.properties.plate,truck_data.truck_name)
	Utils.Blips.removeBlip(truck_blip)
	truck = nil
	truck_blip = nil
end)

Citizen.CreateThread(function()
	while true do
		timer = 10000
		if update_vehicle_status > 0 then
			update_vehicle_status = update_vehicle_status - 1
		end
		Citizen.Wait(timer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- START CONTRACT
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('truck_logistics:startContract')
AddEventHandler('truck_logistics:startContract', function(key,contract_data,location)
	local is_finished = false
	local trailer_body = 0
	if not IsEntityAVehicle(trailer) then
		Utils.Vehicles.deleteVehicle(trailer)
		Utils.Blips.removeBlip(trailer_blip)
		Utils.Blips.removeBlip(route_blip)
		trailer = nil
		trailer_blip = nil
		route_blip = nil
		rent_truck = false
	end
	if trailer or rent_truck then
		exports['lc_utils']:notify("error",Utils.translate('already_has_cargo'))
		TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, false)
		return
	end

	if not IsEntityAVehicle(truck) then
		Utils.Vehicles.deleteVehicle(truck)
		Utils.Blips.removeBlip(truck_blip)
		Utils.Blips.removeBlip(route_blip)
		truck = nil
		truck_blip = nil
		route_blip = nil
		rent_truck = false
	end
	if IsEntityAVehicle(truck) and contract_data.contract_type == 0 then
		exports['lc_utils']:notify("error",Utils.translate('must_store_truck'))
		TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, false)
		return
	end

	Citizen.CreateThreadNow(function()
		resetLoading()
	end)

	loading = true
	local x,y,z,h
	local truck_blip_data = { name = Utils.translate('rented_truck_blip'), sprite = 477, color = 26 }
	local truck_properties = { plate = Utils.Vehicles.generateTempVehiclePlateWithPrefix(GetCurrentResourceName()) }
	if contract_data.contract_type == 0 then
		local garagem = Config.trucker_locations[key]['garage_location']
		x,y,z,h = table.unpack(garagem[location])
		if not Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001) then
			local i = #garagem
			while i > 0 do
				x,y,z,h = table.unpack(garagem[i])
				local checkPos = Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001)
				if checkPos == false then
					if i <= 1 then
						exports['lc_utils']:notify("error",Utils.translate('occupied_places'))
						TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, false)
						loading = false
						return
					end
				else
					break
				end
				i = i - 1
			end
		end
		
		truck,truck_blip = Utils.Vehicles.spawnVehicle(contract_data.truck,x,y,z,h,truck_blip_data,truck_properties)
		rent_truck = true
	end
	
	local cargas = Config.trucker_locations[key]['trailer_location']
	x,y,z,h = table.unpack(cargas[location])
	if not Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001) then
		i = #cargas
		while i > 0 do
			x,y,z,h = table.unpack(cargas[i])
			local checkPos = Utils.Vehicles.isSpawnPointClear({['x']=x,['y']=y,['z']=z},5.001)
			if checkPos == false then
				if i <= 1 then
					if rent_truck then
						Utils.Vehicles.deleteVehicle(truck)
						Utils.Blips.removeBlip(truck_blip)
						truck = nil
						truck_blip = nil
						rent_truck = false
					end
					exports['lc_utils']:notify("error",Utils.translate('occupied_places'))
					TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, false)
					loading = false
					return
				end
			else
				break
			end
			i = i - 1
		end
	end

	local trailer_blip_data = { name = Utils.translate('cargo_blip'), sprite = 479, color = 26 }
	local trailer_properties = { plate = Utils.Vehicles.generateTempVehiclePlateWithPrefix(GetCurrentResourceName()) }
	trailer,trailer_blip = Utils.Vehicles.spawnVehicle(contract_data.trailer,x,y,z,h,trailer_blip_data,trailer_properties)
	exports['lc_utils']:notify("success",Utils.translate('started_job'))
	loading = false

	createVehicleMarkersThread()

	TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, true)

	if contract_data.external_data then
		x,y,z,h = contract_data.external_data.x,contract_data.external_data.y,contract_data.external_data.z,contract_data.external_data.h
	else
		x,y,z,h = table.unpack(Config.delivery_locations[contract_data.coords_index])
	end

	route_blip = Utils.Blips.createBlipForCoords(x,y,z,1,5,Utils.translate('destination_blip'),1.0,true)

	closeUI()

	local timer = 2000
	while IsEntityAVehicle(trailer) do
		timer = 2000
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		local distance = #(GetEntityCoords(ped) - vector3(x,y,z))

		if distance <= 50.0 then
			timer = 2
			if distance <= 4.0 and GetEntityHeading(veh) + 10 >= h and GetEntityHeading(veh) - 10 <= h and GetEntityHeading(trailer) + 10 >= h and GetEntityHeading(trailer) - 10 <= h and IsEntityAttachedToEntity(veh,trailer) then
				DrawMarker(30,x,y,z-0.6,0,0,0,90.0,h,0.0,3.0,1.0,10.0,0,255,0,50,0,0,0,0)
				Utils.Markers.drawText2D(Utils.translate('press_e_to_park'), 8,0.5,0.90,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) then
					BringVehicleToHalt(truck, 2.5, 1, false)
					Citizen.Wait(10)
					DoScreenFadeOut(500)
					Citizen.Wait(500)
					trailer_body = GetVehicleBodyHealth(trailer)
					Utils.Vehicles.deleteVehicle(trailer)
					Utils.Blips.removeBlip(trailer_blip)
					Utils.Blips.removeBlip(route_blip)
					TriggerServerEvent("truck_logistics:deliveredCargo")
					PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
					Citizen.Wait(1000)
					DoScreenFadeIn(1000)
					Utils.Scaleform.showScaleform(Utils.translate('success'), Utils.translate('finished_job'), 3)
					trailer = nil
					trailer_blip = nil
					route_blip = nil
					if not Config.jobs.must_bring_truck_back or contract_data.contract_type ~= 0 then
						TriggerServerEvent("truck_logistics:finishContract",GetVehicleEngineHealth(truck),GetVehicleBodyHealth(truck),trailer_body)
					end
					is_finished = true
					break
				end
			else
				Utils.Markers.drawText2D(Utils.translate('park_your_truck'), 8,0.5,0.90,0.50,255,255,255,180)
				DrawMarker(30,x,y,z-0.6,0,0,0,90.0,h,0.0,3.0,1.0,10.0,255,0,0,50,0,0,0,0)
			end
		end

		local vehicles = { truck, trailer }
		local peds = { ped }
		local has_error, error_message = Utils.Entity.isThereSomethingWrongWithThoseBoys(vehicles,peds)
		if has_error then
			PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
			exports['lc_utils']:notify("error",Utils.translate('failed'))
			
			Utils.Blips.removeBlip(trailer_blip)
			Utils.Blips.removeBlip(route_blip)
			Utils.Vehicles.deleteVehicle(trailer)
			trailer = nil
			trailer_blip = nil
			route_blip = nil
			break
		end

		if IsControlPressed(0,Config.jobs['cancel_job']) then
			TriggerEvent('truck_logistics:cancelContract',contract_data)
			break
		end
		Wait(timer)
	end

	while IsEntityAVehicle(truck) and contract_data.contract_type == 0 do 
		timer = 2000
		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped,false)
		for k,v in pairs(Config.trucker_locations) do
			for k,mark in pairs(v.garage_location) do
				local x,y,z = table.unpack(mark)
				local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
				timer = 2
				if veh == truck and distance <= 20.0 then
					Utils.Markers.drawMarker(39,x,y,z+0.6,2.0)
					if distance <= 5.0 then
						Utils.Markers.drawText2D(Utils.translate('press_e_to_store_truck'), 8,0.5,0.95,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							if Config.jobs.must_bring_truck_back and is_finished then
								TriggerServerEvent("truck_logistics:finishContract",GetVehicleEngineHealth(truck),GetVehicleBodyHealth(truck),trailer_body)
							end
							Utils.Vehicles.deleteVehicle(truck)
							Utils.Blips.removeBlip(truck_blip)
							Utils.Blips.removeBlip(route_blip)
							truck = nil
							truck_blip = nil
							route_blip = nil
							rent_truck = false
						end
					end
				else
					Utils.Markers.drawText2D(Utils.translate('bring_back'), 8,0.5,0.90,0.50,255,255,255,180)
				end
			end
		end

		local vehicles = { truck }
		local peds = { ped }
		local has_error, error_message = Utils.Entity.isThereSomethingWrongWithThoseBoys(vehicles,peds)
		if has_error then
			PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
			exports['lc_utils']:notify("error",Utils.translate('failed'))
			break
		end

		Wait(timer)
	end

	Utils.Vehicles.removeKeysFromPlate(truck_properties.plate,contract_data.truck)
	Utils.Vehicles.removeKeysFromPlate(trailer_properties.plate,contract_data.trailer)
	TriggerEvent('truck_logistics:cancelContract',contract_data)
	TriggerServerEvent('truck_logistics:updateContract',contract_data.contract_id, false)
end)

RegisterNetEvent('truck_logistics:cancelContract')
AddEventHandler('truck_logistics:cancelContract', function(contract_data)
	Utils.Vehicles.deleteVehicle(trailer)
	Utils.Blips.removeBlip(trailer_blip)
	Utils.Blips.removeBlip(route_blip)
	trailer = nil
	trailer_blip = nil
	route_blip = nil
	rent_truck = false
	if contract_data.contract_type == 0 then
		Utils.Vehicles.deleteVehicle(truck)
		Utils.Blips.removeBlip(truck_blip)
		truck = nil
		truck_blip = nil
	end
end)

function createVehicleMarkersThread()
	Citizen.CreateThreadNow(function()
		local timer = 2000
		local ped = PlayerPedId()
		while IsEntityAVehicle(truck) or IsEntityAVehicle(trailer) do
			timer = 2000
			local player_coords = GetEntityCoords(ped)
			local truck_coords = GetEntityCoords(truck)
			local trailer_coods = GetEntityCoords(trailer)
			
			local distance_truck = #(player_coords - truck_coords)
			local distance_trailer = #(player_coords - trailer_coods)
			if distance_truck < 50.0 and GetVehiclePedIsIn(ped,false) ~= truck and not IsEntityAttachedToEntity(truck,trailer) then
				timer = 5
				local tx,ty,tz = table.unpack(truck_coords)
				Utils.Markers.drawMarker(0,tx,ty,tz+3.1,1.0,0,100,255)
			end

			if distance_trailer < 50.0 and (not IsEntityAttachedToEntity(truck,trailer) or GetVehiclePedIsIn(ped,false) ~= truck) then
				timer = 5
				local tx,ty,tz = table.unpack(trailer_coods)
				Utils.Markers.drawMarker(0,tx,ty,tz+3.6,1.0,0,100,255)
			end
			
			Wait(timer)
		end
	end)
end

function resetLoading()
	Citizen.Wait(50000)
	if loading == true then
		exports['lc_utils']:notify("error",Utils.translate('loading_fail'))
		loading = false
	end
end

Citizen.CreateThread(function()
	for _,trucker_location_data in pairs(Config.trucker_locations) do
		local x,y,z = table.unpack(trucker_location_data.menu_location)
		Utils.Blips.createBlipForCoords(x,y,z,trucker_location_data.blips.id,trucker_location_data.blips.color,trucker_location_data.blips.name,trucker_location_data.blips.scale,false)
	end
end)

RegisterNetEvent('truck_logistics:Notify')
AddEventHandler('truck_logistics:Notify', function(type,message)
	exports['lc_utils']:notify(type,message)
end)

Citizen.CreateThread(function()
	Wait(1000)
	SetNuiFocus(false,false)

	Utils.loadLanguageFile(Lang)

	if Utils.Config.custom_scripts_compatibility.target == "disabled" then
		createMarkersThread()
	else
		createTargetsThread()
	end
end)