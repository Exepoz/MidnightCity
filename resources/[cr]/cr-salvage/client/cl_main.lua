local wreckage, ScrapyardPed
local saw
local soundId
local Pfx = {}
local YardBlip
local worldwreck
local textup = false
local WWBlip
local IsNearScrapYard
LocalPlayer.state:set('IsSalvaging', false, true)

-- Loading Functions
function LoadModel(model)
    while not HasModelLoaded(model) do
        Wait(5)
        RequestModel(model)
    end
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local function LoadPfxAsset(Asset)
    while not HasNamedPtfxAssetLoaded(Asset) do
        RequestNamedPtfxAsset(Asset)
        Wait(50)
    end
end

-- Busy Checks
function PlayerBusy()
	Citizen.CreateThread(function()
        while LocalPlayer.state['IsSalvaging'] do
            CRDisableControls(true)
            Wait(1)
            if not LocalPlayer.state['IsSalvaging'] then break end
        end
    end)
end

-- Peds Creation
function CreatePedAtCoords(pedModel, coords, scrapyard)
    if type(pedModel) == "string" then pedModel = GetHashKey(pedModel) end
    LoadModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if scrapyard then ScrapPedTarget(ped) end
    return ped
end

-- Stop Scrapping
function StopSalvage()
    if LocalPlayer.state['IsSalvaging'] then
        TriggerServerEvent('cr-salvage:server:StopPfx')
        StopSound(soundId)
        textup = false
        ClearPedTasks(PlayerPedId())
        if DoesEntityExist(saw) then DeleteObject(saw) end
        SCUtils.SalvageDrawText(false)
        LocalPlayer.state:set('IsSalvaging', false, true)
    end
end exports('StopSalvage', StopSalvage)

-- UI When Scrapping
CreateThread(function()
    local time
    while true do
        if LocalPlayer.state['IsSalvaging'] then
            time = 10
            if Config.SalvageBehaviour == "skillcheck" then
                if not textup then SCUtils.SalvageDrawText(true, Lcl('notif_stopsalvage', Config.InteractKey)) textup = true end
            end
            if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then StopSalvage() end
        else time = 5000 end
        Wait(time)
    end
end)


