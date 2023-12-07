local Trays = {}
local pcoords
local oxTargets = {}
local oxPoints = {}
LocalPlayer.state:set('textui', false, true)

function SetupCRFleecaBanks(abank)
    Citizen.CreateThread(function()
        local SafeLabel = Lcl('target_AttemptSafe')
        local SafeSize = {l = 0.3, w = 0.6}
        local SwipeSize = {l = 0.2, w = 0.2}
        if Config.Framework.MLO == "Gabz" then
            SafeLabel = Lcl('target_BreakBoxes')
            SafeSize = {l = 0.3, w = 2.5}
            SwipeSize = {l = 0.5, w = 0.2}
        end
        if Config.Framework.Interaction.UseTarget then
            for i=1, #Config.Banks, 1 do
                if abank then if i ~= abank then goto continue end end
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "table")
                --TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "tray")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "tellerdoor")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "printer")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "computer")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "lootsafe")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "safe")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "card")
                TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "prevault")
                for j=1, 3, 1 do
                    TriggerEvent("cr-fleecabankrobbery:client:DeleteZones", i, "depobox", j)
                    --exports['qb-target']:RemoveZone("DepBox_"..i..j)
                end
                ::continue::
            end
            for k, v in pairs(Config.Banks) do
                if abank then if k ~= abank then goto continue end end

                local DoorOptions = {{name = "crTellerDoor"..k, type = "client", event = "cr-fleecabankrobbery:client:FleecaBankTellerDoors", icon = "fas fa-user-secret", label = Lcl('target_TellerDoors'), bank = k}}
                local ComputerOptions = {{name = "crFleecaComputer"..k, type = "client", event = "cr-fleecabankrobbery:client:FleecaBankUSBUsage", icon = "fa-solid fa-bug", label = Lcl('target_TellerComputers')}}
                local PrevaultOptions = {{name = "crPreVault"..k, type = "client", event = "cr-fleecabankrobbery:client:UnlockPreVault", icon = "fa-solid fa-table-cells", label = Lcl('target_PreVaultDoors'), bank = k}}
                local SafeOptions = {{name = "crFleecaSafe"..k, type = "client", event = "cr-fleecabankrobbery:client:AttemptSafe", icon = "fa-solid fa-vault", label = SafeLabel, bank = k, canInteract = function() if v.Safe.Busy then return false else return true end end }}
                local CardOptions =  {{name = "crVaultSwipe"..k, type = "client", event = "cr-fleecabankrobbery:client:VaultCard", icon = "fa-solid fa-credit-card", label = Lcl('target_VaultCards'), bank = k }}

                if Config.Framework.Interaction.Target == "qb-target" then
                    exports['qb-target']:AddBoxZone("FleecaTellerDoor"..k, v.TellerDoors.coords, 0.2, 0.2, {name = "FleecaTellerDoor"..k, heading = v.TellerDoors.heading, debugPoly = Config.DebugPoly, minZ = v.TellerDoors.minZ, maxZ = v.TellerDoors.maxZ}, {options = DoorOptions})
                    exports['qb-target']:AddBoxZone("FleecaTellerComputer"..k, v.ComputerCoords.coords, 0.2, 0.5, {name = "FleecaTellerComputer"..k, heading = v.ComputerCoords.heading, debugPoly = Config.DebugPoly, minZ = v.ComputerCoords.minZ, maxZ = v.ComputerCoords.maxZ}, {options = ComputerOptions})
                    exports['qb-target']:AddBoxZone("FleecaPreVaultDoor"..k, v.PreVaultDoor.coords, 0.2, 0.2, {name = "FleecaPreVaultDoor"..k, heading = v.PreVaultDoor.heading, debugPoly = Config.DebugPoly, minZ = v.PreVaultDoor.minZ, maxZ = v.PreVaultDoor.maxZ}, {options = PrevaultOptions})
                    exports['qb-target']:AddBoxZone("FleecaSafe"..k, v.Safe.coords, SafeSize.l, SafeSize.w, {name = "FleecaSafe"..k, heading = v.Safe.heading, debugPoly = Config.DebugPoly, minZ = v.Safe.minZ, maxZ = v.Safe.maxZ}, {options = SafeOptions})
                    exports['qb-target']:AddBoxZone("FleecaVaultCard"..k, v.CardSwipe.coords, SwipeSize.l, SwipeSize.w, {name = "FleecaVaultCard"..k, heading = v.CardSwipe.heading, debugPoly = Config.DebugPoly, minZ = v.CardSwipe.minZ, maxZ = v.CardSwipe.maxZ}, {options = CardOptions})
                elseif Config.Framework.Interaction.Target == "oxtarget" then
                    local mlo = Config.Framework.MLO
                    local oxPos, oxSize
                    oxTargets[k] = {}
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.3) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.3) end
                    oxTargets[k].Teller = exports['ox_target']:addBoxZone({coords = v.TellerDoors.coords+oxPos, size = oxSize, rotation = v.TellerDoors.heading, debug = Config.DebugPoly, options = DoorOptions})
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.2, 0.2) end
                    oxTargets[k].Computer = exports['ox_target']:addBoxZone({coords = v.ComputerCoords.coords+oxPos, size = oxSize, rotation = v.ComputerCoords.heading, debug = Config.DebugPoly, options = ComputerOptions})
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.4) elseif mlo == "Gabz" then oxPos = vec3(0,0,0.1) oxSize = vec3(0.2, 0.2, 0.2) end
                    oxTargets[k].PreVault = exports['ox_target']:addBoxZone({coords = v.PreVaultDoor.coords+oxPos, size = oxSize, rotation = v.PreVaultDoor.heading, debug = Config.DebugPoly, options = PrevaultOptions})
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0.1) oxSize = vec3(0.55, 0.6, 0.7) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(3.0, 0.3, 2.0) end
                    oxTargets[k].Safe = exports['ox_target']:addBoxZone({coords = v.Safe.coords+oxPos, size = oxSize, rotation = v.Safe.heading, debug = Config.DebugPoly, options = SafeOptions})
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0.45) oxSize = vec3(0.2, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.5, 0.6) end
                    oxTargets[k].Card = exports['ox_target']:addBoxZone({coords = v.CardSwipe.coords+oxPos, size = oxSize, rotation = v.CardSwipe.heading, debug = Config.DebugPoly, options = CardOptions})
                end
                ::continue::
            end
        else
            if Config.Framework.Interaction.OxLibDistanceCheck then
                for k, v in pairs(Config.Banks) do
                    oxPoints[k] = {}

                    local DoorPoint = lib.points.new(v.TellerDoors.coords, 1)
                    function DoorPoint:onEnter() if not Config.Banks[k].TellerDoors.Occupied then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_TellerDoors')) end end
                    function DoorPoint:onExit() FBCUtils.DrawText(false) end
                    function DoorPoint:nearby() if not Config.Banks[k].TellerDoors.Occupied then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankTellerDoors', {bank = k}) end end
                    end
                    oxPoints[k].Teller = DoorPoint

                    local ComputerPoint = lib.points.new(v.ComputerCoords.coords, 1)
                    function ComputerPoint:onEnter() if not Config.Banks[k].ComputerCoords.isHacked then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_TellerComputers')) end end
                    function ComputerPoint:onExit() FBCUtils.DrawText(false) end
                    function ComputerPoint:nearby() if not Config.Banks[k].ComputerCoords.isHacked then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankUSBUsage', {bank = k}) end end
                    end
                    oxPoints[k].Computer = ComputerPoint

                    local PreVaultPoint = lib.points.new(v.PreVaultDoor.coords, 1)
                    function PreVaultPoint:onEnter() if not Config.Banks[k].PreVaultDoor.Oppened then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_PreVaultDoors')) end end
                    function PreVaultPoint:onExit() FBCUtils.DrawText(false) end
                    function PreVaultPoint:nearby() if not Config.Banks[k].PreVaultDoor.Oppened then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:UnlockPreVault', {bank = k}) end end
                    end
                    oxPoints[k].PreVault = PreVaultPoint

                    local SafePoint = lib.points.new(v.Safe.coords, 1)
                    function SafePoint:onEnter() if not Config.Banks[k].Safe.Busy then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..SafeLabel) end end
                    function SafePoint:onExit() FBCUtils.DrawText(false) end
                    function SafePoint:nearby() if not Config.Banks[k].Safe.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:AttemptSafe', {bank = k}) end end
                    end
                    oxPoints[k].Safe = SafePoint

                    local CardPoint = lib.points.new(v.CardSwipe.coords, 1)
                    function CardPoint:onEnter() if not Config.Banks[k].CardSwipe.Swiped then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultCards')) end end
                    function CardPoint:onExit() FBCUtils.DrawText(false) end
                    function CardPoint:nearby() if not Config.Banks[k].CardSwipe.Swiped then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:VaultCard', {bank = k}) end end
                    end
                    oxPoints[k].Card = CardPoint
                end
            else
                local ped = PlayerPedId()
                local ItemShown = false
                local CurrentItem
                while true do
                    local wait = 5000
                    while LocalPlayer.state['closestbank'] == nil do Wait(5000) end
                    local bank = LocalPlayer.state['closestbank']
                    pcoords = GetEntityCoords(ped)
                    if #(pcoords - vector3(Config.Banks[bank].loc[1], Config.Banks[bank].loc[2], Config.Banks[bank].loc[3])) < 15 then wait = 5 end
                    if not Config.Banks[bank].TellerDoors.Occupied then
                        local dist = #(pcoords - Config.Banks[bank].TellerDoors.coords)
                        if dist < 2.0 then
                            if dist < 1.0 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_TellerDoors')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', true, true) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankTellerDoors', {bank = bank}) end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                        end
                    end
                    if not Config.Banks[bank].ComputerCoords.isHacked then
                        local dist = #(pcoords - Config.Banks[bank].ComputerCoords.coords)
                        if dist < 2.0 then
                            if dist < 1.0 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_TellerComputers')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankUSBUsage') end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                        end
                    end
                    if not Config.Banks[bank].PreVaultDoor.Oppened then
                        local dist = #(pcoords - Config.Banks[bank].PreVaultDoor.coords)
                        if dist < 2.0 then
                            if dist < 1.0 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_PreVaultDoors')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:UnlockPreVault', {bank = bank}) end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                        end
                    end
                    if not Config.Banks[bank].Safe.Busy then
                        local dist = #(pcoords - Config.Banks[bank].Safe.coords)
                        if dist < 2.0 then
                            if dist < 1.0 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_AttemptSafe')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:AttemptSafe', {bank = bank}) end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                        end
                    end
                    if not Config.Banks[bank].CardSwipe.Swiped then
                        local dist = #(pcoords - Config.Banks[bank].CardSwipe.coords)
                        if dist < 1.0 then
                            if not ItemShown then CurrentItem = Config.Items.VaultCardItem FBCUtils.ShowItem(CurrentItem, true) ItemShown = true end
                        else
                            if ItemShown then FBCUtils.ShowItem(CurrentItem, false) CurrentItem = nil ItemShown = false end
                        end
                    else if ItemShown then FBCUtils.ShowItem(CurrentItem, false) CurrentItem = nil ItemShown = false end end
                    Wait(wait)
                end
            end
        end
    end)
