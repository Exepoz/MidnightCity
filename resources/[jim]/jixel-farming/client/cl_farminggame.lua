local Zones = {}
local Targets = {}
DryingItems = {}
CuringItems = {}
gameStarted = false

local Keys = {
    [322] = 'ESC', [288] = 'F1', [289] = 'F2', [170] = 'F3', [166] = 'F5', [167] = 'F6', [168] = 'F7', [169] = 'F8', [56] = 'F9', [57] = 'F10',
    [243] = '~', [157] = '1', [158] = '2', [160] = '3', [164] = '4', [165] = '5', [159] = '6', [161] = '7', [162] = '8', [163] = '9', [84] = '-', [83] = '=', [177] = 'BACKSPACE',
    [37] = 'TAB', [44] = 'Q', [32] = 'W', [38] = 'E', [45] = 'R', [245] = 'T', [246] = 'Y', [303] = 'U', [199] = 'P', [39] = '[', [40] = ']', [18] = 'ENTER',
    [137] = 'CAPS', [34] = 'A', [8] = 'S', [9] = 'D', [23] = 'F', [47] = 'G', [74] = 'H', [311] = 'K', [182] = 'L',
    [21] = 'LEFTSHIFT', [20] = 'Z', [73] = 'X', [26] = 'C', [0] = 'V', [29] = 'B', [249] = 'N', [244] = 'M', [82] = ',', [81] = '.',
}

local PickingJobData = {
    jobDifficulty = 0,
    currentField = 0,
    remainingHarvest = 0,
    numOfActivePoints = 0,
    activeHarvestPoints = {}
}

local CayoZones = CayoPericoZone.Fields

local function isOnJob(zoneIndex)
    if PickingJobData.remainingHarvest > 0 and PickingJobData.currentField == zoneIndex then
        return true
    else
        return false
    end
end

local function getFormatedRemainingTime(table)
	local result
	local remainingTime = table.finishTime - GetGameTimer()
    local isZero = remainingTime <= 0
    if remainingTime > 60000 then
        remainingTime = string.format("%sm",math.max(0,math.ceil(remainingTime / 60000)))
    else
        remainingTime = string.format("%ss",math.max(0,math.ceil(remainingTime / 1000)))
    end
    return remainingTime, isZero
end
--#region Points
function GeneratePoints(zoneIndex)
    local zone = CayoZones[zoneIndex]
    if Config.DebugOptions.Debug then
    print("Setting Up zone Points: "..zoneIndex)
    end
    pointOptions = zone.Points.Options
    zone.Points.HarvestPoints = {}
    pointPair = zone.Points.firstLine
    local pointA = pointPair[1]
    local pointB = pointPair[2]
    local direction = pointB - pointA
    local magnitude = math.sqrt(direction.x^2 + direction.y^2)
    local normal = vector3(-direction.y, direction.x, 0) / magnitude * pointOptions.lineOffset

    for line = 0, pointOptions.linesPerField - 1 do
        local lineStart = pointA - normal * line
        local lineEnd = pointB - normal * line
        for i = 0, 1, 1/(pointOptions.pointsPerLine-1) do
            local t = i
            local x = lerp(lineStart.x, lineEnd.x, t)
            local y = lerp(lineStart.y, lineEnd.y, t)
            table.insert(zone.Points.HarvestPoints, vector3(x, y, 0))
        end
    end
end

