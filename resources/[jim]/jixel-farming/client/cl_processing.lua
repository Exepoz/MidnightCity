function HasMetaItem(items, amount)
    local amount, count = amount or 1, 0
    local pData = QBCore.Functions.GetPlayerData()
    if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end
    for _, itemData in pairs(pData.items) do
        if itemData and (itemData.name == items) and (itemData.info.quality > 0) then
            if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
            count += itemData.amount
        end
    end
    if count >= amount then if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end return true end
    if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end	return false
end

RegisterNetEvent(
    "jixel-farming:Crafting:MakeItem",
    function(data)
        if Config.DebugOptions.Debug then
            print(string.format("^5Debug: ^3Crafting:MakeItem: ^0\n>Item: ^2%s^0 ^0\n>Header: ^2%s^0", data.item, data.header))
        end
        if data.header == Loc[Config.CoreOptions.Lan].header["header_juicer"] then
            animDictNow = "mini@repair"
            animNow = "fixing_a_ped"
        elseif data.header == Loc[Config.CoreOptions.Lan].header["header_pestle"] then
            animDictNow = "amb@prop_human_bbq@male@base"
            animNow = "base"
        elseif data.header == Loc[Config.CoreOptions.Lan].header["header_processor"] then
            animDictNow = "amb@prop_human_bbq@male@base"
            animNow = "base"
        elseif data.header == Loc[Config.CoreOptions.Lan].header["header_meatprocessor"] then
            animDictNow = "melee@hatchet@streamed_core_fps"
            animNow = "plyr_front_takedown_b"
        elseif data.header == Loc[Config.CoreOptions.Lan].header["header_chickenprocessor"] then
            animDictNow = "anim@heists@prison_heiststation@cop_reactions"
            animNow = "cop_b_idle"
        elseif data.header == Loc[Config.CoreOptions.Lan].header["header_milkprocess"] then
            animDictNow = "mp_ped_interaction"
            animNow = "handshake_guy_a"
        end
        if
            progressBar(
                {
                    label = Loc[Config.CoreOptions.Lan].progress["progress_making"] ..
                        QBCore.Shared.Items[data.item].label,
                    time = 5000,
                    dict = animDictNow,
                    anim = animNow,
                    flag = 48,
                    cancel = true,
                    icon = data.item
                }
            )
        then
            TriggerServerEvent("jixel-farming:Crafting:GetItem", data.item, data.craft)
            Wait(500)
            TriggerEvent("jixel-farming:Crafting", data)
        else
            ClearPedTasks(PlayerPedId())
            TriggerEvent("inventory:client:busy:status", false)
        end
    end
)

