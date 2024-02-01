local QBCore = exports['qb-core']:GetCoreObject()
local AllGreenZones = {}

local function MakeBlip(blipCoords, blipSprite, blipDisplay, blipScale, blipColour, blipName)
	local Blip = AddBlipForCoord(blipCoords)
	SetBlipSprite(Blip, blipSprite)
	SetBlipDisplay(Blip, blipDisplay)
	SetBlipScale(Blip, blipScale)
	SetBlipColour(Blip, blipColour)
	SetBlipAsShortRange(Blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(blipName)
	EndTextCommandSetBlipName(Blip)
    -- if Config.Framework.Debug then
    --     print('Constant Development Closed Shops Blip Activated')
    -- end
end

RegisterCommand('lightinfo', function(source, args)
    print(GetEntityCoords(PlayerPedId())- vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
    lib.setClipboard(GetEntityCoords(PlayerPedId())- vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3])))
end)

--- Checks if player is inside a green zone & updtaes their Player State Bag
checkIsInsideGreenZone = function()
    local inZone = false
    if not LocalPlayer.state.Loaded then return inZone end
    for _, v in pairs(AllGreenZones) do
        if v.insideZone then
            LocalPlayer.state:set('inGreenZone', true, true)
            LocalPlayer.state:set('currentGreenZone', v.zoneName, true)
            inZone = true
            break
        end
    end
    if not inZone then
        LocalPlayer.state:set('inGreenZone', false, true)
        LocalPlayer.state:set('currentGreenZone', 'none', true)
    end
    return inZone
end

local canBeHunted = function()
end

