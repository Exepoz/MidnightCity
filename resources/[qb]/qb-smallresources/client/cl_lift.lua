local QBCore = exports['qb-core']:GetCoreObject()
local floorsMenu = {}
local AllElevators = {}
local isUsingElevator = false
local text
local textblock

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        for k, v in pairs(Config.Elevators) do
            for a, b in pairs(v.Floors) do
                AllElevators[#AllElevators+1] = {lift = k, name = b.Label, location = b.Coords, floor = a}
            end
        end
        CreateElevators()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    for k, v in pairs(Config.Elevators) do
        for a, b in pairs(v.Floors) do
            AllElevators[#AllElevators+1] = {lift = k, name = b.Label, location = b.Coords, floor = a}
        end
    end
    CreateElevators()
end)

function ShowText(bool, msg)
	if bool then
        lib.showTextUI(msg)
		--exports['okokTextUI']:Open(msg, 'darkblue', 'right')
	else
        lib.hideTextUI()
		--exports['okokTextUI']:Close()
	end
end

local function openFloorsMenu(lift, floor)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    floorsMenu = {
        { header = Config.Elevators[lift].Name,
            text = Config.Language[Config.UseLanguage].CurrentFloor .. Config.Elevators[lift].Floors[floor].Label,
            isMenuHeader = true
        },
    }
    local event = 'qb-lift:checkFloorPermission'
    local clo, distance =  QBCore.Functions.GetClosestPlayer(pcoords)
    if clo ~= -1 and distance < 1.8 then event = 'qb-lift:client:ElevatorChoice' end
    for j = 1, #Config.Elevators[lift].Floors, 1 do
        local newEvent = nil
        if j ~= floor then
            local newFloor = Config.Elevators[lift].Floors[j]
            local desc = '' .. Config.Elevators[lift].Floors[j].FloorDesc ..''
            if Config.Elevators[lift].Floors[j].Restricted then
                if not IsAuthorized(lift) then
                    desc = "Requires Key"
                    newEvent = 'qb-lift:FloorsMenu'
                    newFloor = floor
                end
            end
            floorsMenu[#floorsMenu + 1] = {
                header = '' .. Config.Elevators[lift].Floors[j].Label ..'',
                txt = desc,
                params = {
                    event = newEvent or event,
                    args = {
                        lift = lift,
                        floor = newFloor,
                        oldFloor = floor,
                        bring = false
                    }
                }
            }
        end
	end
    floorsMenu[#floorsMenu+1] = { header = "Exit", params = {event = "qb-menu:client:closeMenu"}}
    exports['qb-menu']:openMenu(floorsMenu)
end

RegisterNetEvent('qb-lift:client:ElevatorChoice', function(data)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local other, dist = QBCore.Functions.GetClosestPlayer(pcoords)
    floorsMenu = {
        {
            header = Config.Elevators[data.lift].Name,
            text = Config.Language[Config.UseLanguage].CurrentFloor .. Config.Elevators[data.lift].Floors[data.oldFloor].Label,
            isMenuHeader = true
        },
        {
            header = "Go Alone",
            params = {
                event = "qb-lift:checkFloorPermission",
                args = {
                    lift = data.lift,
                    floor = data.floor,
                    oldFloor = data.oldFloor,
                    bring = false
                }
            }
        },
    }
    if other and dist < 1.8 then
        floorsMenu[#floorsMenu+1] =
        {
            header = "Bring Others",
            params = {
                event = "qb-lift:checkFloorPermission",
                args = {
                    lift = data.lift,
                    floor = data.floor,
                    oldFloor = data.oldFloor,
                    bring = true
                }
            }
        }
    end
    floorsMenu[#floorsMenu+1] =
        {
            header = "Go Back",
            params = {
                event = "qb-lift:FloorsMenu",
                args = {
                    lift = data.lift,
                    floor = data.oldFloor
                }
            },
        }
    exports['qb-menu']:openMenu(floorsMenu)
end)

RegisterNetEvent('qb-lift:FloorsMenu', function(data)
    openFloorsMenu(data.lift, data.floor)
end)


function CreateElevators()
    for k, v in pairs(AllElevators) do
        local point = lib.points.new(v.location, 1.0)
        function point:onEnter() ShowText(true, "[F] To Access Elevator") end
        function point:nearby() if IsControlJustPressed(0, 23) then openFloorsMenu(v.lift, v.floor) ShowText(false) end end
        function point:onExit() ShowText(false) end
    end
end



function IsAuthorized(lift)
    local pData = QBCore.Functions.GetPlayerData()
    for a=1, #Config.Elevators[lift].Group do
        if pData.job.name == Config.Elevators[lift].Group[a] or pData.gang.name == Config.Elevators[lift].Group[a] then
            return true
        end
    end
    return false
end

RegisterNetEvent('qb-lift:changeFloor')
AddEventHandler('qb-lift:changeFloor', function(data)
    if isUsingElevator then return end
    isUsingElevator = true
    local ped = PlayerPedId()
    textblock = true
    ShowText(false) text = false
    local isDead = false
    local pData = QBCore.Functions.GetPlayerData()
    --if pData.metadata.isdead or pData.metadata.inlaststand then isDead = true end
    QBCore.Functions.Progressbar("Call_The_Lift", Config.Language[Config.UseLanguage].Waiting, 5000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        --animDict = "anim@apt_trans@elevator",
        --anim = "elev_1",
        --flags = 16,
    }, {}, {}, function() -- Done
        SetEntityInvincible(ped, true)
        --StopAnimTask(ped, "anim@apt_trans@elevator", "elev_1", 1.0)
        DoScreenFadeOut(500)
        TriggerEvent('qb-lift:music')
        while not IsScreenFadedOut() do
            Wait(0)
        end
        --local pcoords = GetEntityCoords(ped)
        --FreezeEntityPosition(ped, true)
        --SetEntityCoords(ped, pcoords.x, pcoords.y, pcoords.z-50, 0, 0, 0, false)
        Citizen.Wait(7500)
        if Config.UseSoundEffect then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", Config.Elevators[data.lift].Sound, 0.05)
        end
        local h = data.floor.ExitHeading
        SetEntityCoords(ped, data.floor.Coords.x, data.floor.Coords.y, data.floor.Coords.z, 0, 0, 0, false)
        -- if Config.Elevators[data.lift].Casten then
        --     FreezeEntityPosition(ped, true)
        --     local desiredfloor = string.sub(data.floor.Label, 1, 1)
        --     print(desiredfloor)
        --     if desiredfloor == "M" then desiredfloor = "0" end
        --     desiredfloor = tonumber(desiredfloor)
        --     exports['cfx_gn_von_hotel']:SpawnFloor(desiredfloor)
        --     Wait(3000)
        --     FreezeEntityPosition(ped, false)
        -- end
        Wait(500)
        if type(h) == "string" then h = tonumber(h) end
        SetEntityHeading(ped, h)
        Citizen.Wait(1000)
        DoScreenFadeIn(600)
        while not IsScreenFadedIn() do
            Wait(0)
        end
        SetEntityInvincible(ped, false)
        isUsingElevator = false
        pData = QBCore.Functions.GetPlayerData()
        --if pData.metadata.isdead or pData.metadata.inlaststand and not isDead then TriggerServerEvent('malmo-liftRes') end
        Wait(7000) textblock = false
    end)
end)

RegisterNetEvent('qb-lift:callLift')
AddEventHandler('qb-lift:callLift', function()
    Wait(1000)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inLiftRange = false
    for k, v in pairs(Config.Elevators) do
        for i, b in pairs(Config.Elevators[k].Floors) do
            local liftDist = #(coords - b.Coords)
            if liftDist <= 4 then
                inLiftRange = true
                if liftDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        openFloorsMenu(k, i)
                    end
                end
            end
        end
    end
    if not inLiftRange then
        Wait(1000)
    end
end)

RegisterNetEvent('qb-lift:client:BringOthers', function(data)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    if #(pcoords - Config.Elevators[data.lift].Floors[data.oldFloor].Coords) <= 2.0 then
        TriggerEvent('qb-lift:changeFloor', data)
    end
end)

RegisterNetEvent('qb-lift:checkFloorPermission')
AddEventHandler('qb-lift:checkFloorPermission', function(data)
    if Config.Elevators[data.lift].Group then
        if data.floor.Restricted then
            if IsAuthorized(data.lift) then
                if data.bring then
                    TriggerServerEvent('qb-lift:server:BringOthers', data)
                else
                    TriggerEvent('qb-lift:changeFloor', data)
                end
            else
                QBCore.Functions.Notify(Config.Language[Config.UseLanguage].Restricted, "error")
            end
        else
            if data.bring then
                TriggerServerEvent('qb-lift:server:BringOthers', data)
            else
                TriggerEvent('qb-lift:changeFloor', data)
            end
        end
    else
        if data.bring then
            TriggerServerEvent('qb-lift:server:BringOthers', data)
        else
            TriggerEvent('qb-lift:changeFloor', data)
        end
    end
end)

RegisterNetEvent('qb-lift:music')
AddEventHandler('qb-lift:music', function()
    local src = source
        for i = 1, 4 do
        local randomChance = math.random(1, 3)
            if randomChance <= 1 then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "elevator" , 0.05)
		elseif randomChance >= 2 and randomChance <= 2 then
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "elevator2" , 0.05)
        else
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "elevator3" , 0.05)
        end
    end
end)