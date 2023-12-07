local QBCore = exports['qb-core']:GetCoreObject()
local ClosedShops = {}
local looping

local function ClosedShopsNotif(notifType, message, title)
	if Config.Framework.Notifications == 'QBCore' then
		if notifType == 1 then
			QBCore.Functions.Notify(message, 'success')
		elseif notifType == 2 then
			QBCore.Functions.Notify(message, 'primary')
		elseif notifType == 3 then
			QBCore.Functions.Notify(message, 'error')
		end
	elseif Config.Framework.Notifications == "okok" then
		if notifType == 1 then
			exports['okokNotify']:Alert(title, message, 3000, 'success') --https://samuels-development.tebex.io/
		elseif notifType == 2 then
			exports['okokNotify']:Alert(title, message, 3000, 'info')
		elseif notifType == 3 then
			exports['okokNotify']:Alert(title, message, 3000, 'error')
		end
	elseif Config.Framework.Notifications == "mythic" then
		if notifType == 1 then
			exports['mythic_notify']:DoHudText('success', message)
		elseif notifType == 2 then
			exports['mythic_notify']:DoHudText('inform', message)
		elseif notifType == 3 then
			exports['mythic_notify']:DoHudText('error', message)
		end
    elseif Config.Framework.Notifications == "tnj" then
        if notifType == 1 then
            exports['tnj-notify']:Notify(message, 'success', 3000)
		elseif notifType == 2 then
            exports['tnj-notify']:Notify(message, 'primary', 3000)
		elseif notifType == 3 then
            exports['tnj-notify']:Notify(message, 'error', 3000)
		end
	elseif Config.Framework.Notifications == 'chat' then
        if notifType == 1 then
            TriggerEvent('chatMessage', message)
		elseif notifType == 2 then
            TriggerEvent('chatMessage', message)
		elseif notifType == 3 then
            TriggerEvent('chatMessage', message)
		end
	end
end

local function EnsurePedModel(pedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
        if Config.Framework.Debug then
            print('Constant Development Closed Shops PED Requested')
        end
    end
end

local function CreatePedAtCoords(pedModel, coords, scenario)
    if type(pedModel) == "string" then
        pedModel = GetHashKey(pedModel)
    end
    EnsurePedModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 1, coords.w, false, false)
    TaskStartScenarioInPlace(ped, scenario, -1, true) -- Task Scenario
    FreezeEntityPosition(ped, true) -- Freeze Position
    SetEntityVisible(ped, true) -- Toggles Visibility
    SetEntityInvincible(ped, true) -- Invicible
    PlaceObjectOnGroundProperly(ped) -- Ground Check
    SetBlockingOfNonTemporaryEvents(ped, true) -- Blocking
    print(coords)
    if Config.Framework.Debug then
        print('Constant Development Closed Shops PED Activated')
    end
    return ped
end

local function CreateProp(propCoords, propModel)
	local coords = propCoords
	PropModel = propModel
	RequestModel(PropModel)
	while not HasModelLoaded(PropModel) do
		Wait(3)
	end
	PropObject = CreateObject(PropModel, coords.x, coords.y, coords.z - 1, false, false, false)
	PlaceObjectOnGroundProperly(PropObject)
    FreezeEntityPosition(PropObject, true)
    SetEntityHeading(PropObject, coords.w)
	SetEntityInvincible(PropObject, true)
    return PropObject
end

