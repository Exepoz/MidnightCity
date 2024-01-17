Config = {}
Config.DB = {}

-------             CONFIGURATION          --------           
---------------------------------------------------

Config.EnableDebug                          = false                 -- Whether to enable debug prints or not

Config.ESXSkin                              = "AK"                  -- AK for ak47 or Default for esx_skin

Config.DefaultDarkMode                      = 1                     -- Whether dark mode should be enabled by default. 1 is on by default, 0 is off

Config.ServerName                           = "Midnight City"
Config.ServerDiscord                        = "discord.gg/m-g-n" -- For kick/ban messages
Config.ScreenshotWebhook                    = ""
Config.LogsWebhook                          = ""

Config.NoClipKey                            = "9"
Config.AdminPanelKey                        = "0"
Config.ShowNamesKey                         = "8"

Config.EnableAdminPanelCommand              = true                  -- Whether to enable the admin panel command (/a by default)
Config.AdminPanelCommand                    = "a"

Config.NoClipType                           = 1                     -- 1 (default) NEW txAdmin-like NoClip system, or 2 for old style 919Admin NoClip system, or 3 for default qbcore NoClip system

Config.ShowIPInIdentifiers                  = false                 -- Whether to show player's IPs in the identifiers box in player info view

Config.EnableReportCommand                  = true                  -- Enable or disable the report command if you use another report system (reports tab will still show)
Config.ReportCommand                        = "report"              -- The command to use for reports (default /report)
Config.MaxReportsPerPlayer                  = 2                     -- The maximum amount of reports a player can place
Config.SaveTOJSON                           = true                  -- Whether to save reports and admichat to JSON onResourceStopped (server restarts etc) and load from JSON on resource start

Config.DB.VehiclesTable                     = "player_vehicles"     -- Standards: player_vehicles   for QBCore  | user_vehicle   for ESX
Config.DB.CharactersTable                   = "players"             -- Standards: players           for QBCore  | users          for ESX
Config.DB.BansTable                         = "bans"

Config.AnnounceBan                          = true                  -- Whether to announce bans in chat or not
Config.TagEveryone                          = true                 -- Enable to tag everyone in the discord log on ban

Config.EnableNames                          = true                  -- Whether or not to enable the names overhead
Config.AllPlayersUseNames                   = false                 -- Wheter or not all players can use the overhead names
Config.NamesOverSelfHead                    = true                  -- Whether or not your name and id should be over your own head or not

Config.FuelScript                           = 'cdn-fuel'

