local OutKeypadProp -- Dont need reset
local ManagerKey, Pfx, sec_seq_code, CurrentVaultCall, DoorTimerActive, TooLate, TryAgain, SoundID, ResetBank, hasVault1codes, hasVault2codes -- Needs Reset
local PhoneAnswered = false
LocalPlayer.state:set('inv_busy', false, true)
LocalPlayer.state:set('nui', false, true)
LocalPlayer.state:set('textui', false, true)
LocalPlayer.state:set('closestbank', nil, true)

-- Load Models
function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model) Wait(1)
    end
end

-- Load Animations
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-- Load PfX
function LoadPfxAsset(Asset)
    while not HasNamedPtfxAssetLoaded(Asset) do
        RequestNamedPtfxAsset(Asset)
        Wait(50)
    end
end

--~=============~--
--~ Vault Setups ~--
--~=============~--

-- Updating Props inside Gabs Vault
local function SetupGabzVault(Tray1, Tray2)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    if #(pcoords - vector3(-99.1, 6461.99, 31.63)) < 50 then
        local objects = GetGamePool("CObject")
        for _, entity in pairs(objects) do
            local model = GetEntityModel(entity)
            local coords = GetEntityCoords(entity)
            if model == -1474093273 or model == 289396019 or model == 1784997875 or model == 184519788 or model == -2018598162 then
                SetEntityCoords(entity, coords.z,coords.y,coords.z-100, 0 ,0 ,0)
            elseif model == 929864185 then
                if Tray1 == 0 then
                    SetEntityCoords(entity, coords.z,coords.y,coords.z-100, 0 ,0 ,0)
                else
                    local heading = GetEntityHeading(entity)
                    SetEntityCoords(entity, coords.z,coords.y,coords.z-100, 0 ,0 ,0)
                    local TrayObj = CreateObject(Tray1, coords.x, coords.y, coords.z, 1, 0, 0)
                    PlaceObjectOnGroundProperly(TrayObj)
                    SetEntityHeading(TrayObj, heading-180.0)
                    ActivateGabzTray(TrayObj, Tray1)
                end
            elseif  model == -1326042488 then
                if Tray2 == 0 then
                    SetEntityCoords(entity, coords.z,coords.y,coords.z-100, 0 ,0 ,0)
                else
                    local heading = GetEntityHeading(entity)
                    SetEntityCoords(entity, coords.z,coords.y,coords.z-100, 0 ,0 ,0)
                    local TrayObj = CreateObject(Tray2, coords.x, coords.y, coords.z , 1, 0, 0)
                    PlaceObjectOnGroundProperly(TrayObj)
                    SetEntityHeading(TrayObj, heading-180.0)
                    ActivateGabzTray(TrayObj, Tray2)
                end
            end
        end
    end
end

local function SetupK4MB1Vault()
    local Clear = {
        [1] = {hash = -2018598162, coords = vector3(-105.72, 6457.09, 30.62)},
        [2] = {hash = -2018598162, coords = vector3(-108.25, 6459.41, 30.62)},
        [3] = {hash = 1360148151, coords = vector3(-105.72, 6457.09, 30.62)}
    }
    local gate = GetClosestObjectOfType(vector3(-105.52, 6460.55, 31.98), 2.0, 1450792563, 0, 0, 0)
    SetEntityInvincible(gate, true)
    for _, v in pairs(Clear) do
        local obj = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 2.0, v.hash, 0, 0, 0)
        if obj and obj ~= 0 then SetEntityCoords(obj, v.coords.x, v.coords.y, v.coords.z-10) end
    end
end

local function SetupSecondVault()
    for k,v in pairs(Config.Targets.InnerVaultBoxes) do
        if v.BoxAmount == 0 then
            local Amount = math.random(Config.Rewards.Heist2.InnerVaultDepositBoxes.BoxAmount.min, Config.Rewards.Heist2.InnerVaultDepositBoxes.BoxAmount.max)
            v.BoxAmount = Amount
            TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "InnerDepoBoxSpawn", k, Amount)
        end
    end
    SetupInnerTargets()
end
-- core - ent_brk_sparking_wires | Non Looped *** 'ent_brk_sparking_wires', PlayerPedId(), 0.0, -0.1, -0.1, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0
-- cut_exile1 - ent_amb_sparking_wires_sm_sp | Non Looped

local locations = {
    vector3(22.19, 6433.59, 42.78),
    vector3(12.66, 6436.75, 40.34),
    vector3(-12.98, 6446.88, 37.48),
    vector3(-38.87, 6441.06, 40.36),
    vector3(-52.82, 6455.76, 40.37),
    vector3(-73.35, 6469.53, 44.79),
    vector3(-102.5, 6447.51, 44.64),
    vector3(-101.5, 6451.6, 37.59)
}

RegisterCommand('spark', function()
    RequestNamedPtfxAsset('des_car_show_room')
    while not HasNamedPtfxAssetLoaded('des_car_show_room') do
        Wait(1)
    end

    --local termcoords = GetEntityCoords(PlayerPedId())

    local effect = 'ent_ray_arm3_sparking_wires'
    for _, v in ipairs(locations) do
        SetPtfxAssetNextCall('des_car_show_room') --vector3(22.19, 6433.59, 42.78)
        StartParticleFxNonLoopedAtCoord(effect, v.x, v.y, v.z-1.1, 0.0, 0.0, 0.0, 5.0, 0.0, 0.0, 0.0)
        Wait(500)
    end
    --local effect = StartParticleFxNonLoopedAtCoord('ent_brk_sparking_wires', ptfx, 0, 0, 0, 0x3F800000, 0, 0, 0, 0)
    -- Wait(5000)
    -- StopParticleFxLooped(effect, 0)
end)

-- Generating Loot
local function SetupBank()
    PBCUtils.Debug(Lcl('debug_generatingloot'))
    local cVault = Config.Rewards["Heist1"].Vault
    if GlobalState.PaletoBankRobbery.CurrentVault == 2 then cVault = Config.Rewards["Heist2"].Vault end
    local AmountSpawned, MaxAmount, Vault = 0, math.random(cVault.Trays.TrayAmount.min, cVault.Trays.TrayAmount.max), Config.Targets
    if Config.DevMode or MaxAmount > #Vault.Trays then MaxAmount = #Vault.Trays end
    --Table Setup
    if Config.Framework.MLO == "Gabz" then
        local TrayHash = {[1] = 0, [2] = 0}
        local spawn = math.random(2)
        TrayHash[spawn] = 269934519
        if math.random(100) <= cVault.Trays.GoldChance then TrayHash[spawn] = 2007413986 end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'GabzVault', TrayHash[1], TrayHash[2])
    elseif Config.Framework.MLO == "K4MB1" then
        local chance = math.random(100)
        local itemHash = "h4_prop_h4_cash_stack_01a"
        if chance <= Config.Rewards.Heist1.Vault.Table.GoldChance then itemHash = "h4_prop_h4_gold_stack_01a" end
        local loot = CreateObject(GetHashKey(itemHash), Vault.Table.coords, 1, 1, 0)
        SetEntityHeading(loot, Vault.Table.heading)
        local TableNetID = NetworkGetNetworkIdFromEntity(loot)
        TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "Table", GetHashKey(itemHash), TableNetID, MaxAmount)
    end
    --Trays Setup (should be good)
    while AmountSpawned < MaxAmount do
        for k, v in pairs(Vault.Trays) do
            if AmountSpawned >= MaxAmount then return end
            if math.random(3) == 1 and not v.isSpawned and math.random(100) <= 50 then
                local loc = v.coords
                local TrayLoot = math.random(100)
                local TrayHash = 269934519
                v.isSpawned = true
                if TrayLoot <= cVault.Trays.GoldChance then TrayHash = 2007413986 end
                local TrayObj = CreateObject(TrayHash, loc.x, loc.y, loc.z , 1, 0, 0)
                local NetID = NetworkGetNetworkIdFromEntity(TrayObj)
                TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "Trays", k, TrayHash, NetID)
                SetEntityHeading(TrayObj, v.heading)
                AmountSpawned = AmountSpawned + 1
                -- if Config.Debug then local traytype
                --     if TrayHash == 2007413986 then traytype = "Gold" else traytype = "Cash" end print(Lcl('debug_generatingtray', AmountSpawned, traytype)) end
                if AmountSpawned == MaxAmount then break end
            end
        end
    end
    --Deposit Boxes Setup
    TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "Walls", MaxAmount)
    for k,v in pairs(Vault.DepositBoxes) do
        if v.BoxAmount == 0 then
            local Amount = math.random(cVault.DepositBoxes.BoxAmount.min, cVault.DepositBoxes.BoxAmount.max)
            v.BoxAmount = Amount
            TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "DepoBoxSpawn", k, Amount)
            --if Config.Debug then print(Lcl('debug_generatingwall', k, Amount)) end
        end
    end
end

-- Opening Vault Door
RegisterNetEvent("cr-paletobankrobbery:client:VaultCodesRight", function()
    if Config.Framework.MLO == "Gabz" then PBCUtils.UnlockDoor(Config.Doors.Vault) return end
    local VaultDoorObject = Config.Targets.VaultDoor
    local object = GetClosestObjectOfType(VaultDoorObject.coords.x, VaultDoorObject.coords.y, VaultDoorObject.coords.z, 20.0, VaultDoorObject.hash, false, false, false)
    local entHeading = GetEntityHeading(object)
    if object == 0 then return end
    CreateThread(function()
        while true do
            if entHeading < Config.Targets.VaultDoor.OpenHeading then
                SetEntityHeading(object, entHeading + 0.1)
                entHeading = entHeading + 0.1
            else break end
            Wait(10)
        end
    end)
end)

--~===================~--
--~ Security Sequence ~--
--~===================~--
-- Open Door & Search Through Binders to find the security sequence needed when opening the vault door.

-- Security Sequence Door Target Handler
RegisterNetEvent('cr-paletobankrobbery:client:TellerDoor', function()
    local Door = Config.Targets.SecSeq
    if LocalPlayer.state.inv_busy or Door.Busy then return end
    if GlobalState.PaletoBankRobbery.OnCooldown then PBCUtils.Notif(3, Lcl("notif_CooldownMessage"), Lcl('PaletoTitle')) return end
    PBCUtils.HasItem(Config.Items.Lockpick.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl("notif_PBCUtils.MissingItem"), Lcl('PaletoTitle')) PBCUtils.MissingItem(Config.Items.Lockpick.item) return end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SecSeq", true)
        Door.Busy = true
        LocalPlayer.state:set('inv_busy', true, true) DisableControls()
        local door = GetClosestObjectOfType(Door.coords.x, Door.coords.y, Door.coords.z, 1.0, Door.Hash, false, false, false)
        local offset
        if Door.Hash == -1184592117 then offset = GetOffsetFromEntityInWorldCoords(door, -1.0, -0.4, -1.0)
        elseif Door.Hash == -147325430 then offset = GetOffsetFromEntityInWorldCoords(door, 1.1, -0.4, -1.0) end
        local ped = PlayerPedId()
        SetEntityCoords(ped, offset)
        TaskTurnPedToFaceCoord(ped, Door.coords)
        Wait(1500)
        if not GlobalState.PaletoBankRobbery.CopsCalled and Config.HeistOptions.LockpickingSequenceDoorCallsCops then
            TriggerServerEvent('cr-paletobankrobbery:server:CopsAreCalled')
            PBCUtils.CallCops("Intrusion")
        end
        local onFinish = function()
            PBCUtils.Circle("SequenceDoor"):next(function(success)
                ClearPedTasks(ped)
                LocalPlayer.state:set('inv_busy', false, true)
                LocalPlayer.state:set('textui', false, true)
                if success then
                    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SetupBinders")
                    PBCUtils.UnlockDoor(Config.Doors['SequenceDoor'])
                    PBCUtils.Notif(1, Lcl("notif_EnterTellerOffice"), Lcl("PaletoTitle"))
                    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "SecSeq")
                    TriggerServerEvent('cr-paletobankrobbery:server:ActivatePaletoBanque', "SequenceDoor")
                else
                    PBCUtils.Notif(3, Lcl("notif_LockpickFailed"), Lcl('PaletoTitle'))
                    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SecSeq", false)
                end
            end)
        end
        local onCancel = function()
            ClearPedTasks(ped)
            LocalPlayer.state:set('textui', false, true)
            LocalPlayer.state:set('inv_busy', false, true)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "TellerDoor", false)
        end
        PBCUtils.ProgressUI(math.random(1500,3000), Lcl("progbar_lockpicking"), onFinish, onCancel, true, true, 'mp_common_heist', 'pick_door', 1)
    end)
