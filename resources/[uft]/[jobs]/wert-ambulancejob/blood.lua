local bloodactive = false
local LLANG = LANG[Config.Locale]
RegisterNetEvent('wert-ambulancejob:take-blood', function()
    if not bloodactive then
        local player, distance = QBCore.Functions.GetClosestPlayer()
        if player ~= -1 and distance < 5.0 then
            local playerId = GetPlayerServerId(player)
            local id = GetPlayerFromServerId(playerId)
            local targetped = GetPlayerPed(id)
            QBCore.Functions.TriggerCallback("QBCore:HasItem", function(qqty)
                if qqty then
                    bloodactive = true
                    FreezeEntityPosition(targetped, true)
                    TriggerServerEvent('Wert-Ambulance:RemoveItem', "emptytube", 1)
                    TriggerServerEvent('Wert-Ambulance:RemoveItem', "emptysyringe", 1)
                    QBCore.Functions.Progressbar("dna-gloveremove", LLANG["bloodprogress1"], 8000, false, true, { 
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = 'rcmpaparazzo1ig_4',
                        anim = 'miranda_shooting_up',
                        flags = 49,
                    }, { -- prop1
                        model = "prop_syringe_01",
                        bone = 28422,
                        coords = { x = 0.0, y = 0.0, z = 0.0 },
                        rotation = { x = 0.0, y = 0.0, z = 0.0 },
                    }, {}, function() -- Done
                        bloodactive = false
                        FreezeEntityPosition(targetped, false)
                        TriggerServerEvent("wert-ambulancejob:server:kan-alındı", playerId)
                    end, function() -- Cancel
                        bloodactive = false
                        FreezeEntityPosition(targetped, false)
                    end)
                else
                    QBCore.Functions.Notify(LLANG["tubeerror"], "error")
                end
            end, "emptytube")
        else
            QBCore.Functions.Notify(LLANG["closestplayererror"], "error")
        end
    end
end)

RegisterNetEvent('wert-ambulancejob:kan-paketle', function(bloodtype, slot)
    if not bloodactive then
        bloodactive = true
        TriggerServerEvent('Wert-Ambulance:RemoveItem', 'bloodtube', 1, slot)
        QBCore.Functions.Progressbar("kan_paket", LLANG["bloodprogress2"], 5000, false, false, {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
		}, {}, {}, function() -- Done
			bloodactive = false
            local info = {}
            info.bloodtype = bloodtype
            TriggerServerEvent('Wert-Ambulance:AddItem', 'bloodbag', 1, nil, info)
		end)
    end
end)

RegisterNetEvent('wert-ambulancejob:kan-setup', function(bloodtype, slot)
    if not bloodactive then
        bloodactive = true
        TriggerServerEvent('Wert-Ambulance:RemoveItem', 'bloodbag', 1, slot)
        TriggerServerEvent("wert-ambulancejob:server:blood-actions", "add", bloodtype)
        QBCore.Functions.Notify(LLANG["bloodupload"], "success")
        bloodactive = false
    end
end)

RegisterNetEvent('wert-ambulancejob:take-blood-in-bank', function()
    QBCore.Functions.TriggerCallback("wert-ambulancejob:server:get-blood-bank", function(result)
        local Menu = {
            {
                header = LLANG["bloodbank"],
                isMenuHeader = true
            }
        }
        for k,v in pairs(result) do
            Menu[#Menu+1] = {
                header = k:upper(),
                txt = LLANG["bloodmenuamount"] .. "" .. v,
                params = {
                    event = "wert-ambulancejob:add-blood-take",
                    args = {
                        group = k,
                        amount = tonumber(v),
                    }
                }
            }
        end
        exports['qb-menu']:openMenu(Menu)
    end)
end)

RegisterNetEvent("wert-ambulancejob:add-blood-take", function(data)
    if data.amount > 0 then
        local info = {}
        info.bloodtype = data.group
        TriggerServerEvent('Wert-Ambulance:AddItem', 'bloodbag', 1, nil, info)
        TriggerServerEvent("wert-ambulancejob:server:blood-actions", "remove", data.group)
        QBCore.Functions.Notify(LLANG["bloodtaked"] .. " | Group : " .. data.group, "success")
    else
        QBCore.Functions.Notify(LLANG["bloodamounterror"], "error")
    end
end)