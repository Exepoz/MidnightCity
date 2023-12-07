QBCore = exports['qb-core']:GetCoreObject()

yatakta = false
onDuty = false

local sebil = false
local inCoffe = false
local kahve = false
local inelevator = false
local photoactive = false
local photoprop = nil
local kartaktif = false
local LLANG = LANG[Config.Locale]

local function WertSharedRequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

local function disablemrxrayactions()
	DisableControlAction(0, 24, true) -- Attack
	DisableControlAction(0, 257, true) -- Attack 2
	DisableControlAction(0, 25, true) -- Aim
	DisableControlAction(0, 263, true) -- Melee Attack 1
	DisableControlAction(0, 56, true) -- F9
	DisableControlAction(0, 45, true) -- Reload
	DisableControlAction(0, 22, true) -- Jump
	DisableControlAction(0, 44, true) -- Cover
	DisableControlAction(0, 37, true) -- Select Weapon
	DisableControlAction(0, 288,  true) --F1
	DisableControlAction(0, 289, true) -- F2
	DisableControlAction(0, 170, true) -- F3
	DisableControlAction(0, 167, true) -- F6
	DisableControlAction(0, 244, true) -- m
	DisableControlAction(0, 0, true) -- Disable changing view
	DisableControlAction(0, 26, true) -- Disable looking behind
	DisableControlAction(0, 73, true) -- Disable clearing animation
	DisableControlAction(2, 199, true) -- Disable pause screen
	DisableControlAction(0, 59, true) -- Disable steering in vehicle
	DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
	DisableControlAction(0, 72, true) -- Disable reversing in vehicle
	DisableControlAction(0, 47, true)  -- Disable weapon
	DisableControlAction(0, 264, true) -- Disable melee
	DisableControlAction(0, 257, true) -- Disable melee
	DisableControlAction(0, 140, true) -- Disable melee
	DisableControlAction(0, 141, true) -- Disable melee
	DisableControlAction(0, 142, true) -- Disable melee
	DisableControlAction(0, 143, true) -- Disable melee
	DisableControlAction(0, 75, true)  -- Disable exit vehicle
	DisableControlAction(0, 301, true)  -- Disable exit vehicle
	DisableControlAction(27, 75, true) -- Disable exit vehicle
	DisableControlAction(0, 157, true) -- 1
	DisableControlAction(0, 158, true) -- 2
	DisableControlAction(0, 160, true) -- 3
	DisableControlAction(0, 164, true) -- 4
	DisableControlAction(0, 165, true) -- 5
end

local function goxrayormrbed(type, coord)
    local playerPed = PlayerPedId()
	if type == "yat" then
		yatakta = true
		SetEntityCoords(playerPed, coord.x, coord.y, coord.z)
		SetEntityHeading(playerPed, coord.w)
		FreezeEntityPosition(playerPed, true)
		WertSharedRequestAnimDict("anim@gangops@morgue@table@", function()
			TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "ko_front", 8.0, 8.0, -1, 33, 0, 0, 0, 0)
		end)
		CreateThread(function()
			while yatakta do
				if not IsEntityPlayingAnim(playerPed, "anim@gangops@morgue@table@", "ko_front", 3) then
					WertSharedRequestAnimDict("anim@gangops@morgue@table@", function()
						TaskPlayAnim(playerPed, "anim@gangops@morgue@table@", "ko_front", 8.0, 8.0, -1, 33, 0, 0, 0, 0)
					end)
				end
				DisablePlayerFiring(playerPed, true)
				SetPedCanPlayGestureAnims(playerPed, false)
				disablemrxrayactions()
				Wait(1)
			end
		end)
	elseif type == "kalk" then
		yatakta = false
		ClearPedTasks(playerPed)
		FreezeEntityPosition(playerPed, false)
	end
end

local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    onDuty = PlayerData.job.onduty
end)

RegisterNetEvent("wert-ambulancejob:open-shop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "ambulance", Config.Items)
end)

