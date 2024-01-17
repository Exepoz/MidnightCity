RegisterNetEvent("Pug:server:DrugPlaneDepositeToggle", function(bool)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        if bool then
            Player.AddMoney(Config.DrugPlaneDepositCurrency, Config.DrugPlaneDeposit)
            Wait(3000)
            local MoneyBonus = math.ceil(bool * math.random(Config.DropOffBoxWorthEachMin, Config.DropOffBoxWorthEachMax))
            Player.AddMoney(Config.DrugPlaneDepositCurrency, MoneyBonus)
            TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["YouEarned"].." +$"..MoneyBonus.." "..Config.LangT["BonusForBoxes"])
        else
            Player.RemoveMoney(Config.DrugPlaneDepositCurrency, Config.DrugPlaneDeposit)
        end
    end
end)

Config.FrameworkFunctions.CreateCallback('Pug:ServerCB:GetPlayerMoneyCount', function(source, cb)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local Retval = false
    if Player ~= nil then
        local Money = Player.PlayerData.money.cash
        if Config.DrugPlaneDepositCurrency == "bank" then
            Money = Player.PlayerData.money.bank
        end
        if Money >= Config.DrugPlaneDeposit then
            Retval = true
        end
    end
    Wait(100)
    cb(Retval)
end)

RegisterNetEvent("Pug:server:GiveDrugRunDrugs", function()
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        for k, v in pairs(Config.DrugsToGive) do
            local Amount = math.random(v.AmountMin, v.AmountMax)
            Player.AddItem(k, Amount)
            if Framework == "QBCore" then
                TriggerClientEvent('inventory:client:ItemBox', src, FWork.Shared.Items[k], "add", Amount)
            end
        end
    end
end)

-- Laboratory stuff
if Framework == "ESX" then
    Config.FrameworkFunctions.CreateCallback('Pug:serverESX:GetItemsDrugRunning', function(source, cb, item, amount)
        local retval = false
        local Player = FWork.GetPlayerFromId(source)
        local PlayerItem = Player.getInventoryItem(item)
        local Cost = amount or 1
        if PlayerItem then
            if PlayerItem.count >= Cost then
                retval = true
            end
        end
        cb(retval)
    end)
elseif Framework == "QBCore" then
    local function GetFirstSlotByItem(items, itemName)
        if not items then return nil end
        for slot, item in pairs(items) do
            if item.name:lower() == itemName:lower() then
                return tonumber(slot)
            end
        end
        return nil
    end
    local function GetItemByName(source, item)
        local Player = Config.FrameworkFunctions.GetPlayer(source)
        item = tostring(item):lower()
        local slot = GetFirstSlotByItem(Player.PlayerData.items, item)
        return Player.PlayerData.items[slot]
    end
    Config.FrameworkFunctions.CreateCallback('Pug:server:GetItemDrugRunning', function(source, cb, items, amount)
        local src = source
        if Config.InventoryType == "ox" then
            local ox_inventory = exports.ox_inventory
            if ox_inventory:GetItem(src, items, false, true) >= amount then
                cb(true)
            else
                cb(false)
            end
        else
            local retval = false
            local Player = Config.FrameworkFunctions.GetPlayer(src)
            if not Player then return false end
            local isTable = type(items) == 'table'
            local isArray = isTable and table.type(items) == 'array' or false
            local totalItems = #items
            local count = 0
            local kvIndex = 2
            if amount == 'hidden' then
                amount = 1
            end
            if isTable and not isArray then
                totalItems = 0
                for _ in pairs(items) do totalItems += 1 end
                kvIndex = 1
            end
            if isTable then
                for k, v in pairs(items) do
                    local itemKV = {k, v}
                    local item = GetItemByName(src, itemKV[kvIndex])
                    if item and ((amount and item.amount >= amount) or (not isArray and item.amount >= v) or (not amount and isArray)) then
                        count += 1
                    end
                end
                if count == totalItems then
                    retval = true
                end
            else -- Single item as string
                local item = GetItemByName(src, items)
                if item and (not amount or (item and amount and item.amount >= amount)) then
                    retval = true
                end
            end
            cb(retval)
        end
    end)
