local QBCore = exports['qb-core']:GetCoreObject()
local currentRegister   = 0
local currentSafe = 0
local copsCalled = false
local usingAdvanced, openingReg = false, false
local lockpickDone = false

CreateThread(function()
    Wait(1000)
    if QBCore.Functions.GetPlayerData().job ~= nil and next(QBCore.Functions.GetPlayerData().job) then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

CreateThread(function()
    local loop = 0
    while true do
        Wait(1000 * 60 * 5)
        if CurrentlyRobbing then loop = loop + 1 end
        if CurrentlyRobbing and loop == 6 then CurrentlyRobbing = nil loop = 0 end
        if copsCalled then
            copsCalled = false
        end
    end
end)

CreateThread(function()
    Wait(1000)
    setupRegister()
    setupSafes()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k in pairs(Config.Registers) do
            local dist = #(pos - Config.Registers[k][1].xyz)
            if dist <= 1 and Config.Registers[k].robbed then
                inRange = true
                DrawText3Ds(Config.Registers[k][1].xyz, 'The Cash Register Is Empty')
            end
        end
        if not inRange then
            Wait(2000)
        end
        Wait(3)
    end
end)

RegisterNetEvent('qb-storerobbery:client:CrackSafe')
AddEventHandler('qb-storerobbery:client:CrackSafe', function()
    useSafeCracker()
end)

RegisterNetEvent('qb-storerobbery:client:LookatSafe')
AddEventHandler('qb-storerobbery:client:LookatSafe', function()
    AttemptSafe()
end)

RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
    usingAdvanced = isAdvanced
    for k in pairs(Config.Registers) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Registers[k][1].xyz)
        if dist <= 1 and not Config.Registers[k].robbed then
            QBCore.Functions.TriggerCallback('qb-storerobbery:server:getCops', function(CurrentCops)
                if CurrentCops >= Config.MinimumStoreRobberyPolice then
                    if CurrentlyRobbing then
                        if #(pos - CurrentlyRobbing) > 20.00 then QBCore.Functions.Notify("You cannot do this right now!", "error") return end
                    else
                        CurrentlyRobbing = pos
                    end
                    if k ~= currentRegister then copsCalled = false end
                    -- print(usingAdvanced)
                    if usingAdvanced then
                        currentRegister = k
                        if not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if not copsCalled then
                            exports['ps-dispatch']:StoreRobbery(Config.Registers[k].camId)
                            copsCalled = true
                        end
                        lockpick(true)
                    else
                        currentRegister = k
                        if not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if not copsCalled then
                            exports['ps-dispatch']:StoreRobbery(Config.Registers[k].camId)
                            copsCalled = true
                        end
                        lockpick(true)
                    end

                else
                    QBCore.Functions.Notify("Not Enough Police ("..Config.MinimumStoreRobberyPolice.." Required)", "error")
                end
            end)
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true

    if model == 'mp_m_freemode_01' then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function setupRegister()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:getRegisterStatus', function(Registers)
        for k in pairs(Registers) do
            Config.Registers[k].robbed = Registers[k].robbed
        end
    end)
end

function setupSafes()
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:getSafeStatus', function(Safes)
        for k in pairs(Safes) do
            Config.Safes[k].robbed = Safes[k].robbed
        end
    end)
end


function useSafeCracker()
    if not QBCore.Functions.HasItem("safecracker") then QBCore.Functions.Notify("You don\'t have the required tool.", "error") return end
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for safe, _ in pairs(Config.Safes) do
        local dist = #(pos - Config.Safes[safe].coords)
        if dist <= 3.0 then
            if Config.Safes[safe].robbed then QBCore.Functions.Notify("The safe has already been oppened!", "error") return end
            QBCore.Functions.TriggerCallback('qb-storerobbery:server:getCops', function(CurrentCops)
                if CurrentCops < Config.MinimumStoreRobberyPolice then QBCore.Functions.Notify("Not Enough Troopers Required)", "error") return end
                if CurrentlyRobbing then
                    if #(pos - CurrentlyRobbing) > 20.00 then QBCore.Functions.Notify("You cannot do this right now!", "error") return end
                else
                    CurrentlyRobbing = pos
                end
                currentSafe = safe
                TriggerServerEvent('qb-storerobbery:server:RemoveItem', "safecracker", 1)
                if not copsCalled then
                    exports['ps-dispatch']:StoreRobbery(Config.Safes[safe].camId)
                    copsCalled = true
                end
                if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                end
                if math.random(100) <= 50 then
                    TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                end
                TriggerEvent("Drilling:Start", function(success)
                    if success then
                        TriggerServerEvent("qb-storerobbery:server:SafeReward", currentSafe)
                        TriggerServerEvent("qb-storerobbery:server:setSafeStatus", currentSafe)
                        currentSafe = 0
                        takeAnim()
                    else
                        print("Drilling failed.")
                    end
                end)
            end)
        end
    end
