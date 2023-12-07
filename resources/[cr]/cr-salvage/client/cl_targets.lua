local ScrapyardPed = nil
local ScrapyardWreck = nil
local WorldWreckEntity = nil
local WorldWreckSpawnEventEntity = nil
local ScrapyardPedPoint, ScrapyardWreckPoint, WorldWreckPoint, HandIn, WorldWreckSpawnEventPoint, text

function InteractionsDistanceCheck()
    if Config.Framework.Interaction.OxLibDistanceCheck then
        -- luacheck: push ignore
        if Config.WorldWrecks['plane'].onSpawnEvent then
            HandIn = lib.points.new(Config.FlightBox.HandInCoords.xyz, 2)
            function HandIn:onEnter() SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_handinflightbox')) end
            function HandIn:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:giveFlightBox') end end
            function HandIn:onExit() SCUtils.SalvageDrawText(false) end
        end
        ScrapyardPedPoint = lib.points.new(Config.ScrapyardPed.Coords.xyz, 2)
        function ScrapyardPedPoint:nearby()
            if not text then SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_talkto').." "..Lcl('interact_pedname')) text = true end
            if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:talktoped', {ped = ScrapyardPed, page = 1}) end
            Wait(1)
        end
        function ScrapyardPedPoint:onExit() if text then SCUtils.SalvageDrawText(false) text = false end end
        --luacheck: pop
    else
        CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pcoords = GetEntityCoords(ped)
                local wait = 5000
                if Config.WorldWrecks['plane'].onSpawnEvent then
                    local dist = #(pcoords - Config.FlightBox.HandInCoords.xyz)
                    if dist < 100 then wait = 1 end
                    if dist <= 2 then
                        if not text then SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_handinflightbox')) text = true end
                        if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:giveFlightBox') end
                    elseif dist <= 2.2 then
                        if text then SCUtils.SalvageDrawText(false) text = false end
                    end
                end
                if DoesEntityExist(ScrapyardPed) then
                    local dist = #(pcoords - Config.ScrapyardPed.Coords.xyz)
                    if dist < 50 then wait = 1 end
                    if dist <= 2 then
                        if not text then SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_talkto').." "..Lcl('interact_pedname')) text = true end
                        if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:talktoped', {ped = ScrapyardPed, page = 1}) end
                    elseif dist <= 2.2 then
                        if text then SCUtils.SalvageDrawText(false) text = false end
                    end
                end
                if DoesEntityExist(ScrapyardWreck) then
                    local dist = #(pcoords - GetEntityCoords(ScrapyardWreck))
                    if dist < 50 then wait = 1 end
                    if dist <= 2 then
                        if not text then SCUtils.SalvageDrawText(true, Lcl('interact_usepowersaw')) text = true end
                    elseif dist <= 2.2 then
                        if text then SCUtils.SalvageDrawText(false) text = false end
                    end
                end
                if DoesEntityExist(WorldWreckEntity) then
                    local dist = #(pcoords - GetEntityCoords(WorldWreckEntity))
                    if dist < 50 then wait = 1 end
                    if dist <= 2 then
                        if not text then SCUtils.SalvageDrawText(true, Lcl('interact_usepowersaw')) text = true end
                    elseif dist <= 2.2 then
                        if text then SCUtils.SalvageDrawText(false) text = false end
                    end
                end
                if DoesEntityExist(WorldWreckSpawnEventEntity) then
                    local dist = #(pcoords - GetEntityCoords(WorldWreckSpawnEventEntity))
                    if dist < 50 then wait = 1 end
                    if dist <= 2 then
                        if not text then SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_take')) text = true end
                        if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:TakeFlightBox', {box = WorldWreckSpawnEventEntity}) end
                    elseif dist <= 2.2 then
                        if text then SCUtils.SalvageDrawText(false) text = false end
                    end
                end
                Wait(wait)
            end
        end)
    end
end