end

function PugFindPlayersByItentifier(identifier, bool)
    local players = GetPlayers()
    for _, v in ipairs(players) do
        local playerIdentifier = FWork.GetIdentifier(v)
        if playerIdentifier == identifier then
            if Config.Debug then
                print("player found:", v)
            end
            if bool then
                return v
            else
                return FWork.GetPlayerFromId(v)
            end
        end
    end
end

local function CehckIsMemberOfCokeLab(source)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        local cid = tostring(Player.PlayerData.citizenid)
        local result = MySQL.query.await('SELECT * FROM pug_cokebusiness', {})
        if result[1] ~= nil then
            for i = 1, (#result), 1 do
                local keyholders = json.decode(result[i].access)
                if keyholders ~= nil then
                    for _,v in pairs(keyholders) do
                        if tostring(v) == cid then
                            return result[i]
                        end
                    end
                end
            end
        end
        Wait(100)
        return false
    else
        return false
    end
end

local function UpdateEveryoneInLab(src)
    Wait(500)
    local Shared2 = CehckIsMemberOfCokeLab(src)
    if Shared2 then
        for _, v in pairs(json.decode(Shared2.access)) do
            local Player = Config.FrameworkFunctions.GetPlayer(v, true)
            if Player ~= nil then
                TriggerClientEvent("Pug:cleint:UpdateAllLabInfo", Player.PlayerData.source, Shared2)
            end
        end
    end
end

Config.FrameworkFunctions.CreateCallback('Pug:server:DoesOwnCokeLab', function(source, cb)
    local src = source
    local Data = CehckIsMemberOfCokeLab(src)
    if Data then
        cb(Data)
    else
        cb(false)
    end
end)

Config.FrameworkFunctions.CreateCallback('Pug:server:GetCokeDoorData', function(source, cb)
    local src = source
    local result = MySQL.query.await('SELECT * FROM pug_cokebusiness', {})
    if result[1] ~= nil then
        local DoorFound = false
        for i = 1, (#result), 1 do
            local LabCoords = json.decode(result[i].lablocation)
            if #(GetEntityCoords(GetPlayerPed(src)) - vector3(LabCoords.x, LabCoords.y, LabCoords.z)) <= 2.0 then
                DoorFound = true
                local keyholders = json.decode(result[i].access)
                local Player = Config.FrameworkFunctions.GetPlayer(src)
                local cid
                if Player ~= nil then
                    cid = tostring(Player.PlayerData.citizenid)
                end
                if keyholders ~= nil then
                    local owner = false
                    for _,v in pairs(keyholders) do
                        if tostring(v) == cid then
                            owner = true
                            break
                        end
                    end
                    Wait(300)
                    local Data = {
                        Owner = owner,
                        AllData = result[i]
                    }
                    cb(Data)
                    break
                else
                    cb(false)
                    break
                end
            end
        end
        Wait(200)
        if not DoorFound then
            cb(false)
        end
    else
        cb(false)
    end
end)

Config.FrameworkFunctions.CreateCallback('Pug:serverCB:GetCokeLabMembersNames', function(source, cb)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
	local cid = Player.PlayerData.citizenid
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared ~= nil then
        local Players = {}
        for _, v in pairs(json.decode(Shared.access)) do
            if v == cid then
            else
                local Player2 = Config.FrameworkFunctions.GetPlayer(v, true)
                if Player2 ~= nil then
                    Players[#Players+1] = {
                        name = Player2.PlayerData.charinfo.firstname .. ' '.. Player2.PlayerData.charinfo.lastname..' 🟢',
                        cid = Player2.PlayerData.citizenid
                    }
                else
                    if Framework == "QBCore" then
                        local Player3 = FWork.Player.GetOfflinePlayer(v)
                        if Player3 ~= nil then
                            Players[#Players+1] = {
                                name = Player3.PlayerData.charinfo.firstname .. ' '.. Player3.PlayerData.charinfo.lastname .. ' ❌',
                                cid = Player3.PlayerData.citizenid
                            }
                        end
                    else

                    end
                end
            end
        end
        cb(Players)
    else
        cb(false)
    end
end)

RegisterNetEvent("Pug:Server:PurchaseCokeLaboratory", function(LabCoords)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local price = Config.CokeLabCost
    local RouteBucket = tonumber(math.random(1000,9999))
    if not CehckIsMemberOfCokeLab(src) then
        if Player ~= nil then
            local cid = Player.PlayerData.citizenid
            local bankBalance = Player.PlayerData.money.cash
            if Config.Currency == "bank" then
                bankBalance = Player.PlayerData.money.bank
            end
            if bankBalance >= price then
                Player.RemoveMoney(Config.Currency, price, "player-purchace")
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["PurchaseLaboratory"], 'success')
                MySQL.insert.await('INSERT INTO pug_cokebusiness (citizenid, bucketid, upgrades, access, membercap, supplies, product, password, lablocation, plane) VALUES (?,?,?,?,?,?,?,?,?,?)', {
                    cid, RouteBucket, 0, json.encode({cid}), 1, 0, 0, RouteBucket, json.encode(vector3(LabCoords.x, LabCoords.y, LabCoords.z)), Config.CokePlanes[0].model
                })
                -- TriggerClientEvent("Pug:Client:CutScene",src, RouteBucket)
            else
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["YouAreMissing"].."$"..price - bankBalance, 'error')
            end
        end
    else
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["AlreadyApartOfLab"], 'error')
    end
