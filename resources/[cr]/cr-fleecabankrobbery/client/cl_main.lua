local closestBank, TickEnded, SoundID, HasCodes
local AttemptingVault = false
LocalPlayer.state:set('inv_busy', false, true)
LocalPlayer.state:set('nui', false, true)
LocalPlayer.state:set('textui', false, true)
LocalPlayer.state:set('closestbank', nil, true)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        print(Lcl('debug_loadingbanks'))
        if Config.Framework.MLO == "Gabz" then PrepareBanks() end
        SetupCRFleecaBanks()
    end
end)

--~===========~--
--~ Utilities ~--
--~===========~--

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function LoadModel(model)
    while (not HasModelLoaded(model)) do
        RequestModel(model)
        Citizen.Wait(5)
    end
end

function ShowText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

local function DisableControls()
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

local function CloseKeyPad()
    SetNuiFocus(false, false)
    LocalPlayer.state:set('nui', false, true)
    LocalPlayer.state:set('textui', false, true)
    LocalPlayer.state:set('inv_busy', false, true)
end

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

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function LootAtEntity(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

-- Closest Bank Thread
CreateThread(function()
    while true do
        Wait(100)
        local pos = GetEntityCoords(PlayerPedId())
        local inRange = false

        for k, v in pairs(Config.Banks) do
            local dist = #(pos - vector3(v['loc'].x, v['loc'].y, v['loc'].z))
            if dist < 15 then
                LocalPlayer.state:set('closestbank', k, true)
                closestBank = k
                inRange = true
            end
        end

        if not inRange then
            Wait(2000)
            closestBank = nil
        end
    end
end)

--~============~--
--~ Bank Setup ~--
--~============~--

local function SetupBank(bank)
    if Config.Debug then print(Lcl('debug_generatingloot', Config.Banks[bank].name)) end
    local loot
    local AmountSpawned = 0
    local MaxAmount = math.random(Config.Rewards.Trays.MaxTrayAmount)
    if Config.Framework.MLO == "Gabz" then MaxAmount = MaxAmount + 1 end
    if Config.DevMode or MaxAmount > 5 then MaxAmount = 5 end
    --Table Setup
    if Config.Framework.MLO == "K4MB1" then
        local chance = math.random(100)
        local itemHash = "h4_prop_h4_cash_stack_01a"
        if chance <= Config.Rewards.Table.GoldChance then itemHash = "h4_prop_h4_gold_stack_01a" end
        --if chance <= Config.Table.GoldPileChance then itemHash = "h4_prop_h4_gold_stack_01a" end
        loot = CreateObject(GetHashKey(itemHash), Config.Banks[bank].Table.coords, 1, 1, 0)
        SetEntityHeading(loot, Config.Banks[bank].Table.heading)
        local TableNetID = NetworkGetNetworkIdFromEntity(loot)
        TriggerServerEvent('cr-fleecabankrobbery:server:VaultSync', "Table", bank, GetHashKey(itemHash), TableNetID)
        if Config.Debug then local tableloot
            if itemHash == 'h4_prop_h4_gold_stack_01a' then tableloot = "Gold" else tableloot = "Cash" end print(Lcl('debug_generatingtable', tableloot)) end
    end
    --Trays Setup
    while AmountSpawned < MaxAmount do
        for k, v in pairs(Config.Banks[bank].Trays) do
            if AmountSpawned < MaxAmount then
                local try = math.random(3)
                if try == 1 then
                    if not v.isSpawned then
                        local TrayChance = math.random(100)
                        if TrayChance <= 50 then
                            local loc = v.coords
                            local TrayLoot = math.random(100)
                            local TrayHash = 269934519
                            v.isSpawned = true
                            if TrayLoot <= Config.Rewards.Trays.GoldChance then TrayHash = 2007413986 end
                            local TrayObj = CreateObject(TrayHash, loc.x, loc.y, loc.z , 1, 0, 0)
                            local NetID = NetworkGetNetworkIdFromEntity(TrayObj)
                            TriggerServerEvent('cr-fleecabankrobbery:server:VaultSync', "Trays", bank, k, TrayHash, NetID)
                            SetEntityHeading(TrayObj, v.heading)
                            AmountSpawned = AmountSpawned + 1
                            if Config.Debug then local traytype
                                if TrayHash == 2007413986 then traytype = "Gold" else traytype = "Cash" end print(Lcl('debug_generatingtray', AmountSpawned, traytype)) end
                            if AmountSpawned == MaxAmount then break end
                        end
                    end
                end
            end
        end
    end
    --Deposit Boxes Setup
    TriggerServerEvent('cr-fleecabankrobbery:server:VaultSync', "Walls", bank, MaxAmount)
    for k,v in pairs(Config.Banks[bank].DepositBoxes) do
        if v.BoxAmount == 0 then
            local Amount = math.random(Config.Rewards.DepositBoxes.BoxAmount.Min, Config.Rewards.DepositBoxes.BoxAmount.Max )
            v.BoxAmount = Amount
            TriggerServerEvent('cr-fleecabankrobbery:server:VaultSync', "DepoBoxSpawn", bank, k, Amount)
            if Config.Debug then print(Lcl('debug_generatingwall', k, Amount)) end
        end
    end
end

--~==============~--
--~ Teller Doors ~--
--~==============~--

--Teller Doors
RegisterNetEvent('cr-fleecabankrobbery:client:FleecaBankTellerDoors', function()
    local Door = Config.Banks[closestBank].TellerDoors
    if LocalPlayer.state.inv_busy or Door.Occupied then return end
    if GlobalState.CRFleecaBank.GlobalCD or GlobalState.CRFleecaBank.Banks[closestBank].onCooldown then FBCUtils.Notif(3, Lcl("CooldownMessage"), Lcl('FleecaTitle')) return end
    FBCUtils.HasItem(Config.Items.Lockpick.item):next(function(hasItem)
        if not hasItem then FBCUtils.Notif(3, Lcl("MissingItem"), Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.LockpickItem) return end
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "tellerdoor", closestBank, true)
        Door.Occupied = true
        LocalPlayer.state:set('inv_busy', true, true) DisableControls()
        local ped = PlayerPedId()
        SetEntityCoords(ped, Door.coords.x, Door.coords.y, Door.coords.z-1)
        SetEntityHeading(ped, Door.heading)
        local onFinish = function()
            TaskPlayAnim(ped, 'mp_common_heist', 'pick_door', 2.0, 2.0, -1, 1, 1.0, 1, 1, 1)
            FBCUtils.Circle("TellerDoor"):next(function(success)
                if success then
                    ClearPedTasks(ped)
                    FBCUtils.UnlockDoor(Config.FleecaBankTellerDoors[closestBank])
                    LocalPlayer.state:set('inv_busy', false, true)
                    LocalPlayer.state:set('textui', false, true)
                    TriggerServerEvent("cr-fleecabankrobbery:server:TellerUnlocked", closestBank)
                    TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "tellerdoor")
                    FBCUtils.Notif(1, Lcl("EnterTellerOffice"), Lcl("FleecaTitle"))
                else
                    LocalPlayer.state:set('inv_busy', false, true)
                    LocalPlayer.state:set('textui', false, true)
                    ClearPedTasks(ped)
                    FBCUtils.Notif(3, Lcl("LockpickFailed"), Lcl('FleecaTitle'))
                    TriggerServerEvent("cr-fleecabankrobbery:server:FleecaBankLockPickRemoval")
                    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "tellerdoor", closestBank, false)
                end
            end)
        end
        local onCancel = function()
            ClearPedTasks(ped)
            LocalPlayer.state:set('textui', false, true)
            LocalPlayer.state:set('inv_busy', false, true)
            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "tellerdoor", closestBank, false)
        end
        FBCUtils.ProgressUI(math.random(1500, 3000), Lcl('progbar_lockpicking'), onFinish, onCancel, true, true, 'mp_common_heist', 'pick_door', 1)
    end)
