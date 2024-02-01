local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local hasActivePins = false
local currentLane = 0
local totalThrown = 0
local totalDowned = 0
local lastBall = 0
local lanes = Config.BowlingLanes
local inBowlingZone = false
local BowlingAlley
local boughtTicket, boughtBall = false, false
local lastlane = 0
local gamesPlayed = 0



local function canUseLane(pLaneId)
    local shit = false

    QBCore.Functions.TriggerCallback('bp-bowling:getLaneAccess', function(response)
        if(response == true) then
            shit = true
        end
    end , pLaneId)
    Citizen.Wait(300)
    return shit

end

Citizen.CreateThread(function()

    exports.ox_target:addSphereZone({coords = vector3(755.52, -772.9, 26.64), radius = 0.7, debug = false, options = {
        {
            label = 'Check Scores',
            icon = 'fas-fa-clipboard',
            onSelect = function()
                lib.registerContext({
                    id = 'bowlingScores',
                    title = 'Scoring',
                    options = {
                        {
                            title = 'Check Games In Progress',
                            onSelect = function()
                                local currOptions = {}
                                local currentGames = GlobalState.CurrentBowlingGames
                                for i = 1, 8 do
                                    if currentGames[i] then
                                        local str = ""
                                        for k, v in pairs(currentGames[i].games) do
                                            if k ~= 1 then str = str.."\n" end
                                            str = str.."Game "..k.." | Throw 1 : "..v[1]..(v[2] and " | Throw 2 : "..v[2] or "").." | Total : "..v['tot']
                                        end
                                        currOptions[#currOptions+1] = {
                                            title = 'Lane '..i.." | "..currentGames[i].name.." | Points : "..currentGames[i].totalPoints,
                                            description = str,
                                            readOnly = true
                                        }
                                    end
                                end
                                if #currOptions < 1 then
                                    currOptions[#currOptions+1] = {
                                        title = "No Games in Progress.",
                                        readOnly = true
                                    }
                                end
                                lib.registerContext({
                                    id = 'currentBowlingGames',
                                    title = 'Games In Progress',
                                    options = currOptions,
                                    menu = 'bowlingScores'
                                }) lib.showContext('currentBowlingGames')
                            end,
                            icon = 'fas fa-bars-progress'
                        },
                        {
                            title = 'Check Past Games',
                            onSelect = function()
                                local currOptions = {}
                                local currentGames = GlobalState.PastBowlingGames
                                for k_, v_ in pairs(currentGames) do
                                    local str = ""
                                    for k, v in pairs(v_.games) do
                                        if k ~= 1 then str = str.."\n" end
                                        str = str.."Game "..k.." | Throw 1 : "..v[1]..(v[2] and " | Throw 2 : "..v[2] or "").." | Total : "..v['tot']
                                    end
                                    currOptions[#currOptions+1] = {
                                        title = 'Lane '..v_.lane.." | "..v_.name.." | Points : "..v_.totalPoints,
                                        description = str,
                                        readOnly = true
                                    }
                                end
                                if #currOptions < 1 then
                                    currOptions[#currOptions+1] = {
                                        title = "No Past Games To Show.",
                                        readOnly = true
                                    }
                                end
                                lib.registerContext({
                                    id = 'pastBowlingGames',
                                    title = 'Past Games',
                                    options = currOptions,
                                    menu = 'bowlingScores'
                                }) lib.showContext('pastBowlingGames')
                            end,
                            icon = 'fas fa-square-check'
                        },

                    }
                })
                lib.showContext('bowlingScores')
            end
        }
    }})

    for k, v in pairs(lanes) do
        if (not v.enabled) then goto continueBox end

        local zone = BoxZone:Create(v.pos, 1.8, 2.0, {
            name= "bp-bowling:lane_"..k,
            offset={0.0, 0.0, 0.0},
            scale={1.0, 1.0, 1.0},
            debugPoly=false,
        })
        ::continueBox::
    end

    BowlingAlley = BoxZone:Create(vector3(743.95, -774.54, 26.34), 16.8, 30.4, {
        name= "bp-bowling:bowling_alley",
        offset={0.0, 0.0, 0.0},
        scale={1.0, 1.0, 1.0},
        debugPoly=false,
    })
    if not BowlingAlley then return end
    BowlingAlley:onPointInOut(BowlingAlley.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
            inBowlingZone = true
        else
            TriggerServerEvent('bowling:finishScore', lastlane)
            inBowlingZone = false
            TriggerServerEvent("bp-bowling:RemoveItem")
            boughtTicket = false
            boughtBall = false
            if lastlane ~= 0 then
                lanes[lastlane].enabled = true
                TriggerServerEvent('bp-bowling:syncLane', lastlane, true)
            end
            gamesPlayed = 0
            if (hasActivePins) then
                resetBowling()
                totalDowned = 0
                totalThrown = 0
            end
        end
    end)

    local data = {
        id = 'bowling_npc_vendor',
        position = {
            coords = vector3(756.39, -774.74, 25.34),
            heading = 102.85,
        },
        pedType = 4,
        model = "csb_dix",
        networked = false,
        distance = 25.0,
        settings = {
            { mode = 'invincible', active = true },
            { mode = 'ignore', active = true },
            { mode = 'freeze', active = true },
        },
        flags = {
            isNPC = true,
        },
    }
    RequestModel(GetHashKey(data.model))
	while not HasModelLoaded(GetHashKey(data.model)) do
		Citizen.Wait( 1 )
	end
    created_ped = CreatePed(data.pedType, data.model , data.position.coords.x,data.position.coords.y,data. position.coords.z, data.position.heading, data.networked, false)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
    local BowlingPed = {
        GetHashKey("a_m_o_salton_01"),
    }

    exports['qb-target']:AddTargetEntity(created_ped, {
        options = {
            {
                event = 'bp-bowling:client:openMenu',
                icon = 'fas fa-bowling-ball',
                label = 'View Store'
            }
        },
        job = {"all"},
        distance = 2.5
    })
        ::continuePeak::
end)