end)

RegisterNetEvent("Pug:server:UpdateDrugProductProcessed", function()
    local src = source
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared then
        local Owner = Shared.citizenid
        if tonumber(Shared.supplies) >= Config.AmountOfDrugsToProcess then
            local currentSupplies = tonumber(Shared.supplies)
            local drugsToProcess = Config.AmountOfDrugsToProcess
            local remainingSupplies = math.ceil(currentSupplies - drugsToProcess)
            local currentProduct = tonumber(Shared.product)
            local updatedProductAmount = math.ceil(currentProduct + drugsToProcess)
            local processedDrugs2
            if Shared.upgrades == 1 then
                local productPercentIncrease = Config.ProductPercentIncreaseUpgrade1
                processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
                remainingSupplies = math.ceil(currentSupplies - processedDrugs2)
                updatedProductAmount = math.ceil(currentProduct + processedDrugs2)
            elseif Shared.upgrades == 2 then
                local productPercentIncrease = Config.ProductPercentIncreaseUpgrade2
                processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
                remainingSupplies = math.ceil(currentSupplies - processedDrugs2)
                updatedProductAmount = math.ceil(currentProduct + processedDrugs2)
            elseif Shared.upgrades >= 3 then
                local productPercentIncrease = Config.ProductPercentIncreaseUpgrade3
                processedDrugs2 = math.ceil(drugsToProcess + (drugsToProcess * productPercentIncrease))
                remainingSupplies = math.ceil(currentSupplies - processedDrugs2)
                updatedProductAmount = math.ceil(currentProduct + processedDrugs2)
            end
            if Config.Debug then
                print(remainingSupplies, "remainingSupplies")
                print(updatedProductAmount, "updatedProductAmount")
            end
            MySQL.update('UPDATE pug_cokebusiness SET supplies = ? WHERE citizenid = ?', { remainingSupplies, Owner })
            MySQL.update('UPDATE pug_cokebusiness SET product = ? WHERE citizenid = ?', { updatedProductAmount, Owner })
            UpdateEveryoneInLab(src)
            if processedDrugs2 then
                for _, v in pairs(json.decode(Shared.access)) do
                    local Player = Config.FrameworkFunctions.GetPlayer(v, true)
                    if Player ~= nil then
                        TriggerClientEvent("Pug:client:ShowDrugJobNotify", v, "+ "..processedDrugs2.." "..Config.LangT["InTheLab"])
                    end
                end
            else
                for _, v in pairs(json.decode(Shared.access)) do
                    local Player = Config.FrameworkFunctions.GetPlayer(v, true)
                    if Player ~= nil then
                        TriggerClientEvent("Pug:client:ShowDrugJobNotify", v, "+ "..drugsToProcess.." "..Config.LangT["InTheLab"])
                    end
                end
            end
            Wait(2000)
            for _, v in pairs(json.decode(Shared.access)) do
                local Player = Config.FrameworkFunctions.GetPlayer(v, true)
                if Player ~= nil then
                    TriggerClientEvent("Pug:client:ShowDrugJobNotify", v, updatedProductAmount.." "..Config.LangT["InTheLab"])
                end
            end
        else
            -- TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["NoSuppliesInLab"], "error")
        end
    end
