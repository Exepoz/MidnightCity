local Trays, oxTargets,oxPoints = {}, {}, {}
local pcoords
local drawing, drawn
LocalPlayer.state:set('textui', false, true)


-- on reset = drawn = nil

function SetupPaletoBank()
    drawn = nil
    local t = Config.Targets
    Citizen.CreateThread(function()
        local KPLabel, KPSize = Lcl('target_VaultKeypad'), {l = 0.2, w = 0.2}
        if Config.Framework.MLO == "Gabz" then
            KPLabel = Lcl('target_VaultKeypad') KPSize = {l = 0.3, w = 0.5}
        end
        if Config.Framework.Interaction.UseTarget then
            if Config.Framework.Interaction.Target == "qb-target" then
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "SecSeq")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultComputer")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultKeypad")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "ManagerDoor")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OutsideKeypad")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OutsideDepo")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "CorridorDoor")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InnerVaultKeypad")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Printer")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "GabzTray")
                TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InstallDrill")
                for i = 1, 4 do
                    TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OfficeDoor", i)
                    TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OfficeComputer", i)
                    TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Wall", i)
                    TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InnerBox", i)
                end
            end

            local Options_SecSeqDoor = {{name = "crpaleto_SecSeqDoor", type = "client", event = "cr-paletobankrobbery:client:TellerDoor", icon = "fas fa-user-secret", label = Lcl('target_TellerDoor')}}
            local Options_VaultComputer = {{name = "crpaleto_VaultComputer", type = "client", event = "cr-paletobankrobbery:client:VaultComputer", icon = "fa-solid fa-bug", label = Lcl('target_VaultComputer')}}
            local Options_VaultKeypad = {{name = "crpaleto_VaultKeypad", type = "client", event = "cr-paletobankrobbery:client:VaultKeypad", icon = "fa-solid fa-table-cells", label = Lcl('target_VaultKeypad')}}
            local Options_ManagerDoor = {{name = "crpaleto_ManagerDoor", type = "client", event = "cr-paletobankrobbery:client:ManagerDoor", icon = "fa-solid fa-key", label = Lcl('target_UnlockDoor')}}
            local Options_OutsideKeypad =  {{name = "crpaleto_OutsideKeypad", type = "client", event = "cr-paletobankrobbery:client:OutsideKeypad", icon = "fa-solid fa-credit-card", label = Lcl('target_VaultCards')}}
            local Options_OutsideDepo =  {{name = "crpaleto_OutsideDepo", type = "client", event = "cr-paletobankrobbery:client:UseSaw", icon = "fa-solid fa-burst", label = Lcl('target_BreakBoxes'), coords = t.OutDepo.coords}}
            local Options_CorridorDoor =  {{name = "crpaleto_CorridorDoor", type = "client", event = "cr-paletobankrobbery:client:UnlockCorridor", icon = "fa-solid fa-lock-open", label = Lcl('target_UnlockDoor')}}
            local Options_InstallDrill =  {{name = "crpaleto_InstallDrill", type = "client", event = "cr-paletobankrobbery:client:InstallDrill", icon = "fa-solid fa-tools", label = Lcl('target_InstallDrill'), canInteract = function() if Config.Targets.Drill.isOpenned or Config.Targets.Drill.Busy then return false end return true end},
            {name = "crpaleto_InstallDrill2", type = "client", event = "cr-paletobankrobbery:client:collectSafe", icon = "fa-solid fa-hands", label = Lcl('target_LootSafe'), canInteract = function() if Config.Targets.Drill.isOpenned and not Config.Targets.Drill.Busy then return true end return false end}}

            -- K4MB1 Only
            local Options_InnerVaultKeypad =  {{name = "crpaleto_InnerVaultKeypad", type = "client", event = "cr-paletobankrobbery:client:VaultKeypad", icon = "fa-solid fa-table-cells", label = KPLabel, inner = true}}
            --local Options_BombGate =  {{name = "crpaleto_BombGate", type = "client", event = "cr-paletobankrobbery:client:BombGate", icon = "fa-solid fa-table-cells", label = Lcl('target_BombDoor')}}

            --local Options_InstallDrill =  {{name = "crpaleto_InstallDrill", type = "client", event = "cr-paletobankrobbery:client:InstallDrill", icon = "fa-solid fa-tools", label = Lcl('target_InstallDrill'), canInteract = false}, --function() if Config.Targets.Drill.isOpenned or Config.Targets.Drill.Busy then return false end return true end},
            --{name = "crpaleto_InstallDrill2", type = "client", event = "cr-paletobankrobbery:client:collectSafe", icon = "fa-solid fa-hands", label = Lcl('target_LootSafe'), }}--canInteract = function() if Config.Targets.Drill.isOpenned and not Config.Targets.Drill.Busy then return true end return false end}}

            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddBoxZone("crpaleto_SecSeqDoor", t.SecSeq.coords, 0.2, 0.2, {name = "crpaleto_SecSeqDoor", heading = t.SecSeq.heading, debugPoly = Config.DebugPoly, minZ = t.SecSeq.minZ, maxZ = t.SecSeq.maxZ}, {options = Options_SecSeqDoor, distance = 2})
                --exports['qb-target']:AddBoxZone("crpaleto_VaultComputer", t.VaultComputer.coords, 0.2, 0.7, {name = "crpaleto_VaultComputer", heading = t.VaultComputer.heading, debugPoly = Config.DebugPoly, minZ = t.VaultComputer.minZ, maxZ = t.VaultComputer.maxZ}, {options = Options_VaultComputer})
                exports['qb-target']:AddBoxZone("crpaleto_VaultKeypad", t.VaultKeypad.coords, 0.2, t.VaultKeypad.width, {name = "crpaleto_VaultKeypad", heading = t.VaultKeypad.heading, debugPoly = Config.DebugPoly, minZ = t.VaultKeypad.minZ, maxZ = t.VaultKeypad.maxZ}, {options = Options_VaultKeypad})
                exports['qb-target']:AddBoxZone("crpaleto_ManagerDoor", t.ManagerDoor.coords, 0.2, 0.2, {name = "crpaleto_ManagerDoor", heading = t.ManagerDoor.heading, debugPoly = Config.DebugPoly, minZ = t.ManagerDoor.minZ, maxZ = t.ManagerDoor.maxZ}, {options = Options_ManagerDoor})
                --exports['qb-target']:AddBoxZone("crpaleto_OutsideKeypad", t.OutsideKeypad.coords, 0.2, 0.2, {name = "crpaleto_OutsideKeypad", heading = t.OutsideKeypad.heading, debugPoly = Config.DebugPoly, minZ = t.OutsideKeypad.minZ, maxZ = t.OutsideKeypad.maxZ}, {options = Options_OutsideKeypad})
                exports['qb-target']:AddBoxZone("crpaleto_OutsideDepo", t.OutDepo.coords, 0.2, 2.5, {name = "crpaleto_OutsideDepo", heading = t.OutDepo.heading, debugPoly = Config.DebugPoly, minZ = t.OutDepo.minZ, maxZ = t.OutDepo.maxZ}, {options = Options_OutsideDepo})
                exports['qb-target']:AddBoxZone("crpaleto_CorridorDoor", t.CorridorDoor.coords, 0.2, 0.2, {name = "crpaleto_CorridorDoor", heading = t.CorridorDoor.heading, debugPoly = Config.DebugPoly, minZ = t.CorridorDoor.minZ, maxZ = t.CorridorDoor.maxZ}, {options = Options_CorridorDoor})
                exports['qb-target']:AddBoxZone("crpaleto_InstallDrill", t.Drill.coords, t.Drill.w, t.Drill.l, {name = "crpaleto_InstallDrill", heading = t.Drill.heading, debugPoly = Config.DebugPoly, minZ = t.Drill.minZ, maxZ = t.Drill.maxZ}, {options = Options_InstallDrill, distance = 1})

                for k, v in pairs(t.OfficeDoor) do
                    local Options = {{name = "crpaleto_OfficeDoor_"..k, type = "client", event = "cr-paletobankrobbery:client:OfficeDoor", icon = "fas fa-key", label = Lcl('target_UnlockDoor'), door = k}}
                    exports['qb-target']:AddBoxZone("crpaleto_OfficeDoor_"..k, v.coords, 0.2, 0.2, {name = "crpaleto_OfficeDoor_"..k, heading = v.heading, debugPoly = Config.DebugPoly, minZ = v.minZ, maxZ = v.maxZ}, {options = Options, distance = 2})
                end
                for k, v in pairs(t.OfficeComputers) do
                    local Options = {{name = "crpaleto_OfficeComputer_"..k, type = "client", event = "cr-paletobankrobbery:client:OfficeComputer", icon = "fas fa-bug", label = Lcl('target_VaultComputer'), computer = k}}
                    exports['qb-target']:AddBoxZone("crpaleto_OfficeComputer_"..k, v.coords, 0.2, 0.5, {name = "crpaleto_OfficeComputer_"..k, heading = v.heading, debugPoly = Config.DebugPoly, minZ = v.minZ, maxZ = v.maxZ}, {options = Options, distance = 2})
                end

                if Config.Framework.MLO == "K4MB1" then
                    exports['qb-target']:AddBoxZone("crpaleto_InnerVaultKeypad", t.InnerVaultKeypad.coords, KPSize.l, KPSize.w, {name = "crpaleto_InnerVaultKeypad", heading = t.InnerVaultKeypad.heading, debugPoly = Config.DebugPoly, minZ = t.InnerVaultKeypad.minZ, maxZ = t.InnerVaultKeypad.maxZ}, {options = Options_InnerVaultKeypad})
                    --exports['qb-target']:AddBoxZone("crpaleto_BombGate", t.Gate.coords, 0.2, 0.2, {name = "crpaleto_BombGate", heading = t.Gate.heading, debugPoly = Config.DebugPoly, minZ = t.Gate.minZ, maxZ = t.Gate.maxZ}, {options = Options_BombGate})
                end

            elseif Config.Framework.Interaction.Target == "oxtarget" then
                local mlo = Config.Framework.MLO
                local oxPos, oxSize
                if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.3) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.3) end
                oxTargets.SecSeqDoor = exports['ox_target']:addBoxZone({coords = t.SecSeq.coords+oxPos, size = oxSize, rotation = t.SecSeq.heading, debug = Config.DebugPoly, options = Options_SecSeqDoor})
                if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.2, 0.2) end
                oxTargets.VaultComputer = exports['ox_target']:addBoxZone({coords = t.VaultComputer.coords+oxPos, size = oxSize, rotation = t.VaultComputer.heading, debug = Config.DebugPoly, options = Options_VaultComputer})
                if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.4) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.5, 0.2, 0.6) end
                oxTargets.VaultKeypad = exports['ox_target']:addBoxZone({coords = t.VaultKeypad.coords+oxPos, size = oxSize, rotation = t.VaultKeypad.heading, debug = Config.DebugPoly, options = Options_VaultKeypad})
                if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) end
                oxTargets.ManagerDoor = exports['ox_target']:addBoxZone({coords = t.ManagerDoor.coords+oxPos, size = oxSize, rotation = t.ManagerDoor.heading, debug = Config.DebugPoly, options = Options_ManagerDoor})
                if mlo == "K4MB1" then oxPos = vec3(0,0,0.1) oxSize = vec3(0.2, 0.2, 0.3) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) end
                oxTargets.OutsideKeypad = exports['ox_target']:addBoxZone({coords = t.OutsideKeypad.coords+oxPos, size = oxSize, rotation = t.OutsideKeypad.heading, debug = Config.DebugPoly, options = Options_OutsideKeypad})
                if mlo == "K4MB1" then oxPos = vec3(0,0,-0.2) oxSize = vec3(2.4, 0.2, 2.3) elseif mlo == "Gabz" then oxPos = vec3(0,0,0.3) oxSize = vec3(2.5, 0.2, 2.2) end
                oxTargets.OutDepo = exports['ox_target']:addBoxZone({coords = t.OutDepo.coords+oxPos, size = oxSize, rotation = t.OutDepo.heading, debug = Config.DebugPoly, options = Options_OutsideDepo})
                if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) end
                oxTargets.CorridorDoor = exports['ox_target']:addBoxZone({coords = t.CorridorDoor.coords+oxPos, size = oxSize, rotation = t.CorridorDoor.heading, debug = Config.DebugPoly, options = Options_CorridorDoor})
                if mlo == "K4MB1" then oxPos = vec3(0,-0.1,-0.3) oxSize = vec3(1.1, 1.0, 1.5) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.7, 0.7) end
                oxTargets.Drill = exports['ox_target']:addBoxZone({coords = t.Drill.coords+oxPos, size = oxSize, rotation = t.Drill.heading, debug = Config.DebugPoly, options = Options_InstallDrill})

                oxTargets.OfficeDoor = {}
                for k, v in pairs(t.OfficeDoor) do
                    local Options = {{name = "crpaleto_OfficeDoor_"..k, type = "client", event = "cr-paletobankrobbery:client:OfficeDoor", icon = "fas fa-key", label = Lcl('target_UnlockDoor'), door = k}}
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2) end
                    oxTargets.OfficeDoor[k] = exports['ox_target']:addBoxZone({coords = v.coords+oxPos, size = oxSize, rotation = v.heading, debug = Config.DebugPoly, options = Options})
                end
                oxTargets.OfficeComputer = {}
                for k, v in pairs(t.OfficeComputers) do
                    local Options = {{name = "crpaleto_OfficeComputer_"..k, type = "client", event = "cr-paletobankrobbery:client:OfficeComputer", icon = "fas fa-bug", label = Lcl('target_VaultComputer'), computer = k}}
                    if mlo == "K4MB1" then oxPos = vec3(0,0,0) oxSize = vec3(0.5, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.5, 0.2, 0.2) end
                    oxTargets.OfficeComputer[k] = exports['ox_target']:addBoxZone({coords = v.coords+oxPos, size = oxSize, rotation = v.heading, debug = Config.DebugPoly, options = Options})
                end

                if Config.Framework.MLO == "K4MB1" then
                    oxPos = vec3(0,0,0) oxSize = vec3(0.2, 0.2, 0.2)
                    oxTargets.InnerVaultKeypad = exports['ox_target']:addBoxZone({coords = t.InnerVaultKeypad.coords+oxPos, size = oxSize, rotation = t.InnerVaultKeypad.heading, debug = Config.DebugPoly, options = Options_InnerVaultKeypad})
                    --oxPos = vec3(0,0,0.45) oxSize = vec3(0.2, 0.2, 0.2)
                    --oxTargets.BombDoor = exports['ox_target']:addBoxZone({coords = t.Gate.coords+oxPos, size = oxSize, rotation = t.Gate.heading, debug = Config.DebugPoly, options = Options_BombGate})
                end
            end
        else
            local SecSeqDoor = lib.points.new(t.SecSeq.coords, 1)
            function SecSeqDoor:onEnter() if not t.SecSeq.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_TellerDoor')) end end
            function SecSeqDoor:onExit() PBCUtils.DrawText(false) end
            function SecSeqDoor:nearby() if not t.SecSeq.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:TellerDoor') end end
            end oxPoints.SecSeqDoor = SecSeqDoor

            local VaultComputer = lib.points.new(t.VaultComputer.coords, 1)
            function VaultComputer:onEnter() if not t.VaultComputer.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultComputer')) end end
            function VaultComputer:onExit() PBCUtils.DrawText(false) end
            function VaultComputer:nearby() if not t.VaultComputer.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:VaultComputer') end end
            end oxPoints.VaultComputer = VaultComputer

            local VaultKeypad = lib.points.new(t.VaultKeypad.coords, 1)
            function VaultKeypad:onEnter() if not t.VaultKeypad.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultKeypad')) end end
            function VaultKeypad:onExit() PBCUtils.DrawText(false) end
            function VaultKeypad:nearby() if not t.VaultKeypad.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:VaultKeypad', {}) end end
            end oxPoints.VaultKeypad = VaultKeypad

            local ManagerDoor = lib.points.new(t.ManagerDoor.coords, 1)
            function ManagerDoor:onEnter() if not t.ManagerDoor.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_UnlockDoor')) end end
            function ManagerDoor:onExit() PBCUtils.DrawText(false) end
            function ManagerDoor:nearby() if not t.ManagerDoor.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:ManagerDoor') end end
            end oxPoints.ManagerDoor = ManagerDoor

            local OutsideKeypad = lib.points.new(t.OutsideKeypad.coords, 1)
            function OutsideKeypad:onEnter() if not t.OutsideKeypad.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultCards')) end end
            function OutsideKeypad:onExit() PBCUtils.DrawText(false) end
            function OutsideKeypad:nearby() if not t.OutsideKeypad.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:OutsideKeypad') end end
            end oxPoints.OutsideKeypad = OutsideKeypad

            local OutsideDepo = lib.points.new(t.OutDepo.coords, 1)
            function OutsideDepo:onEnter() if not t.OutDepo.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_BreakBoxes')) end end
            function OutsideDepo:onExit() PBCUtils.DrawText(false) end
            function OutsideDepo:nearby() if not t.OutDepo.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:UseSaw', {coords = t.OutDepo.coords}) end end
            end oxPoints.OutsideDepo = OutsideDepo

            local CorridorDoor = lib.points.new(t.CorridorDoor.coords, 1)
            function CorridorDoor:onEnter() if not t.CorridorDoor.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_UnlockDoor')) end end
            function CorridorDoor:onExit() PBCUtils.DrawText(false) end
            function CorridorDoor:nearby() if not t.CorridorDoor.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:UnlockCorridor') end end
            end oxPoints.CorridorDoor = CorridorDoor

            oxPoints.OfficeDoor = {}
            for k, v in pairs(t.OfficeDoor) do
                local data = {door = k}
                local Point = lib.points.new(v.coords, 1)
                function Point:onEnter() if not v.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_UnlockDoor')) end end
                function Point:onExit() PBCUtils.DrawText(false) end
                function Point:nearby() if not v.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:OfficeDoor', data) end end
                end oxPoints.OfficeDoor[k] = Point
            end

            oxPoints.OfficeComputers = {}
            for k, v in pairs(t.OfficeComputers) do
                local data = {computer = k}
                local Point = lib.points.new(v.coords, 1)
                function Point:onEnter() if not v.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultComputer')) end end
                function Point:onExit() PBCUtils.DrawText(false) end
                function Point:nearby() if not v.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:OfficeComputer', data) end end
                end oxPoints.OfficeComputers[k] = Point
            end

            local OfficeSafe = lib.points.new(t.Drill.coords, 1)
            function OfficeSafe:onEnter()
                if not t.Drill.Busy or not t.Drill.isOpenned then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_InstallDrill')) end
                if t.Drill.isOpenned and not t.Drill.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_LootSafe')) end
            end
            function OfficeSafe:onExit() PBCUtils.DrawText(false) end
            function OfficeSafe:nearby()
                if not t.Drill.Busy or not t.Drill.isOpenned then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:InstallDrill') end end
                if t.Drill.isOpenned and not t.Drill.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:collectSafe') end end
            end oxPoints.OfficeSafe = OfficeSafe

            if Config.Framework.MLO == "K4MB1" then
                local InnerKeypad = lib.points.new(t.InnerVaultKeypad.coords, 1)
                function InnerKeypad:onEnter() if not t.InnerVaultKeypad.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_VaultKeypad')) end end
                function InnerKeypad:onExit() PBCUtils.DrawText(false) end
                function InnerKeypad:nearby() if not t.InnerVaultKeypad.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:VaultKeypad', {inner = true}) end end
                end oxPoints.InnerVaultKeypad = InnerKeypad

                local BombGate = lib.points.new(t.Gate.coords, 1)
                function BombGate:onEnter() if not t.Gate.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_BombDoor')) end end
                function BombGate:onExit() PBCUtils.DrawText(false) end
                function BombGate:nearby() if not t.Gate.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:BombDoor') end end
                end oxPoints.BombGate = BombGate
            end
        end
        if Config.Framework.MLO == "K4MB1" then
            local MetalGate = lib.points.new(t.Gate.coords, 1)
            function MetalGate:onEnter() if not t.GateecSeq.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_BombDoor')) end end
            function MetalGate:onExit() PBCUtils.DrawText(false) end
            function MetalGate:nearby() if not t.Gate.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:BombMetalGate') end end
            end oxPoints.MetalGate = MetalGate
        end
    end)