end

function ActivatePrinter(bank)
    local Printer = Config.Banks[bank].Printer
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crFleecaPrinter"..bank, type = "client", event = "cr-fleecabankrobbery:client:FleecaBankPrinters", icon = "fas fa-user-print", label = Lcl('target_Printers'), bank = bank}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddBoxZone("FleecaPrinter"..bank, Printer.coords, 1, 1, { name="FleecaPrinter"..bank, heading = Printer.heading, debugPoly = Config.DebugPoly, minZ = Printer.minZ, maxZ = Printer.maxZ, }, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets[bank].Printer = exports['ox_target']:addBoxZone({coords = Printer.coords, size = vector3(1.0, 1.0, 1.0), rotation = Printer.heading, debug = Config.DebugPoly, options = options})
            end
        else
            if Config.Framework.Interaction.OxLibDistanceCheck then
                local Point = lib.points.new(Printer.coords, 1)
                function Point:onEnter() FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_Printers')) end
                function Point:onExit() FBCUtils.DrawText(false) end
                function Point:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankPrinters', {bank = bank}) end
                end
                oxPoints[bank].Printer = Point
            else
                local PrinterActive = true
                while PrinterActive do
                    local wait = 10000
                    local dist = #(pcoords - Printer.coords)
                    if dist <= 50 then wait = 1 end
                    if dist <= 1.5 then
                        if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_Printers')) LocalPlayer.state:set('textui', true, true) end
                    if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankPrinters', {bank = bank}) PrinterActive = false end
                    else
                        if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                    end
                    Wait(wait)
                end
            end
        end
    end)
