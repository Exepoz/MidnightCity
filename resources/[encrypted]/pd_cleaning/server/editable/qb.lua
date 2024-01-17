 if Config.framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()

    function HasItem(player, item)
        local xPlayer = QBCore.Functions.GetPlayer(player)

        return xPlayer.Functions.GetItemByName(item)
    end

    function IsPolice(player)
        local xPlayer = QBCore.Functions.GetPlayer(player)
        if not xPlayer then
            return false
        end

        local job = xPlayer.PlayerData.job

        return Contains(Config.policeJobNames, job.name)
    end

    function GetPoliceCount()
        local currentOfficers = 0
        for _, playerId in ipairs(GetPlayers()) do
            playerId = tonumber(playerId)
            if IsPolice(playerId) then
                currentOfficers = currentOfficers + 1
            end
        end
        return currentOfficers
    end

    function AddMoney(player, amount)
        local xPlayer = QBCore.Functions.GetPlayer(player)

        if not xPlayer then
            return false
        end

        xPlayer.Functions.AddMoney(Config.payout_account, amount)
    end

    function GetValuable(player, itemModel)
        local selectedItem
        local xPlayer = QBCore.Functions.GetPlayer(player)

        for k in pairs(Config.valuableItems) do
            local model = Config.valuableItems[k].model

            if GetHashKey(model) == itemModel then
                selectedItem = Config.valuableItems[k]
            end
        end

        if selectedItem ~= nil then
            xPlayer.Functions.AddItem(selectedItem.item, 1)
            SendNotification(L('You have stolen ~y~') .. selectedItem.label)

        end
    end

    function GetIdentifier(player)
        local identifier = QBCore.Functions.GetIdentifier(player, 'license')

        return identifier
    end

    function SellValuables(player, itemID)
        local xPlayer = QBCore.Functions.GetPlayer(player)
        local items = xPlayer.PlayerData.items
        local item = itemID
        local itemCount = 0

        for k in pairs(items) do
            local itemName = xPlayer.PlayerData.items[k].name
            if itemName == item.item then
                itemCount = xPlayer.PlayerData.items[k].amount
            end
        end

        if itemCount > 0 then
            xPlayer.Functions.RemoveItem(item.item, itemCount)
            xPlayer.Functions.AddMoney(Config.sellLocations[1].useAccount, item.price * itemCount)
            SendNotification(L('You have sold ') .. L('~g~') .. itemCount .. L('x ') .. item.label .. L('~w~') .. L('for') .. L(' ~g~') .. item.price * itemCount .. L('$'))
        end
    end
end