end)

-- Security Sequence Pickup & Search
RegisterNetEvent('cr-paletobankrobbery:client:Binders', function(data)
    if Config.Targets.Binders[data.binder].Busy or LocalPlayer.state.inv_busy then return end
    LocalPlayer.state:set('inv_busy', true, true)
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SearchBinder", true, data.binder)
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "HideBinders", data.coords, data.hash, false)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local binder = CreateObject(data.hash, pcoords.x, pcoords.y, pcoords.z ,  true,  true, true)
    SetEntityCollision(binder, false, true)
    local pos, rot = {}, {}
    if data.hash == -1883980157 then pos.x = 0 pos.y = -0.05 pos.z = -0.1 rot[1] = 0 rot[2] = 90.0 rot[3] = 0
    elseif data.hash == 1573132612 then pos.x = 0 pos.y = -0.05 pos.z = -0.0 rot[1] = -0.0 rot[2] = 0.0 rot[3] = 90
    elseif data.hash == -1524553731 then pos.x = -0.10 pos.y = -0.05 pos.z = -0.0 rot[1] = -0.0 rot[2] = 0.0 rot[3] = -90 end
    AttachEntityToEntity(binder, ped, GetPedBoneIndex(ped, 4153), pos.x, pos.y, pos.z, rot[1], rot[2], rot[3], false, false, false, false, 2, true) -- right bone : 28422
    local animDict, anim, flag
    if data.coords.z < (pcoords.z - 0.2) then animDict, anim, flag = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 0
    else animDict, anim, flag = 'mp_arresting', 'a_uncuff', 17 end
    LoadAnimDict(animDict) TaskPlayAnim(ped, animDict, anim, 4.0, 4.0, -1, flag, 0.0, 0, 0, 0)
    local onFinish = function()
        DeleteEntity(binder)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SearchBinder", false, data.binder)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "HideBinders", data.coords, data.hash, true)
        TriggerEvent('cr-paletobankrobbery:client:DeleteZones', "Binders", data.binder)
        LocalPlayer.state:set('inv_busy', false, true)
        if data.binder == GlobalState.PaletoBankRobbery.Binder then
            PBCUtils.Notif(1, Lcl('notif_FoundSticky'), Lcl('PaletoTitle'))
            TriggerServerEvent('cr-paletobankrobbery:server:RecItem', "SecSeq")
        else
            PBCUtils.Notif(3, Lcl('notif_NothingImportant'), Lcl('PaletoTitle'))
        end
    end
    PBCUtils.ProgressUI(3000, Lcl('progbar_searching'), onFinish, nil, false, true)
end)

--~=================~--
--~ Hacking Stuff ~--
--~=================~--

function HackFailed(office)
    ClearPedTasks(PlayerPedId())
    LocalPlayer.state:set('inv_busy', false, true)
    LocalPlayer.state:set('textui', false, true)
    PBCUtils.Notif(3, Lcl("notif_SecurityBypassFailed"), Lcl('PaletoTitle'))
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'OfficeComputer', false, office)
end

-- (Heist 2) Custom Synced Hacking "Minigame"
local function OfficeHacking(office)
    local InitialPairTime = Config.Difficulties.DatabaseConnection.TimeToPair*1000
    local TimeOutTime = Config.Difficulties.DatabaseConnection.TimedOutTime*1000
    local paired = 1
    if office == 1 then paired = 2 end
    TriggerServerEvent('cr-paletobankrobbery:server:DatabaseConnect', office)
    local ConnectionEstablished = false
    local sent = false
    local code = GlobalState.PaletoBankRobbery.OfficeCode[office]
    local othercode = GlobalState.PaletoBankRobbery.OfficeCode[paired]


    local WFP_timer, CE_timer, DOT_timer, timeOut_time, response_timer
    local verified = false
    CreateThread(function()
        local WFP = "~b~"..Lcl('hack_WaitForPaired').."~w~."
        local match = "~b~"..Lcl('hack_Verifying').."~w~."
        local WFP_len = string.len(WFP)
        local match_len = string.len(match)
        local seq

        while not ConnectionEstablished do
            Wait(1) local CurrentTime = GetGameTimer()
            if not WFP_timer then WFP_timer = CurrentTime end
            if not DOT_timer then DOT_timer = CurrentTime end
            if CurrentTime > DOT_timer + 1000 then WFP = WFP.."." DOT_timer = nil end
            if string.len(WFP) > WFP_len + 5 then WFP = "~b~"..Lcl('hack_WaitForPaired').."~w~." end
            if CurrentTime >= WFP_timer + InitialPairTime then
                if not timeOut_time then timeOut_time = CurrentTime end
                WFP = "~r~"..Lcl('hack_ConnectionTimedOut')
                if CurrentTime >= timeOut_time + 5000 then return end
            end
            ShowText(Lcl('hack_Header', WFP), 4, {255, 255, 255}, 0.4, 0.55, 0.888 + 0.025)
            if GlobalState.PaletoBankRobbery.Database[1] == 1 and GlobalState.PaletoBankRobbery.Database[2] == 1 then ConnectionEstablished = true end
        end

        while ConnectionEstablished do
            Wait(1) local CurrentTime = GetGameTimer()
            local textShown = "~g~"..Lcl('hack_ConnectionEstablished')
            local formatText = Lcl('hack_Header', textShown)
            if not CE_timer then DOT_timer = nil CE_timer = CurrentTime end
            if CurrentTime >= CE_timer + TimeOutTime then
                if not timeOut_time then timeOut_time = CurrentTime end
                formatText = Lcl('hack_Header', "~r~"..Lcl('hack_ConnectionTimedOut'))
                if CurrentTime >= timeOut_time + 5000 then HackFailed(office) return end
            elseif CurrentTime > CE_timer + 3000 then
                textShown = "~g~"..code
                formatText = Lcl('hack_Header', textShown)
                if not seq then
                    match = "~y~["..Config.InteractKey.."]~w~ "..Lcl('hack_InputSequence')
                    if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        match = "~b~"..Lcl('hack_Verifying').."~w~."
                        seq = GetKeyBoard(formatText)
                    end
                    formatText = formatText..'\n'..match
                else
                    if not DOT_timer then DOT_timer = CurrentTime end
                    if CurrentTime > DOT_timer + 1000 then match = match.."." DOT_timer = nil end
                    if string.len(match) > match_len + 3 or verified then
                        verified = true
                        if seq == othercode then
                            PBCUtils.Debug('Correct Code!')
                            if not sent then
                                TriggerServerEvent('cr-paletobankrobbery:server:AccessGranted', office) sent = true

                            end
                            if GlobalState.PaletoBankRobbery.CorrectConnection == 2 then
                                match = "~g~"..Lcl('hack_AccessGranted')
                                if not response_timer then response_timer = CurrentTime end
                                if CurrentTime >= response_timer + 5000 then return end
                            else
                                if not DOT_timer then DOT_timer = CurrentTime end
                                if CurrentTime > DOT_timer + 1000 then match = match.."." DOT_timer = nil end
                                if string.len(match) > match_len + 3 then match = "~b~"..Lcl('hack_Verifying').."~w~." end
                            end
                        else
                            match = "~r~"..Lcl('hack_AccessDenied')
                            if not response_timer then response_timer = CurrentTime HackFailed(office) end
                            if CurrentTime >= response_timer + 5000 then return end
                        end
                    end
                    formatText = formatText..'\n'..match
                end
            end
            ShowText(formatText, 4, {255, 255, 255}, 0.4, 0.55, 0.888 + 0.025)
        end
    end)
end

-- (Shared) Hacking Handling
local function HackingHandler(office)
    local ped = PlayerPedId()
    local onFinish = function()
        PBCUtils.Notif(1, Lcl("notif_CodesFound"), Lcl('PaletoTitle'))
        Wait(1000) CRDisableControls(true)
        local Hack = 'Heist1Hack'
        if office then Hack = 'Heist2Hack' end
        PBCUtils.HackingMinigame(Hack):next(function(success)
            ClearPedTasks(ped)
            LocalPlayer.state:set('textui', false, true)
            LocalPlayer.state:set('inv_busy', false, true)
            if success and office then
                PBCUtils.Notif(1, Lcl("notif_SecurityBypass"), Lcl('PaletoTitle'))
                if Config.Difficulties.Heist2Hack.SuccesfulHackRemoveUSB then
                    TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.OfficeComputerHacking.item, 1)
                else TriggerServerEvent('cr-paletobankrobbery:server:USBRemoval', Hack) end
                OfficeHacking(office)
            elseif success then
                PBCUtils.Notif(1, Lcl("notif_SecurityBypass"), Lcl('PaletoTitle'))
                if Config.Difficulties.Heist1Hack.SuccesfulHackRemoveUSB then TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.VaultComputerHacking.item, 1) end
                TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "VaultComputer")
                TriggerServerEvent('cr-paletobankrobbery:server:ActivatePaletoBanque', "HackedVaultComputer")
                Wait(1000) TriggerServerEvent('cr-paletobankrobbery:server:RecItem', "VaultCode1")
                hasVault1codes = true
            else
                TriggerServerEvent('cr-paletobankrobbery:server:USBRemoval', Hack)
                PBCUtils.Notif(3, Lcl("notif_SecurityBypassFailed"), Lcl('PaletoTitle'))
                local sync = "VaultComputer" if office then sync = "OfficeComputer"end
                TriggerServerEvent('cr-paletobankrobbery:server:Sync', sync, false, office)
            end
        end)
    end
    local onCancel = function() LocalPlayer.state:set('textui', false, true) ClearPedTasks(ped) end
    PBCUtils.ProgressUI(math.random(5000, 7500), Lcl('progbar_lookingforcodes'), onFinish, onCancel, true, true, "mp_prison_break", 'hack_loop', 17)
end

-- (Heist 1) Hacking Vault Computer
RegisterNetEvent('cr-paletobankrobbery:client:VaultComputer', function()
    local Computer = Config.Targets.VaultComputer
    if LocalPlayer.state.inv_busy or Computer.Busy then return end
    if GlobalState.PaletoBankRobbery.OnCooldown then PBCUtils.Notif(3, Lcl("notif_CooldownMessage"), Lcl('PaletoTitle')) return end
    --PBCUtils.HasItem(Config.Items.VaultComputerHacking.item):next(function(hasItem)
    --    if not hasItem then PBCUtils.Notif(3, Lcl("notif_MissingItem"), Lcl('PaletoTitle')) LocalPlayer.state['textui'] = false return end
        PBCUtils.GetCurrentCops():next(function(CopAmount)
            if CopAmount < Config.Police.CopsNeeded.Heist1 then PBCUtils.Notif(3, Lcl("notif_NotEnoughCops"), Lcl('PaletoTitle')) return end
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultComputer", true)
            LocalPlayer.state:set('inv_busy', true, true) DisableControls()
            local keyboard = GetClosestObjectOfType(Computer.coords, 0.2, -69396461, 0 , 0, 0)
            local offsetCoords = GetOffsetFromEntityInWorldCoords(keyboard, 0.0, -0.7, -0.8)
            local ped = PlayerPedId()
            SetEntityCoords(ped, offsetCoords) SetEntityHeading(ped, Computer.heading)
            local onFinish = function()
                --TriggerServerEvent("cr-paletobankrobbery:server:USBRemoval", 'Heist1Hack')
                exports['mdn-extras']:RemoveHackUse('paleto')
                PBCUtils.CallCops("Robbery")
                HackingHandler()
                PBCUtils.Notif(1, Lcl("notif_USBInserted"), Lcl('PaletoTitle'))
            end
            local onCancel = function()
                TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultComputer", false)
                LocalPlayer.state:set('textui', false, true) ClearPedTasks(ped)
            end
            PBCUtils.ProgressUI(4000, Lcl('progbar_insertingusb'), onFinish, onCancel, true, true, "anim@gangops@morgue@office@laptop@", "enter", 17)
        end)
    --end)
end)