end

function ActivateSafeLoot(bank)
    local Safe = Config.Banks[bank].Safe
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crFleecaSafeLoot"..bank, type = "client", event = "cr-fleecabankrobbery:client:FleecaBankLootSafe", icon = "fas fa-user-vault", label = Lcl('target_LootSafe'), bank = bank}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddBoxZone("FleecaSafeLoot"..bank, Safe.coords, 0.3, 0.6, { name="FleecaSafeLoot"..bank, heading = Safe.heading, debugPoly = Config.DebugPoly, minZ = Safe.minZ, maxZ = Safe.maxZ, }, { options = options, distance = 1.5 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets[bank].OpennedSafe = exports['ox_target']:addBoxZone({coords = Safe.coords+vec3(0.0,0.0,0.1), size = vector3(0.55, 0.6, 0.7), rotation = Safe.heading, debug = Config.DebugPoly, options = options})
            end
        else
            if Config.Framework.Interaction.OxLibDistanceCheck then
                local Point = lib.points.new(Safe.coords, 1)
                function Point:onEnter() if not Safe.IsLooted then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_LootSafe')) end end
                function Point:onExit() FBCUtils.DrawText(false) end
                function Point:nearby() if not Safe.IsLooted then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankLootSafe', {bank = bank}) Safe.IsLooted = true end end
                end
                oxPoints[bank].OpennedSafe = Point
            else
                while not Safe.IsLooted do
                    local wait = 10000
                    local dist = #(pcoords - Safe.coords)
                    if dist <= 50 then wait = 1 end
                    if dist <= 1.5 then
                        if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_LootSafe')) LocalPlayer.state:set('textui', true, true) end
                        if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                            FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:FleecaBankLootSafe', {bank = bank}) Safe.IsLooted = true
                        end
                    else
                        if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                    end
                    Wait(wait)
                end
            end
        end
    end)
