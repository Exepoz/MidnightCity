local SpecialLootGiven = false
local PaletoBankInfo = {}
PaletoBankInfo.HeistStarted = {['Heist1'] = false, ['Heist2'] = false}
exports['mdn-extras']:SetCooldown('paleto', false)
exports['mdn-extras']:SetCooldown('paleto2', false)

GlobalState.PaletoBankRobbery = PaletoBankInfo

--~==================~--
--~ Heist Generation ~--
--~==================~--

local function VersionCheck()
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        local function ToNumber(cd) return tonumber(cd) end
        local resource_name = GetCurrentResourceName()
        local current_version = GetResourceMetadata(resource_name, 'version', 0)
        PerformHttpRequest('https://github.com/Constant-Development/cr-versions/blob/main/'..resource_name..'.txt?raw=true',function(_, r, _)
            if not r then print('^8Cannot Reach GitHub, Updater Disabled^0') return end
            local result = json.decode(r:sub(1, -1))
            local color = '^9'--'^'..math.random(2,9)
            local symbols = color..'~= ^5Constant Development Updater '..color
            local suffix = ""
            for _ = 1, 26+#resource_name do
                suffix = suffix..'='
            end
            symbols = symbols..suffix..'~^0'
            if ToNumber(result.version:gsub('%.', '')) > ToNumber(current_version:gsub('%.', '')) then
                print(symbols)
                print('^1 ['..resource_name..'] - Update Available!\n'..color..'^0 You are using: ^3'..current_version..'^0\n Version Available: ^3'..result.version..'\n^0 Changelog: ^3'..result.notes..'^0\n See Discord for full changelog ^3(https://discord.gg/5Trc4nEuga)')
                print(symbols)
            else
                --print(symbols)
                print('^2 ['..resource_name..'] ~ v'..current_version..' ~ Up to Date!^0')
                --print(symbols)
            end
        end,'GET')
    end)
end

local function GenerateKey()
    local code = ""
    for i = 1, 5, 1 do
        local a = math.random(10,99)
        PaletoBankInfo.VCode[i] = a
        code = code..a
        if i~= 5 then code = code.."-" end
    end
    return code
end

