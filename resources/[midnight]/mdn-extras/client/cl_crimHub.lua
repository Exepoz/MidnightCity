local QBCore = exports['qb-core']:GetCoreObject()
local Midnight = exports['mdn-nighttime']:GetMidnightCore()
local QM, currEx

RegisterCommand('getPeds', function()
    local peds = {}
    for k, v in pairs(lib.getNearbyPeds(GetEntityCoords(PlayerPedId()), 30.0)) do
        local heading = GetEntityHeading(v.ped)
        local info = {
            coords = vector4(v.coords.x, v.coords.y,v.coords.z, heading),
            model = GetEntityModel(v.ped),
            relGroup = GetPedRelationshipGroupHash(v.ped)
        }
        peds[#peds+1] = info
    end
    QBCore.Debug(peds)
end)

-- RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
--     Wait(2000) SetupHeistBPPed()
-- end)

-- AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
--     SetupHeistBPPed()
-- end)

-- Utils

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

-- Blueprints Guys

local bpMenu, deviMenu = {}, {}
for k, heist in ipairs(Config.BPOrder) do
    local v = Config.Electronics[heist]
    if v.bp then
        bpMenu[#bpMenu+1] = {
            title = QBCore.Shared.Items[v.bp].label.." (Blueprint)", description = 'In exchange of :\n·   **_'..QBCore.Shared.Items[v.needed].label.."_**\n·   "..v.crumbs.." Crumbs",
            image = "nui://ps-inventory/html/images/"..QBCore.Shared.Items[v.needed].image,
            onSelect = function(data)
                TriggerServerEvent('bpGuy:server:getItem', v.bp, {item = {v.needed, 1}, crumbs = v.crumbs}, true)
            end,
        }
        deviMenu[#deviMenu+1] = {
            title = QBCore.Shared.Items[v.bp].label, description = "In exchange of :\n·   "..QBCore.Shared.Items[Config.Electronics[Config.BPOrder[k-1]].item].label.. " : "..v.buy.e.."\n·   Crumbs : "..v.buy.c,
            onSelect = function(data)
                TriggerServerEvent('bpGuy:server:getItem', v.bp, {item = {Config.Electronics[Config.BPOrder[k-1]].item, v.buy.e}, crumbs = v.buy.c})
            end,
        }
    end
end
lib.registerContext({id = 'illegal_electronics_BP', title = 'Rare Devices Blueprints', menu = 'bpGuy', options = bpMenu})
lib.registerContext({id = 'illegal_electronics', title = 'Rare Electronic Devices', menu = 'bpGuy', options = deviMenu})

local heistEquip, heistEquipBP = {}, {}
for _, v in ipairs(Config.HeistEquip) do
    heistEquip[#heistEquip+1] = {
        title = QBCore.Shared.Items[v.item].label, description = "Cost : **".. v.i_cost.." Crumbs**",
        onSelect = function()
            TriggerServerEvent('bpGuy:server:getItem', v.item, {crumbs = v.i_cost})
        end, args = {man = true},
    }
    heistEquipBP[#heistEquipBP+1] = {
        title = QBCore.Shared.Items[v.item].label.." (Blueprint)", description = "Cost : **".. v.bp_cost.." Crumbs**",
        onSelect = function()
            TriggerServerEvent('bpGuy:server:getItem', v.item, {crumbs = v.bp_cost}, true)
        end, args = {man = true},
    }
end
lib.registerContext({id = 'heist_equip', title = 'Heist Equipment', menu = 'bpGuy', options = heistEquip})
lib.registerContext({id = 'heist_equip_bp', title = 'Heist Equipment Blueprints', menu = 'bpGuy', options = heistEquipBP})