RegisterNetEvent("wert-ambulancejob:duty-action", function()
    onDuty = not onDuty
	TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent("wert-ambulancejob:open-stash", function()
    TriggerEvent("inventory:client:SetCurrentStash", "EmsStash")
	TriggerServerEvent("inventory:server:OpenInventory", "stash", "EmsStash", {
		maxweight = 2000000,
		slots = 100,
	})
end)


RegisterNetEvent("wert-ambulancejob:ambulance-bill", function()
    QBCore.Functions.TriggerCallback('wert-ambulancejob:server:get-players-coords', function(result)
        local Menu = {
            {
                header = LLANG["selectbillplayer"],
                isMenuHeader = true
            }
        }
        for k,v in pairs(result) do
            Menu[#Menu+1] = {
                header = v,
                txt = "",
                params = {
                    event = "wert-ambulancejob:send-bill",
                    args = {
                        id = k
                    }
                }
            }
        end
        if #Menu > 1 then
            exports['qb-menu']:openMenu(Menu)
        else
            QBCore.Functions.Notify(LLANG["closestplayererror"], 'error')
        end
    end, 8, GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent("wert-ambulancejob:send-bill", function(data) 
    local dialog = exports['qb-input']:ShowInput({
        header = LLANG["billheader"],
        submitText = LLANG["confirm"],
        inputs = {
            {
                text = LLANG["billprice"], -- text you want to be displayed as a place holder
                name = "billprice", -- name of the input should be unique otherwise it might override
                type = "number", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
                isRequired = true -- Optional [accepted values: true | false] but will not submit the form if no value is inputted
            },
        },
    })
    if dialog ~= nil then
        local amount = tonumber(dialog.billprice)
        if amount ~= nil then
            QBCore.Functions.Notify(LLANG["billsended"] .. "" .. amount)
            TriggerServerEvent('wert-ambulancejob:send-bill', data.id, amount)
        else
            QBCore.Functions.Notify(LLANG["billinvalid"], "error")
        end
    end
end)

RegisterNetEvent("wert-ambulancejob:patient-save", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "System",
    })
end)

-- Mr
RegisterNetEvent("wert-ambulancejob:mr-panel", function()
    local checkcoord = vector3(Config.MrCoord.x, Config.MrCoord.y, Config.MrCoord.z)
    local dialogtwo = exports['qb-input']:ShowInput({
        header = "MRI",
        submitText = LLANG["confirm"],
        inputs = {
            {
                text = LLANG["selectplan"],
                name = "plan",
                type = "select",
                options = {
                    { value = "beyin", text = "Brain" },
                    { value = "kalca", text = "Pelvis" },
                    { value = "tabdomen", text = "Total abdomen" },
                    { value = "tchest", text = "Total toraks" },
                    { value = "elbilek", text = "Wrist" },
                    { value = "omuz", text = "Shoulder" },
                    { value = "diz", text = "Knee joint" },
                    { value = "tboyun", text = "Total kollum" },
                    { value = "hipofiz", text = "Pituitary" },
                }
            },
        },
    })
    if dialogtwo ~= nil then
        local selecetedmenu = tostring(dialogtwo.plan)
        if selecetedmenu and selecetedmenu ~= "" then
            QBCore.Functions.TriggerCallback('wert-ambulancejob:server:get-players-coords', function(result)
                local Menu = {
                    {
                        header = LLANG["selectpatient"],
                        isMenuHeader = true
                    }
                }
                for k,v in pairs(result) do
                    Menu[#Menu+1] = {
                        header = v,
                        txt = "",
                        params = {
                            event = "wert-ambulancejob:client:mr-start",
                            args = {
                                id = k,
                                plan = selecetedmenu,
                                isim = v,
                            }
                        }
                    }
                end
                exports['qb-menu']:openMenu(Menu)
            end, 10, checkcoord)
        else
            QBCore.Functions.Notify(LLANG["invalidplan"], "error")
        end
    end
end)

RegisterNetEvent("wert-ambulancejob:mr", function(action)
    goxrayormrbed(action, Config.MrCoord)
end)

RegisterNetEvent("wert-ambulancejob:xray", function(action)
    goxrayormrbed(action, Config.Xray)
end)

RegisterNetEvent("wert-ambulancejob:xray-panel", function()
    local checkcoord = vector3(Config.Xray.x, Config.Xray.y, Config.Xray.z)
    local dialogtwo = exports['qb-input']:ShowInput({
        header = "XRAY",
        submitText = LLANG["confirm"],
        inputs = {
            {
                text = LLANG["selectplan"],
                name = "plan",
                type = "select",
                options = {
                    { value = "kafa", text = "Head" },
                    { value = "omuz", text = "Shoulder" },
                    { value = "humerus", text = "Humerus" },
                    { value = "onkol", text = "Forearm" },
                    { value = "pelvis", text = "Pelvis" },
                    { value = "femur", text = "Femur" },
                    { value = "diz", text = "Knee" },
                    { value = "ayak", text = "Foot" },
                    { value = "ciger", text = "Lung" },
                }
            },
        },
    })
    if dialogtwo ~= nil then
        local selecetedmenu = tostring(dialogtwo.plan)
        if selecetedmenu and selecetedmenu ~= "" then
            QBCore.Functions.TriggerCallback('wert-ambulancejob:server:get-players-coords', function(result)
                local Menu = {
                    {
                        header = LLANG["selectpatient"],
                        isMenuHeader = true
                    }
                }
                for k,v in pairs(result) do
                    Menu[#Menu+1] = {
                        header = v,
                        txt = "",
                        params = {
                            event = "wert-ambulancejob:client:xray-start",
                            args = {
                                id = k,
                                plan = selecetedmenu,
                                isim = v,
                            }
                        }
                    }
                end
                exports['qb-menu']:openMenu(Menu)
            end, 10, checkcoord)
        else
            QBCore.Functions.Notify(LLANG["invalidplan"], "error")
        end
    end
end)

RegisterNetEvent("wert-ambulancejob:client:mr-start", function(data)
	TriggerServerEvent('wert-ambulancejob:mr-start', "start")
	TriggerServerEvent("wert-ambulancejob:server:mr-other-start", data.id)
	QBCore.Functions.Progressbar('mr_prog', LLANG["mrprogress"], 15000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		TriggerServerEvent('wert-ambulancejob:mr-start', "stop")
		TriggerServerEvent('Wert-Ambulance:AddItem', "mri", 1, nil, {
			plan = data.plan,
			hasta = data.isim,
		})
	end, function()
	end)
end)

RegisterNetEvent("wert-ambulancejob:client:mr-other-start", function()
	QBCore.Functions.Progressbar('mr_prog', LLANG["mrprogress"], 15000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
	end, function()
	end)
end)

RegisterNetEvent("wert-ambulancejob:client:xray-start", function(data)
	TriggerServerEvent("wert-ambulancejob:server:xray-other-start", data.id)
	QBCore.Functions.Progressbar('xray_prog', LLANG["xrayprogress"], 15000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		TriggerServerEvent('Wert-Ambulance:AddItem', "xray", 1, nil, {
			plan = data.plan,
			hasta = data.isim,
		})
	end, function()
	end)
end)

RegisterNetEvent("wert-ambulancejob:client:xray-other-start", function()
	QBCore.Functions.Progressbar('xray_prog', LLANG["xrayprogress"], 15000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Play When Done
	end, function() -- Play When Cancel
	end)
end)


--Sebil
RegisterNetEvent("wert-ambulancejob:sebil", function()
    if not sebil then
        sebil = true
        QBCore.Functions.Progressbar("wert_sebil", LLANG["waterprogress"], 10000, false, true, { 
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "friends@frl@ig_1",
            anim = "drink_lamar",
            flags = 49,
        }, {}, {}, function() -- Bitiş Mert
            sebil = false
            TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + 4)
        end, function() -- İptal Mert
            sebil = false
        end)
    end
end)