end

function ActivateTableTarget(loot, bank)
    if not DoesEntityExist(loot) then return end
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crFleecaTable"..bank, type = "client", event = "cr-fleecabankrobbery:client:GrabTableLoot", icon = "fas fa-user-hand", label = Lcl('target_GrabLoot'), bank = bank, loot = loot}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("TableLoot_"..bank, loot, { name="TableLoot_"..bank, heading = GetEntityHeading(loot), debugPoly = Config.DebugPoly }, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets[bank].Table = exports['ox_target']:addBoxZone({coords = GetEntityCoords(loot), size = vector3(0.8, 0.8, 0.5), rotation = GetEntityHeading(loot), debug = Config.DebugPoly, options = options})
            end
        else
            if Config.Framework.Interaction.OxLibDistanceCheck then
                local TablePoint = lib.points.new(Config.Banks[bank].Table.coords, 1)
                function TablePoint:onEnter() if not Config.Banks[bank].Table.grabbed then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabLoot')) end end
                function TablePoint:onExit() FBCUtils.DrawText(false) end
                function TablePoint:nearby() if not Config.Banks[bank].Table.grabbed then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:GrabTableLoot', {bank = bank, loot = loot}) end end
                end
                oxPoints[bank].Table = TablePoint
            else
                while true do
                    local wait = 10000
                    local coords = vector3(Config.Banks[bank].loc.x, Config.Banks[bank].loc.y, Config.Banks[bank].loc.z)
                    local dist = #(pcoords - coords)
                    if dist <= 50 then wait = 1 end
                    if not Config.Banks[bank].Table.grabbed then
                        local tabledist = #(pcoords - Config.Banks[bank].Table.coords)
                        if tabledist <= 0.9 then
                            if tabledist <= 0.8 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabLoot')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:GrabTableLoot', {bank = bank, loot = loot}) end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                        end
                    end
                    Wait(wait)
                end
            end
        end
    end)
end