-- (Heist 2) Hacking Office Computers
RegisterNetEvent('cr-paletobankrobbery:client:OfficeComputer', function(data)
    local ped = PlayerPedId()
    if LocalPlayer.state.inv_busy or Config.Targets.OfficeComputers[data.computer].Busy or not GlobalState.PaletoBankRobbery.Step.KeyAcquired then return end
    if (GlobalState.PaletoBankRobbery.OnCooldown or not GlobalState.PaletoBankRobbery.HeistInProgress) and not Config.DevMode then PBCUtils.Notif(3, Lcl("notif_CooldownMessage"), Lcl('PaletoTitle')) return end
    PBCUtils.HasItem(Config.Items.OfficeComputerHacking.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl("notif_MissingItem"), Lcl('PaletoTitle')) LocalPlayer.state['textui'] = false return end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "OfficeComputer", true, data.computer)
        LocalPlayer.state:set('inv_busy', true, true)
        DisableControls()
        local keyboard = GetClosestObjectOfType(Config.Targets.OfficeComputers[data.computer].coords, 0.2, -69396461, 0 , 0, 0)
        if keyboard and keyboard ~= 0 then
            local offsetCoords = GetOffsetFromEntityInWorldCoords(keyboard, 0.0, -0.7, -0.8)
            SetEntityCoords(ped, offsetCoords)
            SetEntityHeading(ped, Config.Targets.OfficeComputers[data.computer].heading)
        else
            TaskTurnPedToFaceCoord(ped, Config.Targets.OfficeComputers[data.computer].coords, 2000)
            Wait(2000)
        end
        LoadAnimDict("anim@gangops@morgue@office@laptop@")
        TaskPlayAnim(ped, "anim@gangops@morgue@office@laptop@", 'enter', 4.0, 2.0, -1, 16, 0.0, 0, 0, 0)
        local onFinish = function() Wait(2250) HackingHandler(data.computer) end
        local onCancel = function() ClearPedTasks(ped) end
        PBCUtils.ProgressUI(4000, Lcl('progbar_insertingusb'), onFinish, onCancel, true, true)
        Wait(2350) PBCUtils.Notif(1, Lcl("notif_USBInserted"), Lcl('PaletoTitle'))
    end)
end)

--~============~--
--~ Vault Door ~--
--~============~--

function DoorTimer()
    PBCUtils.Debug('Door Timer Stuff')
    CreateThread(function()
        if GlobalState.PaletoBankRobbery.OnCooldown then PBCUtils.Notif(3, Lcl('notif_CooldownMessage'), Lcl('PaletoTitle')) return end
        if not GlobalState.PaletoBankRobbery.HeistCompleted then
            PBCUtils.Debug('Completing Heist')
            TriggerServerEvent('cr-paletobankrobbery:server:StepDone', 'CompleteHeist')
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'DoorTimer', true)
            local timer = Config.HeistOptions['Heist'..CurrentVaultCall].DoorTimer
            if Config.DevMode then timer = 10 end
            PBCUtils.Debug('Starting Timer')
            Wait((timer * 1000)/2)
            PBCUtils.Notif(2, Lcl('notif_VaultHalfTime', tonumber((timer/2))), Lcl('PaletoTitle'))
            Wait((timer * 1000)/2)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'DoorTimer', false)
        end
        PBCUtils.Debug('Opening Door')
        PBCUtils.Notif(1, Lcl("notif_VaultDoorOpenned"), Lcl('PaletoTitle'))
        if CurrentVaultCall == 1 or Config.Framework.MLO == "Gabz" then
            PBCUtils.Debug('Vault 1')
            SetupBank()
            TriggerServerEvent('cr-paletobankrobbery:server:VaultCodesRight')
        else
            PBCUtils.Debug('Vault 2')
            PBCUtils.UnlockDoor(Config.Doors.InnerVault)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SetupInner")
        end
    end)
end

-- (Shared) Vault Keypad
RegisterNetEvent('cr-paletobankrobbery:client:VaultKeypad', function(data)
    if DoorTimerActive then PBCUtils.Notif(3, Lcl('notif_timerActive'), Lcl('PaletoTitle')) return end
    --if (not GlobalState.PaletoBankRobbery.HeistStarted['Heist1'] or not GlobalState.PaletoBankRobbery.HeistStarted["Heist2"]) and not Config.DevMode then PBCUtils.Notif(3, Lcl("notif_CooldownMessage"), Lcl('PaletoTitle')) return end
    if Config.Framework.MLO == "K4MB1" then
        if data.inner then
            if Config.Targets.InnerVaultKeypad.Occupied then return end
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "InnerKeypad", true)
        else
            if Config.Targets.VaultKeypad.Occupied then return end
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultKeypad", true)
        end
    elseif Config.Framework.MLO == "Gabz" then
        if Config.Targets.VaultKeypad.Busy then return end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultKeypad", true)
    end
    if Config.Framework.Framework == "ESX" and not Config.Framework.UseOxInv then
        if hasVault1codes then
            hasVault1codes = false
            PBCUtils.Notif(1, Lcl('notif_VaultCodeSuccess'), Lcl('PaletoTitle'))
            TriggerServerEvent('cr-paletobankrobbery:server:Vaults', 1)
            TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "VaultKeypad")
            if not GlobalState.PaletoBankRobbery.Step.PhoneCall then
                local phone = 1
                if Config.Framework.MLO == "Gabz" then phone = math.random(#Config.Targets.Phones) end
                TriggerServerEvent('cr-paletobankrobbery:server:CallBank', phone, 1)
            else CurrentVaultCall = 1 DoorTimer() end
        elseif hasVault2codes then
            hasVault2codes = false
            PBCUtils.Notif(1, Lcl('notif_VaultCodeSuccess'), Lcl('PaletoTitle'))
            TriggerServerEvent('cr-paletobankrobbery:server:Vaults', 2)
            if Config.Framework.MLO == "Gabz" then TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "VaultKeypad")
            else TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "InnerKeypad") end
            if Config.HeistOptions.Heist2.PhoneCall and not GlobalState.PaletoBankRobbery.Step.PhoneCall then
                local phone = 1
                if Config.Framework.MLO == "Gabz" then phone = math.random(#Config.Targets.Phones) end
                TriggerServerEvent('cr-paletobankrobbery:server:CallBank', phone, 2)
            else CurrentVaultCall = 2 DoorTimer() end
        else
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultKeypad", false)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "InnerKeypad", false)
            PBCUtils.Notif(3, Lcl('notif_CombinationUnkown'), Lcl('PaletoTitle'))
        end
    else
        LocalPlayer.state:set('inv_busy', true, true)
        LocalPlayer.state:set('nui', true, true)
        SendNUIMessage({action = "openKeypad"})
        SetNuiFocus(true, true)
        DisableControls()
    end
end)

-- (Shared) Combination Check
RegisterNUICallback('TryCombination', function(data)
    local code = tonumber(data.combination)
    if not code then return end
    if code == GlobalState.PaletoBankRobbery.Vault then
        PBCUtils.Notif(1, Lcl('notif_VaultCodeSuccess'), Lcl('PaletoTitle'))
        TriggerServerEvent('cr-paletobankrobbery:server:Vaults', 1)
        --Delete Zone + Reset LocalStates
        TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "VaultKeypad")
        SendNUIMessage({ action = "closeKeypad", error = false, }) SetNuiFocus(false, false)
        LocalPlayer.state:set('nui', false, true) LocalPlayer.state:set('inv_busy', false, true)

        if not GlobalState.PaletoBankRobbery.Step.PhoneCall then
            local phone = 1
            if Config.Framework.MLO == "Gabz" then phone = math.random(#Config.Targets.Phones) end
            TriggerServerEvent('cr-paletobankrobbery:server:CallBank', phone, 1)
        else CurrentVaultCall = 1 DoorTimer() end
    elseif code == GlobalState.PaletoBankRobbery.SecondVault then
        PBCUtils.Notif(1, Lcl('notif_VaultCodeSuccess'), Lcl('PaletoTitle'))
        TriggerServerEvent('cr-paletobankrobbery:server:Vaults', 2)
        --Delete Zone + Reset LocalStates
        if Config.Framework.MLO == "Gabz" then TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "VaultKeypad")
        else TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "InnerKeypad") end
        SendNUIMessage({ action = "closeKeypad", error = false }) SetNuiFocus(false, false)
        LocalPlayer.state:set('nui', false, true) LocalPlayer.state:set('inv_busy', false, true)
        if Config.HeistOptions.Heist2.PhoneCall and not GlobalState.PaletoBankRobbery.Step.PhoneCall then
            local phone = 1
            if Config.Framework.MLO == "Gabz" then phone = math.random(#Config.Targets.Phones) end
            TriggerServerEvent('cr-paletobankrobbery:server:CallBank', phone, 2)
        else CurrentVaultCall = 2 DoorTimer() end
    else
        SendNUIMessage({ action = "closeKeypad", error = true }) SetNuiFocus(false, false)
        LocalPlayer.state:set('nui', false, true)  LocalPlayer.state:set('textui', false, true) LocalPlayer.state:set('inv_busy', false, true)
    end
end)

-- Vault Keypad Combination Fail
RegisterNUICallback("CombinationFail", function()
    SetNuiFocus(false, false)
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultKeypad", false)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

-- Vault Keypad No Answer (Keypad Closed)
RegisterNUICallback('PadLockClose', function()
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "VaultKeypad", false)
    SetNuiFocus(false, false)
end)

--~============~--
--~ Phone Call ~--
--~============~--

-- Synced Phone Call Sound & Target
RegisterNetEvent('cr-paletobankrobbery:client:CallBank', function(phone, vault)
    CurrentVaultCall = vault
    local obj = GetClosestObjectOfType(Config.Targets.Phones[phone].coords, 1.0, 1146022803, false, false, false)
    if not obj or obj == 0 then return end
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local coords = GetEntityCoords(obj)
    local pdist = #(coords - pcoords)
    Wait(5000)
    PBCUtils.PhoneSound(false, coords)
    Wait(1500)
    if pdist <= 20.0 then PBCUtils.Notif(2, Lcl('notif_PhoneRinging'), Lcl('PaletoTitle')) end
    SetupPhoneTarget(phone, obj)
    CreateThread(function()
        Wait(Config.Difficulties.PhoneCall.TimeToAnswerThePhone * 1000)
        TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Phone")
    end)
end)

local function CheckTooLate()
    CreateThread(function()
        local time = GetGameTimer()
        while true do
            if TryAgain then time = GetGameTimer() TryAgain = false end
            if GetGameTimer() >= time+Config.HeistOptions.Heist1.CallTime * 1000 then TooLate = true return end
            Wait(100)
        end
    end)
end