function ShowText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    --SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function ScrapWreck(world)
    if Config.SalvageBehaviour == "skillcheck" then
        local time
        while LocalPlayer.state['IsSalvaging'] do
            if world then
                time = (math.random(Config.WorldWrecks.ScrapTime.min, Config.WorldWrecks.ScrapTime.max)*1000)
            else
                time = (math.random(Config.YardWrecks.ScrapTime.min, Config.YardWrecks.ScrapTime.max)*1000)
            end
            Wait(time)
            if LocalPlayer.state['IsSalvaging'] then
                if Config.SkillCheck.Enabled then
                    SalvageSkillCheck(world)
                else
                    TriggerServerEvent('cr-salvage:server:getScrapLoot', false, world)
                end
            else
                StopSalvage()
                break
            end
        end
    else
        CreateThread(function()
            local breaking = 0
            local progress
            local heating = 0
            local cooling = 0
            local heat = 0
            local start = GetGameTimer()
            local nextloot
            if world then
                nextloot = start + (math.random(Config.WorldWrecks.ScrapTime.min, Config.WorldWrecks.ScrapTime.max)*1000)
            else
                nextloot = start + (math.random(Config.YardWrecks.ScrapTime.min, Config.YardWrecks.ScrapTime.max)*1000)
            end
            while LocalPlayer.state['IsSalvaging'] do
                local pba = ""
                local pbb = ""
                local progressbar = "|"
                local hba = "|"
                local hbb = ""
                local heatbar = ""
                Wait(2)
                if world then progress = GlobalState.CRSalvage.WorldWreckProgress else progress = GlobalState.CRSalvage.YardWreckProgress end
                if progress == 10 then StopSalvage() break end
                if Config.SalvageMinigame.ProgressWhileIdle then breaking = breaking + 1 end
                if IsControlPressed(0, 24) then
                    cooling = 0
                    if not Config.SalvageMinigame.ProgressWhileIdle then breaking = breaking + 1 end
                    nextloot = nextloot - Config.SalvageMinigame.MouseDownProgress
                    heating = heating + (math.random(3) * Config.SalvageMinigame.BladeHeatMultiplier)
                    if heating >= 150 then heat = heat + 1 heating = 0 end
                else
                    if heating > 0 then heating = heating - 1 end
                    if cooling >= 0 then cooling = cooling + (1 * Config.SalvageMinigame.BladeCoolingMultiplier) end
                    if cooling >= 50 then if heat > 0 then heat = heat - 1 end cooling = 0 end
                end
                if breaking >= 100 then
                    if GetGameTimer() >= nextloot then
                        if world then
                            nextloot = GetGameTimer() + (math.random(Config.WorldWrecks.ScrapTime.min, Config.WorldWrecks.ScrapTime.max)*1000)
                        else
                            nextloot = GetGameTimer() + (math.random(Config.YardWrecks.ScrapTime.min, Config.YardWrecks.ScrapTime.max)*1000)
                        end
                        local bonusloot = false
                        if heat >= Config.SalvageMinigame.Sweetspot then bonusloot = true end
                        TriggerServerEvent('cr-salvage:server:getScrapLoot', bonusloot, world)
                    end
                    breaking = 0
                end
                for _ = 0, progress - 1, 1 do
                    pba = pba.."-"
                end
                local diff = 10 - progress
                for _ = 0, diff - 1, 1 do
                    pbb = pbb.."-"
                end
                progressbar = progressbar..'~g~'..pba..'~r~'..pbb.."~w~|"
                for _ = 0, heat - 1, 1 do
                    hba = hba.."|"
                end
                local heatdiff = 9 - heat
                for _ = 0, heatdiff, 1 do
                    hbb = hbb.."|"
                end
                heatbar = heatbar..'~r~'..hba..'~w~'..hbb
                local commands = "~b~[M1]~w~ "..Lcl('salvageUI_Salvage').." ~b~[G]~w~ "..Lcl('salvageUI_Stop')
                if Config.SalvageMinigame.ShowSweetspot then
                    if heat >= Config.SalvageMinigame.Sweetspot then commands = commands.."~y~ - ~g~"..Lcl('salvageUI_Sweetspot').."!" end
                end
                local text = Lcl('salvageUI_Progress').." : "..progressbar.."\n"..Lcl('salvageUI_BladeHeat').." : "..heatbar
                if heat == 10 then StopSalvage() TriggerServerEvent('cr-salvage:server:BreakSaw') break end --BreakSaw(coords) break end
                local textpos = Config.SalvageMinigame.UIPosition.Minigame
                local commandpos = Config.SalvageMinigame.UIPosition.Commands
                ShowText(text, 4, {255, 255, 255}, textpos.scale, textpos.x, textpos.y)
                ShowText(commands, 4, {255, 255, 255}, commandpos.scale, commandpos.x, commandpos.y)
            end
        end)
    end
end

local function ScrapYardBlip(coords)
    YardBlip = AddBlipForRadius(coords, 50.0)
    SetBlipColour(YardBlip, 47)
    SetBlipAlpha(YardBlip, 128)
end

local function SpawnWorldWreck(spawnCoords, wwType)
    if Config.Debug then print(Lcl('debug_spawningPlane', spawnCoords)) end
    local hash = Config.WorldWrecks[wwType].WreckHash
    LoadModel(hash)
    worldwreck = CreateObject(hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, true, false)
    SetEntityHeading(worldwreck, spawnCoords.w)
    SetEntityCollision(worldwreck, true)
    PlaceObjectOnGroundProperly(worldwreck)
    local offset = GetOffsetFromEntityInWorldCoords(worldwreck, 0, 0, -0.1)
    SetEntityCoords(worldwreck, offset)
    FreezeEntityPosition(worldwreck, true)
    SetEntityCoords(worldwreck, (GetEntityCoords(worldwreck) + Config.WorldWrecks[wwType].Locations[GlobalState.CRSalvage.WorldWreckLocation].posOverride))
    if Config.WorldWrecks[wwType].Locations[GlobalState.CRSalvage.WorldWreckLocation].rotOverride ~= vector3(0,0,0) then SetEntityRotation(worldwreck, (Config.WorldWrecks[wwType].Locations[GlobalState.CRSalvage.WorldWreckLocation].rotOverride)) end
    if Config.Debug then print(Lcl('debug_successfulSpawn', hash, worldwreck, offset, wwType)) end
    WorldWreckOnSpawnEvent(worldwreck, offset)
    SetupWorldWreckTarget(worldwreck)