end)

RegisterNetEvent('cr-fleecabankrobbery:client:UnhookChair', function(bank)
    local ped = PlayerPedId()
    local pcoords = GetEntityCoords(ped)
    local bcoords = vector3(Config.Banks[bank].loc.x, Config.Banks[bank].loc.y, Config.Banks[bank].loc.z)
    if #(bcoords - pcoords) >= 20 then return end
    local Chair = GetClosestObjectOfType(Config.Banks[bank].ComputerCoords.coords, 2.0, 652816835, 0, 0, 0)
    if Chair == 0 then return end
    FreezeEntityPosition(Chair, false)
end)

--~===============~--
--~ Prevault Code ~--
--~===============~--

-- Grabbing Codes
RegisterNetEvent('cr-fleecabankrobbery:client:FleecaBankPrinters', function()
    local onFinish = function()
        if Config.Framework.Framework == "ESX" then HasCodes = true end
        TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "printer")
        TriggerServerEvent("cr-fleecabankrobbery:server:GetSecurityCode", closestBank)
    end
    FBCUtils.ProgressUI(1500, Lcl('progbar_grabbing'), onFinish, nil, false, true, "pickup_object", "putdown_low", 16)
end)

-- Printing Codes
local function PrintingCodes(bank)
    if Config.Logs then FBCUtils.Logs(Lcl('FleecaTitle'), 'green', Lcl('logs_robberystarted', GetPlayerName(PlayerId()), Config.Banks[bank].name)) end
    if Config.Debug then print(Lcl('debug_printingcodes')) end
    local onFinish = function()
        if Config.Cooldown.Type == "global" then FBCUtils.UpdateScoreboard(true) end
        FBCUtils.Notif(1, Lcl("CodesPrinted"), Lcl('FleecaTitle'))
        ActivatePrinter(bank)
    end
    FBCUtils.ProgressUI(math.random(5000, 7500), Lcl('progbar_printingcodes'), onFinish, nil, false, false)
end

-- Hacking
local function HackingHandler()
    local ped = PlayerPedId()
    local onFinish = function()
        --LoadAnimDict('anim@gangops@morgue@office@laptop@')
        TaskPlayAnim(ped, 'mp_prison_break', 'hack_loop', 2.0, 2.0, -1, 17, 1.0, 1, 1, 1)
        FBCUtils.Notif(1, Lcl("CodesFound"), Lcl('FleecaTitle'))
        Wait(1000) CRDisableControls(true)
        exports['mdn-extras']:RemoveHackUse('fleeca')
        TriggerServerEvent('cr-fleecabankrobbery:server:StartResetCooldown', closestBank)
        FBCUtils.HackingMinigame():next(function(success)
            if success then
                LocalPlayer.state:set('textui', false, true)
                LocalPlayer.state:set('inv_busy', false, true)
                FBCUtils.Notif(1, Lcl("SecurityBypass"), Lcl('FleecaTitle'))
                exports['mdn-extras']:RemoveProtocol()
                TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "computer")
                ClearPedTasks(ped)
                PrintingCodes(closestBank)
            else
                LocalPlayer.state:set('textui', false, true)
                LocalPlayer.state:set('inv_busy', false, true)
                FBCUtils.Notif(3, Lcl("SecurityBypassFailed"), Lcl('FleecaTitle'))
                ClearPedTasks(ped)
                TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "computer", closestBank, false)
            end
        end)
    end
    local onCancel = function()
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "computer", closestBank, false)
        LocalPlayer.state['textui'] = false
        ClearPedTasks(ped)
    end
    FBCUtils.ProgressUI(math.random(5000, 7500), Lcl('progbar_lookingforcodes'), onFinish, onCancel, true, true, "mp_prison_break", 'hack_loop', 17)
end

-- Computer Hack Handle
RegisterNetEvent('cr-fleecabankrobbery:client:FleecaBankUSBUsage', function(data)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local Computer = Config.Banks[closestBank].ComputerCoords
    local dist = #(coords - Computer.coords)
    if LocalPlayer.state.inv_busy or dist > 2 or not GlobalState.CRFleecaBank.Banks[closestBank].TellerUnlocked or Computer.isHacked then return end
    if GlobalState.CRFleecaBank.GlobalCD or GlobalState.CRFleecaBank.Banks[closestBank].onCooldown then FBCUtils.Notif(3, Lcl("CooldownMessage"), Lcl('FleecaTitle')) return end
    --FBCUtils.HasItem(Config.Items.ComputerHackItem.item):next(function(hasItem)
    --    if not hasItem then FBCUtils.Notif(3, Lcl("MissingItem"), Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.Items.ComputerHackItem.item) return end
    --if not exports['mdn-extras']:CheckHasProgram('fleeca') then FBCUtils.Notif(3, "You don\'t have the required breaching protocol to do this", Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.Items.ComputerHackItem.item) return end
        FBCUtils.GetCurrentCops():next(function(CopAmount)
            if CopAmount < Config.Police.CopsNeeded then FBCUtils.Notif(3, Lcl("NotEnoughCops"), Lcl('FleecaTitle')) return end
            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "computer", closestBank, true)
            LocalPlayer.state:set('inv_busy', true, true) DisableControls()
            if Config.Framework.MLO == "K4MB1" then
                local keyboard = GetClosestObjectOfType(Computer.coords, 0.2, -954257764, 0 , 0, 0)
                local offsetCoords = GetOffsetFromEntityInWorldCoords(keyboard, 0, -0.7, -1.0)
                SetEntityCoords(ped, offsetCoords) SetEntityHeading(ped, Computer.heading)
            end
            local onFinish = function()
                --TriggerServerEvent("cr-fleecabankrobbery:server:FleecaBankUSBRemoval")
                FBCUtils.CallCops(Config.Banks[closestBank].loc)
                HackingHandler()
                FBCUtils.Notif(1, Lcl("USBInserted"), Lcl('FleecaTitle'))
            end
            local onCancel = function()
                TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "computer", closestBank, false)
                LocalPlayer.state:set('textui', false, true) ClearPedTasks(ped)
            end
            FBCUtils.ProgressUI(4000, Lcl('progbar_insertingusb'), onFinish, onCancel, true, true, "anim@gangops@morgue@office@laptop@", "enter", 17)
        end)
    --end)
end)

--~===============~--
--~ Prevault Door ~--
--~===============~--