local function drawStatusHUD(state, pValues)
    local title = "Bowling - Lane #" .. currentLane
    local values = {}
    table.insert(values, "Games Played: " .. gamesPlayed .. "/5")
    table.insert(values, "Throws: " .. totalThrown .. "/2")
    table.insert(values, "Downed: " .. totalDowned)

    if (pValues) then
        for k, v in pairs(pValues) do
        table.insert(values, v)
        end
    end

    SendNUIMessage({show = state , t = title , v = values})
end
RegisterNetEvent('bp-bowling:client:openMenu')
AddEventHandler('bp-bowling:client:openMenu' , function()
    local options = Config.BowlingVendor
    local data = {}
    local menuOptions = {}
    local uNwinDTestMenu = { }


    for itemId, item in pairs(options) do
        uNwinDTestMenu[#uNwinDTestMenu+1] = {
            id = itemId,
            header = item.name,
            txt = "Price "..item.price.."$",
            params = {
                event = "bp-bowling:openMenu2",
                args = {
                    data = itemId,
                }
            }
        }
    end
    exports['qb-menu']:openMenu(uNwinDTestMenu)
end)


RegisterNetEvent('bp-bowling:openMenu2')
AddEventHandler('bp-bowling:openMenu2' , function(data)
    if(data.data == 'bowlingreceipt') then
        local lanesSorted = {}
        for k, v in ipairs(lanes) do
            if(lanes[k].enabled == false) then
                return
            end

            local uNwinDTestMenu2 = { }

            for k, v in ipairs(lanes) do
                uNwinDTestMenu2[#uNwinDTestMenu2+1] = {
                    id = k,
                    header = "Lane #"..k,
                    txt = "",
                    params = {
                        event = "bp-bowling:bowlingPurchase",
                        args = {
                            key = k
                        }
                    }
                }
            end
            exports['qb-menu']:openMenu(uNwinDTestMenu2)
        end

    else
        TriggerEvent("bp-bowling:bowlingPurchase" , 'd')
    end
end)

local sheesh = false
function shit(k,v)
    Citizen.CreateThread(function()
        while sheesh == true do
            exports.ox_target:addBoxZone({coords = v.pos, size = vector3(1,1,1), debug = true, drawSprite = true, options = {
                {
                    label = 'Setup Pins',
                    icon = 'fas fa-arrow-circle-down',
                    onSelect = function() TriggerEvent('bp-bowling:setupPins', {v = k}) end,
                },
            }})
            -- exports['qb-target']:AddBoxZone("bp-bowling:lane_"..k, v.pos, 1.8, 2.0, {
            --     name = "bp-bowling:lane_"..k,
            --     heading = 0.0,
            --     minZ=20.85,
            --     maxZ=14.85,
            --     debugPoly = true
            -- }, {
            --     options = {
            --         {
            --             Action = 'bp-bowling:setupPins',
            --             isEvent = true,
            --             icon = 'fas fa-arrow-circle-down',
            --             label = 'Setup Pins',
            --             args = { v = k }
            --         }
            --     },
            --     job = {"all"},
            --     distance = 2.0
            -- })
            sheesh = false
            Citizen.Wait(0)
        end
    end)

end

RegisterNetEvent('bp-bowling:syncLane')
AddEventHandler("bp-bowling:syncLane", function(lane, bool)
    lanes[lane].enabled = bool
end)

RegisterNetEvent('bp-bowling:bowlingPurchase')
AddEventHandler("bp-bowling:bowlingPurchase", function(data)
    local isLane = type(data.key) == "number"
    if isLane and boughtTicket then QBCore.Functions.Notify("You already bought a lane ticket!") return end
    if not isLane and boughtBall then QBCore.Functions.Notify("You already bought a bowling ball!") return end
    QBCore.Functions.TriggerCallback('bp-bowling:purchaseItem', function(response)
        if response == true then
            if(isLane == true) then
                boughtTicket = true
                for k, v in pairs(lanes) do
                    if(canUseLane(k) == true) then
                        sheesh = true
                        shit(k , v)

                    end
                end
                TriggerServerEvent('bp-bowling:syncLane', data.key, false)
                lanes[data.key].enabled = false
                lastlane = data.key
                QBCore.Functions.Notify("You've successfuly bought lane access | Lane: "..data.key.."#")
            else
                boughtBall = true
                QBCore.Functions.Notify("You've successfuly bought a Bowling Ball")
            end
            return
        end

    end , data.key , isLane)


end)

