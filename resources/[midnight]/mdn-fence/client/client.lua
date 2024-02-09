local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local BMPed

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000) SetupMarket()
end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
    SetupMarket()
end)

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

-- Selling
local sellToFence = function()
    local fenceItems = {}
    local pData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('fence:fetchCurrentPrices', function(currentItems)
        table.insert(fenceItems, {title = 'Disclaimer :' , description = "Real Time prices are volatile and may vary from the originally showned price.", disabled = true})
        for _, v in pairs(pData.items) do
            local cI = currentItems[v.name]
            if cI then
                table.insert(fenceItems, {
                    title = QBCore.Shared.Items[v.name].label,
                    description = 'Amount : '..v.amount..'\nCurrently sells for '..(cI.currentPrice or cI.price).. " crumbs each.",
                    serverEvent = 'mdn-fence:server:sellToFence',
                    args = {v.name, v.slot, v.amount}
                })
            end
        end
        lib.registerContext({ id = 'fenceSellingItems', title = "The Night Market", menu = 'fenceMainMenu', options = fenceItems})
        lib.showContext('fenceSellingItems')
    end)
end

-- Bounties
local checkBounties = function()
    local pData = QBCore.Functions.GetPlayerData()
	local options = {}
	for k, v in ipairs(GlobalState.FenceBounties) do
        local str = Config.Quests[v.item]?.price and Config.Quests[v.item]?.price ..' crumbs each. (Special Feature!)' or Config.FenceItems[v.item] and math.floor(Config.FenceItems[v.item].price * 1.5) ..' crumbs each. (1.5x Extras)'
        options[#options+1] = {title = QBCore.Shared.Items[v.item].label, disabled = GlobalState.CompletedBounties[pData.citizenid] and GlobalState.CompletedBounties[pData.citizenid][v.item] == true,
		onSelect = function()
            local options2 = {{type = 'number', label = 'Amount', description = 'Amount you want to sell.', required = true, default = 1, min = 1, max = 5}}
            local input = lib.inputDialog('Chose Amount', options2)
            if not input or input[1] <= 0 then QCore.Functions.Notify('Invalid Amount', 'error') return lib.showContext('fenceBounties') end
            TriggerServerEvent('mdn-fence:server:HandInBounty', k, input[1])
        end, description = 'Hand in for '.. str}
	end
	-- Context Menu
	lib.registerContext({ id = 'fenceBounties', title = 'Current Hot Items', menu = 'fenceMainMenu',
		options = options }
	) lib.showContext('fenceBounties')
end

-- Buying
function AddShopItem(item, src, key, shop, itemTable)
    local options = {{type = 'number', label = 'Amount', description = 'Amount you want to buy.', required = true, default = 1, min = 1, max = GlobalState.FenceShop.Stock[item.item].stock}}
    if GlobalState.FenceShop.Stock[item.item].subt then options[#options+1] = {type = 'select', label = 'Type', description = 'Chose the item subtype.', required = true, options = GlobalState.FenceShop.Stock[item.item].subt} end
    local iTable = {
        title = QBCore.Shared.Items[item.item].label,
        description = "Stock : ".. GlobalState.FenceShop.Stock[item.item].stock .." | Cost: "..item.price.." crumbs",
        onSelect = function()
            local input = lib.inputDialog('Chose Amount', options)
            if not input then  return  lib.showContext('OO_'..src) end
            TriggerServerEvent('mdn-fence:server:buyItem', itemTable, item.item, input[1], key, input[2] or nil, shop)
        end
    }
    return iTable
end

local function MakeMenu()
    local options = {}
    for k, v in ipairs(Config.ShopOrder) do
        local shop = Config.Shop[v]
        local shopItems = {}
        for a, item in ipairs(shop.items) do print(item, v, a, k) shopItems[#shopItems+1] = AddShopItem(item, v, a, k, shop) end
        lib.registerContext({id = 'OO_'..k, title = shop.options.header.." Store", canClose = true, menu = 'fenceStore', options = shopItems})
        options[#options+1] = {title = shop.options.header, icon = shop.options.icon, menu = 'OO_'..k}
    end
    return options
end


local openShop = function()
    local options = MakeMenu()
    lib.registerContext({id = 'fenceStore', title = "The Night Market", menu = 'fenceMainMenu', canClose = true, options = options})
    lib.showContext('fenceStore')
end

-- missions :
-- Chose "Contract" level, changes amount of packages and time to deliver
-- receives x amount of packages depending on contract
-- Using a package gives a ping to where it's due.
-- (List item that gives blips fors all the locations?)
-- player has to deliver all of the packages in the time allocated.
-- either : cant deliver a package if the time is up (Use quality system?)
    -- or : cant still deliver, but will only get 50% of the rewards.
-- can only deliver if player is carrying the list
-- Each delivery updates the list with either onTime or tooLate.
-- return the list to fence to cash in rewards.

local getMission = function(data)
    TriggerEvent("delivery:start_delivery", {job = 'fence', pedID = 'fence start_delivery', entity = data.entity})
end

local returnPackage = function()
end

local returnList = function()

end

local TalkToFence = function(data)

    Midnight.Functions.IsBlacklisted():next(function(isBlacklisted)
        if isBlacklisted then QBCore.Functions.Notify('I won\'t talk to you, bloody scum!', 'error') return end
        local count = 0
        local pData = QBCore.Functions.GetPlayerData()
        for _, v in pairs(pData.items) do if v.name == "midnight_crumbs" then count = count + v.amount end end
        local options = {
            {title = 'Account Holder : '..pData.charinfo.firstname.." "..pData.charinfo.lastname.."\nCurrent Crumbs : "..count, readOnly = true},
            {title = 'See Item Bounties', onSelect = checkBounties, icon = 'fa-solid fa-fire', arrow = true, description = 'Check out which hot item the Night Market is currently looking for.'},
            {title = 'Sell Acquisitions', onSelect = sellToFence, icon = 'fa-solid fa-coins', arrow = true, description = 'Sell some of your items to fence.'},
            {title = 'Check the Market', onSelect = openShop, icon = 'fa-solid fa-basket-shopping', arrow = true, description = 'Take a look a what\'s for sale.'}
        }
        if GetClockHours() > 19 or GetClockHours() < 7 then
            options[#options+1] = {title = 'Work as Courrier', onSelect = getMission, args = {entity = data.entity}, icon = 'fa-solid fa-person-running', description = 'Deliver some packages in exchange of some gold crumbs.'}
            options[#options+1] = {title = 'Return Lost Package', onSelect = returnPackage, icon = 'fa-solid fa-box', description = 'Return any lost packages you may have "found" on your journey.'}
        end
        if QBCore.Functions.HasItem('fencelist') then
            options[#options+1] = {title = 'Return Deliver List', onSelect = returnList, icon = 'fa-solid fa-clipboard-list', description = 'Return your courrier list and collect your payment.'}
        end
        lib.registerContext({ id = 'fenceMainMenu', title = "The Night Market", options = options})
        lib.showContext('fenceMainMenu')
    end)
end

function SetupMarket()
    Citizen.CreateThread(function()
        BMPed = CreatePedAtCoords('s_m_y_blackops_01', vector4(-274.68, -2211.19, 10.05, 90.21), false)
        exports.ox_target:addLocalEntity(BMPed, {
            {label = "Talk to Fence", name = 'fencePed', icon = 'fa-solid fa-comments-dollar', distance = 2.0, canIntereact = function() return true --[[GlobalState.isFenceOpen]] end, onSelect = TalkToFence },
        }
    )
    end)
end

RegisterNetEvent('fence:client:backToSelling', sellToFence)