-- Prevault Door
RegisterNetEvent('cr-fleecabankrobbery:client:UnlockPreVault', function()
    LocalPlayer.state:set('textui', false, true)
    LocalPlayer.state:set('inv_busy', true, true)
    if Config.Framework.Framework == "ESX" then
        FBCUtils.HasItem(Config.Items.PrintedDocument.item):next(function(hasItem)
            if not (hasItem and HasCodes) then FBSUtils.Notify(3, Lcl('DontKnowCode'), Lcl('FleecaTitle')) return end
            HasCodes = false
            TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "prevault")
            TriggerServerEvent('cr-fleecabankrobbery:server:RemItem', Config.Items.PrintedDocument.item, 1)
            FBCUtils.UnlockDoor(Config.PreVaultDoors[closestBank])
            LocalPlayer.state:set('inv_busy', false, true)
        end)
    else
        LocalPlayer.state:set('nui', true, true)
        DisableControls()
        SendNUIMessage({action = "openKeypad"})
        SetNuiFocus(true, true)
    end
end)

--~=======~--
--~ Safe  ~--
--~=======~--

-- Gabz Deposit Box Looting
local function LootDepo(coords, saw, bag)
    local ped = PlayerPedId()
    local dic = "anim@heists@fleeca_bank@drilling"
    LoadAnimDict(dic)
    local scene3 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, dic, 'outro', 4.0, 4.0, 5000, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, dic, 'bag_outro', 1.0, 1.0, 1148846080)
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "StopSound")
    Wait(1000)
    NetworkStartSynchronisedScene(scene3)
    Wait(1200)
    DeleteObject(saw)
    Wait(2600)
    NetworkStopSynchronisedScene(scene3)
    DeleteObject(bag)
    TriggerServerEvent("cr-fleecabankrobbery:server:GetSafeLoot", closestBank)
    TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "safe")
    LocalPlayer.state:set('inv_busy', false, true)
end

-- Gabz Deposit Box Break Saw
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
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "StopSound")
    NetworkStartSynchronisedScene(scene4)
    Wait(1200) ClearPedTasks(ped)
    DeleteObject(saw) DeleteObject(bag)
    if not reason then
        FBCUtils.Notif(3, Lcl('SawBladeBroke'), Lcl('FleecaTitle'))
        TriggerServerEvent("cr-fleecabankrobbery:server:RemItem", Config.Items.PowerSaw.item, 1)
        TriggerServerEvent("cr-fleecabankrobbery:server:RecItem", Config.Items.BrokePowerSaw.item, 1)
    end
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "safe", closestBank, false)
    LocalPlayer.state:set('inv_busy', false, true)
end

-- Gabz Deposit Box Minigame
local function SawDepoBox(coords, saw, bag)
    CreateThread(function()
        local breaking, progress, heating, cooling, heat = 0, 0, 0, 0, 0
        local StopReason
        while true do
            local pba = ""
            local pbb = ""
            local progressbar = "|"
            local hba = ""
            local hbb = ""
            local heatbar = ""
            Wait(1)
            if IsControlPressed(0, 47) then StopReason = "stop" BreakSaw(coords, saw, bag, StopReason) break end
            if IsControlPressed(0, 22) then -- mouse click 24
                cooling = 0
                breaking = breaking + (math.random(2) * Config.SawMiningame.ProgressSpeedMultiplier)
                heating = heating + (math.random(heat+math.random(3)) * Config.SawMiningame.BladeHeatMultiplier)
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
            local textpos = Config.SawMiningame.UIPosition
            ShowText(text, 4, {255, 255, 255}, textpos.Text.scale, textpos.Text.x, textpos.Text.y)
            ShowText(commands, 4, {255, 255, 255}, textpos.Commands.scale, textpos.Commands.x, textpos.Commands.y)
        end
    end)
end

-- Gabz Deposit Boxes Anim
local function SawSafe()
    FBCUtils.HasItem(Config.Items.PowerSaw.item):next(function(hasItem)
        if not hasItem then FBCUtils.Notif(3, Lcl("MissingItem"), Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.Items.PowerSaw.item) return end
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "RequestSound")
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "safe", closestBank, true)
        LocalPlayer.state:set('inv_busy', true, true)
        local ped = PlayerPedId()
        TaskTurnPedToFaceCoord(ped, Config.Banks[closestBank].Safe.coords, 1000) Wait(1000)
        --if Config.Debug then print(Lcl("debug_startharvesting")) end
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0.25)
        local sawhash = 2115125482
        local bagModel = 'hei_p_m_bag_var22_arm_s'
        local dic = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
        LoadModel(sawhash)
        LoadModel(GetHashKey(bagModel))
        LoadAnimDict(dic)
        local bag = CreateObject(GetHashKey(bagModel), coords, 1, 0, 0)

        local scene1 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, 1, 0, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene1, dic, 'intro', 4.0, 4.0, 0, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene1, dic, 'bag_intro', 1.0, 1.0, 1148846080)

        local scene2 = NetworkCreateSynchronisedScene(coords, GetEntityRotation(ped), 2, false, true, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene2, dic, 'drill_straight_start', 4.0, 8.0, 5000, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(bag, scene2, dic, 'bag_drill_straight_start', 1.0, 1.0, 1148846080)

        NetworkStartSynchronisedScene(scene1)
        Wait(2800)
        local saw = CreateObject(sawhash, coords, 1, false, false)
        SetEntityCollision(saw, true, true)
        AttachEntityToEntity(saw, ped, GetPedBoneIndex(ped, 64016), 0.1, -0.05, -0.02, -0.0, -35.0, 165.0, false, false, false, false, 2, true)--right bone:28422)
        Wait(1800)
        NetworkStartSynchronisedScene(scene2)
        --PlayerBusy()
        local sawID = NetworkGetNetworkIdFromEntity(saw)
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "SawSound", sawID)
        --local FxCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0 , 0.05)
        Wait(500)
        --TriggerServerEvent('cr-salvage:server:SawPfx', FxCoords)
        SawDepoBox(coords, saw, bag)
    end)
end

-- K4MB1 Safe onFail
local function SafeCrackFail(scene)
    Wait(1)
    NetworkStartSynchronisedScene(scene)
    FBCUtils.Notif(3, Lcl("SafeCrackFailed"), Lcl('FleecaTitle'))
    LocalPlayer.state['textui'] = false
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "safe", closestBank, false)
end

