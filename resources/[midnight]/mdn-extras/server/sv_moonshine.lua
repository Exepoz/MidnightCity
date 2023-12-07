local QBCore = exports['qb-core']:GetCoreObject()
-- local time = os.time() - math.random(1200, 4800)
local moonshineTime = os.time() - 3600
GlobalState.LowMoonshine = moonshineTime

-- Wine
local WineVats = {
    {time = 0, wine = "None"},
    {time = 0, wine = "None"},
    {time = 0, wine = "None"}
}
local WineBarrels = {
    {amount = 0, wine = "None"},
    {amount = 0, wine = "None"},
}
local Winery = {WineVats = WineVats, WineBarrels = WineBarrels}
GlobalState.WineVats = Winery.WineVats
GlobalState.WineBarrels = Winery.WineBarrels

CreateThread(function()
	local LoadJson = json.decode(LoadResourceFile(GetCurrentResourceName(), 'winevats.json'))
    Winery.WineVats = LoadJson['WineVats']
    Winery.WineBarrels = LoadJson['WineBarrels']
	GlobalState.WineVats = Winery.WineVats
	GlobalState.WineBarrels = Winery.WineBarrels
end)

RegisterNetEvent("mdn-extras:server:depositGrapes", function(machine, wine)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    if Winery.WineVats[machine].wine ~= "None" then return end
    local recipe = Config.Moonshine.WineRecipes[wine]
    local grapes = recipe['mplum'] and 'mplum' or
                    recipe['mgrape'] and 'mgrape' or
                    recipe['mgrape2'] and 'mgrape2' or
                    recipe['mgrape3'] and 'mgrape3' or
                    recipe['mgrape4'] and 'mgrape4'
    local grapesItem = Player.Functions.GetItemByName(grapes)
    local sugar = Player.Functions.GetItemByName('sugar')
    local yeast = Player.Functions.GetItemByName('yeast')

    if not grapesItem or grapesItem.amount < recipe[grapes] or not sugar or sugar.amount < recipe['sugar'] or not yeast or yeast.amount < recipe['yeast']
    then TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough ingredients to fill the vat!', 'error', 3000) return end

    Player.Functions.RemoveItem(grapes, recipe[grapes])
    Player.Functions.RemoveItem('sugar', recipe['sugar'])
    Player.Functions.RemoveItem('yeast', recipe['yeast'])
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[grapes], "remove",  recipe[grapes])
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['sugar'], "remove",  recipe['sugar'])
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['yeast'], "remove",  recipe['yeast'])

	Winery.WineVats[machine].wine = wine
	Winery.WineVats[machine].time = os.time()
	GlobalState.WineVats = Winery.WineVats
	TriggerClientEvent('QBCore:Notify', src, 'The fermentation will be done in 36 hours.', 'success', 5000)
	SaveResourceFile(GetCurrentResourceName(), "winevats.json", json.encode(Winery), -1)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nVat :** #"..machine.."\nWine : "..wine
    TriggerEvent("qb-log:server:CreateLog", "vineyard", "Fermentation Started", "blue", {ply = GetPlayerName(src), txt = logString})
end)

RegisterNetEvent("mdn-extras:server:takeWine", function(machine)
	local src = source
	local time = Winery.WineVats[machine].time
	if time+129600 - os.time() > 0 then TriggerClientEvent('QBCore:Notify', src, 'The fermentation isn\'t done...', 'error', 3000) return end
	local wine = Winery.WineVats[machine].wine
	local Player = QBCore.Functions.GetPlayer(src)
    if not Player.Functions.RemoveItem('empty_barrel', 3) then TriggerClientEvent('QBCore:Notify', src, 'You need 3 empty barrels to empty the vat.', 'error', 3000) return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_barrel'], "remove", 3)
    local info = {wine = wine, grapeLabel = Config.Moonshine.WineRecipes[wine].label}
    for i = 1, 3 do
	    Player.Functions.AddItem('wine_barrel', 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine_barrel'], "add", 1)
    end

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString =  "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nVat :** #"..machine.."\nWine : "..wine
    TriggerEvent("qb-log:server:CreateLog", "vineyard", "Fermentation Finished", "blue", {ply = GetPlayerName(src), txt = logString})

	Winery.WineVats[machine].wine = "None"
	Winery.WineVats[machine].time = 0
	GlobalState.WineVats = Winery.WineVats
	SaveResourceFile(GetCurrentResourceName(), "winevats.json", json.encode(Winery), -1)
end)

RegisterNetEvent("mdn-extras:server:pourBottle", function(barrel)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if GlobalState.WineBarrels[barrel].amount == 0 then TriggerClientEvent('QBCore:Notify', src, 'The Barrel is empty!', 'error', 3000) return end
    local info = {drinks = 5}
    if Player.Functions.AddItem(Winery.WineBarrels[barrel].wine, 1, false, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Winery.WineBarrels[barrel].wine], "add", 1)
        Winery.WineBarrels[barrel].amount =  Winery.WineBarrels[barrel].amount - 1
        if Winery.WineBarrels[barrel].amount == 0 then Winery.WineBarrels[barrel].wine = "None" end
        GlobalState.WineBarrels = Winery.WineBarrels
        SaveResourceFile(GetCurrentResourceName(), "winevats.json", json.encode(Winery), -1)
    else TriggerClientEvent('QBCore:Notify', src, 'You can\'t carry a bottle!', 'error', 3000) end
end)