end

function AttemptSafe()
    local pos = GetEntityCoords(PlayerPedId())
    for safe,_ in pairs(Config.Safes) do
        local dist = #(pos - Config.Safes[safe].coords)
        if dist < 3 then
            inRange = true
            if not Config.Safes[safe].robbed then
                QBCore.Functions.TriggerCallback('qb-storerobbery:server:getCops', function(CurrentCops)
                    if CurrentCops >= Config.MinimumStoreRobberyPolice then
                        if CurrentlyRobbing then
                            if #(pos - CurrentlyRobbing) > 20.00 then QBCore.Functions.Notify("You cannot do this right now!", "error") return end
                        else
                            CurrentlyRobbing = pos
                        end
                        currentSafe = safe
                        if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if math.random(100) <= 50 then
                            TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                        end
                        if Config.Safes[safe].type == "keypad" then
                            SendNUIMessage({
                            action = "openKeypad",
                        })
                            SetNuiFocus(true, true)
                        elseif Config.Safes[safe].type == "big" then
                            QBCore.Functions.TriggerCallback('qb-storerobbery:server:getPadlockCombination', function(combination)
                                FreezeEntityPosition(PlayerPedId(), true)
                                print(combination[1],combination[2],combination[3])
                                lib.showTextUI('[A] Anti-Clockwise | [D] Clockwise | [W] Try Number | [S] Exit', {position = 'top-center'})
                                local res = exports["pd-safe"]:createSafe(combination, true)
                                lib.hideTextUI()
                                if res then
                                    TriggerServerEvent("qb-storerobbery:server:SafeReward", safe)
                                    TriggerServerEvent("qb-storerobbery:server:setSafeStatus", safe, true)
                                    currentSafe = 0
                                    takeAnim()
                                end
                                FreezeEntityPosition(PlayerPedId(), false)
                            end, safe)
                        else
                            QBCore.Functions.TriggerCallback('qb-storerobbery:server:getPadlockCombination', function(combination)
                                TriggerEvent("SafeCracker:StartMinigame", combination)
                            end, safe)
                        end
                        if not copsCalled then
                            exports['ps-dispatch']:StoreRobbery(Config.Safes[safe].camId)
                            copsCalled = true
                        end
                    else
                        QBCore.Functions.Notify("Not Enough Police Around!", "error")
                    end
                end)
            else
                QBCore.Functions.Notify("The safe has already been oppened!", "error")
            end
        end
    end
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function lockpick()
    lockpickDone = false
    LockpickDoorAnim()
	local success = exports['lockpick']:startLockpick()
    lockpickDone = true
	if not success then RegisterLockpickFail() return end
    RegisterLockpickSuccess()
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(100)
    end
end

function lockpickAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

local openingDoor = false

function RegisterLockpickSuccess()
    if currentRegister ~= 0 then
        TriggerServerEvent('qb-storerobbery:server:setRegisterStatus', currentRegister)
        local lockpickTime = 25000
        Wait(1000)
        TakeCashAnim(lockpickTime)
        QBCore.Functions.Progressbar("search_register", "Emptying The Register..", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('qb-storerobbery:server:takeMoney', currentRegister, true)
            currentRegister = 0
        end, function() -- Cancel
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify("Process canceled..", "error")
            currentRegister = 0
        end)
        CreateThread(function()
            while openingDoor do
                TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                Wait(10000)
            end
        end)
    end
end