-- Scrapyard Ped Interaction
---@param sped number - Entity ID to have the target on/DrawText Show up
function ScrapPedTarget(sped)
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {
                { name = "tutorial", type = "client", event = "cr-salvage:client:tutorial", icon = "far fa-question-circle", label = Lcl('interact_scrapyardtutorial'), page = 1 },
                { name = "buy", type = "client", event = "cr-salvage:client:buy", icon = "fas fa-dollar-sign", label = Lcl('interact_scrapyardshop'),
                canInteract = function() if Config.ScrapyardPed.Shop then return true else return false end end },
                { name = "dis_emailnotif", type = "client", event = "cr-salvage:client:emailnotification", icon = "fas fa-envelope", label = Lcl('interact_disableemailnotif'),
                canInteract = function() if not LocalPlayer.state.cr_salvage_emails then return false else return true end end },
                { name = "en_emailnotif", type = "client", event = "cr-salvage:client:emailnotification", icon = "fas fa-envelope", label = Lcl('interact_getemailnotif'),
                canInteract = function() if LocalPlayer.state.cr_salvage_emails then return false else return true end end }
            }
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("scrapyardped", sped, { name = "scrapyardped", heading = GetEntityHeading(sped), debugPoly = Config.DebugPoly}, { options = options, distance = 1.5 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                exports['ox_target']:addLocalEntity(sped, options)
            end
        end
    end)
end

-- Scrapyard Wreck Interaction
---@param wreck number - Entity ID to have the target on/DrawText Show up
function SetupWreckTarget(wreck)
    if Config.Framework.Interaction.UseTarget then
        local options = {{ name = "harvest", type = "client", event = "cr-salvage:client:harvest", icon = "fas fa-car-crash", label = Lcl("interact_scrap"), wreck = wreck, yard = true }}
        if Config.Framework.Interaction.Target == "qb-target" then
            exports['qb-target']:AddEntityZone("scrapyardwreckage", wreck, {name = "scrapyardwreckage", heading = GetEntityHeading(wreck), debugPoly = Config.DebugPoly}, {options = options, distance = 1.5})
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            exports['ox_target']:addLocalEntity(wreck, options)
        end
    else
        if Config.Framework.Interaction.OxLibDistanceCheck then
            local coords = GetEntityCoords(wreck)
            ScrapyardWreckPoint = lib.points.new(coords, 3)
            text = false
            --luacheck: push ignore
            function ScrapyardWreckPoint:nearby()
                if not text then SCUtils.SalvageDrawText(true, Lcl('interact_usepowersaw')) text = true end
                Wait(1)
            end
            function ScrapyardWreckPoint:onExit() if text then SCUtils.SalvageDrawText(false) text = false end end
            --luacheck: pop
        else
            ScrapyardWreck = wreck
        end
    end
end

-- World Wreck Target
---@param wreck number - Entity ID to have the target on/DrawText Show up
function SetupWorldWreckTarget(wreck)
    if Config.Framework.Interaction.UseTarget then
        local options = {{ name = "harvest", type = "client", event = "cr-salvage:client:harvest", icon = "fas fa-car-crash", label = Lcl("interact_scrap"), wreck = wreck, wtype = "plane" }}
        if Config.Framework.Interaction.Target == "qb-target" then
            exports['qb-target']:AddEntityZone("worldwreck", wreck, {name = "worldwreck", heading = GetEntityHeading(wreck), debugPoly = Config.DebugPoly, }, {options = options, distance = 2.0})
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            exports['ox_target']:addLocalEntity(wreck, options)
        end
    else
        if Config.Framework.Interaction.OxLibDistanceCheck then
            WorldWreckPoint = lib.points.new(GetEntityCoords(wreck), 3)
            text = false
            --luacheck: push ignore
            function WorldWreckPoint:nearby()
                if not text then SCUtils.SalvageDrawText(true, Lcl('interact_usepowersaw')) text = true end
                Wait(1)
            end
            function WorldWreckPoint:onExit() if text then SCUtils.SalvageDrawText(false) text = false end end
            --luacheck: pop
        else
            WorldWreckEntity = wreck
        end
    end
end

-- World Wreck Spawn Event Target
---@param entity number - Entity ID to have the target on/DrawText Show up
function WWSpawnEventTarget(entity)
    if Config.Framework.Interaction.UseTarget then
        if GlobalState.CRSalvage.WorlWreckType == "plane" then
            local options = {{type = "client", event = "cr-salvage:client:TakeFlightBox", icon = "fas fa-hand", label = Lcl('interact_take'), box = entity}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddTargetEntity(entity, { options = {
                { type = "client", event = "cr-salvage:client:TakeFlightBox", icon = "fas fa-hand", label = Lcl('interact_take'), box = entity}}, distance = 2.0 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                local netID = NetworkGetNetworkIdFromEntity(entity)
                exports['ox_target']:addEntity(netID, options)
            end
        end
    else
        if Config.Framework.Interaction.OxLibDistanceCheck then
            WorldWreckSpawnEventPoint = lib.points.new(GetEntityCoords(entity), 3)
            text = false
            --luacheck: push ignore
            function WorldWreckSpawnEventPoint:nearby()
                if not text then SCUtils.SalvageDrawText(true, "["..Config.InteractKey.."] "..Lcl('interact_take')) text = true end
                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then TriggerEvent('cr-salvage:client:TakeFlightBox', {box = entity}) end
                Wait(1)
            end
            function WorldWreckSpawnEventPoint:onExit() if text then SCUtils.SalvageDrawText(false) text = false end end
            --luacheck: pop
        else
            WorldWreckSpawnEventPoint = entity
        end
    end
end

-- Flight Box Handing Interaction (Ped to give box to)
function SetupFlightBoxTarget()
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local FlightBox = Config.FlightBox
            if Config.WorldWrecks['plane'].onSpawnEvent then
                local options = {{ name = "give", type = "client", event = "cr-salvage:client:giveFlightBox", icon = "fas fa-hand", label = Lcl('interact_handinflightbox')}}
                if Config.Framework.Interaction.Target == "qb-target" then
                    exports['qb-target']:AddBoxZone("fboxhandin", FlightBox.HandInCoords.xyz , 1.0, 1.0,
                    { name = "fboxhandin", heading = FlightBox.HandInCoords.w, debugPoly = Config.DebugPoly, minZ = FlightBox.HandInCoords.z - 1.0, maxZ = FlightBox.HandInCoords.z + 1.0 }, { options = options, distance = 2.5 })
                elseif Config.Framework.Interaction.Target == "oxtarget" then
                    exports['ox_target']:addBoxZone({ coords = FlightBox.HandInCoords.xyz, size = vec3(1, 1, 2), rotation = FlightBox.HandInCoords.w, debug = Config.DebugPoly, options = options })
                end
            end
        end
    end)
end


function DeletePoint(loc)
    if loc == "yard" and ScrapyardWreckPoint then ScrapyardWreckPoint:remove()
    elseif loc == "ww" and WorldWreckPoint then WorldWreckPoint:remove()
    elseif loc == "wwSpawnEvent" and WorldWreckPoint then WorldWreckSpawnEventPoint:remove() end
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    if Config.Framework.Interaction.UseTarget then
        if Config.Framework.Interaction.OxLibDistanceCheck then
            if ScrapyardWreckPoint then ScrapyardWreckPoint:remove() end
            if WorldWreckPoint then WorldWreckPoint:remove() end
            if WorldWreckSpawnEventPoint then WorldWreckSpawnEventPoint:remove() end
            if HandIn then HandIn:remove() end
        elseif Config.Framework.Interaction.Target == "qb-target" then
            exports['qb-target']:RemoveZone("WWSpawnEventEntity")
            exports['qb-target']:RemoveZone("fboxhandin")
            exports['qb-target']:RemoveZone("scrapyardped")
            exports['qb-target']:RemoveZone("scrapyardwreckage")
            exports['qb-target']:RemoveZone("worldwreck")
        end
    end
   end
end)