local function getRandomPoint(zoneIndex)
    local harvestPoints = CayoZones[zoneIndex].Points.HarvestPoints
    if #harvestPoints <= CayoZones[zoneIndex].Points.ActivePointAmount then
        return error("Too many active points for the amount of points in the zone: "..#harvestPoints.." "..CayoZones[zoneIndex].Points.ActivePointAmount)
    end
    local randomPoint = CayoZones[zoneIndex].Points.HarvestPoints[math.random(1, #harvestPoints)]
    local attempts = 0
    while PickingJobData.activeHarvestPoints[randomPoint] do
        randomPoint = CayoZones[zoneIndex].Points.HarvestPoints[math.random(1, #harvestPoints)]
        attempts = attempts + 1
        if attempts > 100 then
            return error("Unable to find an unused point after 100 attempts")
        end
    end
    if Config.DebugOptions.Debug then print("Random point selected: "..randomPoint) end
    local newZ = GetCoordZ(randomPoint.x, randomPoint.y)
    return vector3(randomPoint.x, randomPoint.y, newZ)
end

local function spawnRandHarvestPoint(zoneIndex)
    if Config.DebugOptions.Debug then print('Hey im picking a random point for zone: '..tostring(zoneIndex)) end
    while PickingJobData.numOfActivePoints < CayoZones[zoneIndex].Points.ActivePointAmount do
        local point = getRandomPoint(zoneIndex)
        PickingJobData.numOfActivePoints += 1
        print("Adding Point:"..point)
        PickingJobData.activeHarvestPoints[point] = {
            draw = function() DrawMarker(1, point.x, point.y, point.z, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 0, 0, 100, true, true, 2, false, false, false, false) end
        }
    end
end

local function removePoint(point)
    PickingJobData.activeHarvestPoints[point] = nil
    PickingJobData.numOfActivePoints -= 1
    PickingJobData.remainingHarvest -= 1
end


local function isPlayerCloseToPoint()
    local playerPos = GetEntityCoords(PlayerPedId())
    for point, _ in pairs(PickingJobData.activeHarvestPoints) do
        if #(playerPos - point) < 1.5 then
            return true, point
        end
    end
end
--#endregion
RegisterNetEvent(
    "jixel-farming:client:jobmenu",
    function()
        local Menu = {}
        if Config.CoreOptions.Menu ~= "ox" then
            Menu[#Menu + 1] = {icon = "fas fa-tractor", header = "Farm Job Menu", isMenuHeader = true}
            Menu[#Menu + 1] = {
                icon = "fas fa-circle-xmark",
                header = Loc[Config.CoreOptions.Lan].menu["close"],
                params = {event = "qb-menu:client:closeMenu"}
            }
        end

        for key, jobDifficulty in ipairs(CayoPericoZone.JobDifficulty) do
            Menu[#Menu + 1] = {
                icon = "fas fa-car-tunnel",
                header = Loc[Config.CoreOptions.Lan].menu["job_size"] .. " [" .. jobDifficulty.label .. "]",
                title = Loc[Config.CoreOptions.Lan].menu["job_size"] .. " [" .. jobDifficulty.label .. "]",
                event = "jixel-farming:client:StartPickingGame",
                args = {harvestAmount = jobDifficulty.stops(), jobDifficulty = key}, -- The chosen stop amount will be passed as an argument
                params = {
                    event = "jixel-farming:client:StartPickingGame",
                    args = {harvestAmount = jobDifficulty.stops(), jobDifficulty = key}
                } -- The chosen stop amount will be passed as an argument
            }
        end

        if Config.CoreOptions.Menu == "ox" then
            exports.ox_lib:registerContext(
                {id = "farming_joboptions", title = "Farm Job Menu", position = "top-right", options = Menu}
            )
            exports.ox_lib:showContext("farming_joboptions")
        else
            exports["qb-menu"]:openMenu(Menu)
        end
    end
)

local isPlayerInsideZone = false
local function DebugHarvestPoints(zoneIndex)
    if Config.DebugOptions.Debug then
        print("Debuging Harvest points for zone:" .. zoneIndex)
        CreateThread(
            function()
                while isPlayerInsideZone do
                    for _, point in pairs(CayoZones[zoneIndex].Points.HarvestPoints) do
                        local newZ = GetCoordZ(point.x, point.y, true)
                        DrawMarker(  1, point.x, point.y,  newZ, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 0, 0, 100, true, true, 2, false, false, false, false)
                    end
                    Wait(0)
                end
            end
        )
    end
end

local pickGameKey = CayoPericoZone.PickUpKey
local keyz = Keys[pickGameKey]
local function setupZoneInOutCheck(zone)
    zone.zone:onPlayerInOut(
        function(isPointInside)
            isPlayerInsideZone = isPointInside
            DebugHarvestPoints(zone.index)
            if isPlayerInsideZone and isOnJob(zone.index) then
                exports[Config.CoreOptions.CoreName]:DrawText(
                    Loc[Config.CoreOptions.Lan].drawtext["pick"] .. keyz,
                    "right"
                )
                spawnRandHarvestPoint(zone.index)
                CreateThread(
                    function()
                        while isPlayerInsideZone and isOnJob(zone.index) do
                            if IsControlJustPressed(0, pickGameKey) then
                                local isCloseToPoint, point = isPlayerCloseToPoint()
                                if isCloseToPoint then
                                    PickThing("jixel-farming:client:PickThing", point)
                                end
                            end
                            for point, data in pairs(PickingJobData.activeHarvestPoints) do
                                data.draw()
                            end
                            Wait(0)
                        end
                    end
                )
            else
                exports[Config.CoreOptions.CoreName]:HideText()
            end
        end
    )
end

RegisterNetEvent(
    "jixel-farming:client:StartPickingGame",
    function(data)
        if not gameStarted then
            gameStarted = true
        else
            return triggerNotify(nil, "You've already started a game", "error")
        end
        math.randomseed(GetGameTimer())
        PickingJobData.jobDifficulty = data.jobDifficulty
        PickingJobData.remainingHarvest = data.harvestAmount
        PickingJobData.currentField = math.random(1, #CayoZones)
        PickingJobData.activeHarvestPoints = {}
        PickingJobData.numOfActivePoints = 0
        SetNewWaypoint(
            CayoZones[PickingJobData.currentField].WayPoint.x,
            CayoZones[PickingJobData.currentField].WayPoint.y
        )
        if Config.DebugOptions.Debug then
            print(
                string.format(
                    "Field %s has been selected. Go harvest %s amount of stuff",
                    PickingJobData.currentField,
                    PickingJobData.remainingHarvest
                )
            )
        end
        exports[Config.CoreOptions.CoreName]:DrawText(
            Loc[Config.CoreOptions.Lan].drawtext["starttobbacoharvest"] .. PickingJobData.currentField,
            "right"
        )
    end
)

RegisterNetEvent(
    "jixel-farming:client:PickThing",
    function(data)
        local animDictNow = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
        local animNow = "plant_floor"
        local item = CayoPericoZone.Item
        EmoteCancel()
        if
            progressBar(
                {
                    label = Loc[Config.CoreOptions.Lan].progress["progress_harvesting"] ..
                        QBCore.Shared.Items[item].label,
                    time = 5000,
                    dict = animDictNow,
                    anim = animNow,
                    flag = 49,
                    cancel = true,
                    icon = data.item
                }
            )
         then
            print(CayoPericoZone.JobDifficulty[PickingJobData.jobDifficulty].amount())
            TriggerServerEvent(
                "jixel-farming:server:PickThing",
                CayoPericoZone.JobDifficulty[PickingJobData.jobDifficulty].amount()
            )
            removePoint(data[1])
            if PickingJobData.remainingHarvest == 0 then
                triggerNotify(nil, Loc[Config.CoreOptions.Lan].notification["completedharvest"], "success")
                gameStarted = false
            end
            if Config.DebugOptions.Debug then
                print("Picked Tobacco Remaining Picks is: " .. PickingJobData.remainiZZngHarvest)
            end
            spawnRandHarvestPoint(PickingJobData.currentField)
        else
            triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["cancel"], "error")
        end
        ClearPedTasks(PlayerPedId())
    end
)

--#region Drying/Curing
RegisterNetEvent(
    "jixel-farming:client:DryingMenu",
    function(data)
        local GameMenu = {}
        if Config.CoreOptions.Menu ~= "ox" then
            GameMenu[#GameMenu + 1] = {
                icon = "fas fa-tractor",
                header = Loc[Config.CoreOptions.Lan].menu["job_header"],
                isMenuHeader = true
            }
            GameMenu[#GameMenu + 1] = {
                icon = "fas fa-circle-xmark",
                header = Loc[Config.CoreOptions.Lan].menu["close"],
                params = {event = "qb-menu:client:closeMenu"}
            }
        end
        if DryingItems[data.id] then
            local remainingTime, timeIsComplete = getFormatedRemainingTime(DryingItems[data.id])
            local header = string.format("%s (%s)", Loc[Config.CoreOptions.Lan].menu["time_remaining"], remainingTime)
            if timeIsComplete then
                header = string.format("%s (%s)", Loc[Config.CoreOptions.Lan].menu["time_finished"], remainingTime)
            end
            GameMenu[#GameMenu + 1] = {
                icon = "nui://" .. Config.CoreOptions.img .. QBCore.Shared.Items[DryingItems[data.id].item].image,
                header = header,
                title = header,
                event = "jixel-farming:client:CheckDrying",
                args = {tableId = data.id},
                params = {event = "jixel-farming:client:CheckDrying", args = {tableId = data.id}}
            }
        else
            for key, item in pairs(data.dryingItems) do
                local disable = false
                local setheader = QBCore.Shared.Items[key].label
                if not HasItem(item.item.name, item.item.amount) then
                    disable = true
                end
                if not disable then
                    setheader = setheader .. "✔️"
                end
                GameMenu[#GameMenu + 1] = {
                    icon = "nui://" .. Config.CoreOptions.img .. QBCore.Shared.Items[key].image,
                    header = setheader,
                    title = key,
                    disabled = (Config.CoreOptions.Menu == "ox" and disable),
                    event = "jixel-farming:client:StartDrying",
                    args = {
                        item = key,
                        amount = item.amount,
                        tableId = data.id
                    },
                    params = {
                        event = "jixel-farming:client:StartDrying",
                        args = {item = key, amount = item.amount, tableId = data.id}
                    }
                }
            end
        end
        if Config.CoreOptions.Menu == "ox" then
            exports.ox_lib:registerContext(
                {id = "DryingMenu", title = "Drying Menu", position = "top-right", options = GameMenu}
            )
            exports.ox_lib:showContext("DryingMenu")
        else
            exports["qb-menu"]:openMenu(GameMenu)
        end
    end
)

RegisterNetEvent(
    "jixel-farming:client:CuringMenu",
    function(data)
        local CuringMenu = {}
        if Config.CoreOptions.Menu ~= "ox" then
            CuringMenu[#CuringMenu + 1] = {
                icon = "fas fa-tractor",
                header = Loc[Config.CoreOptions.Lan].menu["job_header"],
                isMenuHeader = true
            }
            CuringMenu[#CuringMenu + 1] = {
                icon = "fas fa-circle-xmark",
                header = Loc[Config.CoreOptions.Lan].menu["close"],
                params = {event = "qb-menu:client:closeMenu"}
            }
        end
        if CuringItems[data.id] then
            local remainingTime, timeIsComplete = getFormatedRemainingTime(CuringItems[data.id])
            local header = string.format("%s (%s)", Loc[Config.CoreOptions.Lan].menu["time_remaining"], remainingTime)
            if timeIsComplete then
                header = string.format("%s (%s)", Loc[Config.CoreOptions.Lan].menu["time_finished"], remainingTime)
            end
            CuringMenu[#CuringMenu + 1] = {
                icon = "nui://" .. Config.CoreOptions.img .. QBCore.Shared.Items[CuringItems[data.id].item].image,
                header = header,
                title = header,
                event = "jixel-farming:client:CheckCuring",
                args = {tableId = data.id},
                params = {event = "jixel-farming:client:CheckCuring", args = {tableId = data.id}}
            }
        else
            for key, item in pairs(data.cureItems) do
                local disable = false
                local setheader = QBCore.Shared.Items[key].label
                if not HasItem(item.item.name, item.item.amount) then
                    disable = true
                end
                if not disable then
                    setheader = setheader .. "✔️"
                end
                CuringMenu[#CuringMenu + 1] = {
                    icon = "nui://" .. Config.CoreOptions.img .. QBCore.Shared.Items[key].image,
                    header = setheader,
                    title = key,
                    disabled = (Config.CoreOptions.Menu == "ox" and disable),
                    event = "jixel-farming:client:StartCuring",
                    args = {
                        item = key,
                        amount = item.amount,
                        tableId = data.id
                    },
                    params = {
                        event = "jixel-farming:client:StartCuring",
                        args = {item = key, amount = item.amount, tableId = data.id}
                    }
                }
            end
        end

        if Config.CoreOptions.Menu == "ox" then
            exports.ox_lib:registerContext(
                {id = "CuringMenu", title = "Curing Menu", position = "top-right", options = CuringMenu}
            )
            exports.ox_lib:showContext("CuringMenu")
        else
            exports["qb-menu"]:openMenu(CuringMenu)
        end
    end
)

RegisterNetEvent(
    "jixel-farming:client:StartDrying",
    function(data)
        local craftItem = Crafting.Drying[data.item]
        if not HasItem(craftItem.item.name, craftItem.item.amount) then
            return
        end
        DryingItems[data.tableId] = {
            id = data.tableId,
            finishTime = GetGameTimer() + (craftItem.dryingTime * 60000),
            remainingTime = craftItem.dryingTime * 60000,
            item = data.item,
            amount = data.amount
        }
        TriggerServerEvent("jixel-farming:server:StartDrying", DryingItems[data.tableId])
    end
)

RegisterNetEvent(
    "jixel-farming:client:StartCuring",
    function(data)
        local craftItem = Crafting.Curing[data.item]
        if not HasItem(craftItem.item.name, craftItem.item.amount) then
            return
        end
        CuringItems[data.tableId] = {
            id = data.tableId,
            finishTime = GetGameTimer() + (craftItem.curingTime * 60000),
            remainingTime = craftItem.curingTime * 60000,
            item = data.item,
            amount = data.amount
        }
        TriggerServerEvent("jixel-farming:server:StartCuring", CuringItems[data.tableId])
    end
)

RegisterNetEvent(
    "jixel-farming:client:CheckDrying",
    function(data)
        local dryingItem = DryingItems[data.tableId]
        if not dryingItem then
            return
        end
        local result
        local remainingTime = dryingItem.finishTime - GetGameTimer()
        dryingItem.remainingTime = math.max(0, remainingTime)
        if remainingTime <= 0 then
            TriggerServerEvent("jixel-farming:server:CheckDrying", data)
        end
    end
)

RegisterNetEvent(
    "jixel-farming:client:FinishDrying",
    function(tableId)
        DryingItems[tableId] = nil
    end
)

RegisterNetEvent(
    "jixel-farming:client:CheckCuring",
    function(data)
        local curingItem = CuringItems[data.tableId]
        if not curingItem then
            return
        end
        local result
        local remainingTime = curingItem.finishTime - GetGameTimer()
        curingItem.remainingTime = math.max(0, remainingTime)
        if remainingTime <= 0 then
            TriggerServerEvent("jixel-farming:server:CheckCuring", data)
        end
    end
)

RegisterNetEvent(
    "jixel-farming:client:FinishCuring",
    function(tableId)
        CuringItems[tableId] = nil
    end
)
--#endregion

for i, area in ipairs(CayoZones) do
    local zone = area.Zone
    Zones["Cayo_" .. i] = {
        index = i,
        zone = PolyZone:Create(
            zone,
            {
                name = "Cayo_" .. i,
                heading = zone.h,
                debugPoly = Config.DebugOptions.Debug
            }
        )
    }
    GeneratePoints(i)
    setupZoneInOutCheck(Zones["Cayo_" .. i])
end

AddEventHandler(
    "onResourceStop",
    function(resource)
        if resource == GetCurrentResourceName() then
            for key, _ in pairs(Targets) do
                exports["qb-target"]:RemoveZone(key)
            end
        end
    end
)