local function GenerateRNG()
    PaletoBankInfo.Binder = math.random(#Config.Targets.Binders)
    PaletoBankInfo.VCode, PaletoBankInfo.Step, PaletoBankInfo.Database = {}, {}, {}
    PaletoBankInfo.HeistStarted = {['Heist1'] = false, ['Heist2'] = false}
    PaletoBankInfo.ManagerKey = math.random(#Config.Targets.ManagerKey)
    PaletoBankInfo.VCode.Full = GenerateKey()
    PaletoBankInfo.Vault = math.random(1000,9999)
    PaletoBankInfo.SecondVault = math.random(1000,9999)
    PaletoBankInfo.Key = math.random(10000,99999)
    PaletoBankInfo.OfficeCode = {}
    PaletoBankInfo.OfficeCode[1] = tostring(math.random(100,999)).."-"..tostring(math.random(100,999))
    PaletoBankInfo.OfficeCode[2] = tostring(math.random(100,999)).."-"..tostring(math.random(100,999))
    PaletoBankInfo.CopsCalled = false
    PaletoBankInfo.AccessGranted = false
    PaletoBankInfo.BankInProgress = false
    PaletoBankInfo.CorrectConnection = 0
    GlobalState.PaletoBankRobbery = PaletoBankInfo
    GlobalState.PaletoDBConnections = 0
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        CreateThread(function()
            VersionCheck()
            GenerateRNG()
            PBSUtils.Debug("Heist #1 Vault Code : "..PaletoBankInfo.Vault)
            PBSUtils.Debug("Heist #2 Vault Code : "..PaletoBankInfo.SecondVault)
            PBSUtils.Debug("Security Sequence   : "..PaletoBankInfo.VCode.Full)
            PBSUtils.Debug("Officer Computer #1 : "..PaletoBankInfo.OfficeCode[1])
            PBSUtils.Debug("Officer Computer #2 : "..PaletoBankInfo.OfficeCode[2])
            if Config.TsunamiCooldown then
                PaletoBankInfo.OnCooldown = true
                GlobalState.PaletoBankRobbery = PaletoBankInfo
                Wait(Config.TsunamiCooldownTime*60000)
                PaletoBankInfo.OnCooldown = false
                GlobalState.PaletoBankRobbery = PaletoBankInfo
            end
        end)
    end
end)

RegisterNetEvent('cr-paletobankrobbery:server:Vaults', function(heist)
    PaletoBankInfo.CurrentVault = heist
    PaletoBankInfo.BankInProgress = true
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)

--~================~--
--~ Cooldown Stuff ~--
--~================~--
RegisterNetEvent('cr-paletobankrobbery:server:CopsAreCalled', function()
    PaletoBankInfo.CopsCalled = true
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)
-- SpecialLootGiven

RegisterNetEvent('cr-paletobankrobbery:server:StepDone', function(step)
    PBSUtils.Debug("Step Completed : "..step)
    if step == "OutsideKeypad" then
        PaletoBankInfo.Step.OutsideKeypad = true
    elseif step == "PhoneCall" then
        PaletoBankInfo.Step.PhoneCall = true
    elseif step == "CompleteHeist" then
        PaletoBankInfo.HeistCompleted = true
    end
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)

RegisterNetEvent('cr-paletobankrobbery:server:ForceReset', function()
    CreateThread(function()
        PaletoBankInfo.OnCooldown = true
        GlobalState.PaletoBankRobbery = PaletoBankInfo
        Wait(2000)
        PBSUtils.Debug('Resetting the bank.')
        GenerateRNG()
        TriggerClientEvent("cr-paletobankrobbery:client:ResetBank", -1)
        PaletoBankInfo.OnCooldown = false
        GlobalState.PaletoBankRobbery = PaletoBankInfo
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:server:StartResetCooldown', function()
    CreateThread(function()
        PaletoBankInfo.OnCooldown = true
        GlobalState.PaletoBankRobbery = PaletoBankInfo
        Wait(Config.HeistOptions.CooldownTime * 60000)
        PBSUtils.Debug('Cooldown Done, Resetting the bank.')
        GenerateRNG()
        TriggerClientEvent("cr-paletobankrobbery:client:ResetBank", -1)
        exports['mdn-extras']:SetCooldown('paleto', false)
        exports['mdn-extras']:SetCooldown('paleto2', false)
        PaletoBankInfo.OnCooldown = false
        GlobalState.PaletoBankRobbery = PaletoBankInfo
    end)
end)

RegisterNetEvent('cr-paletobankrobbery:server:ActivatePaletoBanque', function(step)
    PaletoBankInfo.Step[step] = true
    if PaletoBankInfo.HeistInProgress then return end
    CreateThread(function()
        PBSUtils.Debug(Lcl('debug_BankActive', Config.HeistOptions.TimeToComplete))
        PBSUtils.Logs('logs_BankStarted', 'green', Lcl('debug_BankActive', Config.HeistOptions.TimeToComplete))
        if step ~= 'SequenceDoor' then
            exports['mdn-extras']:SetCooldown('paleto', true)
            exports['mdn-extras']:SetCooldown('paleto2', true)
        end
        PaletoBankInfo.HeistInProgress = true
        GlobalState.PaletoBankRobbery = PaletoBankInfo
        Wait(Config.HeistOptions.TimeToComplete*60000)
        PaletoBankInfo.HeistInProgress = false
        GlobalState.PaletoBankRobbery = PaletoBankInfo
        PBSUtils.Debug('Bank Disabled')
        if not PaletoBankInfo.HeistCompleted then
            PBSUtils.Debug('Bank not completed, resetting codes, doors & targets') GenerateRNG()
            TriggerClientEvent("cr-paletobankrobbery:client:ResetBank", -1)
        else PBSUtils.Debug('Heist Completed, Initiating Cooldown') TriggerEvent('cr-paletobankrobbery:server:StartResetCooldown') end
    end)
end)
--~=======~--
--~ Items ~--
--~=======~--

RegisterNetEvent('cr-paletobankrobbery:server:RecItem', function(type, serversource)
    local src = serversource or source
    local code, info
    if type == "SecSeq" then
        code = tostring(PaletoBankInfo.VCode.Full)
        info = {label = Lcl('stickynotelabelsecurity', code)}
        PBSUtils.GiveItem(src, Config.Items.SitckyNote.item, 1, info)
        PaletoBankInfo.Binder = nil
    elseif type == "VaultCode1" then
        code = tostring(PaletoBankInfo.Vault)
        info = {label = Lcl('stickynotelabelvault', code)}
        PBSUtils.GiveItem(src, Config.Items.SitckyNote.item, 1, info)
    elseif type =="VaultCode2" then
        code = tostring(PaletoBankInfo.SecondVault)
        info = {label = Lcl('stickynotelabelvault', code)}
        PBSUtils.GiveItem(src, Config.Items.PrinterDocument.item, 1, info)
    elseif type == "OfficeKey" then
        PaletoBankInfo.Step.KeyAcquired = true
        PBSUtils.GiveItem(src, Config.Items.OfficeKey.item, 1, info)
    else
        PBSUtils.GiveItem(src, type, 1)
    end
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)

RegisterNetEvent('cr-paletobankrobbery:server:RemItem', function(item, amount)
    local src = source
    PBSUtils.RemoveItem(src, item, amount)
end)

RegisterNetEvent('cr-paletobankrobbery:server:USBRemoval', function(hack)
    local src = source
    local Hack = Config.Difficulties[hack]
    if Hack.RemovalType == "chance" or (Config.Framework.Framework == "ESX" and not Config.Framework.UseOxInv) then
        if math.random(100) <= Hack.RemovalChance then PBSUtils.RemoveItem(src, Config.Items.VaultComputerHacking.item, 1) end
    elseif Hack.RemovalType == "uses" then
        --PBSUtils.AddItemUse(src, Config.Items.VaultComputerHacking.item, "uses", Config.Items.VaultComputerHacking.uses)
    end
end)

RegisterNetEvent('cr-paletobankrobbery:server:GetOutDepoLoot', function()
    local src = source
    local info = { Door = PaletoBankInfo.Key }
    PBSUtils.GiveItem(src, Config.OfficeKeyItem, 1, info)
end)

--~============~--
--~ Phone Call ~--
--~============~--

RegisterNetEvent('cr-paletobankrobbery:server:CallBank', function(phone, vault)
    TriggerClientEvent('cr-paletobankrobbery:client:CallBank', -1, phone, vault)
end)

RegisterNetEvent('cr-paletobankrobbery:server:AnswerPhone')
AddEventHandler('cr-paletobankrobbery:server:AnswerPhone', function()
    PaletoBankInfo.PhoneAnswered = true
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)

--~======================~--
--~ Synced Database Hack ~--
--~======================~--

-- Database Hack (Synced Completion Check)
RegisterNetEvent('cr-paletobankrobbery:server:DatabaseConnect', function(computer)
    PaletoBankInfo.Database[computer] = 1
    if Config.HeistOptions.Heist2.SoloDataBase then Wait(2000)
        PaletoBankInfo.Database[1] = 1 PaletoBankInfo.Database[2] = 1
    end
    GlobalState.PaletoBankRobbery = PaletoBankInfo
end)

RegisterNetEvent('cr-paletobankrobbery:server:AccessGranted', function()
    if GlobalState.PaletoBankRobbery.CorrectConnection == 0 then
       PaletoBankInfo.CorrectConnection = PaletoBankInfo.CorrectConnection + 1
       GlobalState.PaletoBankRobbery = PaletoBankInfo
    elseif GlobalState.PaletoBankRobbery.CorrectConnection == 1 then
       PaletoBankInfo.CorrectConnection = PaletoBankInfo.CorrectConnection + 1
        PBSUtils.Notify(1, Lcl('notif_PrintingCodes'), Lcl('PaletoTitle'), source)
        PaletoBankInfo.AccessGranted = true
        if not PaletoBankInfo.AccessGranted then PaletoBankInfo.AccessGranted = true end
        GlobalState.PaletoBankRobbery = PaletoBankInfo TriggerClientEvent('cr-paletobankrobbery:client:ActivatePrinter', -1)
        TriggerClientEvent('cr-paletobankrobbery:server:DeleteZones', -1, 'OfficeComputer', 1)
        TriggerClientEvent('cr-paletobankrobbery:server:DeleteZones', -1, 'OfficeComputer', 2)
    end
end)

--~================~--
--~ Vault Stuff ~--
--~================~--

RegisterNetEvent('cr-paletobankrobbery:server:TableLoot', function(model)
    local src = source
    local item, itemAmount
    local Table = Config.Rewards.Heist1.Vault.Table
    local coords = Config.Targets.Table.coords
    if PBSUtils.CheckExploit(src, coords, 'cr-paletobankrobbery:server:TableLoot') then return end
    if model == -180074230 then
        item = Config.Items.GoldBar
        itemAmount = math.random(Table.GoldAmount.min, Table.GoldAmount.max)
        PBSUtils.GiveItem(src, item.item, itemAmount)
        PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.name.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n(Middle Table)")
    else
        local info = {worth = math.random(Table.MoneyWorth.min, Table.MoneyWorth.max)}
        itemAmount = math.random(Table.BagAmount.min, Table.BagAmount.max)
        if Table.MoneyInBags then
            item = Config.Items.DirtyMoney
            PBSUtils.GiveItem(src, item.item, itemAmount, info)
            PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.name.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n**"..Lcl('logs_worth').."** "..info.worth.."\n"..'(Middle Table)')
        else
            local totalWorth = itemAmount * info.worth
            PBSUtils.AddMoney(src, "cash", totalWorth)
            PBSUtils.Notify(1, Lcl('notif_GrabbedLootMoney', totalWorth), Lcl("PaletoTitle"))
            PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** $"..totalWorth.."\n(Middle Table)")
        end
    end
end)

RegisterNetEvent('cr-paletobankrobbery:server:TrayLoot', function(model)
    local src = source
    local item = Config.Items.DirtyMoney
    local itemAmount, info
    local Trays = Config.Rewards.Heist1.Vault.Trays
    if GlobalState.PaletoBankRobbery.CurrentVault == 2 then Trays = Config.Rewards.Heist2.Vault.Trays end
    local coords = Config.Targets.Trays[1].coords
    if PBSUtils.CheckExploit(src, coords, 'cr-paletobankrobbery:server:TrayLoot') then return end
    if model == 2007413986 then
        item = Config.Items.GoldBar
        itemAmount = math.random(Trays.GoldAmount.Min, Trays.GoldAmount.Max)
        PBSUtils.GiveItem(src, item.item, itemAmount)
        PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.name.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n(Tray)")
    else
        info = {worth = math.random(Trays.MoneyWorth.Min, Trays.MoneyWorth.Max)}
        itemAmount = math.random(Trays.MoneyBagAmount.Min, Trays.MoneyBagAmount.Max)
        if Trays.MoneyInBags then
            PBSUtils.GiveItem(src, item.item, itemAmount, info)
            PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.name.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n**"..Lcl('logs_worth').."** "..info.worth.."\n"..'(Tray)')
        else
            local totalWorth = itemAmount * info.worth
            PBSUtils.AddMoney(src, "cash", totalWorth)
            PBSUtils.Notify(1, Lcl('notif_GrabbedLootMoney', totalWorth), Lcl("PaletoTitle"))
            PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** $"..totalWorth.."\n(Tray)")
        end
    end
end)

RegisterNetEvent('cr-paletobankrobbery:server:DepoLoot', function(box, loot, inner)
    local src = source
    local Boxes = Config.Rewards.Heist1.Vault.DepositBoxes
    if GlobalState.PaletoBankRobbery.CurrentVault == 2 then Boxes = Config.Rewards.Heist2.Vault.DepositBoxes end
    local coords = Config.Targets.DepositBoxes[1].coords
    if PBSUtils.CheckExploit(src, coords, 'cr-paletobankrobbery:server:DepoLoot') then return end
    if inner then Boxes = Config.Rewards.Heist2.InnerVaultDepositBoxes end
    if Config.Difficulties.DrillingMinigame.Type == "fivem-drilling" then
        local ranLoot = PBSUtils.GenerateLoot(Boxes.Loot)
        local lootAmount = math.random(Boxes.Loot[ranLoot].amount.min, Boxes.Loot[ranLoot].amount.max)
        PBSUtils.GiveItem(src, Boxes.Loot[ranLoot].item, lootAmount)
        PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..Reward.Loot[ranLoot].item.."\n**"..Lcl('logs_qty').."** "..lootAmount.."\n(Deposit Box)")
        Wait(1000)
        TriggerClientEvent('cr-paletobankrobbery:client:VaultSync', -1, "DepoLoot", box)
        if math.random(100) <= Boxes.SpecialLootChance then PBSUtils.GiveItem(src, Boxes.SpecialLoot, 1) end
    elseif Config.Difficulties.DrillingMinigame.Type == "custom" then
        if loot == "noloot" then
            TriggerClientEvent('cr-paletobankrobbery:client:VaultSync', -1, "DepoLoot", box)
        else
            if math.random(100) >= Boxes.EmptyChance then
                local bagInfo = {}
                bagInfo.type = "PaletoBankRobbery"
                bagInfo.typeName = "Paleto Bank Robbery"
                PBSUtils.GiveItem(src, 'lootbag', 1, bagInfo)
                if Config.Logs then PBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..'lootbag'.."\n**"..Lcl('logs_qty').."** ".. 1 .."\n(Deposit Box)") end
                TriggerClientEvent('cr-paletobankrobbery:client:VaultSync', -1, "DepoLoot", box)
            else
                PBSUtils.Notify(3, Lcl("notif_DepositBoxEmpty"), Lcl("PaletoTitle"))
                TriggerClientEvent('cr-paletobankrobbery:client:VaultSync', -1, "DepoLoot", box)
            end
        end
    end
end)

