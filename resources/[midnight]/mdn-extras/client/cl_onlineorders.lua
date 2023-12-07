local QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
-- Ordering

Citizen.CreateThread(function()
    for k, v in pairs(Config.OnlineOrders.CustomJobs) do
        local p = lib.points.new(v.coords, 1.5)
        function p:onEnter()
            if not v.cids[QBCore.Functions.GetPlayerData().citizenid] then return end
            lib.addRadialItem({id = "OOTablet", icon = 'tablet', label = 'Order Ingredients',
            onSelect = function()
                TriggerEvent('OnlineOrders:client:Menu', {name = k, label = v.label})
            end})
        end
        function p:onExit() lib.removeRadialItem('OOTablet') ExecuteCommand('emotecancel') end
    end
end)

local function MakeMenu(job)
    local options = {}
    for _, v in pairs(Config.OnlineOrders.jobs[job.name].AvailableShops) do
        local shop = Config.OnlineOrders.Shops[v]
        local shopItems = {}
        for a, item in ipairs(shop.items) do
            if item.jobs and item.jobs[job.name] then shopItems[#shopItems+1] = AddShopItem(item, v, a, job)
            elseif not item.jobs and not (item.exl and item.exl[job.name]) then shopItems[#shopItems+1] = AddShopItem(item, v, a, job) end
        end
        lib.registerContext({id = 'OO_'..v, title = shop.options.header.." Store", canClose = true, menu = 'onlineOrders', options = shopItems})
        options[#options+1] = {title = shop.options.header, icon = shop.options.icon, menu = 'OO_'..v}
    end
    options[#options+1] =  {title = "View Cart", icon = 'cart-shopping', menu = 'currentCart'}
    local cart = UpdateCart(job)
    lib.registerContext({id = 'currentCart', title = job.label.."'s Cart", canClose = true, menu = 'onlineOrders', options = cart})
    return options
end

function UpdateCart(job)
    local cart = {}
    for k, v in pairs(GlobalState.OnlineOrders.Jobs[job.name].cart) do
        cart[#cart+1] =  {title = QBCore.Shared.Items[k].label, description = "Amount in cart : "..v.amt.." | Total : $".. v.amt * GlobalState.OnlineOrders.Stock[k].price .." | Click to Modify.",
        onSelect = function()
            local input = lib.inputDialog('Modify Amount', {
                {type = 'number', label = 'Amount', description = 'Amount to purchase', required = true, min = 0, max = 100, default = v.amt}
            }) if not input then  return lib.showContext('currentCart') end

            TriggerServerEvent('OnlineOrders:UpdateCart', k, input[1], v.amt, job)
            QBCore.Functions.Progressbar('onlineOrders', 'Updating Cart...', 2000, false, false,
            { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false },
            {}, {}, {}, function() MakeMenu(job) Citizen.Wait(500)  lib.showContext('currentCart') end)
        end }
    end
    cart[#cart+1] = {title = "Pay & Print Order", icon = 'cart-arrow-down', description = "Total : $"..GlobalState.OnlineOrders.Jobs[job.name].total, serverEvent = 'OnlineOrders:FinishOrder', args = {job = job}, disabled = #cart < 1}
    return cart
end

function AddShopItem(item, src, key, job)
    local options = {{type = 'number', label = 'Amount', description = 'Amount to be added to your cart', required = true, min = 1, max = 100}}
    if GlobalState.OnlineOrders.Stock[item.item].subt then options[#options+1] = {type = 'select', label = 'Type', description = 'Chose the item subtype.', required = true, options = GlobalState.OnlineOrders.Stock[item.item].subt} end
    local itemTable = {
        title = QBCore.Shared.Items[item.item].label,
        description = "Stock : ".. GlobalState.OnlineOrders.Stock[item.item].stock .." | Cost: $"..item.price.." | Amt in Cart : "..(GlobalState.OnlineOrders.Jobs[job.name].cart[item.item] and GlobalState.OnlineOrders.Jobs[job.name].cart[item.item].amt or 0),
        onSelect = function()
            local input = lib.inputDialog('Chose Amount', options)
            if not input then  return  lib.showContext('OO_'..src) end
            TriggerServerEvent('OnlineOrders:AddToCart', src, item.item, input[1], key, job.name, input[2] or nil)
            QBCore.Functions.Progressbar('onlineOrders', 'Updating Cart...', 1000, false, false,
            { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false },
            {}, {}, {}, function() MakeMenu(job) Citizen.Wait(500)  lib.showContext('OO_'..src) end)
        end
    }
    return itemTable
end

RegisterNetEvent('OnlineOrders:client:Menu', function(j)
    local pData = QBCore.Functions.GetPlayerData()
    local job = j or pData.job
    print(job.name)
    if not Config.OnlineOrders.jobs[job.name] then QBCore.Functions.Notify('You do not have the password to the account!', 'error', 7500) return end
    local options = MakeMenu(job)
    lib.registerContext({id = 'onlineOrders', title = "Online Store", canClose = true, options = options})

    lib.showContext('onlineOrders')
end)

RegisterNetEvent('OnlineOrders:OpenCart', function(j)
    local pData = QBCore.Functions.GetPlayerData()
    local job = j or pData.job
    MakeMenu(job) Citizen.Wait(500)

    lib.showContext('currentCart')
end)

local function CheckCanDoOnlineOrders(job) return Config.OnlineOrders.jobs[job] end exports('CheckCanDoOnlineOrders', CheckCanDoOnlineOrders)

-- Pickup

local function EnsurePedModel(pedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end
end

local function CreatePedAtCoords(pedModel, coords, isNetworked)
    if type(pedModel) == "string" then
        pedModel = GetHashKey(pedModel)
    end
    EnsurePedModel(pedModel)
    local ped = CreatePed(0, pedModel, coords.x, coords.y, coords.z - 0.98, coords.w, isNetworked, false)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, true)
    SetEntityInvincible(ped, true)
    PlaceObjectOnGroundProperly(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

local function CreateBlip(coords)
	local Blip = AddBlipForCoord(coords)
	SetBlipSprite(Blip, 615)
	SetBlipDisplay(Blip, 4)
	SetBlipScale(Blip, 0.6)
	SetBlipColour(Blip, 64)
	SetBlipAsShortRange(Blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mechanic Shops Pickups Location")
	EndTextCommandSetBlipName(Blip)
    return Blip
end

RegisterNetEvent('OnlineOrders:OpenInv', function() if GetResourceKvpInt('UnBoxInv') == 1 then ExecuteCommand('inventory') end end)
RegisterNetEvent('OnlineOrders:GrabOrder', function(data) TriggerServerEvent('OnlineOrders:GetItems', data.loc) end)
--RegisterNetEvent('OnlineOrders:ToggleUnboxInv', function() end)

-- RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) JobInfo  end)


    Citizen.CreateThread(function()
        for k, v in pairs(Config.OnlineOrders.ShopLocations) do
            local sPed = CreatePedAtCoords(v.ped, v.coords, false)
            while not sPed do Wait(1000) end
            local options = {{name = "OOPed"..k, type = "client", event = "OnlineOrders:GrabOrder", icon = "fas fa-hand", label = "Grab Order", loc = k, item = 'orderconfirmation'}}
            exports['qb-target']:AddBoxZone("OOPed"..k, v.coords, 0.5, 0.5, { name="OOPed"..k, heading = GetEntityHeading(sPed), debugPoly = Config.DebugPoly, minZ = v.coords.z-1, maxZ = v.coords.z+1}, { options = options, distance = 1.5 })
        end
    end)

RegisterNetEvent('OnlineOrders:CheckOrder', function(item)
    local pData = QBCore.Functions.GetPlayerData()
    local items = pData.items[item.slot].info.items
    local options = {}
    if items then
        for k, v in pairs(items) do
            local shopLoc = Config.OnlineOrders.ShopLocations[v.loc]
            options[#options+1] = {title = "x"..v.amt.. "     "..QBCore.Shared.Items[k].label, disabled = v.taken, description = (not v.taken and shopLoc.name.." | Click to set Waypoint."), onSelect = function()
                local coords = shopLoc.coords
                blips[v.loc] = CreateBlip(coords)
                SetNewWaypoint(coords.x, coords.y)
                QBCore.Functions.Notify('GPS Updated!', 'success')
            end}
        end
    end
    lib.registerContext({id = 'orderConfirmation', title = "Shop Order", canClose = true, options = options})
    lib.showContext('orderConfirmation')
end)

RegisterNetEvent('OnlineOrders:DelBlip', function(loc) RemoveBlip(blips[loc]) end)