-- K4MB1 Safe onSuccess
local function OpenSafe(bank)
    local SafeDoor = GetClosestObjectOfType(Config.Banks[bank].Safe.coords.x, Config.Banks[bank].Safe.coords.y, Config.Banks[bank].Safe.coords.z, 20.0, -1992154984 , false, false, false)
    local entHeading = Config.Banks[bank].Safe.DoorHeading
    if SafeDoor ~= 0 then
        CreateThread(function()
            while true do
                -- if bank ~= 5 then
                if entHeading < (Config.Banks[bank].Safe.DoorHeading + 100) then
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

-- K4MB1 Safe Looting
RegisterNetEvent('cr-fleecabankrobbery:client:FleecaBankLootSafe', function()
    if Config.Banks[closestBank].Safe.IsLooted or LocalPlayer.state.inv_busy then return end
    LocalPlayer.state:set('inv_busy', true, true) DisableControls()
    local onFinish = function()
        if GlobalState.CRFleecaBank.Banks[closestBank].HasCard then
            local card = GetClosestObjectOfType(Config.Banks[closestBank].Safe.coords, 2.0, GetHashKey('k4mb1_genbank_card'), 0, 0, 0)
            local coords = Config.Banks[closestBank].Safe.coords
            SetEntityCoords(card, coords.x, coords.y, coords.z-3, 0 , 0 ,0)
        end
        TriggerServerEvent("cr-fleecabankrobbery:server:GetSafeLoot", closestBank)
        TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "lootsafe")
        LocalPlayer.state:set('inv_busy', false, true)
    end
    FBCUtils.ProgressUI(1500, Lcl('progbar_grabbing'), onFinish, nil, false, true, "pickup_object", "putdown_low", 16)
end)

-- Safe Handle + K4MB1 Safe Anim
RegisterNetEvent('cr-fleecabankrobbery:client:AttemptSafe', function()
    if not Config.DevMode and not GlobalState.CRFleecaBank.Banks[closestBank].SecurityDisabled then FBCUtils.Notif(3, Lcl('SecurityNeedsDisabling'), Lcl('FleecaTitle')) return end
    local CurrentSafe = Config.Banks[closestBank].Safe
    if LocalPlayer.state.inv_busy then return end
    if CurrentSafe.Busy then return end
    if Config.Framework.MLO == "Gabz" then SawSafe() return end
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "RequestSound")
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "safe", closestBank, true)
    local ped = PlayerPedId()
    local Dict = "mini@safe_cracking"
    local AnimStart, AnimEnd, AnimFail, SafeAnim = "step_into",  "step_out", "dial_turn_fail_4", "safe_closed_safe"
    local Anim1, Anim2, Anim3 = "dial_turn_clock_fast_3", "dial_turn_anti_fast_2", "dial_turn_clock_normal"
    local TickAnim, TickAnim2, TickAnim3 = "dial_turn_succeed_4", "dial_turn_succeed_3", "dial_turn_succeed_2"
    LoadAnimDict(Dict)
    local Safe = GetClosestObjectOfType(CurrentSafe.coords, 5.0, GetHashKey("ch_prop_ch_arcade_safe_door"), false, false, false)
    local offset = GetOffsetFromEntityInWorldCoords(Safe, -0.85, 0.0, -0.75)
    local heading = vector3(0,0,CurrentSafe.heading+270)

    local Enter = NetworkCreateSynchronisedScene(offset, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, Enter, Dict, AnimStart, 3.0, 2.0, 1033, 51, 0.0, false, false, false)
    NetworkAddEntityToSynchronisedScene(Safe, Enter, Dict, SafeAnim, 3.0, 2.0, 1033, 51, 0.0, false, false, false)

    local Outro = NetworkCreateSynchronisedScene(offset, heading, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, Outro, Dict, AnimEnd, 3.0, 2.0, 1033, 51, 0.0, false, false, false)

    local CrackFail = NetworkCreateSynchronisedScene(offset, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, CrackFail, Dict, AnimFail, 0.0, 2.0, 1033, 51, 0.0, false, false, false)

    local TurnSafe = NetworkCreateSynchronisedScene(offset, heading, 2, false, true, 1065353216, -1, 1.3)
    NetworkAddPedToSynchronisedScene(ped, TurnSafe, Dict, Anim1, 0.0, 5.0, 1033, 51, 0.0, 0)
    local TurnSafe2 = NetworkCreateSynchronisedScene(offset, heading, 2, false, true, 1065353216, -1, 1.3)
    NetworkAddPedToSynchronisedScene(ped, TurnSafe2, Dict, Anim2, 0.0, 5.0, 1033, 51, 0.0, 0)
    local TurnSafe3 = NetworkCreateSynchronisedScene(offset, heading, 2, false, true, 1065353216, -1, 1.3)
    NetworkAddPedToSynchronisedScene(ped, TurnSafe3, Dict, Anim3, 0.0, 5.0, 1033, 51, 0.0, 0)

    local SafeTick = NetworkCreateSynchronisedScene(offset, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, SafeTick, Dict, TickAnim, 0.0, 2.0, 51, 51, 0.0, false, false, false)
    local SafeTick2 = NetworkCreateSynchronisedScene(offset, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, SafeTick2, Dict, TickAnim2, 0.0, 2.0, 51, 51, 0.0, false, false, false)
    local SafeTick3 = NetworkCreateSynchronisedScene(offset, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, SafeTick3, Dict, TickAnim3, 0.0, 2.0, 51, 51, 0.0, false, false, false)

    NetworkStartSynchronisedScene(Enter)
    Wait(900)
    local SafeTicked = 0
    --local SafeTicked = 3  -- FOR TESTING PURPOSES
    TickEnded = true
    while SafeTicked < 3 do
        if TickEnded then
            TickEnded = false
            if SafeTicked == 0 then NetworkStartSynchronisedScene(TurnSafe)
            elseif SafeTicked == 1 then NetworkStartSynchronisedScene(TurnSafe2)
            elseif SafeTicked == 2 then NetworkStartSynchronisedScene(TurnSafe3) end
            FBCUtils.Circle('Safecracking'):next(function(success)
                if success then
                    if Config.Difficulties.Safecracking.AddSkillbar then
                        FBCUtils.Skillbar():next(function(Success)
                            if Success then
                                if SafeTicked == 0 then NetworkStartSynchronisedScene(SafeTick)
                                elseif SafeTicked == 1 then NetworkStartSynchronisedScene(SafeTick2)
                                elseif SafeTicked == 2 then NetworkStartSynchronisedScene(SafeTick3) end
                                FBCUtils.Notif(1, Lcl("SafeTick"), Lcl("FleecaTitle") )
                                Wait(1000)
                                SafeTicked = SafeTicked + 1
                                TickEnded = true
                            else
                                SafeTicked = 5
                                SafeCrackFail(Outro)
                            end
                        end)
                    else
                        if SafeTicked == 0 then NetworkStartSynchronisedScene(SafeTick)
                        elseif SafeTicked == 1 then NetworkStartSynchronisedScene(SafeTick2)
                        elseif SafeTicked == 2 then NetworkStartSynchronisedScene(SafeTick3) end
                        FBCUtils.Notif(1, Lcl("SafeTick"), Lcl("FleecaTitle") )
                        Wait(1000)
                        SafeTicked = SafeTicked + 1
                        TickEnded = true
                    end
                else
                    SafeTicked = 5
                    SafeCrackFail(Outro)
                end
            end)
        else Wait(200) end
    end
    Wait(500)
    if SafeTicked == 3 then
        if not GlobalState.CRFleecaBank.Banks[closestBank].HasCard then
            print("removing card from safe")
            local card = GetClosestObjectOfType(Config.Banks[closestBank].Safe.coords, 2.0, GetHashKey('k4mb1_genbank_card'), 0, 0, 0)
            local coords = Config.Banks[closestBank].Safe.coords
            SetEntityCoords(card, coords.x, coords.y, coords.z-3, 0 , 0 ,0)
        end
        NetworkStartSynchronisedScene(Outro)
        Wait(500)
        TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "safe")
        TriggerServerEvent("cr-fleecabankrobbery:server:GenSyncs", "safecrack", closestBank)
        LocalPlayer.state['textui'] = false
        ActivateSafeLoot(closestBank)
    end