end

RegisterNetEvent('cr-salvage:client:emailnotification', function()
    TriggerServerEvent('cr-salvage:server:ToggleEmails')
    Wait(200)
    if Config.Debug then print(Lcl('debug_emailsToggle', LocalPlayer.state.cr_salvage_emails)) end
end)

RegisterNetEvent('cr-salvage:client:RemoveBB', function()
    local coords = Config.WorldWrecks[GlobalState.CRSalvage.WorlWreckType].Locations[GlobalState.CRSalvage.WorldWreckLocation].coords
    local box = GetClosestObjectOfType(coords.x, coords.y, coords.z, 60.0, Config.FlightBox.Hash, 0, 0, 0)
    DeletePoint("wwSpawnEvent")
    if box and box ~= 0 then
        DeleteObject(box)
        if Config.Debug then print(Lcl('debug_deletingFlightBox')) end
    end
end)

RegisterNetEvent('cr-salvage:client:giveFlightBox', function()
    SCUtils.SalvageDrawText(false)
    if SCUtils.HasItem(Config.FlightBox.Item) then
        TriggerServerEvent('cr-salvage:server:flightboxrewards')
        SCUtils.SalvageNotif(1, Lcl('notif_giveflightbox'), Lcl('salvagetitle'))
    else
        SCUtils.SalvageNotif(2, Lcl('notif_infogiveflightbox'), Lcl('salvagetitle'))
    end
end)

RegisterNetEvent('cr-salvage:client:TakeFlightBox', function(data)
    local ped = PlayerPedId()
    local animDict = "pickup_object"
    local anim = "pickup_low"
    LoadAnimDict(animDict)
    TaskPlayAnim(ped, animDict, anim, 8.0, 8.0, -1, 1, 4.0, 1, 1, 1)
    Wait(1500)
    ClearPedTasks(ped)
    SCUtils.SalvageDrawText(false)
    TriggerServerEvent('cr-salvage:server:TakeBB', GetEntityCoords(data.box))
end)

RegisterNetEvent('cr-salvage:client:GrabEmailBlip')
AddEventHandler('cr-salvage:client:GrabEmailBlip', function()
    SCUtils.SalvageNotif(2, Lcl('notif_GPSUpdated'), Lcl('salvagetitle'))
    local location = Config.WorldWrecks[GlobalState.CRSalvage.WorlWreckType].Locations[GlobalState.CRSalvage.WorldWreckLocation].coords
    local Xoffset = GlobalState.CRSalvage.offset.x
    local Yoffset = GlobalState.CRSalvage.offset.y
    local blipcoords = vector3(location.x + Xoffset, location.y + Yoffset, location.z)
    WWBlip = AddBlipForRadius(blipcoords, 1000.0)
    SetBlipColour(WWBlip, 47)
    SetBlipAlpha(WWBlip, 64)
end)

RegisterNetEvent('cr-salvage:client:SpawnWW', function(wwType, wwLoc)
    Wait(1000)
    if Config.Debug then print(Lcl("debug_wwinfo")) end
    local location = Config.WorldWrecks[wwType].Locations[wwLoc].coords
    local v3 = vector3(location.xyz)
    if LocalPlayer.state['cr_salvage_emails'] then SCUtils.SalvageEmails() TriggerEvent('cr-salvage:client:GrabEmailBlip') end
    local ped = PlayerPedId()
    WorldWreckOnGenerationEvent(wwType, location)
    CreateThread(function()
        local spawned
        while true do
            if not GlobalState.CRSalvage.WorldWreckActive then break end
            local pcoords = GetEntityCoords(ped)
            local dist = #(pcoords - v3)
            if not spawned and dist <= 300 then
                SpawnWorldWreck(location, wwType)
                spawned = true
            end
            if dist <= Config.WorldWrecks.PreciseBlipDistance then
                if WWBlip then
                    RemoveBlip(WWBlip) --801
                    WWBlip = AddBlipForCoord(v3.xyz)
                    SetBlipSprite(WWBlip, 801)
                    SetBlipColour(WWBlip, 47)
                    AddTextEntry('WWBlip', "Wreckage")
                    BeginTextCommandSetBlipName('WWBlip')
                    EndTextCommandSetBlipName(WWBlip)
                    SetBlipScale(WWBlip, 0.7)
                    SetBlipAsShortRange(WWBlip, true)
                    break
                end
            end
            --if Config.Debug then print(Lcl('debug_WorldWreckDistanceCheck', dist)) end
            Wait(5000)
        end
    end)
end)

