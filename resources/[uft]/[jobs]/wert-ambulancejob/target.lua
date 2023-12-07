-- If you use qb-phone add client.lua this event (For bill notify)
--[[ RegisterNetEvent('qb-phone:client:bill-notif', function(text)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Bank",
            text = text,
            icon = "fas fa-university",
            color = "#ff002f",
            timeout = 3500,
        },
    })
end) ]]

CreateThread(function()
    --SetNuiFocus(true, true)
    -- Duty, Patient System, Bill Targets
    exports['qb-target']:AddBoxZone("EMSWertAmbulanceDuty", Config.TargetInfos["EMSWertAmbulanceDuty"].Coord, Config.TargetInfos["EMSWertAmbulanceDuty"].Lenght, Config.TargetInfos["EMSWertAmbulanceDuty"].Width, {
        name="EMSWertAmbulanceDuty",
        heading=Config.TargetInfos["EMSWertAmbulanceDuty"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertAmbulanceDuty"].Minz,
        maxZ = Config.TargetInfos["EMSWertAmbulanceDuty"].Maxz,
        }, {
            options = {
                {
                    type = "client",
                    event = "wert-ambulancejob:duty-action",
                    place = "Hospital",
                    icon = "far fa-clipboard",
                    label = "On duty / Off duty",
                    job = "ambulance",
                },
            },
        distance = Config.TargetInfos["EMSWertAmbulanceDuty"].Distance
    })
    exports['qb-target']:AddBoxZone("EMSWertAmbulanceComputer", Config.TargetInfos["EMSWertAmbulanceComputer"].Coord, Config.TargetInfos["EMSWertAmbulanceComputer"].Lenght, Config.TargetInfos["EMSWertAmbulanceComputer"].Width, {
        name="EMSWertAmbulanceComputer",
        heading=Config.TargetInfos["EMSWertAmbulanceComputer"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertAmbulanceComputer"].Minz,
        maxZ = Config.TargetInfos["EMSWertAmbulanceComputer"].Maxz,
        }, {
            options = {
                {
                    type = "client",
                    event = "wert-ambulancejob:patient-save",
                    place = "Hospital",
                    icon = "fas fa-floppy-disk",
                    label = "Patient registration system",
                    job = "ambulance",
                },
                {
                    type = "client",
                    event = "wert-ambulancejob:ambulance-bill",
                    place = "Hospital",
                    icon = "fas fa-money-bill",
                    label = "Bill player",
                    job = "ambulance",
                },
            },
        distance = Config.TargetInfos["EMSWertAmbulanceComputer"].Distance
    })
    -- Armory, Stash Targets
    exports['qb-target']:AddBoxZone("EMSWertArmoryStash", Config.TargetInfos["EMSWertArmoryStash"].Coord, Config.TargetInfos["EMSWertArmoryStash"].Lenght, Config.TargetInfos["EMSWertArmoryStash"].Width, {
        name="EMSWertArmoryStash",
        heading=Config.TargetInfos["EMSWertArmoryStash"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertArmoryStash"].Minz,
        maxZ = Config.TargetInfos["EMSWertArmoryStash"].Maxz,
        }, {
            options = {
                {
					type = "client",
					event = "wert-ambulancejob:open-shop",
					place = "Hospital",
					icon = "fas fa-dolly",
					label = "Armory",
					job = "ambulance",
				},
				{
					type = "client",
					event = "wert-ambulancejob:open-stash",
					place = "Hospital",
					icon = "fas fa-box",
					label = "Stash",
					job = "ambulance",
				},
            },
        distance = Config.TargetInfos["EMSWertArmoryStash"].Distance
    })
    -- Boss Menu Targets
    exports['qb-target']:AddBoxZone("EMSWertBossMenu", Config.TargetInfos["EMSWertBossMenu"].Coord, Config.TargetInfos["EMSWertBossMenu"].Lenght, Config.TargetInfos["EMSWertBossMenu"].Width, {
        name="EMSWertBossMenu",
        heading=Config.TargetInfos["EMSWertBossMenu"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertBossMenu"].Minz,
        maxZ = Config.TargetInfos["EMSWertBossMenu"].Maxz,
        }, {
            options = {
                {
					type = "client",
					event = Config.TargetInfos["EMSWertBossMenu"].Event,
					place = "Hospital",
					icon = Config.TargetInfos["EMSWertBossMenu"].Icon,
					label = Config.TargetInfos["EMSWertBossMenu"].Label,
					job = "ambulance",
				},
            },
        distance = Config.TargetInfos["EMSWertBossMenu"].Distance
    })
    -- MRI Targets
    exports['qb-target']:AddBoxZone("EMSWertMrComputer", Config.TargetInfos["EMSWertMrComputer"].Coord, Config.TargetInfos["EMSWertMrComputer"].Lenght, Config.TargetInfos["EMSWertMrComputer"].Width, {
        name="EMSWertMrComputer",
        heading=Config.TargetInfos["EMSWertMrComputer"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertMrComputer"].Minz,
        maxZ = Config.TargetInfos["EMSWertMrComputer"].Maxz,
        }, {
            options = {
                {
					type = "client",
					event = Config.TargetInfos["EMSWertMrComputer"].Event,
					place = "Hospital",
					icon = Config.TargetInfos["EMSWertMrComputer"].Icon,
					label = Config.TargetInfos["EMSWertMrComputer"].Label,
					job = "ambulance",
				},
            },
        distance = Config.TargetInfos["EMSWertMrComputer"].Distance
    })
    exports['qb-target']:AddBoxZone("EMSWertMrDesk", Config.TargetInfos["EMSWertMrDesk"].Coord, Config.TargetInfos["EMSWertMrDesk"].Lenght, Config.TargetInfos["EMSWertMrDesk"].Width, {
        name="EMSWertMrDesk",
        heading=Config.TargetInfos["EMSWertMrDesk"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertMrDesk"].Minz,
        maxZ = Config.TargetInfos["EMSWertMrDesk"].Maxz,
        }, {
            -- Don't tuch
            options = {
				{
					type = "client",
					place = "Hospital",
					icon = "fas fa-bed",
					label = "MR Desk",
					action = function(entity)
						TriggerEvent("wert-ambulancejob:mr", "yat")
					end,
					canInteract = function(entity)
						if not yatakta then return true else return false end
					end,
				},
				{
					type = "client",
					place = "Hospital",
					icon = "fas fa-bed",
					label = "Get Up",
					action = function(entity)
						TriggerEvent("wert-ambulancejob:mr", "kalk")
					end,
					canInteract = function(entity)
						if yatakta then return true else return false end
					end,
				},
			},
        distance = Config.TargetInfos["EMSWertMrDesk"].Distance
    })
    -- Xray Targets
    exports['qb-target']:AddBoxZone("EMSWertXrayComputer", Config.TargetInfos["EMSWertXrayComputer"].Coord, Config.TargetInfos["EMSWertXrayComputer"].Lenght, Config.TargetInfos["EMSWertXrayComputer"].Width, {
        name="EMSWertXrayComputer",
        heading=Config.TargetInfos["EMSWertXrayComputer"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertXrayComputer"].Minz,
        maxZ = Config.TargetInfos["EMSWertXrayComputer"].Maxz,
        }, {
            options = {
                {
					type = "client",
					event = Config.TargetInfos["EMSWertXrayComputer"].Event,
					place = "Hospital",
					icon = Config.TargetInfos["EMSWertXrayComputer"].Icon,
					label = Config.TargetInfos["EMSWertXrayComputer"].Label,
					job = "ambulance",
				},
            },
        distance = Config.TargetInfos["EMSWertXrayComputer"].Distance
    })
    exports['qb-target']:AddBoxZone("EMSWertXrayDesk", Config.TargetInfos["EMSWertXrayDesk"].Coord, Config.TargetInfos["EMSWertXrayDesk"].Lenght, Config.TargetInfos["EMSWertXrayDesk"].Width, {
		name="EMSWertXrayDesk",
        heading=Config.TargetInfos["EMSWertXrayDesk"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSWertXrayDesk"].Minz,
        maxZ = Config.TargetInfos["EMSWertXrayDesk"].Maxz,
		}, {
			options = {
				{
					type = "client",
					place = "Hospital",
					icon = "fas fa-bed",
					label = "XRAY Desk",
					action = function(entity)
						TriggerEvent("wert-ambulancejob:xray", "yat")
					end,
					canInteract = function(entity)
						if not yatakta then return true else return false end
					end,
				},
				{
					type = "client",
					place = "Hospital",
					icon = "fas fa-bed",
					label = "Get Up",
					action = function(entity)
						TriggerEvent("wert-ambulancejob:xray", "kalk")
					end,
					canInteract = function(entity)
						if yatakta then return true else return false end
					end,
				},
			},
			distance = Config.TargetInfos["EMSWertXrayDesk"].Distance
		})

    exports['qb-target']:AddBoxZone('EMSBloodCard', Config.TargetInfos["EMSBloodCard"].Coord, Config.TargetInfos["EMSBloodCard"].Lenght, Config.TargetInfos["EMSBloodCard"].Width, {
        name='EMSBloodCard',
        heading=Config.TargetInfos["EMSBloodCard"].Heading,
        debugPoly=Config.DebugPoly,
        minZ = Config.TargetInfos["EMSBloodCard"].Minz,
        maxZ = Config.TargetInfos["EMSBloodCard"].Maxz,
        }, {
            options = {
                {
                    type = 'client',
                    event = Config.TargetInfos["EMSBloodCard"].Event,
                    icon = Config.TargetInfos["EMSBloodCard"].Icon,
                    label = Config.TargetInfos["EMSBloodCard"].Label,
                },
            },
        distance = 1.5
    })

    --Models
    --Coffe machine
	exports["qb-target"]:AddTargetModel(`prop_coffee_mac_02`, {
        options = {
            {
				type = "client",
				event = "wert-ambulancejob:make-coffee",
				place = "Hospital",
				icon = "fas fa-beer-mug-empty",
				label = "Coffe Machine",
			},
        },
        distance = 1.5
    })
    --Water tank
    exports["qb-target"]:AddTargetModel(`prop_watercooler`, {
        options = {
            {
				type = "client",
				event = "wert-ambulancejob:sebil",
				place = "Hospital",
				icon = "fas fa-droplet",
				label = "Water Cooler",
			},
        },
        distance = 1.5
    })
    --Elevators
    for k,v in pairs(Config.ElevatorInfos) do
        exports['qb-target']:AddBoxZone(k.."EMSElevator", v.Coord, v.Lenght, v.Width, {
            name=k.."EMSElevator",
            heading=v.Heading,
            debugPoly=Config.DebugPoly,
            minZ = v.Minz,
            maxZ = v.Maxz,
            }, {
                options = {
                    {
                        type = "client",
                        place = "Hospital",
                        icon = "fas fa-door-open",
                        label = "Elevator",
                        action = function(entity)
                            TriggerEvent("wert-ambulancejob:use-elevator", k)
                        end,
                    },
                },
                distance = v.Distance
            })
    end

    if Config.GarageEnabled then
        for x, y in pairs(Config.GarageNpcInfos) do
            for xx, yy in pairs(Config.GarageNpcInfos[x]) do
                RequestModel(yy.hash)
                while not HasModelLoaded(yy.hash) do
                    Wait(1)
                end
                local garageped = CreatePed(1, yy.hash, yy.coord.x, yy.coord.y, yy.coord.z - 1.0, yy.coord.w, false, true)
                SetBlockingOfNonTemporaryEvents(garageped, true)
                SetPedDiesWhenInjured(garageped, false)
                SetPedCanPlayAmbientAnims(garageped, true)
                SetPedCanRagdollFromPlayerImpact(garageped, false)
                SetEntityInvincible(garageped, true)
                FreezeEntityPosition(garageped, true)
                exports["qb-target"]:AddTargetEntity(garageped, {
                    options = {
                        {
                            place = "WertGarageAmbulance",
                            icon = "fas fa-warehouse",
                            label = "Garage attendant ",
                            job = "ambulance",
                            action = function(entity)
                                TriggerEvent("wert-ambulancejob:client:garage-menu", x, xx)
                            end,
                        },
                    },
                    distance = 1.5
                })
            end
            
        end
    
        local headerDrawn = false
        local garageOne = BoxZone:Create(vector3(326.07, -588.53, 28.8), 6.0, 19.0, {
            name="park1",
            heading=340,
            debugPoly=Config.DebugPoly,
            minZ = 27.5,
            maxZ = 31.8,
        })
        garageOne:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    if not headerDrawn then
                        headerDrawn = true
                        exports['qb-menu']:showHeader({
                            {
                                header = 'Store vehicle',
                                icon = 'fas fa-door-open',
                                params = {
                                    event = 'wert-ambulancejob:client:store-vehicle',
                                }
                            },
                        })
                    end
                end
            else
                if headerDrawn then
                    headerDrawn = false
                    exports['qb-menu']:closeMenu()
                end
            end
        end)
    
        local garageTwo = BoxZone:Create(vector3(318.63, -571.96, 28.8), 18.2, 9.8, {
            name="park2",
            heading=340,
            debugPoly=Config.DebugPoly,
            minZ = 27.5,
            maxZ = 31.8,
        })
        garageTwo:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    if not headerDrawn then
                        headerDrawn = true
                        exports['qb-menu']:showHeader({
                            {
                                header = 'Store vehicle',
                                icon = 'fas fa-door-open',
                                params = {
                                    event = 'wert-ambulancejob:client:store-vehicle',
                                }
                            },
                        })
                    end
                end
            else
                if headerDrawn then
                    headerDrawn = false
                    exports['qb-menu']:closeMenu()
                end
            end
        end)
    end

    for _, item in pairs(Config.NpcDoctors) do
        RequestModel(GetHashKey("s_m_m_doctor_01"))
        while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
          Wait(1)
        end
        local hospitalped = CreatePed(4, 0xd47303ac, item.coord.x, item.coord.y, item.coord.z-1.0, item.coord.w, false, true)
        SetBlockingOfNonTemporaryEvents(hospitalped, true)
        SetPedDiesWhenInjured(hospitalped, false)
        SetPedCanPlayAmbientAnims(hospitalped, true)
        SetPedCanRagdollFromPlayerImpact(hospitalped, false)
        SetEntityInvincible(hospitalped, true)
        FreezeEntityPosition(hospitalped, true)
        Wait(100)
        exports["qb-target"]:AddTargetEntity(hospitalped, {
            options = {
                {
                    place = "NpcDoctor",
                    icon = "fas fa-stethoscope",
                    label = item.name .. " Doctor",
                    action = function()
                        TriggerEvent('wert-ambulancejob:client:npc-doctor-menu', item.name)
                    end,
                },
            },
            distance = 4.0
        })
    end

    --Blood targets
    exports['qb-target']:AddBoxZone('EMSBloodPackaged', vector3(311.74, -565.86, 43.28), 1.2, 0.8, {
        name='EMSBloodPackaged',
        heading=340,
        debugPoly=Config.DebugPoly,
        minZ = 42.28,
        maxZ = 44.28,
        }, {
            options = {
                {
                    type = 'client',
                    --event = 'wert-ambulancejob:kan-paketle',
                    icon = 'fa-solid fa-droplet',
                    label = 'Packaged blood',
                    item = 'bloodtube',
                    action = function(entity)
                        TriggerServerEvent('wert-ambulancejob:kan-paket')
                    end,
                },
            },
        distance = 1.5
    })


    exports['qb-target']:AddBoxZone('EMSBloodBank', vector3(309.95, -560.44, 43.28), 0.8, 0.8, {
        name='EMSBloodBank',
        heading=340,
        debugPoly=Config.DebugPoly,
        minZ = 42.28,
        maxZ = 44.28,
        }, {
            options = {
                {
                    type = 'client',
                    icon = 'fa-solid fa-server',
                    label = 'Load blood in the bank',
                    item = 'bloodbag',
                    action = function(entity)
                        TriggerServerEvent('wert-ambulancejob:kan-load-bank')
                    end,
                },

                {
                    type = 'client',
                    icon = 'fa-solid fa-hand-holding-heart',
                    label = 'Take blood in the bank',
                    event = 'wert-ambulancejob:take-blood-in-bank'
                },
            },
        distance = 1.5
    })
end)