end)

--~=============~--
--~ Vault Door  ~--
--~=============~--

-- Swipe Success
local function VaultDoorTimer()
    FBCUtils.CallCops(Config.Banks[closestBank].loc)
    TriggerServerEvent('cr-fleecabankrobbery:server:FleecaBankCardRemoval')
    TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "card")
    local Timer = Config.Difficulties.VaultDoor.DoorTimer
    if Config.DevMode then Timer = 0.2 end
    FBCUtils.Notif(1, Lcl("OpenningVaultDoor", tonumber(Timer)) , Lcl('FleecaTitle'))
    Wait((Timer * 60000)/2)
    FBCUtils.Notif(2, Lcl('VaultHalfTime', tonumber((Timer/2))), Lcl('FleecaTitle'))
    Wait((Timer * 60000)/2)
    SetupBank(closestBank)
    FBCUtils.Notif(1, Lcl("VaultDoorOpenned"), Lcl('FleecaTitle'))
    TriggerServerEvent('cr-fleecabankrobbery:server:VaultCodesRight', closestBank)
end

-- Vault Door Opening
RegisterNetEvent("cr-fleecabankrobbery:client:VaultCodesRight", function(bank)
    local Door = Config.Banks[bank].VaultDoor
    local hash = 839234948
    if Config.Framework.MLO == "Gabz" then hash = 2121050683 end
    local object = GetClosestObjectOfType(Door.coords.x, Door.coords.y, Door.coords.z, 20.0, hash, false, false, false)

    local entHeading = Door.ClosedHeading
    if object ~= 0 then
        CreateThread(function()
            while true do
                if entHeading > Door.ClosedHeading - 100 then
                    SetEntityHeading(object, entHeading - 0.5)
                    entHeading = entHeading - 0.1
                else break end
                Wait(10)
            end
        end)
    end
end)

-- Swipe Vault Card
RegisterNetEvent("cr-fleecabankrobbery:client:VaultCard", function()
    if not Config.DevMode and not GlobalState.CRFleecaBank.Banks[closestBank].SecurityDisabled then FBCUtils.Notif(3, Lcl('SecurityNeedsDisabling'), Lcl('FleecaTitle')) return end
    local ped, CurrentReader = PlayerPedId(), Config.Banks[closestBank].CardSwipe
    if CurrentReader.Swiped then return end
    local pcoords = GetEntityCoords(ped)
    if #(pcoords - CurrentReader.coords) > 1 or CurrentReader.Swiped then return end
    FBCUtils.HasItem(Config.Items.VaultCardItem.item):next(function(hasItem)
        if not hasItem then FBCUtils.Notif(3, Lcl("MissingItem"), Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.Items.VaultCardItem.item) return end
        TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "swipe", closestBank, true)
        if Config.Framework.MLO == "K4MB1" then
            local reader = GetClosestObjectOfType(CurrentReader.coords, 0.3, 687605575, 0, 0, 0)
            local offset = GetOffsetFromEntityInWorldCoords(reader, -0.1, -0.5, -1.5)
            SetEntityCoords(ped, offset) SetEntityHeading(ped, CurrentReader.heading)
        else
            TaskTurnPedToFaceCoord(ped, Config.Banks[closestBank].CardSwipe.coords, 2000)
            Wait(2000)
        end
        local onCancel = function()
            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "swipe", closestBank, false)
            ClearPedTasks(ped)
        end
        local secondFinish = function()
            Wait(1500)
            if Config.Difficulties.VaultDoor.CodesNeeded then
                AttemptingVault = true
                FBCUtils.Notif(2, Lcl("HumanInputRequired"), Lcl('FleecaTitle'))
                Wait(750)
                if Config.Framework.Framework == "ESX" and not GlobalState.CRFleecaBank[closestBank].HasCodes then AttemptingVault = false FBSUtils.Notify(3, Lcl('DontKnowCode'), Lcl('FleecaTitle')) return end
                LocalPlayer.state:set('nui', true, true)
                LocalPlayer.state:set('inv_busy', true, true)
                SendNUIMessage({ action = "openKeypad"})
                SetNuiFocus(true, true)
            else
                VaultDoorTimer()
            end
        end
        local onFinish = function()
            FBCUtils.Notif(2, Lcl("ReadingCard"), Lcl('FleecaTitle'))
            FBCUtils.ProgressUI(2000, Lcl('progbar_readingdetails'), secondFinish, onCancel, true, true)
        end
        FBCUtils.ProgressUI(math.random(3000, 5000), Lcl('progbar_swipingcard'), onFinish, onCancel, false, true, "mp_common_miss", 'card_swipe', 16)
    end)
end)


--~=======~--
--~ Vault ~--
--~=======~--

-- K4Mb1 Table Handle
RegisterNetEvent('cr-fleecabankrobbery:client:GrabTableLoot', function(data)
    local ped = PlayerPedId()
    local pedCo = GetEntityCoords(ped)
    local CurrentTable = Config.Banks[closestBank].Table
    if LocalPlayer.state.inv_busy or CurrentTable.grabbed then return end
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "table", closestBank)
    TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "table", data.loot)
    LocalPlayer.state:set('inv_busy', true, true)
    DisableControls()
    --SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    local animDict = 'anim@scripted@heist@ig1_table_grab@cash@male@'
    local stackModel = CurrentTable.model
    if stackModel == -180074230 then animDict = 'anim@scripted@heist@ig1_table_grab@gold@male@' end
    LoadAnimDict(animDict) LoadModel('hei_p_m_bag_var22_arm_s')
    local heading = vector3(0.0, 0.0, CurrentTable.heading)
    local bag = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), pedCo, 1, 1, 0)
    local TableLoot = GetClosestObjectOfType(CurrentTable.coords, 1.5, stackModel, false, false, false)

    local scene1 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'enter', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, animDict,'enter_bag', 1.0, -1.0, 1148846080)

    local scene2 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'grab', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'grab_bag', 1.0, -1.0, 1148846080)
    if stackModel == -180074230 then NetworkAddEntityToSynchronisedScene(TableLoot, scene2, animDict, 'grab_gold', 1.0, -1.0, 1148846080)
    else NetworkAddEntityToSynchronisedScene(TableLoot, scene2, animDict, 'grab_cash', 1.0, -1.0, 1148846080) end

    local scene3 = NetworkCreateSynchronisedScene(CurrentTable.coords, heading, 2, true, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'exit_bag', 1.0, -1.0, 1148846080)

    NetworkStartSynchronisedScene(scene1)
    Wait(GetAnimDuration(animDict, 'enter') * 1000) NetworkStartSynchronisedScene(scene2)
    Wait(GetAnimDuration(animDict, 'grab') * 1000 - 3000) DeleteObject(TableLoot) NetworkStartSynchronisedScene(scene3)
    Wait(GetAnimDuration(animDict, 'exit') * 1000) ClearPedTasks(ped) DeleteObject(bag)
    --SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    LocalPlayer.state:set('inv_busy', false, true)
    TriggerServerEvent('cr-fleecabankrobbery:server:TableLoot', stackModel)