RegisterNetEvent('cr-salvage:client:DeleteWorldWreck', function(notif)
    if WWBlip then RemoveBlip(WWBlip) end
    DeletePoint("ww")
    if worldwreck then
        if notif then SCUtils.SalvageNotif(2, Lcl('notif_wreckDepleted'), Lcl('salvagetitle')) end
        StopSalvage()
        Wait(1000)
        if DoesEntityExist(worldwreck) then
            while GetEntityAlpha(worldwreck) > 0 do
                SetEntityAlpha(worldwreck, GetEntityAlpha(worldwreck) - 1)
                Wait(2)
            end
            Wait(1000)
            DeleteObject(worldwreck)
        end
    end
end)

RegisterNetEvent('cr-salvage:client:DeleteCurrentWreck', function()
    if IsNearScrapYard then
        StopSalvage()
        DeletePoint("yard")
        if Config.YardWrecks.Blip then
            RemoveBlip(YardBlip)
        end
        if DoesEntityExist(wreckage) then
            while GetEntityAlpha(wreckage) > 0 do
                SetEntityAlpha(wreckage, GetEntityAlpha(wreckage) - 1)
                Wait(2)
            end
            DeleteObject(wreckage)
        end
    end
end)

RegisterNetEvent('cr-salvage:client:CheckHarvest', function()
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    if wreckage then
        local target = GetEntityCoords(wreckage)
        local dist = #(pcoords - target)
        if dist <= 3.0 then
            SCUtils.SalvageDrawText(false)
            local data = {yard = true, wreck = wreckage}
            TriggerEvent('cr-salvage:client:harvest', data)
        end
    elseif worldwreck then
        local target = GetEntityCoords(worldwreck)
        local dist = #(pcoords - target)
        if dist <= 3.0 then
            SCUtils.SalvageDrawText(false)
            local data = {yard = false, wreck = worldwreck}
            TriggerEvent('cr-salvage:client:harvest', data)
        end
    end
end)

RegisterNetEvent('cr-salvage:client:harvest', function(data)
    if LocalPlayer.state['IsSalvaging'] then return end
    local ped = PlayerPedId()
    if data.yard then TaskTurnPedToFaceEntity(ped, data.wreck, 2000)
    else if not HasEntityClearLosToEntityInFront(ped, data.wreck) then SCUtils.SalvageNotif(3, Lcl("notif_notfacingwreck"), Lcl("salvagetitle")) return end end
    if not SCUtils.HasItem(Config.PowerSawItem) then SCUtils.SalvageNotif(3, Lcl('notif_missingsaw'),  Lcl('salvagetitle')) if Config.ShowMissingItem then SCUtils.MissingItem(Config.PowerSawItem) end return end
    if Config.Debug then print(Lcl("debug_startharvesting")) end
    local coords = GetEntityCoords(ped)
    local sawhash = 2115125482
    local dic = "anim@heists@fleeca_bank@drilling"
    RequestAmbientAudioBank('DLC_HEIST_FLEECA_SOUNDSET', true)
    RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', 1)
    RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', 0)
    LoadModel(sawhash)
    LoadAnimDict(dic)
    LocalPlayer.state['IsSalvaging'] = true
    Wait(2000)
    saw = CreateObject(sawhash, coords, true, false, false)
    SetEntityCollision(saw, true, true)
    AttachEntityToEntity(saw, ped, GetPedBoneIndex(ped, 64016), 0.1, -0.05, -0.02, -0.0, -35.0, 165.0, false, false, false, false, 2, true)--right bone:28422)
    TaskPlayAnim(ped, dic, 'drill_straight_start', 2.0, -8.0, -1, 17, 8.0, false, false, false)
    PlayerBusy()
    soundId = GetSoundId()
    PlaySoundFromEntity(soundId, 'Drill', saw, 'DLC_HEIST_FLEECA_SOUNDSET', true, 0)
    local FxCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0 , 0.05)
    Wait(500)
    TriggerServerEvent('cr-salvage:server:SawPfx', FxCoords)
    if data.yard then
        ScrapWreck()
    else
        ScrapWreck(true)
    end