--Kahve
RegisterNetEvent('wert-ambulancejob:make-coffee', function()
	if not kahve then
		if not inCoffe then
			kahve = true
			QBCore.Functions.Progressbar("ems_coffee", LLANG["coffeprogress"], 5000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				QBCore.Functions.Notify(LLANG["preparingcoffe"], "primary")
				Wait(5000)
				inCoffe = true
				kahve = false
				QBCore.Functions.Notify(LLANG["coffeready"], "success")
				-- Hazır tink sesi
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'coffee', 0.4)
			end, function() -- Cancel
				kahve = false
			end)
		else
			inCoffe = false
			QBCore.Functions.Notify(LLANG["gotcoffe"])
            TriggerServerEvent('Wert-Ambulance:AddItem', Config.CoffeItem, 1)
		end
	else
		QBCore.Functions.Notify(LLANG["alreadycoffe"], "error")
	end
end)

--Elevator
RegisterNetEvent("wert-ambulancejob:use-elevator", function(currentFloor)
    if not inelevator then
        local Menu = {
            {
                header = LLANG["selectfloor"],
                icon = "fa-solid fa-circle-info",
                isMenuHeader = true,
            },
        }
        for k,v in pairs(Config.ElevatorInfos) do
            if currentFloor ~= k then
                Menu[#Menu+1] = {
                    header = k .. "" .. LLANG["floornum"],
                    icon = "fa-solid fa-door-open",
                    params = {
                        event = "wert-ambulancejob:selected-floor",
                        args = {
                            tp = v.Tpcoord
                        }
                    }
                }
            end
        end
        Menu[#Menu+1] = {
            header = LLANG["exit"],
            icon = "fa-solid fa-angle-left",
            params = {
                event = "qb-menu:closeMenu",
            }
        }
            
        
        exports['qb-menu']:openMenu(Menu)
    end
end)