RegisterNetEvent("jixel-farming:Crafting",
    function(data)
        local Menu = {}
        if Config.CoreOptions.Menu == "qb" then
            Menu[#Menu + 1] = {header = data.header, txt = "", isMenuHeader = true}
            Menu[#Menu + 1] = {
                icon = "fas fa-circle-xmark",
                header = "",
                txt = Loc[Config.CoreOptions.Lan].menu["close"],
                params = {event = ""}
            }
        end
        Menu[#Menu+1] = {icon = "fas fa-circle-info", header = 'Tip :', description = 'Packages are only considered "Organic" when made with ONLY organic ingredients', readOnly = true, }
        for i = 1, #data.craftable do
            for k, v in pairs(data.craftable[i]) do
                if k ~= "amount" and k ~= "rep" then
                    local text = ""
                    local rep = data.craftable[i].rep
                    local farmingrep = QBCore.Functions.GetPlayerData().metadata.farmingrep
                    local setheader = QBCore.Shared.Items[tostring(k)].label
                    -- check crafting recipe for rep, then add it to the title of the item
                    if data.craftable[i]["amount"] ~= nil then
                        setheader = setheader .. " x" .. data.craftable[i]["amount"]
                    end
                    if Config.ScriptOptions.FarmingRep and data.craftable[i].rep ~= nil then
                        rep = data.craftable[i].rep
                        setheader = setheader .. " [ Rep: " .. rep .. " ]"
                    end
                    local disable = false
                    local checktable = {}
                    for l, b in pairs(data.craftable[i][tostring(k)]) do
                        if b == 1 then
                            number = ""
                        else
                            number = " x" .. b
                        end
                        if Config.CoreOptions.Menu == "ox" then
                            text = text .. QBCore.Shared.Items[l].label .. number .. "\n"
                        end
                        if Config.CoreOptions.Menu == "qb" then
                            text = text .. "- " .. QBCore.Shared.Items[l].label .. number .. "<br>"
                        end
                        settext = text
                        checktable[l] = HasMetaItem(l, b)
                    end
                    for _, v in pairs(checktable) do
                        if v == false then
                            if Config.DebugOptions.Debug and not disable then print("^5Debug: ^3Crafting: ^0Menu option disabled, you do not have the required items for: ^2"..k.."^0") end
                            disable = true
                        end
                    end
                    if Config.ScriptOptions.FarmingRep and (farmingrep == nil or farmingrep <= data.craftable[i].rep) then
                        if Config.DebugOptions.Debug then
                            if farmingrep == nil then
                                print(string.format("^5Debug: ^3Crafting: ^0Menu option disabled rep is missing: ^2%s", tostring(farmingrep)))
                            else
                                print(string.format("^5Debug: ^3Crafting: ^0Menu option disabled you do not have enough rep: ^%s/%s^0 for item ^2%s^0", tostring(farmingrep), tostring(data.craftable[i].rep), k))
                            end
                        end
                        disable = true
                    end
                    if not disable then
                        setheader = setheader .. "✔️"
                    end
                    Menu[#Menu + 1] = {
                        isMenuHeader = disable,
                        disabled = (Config.CoreOptions.Menu == "ox" and disable),
                        icon = "nui://" .. Config.CoreOptions.img .. QBCore.Shared.Items[k].image,
                        header = setheader,
                        txt = settext,
                        params = {
                            event = "jixel-farming:Crafting:MakeItem",
                            args = {
                                item = k,
                                craft = data.craftable[i],
                                craftable = data.craftable,
                                header = data.header
                            }
                        },
                        title = setheader,
                        description = settext,
                        event = "jixel-farming:Crafting:MakeItem",
                        args = {item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header}
                    }
                    settext, setheader = nil
                end
            end
        end
        if Config.CoreOptions.Menu == "ox" then
            exports.ox_lib:registerContext(
                {id = "Crafting", title = data.header, position = "top-right", options = Menu}
            )
            exports.ox_lib:showContext("Crafting")
        else
            exports["qb-menu"]:openMenu(Menu)
        end
        lookEnt(data.coords)
    end
)

local animalalive = nil
RegisterNetEvent(
    "jixel-farming:client:slaughterAnimal",
    function(data)
        local player = PlayerPedId()
        if data.animal == "cow" then
            model = "a_c_cow"
            item = "cowtag"
        elseif data.animal == "pig" then
            model = "a_c_pig"
            item = "alivepig"
        end
        if HasMetaItem(item, 1) then
            local animalSlaughterCoord = vector3(989.31, -2183.84, 30.62)
            local collisionPoint = vector3(984.69, -2183.47, 30.67)
            local spawnAnimalCoord = vector3(972.55, -2182.22, 29.98)
            local entity = makePed(model, spawnAnimalCoord, 0, nil, nil, nil)
            animalalive = entity
            local entityCoords = GetEntityCoords(entity)
            local playerCoords = GetEntityCoords(player)
            local effect = "ent_dst_chick_carcass"
            local waitAnimDict = "amb@world_human_cop_idles@female@idle_a"
            local waitAnimName = "idle_a"
            loadAnimDict(waitAnimDict)
            TaskPlayAnim(player, waitAnimDict, waitAnimName, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            if not IsPedHeadingTowardsPosition(entity, animalSlaughterCoord, 20.0) then
                TaskTurnPedToFaceCoord(entity, playerCoords, 1500)
                Wait(1500)
            end
            if not IsPedHeadingTowardsPosition(player, entityCoords, 20.0) then
                TaskTurnPedToFaceCoord(player, entityCoords.xyz, 1500)
                Wait(1500)
            end
            FreezeEntityPosition(player, true)
            if data.animal == "pig" then
                TaskGoStraightToCoord(entity, animalSlaughterCoord, 0.5, 12000, 0.0, 0)
            else
                TaskGoStraightToCoord(entity, animalSlaughterCoord, 0.5, 10000, 0.0, 0)
            end
            while #(GetEntityCoords(entity) - animalSlaughterCoord) > 0.8 do
                Wait(0)
            end
            Wait(1000)
            if Config.ScriptOptions.ParticleFXEnabled then
                CreateThread(
                    function()
                        loadPtfxDict("core")
                        UseParticleFxAssetNextCall("core")
                        local particle =
                            StartParticleFxLoopedAtCoord(
                            effect,
                            GetEntityCoords(entity).x,
                            GetEntityCoords(entity).y,
                            GetEntityCoords(entity).z,
                            0.0,
                            0.0,
                            GetEntityHeading(entity) - 180.0,
                            2.5,
                            0.0,
                            0.0,
                            0.0
                        )
                        Wait(5000)
                        StopParticleFxLooped(particle, true)
                    end
                )
            end
            if
                progressBar(
                    {
                        label = Loc[Config.CoreOptions.Lan].progress["progress_killing"] .. data.animal,
                        time = math.random(4000, 8000),
                        cancel = true,
                        dict = "melee@hatchet@streamed_core_fps",
                        anim = "plyr_front_takedown_b",
                        flag = 16
                    }
                )
             then
                Wait(1000)
                DeleteEntity(entity)
                local amount = AnimalSettings.Cows.SlaughterZone.MeatReward()
                TriggerServerEvent("jixel-farming:server:toggleItem", false, item, 1)
                if data.animal == "cow" then
                    TriggerServerEvent("jixel-farming:server:toggleItem", true, "rawbeef", amount)
                end
                if data.animal == "pig" then
                    TriggerServerEvent("jixel-farming:server:toggleItem", true, "rawpork", amount)
                end
                for i, discord in ipairs(Discord.SlaughterReports) do
                    if discord then
                        TriggerServerEvent(
                            "jixel-farming:server:SlaughterDiscordLog",
                            {colour = 1942002, htmllink = discord.link},
                            data.animal,
                            amount
                        )
                    end
                end
                animalalive = nil
                FreezeEntityPosition(player, false)
                unloadAnimDict(waitAnimDict)
                ClearPedTasks(player)
            else
            end
        else
            return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["no_animal"], "error")
        end
    end
)

AddEventHandler(
    "onResourceStop",
    function(resource)
        if resource == GetCurrentResourceName() then
            if animalalive ~= nil then
                DeleteEntity(animalalive)
            end
        end
    end
)
