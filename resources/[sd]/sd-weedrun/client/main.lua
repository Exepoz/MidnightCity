local QBCore = exports['qb-core']:GetCoreObject()

local weedAttach = {
	['animDict'] = 'anim@heists@narcotics@trash',
	['animName'] = 'drop_side',
	['model'] = 'hei_prop_heist_weed_block_01',
	['bone'] = 28422,
	['x'] = 0.01,
	['y'] = -0.02,
	['z'] = -0.12,
	['xR'] = 0.0,
	['yR'] = 0.0,
	['zR'] = 0.0,
	['vertexIndex'] = 0,
}

local isOnDeliveryTask = false
local CurrentDeliveryNPC = nil
local finishedDelivery = 0
local currentCollected = 0
local maxCollect = 5

delievered = true

gettingBox = false
amountOfBox = 0

local spawnedPeds = {}

local CurrentCops = 0

local bliptable = {}

-- Cop Minimum Amount

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- Blip Creation
CreateThread(function()
    if Config.Blip.Enable then
        local blip = AddBlipForCoord(GlobalState.WeedBossLocation)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, Config.Blip.Display)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.Colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Ped Creation
function CreatePedAtCoords(pedModel, coords)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
    QBCore.Functions.LoadModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z, coords.w, false, false)
    FreezeEntityPosition(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)

	AddEventHandler("onResourceStop", function(resource)
        if resource == GetCurrentResourceName() then
            DeleteEntity(ped)
        end
    end)

    return ped
end

CreateThread(function()
    while not GlobalState.WeedBossLocation do Wait(0) end
    local ped = CreatePedAtCoords(Config.BossPed, GlobalState.WeedBossLocation)
end)

-- Target Exports

CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.BossPed, {
        options = {
            { 
				type = "client",
				event = "sd-weedrun:client:checkitem",
				icon = "fas fa-circle",
				label = Lang:t("target.weedboss"),

            },
            { 
                type = "client", 
				event = "sd-weedrun:client:packagegoods",
				icon = "fas fa-box",
				label = Lang:t("target.package_goods"),
			},
			
        },
        distance = 3.0 
    })

end)

-- Police Alert

function policeAlert()
	-- exports['qb-dispatch']:Weed() -- Project-SLoth qb-dispatch
	-- TriggerServerEvent('police:server:policeAlert', 'Suspicious Hand-off') -- Regular qbcore
	-- These are just examples, you will have to implement your own system!
end

-- Sign in Event

RegisterNetEvent('sd-weedrun:client:checkitem')
AddEventHandler('sd-weedrun:client:checkitem', function()
		QBCore.Functions.TriggerCallback('sd-weedrun:server:haspackage', function(hasItem)
        if hasItem then
            TriggerEvent('sd-weedrun:client:start')
        else
			QBCore.Functions.Notify(Lang:t("error.no_packages"), 'error')
        end
	end)
end)

RegisterNetEvent('sd-weedrun:client:start', function ()
    QBCore.Functions.TriggerCallback("sd-weedrun:server:getCops", function(enoughCops)
        if enoughCops >= Config.MinimumPolice then
            QBCore.Functions.TriggerCallback("sd-weedrun:server:coolc",function(isCooldown)
                if not isCooldown then
					if Config.EnableAnimation then
						TriggerEvent('animations:client:EmoteCommandStart', {Config.Animation})
					end
                    QBCore.Functions.Progressbar("search_register", Lang:t("progress.preparing_run"), 5000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                    }, {}, {}, function() -- Done
						if Config.EnableAnimation then
							TriggerEvent('animations:client:EmoteCommandStart', {"c"})
						end
                        TriggerServerEvent('sd-weedrun:server:startr')
                    end, function() -- Cancel
                        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                    end)
                else
                    QBCore.Functions.Notify(Lang:t("error.someone_recently_did_this"), 'error')
                end            
            end)
        else
            QBCore.Functions.Notify(Lang:t("error.cannot_do_this_right_now"), 'error')
        end
    end)
end)

-- Sign Out Event

RegisterNetEvent('sd-weedrun:client:signoff', function()

	exports['qb-target']:RemoveTargetModel(Config.BossPed, {
		Lang:t("target.weedboss")
	})

	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				type = "client",
				event = "sd-weedrun:client:endRun",
				icon = "fas fa-circle",
				label = Lang:t("target.sign_out_target"),

			}
		},
		distance = 2.0
	})
end)

-- Sign In Event on Cooldown