end)

-- Tray Handle
RegisterNetEvent('cr-fleecabankrobbery:client:GrabTrayLoot', function(data)
    if LocalPlayer.state.inv_busy then return end
    for k,v in pairs(Config.Banks[closestBank].Trays) do
        if k == data.loc then
            if v.grabbed then return end
            LocalPlayer.state:set('inv_busy', true, true)
            DisableControls()
            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "tray", closestBank, data.loc)
            TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "tray", data.tray)
            local ped = PlayerPedId()
            local pedCo = GetEntityCoords(ped)
            local TrayHash = v.model
            local TrayLoot
            if TrayHash == 881130828 then TrayLoot = 'ch_prop_vault_dimaondbox_01a'
            elseif TrayHash == 2007413986 then TrayLoot = 'ch_prop_gold_bar_01a'
            else TrayLoot = 'hei_prop_heist_cash_pile' end
            local animDict = 'anim@heists@ornate_bank@grab_cash'
            LoadAnimDict(animDict) LoadModel(3350498815)

            local Tray = GetClosestObjectOfType(v.coords, 1.5, TrayHash, 0, 0, 0)
            local bag = CreateObject(3350498815, pedCo, true, false, false)
            local coords, rot = GetEntityCoords(Tray), GetEntityRotation(Tray)
            local scene1 = NetworkCreateSynchronisedScene(coords, rot, 2, true, false, 1, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'intro', 1.5, 1, 1, 16, 1111111111, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene1, animDict, 'bag_intro', 4.0, -8.0, 1)

            local scene2 =  NetworkCreateSynchronisedScene(coords, rot, 2, true, false, 1, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'grab', 1.5, 1, 1, 16, 1111111111, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'bag_grab', 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(Tray, scene2, animDict, 'cart_cash_dissapear', 4.0, -8.0, 1)

            local scene3 =  NetworkCreateSynchronisedScene(coords, rot, 2, true, false, 1, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', 1.5, 1, 1, 16, 1111111111, 0)
            NetworkAddEntityToSynchronisedScene(bag, scene3, animDict, 'bag_exit', 4.0, -8.0, 1)

            --SetPedComponentVariation(ped, 5, Config.EmptyBackID, 1, 1)
            NetworkStartSynchronisedScene(scene1)
            Wait(1750) CashInHand(TrayLoot) NetworkStartSynchronisedScene(scene2)
            Wait(37000) NetworkStartSynchronisedScene(scene3) Wait(2000)

            local newTrolly = CreateObject(769923921, v.coords, true, false, false)
            SetEntityHeading(newTrolly, v.heading) DeleteObject(Tray) DeleteObject(bag)

            --SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
            TriggerServerEvent('cr-fleecabankrobbery:server:TrayLoot', TrayHash, data.loc)
            LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
        end
    end
end)

-- Finishing Drilling
local function FinishedDrill(data, amount, reason)
    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "StopSound")
    if reason == "broke" then
        TriggerServerEvent('cr-fleecabankrobbery:server:RemItem', Config.Items.DrillingItem.item, 1)
        FBCUtils.Notif(3, Lcl("DrillBroke"), Lcl("FleecaTitle"))
    end
    if amount >= Config.Banks[closestBank].DepositBoxes[data.k].BoxAmount then
        TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "depobox", data.k)
    else
        local newAmount = Config.Banks[closestBank].DepositBoxes[data.k].BoxAmount - amount
        TriggerServerEvent('cr-fleecabankrobbery:server:VaultSync', "DepoBoxSpawn", closestBank, data.k, newAmount)
        TriggerServerEvent("cr-fleecabankrobbery:server:GenSyncs", "DepositBox", closestBank, false, data.k)
    end
    local ped = PlayerPedId()
    Wait(2000)
    --SetPedComponentVariation(ped, 5, Config.HideBagID, 1, 1)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(data.cam, false)
    if Config.Framework.MLO == "Gabz" then
        local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
        local scene3 = NetworkCreateSynchronisedScene(data.scene.boxPos, data.scene.boxRot, 2, true, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene3, animDict, 'exit', -1 , -1.0, 5000, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(data.bag, scene3, animDict, 'bag_exit', -1.0, -1.0, 1148846080)
        NetworkStartSynchronisedScene(scene3)
        AttachEntityToEntity(data.laserDrill, ped, GetPedBoneIndex(ped, 64016), 0.05, -0.05, 0.02, 10.0, 10.0, 60.0, false, false, false, false, 2, true)--right bone:28422
        Wait(1250)
    end
    DeleteObject(data.laserDrill)
    DeleteObject(data.bag)
    Wait(800)
    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)
    CRDisableControls(true)
end

-- Custom Drilling Minigame
local function BreakDepoBox(data)
    CreateThread(function()
        local progress = 0
        local heating = 0
        local cooling = 0
        local heat = 0
        local heat2 = 0
        local loot = 0
        local maxloot = Config.Banks[closestBank].DepositBoxes[data.k].BoxAmount
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
                TriggerServerEvent('cr-fleecabankrobbery:server:DepoLoot', closestBank, data.k)
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
            if heat == 10 then StopReason = "broke" if Config.Difficulties.DrillingMinigame.DrillCanBreak then TriggerServerEvent('cr-fleecabankrobbery:server:RemItem', Config.Items.DrillingItem.item, 1) FBCUtils.Notif(3, Lcl("DrillBroke"), Lcl("FleecaTitle")) end break end
            local textpos = Config.Difficulties.DrillingMinigame.UIPosition.Text
            local commandpos = Config.Difficulties.DrillingMinigame.UIPosition.Commands
            ShowText(text, 4, {255, 255, 255}, textpos.scale, textpos.x, textpos.y)
            ShowText(commands, 4, {255, 255, 255}, commandpos.scale, commandpos.x, commandpos.y)
        end
        FinishedDrill(data, loot, StopReason)
    end)
end