function ActivateTrayFinder(MaxTrays)
    if not Config.Framework.Interaction.UseTarget then
        TriggerServerEvent('cr-fleecabankrobbery:server:UpdateGlobalState', 'PickedUpTrays', 0)
        CreateThread(function()
            while true do
                local text = ""
                local bank = LocalPlayer.state['closestbank']
                local pCoords = GetEntityCoords(PlayerPedId())
                if #(pCoords - vector3(Config.Banks[bank].loc.x,Config.Banks[bank].loc.y,Config.Banks[bank].loc.z)) < 15 then
                    local _, hcoords, entity = LootAtEntity(3.0)
                    for _, v in pairs(Trays) do
                        local dist = #(pCoords - GetEntityCoords(v.entity))
                        if dist < 1.1 then
                            if hcoords.x ~= 0.0 and hcoords.y ~= 0.0 and entity == v.entity and not v.grabbed then
                                text = "~g~["..Config.InteractKey.."]~w~ "..Lcl('target_GrabLoot')
                                SetEntityDrawOutline(v.entity, true)
                                SetEntityDrawOutlineColor(227, 175, 49, 200)
                                if IsControlPressed(0, Config.KeyList[Config.InteractKey]) then
                                    v.grabbed = true
                                    TriggerEvent('cr-fleecabankrobbery:client:GrabTrayLoot', {tray = v.entity, loc = v.loc})
                                    TriggerServerEvent('cr-fleecabankrobbery:server:UpdateGlobalState', 'PickedUpTrays', GlobalState.PickedUpTrays + 1)
                                end
                            elseif entity == v.entity and v.grabbed then
                                SetEntityDrawOutline(v.entity, false)
                            end
                        else
                            SetEntityDrawOutline(v.entity, false)
                        end
                    end
                else break end
                if GlobalState.PickedUpTrays and GlobalState.PickedUpTrays >= MaxTrays then TriggerServerEvent('cr-fleecabankrobbery:server:UpdateGlobalState', 'PickedUpTrays', 0) break end
                ShowText(text, 4, {255, 255, 255}, 0.4, 0.55, 0.888 + 0.025)
                Wait(1)
            end
        end)
    end
end

function ActivateTrayTargets(tray, loc, bank)
    if Config.Debug then print(Lcl('debug_createtraytarget', tray, loc)) end
    if not DoesEntityExist(tray) then print(Lcl('debug_trayspawnerror', tray)) return end
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crFleecaTray"..loc, type = "client", event = "cr-fleecabankrobbery:client:GrabTrayLoot", icon = "fas fa-hand", label = Lcl('target_GrabLoot'), tray = tray, loc = loc }}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("FleecaTray_"..tray, tray, { name="FleecaTray_"..tray, heading = GetEntityHeading(tray), debugPoly = Config.DebugPoly}, { options = options, distance = 1.5 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                if not oxTargets[bank].Trays then oxTargets[bank].Trays = {} end
                oxTargets[bank].Trays[loc] = exports['ox_target']:addLocalEntity(tray, options)
            end
        else
            Trays[bank..loc] = {loc = loc, entity = tray}
        end
    end)
end