local function CreateClosedShopBlips(blipCoords, blipSprite, blipDisplay, blipScale, blipColour, blipName)
	local Blip = AddBlipForCoord(blipCoords)
	SetBlipSprite(Blip, blipSprite)
	SetBlipDisplay(Blip, blipDisplay)
	SetBlipScale(Blip, blipScale)
	SetBlipColour(Blip, blipColour)
	SetBlipAsShortRange(Blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(blipName)
	EndTextCommandSetBlipName(Blip)
    if Config.Framework.Debug then
        print('Constant Development Closed Shops Blip Activated')
    end
end

-- Shop Menu
RegisterNetEvent('cr-closedshops:client:SystemStoreBasic')
AddEventHandler("cr-closedshops:client:SystemStoreBasic", function(ShopData)
    GetDutyAmount(Config.ClosedShops[ShopData.shop].System.JobNames):next(function(amount)
        if amount > 0 then QBCore.Functions.Notify('I am not currently working at the moment, go see my coworker!', 'error', 7500) return end
        local Shop
        Shop = {{ header = Config.ClosedShops[ShopData.shop].Shop.label, isMenuHeader = true}}
        for k, v in pairs(Config.ClosedShops[ShopData.shop].Shop.items) do
            Shop[#Shop+1] = {
            header = QBCore.Shared.Items[v.name].label,
            txt = "Price : "..v.price.." | Available : "..Config.ClosedShops[ShopData.shop].Shop.items[k].current,
            icon = v.name,
            params = { event = 'cr-closedshops:client:buyamount', args = { shop = ShopData.shop, item = k } }
        }
        end
        Shop[#Shop+1] = {
            header = "Exit",
            icon = 'fas fa-sign-out-alt',
            params = { event = 'qb-menu:client:closeMenu' }
        }
        exports['qb-menu']:openMenu(Shop)
    end)
end)

-- Select Amount to buy (1 or more)
RegisterNetEvent('cr-closedshops:client:buyamount')
AddEventHandler('cr-closedshops:client:buyamount', function(data)
    local Shop
    Shop = {
        { header = Config.ClosedShops[data.shop].Shop.label, isMenuHeader = true },
        {
            header = "Buy 1",
            icon = 'fas fa-dollar-sign',
            params = { event = 'cr-closedshops:client:selectbuyamount', args = { shop = data.shop, item = data.item, amount = 1 } }
        },
        {
            header = "Select Amount to Buy",
            icon = 'fas fa-list-ol',
            params = { event = 'cr-closedshops:client:selectbuyamount', args = { shop = data.shop, item = data.item } }
        },
        {
            header = "Go Back",
            icon = "fas fa-arrow-left",
            params = { event = "cr-closedshops:client:SystemStoreBasic", args = {shop = data.shop} }
        }
    }
    exports['qb-menu']:openMenu(Shop)
end)

-- Select Amount to buy (qb-input)
RegisterNetEvent('cr-closedshops:client:selectbuyamount')
AddEventHandler('cr-closedshops:client:selectbuyamount', function(data)
    local dialog = {}
    if data.amount then dialog = {} dialog.amount = data.amount end
    if not dialog.amount then
        dialog = exports['qb-input']:ShowInput({
            header = "Select Amount",
            submitText = "Buy",
            inputs = {
                {
                    text = "Amount",
                    name = 'amount',
                    type = 'number',
                    isRequired = true
                }
            }
        })
    end
    if dialog then
        if tonumber(dialog.amount) > 0 then
            if tonumber(dialog.amount) < 0 then ClosedShopsNotif(3, "Please enter a valid amount.", Config.ClosedShops[data.shop].Shop.label) return end
            if not Config.ClosedShops[data.shop].Shop.items[data.item].current then ClosedShopsNotif(3, "Something went wrong, contact server admins.", Config.ClosedShops[data.shop].Shop.label) return end
            if Config.ClosedShops[data.shop].Shop.items[data.item].current < 1 then ClosedShopsNotif(3, "You bought too much already! Come back later.", Config.ClosedShops[data.shop].Shop.label) return end
            if tonumber(dialog.amount) > Config.ClosedShops[data.shop].Shop.items[data.item].current then ClosedShopsNotif(3, "We don't have enough right now!", Config.ClosedShops[data.shop].Shop.label) return end
            Config.ClosedShops[data.shop].Shop.items[data.item].current = Config.ClosedShops[data.shop].Shop.items[data.item].current - dialog.amount
            TriggerServerEvent('cr-closedshops:server:buyItem', data.shop, data.item, tonumber(dialog.amount))
        else
            ClosedShopsNotif(3, "Invalid Amount", "Closed Shop")
        end
    end
end)

function GetDutyAmount(jobs)
    local p = promise.new()
    QBCore.Functions.TriggerCallback('cr-closedshops:server:GetCops', function(amount)
        if amount then p:resolve(amount) else p:reject() end
    end, jobs)
    return p
end

for k, v in pairs(Config.ClosedShops) do
    ClosedShops[k] = {}
    local Shop = lib.points.new(vector3(v.System.coords.x, v.System.coords.y, v.System.coords.z), 30)
    local ShopE
    function Shop:onEnter()
        GetDutyAmount(v.System.JobNames):next(function(amount)
            if amount == 0 then
                local label = ""
                if v.System.ShopType == "ped" then
                    label = "Order from "..v.PED.Name
                    ShopE = CreatePedAtCoords(v.PED.Model, v.System.coords, v.PED.Scenario)
                    ClosedShops[k].e = ShopE
                elseif v.System.ShopType == "prop" then
                    label = "Buy From Vending Machine"
                    ShopE = CreateProp(v.System.coords, v.Prop.Model)
                    ClosedShops[k].e = ShopE
                else
                    print("Config Error. Closed Shop : "..k)
                end
                ShopE = exports['qb-target']:AddEntityZone("ClosedShop_"..k, ShopE, { name = "ClosedShop_"..k, heading = GetEntityHeading(ShopE), debugPoly = Config.Framework.Debug, },
                { options = { { type = "client", event = 'cr-closedshops:client:SystemStoreBasic', icon = "fas fa-people-arrows", label = label, shop = k}, }, distance = 2})
            end
        end)
    end
    function Shop:onExit()
        if DoesEntityExist(ClosedShops[k].e) then
            DeleteEntity(ClosedShops[k].e) ClosedShops[k].e = nil
            exports['qb-target']:RemoveZone("ClosedShop_"..k)
        end
    end
    ClosedShops[k].point = Shop
end


AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
      Wait(100)
      if looping then return end
      Citizen.CreateThread(function()
        while true do
            looping = true
            for _, values in pairs(Config.ClosedShops) do
                for _, v in pairs(values.Shop.items) do
                    if not v.current then v.current = v.limit end
                    if v.current < v.limit then v.current = v.current + 1 end
                end
            end
            Wait(10 * 60000)
        end
    end)
   end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    Citizen.CreateThread(function()
        if looping then return end
        while true do
            looping = true
            for _, values in pairs(Config.ClosedShops) do
                if values.Blip.Enabled then
                    CreateClosedShopBlips(values.System.coords, values.Blip.Sprite, values.Blip.Display, values.Blip.Scale, values.Blip.Colour, values.Blip.Label.."'s Closed Shop")
                end
                for _, v in pairs(values.Shop.items) do
                    if not v.current then v.current = v.limit end
                    if v.current < v.limit then v.current = v.current + 1 end
                end
            end
            Wait(10 * 60000)
        end
    end)
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      for _, v in pairs(ClosedShops) do
        if DoesEntityExist(v.e) then DeleteEntity(v.e) end
      end
   end
end)