end)
RegisterNetEvent("Pug:server:AddSuppliesToLab", function(AddedSupplies)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        local Shared = CehckIsMemberOfCokeLab(src)
        if Shared then
            Player.RemoveItem(Config.ProductSupplies, AddedSupplies)
            if Framework == "QBCore" then
                TriggerClientEvent('inventory:client:ItemBox', src, FWork.Shared.Items[Config.ProductSupplies], "remove", tonumber(AddedSupplies))
            end
            local Owner = Shared.citizenid
            local CurrentSupplies = tonumber(Shared.supplies)
            local AddedSupplies = tonumber(AddedSupplies) * math.random(Config.CokeBrickToSuppliesTanslation.Min,Config.CokeBrickToSuppliesTanslation.Max)
            local NewSupplies = math.ceil(CurrentSupplies + AddedSupplies)
            MySQL.update('UPDATE pug_cokebusiness SET supplies = ? WHERE citizenid = ?', { NewSupplies, Owner })
            UpdateEveryoneInLab(src)
            TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, "+ "..tonumber(AddedSupplies).." "..Config.LangT["SuppliesAdded"])
            Wait(2000)
            TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, " "..tonumber(NewSupplies).." "..Config.LangT["TotalSupplies"])
        end
    end
end)
RegisterNetEvent("Pug:server:RemoveProductFromLab", function(RemovedProduct)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        local Shared = CehckIsMemberOfCokeLab(src)
        if Shared then
            if tonumber(Shared.product) >= tonumber(RemovedProduct) then
                Player.AddItem(Config.FinalDrugProduct, RemovedProduct)
                if Framework == "QBCore" then
                    TriggerClientEvent('inventory:client:ItemBox', src, FWork.Shared.Items[Config.FinalDrugProduct], "remove", tonumber(RemovedProduct))
                end
                local Owner = Shared.citizenid
                local CurrentProduct = tonumber(Shared.product)
                local NewProduct = math.ceil(CurrentProduct - tonumber(RemovedProduct))
                MySQL.update('UPDATE pug_cokebusiness SET product = ? WHERE citizenid = ?', { NewProduct, Owner })
                UpdateEveryoneInLab(src)
                TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, "- "..tonumber(RemovedProduct).." "..Config.LangT["ProductRemoved"])
            else
                TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["NotEnough"], "error")
            end
        end
    end