-- Giving Security Code
RegisterNetEvent('cr-paletobankrobbery:client:GiveCode', function(tryAgain)
    CreateThread(function()
        CheckTooLate()
        sec_seq_code = GetKeyBoard()
        local timer = Config.HeistOptions['Heist'..CurrentVaultCall].DoorTimer
        if TooLate then PBCUtils.Notif(1, Lcl('notif_GroupeSixCorrectCode', timer), Lcl('PaletoTitle'))
            return end
        PhoneAnswered = true
        if sec_seq_code == GlobalState.PaletoBankRobbery.VCode.Full then
            TriggerServerEvent('cr-paletobankrobbery:server:StepDone', 'PhoneCall')
            if Config.DevMode then timer = 0.2 end
            PBCUtils.Notif(1, Lcl('notif_GroupeSixCorrectCode', timer), Lcl('PaletoTitle'))
            DoorTimer()
        else
            if not tryAgain then
                TryAgain = true
                sec_seq_code = nil
                PBCUtils.Notif(3, Lcl('notif_GroupeSixWrongCode'), Lcl('PaletoTitle'))
                Wait(1000)
                TriggerEvent('cr-paletobankrobbery:client:GiveCode', true)
            else
                PBCUtils.Notif(3, Lcl('notif_GroupeSixCallingCops2'), Lcl('PaletoTitle'))
            end
        end
    end)
end)

-- Phone Call UI
local function PhoneCall()
    CreateThread(function()
        while true do
            local prompt = Lcl('phone_Prompt')
            local options = "~g~[ENTER]~w~ "..Lcl('phone_GiveCode').."\n~r~[BACK_SPACE]~w~ "..Lcl('phone_HangUp')
            if IsControlJustPressed(0, Config.KeyList["ENTER"]) then TriggerEvent('cr-paletobankrobbery:client:GiveCode') end
            if IsControlJustPressed(0, Config.KeyList["BACKSPACE"]) then break end
            local ppos, opos = Config.Difficulties.PhoneCall.UIPosition.Text, Config.Difficulties.PhoneCall.UIPosition.Commands
            ShowText(prompt, 4, {255, 255, 255}, ppos.scale, ppos.x, ppos.y)
            ShowText(options, 4, {255, 255, 255}, opos.scale, opos.x, opos.y)
            if PhoneAnswered or TooLate then break end
            Wait(1)
        end
    end)
end

-- Answering Phone Handle
RegisterNetEvent('cr-paletobankrobbery:client:AnswerPhone', function()
    TriggerServerEvent('cr-paletobankrobbery:server:AnswerPhone')
    local pcoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Phone", pcoords)
    Wait(1000)
    PBCUtils.Notif(2, Lcl('notif_GroupeSixCall'), Lcl('PaletoTitle'))
    Wait(2000)
    CreateThread(function()
        local time = Config.HeistOptions.Heist1.CallTime * 1000
        Wait(time/2)
        if PhoneAnswered or TryAgain then return end
        PBCUtils.Notif(2, Lcl('notif_GroupeSixWaiting'), Lcl('PaletoTitle'))
        Wait(time/2)
        if PhoneAnswered or TryAgain then return end
        PBCUtils.Notif(3, Lcl('notif_GroupeSixCallingCops'), Lcl('PaletoTitle'))
        TooLate = true
    end)
    PhoneCall()
end)

--~==========~--
--~ Thermite ~--
--~==========~--

local function ThermiteAnim(type, loc)
    local Loc
    if type == "door" then Loc = Config.Targets.ThermiteDoors[loc]
    elseif type == "BombGate" then Loc = Config.Targets.Gate end
    local Dict = 'anim@heists@ornate_bank@thermal_charge'
    local bagModel = GetHashKey('hei_p_m_bag_var22_arm_s')
    local thermiteModel = 'hei_prop_heist_thermite'
    local pfx = 'scr_ornate_heist'
    LoadAnimDict(Dict)
    LoadModel(bagModel)
    LoadPfxAsset(pfx)

    local ped = PlayerPedId()
    SetEntityHeading(ped, Loc.heading + 90)
    Wait(100)

    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    SetEntityCoords(ped, Loc.coords.x + 0.15, Loc.coords.y + 0.1, Loc.coords.z - 1)
    if (type == "door" and loc == 2) then Loc.coords = GetOffsetFromEntityInWorldCoords(ped, 0, -0.39, 0)
    elseif type == "BombGate" then Loc.coords = GetOffsetFromEntityInWorldCoords(ped, 0.2, 0.35, -0.2) end
    --elseif type == "outside" and loc == 3 then Loc.coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.34, 0) end
    local scene1 = NetworkCreateSynchronisedScene(Loc.coords.x + 0.15, Loc.coords.y + 0.1, Loc.coords.z, rotx, roty, rotz, 2, false, false, 1065353216, 0, 1.3)
    local bagObj = CreateObject(bagModel, Loc.coords.x, Loc.coords.y, Loc.coords.z,  true,  true, false)

    SetEntityCollision(bagObj, false, true)
    NetworkAddPedToSynchronisedScene(ped, scene1, Dict, 'thermal_charge', 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagObj, scene1, Dict, 'bag_thermal_charge', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene1)
    Wait(1500)

    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bombObj = CreateObject(thermiteModel, x, y, z + 0.3,  true,  true, true)

    SetEntityCollision(bombObj, false, true)
    AttachEntityToEntity(bombObj, ped, GetPedBoneIndex(ped, 28422), 0, 0.05, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Wait(2000)
    DeleteObject(bagObj)
    DetachEntity(bombObj, 1, 1)
    FreezeEntityPosition(bombObj, true)
    NetworkStopSynchronisedScene(scene1)
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    if type == "door" then
        TriggerServerEvent('cr-paletobankrobbery:server:ThermitePfxSync')
        Wait(10000)
        DeleteObject(bombObj)
    elseif type == "BombGate" then
        Wait(Config.Difficulties.MetalGate.TimeToExpload * 1000)
        DeleteObject(bombObj)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'GodMetalGate')
        Wait(500)
        AddExplosion(vector3(-105.89, 6460.92, 31.95), 0, 1.0, 1, 0 , 1)
        Wait(100)
        local door = GetClosestObjectOfType(vector3(-105.52, 6460.55, 31.98), 2.0, -275220570, 0, 0, 0)
        local coords = GetOffsetFromEntityInWorldCoords(door, 0, -0.1, 0)
        SetEntityCoords(door, coords, 0, 0, 0)
    end
    --if type == "door" then
    --    local DoorHash
    --    if loc == 1 then DoorHash = Config.Doors.Prevault else DoorHash = Config.Doors.Vault end
    --    PBCUtils.UnlockDoor(DoorHash)
    --end
end

RegisterNetEvent('cr-paletobankrobbery:client:ThermitePfxSync')
AddEventHandler('cr-paletobankrobbery:client:ThermitePfxSync', function()
    local pfxAsset = 'scr_ornate_heist'
    LoadPfxAsset(pfxAsset)
    SetPtfxAssetNextCall(pfxAsset)
    local ped = PlayerPedId()
    local obj = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey('hei_prop_heist_thermite'))
    local coords = GetEntityCoords(obj)
    Pfx = StartParticleFxLoopedAtCoord('scr_heist_ornate_thermal_burn', coords.x, coords.y +1.0, coords.z+0.05, 0.0, 0.0, 0.0, 1.0, false, false, false, false, 0)
    Wait(10000)
    StopParticleFxLooped(Pfx, 0)
    Pfx = nil
end)

RegisterNetEvent('cr-paletobankrobbery:client:ThermiteDoors')
AddEventHandler('cr-paletobankrobbery:client:ThermiteDoors', function(door)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    for k, v in pairs(Config.Targets.ThermiteDoors) do if #(pcoords - v.coords) <= 1.0 then door = k break end end
    if not door then return end
    PBCUtils.HasItem(Config.ThermiteItem):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingItem'), Lcl("PaletoTitle")) return end
        if Config.Targets.ThermiteDoors.isBurnt then return end
        if LocalPlayer.state.inv_busy then return end
        Wait(500)
        LocalPlayer.state:set('inv_busy', true, true)
        DisableControls()
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "Thermite", true, door)
        exports['memorygame']:thermiteminigame(Config.Thermite.CorrectBlocks, Config.Thermite.IncorrectBlocks, Config.Thermite.TimeToShow, Config.Thermite.TimeToLose,
        function() -- success
            TriggerServerEvent("cr-paletobankrobbery:server:DeleteZones", "Thermite", door)
            TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.ThermiteItem, 1)
            ThermiteAnim(door)
        end, function()
            if Config.Thermite.RemoveThermiteOnFail then TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.ThermiteItem, 1) end
            LocalPlayer.state:set('inv_busy', false, true)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "Thermite", false, door)
            PBCUtils.Notif(3, Lcl("ThermiteFailed"), Lcl("PaletoTitle"))
        end)
    end)
end)

--~=================~--
--~ Part 2 Specific ~--
--~=================~--

RegisterNetEvent('cr-paletobankrobbery:client:UnlockCorridor', function()
    if not GlobalState.PaletoBankRobbery.Step.OutsideKeypad then return PBCUtils.Notif(3, Lcl('notif_CantDoThat'), Lcl('PaletoTitle')) end
    PBCUtils.UnlockDoor(Config.Doors.CorridorDoor)
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', 'CorridorDoor')
end)

RegisterNetEvent('cr-paletobankrobbery:client:OutsideKeypad', function()
    if GlobalState.PaletoBankRobbery.OnCooldown then PBCUtils.Notif(3, Lcl("notif_CooldownMessage"), Lcl('PaletoTitle')) return end
    --PBCUtils.HasItem(Config.Items.Keycard.item):next(function(hasItem)
    --    if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingItem'), Lcl("PaletoTitle")) return end
        PBCUtils.GetCurrentCops():next(function(CopAmount)
            if CopAmount < Config.Police.CopsNeeded.Heist2 then PBCUtils.Notif(3, Lcl("notif_NotEnoughCops"), Lcl('PaletoTitle')) return end
            if Config.Scoreboard then PBCUtils.UpdateScoreboard(true) end
            PBCUtils.UnlockDoor(Config.Doors.OutsideKeypad)
            TriggerServerEvent('cr-paletobankrobbery:server:StepDone', 'OutsideKeypad')
            TriggerServerEvent('cr-paletobankrobbery:server:ActivatePaletoBanque', "OutsideKeypad")
            exports['mdn-extras']:RemoveProtocol()
            TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Keycard.item, 1)
            TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', 'OutsideKeypad')
            if Config.Framework.MLO == "K4MB1" then
                local Spawn = {
                    [1] = {hash = 2520641774, coords = vector4(-106.15, 6457.28, 30.63, 192.12)},
                    [2] = {hash = 2947971326, coords = vector4(-106.15, 6457.28, 30.73, 192.12)},
                    [3] = {hash = 289396019, coords = vector4(-105.46, 6456.96, 31.49, 192.12)},
                    [4] = {hash = 289396019, coords = vector4(-105.94, 6456.87, 31.49, 100.12)},
                    [5] = {hash = 289396019, coords = vector4(-105.77, 6456.95, 30.74, 60.12)},
                }
                TriggerServerEvent('cr-paletobankrobbery:server:Sync', "K4MB1Vault")
                for _, v in pairs(Spawn) do
                    LoadModel(v.hash)
                    local obj = CreateObject(v.hash, v.coords.x, v.coords.y, v.coords.z, 1, 0, 0)
                    SetEntityHeading(obj, v.coords.w)  FreezeEntityPosition(obj, true)
                end
            end
        end)
    --end)
end)

RegisterNetEvent('cr-paletobankrobbery:client:ManagerDoor', function()
    PBCUtils.HasItem(Config.Items.ManagerKey.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingKey'), Lcl("PaletoTitle")) return end
        PBCUtils.UnlockDoor(Config.Doors.ManagerOffice)
        TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.ManagerKey.item, 1)
        TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', 'ManagerDoor')
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:client:OfficeDoor', function(data)
    if not GlobalState.PaletoBankRobbery.Step.KeyAcquired then PBCUtils.Notif(3, Lcl('notif_MissingKey'), Lcl('PaletoTitle')) return end
    PBCUtils.UnlockDoor(Config.Doors.GabzOffices[data.door])
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', 'OfficeDoor', data.door)
end)