RegisterNetEvent('sd-weedrun:signin', function()
	exports['qb-target']:RemoveTargetModel(Config.BossPed, {
		Lang:t("target.sign_out_target")
	})

	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				type = "client",
				event = "sd-weedrun:client:endRun2",
				icon = "fas fa-circle",
				label = Lang:t("target.sign_out_target2"),
	
			}
		},
		distance = 2.0
	})
end)

-- Sign Off Event after Cooldown

RegisterNetEvent('sd-weedrun:client:endRun2', function()  
	ClearAllBlipRoutes()

	for _,v in pairs(bliptable) do
		RemoveBlip(v)
	end

	QBCore.Functions.Notify(Lang:t("error.sign_out"), 'error')

	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				type = "client",
				event = "sd-weedrun:client:checkitem",
				icon = "fas fa-circle",
				label = Lang:t("target.weedboss"),
	
			}
		},
		distance = 2.0
	})

	exports['qb-target']:RemoveTargetModel(Config.BossPed, {
		Lang:t("target.sign_out_target2")
	})

end)

-- Sign On Event on Cooldown

RegisterNetEvent('sd-weedrun:client:endRun', function()  
	ClearAllBlipRoutes()

	for _,v in pairs(bliptable) do
		RemoveBlip(v)
	end

	DeleteEntity(CurrentDeliveryNPC)
	DeleteEntity(weedObject)

	if Config.EnableCooldown then
	TriggerServerEvent('sd-weedrun:server:signoff')
	end

	QBCore.Functions.Notify(Lang:t("error.sign_out"), 'error')

exports['qb-target']:AddTargetModel(Config.BossPed, {
	options = {
		{
			type = "client",
			event = "sd-weedrun:client:checkitem",
			icon = "fas fa-circle",
			label = Lang:t("target.weedboss"),

		}
	},
	distance = 2.0
})

exports['qb-target']:RemoveTargetModel(Config.BossPed, {
	Lang:t("target.sign_out_target")
})

end)

-- Weed Run Main

RegisterNetEvent('sd-weedrun:client:itemcheck', function()
			QBCore.Functions.TriggerCallback("sd-weedrun:server:haspackage", function(cb)
				if cb then
					hasWeedPackage = true
				else
					hasWeedPackage = false
				end
			end, Config.Item)
		end)

RegisterNetEvent('sd-weedrun:client:nextdelivery', function()
	ClearAllBlipRoutes()
	for _,v in pairs(bliptable) do
		RemoveBlip(v)
	end
	
	if finishedDelivery ~= 10 then
		isOnDeliveryTask = false
	Wait(500)
	
if hasWeedPackage then 
		QBCore.Functions.Notify(Lang:t("success.nextlocation"), 'success')
		TriggerEvent('sd-weedrun:client:generateloc')
else 
	QBCore.Functions.Notify(Lang:t("error.nomorepackages"), 'error')
	exports['qb-target']:RemoveTargetModel(Config.BossPed, {
		Lang:t("target.sign_out_target")
	})

	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				type = "client",
				event = "sd-weedrun:client:checkitem",
				icon = "fas fa-circle",
				label = Lang:t("target.weedboss"),
	
			}
		},
		distance = 2.0
	})
	isOnDeliveryTask = false
	delievered = false
end
	else
		exports['qb-target']:RemoveTargetModel(Config.BossPed, {
			Lang:t("target.sign_out_target")
		})
	
		exports['qb-target']:AddTargetModel(Config.BossPed, {
			options = {
				{
					type = "client",
					event = "sd-weedrun:client:checkitem",
					icon = "fas fa-circle",
					label = Lang:t("target.weedboss"),
		
				}
			},
			distance = 2.0
		})
		
 QBCore.Functions.Notify(Lang:t("success.finished"), 'success')
	end
end)

RegisterNetEvent('sd-weedrun:client:generateloc', function()
	delievered = false
	ClearAllBlipRoutes()
	for _,v in pairs(bliptable) do
		RemoveBlip(v)
	end
	CreateThread(function()
		while true do
			Wait(200)
			if IsPedInAnyVehicle(PlayerPedId()) then
				isOnDeliveryTask = true
				break
			end
		end
	end)

	local hash, name = PedReturn()
	local generateCoords_i = genCoord()
	local generateCoords = Config.handoffPeds[generateCoords_i].coords

	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(1) 
	end

	blipolustur(generateCoords.x, generateCoords.y, 514, 25, 0.7, 'Client')

	Wait(20000)
	DeleteEntity(CurrentDeliveryNPC)
	DeleteObject(weedObject)
  
	CurrentDeliveryNPC = CreatePed(4, hash, generateCoords.x, generateCoords.y, generateCoords.z, generateCoords.w, true, false)
	SetEntityInvincible(CurrentDeliveryNPC, true)
	SetBlockingOfNonTemporaryEvents(CurrentDeliveryNPC, true)

	exports['qb-target']:AddTargetEntity(CurrentDeliveryNPC, {
		options = {
			{
				event = "sd-weedrun:client:deliverPackage",
				icon = "fas fa-hand-holding",
				label = Lang:t("target.deliver_package"),
				coords_i = generateCoords_i,

				canInteract = function()
					if delievered then return true else return false end 
				end

			}
		},
		distance = 2.0
	})
	Wait(3000)
	delievered = true
end)