end)
RegisterNetEvent("Pug:Server:UpgradeCokeLab", function(RemovedProduct)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared then
        if Player ~= nil then
            if tonumber(Shared.upgrades) < 3 then
                if tonumber(Shared.upgrades) == 0 then
                    if tonumber(Shared.supplies) < Config.UpgradeCokeLabRequirement1 then
                        TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement1.." "..Config.LangT["SuppliesNeeded"], 'error')
                        return
                    end
                elseif tonumber(Shared.upgrades) == 1 then
                    if tonumber(Shared.supplies) < Config.UpgradeCokeLabRequirement2 then
                        TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement2.." "..Config.LangT["SuppliesNeeded"], 'error')
                        return
                    end
                elseif tonumber(Shared.upgrades) == 2 then 
                    if tonumber(Shared.supplies) < Config.UpgradeCokeLabRequirement3 then
                        TriggerClientEvent("Pug:client:ShowDrugJobNotify", src, Config.LangT["YouNeed"].. " ".. Config.UpgradeCokeLabRequirement3.." "..Config.LangT["SuppliesNeeded"], 'error')
                        return
                    end
                end
                local cid = Player.PlayerData.citizenid
                local bankBalance = Player.PlayerData.money.cash
                if Config.Currency == "bank" then
                    bankBalance = Player.PlayerData.money.bank
                end
                local Owner = Shared.citizenid
                local price = Config.UpgradeCokeLabCost * (tonumber(Shared.upgrades) + 1)
                local NewUpgrade = tonumber(Shared.upgrades) + 1
                if bankBalance >= price then
                    Player.RemoveMoney(Config.Currency, price, "player-purchace")
                    MySQL.update('UPDATE pug_cokebusiness SET upgrades = ? WHERE citizenid = ?', { NewUpgrade, Owner })
                    TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["SuccessUpgrade"], 'success')
                    Wait(500)
                    local Shared2 = CehckIsMemberOfCokeLab(src)
                    if Shared2 then
                        for _, v in pairs(json.decode(Shared2.access)) do
                            local Player = Config.FrameworkFunctions.GetPlayer(v, true)
                            if Player ~= nil then
                                TriggerClientEvent("Pug:cleint:UpdateAllLabInfo", Player.PlayerData.source, Shared2)
                                TriggerClientEvent("Pug:cleint:UpdateCokeLabPeds", Player.PlayerData.source, Shared2)
                            end
                        end
                    end
                    Wait(500)
                    TriggerClientEvent("Pug:Client:DrugLaptopMenu", src)
                else
                    TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["YouAreMissing"].."$"..price - bankBalance, 'error')
                    TriggerClientEvent("Pug:Client:DrugLaptopMenu", src)
                end
            else
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["MaxedOut"], 'error')
                TriggerClientEvent("Pug:Client:DrugLaptopMenu", src)
            end
        end
    else
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["LabNotFound"], 'error')
    end
end)
RegisterNetEvent("Pug:Server:UpgradeCokeLabMember", function()
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared then
        if Player ~= nil then
            if tonumber(Shared.membercap) < Config.MaxMembers then
                local cid = Player.PlayerData.citizenid
                local bankBalance = Player.PlayerData.money.cash
                if Config.Currency == "bank" then
                    bankBalance = Player.PlayerData.money.bank
                end
                local Owner = Shared.citizenid
                local price = Config.UpgradeCokeLabMembersCost * tonumber(Shared.membercap)
                local NewUpgrade = tonumber(Shared.membercap) + 1
                if bankBalance >= price then
                    Player.RemoveMoney(Config.Currency, price, "player-purchace")
                    MySQL.update('UPDATE pug_cokebusiness SET membercap = ? WHERE citizenid = ?', { NewUpgrade, Owner })
                    TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["SuccessUpgradeMembers"], 'success')
                    UpdateEveryoneInLab(src)
                    Wait(500)
                    TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
                else
                    TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["YouAreMissing"].."$"..price - bankBalance, 'error')
                    TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
                end
            else
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["MaxedOut"], 'error')
                TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
            end
        end
    else
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["LabNotFound"], 'error')
        TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
    end
end)
RegisterNetEvent("Pug:server:AddMemberToCokeLab", function(ID)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local Player2 = Config.FrameworkFunctions.GetPlayer(ID)
    if Player ~= nil then
        if Player2 ~= nil then
            local OtherPlayerCID = Player2.PlayerData.citizenid
            local Shared = CehckIsMemberOfCokeLab(src)
            if tonumber(#json.decode(Shared.access)) < Config.MaxMembers then
                local OtherOwned = false
                local check = CehckIsMemberOfCokeLab(ID)
                if check then
                    OtherOwned = true
                    TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["AlreadyApartOfLabMember"], 'error')
                    return
                end
                Wait(100)
                if not OtherOwned then
                    if Shared then
                        local Owner = Shared.citizenid
                        local Players = {}
                        for _, v in pairs(json.decode(Shared.access)) do
                            if v == OtherPlayerCID then 
                                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["AlreadyAMember"], 'error')
                                TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
                                return
                            end
                        end
                        Players[#Players+1] = OtherPlayerCID
                        for _, v in pairs(json.decode(Shared.access)) do
                            Players[#Players+1] = v
                        end
                        Wait(100)
                        MySQL.update('UPDATE pug_cokebusiness SET access = ? WHERE citizenid = ?', { json.encode( Players ), Owner })
                        Wait(100)
                        UpdateEveryoneInLab(src)
                        Wait(100)
                        TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
                        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["SuccessAddedMember"], 'success')
                    end
                end
            else
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["MaxCapacity"], 'error')
                TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
            end
        else
            TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["NotInCity"], 'error')
            TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
        end
    end