RegisterNetEvent('cr-paletobankrobbery:client:ActivatePrinter', function()
    ActivatePrinter()
end)

RegisterNetEvent('cr-paletobankrobbery:client:PrintVaultCodes', function()
    if GlobalState.PaletoBankRobbery.AccessGranted then
        hasVault2codes = true
        TriggerServerEvent('cr-paletobankrobbery:server:RecItem', "VaultCode2")
        TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Printer")
    else
        PBCUtils.Notif(3, Lcl('debug_SomethingWrong'), Lcl('PaletoTitle'))
    end
end)

--~==================================~--
--~ Outside Deposit Box (Office Key) ~--
--~==================================~--

local function LootDepo(coords, saw, bag)
    local ped, dic = PlayerPedId(), "anim@heists@fleeca_bank@drilling"
    LoadAnimDict(dic)

    local scene3 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, dic, 'outro', 4.0, 4.0, 5000, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, dic, 'bag_outro', 1.0, 1.0, 1148846080)

    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
    Wait(1000) NetworkStartSynchronisedScene(scene3)
    Wait(1200) DeleteObject(saw)
    Wait(2600) NetworkStopSynchronisedScene(scene3)
    DeleteObject(bag)
    TriggerServerEvent('cr-paletobankrobbery:server:RecItem', "OfficeKey")
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "OutsideDepo")
    LocalPlayer.state:set('inv_busy', false, true)
end

local function BreakSaw(coords, saw, bag, reason)
    local ped = PlayerPedId()
    local dic = "anim@heists@fleeca_bank@drilling" LoadAnimDict(dic)

    local scene3 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, dic, 'drill_straight_fail', 4.0, 8.0, 5000, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, dic, 'bag_drill_straight_fail', 1.0, 1.0, 1148846080)

    local scene4 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene4, dic, 'exit', 4.0, 8.0, 5000, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene4, dic, 'bag_outro', 1.0, 1.0, 1148846080)

    if not reason then NetworkStartSynchronisedScene(scene3) Wait(3500) end
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
    NetworkStartSynchronisedScene(scene4)
    Wait(1200) ClearPedTasks(ped)
    DeleteObject(saw) DeleteObject(bag)
    if not reason then
        PBCUtils.Notif(3, Lcl('notif_SawBladeBroke'), Lcl('PaletoTitle'))
        TriggerServerEvent("cr-paletobankrobbery:server:RemItem", Config.Items.PowerSaw.item, 1)
        TriggerServerEvent("cr-paletobankrobbery:server:RecItem", Config.Items.BrokenSaw.item)
    end
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "OutDepo", false)
    LocalPlayer.state:set('inv_busy', false, true)
end

function BreakDepoBox(coords, saw, bag)
    CreateThread(function()
        local breaking, progress, heating, cooling, heat = 0, 0, 0, 0, 0
        local StopReason
        while true do
            local pba, pbb, progressbar, hba, hbb, heatbar = "", "", "|", "", "", ""
            Wait(1)
            if IsControlPressed(0, 47) then StopReason = "stop" BreakSaw(coords, saw, bag, StopReason) break end
            if IsControlPressed(0, 22) then
                cooling = 0
                breaking = breaking + (math.random(2) * Config.Difficulties.CorridorDepositBox.ProgressSpeedMultiplier)
                heating = heating + (math.random(heat+math.random(3)) * Config.Difficulties.CorridorDepositBox.BladeHeatMultiplier)
                if math.random(100) < 2 then heating = heating + 75 end
                if heating >= 150 then heat = heat + 1 heating = 0 end
                if breaking >= 400 then progress = progress + 1 breaking = 0 end
            else
                if heating > 0 then heating = heating - 1 end
                if cooling >= 0 then cooling = cooling + 1 end
                if cooling == 50 then if heat > 0 then heat = heat - 1 end cooling = 0 end
            end
            for _ = 0, progress - 1, 1 do pba = pba.."-" end
            local diff = 10 - progress
            for _ = 0, diff - 1, 1 do pbb = pbb.."-" end
            progressbar = progressbar..'~g~'..pba..'~r~'..pbb.."~w~|"
            for _ = 0, heat - 1, 1 do hba = hba.."|" end
            local heatdiff = 9 - heat
            for _ = 0, heatdiff, 1 do hbb = hbb.."|" end
            heatbar = heatbar..'~r~'..hba..'~w~'..hbb--.."|"
            local commands = "~b~[Space]~w~ "..Lcl('SawUI_Saw').." ~b~[G]~w~ "..Lcl('DrillingUI_Stop')
            local text = Lcl('DrillingUI_Progress').." : "..progressbar.."\n"..Lcl('SawUI_Heat').." : "..heatbar
            if heat == 10 then BreakSaw(coords, saw, bag) break end
            if progress >= 10 then LootDepo(coords, saw, bag) break end
            local textpos = Config.Difficulties.CorridorDepositBox.UIPosition
            ShowText(text, 4, {255, 255, 255}, textpos.Text.scale, textpos.Text.x, textpos.Text.y)
            ShowText(commands, 4, {255, 255, 255}, textpos.Commands.scale, textpos.Commands.x, textpos.Commands.y)
        end
    end)
end

RegisterNetEvent('cr-paletobankrobbery:client:UseSaw', function(data)
    if LocalPlayer.state.inv_busy or Config.Targets.OutDepo.Busy then return end
    PBCUtils.HasItem(Config.Items.PowerSaw.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingItem'), Lcl("PaletoTitle")) return end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "RequestSound")
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "OutDepo", true)
        if not GlobalState.PaletoBankRobbery.CopsCalled then
            TriggerServerEvent('cr-paletobankrobbery:server:CopsAreCalled')
            PBCUtils.CallCops('Robbery')
        end
        LocalPlayer.state:set('inv_busy', true, true)
        local ped = PlayerPedId()
        TaskTurnPedToFaceCoord(ped, data.coords, 1000) Wait(1000)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0.25)
        local sawhash, bagModel, dic = 2115125482, 'hei_p_m_bag_var22_arm_s', 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
        LoadModel(sawhash) LoadModel(GetHashKey(bagModel)) LoadAnimDict(dic)
        local bag = CreateObject(GetHashKey(bagModel), coords, 1, 0, 0)

        local scene1 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, 1, 0, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene1, dic, 'intro', 4.0, 4.0, 0, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene1, dic, 'bag_intro', 1.0, 1.0, 1148846080)

        local scene2 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene2, dic, 'drill_straight_start', 4.0, 8.0, 5000, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene2, dic, 'bag_drill_straight_start', 1.0, 1.0, 1148846080)

        NetworkStartSynchronisedScene(scene1) Wait(2800)
        local saw = CreateObject(sawhash, coords, true, false, false)
        SetEntityCollision(saw, true, true)
        AttachEntityToEntity(saw, ped, GetPedBoneIndex(ped, 64016), 0.1, -0.05, -0.02, -0.0, -35.0, 165.0, false, false, false, false, 2, true)--right bone:28422)
        Wait(1800) NetworkStartSynchronisedScene(scene2)

        local sawID = NetworkGetNetworkIdFromEntity(saw)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SawSound", sawID)
        Wait(500)
        BreakDepoBox(coords, saw, bag)
    end)
end)

--~==================================~--
--~ Outside Deposit Box (Office Key) ~--
--~==================================~--

RegisterNetEvent('cr-paletobankrobbery:client:RemoveKey', function()
    if ManagerKey and ManagerKey ~= 0 then DeleteEntity(ManagerKey) end
end)

RegisterNetEvent('cr-paletobankrobbery:client:TakeKeys', function()
    local ped = PlayerPedId()
	LoadAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(ped, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 0, 0, 0, 0, 0)
    Wait(500)
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Key")
    TriggerServerEvent('cr-paletobankrobbery:server:GrabKeys')
end)

--~==============~--
--~ Drilled Safe ~--
--~==============~--

RegisterNetEvent('cr-paletobankrobbery:client:collectSafe', function()
    local t = Config.Targets.Drill
    local dict, anim, bagModel = 'anim@heists@ornate_bank@grab_cash_heels', 'grab', GetHashKey('prop_cs_heist_bag_02')
    local ped = PlayerPedId()
    TaskTurnPedToFaceCoord(ped, t.coords, 1500) Wait(1500)
    local pos = GetEntityCoords(ped)
    local safe = GetClosestObjectOfType(t.coords, 2.0, t.hash, 0, 0, 0)
    if not safe or safe == 0 then return end
    local offsets = {x = -0.2, y = 0.4, z = -0.70}
    local sceneRot = 135.0
    if Config.Framework.MLO == "K4MB1" then
        offsets = {x = 0.5, y = 0, z = -0.37}
        sceneRot = 0.0
    end
    LoadAnimDict(dict) LoadModel(bagModel)
    local moneyBag = CreateObject(bagModel, pos.x, pos.y,pos.z, true, 0, 0)
    AttachEntityToEntity(moneyBag, ped, GetPedBoneIndex(ped, 57005), 0.0, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SafeBusy", true)
    local x,y,z = table.unpack(GetEntityCoords(safe))
    local scene1 = NetworkCreateSynchronisedScene(x+offsets.x, y+offsets.y, z+offsets.z, 0.0, 0.0, sceneRot, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, dict, anim, 1.5, -4.0, 1, 16, 1.0, 0)
    NetworkStartSynchronisedScene(scene1)
    -- Grabbing Loot Under
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', 'InstallDrill')
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "RemoveSafeObjs", true)
    CreateThread(function()
        Wait(7000)
        DeleteEntity(moneyBag)
        ClearPedTasks(ped)
        TriggerServerEvent('cr-paletobankrobbery:server:collectSafe')
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:client:InstallDrill', function()
    local t = Config.Targets.Drill
    if t.Busy or t.isOpenned then return end
    PBCUtils.HasItem(Config.Items.MountedDrill.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingItem'), Lcl("PaletoTitle")) return end
        TriggerServerEvent('cr-paletobankrobbery::server:RemItem', Config.Items.MountedDrill.item, 1)
        local ped = PlayerPedId()
        local dict = 'anim@heists@ornate_bank@hack'
        LoadAnimDict(dict)
        local hash = t.hash
        local safe = GetClosestObjectOfType(t.coords, 2.0, hash, 0, 0, 0)
        if not safe or safe == 0 then return end
        local camCoords = vector3(-105.26, 6479.71, 32.0)
        local camRot = vector3(00.00, 0.00, 0.00)
        local offsets = {x = -0.1, y = 0.9, z = 0.65}
        local sceneRot = -30.0
        local safeDoorHash = 884736502
        if Config.Framework.MLO == "K4MB1" then
            camCoords = vector3(-107.38, 6458.65, 31.63)
            camRot = vector3(00.00, 0.00, 220.00)
            offsets = {x = 0.8, y = 0.8, z = 1.05}
            sceneRot = -150.0
            safeDoorHash = 2947971326
        end
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SafeBusy", true)
        local x,y,z = table.unpack(GetEntityCoords(safe))
        local drillModel, bagModel = GetHashKey("k4mb1_prop_drill2"), GetHashKey('hei_p_m_bag_var22_arm_s')
        LoadModel(drillModel) LoadModel(bagModel)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', 'RequestSound')
        local bagObj = CreateObject(bagModel, x, y, z-2.0, 1, 0, 0)
        local animPos = GetAnimInitialOffsetPosition(dict, 'hack_enter', x+offsets.x, y+offsets.y, z+offsets.z, 0.0, 0.0, 0.0, 0, 0)
        local scene1 = NetworkCreateSynchronisedScene(animPos, 0.0, 0.0, sceneRot, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene1, dict, 'hack_enter', 1.5, -4.0, 1, 16, 1.0, 0)
        NetworkAddEntityToSynchronisedScene(bagObj, scene1, dict, 'hack_enter_bag', 4.0, -8.0, 1)
        FreezeEntityPosition(ped, true)
        local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords, camRot, 80.0, true)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 1000, 0, 0)
        Wait(250)
        NetworkStartSynchronisedScene(scene1)
        Citizen.Wait(1000)
        local drill = CreateObject(drillModel, x, y, z-3.0,  true, 1, 0)
        AttachEntityToEntity(drill, ped, GetPedBoneIndex(ped, 64016), 0.0, 0.0, -0.1, 0.0, 0.0, 90.0, false, false, false, false, 2, true)--right bone:28422
        SetEntityCollision(drill, true)
        Citizen.Wait(1000)
        local safeDoor = GetClosestObjectOfType(x,y,z,1.0, safeDoorHash,0,0,0)
        if not safeDoor or safeDoor == 0 then return end
        AttachEntityToEntity(drill, safeDoor, 1, -0.35, -0.26, 0.39, 0.0, -90.0, 180.0, false, false, false, false, 2, true)--right bone:28422
        DetachEntity(drill, true, true) FreezeEntityPosition(drill, true)
        ClearPedTasks(ped)
        DeleteEntity(bagObj)
        Wait(1000)
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
        local netID = NetworkGetNetworkIdFromEntity(drill)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SawSound", netID)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "DrillFx")
        CreateThread(function()
            Wait(Config.Difficulties.WallSafe.TimeToDrill * 1000)
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
            TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopFx")
            DismantleDrillTarget(drill)
        end)
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:client:DismantleDrill', function(data)
    local ped = PlayerPedId()
    local dic, anim = 'anim@gangops@facility@servers@', 'hotwire'
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "RemoveDrill")
    TaskTurnPedToFaceEntity(ped, data.drill, 1500)
    Wait(1500)
    local onFinish = function()
        ClearPedTasks(ped)
        DeleteEntity(data.drill)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SafeBusy", false)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "OpenSafe")
    end
    PBCUtils.ProgressUI(5000, Lcl('progbar_DismountingDrill'), onFinish, nil, false, true, dic, anim, 16)