Config.Permissions = {
    ["god"] = {
        AllowedActions = {
            "characterspage", -- Access the All Characters page
            "resourcepage", -- Access the Resource control page
            "deletecharacter", -- Delete a character
            "kickall", -- Kick all players
            "reviveall", -- Revive all players
            "messageall", -- Message all players
            "massdeleteentities", -- Permission to delete ALL vehicles, peds, or objects for all players
            "setViewDistance", -- Set view distance
            "copyEntityInfo", -- Copy entity information
            "freeaimMode", -- Enable free aim mode
            "displayVehicles", -- Display vehicle dev mode
            "displayPeds", -- Display peds dev mode
            "displayObjects", -- Display objects dev mode
            "clearreports", --Clear reports ADVISE TO KEEP TO GOD ONLY!
            "clearadminchat", --Clear adminchat ADVISE TO KEEP TO GOD ONLY!
            "clearlogs", --Clear logslist ADVISE TO KEEP TO GOD ONLY!
            "leaderboardinfo", --Check the leaderboards
        },
    },
    ["admin"] = {
        AllowedActions = {
            "characterspage", -- Access the All Characters page
            "resourcepage", -- Access the Resource control page
            "deletecharacter", -- Delete a character
            "kickall", -- Kick all players
            "reviveall", -- Revive all players
            "messageall", -- Message all players
            "massdeleteentities", -- Permission to delete ALL vehicles, peds, or objects for all players
            "setViewDistance", -- Set view distance
            "copyEntityInfo", -- Copy entity information
            "freeaimMode", -- Enable free aim mode
            "displayVehicles", -- Display vehicle dev mode
            "displayPeds", -- Display peds dev mode
            "displayObjects", -- Display objects dev mode
            "clearreports", --Clear reports ADVISE TO KEEP TO GOD ONLY!
            "clearadminchat", --Clear adminchat ADVISE TO KEEP TO GOD ONLY!
            "clearlogs", --Clear logslist ADVISE TO KEEP TO GOD ONLY!
            "leaderboardinfo", --Check the leaderboards
            "adminmenu", -- Open the admin menu
            "viewreports", -- Access the reports list
            "claimreport", -- Claim a report
            "deletereport", -- Delete a report
            "adminchat", -- Access the admin chat
            "serverlogs", -- Access the server logs page
            "servermetrics", -- Access the server metrics page
            "jobpage", -- Access the jobs page
            "gangpage", -- Access the gangs page
            "banspage", -- Access the bans page
            "vehiclesinfo", -- Access the vehicle spawn code list page
            "itemsinfo", -- Access the item spawn code list page
            "noclip", -- Noclip
            "teleport", -- Teleport yourself, others, to location
            "kill", -- Kill yourself, others
            "freeze", -- Freeze a player
            "savedata", -- Save player data
            "ban", -- Ban a player from the server
            "unban", -- Unban a player
            "weather", -- Change the server weather
            "time", -- Change the server time
            "givetakemoney", -- Give or take money from a player
            "warn", -- Warn a player
            "checkwarns", -- Check the warnings of a player
            "revive", -- Revive a player
            "foodandwater", -- Feed a player
            "relievestress", -- Relieve stress of a player
            "setpedmodel", -- Set a player's ped model
            "spectate", -- Spectate a player
            "screenshot", -- Screenshot a player
            "savecar", -- Save a car to a player's garage
            "spawncar", -- Spawn a vehicle
            "clearinventory", -- Clear inventory
            "openinventory",
            "setjob", -- Set job of a player
            "setgang", -- Set gang of a player
            "firejob", -- Fire a player from their job
            "firegang", -- Fire a player from their gang
            "giveitem", -- Give a player an item, or several thousand
            "skinmenu", -- Give a player the skin menu
            "setmedriver", -- Teleport into nearest vehicle as driver
            "setmepassenger", -- Teleport into nearest vehicle as passenger
            "deleteclosestvehicle", -- Delete closest vehicle
            "deleteclosestped", -- Delete closest ped
            "deleteclosestobject", -- Delete closest object
            "repairvehicle", -- Repair a vehicle
            "washvehicle", -- Wash a vehicle
            "lockvehicle", -- Lock a vehicle
            "unlockvehicle", -- Unlock a vehicle
            "maxperformanceupgrades", -- Max performance upgrades (vehicle)
            "randomvisualparts", -- Random visual parts (vehicle)
            "setlivery", -- Set liver (vehicle)
            "setcolor", -- Set color (vehicle)
            "fillgastank", -- Fill gas tank (vehicle)
            "clearblood", -- Clear blood from clothes
            "wetclothes", -- Wet clothes
            "dryclothes", -- Dry clothes
            "forceradar", -- Force minimap on
            "playerblips", -- Toggle player location blips
            "playernames", -- Toggle player location blips
            "invisibility", -- Toggle invisibility
            "godmode", -- Toggle god mode
            "fastrun", -- Toggle fast run
            "superjump", -- Toggle super jump
            "noragdoll", -- Toggle no ragdoll
            "infinitestam", -- Toggle infinite stamina
            "uncuffSelf", -- Uncuff yourself
            "cuff",
            "copyEntityInfo",
            "setViewDistance",
            "freeaimMode",
            "displayVehicles",
            "displayPeds",
            "displayObjects",
        },
    },
    ["mod"] = {
        Power = 50,
        AllowedActions = {
            "adminmenu", -- Open the admin menu
            "viewreports", -- Access the reports list
            "claimreport", -- Claim a report
            "deletereport", -- Delete a report
            "adminchat", -- Access the admin chat
            "jobpage", -- Access the jobs page
            "gangpage", -- Access the gangs page
            "banspage", -- Access the bans page
            "noclip", -- Noclip
            "teleport", -- Teleport yourself, others, to location
            "freeze", -- Freeze a player
            "savedata", -- Save player data
            "kick", -- Kick a player from the server
            "weather", -- Change the server weather
            "time", -- Change the server time
            "warn", -- Warn a player
            "checkwarns", -- Check the warnings of a player
            "revive", -- Revive a player
            "spectate", -- Spectate a player
            "screenshot", -- Screenshot a player
            "setjob", -- Set job of a player
            "setgang", -- Set gang of a player
            "firejob", -- Fire a player from their job
            "firegang", -- Fire a player from their gang
            "setmedriver", -- Teleport into nearest vehicle as driver
            "setmepassenger", -- Teleport into nearest vehicle as passenger
            "deleteclosestvehicle", -- Delete closest vehicle
            "deleteclosestped", -- Delete closest ped
            "deleteclosestobject", -- Delete closest object
            "repairvehicle", -- Repair a vehicle
            "washvehicle", -- Wash a vehicle
            "lockvehicle", -- Lock a vehicle
            "unlockvehicle", -- Unlock a vehicle
            "clearblood", -- Clear blood from clothes
            "wetclothes", -- Wet clothes
            "dryclothes", -- Dry clothes
            "playerblips", -- Toggle player location blips
            "playernames", -- Toggle player location blips
            "kick", -- Kick a player from the server
            "uncuffSelf", -- Uncuff yourself
            "cuff",
            "copyEntityInfo",
            "setViewDistance",
            "freeaimMode",
            "displayVehicles",
            "displayPeds",
            "displayObjects",
        },
    }
}


-------                  KEYS              --------           
---------------------------------------------------


Config.Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


-------               FUNCTIONS            --------           
---------------------------------------------------

function DebugTrace(message)
    if Config.EnableDebug then
        print("^3[919DESIGN Admin ("..GetCurrentResourceName()..")]^7 "..message)
    end
end

function print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

local entityEnumerator = {
    __gc = function(enum)
      if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
      end
      enum.destructor = nil
      enum.handle = nil
    end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
      local iter, id = initFunc()
      if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
  
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
  
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end