AddEventHandler('bp-bowling:setupPins', function(pParameters)
    local lane = pParameters.v
    if (not lanes[lane]) then return end
    if (hasActivePins) then return end
    removeBowlingBall()
    if gamesPlayed > 5 then
        TriggerServerEvent("bp-bowling:RemoveItem")
        boughtTicket = false
        boughtBall = false
        TriggerServerEvent('bp-bowling:syncLane', lastlane, true)
        lanes[lastlane].enabled = true
        gamesPlayed = 0
    return end
    gamesPlayed = gamesPlayed + 1
    hasActivePins = true
    currentLane = lane
    drawStatusHUD(true)
    createPins(lanes[lane].pins)
end)



local function canUseBall()
    --Midnight.Functions.Debug('Can use ball?', inBowlingZone)
    return (lastBall == 0 or lastBall + 6000 < GetGameTimer()) and (inBowlingZone)
end

local function resetBowling()
    removePins()
    hasActivePins = false
    drawStatusHUD(false)
end

local gameState = {}
gameState[1] = {
    onState = function()
        if (totalDowned >= 10) then
            QBCore.Functions.Notify("Strike!")

            drawStatusHUD(true, {"Strike!"})
            Citizen.Wait(5000)
            TriggerServerEvent('bowling:updateScore', lastlane, gamesPlayed, 1, totalDowned)

            resetBowling()
            totalDowned = 0
            totalThrown = 0
            if gamesPlayed >= 5 then
                QBCore.Functions.Notify("5 games played! Buy a new ticket a the counter.", 'error')
                TriggerServerEvent("bp-bowling:RemoveItem")
                boughtTicket = false
                boughtBall = false
                TriggerServerEvent('bp-bowling:syncLane', lastlane, true)
                lanes[lastlane].enabled = true
                gamesPlayed = 0
                Wait(2000)
                TriggerServerEvent('bowling:finishScore', lastlane)
                lastlane = 0
            end
        elseif (totalDowned < 10) then
            removeDownedPins()
            drawStatusHUD(true, {"Throw again!"})
            TriggerServerEvent('bowling:updateScore', lastlane, gamesPlayed, 1, totalDowned)
        end
    end
}
gameState[2] = {
    onState = function()
        if (totalDowned >= 10) then
            drawStatusHUD(true, {"Spare!"})
            QBCore.Functions.Notify("Spare!")
            Citizen.Wait(5000)
        elseif (totalDowned < 10) then
            drawStatusHUD(true)
            QBCore.Functions.Notify("You downed " .. totalDowned .. " pins!")

            Citizen.Wait(5000)
        end
        TriggerServerEvent('bowling:updateScore', lastlane, gamesPlayed, 2, totalDowned)
        totalDowned = 0
        totalThrown = 0
        if gamesPlayed >= 5 then
            QBCore.Functions.Notify("5 games played! Buy a new ticket a the counter.", 'error')
            TriggerServerEvent("bp-bowling:RemoveItem")
            boughtTicket = false
            boughtBall = false
            TriggerServerEvent('bp-bowling:syncLane', lastlane, true)
            lanes[lastlane].enabled = true
            gamesPlayed = 0
            Wait(2000)
            TriggerServerEvent('bowling:finishScore', lastlane)
            lastlane = 0
        end
        resetBowling()
    end
}

RegisterNetEvent('bp-bowling:client:itemused')
AddEventHandler('bp-bowling:client:itemused' , function()
    if (IsPedInAnyVehicle(PlayerPedId(), true)) then return end

    -- Cooldown
    if not canUseBall() then return end
    startBowling(false, function(ballObject)
        lastBall = GetGameTimer()

        if (hasActivePins) then
            totalThrown = totalThrown + 1

            local isRolling = true
            local timeOut = false

            while (isRolling and not timeOut) do
                Citizen.Wait(100)

                local ballPos = GetEntityCoords(ballObject)

                if (lastBall == 0 or lastBall + 10000 < GetGameTimer()) then
                    timeOut = true
                end

                if (ballPos.x < 730.0) then
                    -- Finish line baby
                    isRolling = false
                end
            end

            Citizen.Wait(5000)

            totalDowned = getPinsDownedCount()

            if (timeOut) then
                drawStatusHUD(true, {"Time's up!"})
                timeOut = false
            end

            if (gameState[totalThrown]) then
                gameState[totalThrown].onState()
            end

            removeBowlingBall()

        end
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    drawStatusHUD(false)
end)