end)

local function OpenSafe()
    local coords, hash, entHeading = vector3(-105.22, 6480.66, 32.03), -1992154984, 315
    if Config.Framework.MLO == "K4MB1" then coords, hash, entHeading = vector3(-106.15, 6457.28, 30.73), 2947971326, 192.12 end
    local finH = entHeading + 120
    local SafeDoor = GetClosestObjectOfType(coords, 5.0, hash , false, false, false)
    if not SafeDoor or SafeDoor == 0 then return end
    if SafeDoor ~= 0 then
        CreateThread(function()
            while true do
                if entHeading < finH then
                    SetEntityHeading(SafeDoor, entHeading + 2.5)
                    entHeading = entHeading + 2.5
                else
                    break
                end
                Wait(10)
            end
        end)
    end
    Wait(1500)
end

--~==================~--
--~ K4MB1 Metal Gate ~--
--~===================~--

RegisterNetEvent('cr-paletobankrobbery:client:BombMetalGate', function()
    BombMetalGate()
end)

function BombMetalGate()
    local t = Config.Targets.Gate
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    if #(pcoords - t.coords) > 1.5 or t.Busy or LocalPlayer.state.inv_busy then return end
    PBCUtils.HasItem(Config.Items.Explosives.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl('notif_MissingItem'), Lcl("PaletoTitle")) return end
        Wait(500) LocalPlayer.state:set('inv_busy', true, true) DisableControls()
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "BombGate", true)
        PBCUtils.GateExplosive():next(function(success)
            if success then
                TriggerServerEvent("cr-paletobankrobbery:server:DeleteZones", "BombGate")
                TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Explosives.item, 1)
                LocalPlayer.state:set('inv_busy', false, true)
                ThermiteAnim("BombGate")
            else
                if Config.Difficulties.MetalGate.RemoveItemOnFail then TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Explosives.item, 1) end
                LocalPlayer.state:set('inv_busy', false, true)
                TriggerServerEvent('cr-paletobankrobbery:server:Sync', "BombGate", false)
                PBCUtils.Notif(3, Lcl("notif_ThermiteFailed"), Lcl("PaletoTitle"))
            end
        end)
    end)
end

--~=======~--
--~ Vault ~--
--~=======~--

local function CashInHand(loot)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)

    LoadModel(loot)
    local LootInHand = CreateObject(loot, pedCoords, true)

    FreezeEntityPosition(LootInHand, true)
    SetEntityInvincible(LootInHand, true)
    SetEntityNoCollisionEntity(LootInHand, ped)
    SetEntityVisible(LootInHand, false, false)
    AttachEntityToEntity(LootInHand, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    local StartTime = GetGameTimer()

    CreateThread(function()
        while GetGameTimer() < StartTime + 37000 do
            Wait(1)
            --DisableAllControlActions(0)
            --DisableControlAction(0,36,true)
            CRDisableControls(true)
            if HasAnimEventFired(ped, 726137971) then
                if not IsEntityVisible(LootInHand) then
                    SetEntityVisible(LootInHand, true, false)
                end
            end
            if HasAnimEventFired(ped, 3137358764) then
                if IsEntityVisible(LootInHand) then
                    SetEntityVisible(LootInHand, false, false)
                end
            end
        end
        DeleteObject(LootInHand)
    end)
end

RegisterNetEvent('cr-paletobankrobbery:client:GrabTableLoot', function()
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local CurrentTable = Config.Targets.Table
    if LocalPlayer.state.inv_busy or CurrentTable.grabbed then return end
    TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "Table")
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Table")
    LocalPlayer.state:set('inv_busy', true, true)
    DisableControls()
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    local animDict
    local stackModel = CurrentTable.model
    if stackModel == -180074230 then
        animDict = 'anim@scripted@heist@ig1_table_grab@gold@male@'
    else
        animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
    end
    LoadAnimDict(animDict)
    LoadModel('hei_p_m_bag_var22_arm_s')
    local heading = vector3(0.0, 0.0, CurrentTable.heading)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
    local TableLoot = GetClosestObjectOfType(CurrentTable.coords, 1.5, stackModel, false, false, false)

    local scene1 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'enter', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, animDict,'enter_bag', 1.0, -1.0, 1148846080)

    local scene2 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'grab', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'grab_bag', 1.0, -1.0, 1148846080)
    if stackModel == -180074230 then
        NetworkAddEntityToSynchronisedScene(TableLoot, scene2, animDict, 'grab_gold', 1.0, -1.0, 1148846080)
    else
        NetworkAddEntityToSynchronisedScene(TableLoot, scene2, animDict, 'grab_cash', 1.0, -1.0, 1148846080)
    end

    local scene3 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'exit_bag', 1.0, -1.0, 1148846080)

    NetworkStartSynchronisedScene(scene1)
    Wait(GetAnimDuration(animDict, 'enter') * 1000)
    NetworkStartSynchronisedScene(scene2)
    Wait(GetAnimDuration(animDict, 'grab') * 1000 - 3000)
    DeleteObject(TableLoot)
    NetworkStartSynchronisedScene(scene3)
    Wait(GetAnimDuration(animDict, 'exit') * 1000)
    ClearPedTasks(ped)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    TriggerServerEvent('cr-paletobankrobbery:server:TableLoot', stackModel)
    LocalPlayer.state:set('inv_busy', false, true)
end)

-- works??
RegisterNetEvent('cr-paletobankrobbery:client:GrabTrayLoot', function(data)
    local v = Config.Targets.Trays[data.loc]
    if LocalPlayer.state.inv_busy or v.Busy then return end

    LocalPlayer.state:set('inv_busy', true, true)
    DisableControls()
    TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "GrabTray", data.loc)
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Tray", data.loc)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local TrayHash = v.model
    local TrayLoot
    if TrayHash == 881130828 then TrayLoot = 'ch_prop_vault_dimaondbox_01a'
    elseif TrayHash == 2007413986 then TrayLoot = 'ch_prop_gold_bar_01a'
    else TrayLoot = 'hei_prop_heist_cash_pile' end

    local animDict = 'anim@heists@ornate_bank@grab_cash'
    LoadAnimDict(animDict)
    LoadModel(3350498815)

    local Tray = GetClosestObjectOfType(v.coords, 1.5, TrayHash, 0, 0, 0)
    local bag = CreateObject(3350498815, pedCo, true, false, false)

    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(Tray), GetEntityRotation(Tray), 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'intro', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, animDict, 'bag_intro', 4.0, -8.0, 1)

    local scene2 =  NetworkCreateSynchronisedScene(GetEntityCoords(Tray), GetEntityRotation(Tray), 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'grab', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'bag_grab', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(Tray, scene2, animDict, 'cart_cash_dissapear', 4.0, -8.0, 1)

    local scene3 =  NetworkCreateSynchronisedScene(GetEntityCoords(Tray), GetEntityRotation(Tray), 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'bag_exit', 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, Config.EmptyBackID, 1, 1)
    NetworkStartSynchronisedScene(scene1)
    Wait(1750)
    CashInHand(TrayLoot)
    NetworkStartSynchronisedScene(scene2)
    Wait(37000)
    NetworkStartSynchronisedScene(scene3)
    Wait(2000)

    local newTrolly = CreateObject(769923921, v.coords, true, false, false)
    SetEntityRotation(newTrolly, v.rot, 1, 0)
    DeleteObject(Tray)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    TriggerServerEvent('cr-paletobankrobbery:server:TrayLoot', TrayHash, data.loc)
    LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
end)

RegisterNetEvent('cr-paletobankrobbery:client:GrabGabzTray', function(data)
    local v = Config.Targets.MiddleTray
    if LocalPlayer.state.inv_busy or v.Busy then return end

    LocalPlayer.state:set('inv_busy', true, true)
    DisableControls()
    TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', "GabzTray")
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "GabzTray", pedCo, data.model)
    local TrayHash = data.model
    local TrayLoot
    if TrayHash == 881130828 then TrayLoot = 'ch_prop_vault_dimaondbox_01a'
    elseif TrayHash == 2007413986 then TrayLoot = 'ch_prop_gold_bar_01a'
    else TrayLoot = 'hei_prop_heist_cash_pile' end

    local animDict = 'anim@heists@ornate_bank@grab_cash'
    LoadAnimDict(animDict)
    LoadModel(3350498815)
    local Tray = GetClosestObjectOfType(v.coords, 1.5, TrayHash, 0, 0, 0)
    local bag = CreateObject(3350498815, pedCo, true, false, false)
    local trayRot = GetEntityRotation(Tray)
    local trayCoords = GetEntityCoords(Tray)
    SetEntityCoords(Tray, trayCoords.x, trayCoords.y, trayCoords.z-10, 0, 0, 0, 0)
    Tray = CreateObject(TrayHash, trayCoords.x, trayCoords.y, trayCoords.z-0.5, true, false, false)
    SetEntityRotation(Tray, trayRot, 1, 0)

    local scene1 = NetworkCreateSynchronisedScene(trayCoords, trayRot, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'intro', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, animDict, 'bag_intro', 4.0, -8.0, 1)

    local scene2 =  NetworkCreateSynchronisedScene(trayCoords, trayRot, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'grab', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'bag_grab', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(Tray, scene2, animDict, 'cart_cash_dissapear', 4.0, -8.0, 1)

    local scene3 =  NetworkCreateSynchronisedScene(trayCoords, trayRot, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'bag_exit', 4.0, -8.0, 1)

    SetPedComponentVariation(ped, 5, Config.EmptyBackID, 1, 1)
    NetworkStartSynchronisedScene(scene1)
    Wait(1750)
    CashInHand(TrayLoot)
    NetworkStartSynchronisedScene(scene2)
    Wait(37000)
    NetworkStartSynchronisedScene(scene3)
    Wait(2000)

    local newTrolly = CreateObject(769923921, trayCoords.x, trayCoords.y, trayCoords.z-0.5, true, false, false)
    SetEntityRotation(newTrolly, trayRot, 1, 0)
    DeleteObject(Tray)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    TriggerServerEvent('cr-paletobankrobbery:server:TrayLoot', TrayHash, data.loc)
    LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
end)

