local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("cr-forgery:server:ForgeCard", function(license, citizenid, firstname, lastname, birthday, gender, nationality)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licInfo = Config.Licences[license]
    if licInfo.ForgingCost > 0 and not Player.Functions.RemoveMoney(licInfo.MoneyType, Config.Licences[license].ForgingCost) then FSUtils.Notif(3, Lcl("notif_NotEnoughMoney"), Lcl("notif_Title"), source) return end
    if #licInfo.RequiredItems > 0 then
        for _, v in pairs(Config.Licences[license].RequiredItems) do
            local item = Player.Functions.GetItemByName(v.item, v.amount)
            if item ~= nil and item.amount >= v.amount then
                Player.Functions.RemoveItem(v.item, v.amount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.item], 'remove', v.amount)
            end
        end
    end
    local info = {}
    info.citizenid = citizenid
    info.firstname = firstname
    info.lastname = lastname
    info.birthdate = birthday
    info.gender = gender
    info.nationality = nationality or "Unknown"
    info.type = licInfo.Description
    info.forged = true

    local licenseItem = licInfo.Card

    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[licenseItem], 'add')
    Player.Functions.AddItem(licenseItem, 1, nil, info)

    if Config.UseRep then
    end

    if Config.Logs then
        TriggerEvent('qb-log:server:CreateLog', 'identificationforgery', Lcl('forgery_title'), 'orange', "**"..Lcl('logs_desc', GetPlayerName(Player.PlayerData.source)).."\n"..license.."\nInfo : **\n"..Lcl('logs_CID').." : **"..info.citizenid.."\n**"..Lcl('input_FirstName').." : "..info.firstname.." "..info.lastname.."\nDOB : "..info.birthdate.."\nNationality : "..info.nationality)
    end
end)

QBCore.Functions.CreateCallback("cr-forgery:server:CheckRequirements", function(source, cb, license)
    local HasItm = true
    local HasMon = true
    local Player = QBCore.Functions.GetPlayer(source)
    local License = Config.Licences[license]
    if License.ForgingCost > 0 and Player.PlayerData.money[License.MoneyType] < License.ForgingCost then
        FSUtils.Notif(3, Lcl("notif_NotEnoughMoney"), Lcl("notif_Title"), source)
        HasMon = false
    end
    if #License.RequiredItems > 0 then
        for _, v in pairs(License.RequiredItems) do
            local item = Player.Functions.GetItemByName(v.item, v.amount)
            if not item or item.amount < v.amount then
                FSUtils.Notif(3, Lcl("notif_MissingItem"), Lcl("notif_Title"), source)
                HasItm = false
                break
            end
        end
    end
    cb(HasMon and HasItm)
end)