RegisterNetEvent("wert-ambulancejob:selected-floor", function(data)
    local ped = PlayerPedId()
    if not inelevator then
        inelevator = true
        QBCore.Functions.Progressbar('wertems_elevator', LLANG["elevatorprogress"], 2000, false, true, {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            local ped = PlayerPedId()
            local coords = data.tp
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(10)
            end
            SetEntityCoords(ped, coords.x, coords.y, coords.z, 0, 0, 0, false)
            SetEntityHeading(ped, coords.w)
            Wait(100)
            DoScreenFadeIn(1000)
            inelevator = false
        end, function()
            inelevator = false
        end)
    end
end)

-- Use mr - xray item
RegisterNetEvent("wert-ambulancejob:client:use-photo", function(url)
    if not photoactive then
        photoactive = true
        SetNuiFocus(true, true)
        SendNUIMessage({action = "Photo", photo = url})

        local ped = PlayerPedId()
        WertSharedRequestAnimDict("amb@world_human_tourist_map@male@base", function()
            TaskPlayAnim(ped, "amb@world_human_tourist_map@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
        end)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not HasModelLoaded("prop_tourist_map_01") then
            LoadPropDict("prop_tourist_map_01")
        end
        photoprop = CreateObject(GetHashKey("prop_tourist_map_01"), x, y, z+0.2,  true,  true, true)
        AttachEntityToEntity(photoprop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded("prop_tourist_map_01")
    end
end)

-- Kan grubu kartı
RegisterNetEvent("wert-ambulancejob:take-blood-card", function()
    QBCore.Functions.TriggerCallback('wert-ambulancejob:server:check-money', function(okey)
        if okey then
            local pdata = QBCore.Functions.GetPlayerData()
            local info = {}
            info.kankartdata = {
                csn = pdata.citizenid,
                firstname = pdata.charinfo.firstname,
                lastname = pdata.charinfo.lastname,
                birthdate = pdata.charinfo.birthdate,
                bloodtype = pdata.metadata.bloodtype
            }
            QBCore.Functions.Progressbar('take_bloodcard', LLANG["cardprogressbar"], 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                TriggerServerEvent('Wert-Ambulance:AddItem', "kankart", 1, false, info)
            end, function()
            end)
        else
            QBCore.Functions.Notify(LLANG["casherror"], 'error')
        end
    end, "cash", 150)
end)

RegisterNetEvent("wert-ambulancejob:use-blood-card", function(info)
    if not kartaktif then
        kartaktif = true
        SendNUIMessage({
            action = "Kart",
            kartdata = info
        })
    end
end)

-- Nui callbacks
RegisterNUICallback('Close', function(data)
    SetNuiFocus(false, false)
    if photoactive then photoactive = false ClearPedTasks(PlayerPedId()) end
    if photoprop then DeleteEntity(photoprop) end
    if kartaktif then kartaktif = false end
end)

RegisterNUICallback('activeunits', function(data, cb)
    QBCore.Functions.TriggerCallback('wert-ambulancejob:get-units', function(result)
        cb(result)
    end)
end)

RegisterNUICallback('patientdata', function(data, cb)
    QBCore.Functions.TriggerCallback('wert-ambulancejob:hasta-kayit', function(result)
        cb(result)
    end)
end)

RegisterNUICallback('notify', function(data)
    QBCore.Functions.Notify(data.notif, 'error', 4000)
end)

RegisterNUICallback('new-data', function(data)
    TriggerServerEvent('wert-ambulancejob:hasta-kayit-et', data.hasta, data.aciklama)
end)

RegisterNUICallback('get-blood-bank', function(data, cb)
    QBCore.Functions.TriggerCallback('wert-ambulancejob:server:get-blood-bank', function(result)
        cb(result)
    end)
end)

function CloseMenuBug()
    if kartaktif then kartaktif = false end
    SendNUIMessage({action = "CloseKart"})
end

RegisterCommand('+closeWertUMenu', CloseMenuBug, false)
RegisterKeyMapping("+closeWertUMenu", "Close ui~", "keyboard", "ESCAPE")