-- Finishing Drilling
local function FinishedDrill(data, amount, reason)
    local t = Config.Targets.DepositBoxes[data.k]
    local Sync1, Sync2, Del = "DepoBoxSpawn", "DepositBox", "Wall"
    if data.inner then
        t = Config.Targets.InnerVaultBoxes[data.k]
        Sync1, Sync2, Del = "InnerDepoBoxSpawn", "InnerDepositBox", "InnerBox"
    end
    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
    if reason == "broke" then
        TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Drill.item, 1)
        PBCUtils.Notif(3, Lcl("notif_DrillBroke"), Lcl("PaletoTitle"))
    end
    if amount >= t.BoxAmount then
        TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', Del, data.k)
    else
        local newAmount = t.BoxAmount - amount
        TriggerServerEvent('cr-paletobankrobbery:server:VaultSync', Sync1, data.k, newAmount)
        TriggerServerEvent("cr-paletobankrobbery:server:VaultSync", Sync2, data.k, false)
    end
    local ped = PlayerPedId()
    Wait(2000)
    --SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(data.cam, false)
    local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
    local scene3 = NetworkCreateSynchronisedScene(data.scene.boxPos, data.scene.boxRot, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', -1 , -1.0, 5000, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(data.bag, scene3, animDict, 'bag_exit', -1.0, -1.0, 1148846080)
    NetworkStartSynchronisedScene(scene3)
    AttachEntityToEntity(data.laserDrill, ped, GetPedBoneIndex(ped, 64016), 0.05, -0.05, 0.02, 10.0, 10.0, 60.0, false, false, false, false, 2, true)--right bone:28422
    Wait(1250)
    DeleteObject(data.laserDrill)
    DeleteObject(data.bag)
    Wait(800)
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    --CRDisableControls(true)
end

-- Custom Drilling Minigame
local function DrillDepoBox(data)
    CreateThread(function()
        local progress = 0
        local heating = 0
        local cooling = 0
        local heat = 0
        local heat2 = 0
        local loot = 0
        local maxloot = Config.Targets.DepositBoxes[data.k].BoxAmount
        if data.inner then maxloot = Config.Targets.InnerVaultBoxes[data.k].BoxAmount end
        local breaking = 0
        local StopReason
        local CurrentSweet = math.random(2,8)
        while true do
            local pba = ""
            local pbb = ""
            local progressbar = "|"
            local hba = "|"
            local hbb = ""
            local heatbar = ""
            Wait(2)
            if IsControlPressed(0, 22) then
                cooling = 0
                heating = heating + (math.random(3) * 2)
                if heating >= 150 then heat = heat + 1 heating = 0 end
            else
                if heating > 0 then heating = heating - 1 end
                if cooling >= 0 then cooling = cooling + 1 end
                if cooling >= 50 then if heat > 0 then heat = heat - 1 end cooling = 0 end
            end
            if IsControlPressed(0, 47) then StopReason = "stop" break end
            if heat == CurrentSweet then
                heat2 = heat2 + 1
                if heat2 >= 100 then
                    local chance = math.random(10)
                    if chance == 1 then heat2 = 0 progress = progress + 1 end
                end
            else
                if heat2 > 0 then heat2 = heat2 - 1 end
                if heat >= CurrentSweet then breaking = breaking + 1 end
            end
            if breaking >= Config.Difficulties.DrillingMinigame.BladeHealth then StopReason = "broke" break end
            if progress >= 10 then
                progress = 0
                loot = loot + 1
                print(data.inner)
                TriggerServerEvent('cr-paletobankrobbery:server:DepoLoot', data.k, "loot", data.inner)
                CurrentSweet = math.random(2,8)
                breaking = math.floor(breaking/2)
                if loot >= maxloot then StopReason = "done" break end
            end
            for _ = 0, progress - 1, 1 do pba = pba.."-" end
            local diff = 10 - progress
            for _ = 0, diff - 1, 1 do pbb = pbb.."-" end
            progressbar = progressbar..'~g~'..pba..'~r~'..pbb.."~w~|"
            for _ = 0, heat - 1, 1 do hba = hba.."|" end
            local heatdiff = 9 - heat
            for _ = 0, heatdiff, 1 do hbb = hbb.."|" end
            heatbar = heatbar..'~r~'..hba..'~w~'..hbb
            local commands = "~b~[Space]~w~ "..Lcl('DrillingUI_Drill').." ~b~[G]~w~ "..Lcl('DrillingUI_Stop')
            if heat == CurrentSweet then commands = commands.."~y~ - ~g~"..Lcl('DrillingUI_Hold').." !"
            elseif heat > CurrentSweet then commands = commands.. "~y~ - ~r~"..Lcl('DrillingUI_TooDeep').." !" end
            local text = Lcl('DrillingUI_Progress').." : "..progressbar.."\n"..Lcl('DrillingUI_Depth').." : "..heatbar
            if heat == 10 then StopReason = "broke" if Config.Difficulties.DrillingMinigame.DrillCanBreak then TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Drill.item, 1) PBCUtils.Notif(3, Lcl("notif_DrillBroke"), Lcl("PaletoTitle")) end break end
            local textpos = Config.Difficulties.DrillingMinigame.UIPosition.Text
            local commandpos = Config.Difficulties.DrillingMinigame.UIPosition.Commands
            ShowText(text, 4, {255, 255, 255}, textpos.scale, textpos.x, textpos.y)
            ShowText(commands, 4, {255, 255, 255}, commandpos.scale, commandpos.x, commandpos.y)
        end
        FinishedDrill(data, loot, StopReason)
    end)
end