RegisterNetEvent('cr-paletobankrobbery:server:collectSafe', function()
    local src = source
    local Safe = Config.Rewards.Safe
    local coords = vector3(-106.05, 6457.81, 31.63)
    if Config.Framework.MLO == "Gabz" then coords = vector3(-105.59, 6480.32, 31.63) end
    if PBSUtils.CheckExploit(src, coords, 'cr-paletobankrobbery:server:collectSafe') then return end
    if Safe.Items.enabled then
        local rolls = math.random(Safe.Items.rolls.min, Safe.Items.rolls.max)
        for _ = 1, rolls do
            local RanLoot = PBSUtils.GenerateLoot(Safe.Items.pool)
            local RanAmount = math.random(Safe.Items.pool[RanLoot].amount.Min, Safe.Items.pool[RanLoot].amount.Max)
            local item = Safe.Items.pool[RanLoot].item
            PBSUtils.GiveItem(src, item, RanAmount)
            PBSUtils.Logs(Lcl('logs_safelooted'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.."\n**"..Lcl('logs_qty').."** "..RanAmount)
            Wait(200)
        end
    end
    if Safe.DirtyMoney.enabled then
        local info = {worth = math.random(Safe.DirtyMoney.moneyPerBag.min, Safe.DirtyMoney.moneyPerBag.max)}
        PBSUtils.GiveItem(src, Config.Items.DirtyMoney.item, math.random(Safe.DirtyMoney.bagAmount.min, Safe.DirtyMoney.bagAmount.max), info)
        PBSUtils.Logs(Lcl('logs_safelooted'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..Config.Items.DirtyMoney.name.."\n**"..Lcl('logs_worth').."** "..info.worth)
    end
    if Safe.CleanMoney.enabled then PBSUtils.AddMoney(src, 'cash', math.random(Safe.CleanMoney.min, Safe.CleanMoney.max)) end
end)

--~================~--
--~ Managers Office ~--
--~================~--

-- Grabbing Managers Key
RegisterNetEvent('cr-paletobankrobbery:server:GrabKeys', function()
    TriggerClientEvent('cr-paletobankrobbery:client:RemoveKey', -1)
    PaletoBankInfo.ManagerKey = nil
    GlobalState.PaletoBankRobbery = PaletoBankInfo
    PBSUtils.GiveItem(source, Config.Items.ManagerKey.item, 1)
end)

--~======~--
--~ Sync ~--
--~======~--

RegisterServerEvent('cr-paletobankrobbery:server:VaultCodesRight', function()
    TriggerClientEvent('cr-paletobankrobbery:client:VaultCodesRight', -1)
end)

RegisterNetEvent('cr-paletobankrobbery:server:ThermitePfxSync', function(door)
    TriggerClientEvent('cr-paletobankrobbery:client:ThermitePfxSync', -1, door)
end)

RegisterNetEvent('cr-paletobankrobbery:server:VaultSync', function(type, arg1, arg2, arg3)
    TriggerClientEvent('cr-paletobankrobbery:client:VaultSync', -1, type, arg1, arg2, arg3)
end)

RegisterNetEvent('cr-paletobankrobbery:server:Sync', function(arg1, arg2, arg3, arg4)
    TriggerClientEvent('cr-paletobankrobbery:client:Sync', -1, arg1, arg2, arg3, arg4)
end)

RegisterNetEvent("cr-paletobankrobbery:server:DeleteZones", function(zone, pos)
    TriggerClientEvent('cr-paletobankrobbery:client:DeleteZones', -1, zone, pos)
end)

RegisterNetEvent('cr-paletobankrobbery:server:callCops', function(type)
    TriggerClientEvent('cr-paletobankrobbery:client:callCops', -1, type)
end)