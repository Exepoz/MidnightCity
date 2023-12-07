local tedaviSure = Config.ReviveTime
local dinlenmeSure = Config.RestTime
local yatakta = false
local LLANG = LANG[Config.Locale]
RegisterNetEvent("wert-ambulancejob:client:npc-doctor-menu", function(doctor)
    if Config.UseCheckOnlineDoc then
        QBCore.Functions.TriggerCallback('wert-ambulancejob:online-doctor', function(result)
            if result == 0 then
                local label = LLANG["doctormenu"]
                local Menu = {
                    {
                        header = label,
                        isMenuHeader = true,
                        icon = "fas fa-stethoscope"
                    }
                }
                Menu[#Menu+1] = {
                    header = LLANG["doctorquestion"],
                    txt = LLANG["doctor"] .. " " .. doctor,
                    icon = "fas fa-angle-right",
                    params = {
                        event = "wert-ambulancejob:client:start-treatment",
                        args = {
                            doktor = doctor,
                        }
                    }
                }
                exports['qb-menu']:openMenu(Menu)
            else
                QBCore.Functions.Notify(LLANG["doctorsonlnie"], "error")
            end
        end)
    else
        local label = LLANG["doctormenu"]
        local Menu = {
            {
                header = label,
                isMenuHeader = true,
                icon = "fas fa-stethoscope"
            }
        }
        Menu[#Menu+1] = {
            header = LLANG["doctorquestion"],
            txt = LLANG["doctor"] .. " " .. doctor,
            icon = "fas fa-angle-right",
            params = {
                event = "wert-ambulancejob:client:start-treatment",
                args = {
                    doktor = doctor,
                }
            }
        }
        exports['qb-menu']:openMenu(Menu)
    end
end)

RegisterNetEvent("wert-ambulancejob:client:start-treatment", function(data)
    local playerPed = PlayerPedId()
    local canlandi = false
    local doktor = data.doktor
    yatakta = true
    FreezeEntityPosition(playerPed, true)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.metadata["isdead"] or  PlayerData.metadata["inlaststand"] then
        print(111)
        canlandi = true
        TriggerEvent(Config.ReviveClientEvent)
        Wait(1000)    
        for i=1, #Config.Beds[doktor]["dead"] do
            local yatak = Config.Beds[doktor]["dead"][i]
            local yatakBosDurum = QBCore.Functions.GetPlayersFromCoords(vector3(yatak.x, yatak.y, yatak.z), 1.5)
            if #yatakBosDurum == 0 or i == #Config.Beds[doktor]["dead"] then
                SetEntityCoords(playerPed, yatak.x, yatak.y, yatak.z)
                SetEntityHeading(playerPed, yatak.w)
                QBCore.Functions.Progressbar("wert_hastane", LLANG["npcdoctorprogress1"], tedaviSure, false, false, { 
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@morgue@table@",
                    anim = "ko_front",
                    flags = 33,
                }, {}, {}, function() -- Done
                    -- Done
                end, function() -- Cancel
                    -- Cancel
                end)
                Wait(tedaviSure)  
                break
            end
        end               
    end
    if not canlandi then
        TriggerEvent(Config.ReviveClientEvent)
    end
    Wait(1000) 
    for i=1, #Config.Beds[doktor]["rest"] do
        local yatak = Config.Beds[doktor]["rest"][i]
        local yatakBosDurum = QBCore.Functions.GetPlayersFromCoords(vector3(yatak.x, yatak.y, yatak.z), 1.5)
        if #yatakBosDurum == 0 or i == #Config.Beds[doktor]["rest"] then
            SetEntityCoords(playerPed, yatak.x, yatak.y, yatak.z)
            SetEntityHeading(playerPed, yatak.w)    
            local bugfix = GetEntityCoords(playerPed)
            QBCore.Functions.Progressbar("wert_dinlen", LLANG["npcdoctorprogress2"], dinlenmeSure, false, false, { 
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@gangops@morgue@table@",
                anim = "ko_front",
                flags = 33,
            }, {}, {}, function() -- Done
                Wait(500)
                SetEntityCoords(playerPed, bugfix.x+1.3, bugfix.y, bugfix.z-1)
                QBCore.Functions.Notify(LLANG["npcdoctorfinish"])
            end, function() -- Cancel
                QBCore.Functions.Notify(LLANG["npcdoctorcancel"], "error")
            end)
            Wait(dinlenmeSure)
            yatakta = false
            FreezeEntityPosition(playerPed, false)
            break
        end
    end
end)