-- Drilling Handle
RegisterNetEvent('cr-paletobankrobbery:client:DrillBoxes', function(data)
    local box, ped = data.box, PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local v, Sync = Config.Targets.DepositBoxes[box], "DepositBox"
    if data.inner then
        v = Config.Targets.InnerVaultBoxes[box]
        Sync = "InnerDepositBox"
    end
    local drillDist = #(pedCo - v.coords)
    if LocalPlayer.state.inv_busy or drillDist > 1.5 then return end
    if v.Busy then PBCUtils.Notif(3, Lcl("notif_AlreadyDone"), Lcl("PaletoTitle")) return end
    PBCUtils.HasItem(Config.Items.Drill.item):next(function(hasItem)
        if not hasItem then PBCUtils.Notif(3, Lcl("notif_MissingItem"), Lcl('PaletoTitle')) PBCUtils.MissingItem(Config.Items.Drill.item) return end
        v.Busy = true
        LocalPlayer.state:set('inv_busy', true, true) DisableControls()
        TriggerServerEvent("cr-paletobankrobbery:server:VaultSync", Sync, box, true)
        TriggerServerEvent('cr-paletobankrobbery:server:Sync', "RequestSound")
        local laserDrill, bag
        local sentScene = {}
        local coords = GetEntityCoords(ped)
        local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
        local bagModel = 'hei_p_m_bag_var22_arm_s'
        local laserDrillModel = 'hei_prop_heist_drill'
        local boxPos = v.coords
        local boxRot = vector3(0,0, v.heading)
        sentScene.boxPos = boxPos sentScene.boxRot = boxRot
        LoadAnimDict(animDict) LoadModel(bagModel) LoadModel(laserDrillModel)
        bag = CreateObject(GetHashKey(bagModel), coords, 1, 0, 0)
        laserDrill = CreateObject(GetHashKey(laserDrillModel), coords, 1, 0, 0)
        SetEntityCollision(bag, false)
        SetEntityCollision(laserDrill, false)

        local scene1 = NetworkCreateSynchronisedScene(boxPos, boxRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'intro', 4.0, -4.0, 1033, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene1, animDict, 'bag_intro', 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(laserDrill, scene1, animDict, 'intro_drill_bit', 1.0, -1.0, 1148846080)

        local scene2 = NetworkCreateSynchronisedScene(boxPos, boxRot, 2, false, true, 1065353216, -1, -1)
        NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'drill_straight_idle', 2.0, 8.0, -1, 17, 8.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'bag_drill_straight_idle', 1.0, -1.0, 1148846080)
        NetworkAddEntityToSynchronisedScene(laserDrill, scene2, animDict, 'drill_straight_idle_drill_bit', 1.0, -1.0, 1148846080)

        NetworkStartSynchronisedScene(scene1)
        local sawID = NetworkGetNetworkIdFromEntity(laserDrill)
        Wait(6000) TriggerServerEvent('cr-paletobankrobbery:server:Sync', "SawSound", sawID)
        NetworkStartSynchronisedScene(scene2)
        if Config.Difficulties.DrillingMinigame.Type == "fivem-drilling" then
            local DrillDone
            TriggerEvent('Drilling:Start',function(success)
                if DrillDone then return end
                DrillDone = true
                if success then
                    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
                    Wait(1000)
                    --RenderScriptCams(false, false, 0, 1, 0)
                    --DestroyCam(cam, false)
                    TriggerServerEvent('cr-paletobankrobbery:server:DepoLoot', box, nil, data.inner)
                    TriggerServerEvent('cr-paletobankrobbery:server:DeleteZones', "Wall", box)
                    local scene3 = NetworkCreateSynchronisedScene(boxPos, boxRot, 2, true, false, 1065353216, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', -1 , -1.0, 5000, 0, 1000.0, 0)
                    NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'bag_exit', -1.0, -1.0, 1148846080)
                    NetworkStartSynchronisedScene(scene3)
                    AttachEntityToEntity(laserDrill, ped, GetPedBoneIndex(ped, 64016), 0.05, -0.05, 0.02, 10.0, 10.0, 60.0, false, false, false, false, 2, true)--right bone:28422
                    Wait(1250)
                    DeleteObject(laserDrill)
                    DeleteObject(bag)
                    Wait(800)
                    ClearPedTasks(ped)
                    CRDisableControls(false)
                    LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
                    DrillDone = false
                else
                    PBCUtils.Notif(3, Lcl('notif_DrillOverHeat'), Lcl('PaletoTitle'))
                    TriggerServerEvent('cr-paletobankrobbery:server:Sync', "StopSound")
                    if Config.Difficulties.DrillingMinigame.DrillCanBreak then
                        local breakChance = math.random(100)
                        if breakChance <= Config.Difficulties.DrillingMinigame.DrillBreakChance then
                            PBCUtils.Notif(3, Lcl("notif_DrillBroke"), Lcl('PaletoTitle'))
                            TriggerServerEvent('cr-paletobankrobbery:server:RemItem', Config.Items.Drill.item, 1)
                        end
                    end
                    Wait(2000)
                    RenderScriptCams(false, false, 0, 1, 0)
                    --DestroyCam(cam, false)
                    ClearPedTasks(ped)
                    DeleteObject(bag)
                    DeleteObject(laserDrill)
                    TriggerServerEvent("cr-paletobankrobbery:server:VaultSync", Sync, box, false)
                    LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
                    CRDisableControls(false)
                    DrillDone = false
                end
            end)
        elseif Config.Difficulties.DrillingMinigame.Type == "custom" then
            DrillDepoBox({bag = bag, laserDrill = laserDrill, k = box, scene = sentScene, inner = data.inner})
        end
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:client:ResetBank', function()
    PBCUtils.Debug('Resetting Bank....')
    ResetBank = true
    Wait(5000)
    ResetAllTargets()
    Pfx, sec_seq_code, CurrentVaultCall, DoorTimerActive, TooLate, TryAgain, SoundID, PhoneAnswered, hasVault1codes, hasVault2codes = nil, nil, nil, nil, nil, nil, nil, false, nil, nil
    if ManagerKey and ManagerKey ~= 0 then DeleteEntity(ManagerKey) ManagerKey = nil end
    for _, v in pairs(Config.Doors) do if type(v) == "table" then PBCUtils.ResetDoors(v[1]) PBCUtils.ResetDoors(v[2]) else PBCUtils.ResetDoors(v) end end
    Wait(2000)
    DistanceCheck()
    PBCUtils.Debug('Reset Completed!')
end)

--~===========~--
--~ Utilities ~--
--~===========~--

local VaultSync = {
    ['Walls'] = function() ActivateBoxesTargets() end,
    ['DepoBoxSpawn'] = function(arg1, arg2) Config.Targets.DepositBoxes[arg1].BoxAmount = arg2 end,
    ['InnerDepoBoxSpawn'] = function(arg1, arg2) Config.Targets.InnerVaultBoxes[arg1].BoxAmount = arg2 end,
    ['GrabTray'] = function(arg1) Config.Targets.Trays[arg1].Busy = true end,
    ['GabzTray'] = function() Config.Targets.MiddleTray.Busy = true end,
    ['DepoLoot'] = function(arg1) Config.Targets.DepositBoxes[arg1].LootedAmount = Config.Targets.DepositBoxes[arg1].LootedAmount + 1 end,
    ['DepositBox'] = function(arg1, arg2) Config.Targets.DepositBoxes[arg1].Busy = arg2 end,
    ['InnerDepositBox'] = function(arg1, arg2) Config.Targets.InnerVaultBoxes[arg1].Busy = arg2 end,
    ['Trays'] = function(arg1, arg2, arg3)
        Wait(2000) local entity = NetworkGetEntityFromNetworkId(arg3)
        Config.Targets.Trays[arg1].model = arg2 ActivateTrayTargets(entity, arg1)
    end,
    ['Table'] = function(arg1, arg2)
        Wait(2000) local entity = NetworkGetEntityFromNetworkId(arg2)
        Config.Targets.Table.model = arg1 ActivateTableTarget(entity)
    end,
}

local SyncEvent = {
    ['SecSeq'] = function(arg1) Config.Targets.SecSeq.Busy = arg1 end,
    ['SearchBinder'] = function(arg1, arg2) Config.Targets.Binders[arg2].Busy = arg1 end,
    ['VaultComputer'] = function(arg1) Config.Targets.VaultComputer.Busy = arg1 end,
    ['VaultKeypad'] = function(arg1) Config.Targets.VaultKeypad.Busy = arg1 end,
    ['OutsidePower'] = function(arg1, arg2) Config.Targets.OutsidePower[arg2].Busy = arg1 end,
    ['OfficeComputer'] = function(arg1, arg2) Config.Targets.OfficeComputers[arg2].Busy = arg1 end,
    ['OutDepo'] = function(arg1) Config.Targets.OutDepo.Busy = arg1 end,
    ['SafeBusy'] = function(arg1) Config.Targets.Drill.Busy = arg1 end,
    ['BombGate'] = function(arg1) Config.Targets.Gate.Busy = arg1 end,
    ['DoorTimer'] = function(arg1) DoorTimerActive = arg1 end,
    ['K4MB1Vault'] = function() SetupK4MB1Vault() end,
    ['SetupInner'] = function() SetupSecondVault() end,
    ['SetupBinders'] = function() SetupBinders() end,
    ['OpenSafe'] = function() Config.Targets.Drill.isOpenned = true OpenSafe() end,
    ['StopSound'] = function() StopSound(SoundID) ReleaseSoundId(SoundID) end,
    ['StopFx'] = function() StopParticleFxLooped(Pfx, 0) Pfx = nil end,
    ['GabzVault'] = function(arg1, arg2) SetupGabzVault(arg1, arg2) end,
    ['HideBinders'] = function(arg1, arg2, arg3) local obj = GetClosestObjectOfType(arg1, 0.2, arg2, 0, 0, 0)
        if not obj or obj == 0 then return end SetEntityVisible(obj, arg3, 0) end,
    ['GodMetalGate'] = function() local gate = GetClosestObjectOfType(vector3(-105.52, 6460.55, 31.98), 2.0, 1450792563, 0, 0, 0)
        if not gate or gate == 0 then return end SetEntityInvincible(gate, true) end,
    ['SawSound'] = function(arg1)
        SoundID = GetSoundId()
        local saw = NetworkGetEntityFromNetworkId(arg1)
        if not saw then return end
        PlaySoundFromEntity(SoundID, 'Drill', saw, 'DLC_HEIST_FLEECA_SOUNDSET', true, 0)
    end,
    ['RemoveSafeObjs'] = function()
        local safeObjs = {1282927707, 1282927707, 1282927707, 1282927707, 1282927707, 1282927707, 289396019, 690307545}
        if Config.Framework.MLO == "K4MB1" then safeObjs = {289396019, 289396019, 289396019} end
        local t = Config.Targets.Drill
        for _, v in ipairs(safeObjs) do
            Wait(750)
            local obj = GetClosestObjectOfType(t.coords, 1.0, v, 0, 0, 0)
            if not obj or obj == 0 then return end
            SetEntityCoords(obj, t.coords.x, t.coords.y, t.coords.z-10, 0, 0, 0 ,0)
        end
    end,
    ['RequestSound'] = function()
        RequestAmbientAudioBank('DLC_HEIST_FLEECA_SOUNDSET', true)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', 1)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', 0)
    end,
    ['DrillFx'] = function()
        local pfxAsset, pfxEffect = 'core', 'ent_anim_pneumatic_drill'
        LoadPfxAsset(pfxAsset) SetPtfxAssetNextCall(pfxAsset)
        local coords = vector3(-105.36, 6480.76, 32.14)
        if Config.Framework.MLO == "K4MB1" then coords = vector3(-105.81, 6457.37, 31.83) end
        Pfx = StartParticleFxLoopedAtCoord(pfxEffect, coords, 0.0, 0.0, 0.0, 1.0, false, false, false, false, 0)
    end,
}

RegisterNetEvent('cr-paletobankrobbery:client:VaultSync', function(type, arg1, arg2, arg3) VaultSync[type](arg1, arg2, arg3) end)
RegisterNetEvent('cr-paletobankrobbery:client:Sync', function(type, arg1, arg2, arg3) SyncEvent[type](arg1, arg2, arg3) end)

-- Setting Up Bank Environment
function DistanceCheck()
    local ped = PlayerPedId()
    local kcoord, HeadingSet, ChairSet
    local bcoords = vector3(-105.27, 6473.13, 31.63)
    local ccoords = vector3(-94.41, 6466.10, 30.63)
    CreateThread(function()
        while true do
            local wait = 5000
            local pcoords = GetEntityCoords(ped)
            local v, d
            if Config.Framework.MLO == "K4MB1" then
                if #(pcoords - bcoords) <= 50 then
                    if GlobalState.PaletoBankRobbery.ManagerKey then
                        kcoord = Config.Targets.ManagerKey[GlobalState.PaletoBankRobbery.ManagerKey].coords
                        ManagerKey = GetClosestObjectOfType(kcoord.x, kcoord.y, kcoord.z, 2.0, GetHashKey('prop_cuff_keys_01'), 0, 0, 0)
                        if not ManagerKey or ManagerKey == 0 then
                            ManagerKey = CreateObject(GetHashKey('prop_cuff_keys_01'), kcoord, 0, 0, 0)
                            SetupKeyTarget(ManagerKey)
                        end
                    else
                        if ManagerKey and ManagerKey ~= 0 then DeleteEntity(ManagerKey) end
                    end
                    if not GlobalState.PaletoBankRobbery.BankInProgress and not HeadingSet then
                        wait = 10
                        local obj = GetClosestObjectOfType(bcoords.x, bcoords.y, bcoords.z, 10.0, -1185205679)
                        if obj and obj ~= 0 then SetEntityHeading(obj, 45.00) v = true end
                        local obj2 = GetClosestObjectOfType(bcoords.x, bcoords.y, bcoords.z, 1.0, 1622278560)
                        if obj2 and obj2 ~= 0 then SetEntityCoords(obj2, bcoords.x, bcoords.y, bcoords.z-10, 0, 0,0,0) d = true end
                        --SetEntityHeading(obj2, 45.00) d = true end
                        if v and d then HeadingSet = true end
                    end
                    if not OutKeypadProp then
                        local t = Config.Targets.OutsideKeypad
                        LoadModel(t.Hash)
                        OutKeypadProp = CreateObject(t.Hash, t.coords, 0, 0, 0)
                        SetEntityHeading(OutKeypadProp, t.heading)
                        FreezeEntityPosition(OutKeypadProp, true)
                    end
                else
                    if HeadingSet then HeadingSet = false end
                end
            elseif Config.Framework.MLO == "Gabz" then
                if #(pcoords - ccoords) <= 200 then
                    if GlobalState.PaletoBankRobbery.ManagerKey then
                        kcoord = Config.Targets.ManagerKey[GlobalState.PaletoBankRobbery.ManagerKey].coords
                        ManagerKey = GetClosestObjectOfType(kcoord.x, kcoord.y, kcoord.z, 2.0, GetHashKey('prop_cuff_keys_01'), 0, 0, 0)
                        if not ManagerKey or ManagerKey == 0 then
                            ManagerKey = CreateObject(GetHashKey('prop_cuff_keys_01'), kcoord, 0, 0, 0)
                            SetupKeyTarget(ManagerKey)
                        end
                    else
                        if ManagerKey and ManagerKey ~= 0 then DeleteEntity(ManagerKey) end
                    end
                    if not ChairSet then
                        wait = 10
                        local obj = GetClosestObjectOfType(ccoords.x, ccoords.y, ccoords.z, 2.0, 536071214)
                        if obj and obj ~= 0 then SetEntityCoords(obj, ccoords.x, ccoords.y, ccoords.z-20) ChairSet = true end
                    end
                else
                    if ChairSet then ChairSet = false end
                end
            end
            if ResetBank then ResetBank = false break end
            Wait(wait)
        end
    end)
end

-- CFX Native Keyboard input
function GetKeyBoard(text)
    AddTextEntry('CH_INPUT', Lcl('hack_KeyboardTitle'))
    DisplayOnscreenKeyboard(1, "CH_INPUT", "", "", "", "", "", 20)
    while UpdateOnscreenKeyboard() == 0 do Citizen.Wait(0) if text then ShowText(text, 4, {255, 255, 255}, 0.4, 0.55, 0.888 + 0.025) end end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(0)
        return result
    else
        Citizen.Wait(0)
        return nil
    end
end

-- Disable Controls
function DisableControls()
    Citizen.CreateThread(function()
        while LocalPlayer.state['inv_busy'] do
            CRDisableControls(true)
            Wait(1)
            if not LocalPlayer.state['inv_busy'] then break end
            if LocalPlayer.state['nui'] then
            if not IsNuiFocused() then LocalPlayer.state:set('textui', false, true) LocalPlayer.state:set('inv_busy', false, true) break end end
        end
    end)
end

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

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        PBCUtils.Debug(Lcl('debug_loadingbank'))
        LoadModel(GetHashKey('prop_cuff_keys_01'))
        SetupPaletoBank()
        DistanceCheck()
    end
end)

if Config.DevMode then
    RegisterCommand("resetpaletobank", function()
        TriggerServerEvent('cr-paletobankrobbery:server:ForceReset')
    end)

    RegisterCommand("setuppaletobank", function()
        SetupBank()
    end)
end