function RegisterLockpickFail()
    if usingAdvanced then
        if math.random(1, 100) < 20 then
            local ItemName = "advancedlockpick"
            TriggerServerEvent('qb-storerobbery:server:RemoveItem', ItemName, 1)
        end
    else
        if math.random(1, 100) < 40 then
            local ItemName = "lockpick"
            TriggerServerEvent('qb-storerobbery:server:RemoveItem', ItemName, 1)
        end
    end
    if (IsWearingHandshoes() and math.random(1, 100) <= 25) then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Functions.Notify("You Broke The Lock Pick")
    end
end

function LockpickDoorAnim(time)
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingReg = true
    CreateThread(function()
        while openingReg do
            if lockpickDone then openingReg = false return end
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
        end
    end)
end

function TakeCashAnim(time)
    time = time / 1000
    loadAnimDict("oddjobs@shop_robbery@rob_till")
    TaskPlayAnim(PlayerPedId(), "oddjobs@shop_robbery@rob_till", "loop" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "oddjobs@shop_robbery@rob_till", "loop", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
            time = time - 2
            TriggerServerEvent('qb-storerobbery:server:takeMoney', currentRegister, false)
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "oddjobs@shop_robbery@rob_till", "loop", 1.0)
            end
        end
    end)
end

RegisterNUICallback('PadLockSuccess', function(_, cb)
    if currentSafe ~= 0 then
        if not Config.Safes[currentSafe].robbed then
            SendNUIMessage({
                action = "kekw",
            })
        end
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
    cb('ok')
end)

RegisterNUICallback('PadLockClose', function(_, cb)
    SetNuiFocus(false, false)
    copsCalled = false
    cb('ok')
end)

RegisterNUICallback("CombinationFail", function(_)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('fail', function(_, cb)
    if usingAdvanced then
        if math.random(1, 100) < 20 then
            local ItemName = "advancedlockpick"
            TriggerServerEvent('qb-storerobbery:server:RemoveItem', ItemName, 1)
        end
    else
        if math.random(1, 100) < 40 then
            local ItemName = "lockpick"
            TriggerServerEvent('qb-storerobbery:server:RemoveItem', ItemName, 1)
        end
    end
    if (IsWearingHandshoes() and math.random(1, 100) <= 25) then
        local pos = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
        QBCore.Functions.Notify("You Broke The Lock Pick")
    end
    lockpick(false)
    cb('ok')
end)

RegisterNUICallback('exit', function(_, cb)
    lockpick(false)
    cb('ok')
end)

RegisterNUICallback('TryCombination', function(data)
    QBCore.Functions.TriggerCallback('qb-storerobbery:server:isCombinationRight', function(combination)
        if tonumber(data.combination) ~= nil then
            if tonumber(data.combination) == combination then
                TriggerServerEvent("qb-storerobbery:server:SafeReward", currentSafe)
                TriggerServerEvent("qb-storerobbery:server:setSafeStatus", currentSafe, true)
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = false,
                })
                currentSafe = 0
                takeAnim()
            else
                TriggerEvent("police:SetCopAlert")
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeKeypad",
                    error = true,
                })
                currentSafe = 0
            end
        end
    end, currentSafe)
end)

RegisterNetEvent('qb-storerobbery:client:setRegisterStatus', function(batch, val)
    -- Has to be a better way maybe like adding a unique id to identify the register
    if(type(batch) ~= "table") then
        Config.Registers[batch] = val
    else
        for k, v in pairs(batch) do
            Config.Registers[k] = batch[k]
        end
    end
end)

RegisterNetEvent('qb-storerobbery:client:setSafeStatus', function(safe, bool)
    Config.Safes[safe].robbed = bool
end)

for k, v in pairs(Config.Safes) do
    local w, l
    if v.type == "keypad" then
        w = 0.75 l = 0.75
    else
        w = 0.9 l = 0.9
    end
    exports['qb-target']:AddBoxZone("StoreSafe_"..k, v.coords, w, l, {
        name = "StoreSafe_"..k,
        heading = v.heading,
        debugPoly = true,
        minZ = v.minZ,
        maxZ = v.maxZ,
        }, {
            options = {
                {
                    num = 1,
                    type = "client",
                    event = "qb-storerobbery:client:LookatSafe",
                    icon = "fas fa-user-secret",
                    label = "Attempt Combination",
                },
            },
            distance = 3
    })
end