PedReturn = function()
	local peds = {
		'ig_money',
		'a_m_y_beachvesp_02',
		'a_m_y_breakdance_01',
		'ig_car3guy1',
		'a_m_y_business_03',
		's_m_m_cntrybar_01',
		'ig_devin',
		'ig_dreyfuss',
		'a_m_m_fatlatin_01',
		'u_m_y_baygor',
	}
	local generateModel = math.random(1, #peds)
	local retval = GetHashKey(peds[generateModel])
	return retval, peds[generateModel]
end

genCoord = function()
	local loc = math.random(1, #Config.handoffPeds)

	ClearAllBlipRoutes()

	repeat 
		loc = math.random(1, #Config.handoffPeds)
		Wait(0) 
	until Config.handoffPeds[loc].available


	TriggerServerEvent('sd-weedrun:server:setLocationAvailable', loc, false)

	local retval = loc
	return retval
end

LoadPropDict = function(model)
	while not HasModelLoaded(GetHashKey(model)) do
		RequestModel(GetHashKey(model))
		Wait(10)
	end
end

loadAnimDict = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(1)
	end
end

function blipolustur(x, y, sprite, colour, scale, text)
	local blip = AddBlipForCoord(x, y)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, 11)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, scale)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, true)
	table.insert(bliptable, blip)
end

RegisterNetEvent('onReceiveItem', function(item, amount, nonStacking, itemdata)
	if item == Config.Item then
		local Prop = "hei_prop_heist_box"
		local bone = 60309
		PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack({0.025, 0.08, 0.255, -145.0, 290.0, 0.0})
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		if not HasModelLoaded(Prop) then
			LoadPropDict(Prop)
		end
		prop = CreateObject(GetHashKey(Prop), x, y, z+0.2, true, true, true)
		AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), bone), PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6, true, true, false, true, 1, true)
		SetModelAsNoLongerNeeded(Prop)
		elimde = true
		CreateThread(function()
			while collected do
				if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 1) then
					loadAnimDict("anim@heists@box_carry@") 
					TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 51, 0, false, false, false)
				end

				if not collected then
					return
				end
				Wait(500)
			end
		end)
	end 
end)

-- Weed Packaging

RegisterNetEvent('sd-weedrun:client:packagegoods', function()
    itemsProcessed = false
    for item, amount in pairs(Config.Items) do
        if Config.ItemEvents == 'new' then
          if exports[Config.Inventory]:HasItem(item, amount) and not itemsProcessed then
            exports['qb-target']:RemoveTargetModel(Config.BossPed, {
                Lang:t("target.package_goods"),
            })

            QBCore.Functions.Notify(Lang:t("success.stay_near"), 'success')
            -- Wait(1000)
            TriggerServerEvent('sd-weedrun:server:processWeed', item, amount)
            itemsProcessed = true
		end
        elseif Config.ItemEvents == 'old' then
            if QBCore.Functions.HasItem(item, amount) and not itemsProcessed then
              exports['qb-target']:RemoveTargetModel(Config.BossPed, {
                  Lang:t("target.package_goods"),
              })

              QBCore.Functions.Notify(Lang:t("success.stay_near"), 'error')
              -- Wait(1000)
              TriggerServerEvent('sd-weedrun:server:processWeed', item, amount)
              itemsProcessed = true
            end
	    end
	end
	if not itemsProcessed then QBCore.Functions.Notify(Lang:t("error.no_green"), 'error') end
end)

RegisterNetEvent('now-can-collect-package', function()
	QBCore.Functions.Notify(Lang:t("success.collect_package"), 'success')
	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				event = "collect-weed",
				icon = "fas fa-box",
				label = Lang:t("target.collect_goods"),
			}
		},
		distance = 2.0
	})
end)

RegisterNetEvent('collect-weed', function()

	exports['qb-target']:AddTargetModel(Config.BossPed, {
		options = {
			{
				event = "sd-weedrun:client:packagegoods",
				icon = "fas fa-box",
				label = Lang:t("target.package_goods"),
			}
		},
		distance = 2.0
	})

	TriggerServerEvent('sd-weedrun:server:packagereward')

end)