end

--ox done
function SetupBinders()
    if Config.Framework.Interaction.UseTarget then
        oxTargets.Binders = {}
        for k, v in pairs(Config.Targets.Binders) do
            local options = {{event = "cr-paletobankrobbery:client:Binders", icon = "fas fa-user-secret", label = Lcl('target_Search'), binder = k, coords = v.coords, hash = v.hash, canInteract = function() if v.Busy then return false else return true end end}}
            local e = GetClosestObjectOfType(v.coords, 0.5, v.hash, 0, 0, 0)
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddTargetEntity(e, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                exports['ox_target']:addLocalEntity(e, options)
            end
        end
    else
        oxPoints.Binders = {}
        for k, v in pairs(Config.Targets.Binders) do
            local e = GetClosestObjectOfType(v.coords, 0.2, v.hash, 0, 0, 0)
            if not e or e == 0 or drawing then return end
            local data = {binder = k, coords = v.coords, hash = v.hash}
            local Point = lib.points.new(v.coords, 2.0)
            function Point:nearby()
                if self.currentDistance < 1.3 then
                    if not drawing then SetEntityDrawOutline(e, true) SetEntityDrawOutlineColor(227, 175, 49, 200) drawing = k PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_Search'))  end
                    if not v.Busy and drawing == k and IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        SetEntityDrawOutline(e, false) drawing = true PBCUtils.DrawText(false)
                        TriggerEvent('cr-paletobankrobbery:client:Binders', data)
                    end
                else
                    if drawing == k then SetEntityDrawOutline(e, false) drawing = nil PBCUtils.DrawText(false) end
                end
            end oxPoints.Binders[k] = Point
        end
    end
end

--ox done
function SetupKeyTarget(key)
    if Config.Framework.Interaction.UseTarget then
        local options = {{ event = "cr-paletobankrobbery:client:TakeKeys", icon = "fas fa-hand", label = Lcl('target_GrabKeys')}}
        Citizen.CreateThread(function()
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddTargetEntity(key, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets.ManagerKey = exports['ox_target']:addLocalEntity(key, options)
            end
        end)
    else
        local coords = GetEntityCoords(key)
        local Key = lib.points.new(coords, 1)
        function Key:onEnter() PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabKeys')) end
        function Key:onExit() PBCUtils.DrawText(false) end
        function Key:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
            PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:TakeKeys') end
        end oxPoints.ManagerKey = Key
    end
end

--ox done
function SetupPhoneTarget(phone, e)
    local Phone = Config.Targets.Phones[phone]
    if Config.Framework.Interaction.UseTarget then
        local options = {{ name = "crpaleto_Phone", type = "client", event = "cr-paletobankrobbery:client:AnswerPhone", icon = "fas fa-phone", label = Lcl('target_AnswerPhone'), phone = phone }}
        if Config.Framework.Interaction.Target == "qb-target" then
            --exports['qb-target']:AddTargetEntity(e, { options = options, distance = 2 })
            exports['qb-target']:AddEntityZone("crpaleto_Phone", e, { name="crpaleto_Phone", heading = GetEntityHeading(e), debugPoly = Config.DebugPoly }, { options = options, distance = 2 })
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            exports['ox_target']:addLocalEntity(e, options)
        end
    else
        local Point = lib.points.new(Phone.coords, 1.5)
        function Point:onEnter() PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_AnswerPhone')) end --47
        function Point:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:AnswerPhone', {phone = phone}) end end
        function Point:onExit() PBCUtils.DrawText(false) end
        oxPoints.Phone = Point
    end
end

-- ox done
function DismantleDrillTarget(drill)
    if Config.Framework.Interaction.UseTarget then
        local options = {{ event = "cr-paletobankrobbery:client:DismantleDrill", icon = "fas fa-hand", label = Lcl('target_DismountDrill'), drill = drill }}
        Citizen.CreateThread(function()
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddTargetEntity(drill, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets.DrillObj = exports['ox_target']:addLocalEntity(drill, options)
            end
        end)
    else
        local coords = GetEntityCoords(drill)
        local Point = lib.points.new(coords, 1)
        function Point:onEnter() PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_DismountDrill')) end --47
        function Point:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:DismantleDrill', {drill = drill}) end end
        function Point:onExit() PBCUtils.DrawText(false) end
        oxPoints.DismantleDrill = Point
    end
end

--ox done
function ActivatePrinter()
    if Config.Framework.Interaction.UseTarget then
        local t = Config.Targets.Printer
        local options = {{name = "crpaleto_OfficePrinter", type = "client", event = "cr-paletobankrobbery:client:PrintVaultCodes", icon = "fas fa-printer", label = Lcl('target_GrabCodes') }}
        Citizen.CreateThread(function()
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddBoxZone("crpaleto_OfficePrinter", t.coords, 0.6, 0.6, {name = "crpaleto_OfficePrinter", heading = t.heading, debugPoly = Config.DebugPoly, minZ = t.minZ, maxZ = t.maxZ}, {options = options})
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                local mlo, oxPos, oxSize = Config.Framework.MLO, nil, nil
                if mlo == "K4MB1" then oxPos = vec3(0,0,0.45) oxSize = vec3(0.2, 0.2, 0.2) elseif mlo == "Gabz" then oxPos = vec3(0,0,0) oxSize = vec3(0.6, 0.7, 0.7) end
                oxTargets.OfficePrinter = exports['ox_target']:addBoxZone({coords = t.coords+oxPos, size = oxSize, rotation = t.heading, debug = Config.DebugPoly, options = options})
            end
        end)
    else
        local t = Config.Targets.Printer
        local Printer = lib.points.new(t.coords, 1)
        function Printer:onEnter() PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabCodes')) end
        function Printer:onExit() PBCUtils.DrawText(false) end
        function Printer:nearby() if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
            PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:PrintVaultCodes') end
        end oxPoints.Printer = Printer
    end
end

--ox done
function ActivateBoxesTargets()
    Citizen.CreateThread(function()
        oxTargets.DepositBoxes = {}
        oxPoints.DepositBoxes = {}
        for wall, va in pairs(Config.Targets.DepositBoxes) do
            if Config.Framework.Interaction.UseTarget then
                local l, w = 0.2, 2.0
                --if Config.Framework.MLO == "Gabz" then w = 0.6 end
                local options = {{name = "crPaletoDepoBox_"..wall, type = "client", event = "cr-paletobankrobbery:client:DrillBoxes", icon = "fas fa-unlock-alt", label = Lcl('target_DepositBoxes'), box = wall, inner = false}}
                if Config.Framework.Interaction.Target == "qb-target" then
                    exports['qb-target']:AddBoxZone("crPaletoDepoBox_"..wall, va.coords, l, w, { name="crPaletoDepoBox_"..wall, heading = va.heading, debugPoly = Config.DebugPoly, minZ = va.minZ, maxZ = va.maxZ, }, { options = options, distance = 1.0 })
                elseif Config.Framework.Interaction.Target == "oxtarget" then
                    oxTargets.DepositBoxes[wall] = exports['ox_target']:addBoxZone({coords = va.coords, size = vector3(2.0, 0.2, 2.0), rotation = va.heading, debug = Config.DebugPoly, options = options})
                end
            else
                local Point = lib.points.new(va.coords, 1.0)
                function Point:onEnter() if not va.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_DepositBoxes')) end end
                function Point:onExit() PBCUtils.DrawText(false) end
                function Point:nearby() if not va.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:DrillBoxes', {box = wall}) end end
                end
                oxPoints.DepositBoxes[wall] = Point
            end
        end
    end)
end

function SetupInnerTargets()
    Citizen.CreateThread(function()
        oxPoints.InnerDepositBox = {}
        oxTargets.InnerDepositBox = {}
        for wall, va in pairs(Config.Targets.InnerVaultBoxes) do
            if Config.Framework.Interaction.UseTarget then
                local l, w = 0.2, 2.0
                local options = {{name = "crPaletoInnerDepoBox_"..wall, type = "client", event = "cr-paletobankrobbery:client:DrillBoxes", icon = "fas fa-unlock-alt", label = Lcl('target_DepositBoxes'), box = wall, inner = true}}
                if Config.Framework.Interaction.Target == "qb-target" then
                    exports['qb-target']:AddBoxZone("crPaletoInnerDepoBox_"..wall, va.coords, l, w, { name="crPaletoInnerDepoBox_"..wall, heading = va.heading, debugPoly = Config.DebugPoly, minZ = va.minZ, maxZ = va.maxZ, }, { options = options, distance = 1.0 })
                elseif Config.Framework.Interaction.Target == "oxtarget" then
                    oxTargets.InnerDepositBox[wall] = exports['ox_target']:addBoxZone({coords = va.coords, size = vector3(2.0, 0.2, 2.0), rotation = va.heading, debug = Config.DebugPoly, options = options})
                end
            else
                local Point = lib.points.new(va.coords, 1.0)
                function Point:onEnter() if not va.Busy then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_DepositBoxes')) end end
                function Point:onExit() PBCUtils.DrawText(false) end
                function Point:nearby() if not va.Busy then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                    PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:InnerDrillBoxes', {box = wall, inner = true}) end end
                end
                oxPoints.InnerDepositBox[wall] = Point
            end
        end
    end)
end

--ox done
function ActivateTrayTargets(tray, loc)
    PBCUtils.Debug(Lcl('debug_createtraytarget', tray, loc))
    if not DoesEntityExist(tray) then PBCUtils.Debug(Lcl('debug_trayspawnerror', tray)) return end
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crPaletoTray_"..loc, type = "client", event = "cr-paletobankrobbery:client:GrabTrayLoot", icon = "fas fa-hand", label = Lcl('target_GrabLoot'), tray = tray, loc = loc }}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("crPaletoTray_"..loc, tray, { name="crPaletoTray_"..loc, heading = GetEntityHeading(tray), debugPoly = Config.DebugPoly}, { options = options, distance = 1.5 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                if not oxTargets.Trays then oxTargets.Trays = {} end
                exports['ox_target']:addLocalEntity(tray, options)
            end
        else
            oxPoints.Trays = {}
            local v = Config.Targets.Trays[loc]
                if not tray or tray == 0 or drawing then return end
                local data = {tray = tray, loc = loc}
                local Point = lib.points.new(v.coords, 1.5)
                function Point:nearby()
                    if self.currentDistance < 1.2 then
                        if not drawing then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabLoot')) SetEntityDrawOutline(tray, true) SetEntityDrawOutlineColor(227, 175, 49, 200) drawing = loc end
                        if not v.Busy and drawing == loc and IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                            SetEntityDrawOutline(tray, false) drawing = true PBCUtils.DrawText(false)
                            TriggerEvent('cr-paletobankrobbery:client:GrabTrayLoot', data)
                        end
                    else
                        if drawing == loc then SetEntityDrawOutline(tray, false) drawing = nil PBCUtils.DrawText(false) end
                    end
                end oxPoints.Trays[loc] = Point
            --end
        end
    end)
end

--ox done
function ActivateGabzTray(tray, hash)
    --if Config.Debug then print(Lcl('debug_createtraytarget', tray, loc)) end
    if not DoesEntityExist(tray) then PBCUtils.Debug(Lcl('debug_trayspawnerror', tray)) return end
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crPaletoGabzTray", type = "client", event = "cr-paletobankrobbery:client:GrabGabzTray", icon = "fas fa-hand", label = Lcl('target_GrabLoot'), tray = tray, model = hash}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("crPaletoGabzTray", tray, { name="crPaletoGabzTray", heading = GetEntityHeading(tray), debugPoly = Config.DebugPoly}, { options = options, distance = 1.5 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets.MiddleTray = exports['ox_target']:addLocalEntity(tray, options)
            end
        else
            -- Trays[bank..loc] = {loc = loc, entity = tray}
            if not tray or tray == 0 then return end
            local data = {tray = tray, model = hash}
            local coords = GetEntityCoords(tray)
            local Point = lib.points.new(coords, 1.5)
            function Point:nearby()
                if self.currentDistance < 1.1 then
                    if not Config.Targets.MiddleTray.Busy or not drawn then drawn = true SetEntityDrawOutline(tray, true) SetEntityDrawOutlineColor(227, 175, 49, 200) PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabLoot'))  end
                    if not Config.Targets.MiddleTray.Busy and IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                        SetEntityDrawOutline(tray, false) PBCUtils.DrawText(false)
                        TriggerEvent('cr-paletobankrobbery:client:GrabGabzTray', data)
                    end
                else
                    if drawn then drawn = false SetEntityDrawOutline(tray, false) PBCUtils.DrawText(false) end
                end
            end oxPoints.MiddleTray = Point
        end
    end)
end

function ActivateTableTarget(loot)
    if not DoesEntityExist(loot) then return end
    Citizen.CreateThread(function()
        if Config.Framework.Interaction.UseTarget then
            local options = {{name = "crpaleto_tableloot", type = "client", event = "cr-paletobankrobbery:client:GrabTableLoot", icon = "fas fa-user-hand", label = Lcl('target_GrabLoot'), loot = loot}}
            if Config.Framework.Interaction.Target == "qb-target" then
                exports['qb-target']:AddEntityZone("crpaleto_tableloot", loot, { name="crpaleto_tableloot", heading = GetEntityHeading(loot), debugPoly = Config.DebugPoly }, { options = options, distance = 2 })
            elseif Config.Framework.Interaction.Target == "oxtarget" then
                oxTargets.Table = exports['ox_target']:addBoxZone({coords = GetEntityCoords(loot), size = vector3(0.8, 0.8, 0.5), rotation = GetEntityHeading(loot), debug = Config.DebugPoly, options = options})
            end
        else
            local TablePoint = lib.points.new(Config.Targets.Table.coords, 1)
            function TablePoint:onEnter() if not Config.Targets.Table.grabbed then PBCUtils.DrawText(true, "["..Config.InteractKey.."] "..Lcl('target_GrabLoot')) end end
            function TablePoint:onExit() PBCUtils.DrawText(false) end
            function TablePoint:nearby() if not Config.Targets.Table.grabbed then if IsControlJustPressed(0, Config.KeyList[Config.InteractKey]) then
                PBCUtils.DrawText(false) TriggerEvent('cr-paletobankrobbery:client:GrabTableLoot', {loot = loot}) end end
            end
            oxPoints.Table = TablePoint
        end
    end)
end

RegisterNetEvent("cr-paletobankrobbery:client:DeleteZones", function(zone, pos, id)
    PBCUtils.Debug("Deleted Zone "..zone.." | Pos : "..(pos or "nil"))
    if Config.Framework.Interaction.UseTarget then
        if Config.Framework.Interaction.Target == "qb-target" then
            if zone == "SecSeq" then exports['qb-target']:RemoveZone("crpaleto_SecSeqDoor")
            elseif zone == "VaultComputer" then exports['qb-target']:RemoveZone("crpaleto_VaultComputer")
            elseif zone == "VaultKeypad" then exports['qb-target']:RemoveZone("crpaleto_VaultKeypad")
            elseif zone == "ManagerDoor" then exports['qb-target']:RemoveZone("crpaleto_ManagerDoor")
            elseif zone == "OutsideKeypad" then exports['qb-target']:RemoveZone("crpaleto_OutsideKeypad")
            elseif zone == "OutsideDepo" then exports['qb-target']:RemoveZone("crpaleto_OutsideDepo")
            elseif zone == "CorridorDoor" then exports['qb-target']:RemoveZone("crpaleto_CorridorDoor")
            elseif zone == "InnerVaultKeypad" then exports['qb-target']:RemoveZone("crpaleto_InnerVaultKeypad")
            elseif zone == "InstallDrill" then exports['qb-target']:RemoveZone("crpaleto_InstallDrill")
            elseif zone == "Printer" then exports['qb-target']:RemoveZone("crpaleto_OfficePrinter")
            elseif zone == "GabzTray" then exports['qb-target']:RemoveZone("crPaletoGabzTray")
            elseif zone == "Table" then exports['qb-target']:RemoveZone("crpaleto_tableloot")
            elseif zone == "BombGate" and oxPoints.MetalGate then oxPoints.MetalGate:remove()
            elseif zone == "Phone" then exports['qb-target']:RemoveZone("crpaleto_Phone") PBCUtils.PhoneSound(true)
            elseif zone == "OfficeComputer" then exports['qb-target']:RemoveZone("crpaleto_OfficeComputer_"..pos)
            elseif zone == "OfficeDoor" then exports['qb-target']:RemoveZone("crpaleto_OfficeDoor_"..pos)
            elseif zone == "Tray" and pos then exports['qb-target']:RemoveZone("crPaletoTray_"..pos)
            elseif zone == "Wall" then exports['qb-target']:RemoveZone("crPaletoDepoBox_"..pos)
            elseif zone == "InnerBox" then exports['qb-target']:RemoveZone("crPaletoInnerDepoBox_"..pos)
            end
        elseif Config.Framework.Interaction.Target == "oxtarget" then
            if zone     == "SecSeq" and oxTargets.SecSeqDoor then exports['ox_target']:removeZone(oxTargets.SecSeqDoor)
            elseif zone == "VaultComputer" and oxTargets.VaultComputer then exports['ox_target']:removeZone(oxTargets.VaultComputer)
            elseif zone == "VaultKeypad" and oxTargets.VaultKeypad then exports['ox_target']:removeZone(oxTargets.VaultKeypad)
            elseif zone == "ManagerDoor" and oxTargets.ManagerDoor then exports['ox_target']:removeZone(oxTargets.ManagerDoor)
            elseif zone == "OutsideKeypad" and oxTargets.OutsideKeypad then exports['ox_target']:removeZone(oxTargets.OutsideKeypad)
            elseif zone == "OutsideDepo" and oxTargets.OutDepo then exports['ox_target']:removeZone(oxTargets.OutDepo)
            elseif zone == "CorridorDoor" and oxTargets.CorridorDoor then exports['ox_target']:removeZone(oxTargets.CorridorDoor)
            elseif zone == "OfficeDoor" and oxTargets.OfficeDoor[pos] then exports['ox_target']:removeZone(oxTargets.OfficeDoor[pos])
            elseif zone == "OfficeComputer" and oxTargets.OfficeComputer[pos] then exports['ox_target']:removeZone(oxTargets.OfficeComputer[pos])
            elseif zone == "InnerVaultKeypad" and oxTargets.InnerVaultKeypad then exports['ox_target']:removeZone(oxTargets.InnerVaultKeypad)
            elseif zone == "InstallDrill" and oxTargets.Drill then exports['ox_target']:removeZone(oxTargets.Drill)
            elseif zone == "Printer" and oxTargets.OfficePrinter then exports['ox_target']:removeZone(oxTargets.OfficePrinter)
            elseif zone == "GabzTray" then local obj = GetClosestObjectOfType(pos, 1.0, id, 0, 0, 0) if not obj or obj == 0 then return end
                exports['ox_target']:removeZone(obj)
            elseif zone == "Tray" then local t = Config.Targets.Trays[pos]
                local tray = GetClosestObjectOfType(t.coords, 1.0, t.model, 0, 0, 0)
                if not tray or tray == 0 then return end exports['ox_target']:removeLocalEntity(tray)
            elseif zone == "Table" and oxTargets.Table then exports['ox_target']:removeZone(oxTargets.Table)
            elseif zone == "Wall" and oxTargets.DepositBoxes and oxTargets.DepositBoxes[pos] then exports['ox_target']:removeZone(oxTargets.DepositBoxes[pos])
            elseif zone == "InnerBox" and oxTargets.InnerDepositBox and oxTargets.InnerDepositBox[pos] then exports['ox_target']:removeZone(oxTargets.InnerDepositBox[pos])
            elseif zone == "BombGate" then oxPoints.MetalGate:remove()
            elseif zone == "Phone" then local phone = GetClosestObjectOfType(pos, 1.0, 1146022803, 0, 0, 0) if not phone or phone == 0 then return end
                exports['ox_target']:removeLocalEntity(phone) PBCUtils.PhoneSound(true)
            end
        end
    else
        PBCUtils.DrawText(false)
        if zone == "SecSeq" and oxPoints.SecSeqDoor then oxPoints.SecSeqDoor:remove()
        elseif zone == "VaultComputer" then oxPoints.VaultComputer:remove()
        elseif zone == "VaultKeypad" then oxPoints.VaultKeypad:remove()
        elseif zone == "ManagerDoor" then oxPoints.ManagerDoor:remove()
        elseif zone == "OutsideKeypad" then oxPoints.OutsideKeypad:remove()
        elseif zone == "OutsideDepo" then oxPoints.OutsideDepo:remove()
        elseif zone == "CorridorDoor" then oxPoints.CorridorDoor:remove()
        elseif zone == "OfficeDoor" then oxPoints.OfficeDoor[pos]:remove()
        elseif zone == "OfficeComputer" then oxPoints.OfficeComputer[pos]:remove()
        elseif zone == "InstallDrill" and oxPoints.Drill then oxPoints.Drill:remove()
        elseif zone == "Printer" then oxPoints.Printer:remove()
        elseif zone == "GabzTray" then oxPoints.MiddleTray:remove()
        elseif zone == "Tray" then oxPoints.Tray[pos]:remove()
        elseif zone == "Table" then oxPoints.Table:remove()
        elseif zone == "Wall" then oxPoints.DepositBoxes[pos]:remove()
        elseif zone == "InnerBox" then oxPoints.InnerDepositBox[pos]:remove()
        elseif zone == "BombGate" then oxPoints.MetalGate:remove()
        elseif zone == "Phone" then oxPoints.Phone:remove() PBCUtils.PhoneSound(true)
            -- Points Exlusive? --
        elseif zone == "Binders" then oxPoints.Binders[pos]:remove() Wait(500) drawing = nil -- Added
        elseif zone == "Key" then oxPoints.ManagerKey:remove() -- Added
        elseif zone == "Phone" then oxPoints.Phone:remove() -- Added
        elseif zone == "RemoveDrill" and oxPoints.DismantleDrill then oxPoints.DismantleDrill:remove() -- Added
        end
    end
end)

function ResetAllTargets()
    PBCUtils.Debug("Resetting Targets")
    if not Config.Framework.Interaction.UseTarget then
        for k, v in pairs(oxPoints) do
            PBCUtils.Debug(k)
            for i, o in pairs(v) do if i == "remove" then v:remove() PBCUtils.Debug("Removed "..tostring(v)) elseif type(i) == "number" then o:remove() PBCUtils.Debug("Removed "..tostring(o)) end end
            PBCUtils.Debug("-----------")
        end
    elseif Config.Framework.Interaction.Target == "oxtarget" then
        local RemZones = {'SecSeq', 'VaultComputer', 'VaultKeypad', 'ManagerDoor', 'OutsideKeypad', 'OutsideDepo', 'CorridorDoor', 'OfficeDoor',
        'OfficeComputer', 'InnerVaultKeypad', 'InstallDrill', 'Printer', 'Table', 'Wall', 'InnerBox', 'BombGate'}

        local Rem2 = {'OfficeDoor', 'OfficeComputer', 'Tray', 'Wall', 'InnerBox'}
        for k, v  in pairs(RemZones) do TriggerEvent('cr-paletobankrobbery:client:DeleteZones', v) end
        for k, v in pairs(Rem2) do for i = 1, 6 do TriggerEvent('cr-paletobankrobbery:client:DeleteZones', v, i) end end
        -- for k, v in pairs(oxTargets) do
        --     PBCUtils.Debug(k)
        --     if type(v) ~= "table" then if v then exports['ox_target']:removeZone(v) PBCUtils.Debug("Removed "..tostring(k)) end else
        --     for i, o in pairs(v) do if o then exports['ox_target']:removeZone(o) PBCUtils.Debug("Removed "..tostring(i)) end end end
        --     PBCUtils.Debug("-----------")
        -- end
    elseif Config.Framework.Interaction.Target == "qb-target" then
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "SecSeq")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultComputer")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultKeypad")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "ManagerDoor")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OutsideKeypad")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OutsideDepo")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "CorridorDoor")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InnerVaultKeypad")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InstallDrill")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Printer")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "GabzTray")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Table")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "BombGate")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Phone")
        for i = 1, 6 do
            TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OfficeComputer", i)
            TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "OfficeDoor", i)
            TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Tray", t)
            TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "Wall", i)
            TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "InnerBox", i)
        end
    end
    PBCUtils.Debug('All Targets Removed')
    Wait(1000)
    SetupPaletoBank()
end

RegisterCommand("ResetAllT", function()
    ResetAllTargets()
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName() then
        if Config.Framework.Interaction.OxLibDistanceCheck then return end
        if Config.Framework.Interaction.Target == "oxtarget" then return end
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "SecSeq")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultComputer")
        TriggerEvent("cr-paletobankrobbery:client:DeleteZones", "VaultKeypad")
    end
end)