function ActivateBoxesTargets(bank)
    Citizen.CreateThread(function()
        for wall, va in pairs(Config.Banks[bank].DepositBoxes) do
            if Config.Framework.Interaction.UseTarget then
                local l, w = 2.0, 0.2
                if Config.Framework.MLO == "Gabz" then w = 0.6 end
                local options = {{name = "crDepoBox"..bank..wall, type = "client", event = "cr-fleecabankrobbery:client:DrillBoxes", icon = "fas fa-unlock-alt", label = Lcl('target_DepositBoxes'), box = wall}}
                if Config.Framework.Interaction.Target == "qb-target" then
                    exports['qb-target']:AddBoxZone("DepBox_"..bank..wall, va.coords, l, w, { name="DepBox_"..bank..wall, heading = va.heading, debugPoly = Config.DebugPoly, minZ = va.minZ, maxZ = va.maxZ, }, { options = options, distance = 1.0 })
                elseif Config.Framework.Interaction.Target == "oxtarget" then
                    oxTargets[bank]["DepositBox"..wall] = exports['ox_target']:addBoxZone({coords = va.coords, size = vector3(0.5, 2.0, 2.0), rotation = va.heading, debug = Config.DebugPoly, options = options})
                end
            else
                if Config.Framework.Interaction.OxLibDistanceCheck then
                    local Point = lib.points.new(va.coords, 1)
                    function Point:onEnter() if not va.Busy then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_DepositBoxes')) end end
                    function Point:onExit() FBCUtils.DrawText(false) end
                    function Point:nearby() if not va.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        FBCUtils.DrawText(false) TriggerEvent('cr-fleecabankrobbery:client:DrillBoxes', {box = wall}) end end
                    end
                    oxPoints[bank]["DepositBox"..wall] = Point
                else
                    while true do
                        local pCoords = GetEntityCoords(PlayerPedId())
                        local walldist = #(pCoords - va.coords)
                        if walldist < 15 then
                            if walldist < 0.8 then
                                if not LocalPlayer.state['textui'] then FBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_DepositBoxes')) LocalPlayer.state:set('textui', true, true) end
                                if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                                    FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) TriggerEvent('cr-fleecabankrobbery:client:DrillBoxes', {box = wall}) end
                            else
                                if LocalPlayer.state['textui'] then FBCUtils.DrawText(false) LocalPlayer.state:set('textui', false, true) end
                            end
                            Wait(1)
                        else break end
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("cr-fleecabankrobbery:client:DeleteZones", function(bank, zone, pos)
    if Config.Framework.Interaction.UseTarget then
        if Config.Framework.Interaction.Target == "qb-target" then
            if zone == "table" then exports['qb-target']:RemoveZone("TableLoot_"..bank)
            elseif zone == "tray" then exports['qb-target']:RemoveZone("FleecaTray_"..pos)
            elseif zone == "depobox" then exports['qb-target']:RemoveZone("DepBox_"..bank..pos)
            elseif zone == "tellerdoor" then exports['qb-target']:RemoveZone("FleecaTellerDoor"..bank)
            elseif zone == "printer" then exports['qb-target']:RemoveZone("FleecaPrinter"..bank)
            elseif zone == "computer" then exports['qb-target']:RemoveZone("FleecaTellerComputer"..bank)
            elseif zone == "lootsafe" then exports['qb-target']:RemoveZone("FleecaSafeLoot"..bank)
            elseif zone == "safe" then exports['qb-target']:RemoveZone("FleecaSafe"..bank)
            elseif zone == "card" then exports['qb-target']:RemoveZone("FleecaVaultCard"..bank)
            elseif zone == "prevault" then exports['qb-target']:RemoveZone("FleecaPreVaultDoor"..bank)
            end
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            if not oxTargets[bank] then return end
            if zone     == "table" and oxTargets[bank].Table then exports['ox_target']:removeZone(oxTargets[bank].Table)
            elseif zone == "tray" and oxTargets[bank].Trays and oxTargets[bank].Trays[pos] then exports['ox_target']:removeZone(oxTargets[bank].Trays[pos])
            elseif zone == "depobox" and oxTargets[bank]['DepositBox'..pos] then exports['ox_target']:removeZone(oxTargets[bank]['DepositBox'..pos])
            elseif zone == "tellerdoor" and oxTargets[bank].Teller then exports['ox_target']:removeZone(oxTargets[bank].Teller)
            elseif zone == "printer" and oxTargets[bank].Printer then exports['ox_target']:removeZone(oxTargets[bank].Printer)
            elseif zone == "computer" and oxTargets[bank].Computer then exports['ox_target']:removeZone(oxTargets[bank].Computer)
            elseif zone == "lootsafe" and oxTargets[bank].OpennedSafe then exports['ox_target']:removeZone(oxTargets[bank].OpennedSafe)
            elseif zone == "safe" and oxTargets[bank].Safe then exports['ox_target']:removeZone(oxTargets[bank].Safe)
            elseif zone == "card" and oxTargets[bank].Card then exports['ox_target']:removeZone(oxTargets[bank].Card)
            elseif zone == "prevault" and oxTargets[bank].PreVault then exports['ox_target']:removeZone(oxTargets[bank].PreVault)
            end
        end
    else
        if Config.Framework.Interaction.OxLibDistanceCheck then
            if zone == "table" then oxPoints[bank].Table:remove()
            elseif zone == "tray" then Trays[bank..pos] = nil
            elseif zone == "depobox" then oxPoints[bank]['DepositBox'..pos]:remove()
            elseif zone == "tellerdoor" then oxPoints[bank].Teller:remove()
            elseif zone == "printer" then oxPoints[bank].Printer:remove()
            elseif zone == "computer" then oxPoints[bank].Computer:remove()
            elseif zone == "lootsafe" then oxPoints[bank].OpennedSafe:remove()
            elseif zone == "safe" then oxPoints[bank].Safe:remove()
            elseif zone == "card" then oxPoints[bank].Card:remove()
            elseif zone == "prevault" then oxPoints[bank].PreVault:remove()
            end
        else
            if zone == "prevault" then Config.Banks[bank].PreVaultDoor.Oppened = true
            elseif zone == "tray" then Trays[pos] = nil SetEntityDrawOutline(pos, false)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then
        if Config.Framework.Interaction.OxLibDistanceCheck then return end
        if Config.Framework.Interaction.Target == "oxtarget" then return end
        for i=1, 5, 1 do
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "table")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "tellerdoor")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "printer")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "computer")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "lootsafe")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "safe")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "card")
            TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "prevault")
            for j=1, 3, 1 do
                TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "tray", j)
                TriggerEvent('cr-fleecabankrobbery:client:DeleteZones', i, "depobox", j)
            end
        end
    end
end)