-- Drilling Handle
RegisterNetEvent('cr-fleecabankrobbery:client:DrillBoxes', function(data)
    local ped = PlayerPedId()
    if not data then data = {} end
    local pcoords = GetEntityCoords(ped)
    if LocalPlayer.state.inv_busy then return end
    for k,v in pairs(Config.Banks[closestBank].DepositBoxes) do
        if k == data.box or #(pcoords - v.coords) < 0.7 then
            if v.Busy then return end
            FBCUtils.HasItem(Config.Items.DrillingItem.item):next(function(hasItem)
                if not hasItem then FBCUtils.Notif(3, Lcl("MissingItem"), Lcl('FleecaTitle')) FBCUtils.MissingItem(Config.Items.DrillingItem.item) return end
                Config.Banks[closestBank].DepositBoxes[k].Busy = true
                LocalPlayer.state:set('inv_busy', true, true) DisableControls()
                TriggerServerEvent("cr-fleecabankrobbery:server:GenSyncs", "DepositBox", closestBank, true, k)
                TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "RequestSound")
                local laserDrill, bag, cam
                local sentScene = {}
                if Config.Framework.MLO == "K4MB1" then
                    local coords = GetEntityCoords(ped)
                    local animDict = 'anim_heist@hs3f@ig10_lockbox_drill@pattern_0'..tostring(v.type)..'@lockbox_01@male@'
                    local bagModel, laserDrillModel = 'hei_p_m_bag_var22_arm_s', 'ch_prop_vault_drill_01a'
                    LoadAnimDict(animDict) LoadModel(bagModel) LoadModel(laserDrillModel)

                    cam = CreateCam('DEFAULT_ANIMATED_CAMERA', true)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, 0, 3000, 1, 0)

                    bag = CreateObject(GetHashKey(bagModel), coords, 1, 0, 0)
                    laserDrill = CreateObject(GetHashKey(laserDrillModel), coords, 1, 0, 0)
                    local WallHash, Wall
                    if v.type == 1 then WallHash = -1131403196 Wall = 'abc'
                    elseif v.type == 2 then WallHash = -566137930 Wall = 'ghi'
                    elseif v.type == 3 then WallHash = 1695283513 Wall = 'def' end

                    local BoxCoords = Config.Banks[closestBank].DepositBoxes[k].coords
                    local SecureBox = GetClosestObjectOfType(BoxCoords.x, BoxCoords.y, BoxCoords.z, 20.0, WallHash, false, false, false)
                    local boxPos = GetEntityCoords(SecureBox)
                    local boxRot = GetEntityRotation(SecureBox)
                    sentScene.boxPos = boxPos sentScene.boxRot = boxRot

                    local scene1 = NetworkCreateSynchronisedScene(boxPos, boxRot, 2, true, false, 1342177280, 0, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, scene1, animDict, 'enter', 4.0, -4.0, 1033, 0, 1000.0, 0)
                    NetworkAddEntityToSynchronisedScene(bag, scene1, animDict, 'enter_p_m_bag_var22_arm_s', 1.0, -1.0, 0)
                    NetworkAddEntityToSynchronisedScene(laserDrill, scene1, animDict, 'enter_ch_prop_vault_drill_01a', 1.0, -1.0, 0)--1148846080
                    NetworkAddEntityToSynchronisedScene(SecureBox, scene1, animDict, 'enter_ch_prop_ch_sec_cabinet_01'..Wall, 1.0, -1.0, 0)

                    local scene2 = NetworkCreateSynchronisedScene(boxPos, boxRot, 2, false, true, 1342177280, -1, 1.3)
                    NetworkAddPedToSynchronisedScene(ped, scene2, animDict, 'action', 4.0, -4.0, 0, -1, 8.0, 0)
                    NetworkAddEntityToSynchronisedScene(bag, scene2, animDict, 'action_p_m_bag_var22_arm_s', 1.0, -1.0, 1342177280)
                    NetworkAddEntityToSynchronisedScene(laserDrill, scene2, animDict, 'action_ch_prop_vault_drill_01a', 1.0, -1.0, 1342177280)
                    NetworkAddEntityToSynchronisedScene(SecureBox, scene2, animDict, 'action_ch_prop_ch_sec_cabinet_01'..Wall, 1.0, -1.0, 1342177280)

                    NetworkStartSynchronisedScene(scene1)
                    PlayCamAnim(cam, 'enter_cam', animDict, boxPos, boxRot, 0, 2)
                    Wait(3700)
                    NetworkStartSynchronisedScene(scene2)
                    PlayCamAnim(cam, 'action_cam', animDict, boxPos, boxRot, 0, 2)
                    local sawID = NetworkGetNetworkIdFromEntity(laserDrill)
                    TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "SawSound", sawID)
                elseif Config.Framework.MLO == "Gabz" then
                    local coords = GetEntityCoords(ped)
                    local animDict = 'anim_heist@hs3f@ig9_vault_drill@laser_drill@'
                    local bagModel = 'hei_p_m_bag_var22_arm_s'
                    local laserDrillModel = 'hei_prop_heist_drill'
                    local boxPos = Config.Banks[closestBank].DepositBoxes[data.box].coords
                    local boxRot = vector3(0,0,Config.Banks[closestBank].DepositBoxes[data.box].heading-90)
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
                    Wait(6000) TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "SawSound", sawID)
                    NetworkStartSynchronisedScene(scene2)
                end
                if Config.Difficulties.DrillingMinigame.Type == "fivem-drilling" then
                    TriggerEvent('Drilling:Start',function(success)
                        if success then
                            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "StopSound")
                            Wait(1000)
                            RenderScriptCams(false, false, 0, 1, 0)
                            DestroyCam(cam, false)
                            ClearPedTasks(ped)
                            DeleteObject(bag)
                            DeleteObject(laserDrill)
                            LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
                            CRDisableControls(false)
                            Wait(1000)
                            TriggerServerEvent('cr-fleecabankrobbery:server:DepoLoot', closestBank, k)
                            TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "depobox", k)
                        else
                            TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "StopSound")
                            if Config.Difficulties.DrillingMinigame.DrillCanBreak then
                                local breakChance = math.random(100)
                                if breakChance <= Config.Difficulties.DrillingMinigame.DrillBreakChance then
                                    FBCUtils.Notif(3, Lcl("DrillBroke"), Lcl('FleecaTitle'))
                                    TriggerServerEvent('cr-fleecabankrobbery:server:RemItem', Config.Items.DrillingItem.item, 1)
                                    FBCUtils.Notif(3, Lcl("DrillBroke"), Lcl("FleecaTitle"))
                                end
                            end
                            Wait(2000)
                            RenderScriptCams(false, false, 0, 1, 0)
                            DestroyCam(cam, false)
                            ClearPedTasks(ped)
                            DeleteObject(bag)
                            DeleteObject(laserDrill)
                            TriggerServerEvent("cr-fleecabankrobbery:server:GenSyncs", "DepositBox", closestBank, false, k)
                            LocalPlayer.state:set('inv_busy', false, true) -- Not Busy
                            CRDisableControls(false)
                        end
                    end)
                elseif Config.Difficulties.DrillingMinigame.Type == "custom" then
                    BreakDepoBox({cam = cam, bag = bag, laserDrill = laserDrill, k = k, scene = sentScene})
                end
            end)
        end
    end
end)

--~=============~--
--~ Banks Reset ~--
--~=============~--

