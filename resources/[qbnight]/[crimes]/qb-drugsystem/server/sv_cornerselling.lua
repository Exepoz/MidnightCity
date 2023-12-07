if not Shared.Enable.Cornerselling then return end

local zonePayout = { -- Depending on where the player is cornering, he or she will receive and extra amount of payout per bag based on the zone below
    ['AIRP'] = 1, -- Los Santos International Airport,
    ['ALAMO'] = 1, -- Alamo Sea,
    ['ALTA'] = 10, -- Alta,
    ['ARMYB'] = 1, -- Fort Zancudo,
    ['BANHAMC'] = 1, -- Banham Canyon Dr,
    ['BANNING'] = 1, -- Banning,
    ['BEACH'] = 10, -- Vespucci Beach,
    ['BHAMCA'] = 1, -- Banham Canyon,
    ['BRADP'] = 1, -- Braddock Pass,
    ['BRADT'] = 1, -- Braddock Tunnel,
    ['BURTON'] = 1, -- Burton,
    ['CALAFB'] = 1, -- Calafia Bridge,
    ['CANNY'] = 1, -- Raton Canyon,
    ['CCREAK'] = 1, -- Cassidy Creek,
    ['CHAMH'] = 1, -- Chamberlain Hills,
    ['CHIL'] = 10, -- Vinewood Hills,
    ['CHU'] = 1, -- Chumash,
    ['CMSW'] = 1, -- Chiliad Mountain State Wilderness,
    ['CYPRE'] = 1, -- Cypress Flats,
    ['DAVIS'] = 1, -- Davis,
    ['DELBE'] = 10, -- Del Perro Beach,
    ['DELPE'] = 10, -- Del Perro,
    ['DELSOL'] = 10, -- La Puerta,
    ['DESRT'] = 1, -- Grand Senora Desert,
    ['DOWNT'] = 1, -- Downtown,
    ['DTVINE'] = 1, -- Downtown Vinewood,
    ['EAST_V'] = 10, -- East Vinewood,
    ['EBURO'] = 1, -- El Burro Heights,
    ['ELGORL'] = 1, -- El Gordo Lighthouse,
    ['ELYSIAN'] = 1, -- Elysian Island,
    ['GALFISH'] = 1, -- Galilee,
    ['GOLF'] = 1, -- GWC and Golfing Society,
    ['GRAPES'] = 1, -- Grapeseed,
    ['GREATC'] = 1, -- Great Chaparral,
    ['HARMO'] = 1, -- Harmony,
    ['HAWICK'] = 10, -- Hawick,
    ['HORS'] = 1, -- Vinewood Racetrack,
    ['HUMLAB'] = 1, -- Humane Labs and Research,
    ['JAIL'] = 1, -- Bolingbroke Penitentiary,
    ['KOREAT'] = 10, -- Little Seoul,
    ['LACT'] = 1, -- Land Act Reservoir,
    ['LAGO'] = 1, -- Lago Zancudo,
    ['LDAM'] = 1, -- Land Act Dam,
    ['LEGSQU'] = 20, -- Legion Square,
    ['LMESA'] = 10, -- La Mesa,
    ['LOSPUER'] = 1, -- La Puerta,
    ['MIRR'] = 10, -- Mirror Park,
    ['MORN'] = 10, -- Morningwood,
    ['MOVIE'] = 1, -- Richards Majestic,
    ['MTCHIL'] = 1, -- Mount Chiliad,
    ['MTGORDO'] = 1, -- Mount Gordo,
    ['MTJOSE'] = 1, -- Mount Josiah,
    ['MURRI'] = 1, -- Murrieta Heights,
    ['NCHU'] = 1, -- North Chumash,
    ['NOOSE'] = 1, -- N.O.O.S.E,
    ['OCEANA'] = 1, -- Pacific Ocean,
    ['PALCOV'] = 1, -- Paleto Cove,
    ['PALETO'] = 1, -- Paleto Bay,
    ['PALFOR'] = 1, -- Paleto Forest,
    ['PALHIGH'] = 1, -- Palomino Highlands,
    ['PALMPOW'] = 1, -- Palmer-Taylor Power Station,
    ['PBLUFF'] = 1, -- Pacific Bluffs,
    ['PBOX'] = 10, -- Pillbox Hill,
    ['PROCOB'] = 1, -- Procopio Beach,
    ['RANCHO'] = 1, -- Rancho,
    ['RGLEN'] = 1, -- Richman Glen,
    ['RICHM'] = 1, -- Richman,
    ['ROCKF'] = 1, -- Rockford Hills,
    ['RTRAK'] = 1, -- Redwood Lights Track,
    ['SANAND'] = 10, -- San Andreas,
    ['SANCHIA'] = 1, -- San Chianski Mountain Range,
    ['SANDY'] = 1, -- Sandy Shores,
    ['SKID'] = 20, -- Mission Row,
    ['SLAB'] = 1, -- Stab City,
    ['STAD'] = 10, -- Maze Bank Arena,
    ['STRAW'] = 10, -- Strawberry,
    ['TATAMO'] = 1, -- Tataviam Mountains,
    ['TERMINA'] = 1, -- Terminal,
    ['TEXTI'] = 1, -- Textile City,
    ['TONGVAH'] = 1, -- Tongva Hills,
    ['TONGVAV'] = 1, -- Tongva Valley,
    ['VCANA'] = 10, -- Vespucci Canals,
    ['VESP'] = 10, -- Vespucci,
    ['VINE'] = 10, -- Vinewood,
    ['WINDF'] = 1, -- Ron Alternates Wind Farm,
    ['WVINE'] = 10, -- West Vinewood,
    ['ZANCUDO'] = 1, -- Zancudo River,
    ['ZP_ORT'] = 1, -- Port of South Los Santos,
    ['ZQ_UAR'] = 10 -- Davis Quartz
}