local outsideLocations = {
	vector3(-616.98, -1509.04, 0.27),
	vector3(-561.31, -1526.81, 0.34),
	vector3(-503.77, -1547.53, 1.16),
	vector3(-438.53, -1595.44, 0.27),
	vector3(-504.65, -1635.71, 18.83),
	vector3(-480.55, -1683.35, 19.51),
	vector3(-516.02, -1677.33, 19.48),
	vector3(-608.26, -1678.96, 19.75),
}
local sendOutside = function()
    Wait(math.random(2,4)*1000)
	local ped = PlayerPedId()
	QBCore.Functions.Notify("Get the fuck out of here, you outlaw...", "error")
	SetPedToRagdollWithFall(ped, 2500, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	DoScreenFadeOut(3000)
	Wait(4000)
	SetEntityCoords(ped, outsideLocations[math.random(#outsideLocations)])
	SetPedToRagdollWithFall(ped, 10000, 3000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	Wait(2000)
	DoScreenFadeIn(3000)
	QBCore.Functions.Notify("You\'re lucky we didnt kill you!", "error")
end

--- Zone Handler for entering a green zone
---@param self table table containing all of the current zone's info
local enterGreenZone = function(self)
    local wait, stop = false, false
    if self.zoneName == 'crimHub' then
        wait = true
        Midnight.Functions.IsBlackListed():next(function(isBl)
            if isBl then
                while IsPedInAnyVehicle(PlayerPedId()) do Wait(100) end
                stop, wait = true, false
                sendOutside()
            else
                wait = false
                TriggerEvent('crimHub:client:SetupQuartermaster')
            end
        end)
    end
    while wait do Wait(0) end
    if stop then return end
    if LocalPlayer.state.inGreenZone == false then
        if Midnight.Functions.IsNightTime() then
            exports['qb-phone']:PhoneNotification('The Hunt', "You are no longer a bounty target.", 'fas fa-dove', '#558ac2', 5000)
            TriggerServerEvent('nighttime:server:leaveHunt')
        end
        LocalPlayer.state:set('inGreenZone', true, true)
        LocalPlayer.state:set('currentGreenZone', self.zoneName, true)
    end
end

--- Zone Handler for leaving a green zone
---@param self table table containing all of the current zone's info
local leavingGreenZone = function(self)
    if self.zoneName == 'crimHub' then
        TriggerEvent('crimHub:client:removeQuartermaster')
    end
    LocalPlayer.state:set('inGreenZone', false, true)
    LocalPlayer.state:set('currentGreenZone', 'none', true)
    if not Midnight.Functions.IsNightTime() then return end
    if not Config.Debug then Wait(math.random(30, 75) * 1000) end
    if LocalPlayer.state.inGreenZone == false then
        exports['qb-phone']:PhoneNotification('The Hunt', "You can be targeted by hunters.", 'fas fa-crosshairs', '#5c0707', 5000)
        TriggerServerEvent('nighttime:server:enterHunt')
    end
end

--- Create a green zone with the proper params
---@param name string -- Name of the Green Zone
---@param p table -- Points to make the ox_lib zone
---@param t number -- ox_lib zone thickness (Height)
local createGreenZone = function(name, p, t)
    local z = lib.zones.poly({
        points = p, thickness = t,
        onEnter = enterGreenZone,
        onExit = leavingGreenZone,
        debug = Config.DebugPoly,
        zoneName = name
    })
    AllGreenZones[name] = z
end

--- Turns on the zones green lights when the player is close enough
---@param coords vec3 -- Center of the zone to calculate if lights are on or off.
---@param lights table -- Table containing all of the lights info (coords, dir, d(istance), b(rightness), h(ardness) , r(adius), f(eathering))
local makeGreenLights = function(coords, lights)
    local p = lib.points.new(coords, 150.0)
    function p:nearby()
        if not Midnight.Functions.IsNightTime() then
            Wait(5000)
        else for _, v in pairs(lights) do
                DrawSpotLight(v.coords.x, v.coords.y, v.coords.z, v.dir, 0, 255, 0, v.d, v.b, v.h, v.r, v.f)
            end
        end
    end
end

local PrepareTheDistrict = function()
    exports.ox_target:addBoxZone({coords = vector3(998.82, -2325.09, 30.56), size = vector3(1.5, 20, 2), rotation = -5, debug = Config.DebugPoly, drawSprite = true, options = {
        {label = 'Personal Storage', icon = 'fas fa-box-open', onSelect = function()
            local name = "The District_"..QBCore.Functions.GetPlayerData().citizenid
            TriggerServerEvent("inventory:server:OpenInventory", "stash", name, {maxweight = 200000, slots = 20})
            TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
            TriggerEvent("inventory:client:SetCurrentStash", name)
        end}
    }})
    exports.ox_target:addBoxZone({coords = vector3(976.12,-2352.59, 30.56), size = vector3(1, 1, 2), rotation = 0, debug = Config.DebugPoly, drawSprite = true, options = {
        {label = 'Go to bed. (Exit Game)', icon = 'fas-fa-bed', onSelect = function() TriggerServerEvent('nighttime:GoToBed') end}
    }})
    MakeBlip(vector3(991.17, -2330.57, 30.58), 475, 3, 0.7, 22, "The District")
end

--- Thread to start all zones & green lights
Citizen.CreateThread(function()
    for k,v in pairs(Config.GreenZones) do
        createGreenZone(v.name, v.points, v.thickness)
        makeGreenLights(v.center, v.lights)
    end
    PrepareTheDistrict()
end)

RegisterNetEvent('nighttime:client:nightWarning', function(warn)
    if Midnight.Functions.safeJob() then return end
    if warn == 'pre' then
        exports['qb-phone']:PhoneNotification('Night Approaching', "Careful, it\'s getting dark...", 'fas fa-moon', '#558ac2', 15000)
        for _ = 1, 5 do
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(120)
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(120)
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(1000)
        end
    elseif warn == 'night' then
        exports['qb-phone']:PhoneNotification('The Hunt', "You can be targeted by hunters.", 'fas fa-crosshairs', '#5c0707', 15000)
        exports['qb-phone']:ToggleDayTime(false)
        for _ = 1, 5 do
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(120)
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(120)
            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) Wait(1000)
        end
        if not checkIsInsideGreenZone() then TriggerServerEvent('nighttime:server:enterHunt') end
    elseif warn == 'day' then
        exports['qb-phone']:ToggleDayTime(true)
        exports['qb-phone']:PhoneNotification('The Hunt', "You survived the hunt.", 'fas fa-sun', '#558ac2', 15000)
        if LocalPlayer.state.isHunting then
            Midnight.Functions.stopHunting()
            Wait(10000)
            exports['qb-phone']:PhoneNotification('The Hunt', "Hunting is over, thanks for playing.", 'fas fa-skull', '#5c0707', 15000)
        end
    end
end)

AddEventHandler('onClientResourceStart', function(resName)
    if (GetCurrentResourceName() ~= resName) then return end
    Wait(5000) if not checkIsInsideGreenZone() and Midnight.Functions.IsNightTime() then
        if not Config.Debug then Wait(math.random(30, 75) * 1000) end
        if LocalPlayer.state.inGreenZone == false then
            exports['qb-phone']:PhoneNotification('The Hunt', "You can be targeted by hunters.", 'fas fa-crosshairs', '#5c0707', 5000)
            TriggerServerEvent('nighttime:server:enterHunt')
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LocalPlayer.state.Loaded = true
    Wait(5000) if not checkIsInsideGreenZone() and Midnight.Functions.IsNightTime() then
        if not Config.Debug then Wait(math.random(30, 75) * 1000) end
        if LocalPlayer.state.inGreenZone == false then
            exports['qb-phone']:PhoneNotification('The Hunt', "You can be targeted by hunters.", 'fas fa-crosshairs', '#5c0707', '5000')
            TriggerServerEvent('nighttime:server:enterHunt')
        end
    end
    TriggerServerEvent('nighttime:server:checkIsBloodyPrey')
end)
