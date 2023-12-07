local CRFleecaBank = {}
CRFleecaBank.Banks = {}
CRFleecaBank.GlobalCD = false
GlobalState.CRFleecaBank = CRFleecaBank
GlobalState.CRFleecaSecurityDisabled = false
exports['mdn-extras']:SetCooldown('fleeca', false)

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

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        VersionCheck()
        for k, _ in pairs (Config.Banks) do
            CRFleecaBank.Banks[k] = {}
            CRFleecaBank.Banks[k].DoorCodes = math.random(1000,9999)
            CRFleecaBank.Banks[k].VaultCodes = math.random(1000,9999)
            CRFleecaBank.Banks[k].HasCard = (math.random(100) <= Config.Rewards.Safe.CardChance)
            if Config.Debug or Config.DevMode then print("Bank #"..k.." | Door : "..CRFleecaBank.Banks[k].DoorCodes.." | Vault : "..CRFleecaBank.Banks[k].VaultCodes.." | HasCard : "..tostring(CRFleecaBank.Banks[k].HasCard).." | Bank Name : "..Config.Banks[k].name) end
        end
        if Config.ServerStartCooldown then
            CreateThread(function()
                if Config.Cooldown.Type == "global" then CRFleecaBank.GlobalCD = true
                else for k, _ in pairs (Config.Banks) do CRFleecaBank.Banks[k].onCooldown = true end end
                Wait(Config.ServerStartCooldownTime * 60000)
                if Config.Cooldown.Type == "global" then CRFleecaBank.GlobalCD = false
                else for k, _ in pairs (Config.Banks) do CRFleecaBank.Banks[k].onCooldown = false end end
            end)
        end
        GlobalState.CRFleecaBank = CRFleecaBank
    end
end)

RegisterNetEvent('cr-fleecabankrobbery:server:UpdateGlobalState', function(state, value)
    GlobalState:set(state, value, true)
end)

RegisterNetEvent("cr-fleecabankrobbery:server:TellerUnlocked", function(bank)
    CRFleecaBank.Banks[bank].TellerUnlocked = true
    GlobalState.CRFleecaBank = CRFleecaBank
    if Config.Framework.MLO == "Gabz" then TriggerClientEvent('cr-fleecabankrobbery:client:UnhookChair', -1, bank) end
end)

local function ResetCode(bank)
    local DoorCodes = {}
    local VaultCodes = {}
    if Config.Cooldown.Type == "global" then
        for k, _ in pairs(Config.Banks) do
            DoorCodes[k] = math.random(1000,9999)
            VaultCodes[k] = math.random(1000,9999)
            CRFleecaBank.Banks[k].HasCodes = false
            CRFleecaBank.Banks[k].DoorCodes = DoorCodes[k]
            CRFleecaBank.Banks[k].VaultCodes = VaultCodes[k]
            local c = math.random(100)
            CRFleecaBank.Banks[k].HasCard = (c <= Config.Rewards.Safe.CardChance)
        end
    elseif Config.Cooldown.Type == "unique" then
        DoorCodes[bank] = math.random(1000,9999)
        VaultCodes[bank] = math.random(1000,9999)
        CRFleecaBank.Banks[bank].HasCodes = false
        CRFleecaBank.Banks[bank].DoorCodes = DoorCodes[bank]
        CRFleecaBank.Banks[bank].VaultCodes = VaultCodes[bank]
        CRFleecaBank.Banks[bank].HasCard = (math.random(100) <= Config.Rewards.Safe.CardChance)
    end
end

RegisterNetEvent('cr-fleecabankrobbery:server:StartResetCooldown')
AddEventHandler('cr-fleecabankrobbery:server:StartResetCooldown', function(bank)
    -- Active Cooldown (10 Minutes to open the Vault Door)
    if BankActive then return end
    print(Lcl('debug_BankActive', Config.Banks[bank].name))
    exports['mdn-extras']:SetCooldown('fleeca', true)
    CRFleecaBank.Banks[bank].SecurityDisabled = true
    Config.Banks[bank].Active = true
    BankActive = true
    GlobalState.CRFleecaBank = CRFleecaBank
    CreateThread(function()
        Wait(Config.HeistTimer*60000) -- 10 Minutes to complete the heist

        print(Lcl('debug_BankInactive'))
        CRFleecaBank.Banks[bank].SecurityDisabled = false
        Config.Banks[bank].Active = false
        BankActive = false
        GlobalState.CRFleecaBank = CRFleecaBank

        ResetCode(bank) -- Resets Bank Codes
        if Config.Cooldown.Type == "global" then
            print('cd')
            CRFleecaBank.GlobalCD = true
            GlobalState.CRFleecaBank = CRFleecaBank
            Wait((Config.Cooldown.Time * 1000) * 60)
            print("cd off")
            exports['mdn-extras']:SetCooldown('fleeca', false)
            TriggerClientEvent("cr-fleecabankrobbery:client:ResetBanks", -1)
            CRFleecaBank.GlobalCD = false
            GlobalState.CRFleecaBank = CRFleecaBank
        elseif Config.Cooldown.Type == "unique" then
            CRFleecaBank.Banks[bank].onCooldown = true
            GlobalState.CRFleecaBank = CRFleecaBank
            Wait((Config.Cooldown.Time * 1000) * 60)
            TriggerClientEvent("cr-fleecabankrobbery:client:ResetBank", -1, bank)
            CRFleecaBank.Banks[bank].onCooldown = false
            GlobalState.CRFleecaBank = CRFleecaBank
        else
            print(Lcl('debug_cooldownerror'))
        end
    end)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:GetSecurityCode', function(bank)
    local src = source
    local code = tostring(CRFleecaBank.Banks[bank].DoorCodes)
    local info = { label = Lcl('doclabel').." "..code }
    FBSUtils.GiveItem(src, "printed_document", 1, info)
end)