RegisterNetEvent("mdn-extras:server:drainBarrel", function(barrel)
	local src = source
    Winery.WineBarrels[barrel].amount = 0
    Winery.WineBarrels[barrel].wine = 'None'
    GlobalState.WineBarrels = Winery.WineBarrels
	SaveResourceFile(GetCurrentResourceName(), "winevats.json", json.encode(Winery), -1)
    TriggerClientEvent('QBCore:Notify', src, 'You drained the serving barrel.', 'error', 3000)
end)

RegisterNetEvent("mdn-extras:server:fillBarrel", function(barrel, amt, wine)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if GlobalState.WineBarrels[barrel].amount > 0 then TriggerClientEvent('QBCore:Notify', src, 'The Barrel is already filled!', 'error', 3000) return end
    local barrels = Player.Functions.GetItemsByName('wine_barrel')
    for _, v in pairs(barrels) do
        if Player.PlayerData.items[v.slot].info.wine == wine and amt > 0 then
            Winery.WineBarrels[barrel].wine = wine
            Player.Functions.RemoveItem('wine_barrel', 1, v.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wine_barrel'], "remove", 1)
            if math.random(5) > 1 then
                Player.Functions.AddItem('empty_barrel', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_barrel'], "add", 1)
            else TriggerClientEvent('QBCore:Notify', src, 'One of your barrel broke in the process!', 'error', 3000) end
            Winery.WineBarrels[barrel].amount = Winery.WineBarrels[barrel].amount + 10
            amt = amt - 1
            GlobalState.WineBarrels = Winery.WineBarrels
            SaveResourceFile(GetCurrentResourceName(), "winevats.json", json.encode(Winery), -1)
            if amt == 0 then break end
        end
    end
end)
--- Moonsh
--- Moonshine

RegisterNetEvent("mdn-extras:client:takeLowMoonshine", function()
	local src = source
	if moonshineTime+3600 - os.time() > 0 then TriggerClientEvent('QBCore:Notify', src, 'The moonshine isn\'t ready yet...', 'error', 3000) return end
	local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.AddItem('moonshine_low', 3)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['moonshine_low'], "add", 3)

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
    local logString =  "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\nCID : "..Player.PlayerData.citizenid.."\n\nGrabbed Low-Tier Moonshine"
    TriggerEvent("qb-log:server:CreateLog", "moonshine", "Grabbed Low-Tier.", "green", {ply = GetPlayerName(src), txt = logString})
    moonshineTime = os.time()
    GlobalState.LowMoonshine = moonshineTime
end)

QBCore.Functions.CreateUseableItem('cabalspec', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info == "" or not item.info.drinks then item.info = {drinks = 5} end
        Player.PlayerData.items[item.slot].info.drinks = item.info.drinks - 1
        if Player.PlayerData.items[item.slot].info.drinks <= 0 then
            Player.Functions.RemoveItem('cabalspec', 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['cabalspec'], "remove", 1)
        else
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        TriggerClientEvent('mdn-extras:client:drinkWine', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('uncork', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info == "" or not item.info.drinks then item.info = {drinks = 5} end
        Player.PlayerData.items[item.slot].info.drinks = item.info.drinks - 1
        if Player.PlayerData.items[item.slot].info.drinks <= 0 then
            Player.Functions.RemoveItem('uncork', 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['uncork'], "remove", 1)
        else
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        TriggerClientEvent('mdn-extras:client:drinkWine', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('wineotaur', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info == "" or not item.info.drinks then item.info = {drinks = 5} end
        Player.PlayerData.items[item.slot].info.drinks = item.info.drinks - 1
        if Player.PlayerData.items[item.slot].info.drinks <= 0 then
            Player.Functions.RemoveItem('wineotaur', 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['wineotaur'], "remove", 1)
        else
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        TriggerClientEvent('mdn-extras:client:drinkWine', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('grapescape', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info == "" or not item.info.drinks then item.info = {drinks = 5} end
        Player.PlayerData.items[item.slot].info.drinks = item.info.drinks - 1
        if Player.PlayerData.items[item.slot].info.drinks <= 0 then
            Player.Functions.RemoveItem('grapescape', 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['grapescape'], "remove", 1)
        else
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        TriggerClientEvent('mdn-extras:client:drinkWine', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('sauvignon', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        if item.info == "" or not item.info.drinks then item.info = {drinks = 5} end
        Player.PlayerData.items[item.slot].info.drinks = item.info.drinks - 1
        if Player.PlayerData.items[item.slot].info.drinks <= 0 then
            Player.Functions.RemoveItem('sauvignon', 1, item.slot)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['sauvignon'], "remove", 1)
        else
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        TriggerClientEvent('mdn-extras:client:drinkWine', source, item.name)
    end
end)

QBCore.Functions.CreateCallback("mdn-extras:server:moonshineTime", function(_, cb) cb(os.time()) end)

-- Halloween Candies

QBCore.Functions.CreateUseableItem('hard_candyr', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        Player.Functions.RemoveItem('hard_candyr', 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['hard_candyr'], "remove", 1)
        TriggerClientEvent('mdn-extras:client:eatCandy', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('hard_candyg', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        Player.Functions.RemoveItem('hard_candyg', 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['hard_candyg'], "remove", 1)
        TriggerClientEvent('mdn-extras:client:eatCandy', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('candy_corn', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        Player.Functions.RemoveItem('candy_corn', 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['candy_corn'], "remove", 1)
        TriggerClientEvent('mdn-extras:client:eatCandy', source, item.name)
    end
end)

QBCore.Functions.CreateUseableItem('purple_sweets', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        Player.Functions.RemoveItem('purple_sweets', 1, item.slot)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['purple_sweets'], "remove", 1)
        TriggerClientEvent('mdn-extras:client:eatCandy', source, item.name)
    end
end)