end)
RegisterNetEvent("Pug:server:ChangeCokeLabPassword", function(password)
    local src = source
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared then
        local Owner = Shared.citizenid
        if Config.Debug then
            print(password, Owner)
        end
        MySQL.update('UPDATE pug_cokebusiness SET password = ? WHERE citizenid = ?', {password, Owner })
        Wait(100)
        UpdateEveryoneInLab(src)
        Wait(100)
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["ChangedPassword"].. password, 'success')
        TriggerClientEvent("Pug:Client:DrugLaptopMenu", src)
    else
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["LabNotFound"], 'error')
    end
end)
RegisterNetEvent("Pug:Server:EnterCokeLabPassword", function(password)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        local result = MySQL.query.await('SELECT * FROM pug_cokebusiness WHERE password = ?', { password })
        if result[1] ~= nil then
            local IsCop = false
            if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "troopers" 
                or Player.PlayerData.job.name == "rangers" or Player.PlayerData.job.name == "bcso") then
                IsCop = true
            end
            TriggerClientEvent("Pug:client:EnterCokeLab", src, result[1], true, IsCop)
        else
            TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["WrongPassword"], 'error')
        end
    end
end)
RegisterNetEvent("Pug:server:UpgradeCokePlane", function(Data)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    local Shared = CehckIsMemberOfCokeLab(src)
    if Shared then
        if Player ~= nil then
            local cid = Player.PlayerData.citizenid
            local bankBalance = Player.PlayerData.money.cash
            if Config.Currency == "bank" then
                bankBalance = Player.PlayerData.money.bank
            end
            local Owner = Shared.citizenid
            local price = Config.CokePlanes[Data].price
            local NewUpgrade = Config.CokePlanes[Data].model
            if bankBalance >= price then
                Player.RemoveMoney(Config.Currency, price, "player-purchace")
                MySQL.update('UPDATE pug_cokebusiness SET plane = ? WHERE citizenid = ?', { NewUpgrade, Owner })
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["SuccessUpgradeAirPlane"] .. " ".. Config.CokePlanes[Data].model, 'success')
                UpdateEveryoneInLab(src)
                Wait(500)
                TriggerClientEvent("Pug:client:ManagePlanesMenu", src)
            else
                TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["YouAreMissing"].."$"..price - bankBalance, 'error')
                TriggerClientEvent("Pug:client:ManagePlanesMenu", src)
            end
        end
    else
        TriggerClientEvent('Pug:client:ShowDrugJobNotify', src, Config.LangT["LabNotFound"], 'error')
        TriggerClientEvent("Pug:client:ManagePlanesMenu", src)
    end