end)

RegisterNetEvent('cr-salvage:client:SawPfx', function(id, coords)
    if not IsNearScrapYard then return end
    local pfxAsset = 'core'
    local pfxEffect = 'ent_anim_pneumatic_drill'
    LoadPfxAsset(pfxAsset)
    SetPtfxAssetNextCall(pfxAsset)
    Pfx[id] = StartParticleFxLoopedAtCoord(pfxEffect, coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false, 0)
end)

RegisterNetEvent('cr-salvage:client:RepairSaw', function()
    local ped = PlayerPedId()
    local animDict = 'mp_arresting'
    local anim = 'a_uncuff'
    LoadAnimDict(animDict)
    LocalPlayer.state:set('inv_busy', true, true)
    TaskPlayAnim(ped, animDict, anim, 4.0, 4.0, -1, 17, -1, 0, 0, 0)
    Wait(5000)
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    TriggerServerEvent('cr-salvage:server:RepairSaw')
end)


RegisterNetEvent('cr-salvage:client:StopSalvage', function()
    StopSalvage()
end)

RegisterNetEvent('cr-salvage:client:StopPfx', function(id)
    StopParticleFxLooped(Pfx[id], 0)
end)

RegisterNetEvent('cr-salvage:client:SpawnYardWreck', function()
    if not IsNearScrapYard then return end
    while not GlobalState.CRSalvage.YardLocation or not GlobalState.CRSalvage.YardHash do Wait(1) end
    local coords = GlobalState.CRSalvage.YardLocation
    if Config.Dev then coords = 1 end
    local spawnCoords = Config.YardLocations[coords]
    if Config.Debug then print(Lcl("debug_spawning")) end
    wreckage = CreateObject(GlobalState.CRSalvage.YardHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, true, false)
    SetEntityHeading(wreckage, spawnCoords.w)
    SetEntityCollision(wreckage, true)
    PlaceObjectOnGroundProperly(wreckage)
    local offset = GetOffsetFromEntityInWorldCoords(wreckage, 0, 0, -0.1)
    SetEntityCoords(wreckage, offset)
    FreezeEntityPosition(wreckage, true)
    if Config.Debug then print(Lcl("debug_successfulSpawn", GlobalState.CRSalvage.YardHash, wreckage, Config.YardLocations[coords], "Scrapyard")) end
    if Config.YardWrecks.Blip then
        local Xoffset, Yoffset = math.random(-20, 20), math.random(-20, 20)
        local areablip = vector3(spawnCoords.x + Xoffset, spawnCoords.y + Yoffset, spawnCoords.z)
        ScrapYardBlip(areablip)
    end
    SetupWreckTarget(wreckage)
end)

RegisterNetEvent('cr-salvage:client:EnteringScrapyard', function()
    IsNearScrapYard = true
    ScrapyardPed = CreatePedAtCoords(Config.ScrapyardPed.Model, Config.ScrapyardPed.Coords, true)
    if GlobalState.CRSalvage.YardLocation and GlobalState.CRSalvage.YardHash then TriggerEvent('cr-salvage:client:SpawnYardWreck') end
end)

RegisterNetEvent('cr-salvage:client:LeavingScrapyard', function()
    if DoesEntityExist(ScrapyardPed) then DeleteEntity(ScrapyardPed) end
    if Config.YardWrecks.Blip then RemoveBlip(YardBlip) end
    if DoesEntityExist(wreckage) then DeleteEntity(wreckage) wreckage = nil end
    DeletePoint("yard")
    IsNearScrapYard = false
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if DoesEntityExist(wreckage) then
            DeleteObject(wreckage)
        end
        if DoesEntityExist(worldwreck) then
            DeleteObject(worldwreck)
        end
    end
end)