-- function SetupHeistBPPed()
--     local ped = CreatePedAtCoords('a_m_y_business_02', vector4(-591.02, -1627.87, 33.01, 312.78), false)
--     exports.ox_target:addLocalEntity(ped, {
--         label = 'Purchase Heist Equipment',
--         icon = 'fas fa-cart-shopping',
--         onSelect = function()
--             local pData = QBCore.Functions.GetPlayerData()
--             local options = {}
--             options[#options+1] = {title = 'Sup '..pData.charinfo.firstname.."!", readOnly = true}

--             options[#options+1] = {title = 'Heist Equipment', description = 'Thinking of doing some big crime? I might have some useful stuff for you.', menu = 'heist_equip', args = {man = true}}
--             options[#options+1] = {title = 'Heist Equipment Blueprints', description = 'Good at tinkering? I can sell you some blueprints.', menu = 'heist_equip_bp', args = {man = true}}
--             options[#options+1] = {title = 'Rare Electronic Devices', description = 'Got some electronics? I\'ll sell you some rare devices...', menu = 'illegal_electronics', args = {man = true}}
--             options[#options+1] = {title = 'Rare Devices Blueprints', description = 'Got some rare items from your heists? I can sell you some rare blueprints...', menu = 'illegal_electronics_BP', args = {man = true}}
--             -- options[#options+1] = {title = 'Check Profile', description = 'Take a look at your Bounty Hunter Profile.', onSelect = checkProfile}
--             lib.registerContext({id = 'bpGuy', title = 'The Blueprint Guy',  options = options })
--             lib.showContext('bpGuy')
--         end,
--     })
-- end

local function setupShops(cat, backMenu)
    for _, id in ipairs(cat) do
        local v = Config.CrimHub.ShopCategories[id]
        local shopItems = {}
        for _, v_ in ipairs(v.items) do
            local neededItems = ""
            if v_.needed then for _, b in pairs(v_.needed) do neededItems = neededItems.."\n·   **_"..QBCore.Shared.Items[b[1]].label.."_** x"..b[2] end end
            shopItems[#shopItems+1] = {
                title = QBCore.Shared.Items[v_.item].label..(v_.isBP and " (Blueprint)" or ""), description = "In exchange of :\n·   ".. v_.cost.." Crumbs"..(v_.needed and neededItems or ""),
                icon ="nui://ps-inventory/html/images/"..QBCore.Shared.Items[v_.item].image,
                onSelect = function()
                    TriggerServerEvent('bpGuy:server:getItem', v_.item, {crumbs = v_.cost, items = v_.needed}, v_.isBP)
                end, args = {man = true},
            }
        end
        lib.registerContext({id = id, title = v.label, menu = backMenu, options = shopItems})
    end
end

function SetupVendor(data)
    local ped = CreatePedAtCoords(data.ped, data.coords, false)
    exports.ox_target:addLocalEntity(ped, {
        label = data.menuLabel,
        icon = data.icon,
        onSelect = function()
            Midnight.Functions.IsBlackListed():next(function(isBL)
                if isBL then QBCore.Functions.Notify('I don\'t know you, get out! Now!', 'error') return end
                local pData = QBCore.Functions.GetPlayerData()
                setupShops(data.categories, data.shopId)
                local options = {}
                options[#options+1] = {title = 'Sup '..pData.charinfo.firstname.."!", readOnly = true}
                local C = Config.CrimHub.ShopCategories
                for k, v in ipairs(data.categories) do
                    options[#options+1] = {title = C[v].label, description = C[v].description, menu = v, args = {man = true}}
                end
                lib.registerContext({id = data.shopId, title = data.targetLabel,  options = options })
                lib.showContext(data.shopId)
            end)
        end,
    })
end

-- Quartermaster
local buyCrumbsMenu = function(data)
    local input = lib.inputDialog('1 Banked point = '..Config.CrimHub.BHExchangeRate..' Gold Crumbs', {
        {type = 'number', label = 'Amount to buy', description = 'Current Banked Points : '..data.bank, required = true, min = 1, max = data.bank},
    })
    if not input or not input[1] then TriggerEvent('crimHub:client:talkToQuartermaster') return end
    TriggerServerEvent('nighttime:server:buyBHCrumbs', input[1])
end

local buyGraceMenu = function(data)
    local input = lib.inputDialog('Buying Marks Of Grace', {
        {type = 'number', label = 'Amount to buy', description = '1 Mark = 3 Banked Points', required = true, min = 1, max = 6-data.grace},
    })
    if not input or not input[1] then TriggerEvent('crimHub:client:talkToQuartermaster') return end
    TriggerServerEvent('nighttime:server:buyMOG', input[1])
end

RegisterNetEvent('crimHub:client:SetupQuartermaster', function()
    if QM then return end
    QM = CreatePedAtCoords('s_m_y_blackops_01', vector4(-603.12, -1601.40, 27.01, 230.82), false)
    exports.ox_target:addLocalEntity(QM, {
        label = 'Talk to the Quartermaster',
        icon = 'fas fa-comments',
        event = 'crimHub:client:talkToQuartermaster',
    })
end)

RegisterNetEvent('crimHub:client:removeQuartermaster', function() if DoesEntityExist(QM) then DeleteEntity(QM) QM = nil end end)

RegisterNetEvent('crimHub:client:talkToQuartermaster', function()
    local isNight = Midnight.Functions.IsNightTime()
    QBCore.Functions.TriggerCallback('nighttime:fetchUserData', function(data)
        if not data then
            local alert = lib.alertDialog({
                header = 'A new hunter eh?',
                cancel = true,
                content = 'Hey you, are you interested in becoming a bounty hunter?\n\n\n'..
                "There's a couple of rules I need to inform you about before letting you lose in these streets...\n\n"
                .."We follow a strict code when it comes to hunting, first and foremost, we **ONLY** hunt at night.\n\n"
                .."When you are hunting, you can only kill your prey or other hunters, nobody else. Unless you've bought some _Marks of Grace_, **innocent people are off the grid** for you. "
                .."For sure, you can press anyone and rob whoever you'd like, but **DO NOT** spill their blood unless you've got some _Marks of Grace_\n\n"
                .."Anyone is protected inside **Safe Havens**, these are marked with _green lights_ at their entrance. Again, do **NOT** spill any blood inside Safe Havens.\n\n"
                .."Not following these simple rules will blacklist you from any Golden Trail services. You will be marked as a _Bloody Prey_ and be in constant danger according to the rules of the hunt.\n\n\n"
                .."More info on the next page... **Are you aware of these rules?**"
            }) if alert ~= 'confirm' then return end

            alert = lib.alertDialog({
                header = 'How to hunt.',
                cancel = true,
                content = 'If you become a hunter, you will be given a **Blood Dongle**.\n\n'
                .."While carrying it, you will able to open the hunting services by pressing the Sun/Moon icon at the top right of your phone.\n\n"
                .."At night, you may start hunting. You will be given a random prey between anyone who is outside of a Safe Haven\n\n"
                .."You may switch prey every 30 seconds if you are not happy with the current prey's location.\n\n"
                .."Every minute, the location of your prey will get more precise until it becomes an exact coordinate marker.\n\n"
                .."When close to someone, you may Identify them to find out if they are your prey or not.\n\n"
                .."Once you are certain of who your prey is, you may kill them and reap their bounty.\n\n"
                .."The bounty remains unclaimed until the morning, where I will be able to confirm your kills and bank your points.\n\n"
                .."You may only stop hunting while being inside of a Safe Haven.\n\n\n"
                .."Do you understand these instructions?"
            }) if alert ~= 'confirm' then return end

            alert = lib.alertDialog({
                header = 'The Risks.',
                cancel = true,
                content = '**Do NOT kill the wrong prey.**\n\n'
                .."Unles you've got some _Marks Of Grace_, of which I can sell you here, killing innocent people will result in you becoming a Bloody Prey.\n\n"
                .."You may have a maximum of 6 _Marks Of Grace_ at a time, those grant you immunity from killing an innocent. "
                .."Marks **DO NOT** protect you from killing someone inside of a Safe Haven.\n\n"
                .."You may kill other hunters during the night to steal their unclaim points. Others can do the same to you.\n\n"
                .."Becoming a bloody prey will lower your total score and your poiny bank by half & wipe your unclaim points.\n\n"
                .."Becoming a bloody prey also blacklist you from any Golden Trail Services for a period of 48h, regardless of if your bounty is claimed or not.\n\n"
                .."Any hunters can select bloody preys as their targets. The Prey's location is instantly & precisely given.\n\n"
                .."Bloody Preys have a crumbs bounty bonus attached to them.\n\n\n"
                .."Do you understand these risks?"
            }) if alert ~= 'confirm' then return end
            TriggerServerEvent('nighttime:server:giveHuntDongle')
        else
            local pData = QBCore.Functions.GetPlayerData()
            local options = {}

            options[#options+1] = {title = 'Claimed any new bounties, **'..data.nickname.."**?", readOnly = true, description = data.blacklisted and "~ !! BLACKLISTED !! ~" or "Bounty Points : "..data.points.." | Unclaimed : "..data.unclaimed.." | Banked : "..data.bank}
            options[#options+1] = {title = 'Claim Bounties', disabled = isNight, description = isNight and 'You can only claim during the day' or 'Confirm any unclaimed points and bank them.', serverEvent = 'nighttime:server:bankPoints', args = data}
            options[#options+1] = {title = 'Buy Marks of Grace', disabled = data.bank < 3, description = 'Current : '..data.grace..'\nMake sure you\'ve got a couple if you\'re a messy hunter.', onSelect = buyGraceMenu, args = data}
            options[#options+1] = {title = 'Get Crumbs', disabled = data.bank <= 0, description = 'Current Exchange Rate :\n1 Banked point = '..Config.CrimHub.BHExchangeRate..' Gold Crumbs', onSelect = buyCrumbsMenu, args = data}
            options[#options+1] = {title = 'Get new Blood Dongle', description = 'Lost your dongle? I\'ve got some to spare...', serverEvent = 'nighttime:server:giveHuntDongle'}

            lib.registerContext({id = 'QuarterMaster', title = 'The Quartermaster',  options = options })
            lib.showContext('QuarterMaster')
        end
    end)
end)

-- Current Exchange
local getCurrency = function(currency)
    local p = promise.new()
    if currency == 'cash' then
        p:resolve(QBCore.Functions.GetPlayerData().money.cash)
    else
        QBCore.Functions.TriggerCallback('crimHub:server:getCurrency', function(amount)
            p:resolve(amount)
        end, currency)
    end
    return p
end

local convertCurrency = function(buyA, sellA, amountSelected)
    return math.floor(buyA / sellA * amountSelected)
end

local exchangeAmount = function(data)
    local buy, sell = data[1], data[2]

    getCurrency(sell):next(function(currencyAmount)
        if not currencyAmount or currencyAmount == 0 then QBCore.Functions.Notify("You don't have anything to sell...", 'error') return end
        local labels = {
            ['scoins'] = ' sCoins',
            ['cash'] = ' Dollars',
            ['crumbs'] = ' Gold Crumbs'
        }
        local input = lib.inputDialog('Select Amount to Exchange', {
            {type = 'number', label = Config.CrimHub.CurrencyExchange[buy][sell]..labels[sell].." ⟶ "..Config.CrimHub.CurrencyExchange[buy].rec..labels[buy], description = 'Current '..labels[sell].." : "..math.floor(currencyAmount), required = true, min = 0, max = currencyAmount},
        })
        if not input or not input[1] then TriggerEvent('crimHub:client:talkToQuartermaster') return end
        local finalAmount = convertCurrency(Config.CrimHub.CurrencyExchange[buy].rec, Config.CrimHub.CurrencyExchange[buy][sell], input[1])
        local alert = lib.alertDialog({
            header = 'Confirm Purchase',
            cancel = true, centered = true,
            content = 'Buy '..finalAmount..labels[buy].." for "..input[1]..labels[sell].."?"
        }) if alert ~= 'confirm' then return end
        TriggerServerEvent('crimHub:server:exchangeCurrency', buy, sell, input[1])
    end)
end

local exCashMenu = {}
exCashMenu[#exCashMenu+1] = {title = 'Sell Crumbs', description = 'Sell your Gold Crumbs for money.\n'..Config.CrimHub.CurrencyExchange['cash']['crumbs'].." Crumbs for $"..Config.CrimHub.CurrencyExchange['cash'].rec, onSelect = exchangeAmount, args = {'cash', 'crumbs'}}
exCashMenu[#exCashMenu+1] = {title = 'Sell sCoins', description = 'Sell your sCoins for money.\n'..Config.CrimHub.CurrencyExchange['cash']['scoins'].." sCoins for $"..Config.CrimHub.CurrencyExchange['cash'].rec, onSelect = exchangeAmount, args = {'cash', 'scoins'}}
lib.registerContext({id = 'exCashMenu', title = 'Cash Exchange',  options = exCashMenu, menu = 'currencyExchange'})

local exCrumbsMenu = {}
exCrumbsMenu[#exCrumbsMenu+1] = {title = 'Sell Cash', description = 'Sell your Cash to get crumbs.\n$'..Config.CrimHub.CurrencyExchange['crumbs']['cash'].." for "..Config.CrimHub.CurrencyExchange['crumbs'].rec.." Crumbs.", onSelect = exchangeAmount, args = {'crumbs', 'cash'}}
exCrumbsMenu[#exCrumbsMenu+1] = {title = 'Sell sCoins', description = 'Sell your sCoins for money.\n'..Config.CrimHub.CurrencyExchange['crumbs']['scoins'].." sCoins for "..Config.CrimHub.CurrencyExchange['crumbs'].rec.." Crumbs.", onSelect = exchangeAmount, args = {'crumbs', 'scoins'}}
lib.registerContext({id = 'exCrumbsMenu', title = 'Crumbs Exchange',  options = exCrumbsMenu, menu = 'currencyExchange'})

local exCoinsMenu = {}
exCoinsMenu[#exCoinsMenu+1] = {title = 'Sell Cash', description = 'Sell your Cash to get crumbs.\n$'..Config.CrimHub.CurrencyExchange['scoins']['cash'].." for "..Config.CrimHub.CurrencyExchange['scoins'].rec.." sCoins.", onSelect = exchangeAmount, args = {'scoins', 'cash'}}
exCoinsMenu[#exCoinsMenu+1] = {title = 'Sell Crumbs', description = 'Sell your Gold Crumbs for sCoins.\n'..Config.CrimHub.CurrencyExchange['scoins']['crumbs'].." Crumbs for "..Config.CrimHub.CurrencyExchange['scoins'].rec.." sCoins.", onSelect = exchangeAmount, args = {'scoins', 'crumbs'}}
lib.registerContext({id = 'exCoinsMenu', title = 'sCoins Exchange',  options = exCoinsMenu, menu = 'currencyExchange'})


local sellBags = function()
    QBCore.Functions.TriggerCallback('crimHub:server:fetchBagsCount', function(data)
        if not data then return end
        local alert = lib.alertDialog({
            header = 'Exchange Money Bags',
            cancel = true, centered = true,
            content = "Exchange all of your money bags for "..(Config.CrimHub.CurrencyExchange.moneyBagsRatio*100).."% of it's value, in crumbs?\n\nThis would give you "..data.." Gold Crumbs."
        }) if alert ~= 'confirm' then return end
        TriggerServerEvent('crimHub:server:exchangeMoneyBags')
    end)
end

RegisterNetEvent('crimHub:client:SetupCurrExchange', function()
    if currEx then return end
    currEx = CreatePedAtCoords('s_m_y_blackops_01', vector4(-577.75,-1603.58, 27.01, 100.42), false)
    exports.ox_target:addLocalEntity(currEx, {
        label = 'Exchange your Currencies',
        icon = 'fas fa-hand-holding-dollar',
        event = 'crimHub:client:talkToCurrExchange',
    })
end)

RegisterNetEvent('crimHub:client:removeCurrExchange', function() if DoesEntityExist(currEx) then DeleteEntity(currEx) currEx = nil end end)

RegisterNetEvent('crimHub:client:talkToCurrExchange', function()
    local isNight = Midnight.Functions.IsNightTime()
    local pData = QBCore.Functions.GetPlayerData()
    local options = {}

    options[#options+1] = {title = 'Buy Cash...', description = 'Receive regular money in exchange of other currencies', menu = 'exCashMenu'}
    options[#options+1] = {title = 'Buy Crumbs...', description = 'Receive Gold Crumbs in exchange of other currencies', menu = 'exCrumbsMenu'}
    options[#options+1] = {title = 'Buy sCoins...', description = 'Receive sCoins in exchange of other currencies', menu = 'exCoinsMenu'}
    --options[#options+1] = {title = 'Sell Money Bags...', description = 'Got money bags? We\'ll get them off your hands.', onSelect = sellBags}


    lib.registerContext({id = 'currencyExchange', title = 'The Currency Exchange',  options = options })
    lib.showContext('currencyExchange')
end)

-- Condo System
local RentRoom = function()
end

Citizen.CreateThread(function()
    QBCore.Functions.TriggerCallback('hubCondo:cb:fetchApartments', function()
        exports.ox_target:addSphereZone({coords = vector3(-608.19, -1617.26, 37.22), radius = 0.5, debug = false, options = {
            {label = 'Rent Room', icon = 'fas fa-money-bill-wave', onSelect = RentRoom},
            {label = 'Rent Room', icon = 'fas fa-money-bill-wave', onSelect = RentRoom},
            {label = 'Rent Room', icon = 'fas fa-money-bill-wave', onSelect = RentRoom},
        }})
    end)
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.CrimHub.Vendors) do
        SetupVendor(v)
    end
    TriggerEvent('crimHub:client:SetupQuartermaster')
    TriggerEvent('crimHub:client:SetupCurrExchange')
end)