end)
RegisterNetEvent("Pug:server:ShudDownCokeLabForever", function(LabData)
    local src = source
    local result = MySQL.query.await('SELECT * FROM pug_cokebusiness', {})
    if result[1] ~= nil then
        for i = 1, (#result), 1 do
            if tostring(result[i].citizenid) == tostring(LabData.citizenid) then
                local keyholders = json.decode(result[i].access)
                if keyholders ~= nil then
                    for _,v in pairs(keyholders) do
                        local Player = Config.FrameworkFunctions.GetPlayer(v, true)
                        if Player ~= nil then
                            if Player.PlayerData.source == src then
                            else
                                TriggerClientEvent('Pug:client:ShowDrugJobNotify', Player.PlayerData.source, Config.LangT["YourCokeLabHasBeenRaided"], 'error')
                                TriggerClientEvent("Pug:client:RemoveAllInsideCokeData", Player.PlayerData.source)
                            end
                        end
                    end
                end
                TriggerClientEvent("Pug:client:RemoveAllInsideCokeData", src)
                MySQL.Async.execute('DELETE FROM pug_cokebusiness WHERE citizenid = ?', {LabData.citizenid})
                break
            end
        end
    end
end)
RegisterNetEvent("Pug:server:TogglePlayerCokeLabBucket", function(Bool)
    local src = source
    if Bool then
        SetPlayerRoutingBucket(src, Bool)
    else
        SetPlayerRoutingBucket(src, 0)
    end
end)
RegisterNetEvent("Pug:Server:RemoveCokeLabMember", function(data)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        Wait(100)
        local bankBalance = Player.PlayerData.money.cash
        if Config.Currency == "bank" then
            bankBalance = Player.PlayerData.money.bank
        end
        if bankBalance >= Config.KickMemberPrice then
            local Shared = CehckIsMemberOfCokeLab(src)
            if Shared ~= nil then
                local Owner = Shared.citizenid
                if not Config.CanRemoveLabOwner then
                    if Owner == data.cid then
                        TriggerClientEvent('client:ShowDrugJobNotify', src,  Config.LangT["CantRemoveOwner"], 'error')
                        return
                    end
                end
                Player.RemoveMoney(Config.Currency, Config.KickMemberPrice, "player-purchace")
                local Players = {}
                for _, v in pairs(json.decode(Shared.access)) do
                    if data.cid == v then
                    else
                        Players[#Players+1] = v
                    end
                end
                Wait(100)
                MySQL.update('UPDATE pug_cokebusiness SET access = ? WHERE citizenid = ?', { json.encode( Players ), Owner })
                Wait(100)
                UpdateEveryoneInLab(src)
                Wait(100)
                local Player2 = Config.FrameworkFunctions.GetPlayer(data.cid, true)
                if Player2 ~= nil then
                    TriggerClientEvent("Pug:client:RemoveAllInsideCokeData", Player2.PlayerData.source)
                end
                TriggerClientEvent("Pug:client:ManageMembersCokeLab", src)
            end
        else
            TriggerClientEvent('client:ShowDrugJobNotify', src,  Config.LangT["YouAreMissing"].."$"..Config.KickMemberPrice - bankBalance, 'error')
        end
    end
end)

-- COKELAB INFO ITEM
RegisterNetEvent("Pug:server:GivePlayerCodeItem", function(street1, street2, password)
    local src = source
    local Player = Config.FrameworkFunctions.GetPlayer(src)
    if Player ~= nil then
        local info = {
            firstname = Player.PlayerData.charinfo.firstname,
            lastname = Player.PlayerData.charinfo.lastname,
            Location = street1.." "..street2,
            Password = password,
        }
        Player.AddItem("cokelabnote", 1, info)
    end
end)

if Framework == "QBCore" then
    FWork.Functions.CreateUseableItem("cokelabnote", function(source, item)
        local src = source
        if Config.InventoryType == "ox" or Config.InventoryType == "qs" then
            TriggerClientEvent('chat:addMessage', src,  {
                template = '<div class="chat-message advert"><div class="chat-message-body"><strong>[Coke Lab Note]</strong><br> <strong>Owner:</strong> {0} {1}<br><strong>Lab location:</strong> {2} <br><strong>Lab password:</strong> {3}',
                args = {
                    item.metadata.firstname,
                    item.metadata.lastname,
                    item.metadata.Location,
                    item.metadata.Password
                }
            })
        else
            TriggerClientEvent('chat:addMessage', src,  {
                template = '<div class="chat-message advert"><div class="chat-message-body"><strong>[Coke Lab Note]</strong><br> <strong>Owner:</strong> {0} {1}<br><strong>Lab location:</strong> {2} <br><strong>Lab password:</strong> {3}',
                args = {
                    item.info.firstname,
                    item.info.lastname,
                    item.info.Location,
                    item.info.Password
                }
            })
        end
    end)
elseif Framework == "ESX" then
    FWork.RegisterUsableItem("cokelabnote", function(source, item)
        local src = source
        TriggerClientEvent('chat:addMessage', src,  {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>[Coke Lab Note]</strong><br> <strong>Owner:</strong> {0} {1}<br><strong>Lab location:</strong> {2} <br><strong>Lab password:</strong> {3}',
            args = {
                item.metadata.firstname,
                item.metadata.lastname,
                item.metadata.Location,
                item.metadata.Password
            }
        })
	end)
end
-- END