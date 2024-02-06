local QBCore = exports['qb-core']:GetCoreObject()
LocalPlayer.state:set('isHunting', false, true)
local currentTarget = 0
local precision = 0
local targetBlip
local gettingNewPrey, claimingBounty = false, false

--- Checks if the player is currently a bounty hunter
---@return boolean -- Bool ~ is the player bounty hunting?
Midnight.Functions.isHunting = function() return LocalPlayer.state.isHunting end

--- Processes the death of individuals by players at night time.
local processDeath = function()
    Midnight.Functions.Debug('Processing Death...')
    if not Midnight.Functions.IsNightTime() then return end
    local ped = PlayerPedId()
    local killer
    local killerPed = GetPedSourceOfDeath(ped)
    if IsEntityAPed(killerPed) and IsPedAPlayer(killerPed) then
        killer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))
        Midnight.Functions.Debug('Sending Killer Info to server. ('..killer..')')
        TriggerServerEvent('nighttime:server:processDeath', killer, checkIsInsideGreenZone())
    end
end exports('processDeath', processDeath)

--- Scan an other player to find out if they are the current player's target
---@param v table -- Arguments from ox_target regarding the targetted individual
local identifyIndividual = function(v)
    QBCore.Functions.Progressbar('identifyI', 'Identifying...', 15000, false, true,
    {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    exports['rpemotes']:EmoteCommandStart('texting'), {}, {}, function()
        if #(GetEntityCoords(v.entity) - GetEntityCoords(PlayerPedId())) > 3.0 then QBCore.Functions.Notify('The individual is too far...') return end
        exports['rpemotes']:EmoteCancel()
        --GetNearestPlayerToEntity(v.entity) works too
        if GetPlayerFromServerId(currentTarget) == NetworkGetPlayerIndexFromPed(v.entity) then
            TriggerServerEvent('nighttime:server:preyFound', currentTarget)
            QBCore.Functions.Notify("Positive ID. Individual Registers as Current Prey.", 'success')
        else
            QBCore.Functions.Notify("Neagtive ID. Individual is NOT the Current Prey.", 'error')
        end
    end, function()
        exports['rpemotes']:EmoteCancel()
    end)
end

--- Makes & Updates the Bounty Hunter Target Blip
---@param loc vec3 -- Coordinates of the prey.
local makeTargetBlip = function(loc)
    if targetBlip then RemoveBlip(targetBlip) end
    local p = 500.0 - (precision * 50)
    if p <= 0 then
        targetBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(targetBlip, 303)
        SetBlipFlashes(targetBlip, true)
        SetBlipHiddenOnLegend(targetBlip, true)
    else
        local oX, oY = math.random(-1*p/2, p/2), math.random(-1*p/2, p/2)
        targetBlip = AddBlipForRadius(loc.x+oX, loc.y+oY, loc.z, p)
        SetBlipAlpha(targetBlip, 64)
    end
    SetBlipColour(targetBlip, 1)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
end

--- Handler to make user stop being a bounty hunter.
Midnight.Functions.stopHunting = function()
    if targetBlip then RemoveBlip(targetBlip) end
    LocalPlayer.state:set('isHunting', false, true)
    TriggerServerEvent('nighttime:stopHunting')
end

--- Handler to fetch a new target if the current one is lost or cycled.
---@param v? table Menu Handler if the player requested the new target (Reopens menu if v.man = true)
Midnight.Functions.getNewTarget = function(v)
    if gettingNewPrey or not Midnight.Functions.isHunting() then return end
    gettingNewPrey = true
    QBCore.Functions.Notify('Find New Prey...')
    if DoesBlipExist(targetBlip) then RemoveBlip(targetBlip) end
    precision = 0 Wait(1000)
    QBCore.Functions.TriggerCallback('mdn-bountyHunt:getNewTarget', function(target, loc)
        Midnight.Functions.Debug("Received Target : "..(target or "NIL"))
        if not target then
            QBCore.Functions.Notify('No Preys Available, Please try again later.' , 'error') Midnight.Functions.Debug("No Target Found") currentTarget = 0
        else
            currentTarget = target
        end
        if v and v.man == true then TriggerEvent('openHuntDongle') end
        if not currentTarget or currentTarget == 0 then
            QBCore.Functions.Notify('No Preys Available, Please try again later.' , 'error')
        else
            Wait(1500) QBCore.Functions.Notify('New Prey Acquired.', 'success')
            makeTargetBlip(loc)
        end
        Wait(30000) gettingNewPrey = false Wait(100)
        if lib.getOpenContextMenu() == 'bountyDongle' then TriggerEvent('openHuntDongle') end
    end)
end

-- Handler to starts the bounty hunt loop & enter the game
local startHunting = function()
    QBCore.Functions.Notify('Searching for prey...')
    --Wait(math.random(15, 30)*1000)
    precision = 0
    TriggerServerEvent('nighttime:server:startHunting')
    QBCore.Functions.TriggerCallback('mdn-bountyHunt:getNewTarget', function(target)
        Midnight.Functions.Debug("Received Target : "..(target or "NIL"))
        if not target then
            QBCore.Functions.Notify('No Preys Available, Please try again later.' , 'error') Midnight.Functions.Debug("No Target Found") currentTarget = 0
        else
            currentTarget = target
        end
        Wait(1000)
        Citizen.CreateThread(function()
            QBCore.Functions.Notify('You are now hunting. Good Luck.', 'success')
            while Midnight.Functions.isHunting() do
                local w = 60000
                Midnight.Functions.Debug("Current Target : "..currentTarget)
                if not gettingNewPrey and currentTarget ~= 0 then
                    Midnight.Functions.Debug("Fetching Location...")
                    QBCore.Functions.TriggerCallback('mdn-bountyHunt:getTargetLocation', function(loc)
                        if loc == "notFound" then
                            QBCore.Functions.Notify('The Prey has been lost...', 'error')
                            Wait(2000)
                            Midnight.Functions.getNewTarget()
                        else
                            Midnight.Functions.Debug('Making Blip Area')
                            makeTargetBlip(loc)
                            precision = precision + 1
                        end
                    end, currentTarget)
                    if precision > 10 then w = 60000 - (10000 * -1*(10-precision)) if w < 10000 then w = 10000 end end
                end
                if currentTarget == 0 then w = 15000 end
                Wait(w)
            end
        end)
    end)
end

--- Handler to check own user's profile & stats
local checkProfile = function()
    QBCore.Functions.TriggerCallback('nighttime:server:getHunterInfo', function(data)
        if not data then createHunterProfile()
        else
            -- nickname
            -- hunting points
        end
    end)
end

--- Handler to claim the prey's bounty after killing them
local claimBounty = function(data)
    QBCore.Debug(data)
    if claimingBounty then return end
    claimingBounty = true
    local ped = PlayerPedId()
    TaskTurnPedToFaceEntity(ped, data.entity, 1500) Wait(1500)
    QBCore.Functions.Progressbar('claimBounty', 'Reaping Reward...', 15000, false, true,
    {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
    exports['rpemotes']:EmoteCommandStart('medic'), {}, {}, function()
        if #(GetEntityCoords(data.entity) - GetEntityCoords(PlayerPedId())) > 3.0 then QBCore.Functions.Notify('The individual is too far...') return end
        exports['rpemotes']:EmoteCancel()
        if data.isHunter then
            TriggerServerEvent('nighttime:server:stealPoints', data)
        else
            --GetNearestPlayerToEntity(v.entity) works too
            if GetPlayerFromServerId(currentTarget) == NetworkGetPlayerIndexFromPed(data.entity) then TriggerServerEvent('nighttime:server:claimBounty', currentTarget)
            else QBCore.Functions.Notify("This is not your prey anymore....", 'error') end
        end
    end, function()
        exports['rpemotes']:EmoteCancel()
    end)
end

--- Handler Received from server when selecting a BP as target.
RegisterNetEvent('nighttime:client:selectBloodyPrey', function(data)
    Midnight.Functions.Debug('Bloody Prey Selected : '..data.source)
    currentTarget = data.source
    precision = 10
    QBCore.Functions.TriggerCallback('mdn-bountyHunt:getTargetLocation', function(loc)
        if loc == "notFound" then
            QBCore.Functions.Notify('The Prey has been lost...', 'error')
            Wait(2000)
            Midnight.Functions.getNewTarget()
        else
            Midnight.Functions.Debug('Making Blip Area')
            makeTargetBlip(loc)
        end
    end, currentTarget)
end)

local selectPrey = function(data)
    if not Midnight.Functions.isHunting() then QBCore.Functions.Notify('You are not hunting currently...', 'error') return end
    local alert = lib.alertDialog({
        header = 'Attention!',
        content = 'Despite knowing your target\'s location at all times, you must remember to follow the rules of the hunt.\n'..
                'You are not allowed to kill someone in an protected area. You can only kill your target **outside** of a protected area.\n\n'..
                'Do you wish to proceed?',
        centered = true,
        cancel = true
    })
    if alert ~= 'confirm' then return end
    Midnight.Functions.Debug('Sending Bloody Prey Data to Server')
    TriggerServerEvent('nighttime:server:selectBloodyPrey', data)
end

--- Handler to check the bloody prey menu
local seeBloodyPreys = function(data)
    local disabled = data.blacklisted or not Midnight.Functions.isHunting() or not Midnight.Functions.IsNightTime()
    local desc = 'Cannot find target.'
    if data.blacklisted then desc = "~ !! BLACKLISTED !! ~"
    elseif not Midnight.Functions.IsNightTime() then desc = "Not Night Time."
    elseif not Midnight.Functions.isHunting() then desc = "Not hunting currently." end
    QBCore.Functions.TriggerCallback('mdn-bountyHunt:fetchBloodyPreys', function(preys)
        local options = {}
        for _, v in ipairs(preys) do
            local locdesc = disabled and desc or v.online and 'Select to hunt target' or desc
            options[#options+1] = {
                title = v.name,
                description = "~ "..v.prize.." Crumbs Reward ~\n"..locdesc,
                icon = 'fas fa-skull',  disabled = disabled or data.blacklisted or not v.online or claimingBounty,
                onSelect = selectPrey, args = v
            }
        end
        lib.registerContext({id = 'currentPreys', title = 'Current Bloody Preys',  options = options, menu = 'bountyDongle' })
        lib.showContext('currentPreys')
    end)
end

local function safeJob()

end

RegisterNetEvent('nighttime:addBountyDied', function(ped, bodyID, isHunter)
    Midnight.Functions.Debug('Adding Claim Bounty Target to ped '..ped, bodyID, isHunter)
    if isHunter then
        exports.ox_target:addGlobalPlayer({ name = 'claimBounty_'..bodyID, icon = 'fas fa-sack-dollar', canInteract = function(e) return GetPlayerPed(GetPlayerFromServerId(ped)) == e and not claimingBounty end, label = "Steal Unclaimed Points", distance = 2.0, onSelect = claimBounty, isHunter = isHunter, bodyID = bodyID, hSrc = ped})
    else
        --currentTarget = 0
        exports.ox_target:addGlobalPlayer({ name = 'claimBounty_'..bodyID, icon = 'fas fa-sack-dollar', canInteract = function(e) return GetPlayerPed(GetPlayerFromServerId(ped)) == e and not claimingBounty end, label = "Claim Bounty", distance = 2.0, onSelect = claimBounty, })
    end
end)

RegisterNetEvent('nighttime:client:alertIsBloody', function()
    exports['qb-phone']:PhoneNotification('The Hunt', "You've been marked as a Bloody Prey.", 'fas fa-crosshairs', '#5c0707', 10000)
end)

RegisterNetEvent('nighttime:client:bountyCooldown', function(ped)
    QBCore.Functions.Notify('You succesfully reaped your bounty, good job.', 'success')
    if targetBlip then RemoveBlip(targetBlip) end
    currentTarget = 0
    claimingBounty = true
    Wait(10000) QBCore.Functions.Notify('You will soon get a new prey.', 'info')
    Wait(2*60000)
    claimingBounty = false
    Midnight.Functions.getNewTarget()
end)

RegisterNetEvent('openHuntDongle', function()
    if not QBCore.Functions.HasItem('bh_dongle') then PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1) return end
    QBCore.Functions.TriggerCallback('nighttime:fetchUserData', function(data, dongleID)
        if dongleID and dongleID ~= QBCore.Functions.GetPlayerData().citizenid then QBCore.Functions.Notify('This dongle does not belong to you...', 'error') return end
        if not data then
            TriggerEvent('nighttime:client:createHuntProfile')
        else
            local options = {}
            options[#options+1] = {title = '**Welcome,** '..data.nickname, readOnly = true, description = data.blacklisted and "~ !! BLACKLISTED !! ~" or "Bounty Points : "..data.points.." | Unclaimed : "..data.unclaimed.." | Banked : "..data.bank}
            if Midnight.Functions.isHunting() then
                options[#options+1] = {title = 'Next Target', disabled = data.blacklisted or gettingNewPrey or not Midnight.Functions.IsNightTime(), description = gettingNewPrey and 'On Cooldown.' or 'Receive a new prey for you to hunt.', onSelect = Midnight.Functions.getNewTarget, args = {man = true}}
                options[#options+1] = {title = 'Stop Hunting', disabled = not LocalPlayer.state.inGreenZone, description = LocalPlayer.state.inGreenZone and 'Stop receiving targets.' or 'Can only do this while inside of a Safe Haven.', onSelect = Midnight.Functions.stopHunting}
            else options[#options+1] = {title = 'Search for Bounty', disabled = data.blacklisted or not Midnight.Functions.IsNightTime(), description = data.blacklisted and "~ !! BLACKLISTED !! ~" or Midnight.Functions.IsNightTime() and 'Take part of the hunt and receive the locations of preys.' or 'Wait for the hunt to begin at night.', onSelect = startHunting} end
            -- options[#options+1] = {title = 'Check Profile', description = 'Take a look at your Bounty Hunter Profile.', onSelect = checkProfile}
            options[#options+1] = {title = 'See Bloody Preys', disabled = data.blacklisted, description = data.blacklisted and "~ !! BLACKLISTED !! ~" or 'See everyone who is marked for death by the Golden Trail.', onSelect = seeBloodyPreys, args = data}
            options[#options+1] = {title = 'Diner Reservation', disabled = data.blacklisted, description = data.blacklisted and "~ !! BLACKLISTED !! ~" or 'You\'ve got some bodies to take care of?', event = 'mdn-extras:client:useHTPhone'}
            lib.registerContext({id = 'bountyDongle', title = 'Bounty Finder',  options = options })
            lib.showContext('bountyDongle')
        end
    end)
end)

RegisterNetEvent('nighttime:client:createHuntProfile', function()
    exports['qb-phone']:ClosePhone()
    local alert = lib.alertDialog({
        header = 'No Profile Found',
        content = 'No Hunter Profile Matching your fingerprint found in The Golden Trail Database. Please enter an alias to go by.',
        centered = true,
        cancel = true
    })
    if alert ~= 'confirm' then return end
    local input = lib.inputDialog('Create Hunter Profile', {{type = 'input', label = 'Create Alias', description = 'Chose a name to go by in the bounty hunter world.', required = true, min = 3, max = 21},})
    if not input or not input[1] then return end
    alert = lib.alertDialog({
        header = 'Confirm Alias',
        content = 'Are you sure you want to go by : **'..input[1].."**?",
        centered = true,
        cancel = true
    })
    if alert ~= 'confirm' then return end
    TriggerServerEvent('nighttime:server:createHunterProfile', input[1])
end)

Citizen.CreateThread(function()
    local options = {
        [1] = { name = 'idTarget', label = "Identify Potential Prey", icon = 'fas fa-person-circle-question', distance = 2.0, canInteract = (Midnight.Functions.isHunting() and Midnight.Functions.IsNightTime()), onSelect = identifyIndividual},
    }
    exports.ox_target:addGlobalPlayer(options)
end)