--- Events

RegisterNetEvent('qb-drugsystem:server:CornerSellToPed', function(netId, zone)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if type(netId) ~= 'number' or not Player then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(entity) then return end
    local playerPed = GetPlayerPed(src)
    if #(GetEntityCoords(playerPed) - GetEntityCoords(entity)) > 5 then return end

    for _, item in pairs(Player.PlayerData.items) do
        if Shared.CornerSellDrugs[item.name] then
            local payout = 0
            local removeAmount = math.random(Shared.CornerSellBags.min, Shared.CornerSellBags.max)

            -- Base Price
            if item.amount < removeAmount then removeAmount = item.amount end
            payout += math.random(Shared.CornerSellDrugs[item.name].baseMin, Shared.CornerSellDrugs[item.name].baseMax) * removeAmount

            -- Modifier base on amount of cops around
            local copCount = getCopCount()
            if copCount > Shared.CornerSellDrugs[item.name].copCap then copCount = Shared.CornerSellDrugs[item.name].copCap end
            payout += Shared.CornerSellDrugs[item.name].copMultiplier * copCount * removeAmount -- Payout based on cop count

             -- Modifier based on purity
            if item.info ~= "" and item.info.purity and item.info.purity >= 15.0 then
                payout += Shared.CornerSellDrugs[item.name].purityMultiplier * (item.info.purity-15) * removeAmount
            end

             -- Modifier based on strain
             if item.info ~= "" and item.info.strain and Shared.CornerSellDrugs[item.name].Strains then
                payout += Shared.CornerSellDrugs[item.name].Strains[item.info.strain] * item.info.purity/100 * removeAmount
            end

            -- Modifer based on the zone
            -- if Shared.CornerSellZonedBasedPayout and zonePayout[zone] then -- Payout based on zone
            --     payout += zonePayout[zone] * removeAmount
            -- end
            payout = math.floor(payout)
            if Player.Functions.RemoveItem(item.name, removeAmount, item.slot) then
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'remove', removeAmount)
                Wait(2000)

                local gInfo = exports['av_gangs']:getGang(src)
                if gInfo then
                    TriggerEvent('av_gangs:addXP', gInfo.name, 0.2)
                    TriggerClientEvent('QBCore:Notify', src, "You get some gang reputation from doing this...", 'success')
                end

                Player.Functions.AddMoney('cash', payout, 'cornerselling')
                debugPrint(GetPlayerName(src) .. ' (' .. src .. ')' .. ' cornersold ' .. removeAmount .. ' ' .. item.name .. ', payout: ' .. payout)
            end
            return
        end
    end

    TriggerClientEvent('QBCore:Notify', src, _U('nothing_to_sell'), 'error', 2500)
end)