RegisterNetEvent('cr-fleecabankrobbery:client:ResetBank', function(bank)
    if Config.Debug then
        print(Lcl('debug_resetbanks'))
    end
    SetupCRFleecaBanks(bank)
    Config.Banks[bank].TellerDoors.Occupied = false
    Config.Banks[bank].ComputerCoords.isHacked = false
    Config.Banks[bank].Safe.IsLooted = false
    Config.Banks[bank].Safe.Busy = false
    Config.Banks[bank].Table.grabbed = false
    local pile = GetClosestObjectOfType(Config.Banks[bank].Table.coords, 1.0, GetHashKey('h4_prop_h4_cash_stack_01a'), 1, 0, 0)
    if pile == 0 then pile = GetClosestObjectOfType(Config.Banks[bank].Table.coords, 1.0, GetHashKey('h4_prop_h4_gold_stack_01a'), 1, 0, 0) end
    if pile ~= 0 then DeleteObject(pile) end
    for _, va in pairs(Config.Banks[bank].Trays) do
        local obj = GetClosestObjectOfType(va.coords, 1.0, 269934519, 1, 0, 0)
        if obj == 0 then obj = GetClosestObjectOfType(va.coords, 1.0, 2007413986, 1, 0, 0) end
        if obj == 0 then obj = GetClosestObjectOfType(va.coords, 1.0, 769923921, 1, 0, 0) end
        if obj ~= 0 then DeleteObject(obj) end
        va.isSpawned = false
        va.grabbed = false
    end
    for _, vb in pairs(Config.Banks[bank].DepositBoxes) do
        vb.Busy = false
        vb.BoxAmount = 0
        vb.LootedAmount = 0
    end
    FBCUtils.ResetDoors(bank)
end)

RegisterNetEvent('cr-fleecabankrobbery:client:ResetBanks', function()
    if Config.Debug then
        print(Lcl('debug_resetbanks'))
    end
    SetupCRFleecaBanks()
    if Config.Scoreboard then FBCUtils.UpdateScoreboard(false) end
    for k, v in pairs(Config.Banks) do
        v.TellerDoors.Occupied = false
        v.ComputerCoords.isHacked = false
        v.Safe.IsLooted = false
        v.Safe.Busy = false
        v.Table.grabbed = false
        local pile = GetClosestObjectOfType(v.Table.coords, 1.0, GetHashKey('h4_prop_h4_cash_stack_01a'), 1, 0, 0)
        if pile == 0 then pile = GetClosestObjectOfType(v.Table.coords, 1.0, GetHashKey('h4_prop_h4_gold_stack_01a'), 1, 0, 0) end
        if pile ~= 0 then DeleteObject(pile) end
        for _, va in pairs(v.Trays) do
            local obj = GetClosestObjectOfType(va.coords, 1.0, 269934519, 1, 0, 0)
            if obj == 0 then obj = GetClosestObjectOfType(va.coords, 1.0, 2007413986, 1, 0, 0) end
            if obj == 0 then obj = GetClosestObjectOfType(va.coords, 1.0, 769923921, 1, 0, 0) end
            if obj ~= 0 then DeleteObject(obj) end
            va.isSpawned = false
            va.grabbed = false
        end
        for _, vb in pairs(v.DepositBoxes) do
            vb.Busy = false
            vb.BoxAmount = 0
            vb.LootedAmount = 0
        end
        FBCUtils.ResetDoors(k)
    end
end)

--~===============~--
--~ NUI Callbacks ~--
--~===============~--

-- Try Entered Code
RegisterNUICallback('TryCombination', function(data)
    if not data.combination then return end
    local code = tonumber(data.combination)
    if code == GlobalState.CRFleecaBank.Banks[closestBank].DoorCodes then
        TriggerServerEvent('cr-fleecabankrobbery:server:DeleteZones', closestBank, "prevault")
        FBCUtils.UnlockDoor(Config.PreVaultDoors[closestBank])
        SendNUIMessage({ action = "closeKeypad", error = false})
        CloseKeyPad()
    elseif code == GlobalState.CRFleecaBank.Banks[closestBank].VaultCodes then
        SendNUIMessage({ action = "closeKeypad", error = false})
        CloseKeyPad()
        VaultDoorTimer()
    else
        CloseKeyPad()
        if AttemptingVault then TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "swipe", closestBank, false) end
    end
end)

-- Combination Failed
RegisterNUICallback("CombinationFail", function()
    CloseKeyPad()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

--Closing Keypad
RegisterNUICallback('PadLockClose', function()
    CloseKeyPad()
    if AttemptingVault then TriggerServerEvent('cr-fleecabankrobbery:server:GenSyncs', "swipe", closestBank, false) end
end)

--~===============~--
--~ Other ~--
--~===============~--

RegisterNetEvent('cr-fleecabankrobbery:client:VaultSync', function(type, bank, arg1, arg2, arg3)
    --print("type "..type.." | bank"..bank.." | arg1"..arg1 or "nil".." | arg2"..arg2 or "nil".." | arg3"..arg3 or "nil")
    if type == "Trays" then
        Wait(2000)
        local entity = NetworkGetEntityFromNetworkId(arg3)
        Config.Banks[bank].Trays[arg1].model = arg2
        ActivateTrayTargets(entity, arg1, bank)
    elseif type == "Table" then
        Wait(2000)
        local entity = NetworkGetEntityFromNetworkId(arg2)
        Config.Banks[bank].Table.model = arg1
        ActivateTableTarget(entity, bank)
    elseif type == "Walls" then
        ActivateBoxesTargets(bank)
        ActivateTrayFinder(arg1)
    elseif type == "DepoBoxSpawn" then
        Config.Banks[bank].DepositBoxes[arg1].BoxAmount = arg2
    elseif type == "DepoLootSync" then
        Config.Banks[bank].DepositBoxes[arg1].LootedAmount = Config.Banks[bank].DepositBoxes[arg1].LootedAmount + 1
    elseif type == "DepoBox" then
        Config.Banks[bank].DepositBoxes[arg1].isDrilled = not Config.Banks[bank].DepositBoxes[arg1].isDrilled
    end
end)

RegisterNetEvent('cr-fleecabankrobbery:client:GenSyncs', function(type, arg1, arg2, arg3)
    if type == "safecrack" then OpenSafe(arg1)
    elseif type == "tellerdoor" then Config.Banks[arg1].TellerDoors.Occupied = arg2
    elseif type == "computer" then Config.Banks[arg1].ComputerCoords.isHacked = arg2
    elseif type == "swipe" then Config.Banks[arg1].CardSwipe.Swiped = arg2
    elseif type == "tray" then Config.Banks[arg1].Trays[arg2].grabbed = true
    elseif type == "DepositBox" then Config.Banks[arg1].DepositBoxes[arg3].Busy = arg2
    elseif type == "safe" then Config.Banks[arg1].Safe.Busy = arg2
    elseif type == "table" then Config.Banks[arg1].Table.grabbed = true
    elseif type == "RequestSound" then
        RequestAmbientAudioBank('DLC_HEIST_FLEECA_SOUNDSET', true)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', 1)
        RequestAmbientAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', 0)
    elseif type == "StopSound" then StopSound(SoundID)
    elseif type == "SawSound" then
        local saw = NetworkGetEntityFromNetworkId(arg1)
        SoundID = GetSoundId()
        PlaySoundFromEntity(SoundID, 'Drill', saw, 'DLC_HEIST_FLEECA_SOUNDSET', 1, 0)
    end
end)

if Config.DevMode then
    RegisterCommand("resetbanks", function()
        TriggerServerEvent('cr-fleecabankrobbery:server:ResetBanks')
        TriggerEvent('cr-fleecabankrobbery:client:ResetBanks')
    end)

    RegisterCommand("setupbank", function()
        SetupBank(closestBank)
    end)
end