RegisterNetEvent('sd-weedrun:client:removetarget', function()
	exports['qb-target']:RemoveTargetModel(Config.BossPed, {
		Lang:t("target.collect_goods"),
	})
end)

RegisterNetEvent("sd-weedrun:client:deliverPackage", function(args)
	if holdingBox then
		PlayAmbientSpeech1(CurrentDeliveryNPC, 'Chat_State', 'Speech_Params_Force')
		TaskTurnPedToFaceEntity(CurrentDeliveryNPC, PlayerPedId(), 0)
		holdingBox = false
		delievered = false

		QBCore.Functions.Progressbar("search_register", Lang:t("progress.weighing_package"), 2500, false, false, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
		}, {}, {}, function() -- Done

		TriggerServerEvent('remove-package')
		PlayAmbientSpeech1(CurrentDeliveryNPC, 'GENERIC_THANKS', 'Speech_Params_Force')
		TriggerEvent('animations:client:EmoteCommandStart', {"c"})

		QBCore.Functions.Progressbar("search_register", Lang:t("progress.counting_bills"), 2500, false, false, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {

		}, {}, {}, function() -- Done

			if math.random(1,100) <= Config.CallCopsChance then
				policeAlert()
			end
                
			RequestAnimDict('anim@heists@box_carry@')
			while not HasAnimDictLoaded('anim@heists@box_carry@') do
				Wait(0)
			end
			ClearPedTasksImmediately(CurrentDeliveryNPC)
			RequestModel(weedAttach.model)
			while not HasModelLoaded(weedAttach.model) do
				Wait(0)
			end
			local plyCoords = GetEntityCoords(PlayerPedId())
			local weedObject = CreateObjectNoOffset(weedAttach.model, plyCoords.x, plyCoords.y, plyCoords.z - 5.0, 1, 1, 0)
			-- SetObjectAsNoLongerNeeded(weedObject)
			AttachEntityToEntity(
				weedObject, CurrentDeliveryNPC, GetPedBoneIndex(CurrentDeliveryNPC, weedAttach.bone), 
				weedAttach.x, weedAttach.y, weedAttach.z, weedAttach.xR, weedAttach.yR, weedAttach.zR, 1, 1, 0, 0, 2, 1
			)
			TaskPlayAnim(CurrentDeliveryNPC, 'anim@heists@box_carry@', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			TaskWanderStandard(CurrentDeliveryNPC, 10.0, 10)
			finishedDelivery = finishedDelivery + 1
			
		    TriggerServerEvent('package-delivered', args.coords_i)

			Wait(20000)
			DeleteObject(weedObject)


	end)
end)

	else
		QBCore.Functions.Notify(Lang:t("error.no_package"), 'error')
	end
end)

RegisterNetEvent("sd-weedrun:client:haspackage")
AddEventHandler("sd-weedrun:client:haspackage", function()
	local ped = PlayerPedId()

	QBCore.Functions.TriggerCallback('sd-weedrun:server:haspackage', function(hasItems)
		if hasItems then
			TriggerEvent('animations:client:EmoteCommandStart', {"weedbox"})
			holdingBox = true
		elseif holdingBox and not hasItems then
			TriggerEvent('animations:client:EmoteCommandStart', {"weedbox"})
			Wait(250)
			TriggerEvent('animations:client:EmoteCommandStart', {"c"})
			holdingBox = false
		end
	end)
end)
 
-- Resource Cleanup

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName()
    then

			exports['qb-target']:RemoveTargetModel(Config.BossPed, {
				Lang:t("target.sign_out_target")
			})

			exports['qb-target']:RemoveTargetModel(Config.BossPed, {
				Lang:t("target.sign_out_target2")
			})

			DeleteEntity(CurrentDeliveryNPC)
			DeleteEntity(weedObject)

        end
    end)

RegisterNetEvent('sd-weedrun:client:setLocationAvailable', function(loc, available)
	Config.handoffPeds[loc].available = available
end)

-- E-Mail Creation

RegisterNetEvent('sd-weedrun:client:email', function() 
	if Config.SendEmail then
		QBCore.Functions.Notify(Lang:t("success.send_email_right_now"), 'success')
	RunStart()
	end
end)

function RunStart()
	Citizen.Wait(2000)
	TriggerServerEvent('qb-phone:server:sendNewMail', {
	sender = Lang:t('mailstart.sender'),
	subject = Lang:t('mailstart.subject'),
	message = Lang:t('mailstart.message'),
	})
	Citizen.Wait(3000)
end