-- loot redone, standalone
RegisterNetEvent('cr-fleecabankrobbery:server:GetSafeLoot', function(bank)
    local src = source
    local Safe = Config.Rewards.Safe
    local RanLoot = GenerateLoot("Safe")
    local RanAmount = math.random(Safe.Loot[RanLoot].amount.Min, Safe.Loot[RanLoot].amount.Max)
    local item = Safe.Loot[RanLoot].item
    FBSUtils.GiveItem(src, item, RanAmount)
    if Config.Logs then FBSUtils.Logs(Lcl('logs_safelooted'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.."\n**"..Lcl('logs_qty').."** "..RanAmount) end
    Wait(500)
    if CRFleecaBank.Banks[bank].HasCard then
        FBSUtils.GiveItem(src, Config.Items.VaultCardItem.item, 1)
        if Config.Logs then FBSUtils.Logs(Lcl('logs_safelooted'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..Config.Items.VaultCardItem.name.."\n**"..Lcl('logs_qty').."** 1") end
    end
    Wait(1000)
    if not Config.Difficulties.VaultDoor.CodesNeeded then return end
    local code = tostring(GlobalState.CRFleecaBank.Banks[bank].VaultCodes)
    local info = { label = Lcl('stickynotelabel').." "..code }
    FBSUtils.GiveItem(src, "stickynote", 1, info)
    CRFleecaBank.Banks[bank].HasCodes = true
    GlobalState.CRFleecaBank = CRFleecaBank
    if Config.Logs then FBSUtils.Logs(Lcl('logs_safelooted'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** stickynote\n**"..Lcl('logs_qty').."** 1") end
end)

-- loot redone, standalone
RegisterNetEvent('cr-fleecabankrobbery:server:TableLoot', function(model)
    local src = source
    local item
    local itemAmount
    local cash = false
    local Rewards = Config.Rewards.Table
    if model == -180074230 then
        item = Config.Items.GoldBar.item
        itemAmount = math.random(Rewards.GoldAmount.Min, Rewards.GoldAmount.Max)
        FBSUtils.GiveItem(src, item, itemAmount)
    else
        local info = {worth = math.random(Rewards.MoneyWorth.Min, Rewards.MoneyWorth.Max)}
        itemAmount = math.random(Rewards.BagAmount.Min, Rewards.BagAmount.Max)
        if Rewards.MoneyInBags then
            item = Config.Items.BaggedMoney.item
            FBSUtils.GiveItem(src, item, itemAmount, info)
        else
            cash = true
            local totalWorth = itemAmount * info.worth
            FBSUtils.AddMoney(src, "cash", totalWorth)
            FBSUtils.Notify(1, Lcl('GrabbedLootMoney', totalWorth), Lcl("FleecaTitle"))
            if Config.Logs then FBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** $"..totalWorth.."\n(Middle Table)") end
        end
    end
    if not cash and Config.Logs then FBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n(Middle Table)") end
end)

-- loot redone, standalone
RegisterNetEvent('cr-fleecabankrobbery:server:TrayLoot', function(model, loc)
    local src = source
    local item = Config.Items.BaggedMoney.item
    local itemAmount, info
    local cash = false
    local Reward = Config.Rewards.Trays
    if model == 2007413986 then
        item = Config.Items.GoldBar.item
        itemAmount = math.random(Reward.GoldAmount.Min, Reward.GoldAmount.Max)
        FBSUtils.GiveItem(src, item, itemAmount)
    else
        info = {worth = math.random(Reward.MoneyWorth.Min, Reward.MoneyWorth.Max)}
        itemAmount = math.random(Reward.MoneyBagAmount.Min, Reward.MoneyBagAmount.Max)
        if Reward.MoneyInBags then FBSUtils.GiveItem(src, item, itemAmount, info)
        else
            local totalWorth = itemAmount * info.worth
            FBSUtils.AddMoney(src, "cash", totalWorth)
            FBSUtils.Notify(1, Lcl('GrabbedLootMoney', totalWorth), Lcl("FleecaTitle"))
            if Config.Logs == true then FBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** $"..totalWorth.."\n(Tray #"..loc..")") end
        end
    end
    if not cash and Config.Logs then FBSUtils.Logs( Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..item.."\n**"..Lcl('logs_qty').."** "..itemAmount.."\n(Tray #"..loc..")") end
end)

-- loot redone, standalone
RegisterNetEvent('cr-fleecabankrobbery:server:DepoLoot', function(bank, box, loot)
    local src = source
    local Reward = Config.Rewards.DepositBoxes
    if Config.Difficulties.DrillingMinigame.Type == "fivem-drilling" then
        local ranLoot = GenerateLoot("DepositBoxes")
        local lootAmount = math.random(Reward.Loot[ranLoot].amount.Min, Reward.Loot[ranLoot].amount.Max)
        FBSUtils.GiveItem(src, Reward.Loot[ranLoot].item, lootAmount)
        TriggerClientEvent('cr-fleecabankrobbery:client:VaultSync', -1, "DepoLootSync", bank, box)
        if Config.Logs then FBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..Reward.Loot[ranLoot].item.."\n**"..Lcl('logs_qty').."** "..lootAmount.."\n(Deposit Box)") end
    elseif Config.Difficulties.DrillingMinigame.Type == "custom" then
        if loot == "noloot" then TriggerClientEvent('cr-fleecabankrobbery:client:VaultSync', -1, "DepoLootSync", bank, box)
        else
            local luck = math.random(100)
            if luck > Config.Rewards.DepositBoxes.EmptyChance then
                local bagInfo = {}
                bagInfo.type = "FleecaBankRobbery"
                bagInfo.typeName = "Fleeca Bank Robbery"
                -- local ranLoot = GenerateLoot("DepositBoxes")
                -- local lootAmount = math.random(Reward.Loot[ranLoot].amount.Min, Reward.Loot[ranLoot].amount.Max)
                FBSUtils.GiveItem(src, 'lootbag', 1, bagInfo)
                TriggerClientEvent('cr-fleecabankrobbery:client:VaultSync', -1, "DepoLootSync", bank, box)
                if Config.Logs then FBSUtils.Logs(Lcl('logs_loottitle'), 'green', "**"..Lcl('logs_player').."** "..GetPlayerName(src).. "\n**"..Lcl('logs_found').."** "..'lootbag'.."\n**"..Lcl('logs_qty').."** ".. 1 .."\n(Deposit Box)") end
            else
                FBSUtils.Notify(3, Lcl("DepositBoxEmpty"), Lcl("FleecaTitle"))
                TriggerClientEvent('cr-fleecabankrobbery:client:VaultSync', -1, "DepoLootSync", bank, box)
            end
        end
    end
end)

RegisterNetEvent('cr-fleecabankrobbery:server:RemItem')
AddEventHandler('cr-fleecabankrobbery:server:RemItem', function(item, amount)
    local src = source
    FBSUtils.RemoveItem(src, item, amount)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:RecItem')
AddEventHandler('cr-fleecabankrobbery:server:RecItem', function(item, amount)
    local src = source
    FBSUtils.GiveItem(src, item, amount)
end)

RegisterNetEvent('cr-fleecabankrobbery:server:FleecaBankLockPickRemoval', function()
    local src = source
    if not FBSUtils.HasItem(src, Config.Items.Lockpick.item) or not Config.Difficulties.TellerDoor.RemoveLockpick then return end
    local luck = math.random(1,100)
    if luck <= Config.Difficulties.TellerDoor.LockpickRemovalChance then
        FBSUtils.RemoveItem(src, Config.Items.Lockpick.item, 1)
    end
end)

-- ok
RegisterNetEvent('cr-fleecabankrobbery:server:FleecaBankUSBRemoval', function()
    local src = source
    if Config.Difficulties.ComputerHack.RemoveItem then
        if Config.Difficulties.ComputerHack.RemovalType == "chance" or (Config.Framework.Framework == "ESX" and not Config.Framework.UseOxInv) then
            local luck = math.random(1,100)
            if luck <= Config.Difficulties.ComputerHack.RemovalChance then
                --exports['mdn-extras']:RemoveProtocol()
                --FBSUtils.RemoveItem(src, Config.Items.ComputerHackItem.item)
            end
        elseif Config.Difficulties.ComputerHack.RemovalType == "uses" then
            TriggerClientEvent('cr-fleecabankrobbery:client:RemoveHackUse', src)
            --FBSUtils.LowerMetadata(src, Config.Items.ComputerHackItem.item, "uses")
        end
    end
end)

RegisterNetEvent('cr-fleecabankrobbery:server:FleecaBankCardRemoval', function()
    local src = source
    if not FBSUtils.HasItem(src, Config.Items.VaultCardItem.item) or not Config.Difficulties.VaultDoor.CardRemoval then return end
    FBSUtils.RemoveItem(src, Config.Items.VaultCardItem.item, 1)
end)