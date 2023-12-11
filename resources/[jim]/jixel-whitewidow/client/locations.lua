local QBCore = exports[Config.Core]:GetCoreObject()
local Targets = {}
local onDuty = false
local Props = {}

CreateThread(function()
    for _, v in pairs(Config.Locations) do
        if v.zoneEnable then
            if v.zones then
                JobLocation = PolyZone:Create(v.zones, { name = v.label, debugPoly = Config.Debug })
                JobLocation:onPlayerInOut(function(isPointInside)
                    if PlayerJob.name == v.job then
                        if v.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
                        if v.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
                    end
                end)
            end
            if v.blip then makeBlip({coords = v.blip, sprite = 140, col = v.blipcolor, name = v.label }) end
            local bossroles = {}
            for l, b in pairs(QBCore.Shared.Jobs[v.job].grades) do
                if QBCore.Shared.Jobs[v.job].grades[l].isboss == true then
                if bossroles[v.job] ~= nil then
                    if bossroles[v.job] > tonumber(l) then bossroles[v.job] = tonumber(l) end
                else bossroles[v.job] = tonumber(l)	end
                end
            end
            if v.MLO == "mosbaek" then
                Props[#Props+1] = makeProp({prop = `prop_cooker_03`, coords = v.Targets.EdibleLoc}, true, false)
                Props[#Props+1] = makeProp({prop = `prop_atm_01`, coords = vec4(188.11, -245.42, 54.07, 67.01) }, true, false)
                Targets["WWBoss"] =
                exports['qb-target']:AddBoxZone("WWBoss", vec3(184.25, -244.34, 53.07), 0.9, 0.9, { name="WWBoss", heading = 160.0, debugPoly=Config.Debug, minZ = 53.20, maxZ = 55, },
                    { options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(184.25, -244.34, 54.07), }, }, distance = 2.0 })
                Targets["StrainOne"] =
                    exports['qb-target']:AddBoxZone("StrainOne", vec3(v.Strain.StrainOne.x, v.Strain.StrainOne.y, v.Strain.StrainOne.z-1), 5.0, 0.6,
                    { name="StrainOne", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainOne.z-1.03, maxZ = v.Strain.StrainOne.z+0.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainOne, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainOne.xyz, }, }, distance = 1.0 })
                Targets["StrainTwo"] =
                    exports['qb-target']:AddBoxZone("StrainTwo", vec3(v.Strain.StrainTwo.x, v.Strain.StrainTwo.y, v.Strain.StrainTwo.z-1), 5.0, 0.6,
                    { name="StrainTwo", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainTwo.z-1.03, maxZ = v.Strain.StrainTwo.z+0.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainTwo, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainTwo.xyz, }, }, distance = 1.0 })
                Targets["StrainThree"] =
                    exports['qb-target']:AddBoxZone("StrainThree", vec3(v.Strain.StrainThree.x, v.Strain.StrainThree.y, v.Strain.StrainThree.z-1), 5.0, 0.6,
                    { name="StrainThree", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainThree.z-1.03, maxZ = v.Strain.StrainThree.z+0.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainThree, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainThree.xyz, }, }, distance = 1.0 })
                Targets["StrainFour"] =
                    exports['qb-target']:AddBoxZone("StrainFour", vec3(v.Strain.StrainFour.x, v.Strain.StrainFour.y, v.Strain.StrainFour.z-1), 5.0, 0.6,
                    { name="StrainFour", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainFour.z-1.03, maxZ = v.Strain.StrainFour.z+0.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFour, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFour.xyz, }, }, distance = 1.0 })
                Targets["StrainFive"] =
                    exports['qb-target']:AddBoxZone("StrainFive", vec3(v.Strain.StrainFive.x, v.Strain.StrainFive.y, v.Strain.StrainFive.z-1), 6.0, 0.6,
                    { name="StrainFive", heading = 340, debugPoly = Config.Debug, minZ = v.Strain.StrainFive.z-1.03, maxZ = v.Strain.StrainFive.z+1.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFive, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFive.xyz, }, }, distance = 1.0 })
                Targets["StrainSix"] =
                    exports['qb-target']:AddBoxZone("StrainSix", vec3(v.Strain.StrainSix.x, v.Strain.StrainSix.y, v.Strain.StrainSix.z-1), 6.0, 0.6,
                    { name="StrainSix", heading = 340, debugPoly = Config.Debug, minZ = v.Strain.StrainSix.z-1.03, maxZ = v.Strain.StrainSix.z+1.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSix, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSix.xyz, }, }, distance = 1.0 })
                Targets["StrainSeven"] =
                    exports['qb-target']:AddBoxZone("StrainSeven", vec3(v.Strain.StrainSeven.x, v.Strain.StrainSeven.y, v.Strain.StrainSeven.z-1), 6.0, 0.6,
                    { name="StrainSeven", heading = 340, debugPoly = Config.Debug, minZ = v.Strain.StrainSeven.z-1.03, maxZ = v.Strain.StrainSeven.z+1.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSeven, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSeven.xyz, }, }, distance = 1.0 })
                Targets["StrainEight"] =
                    exports['qb-target']:AddBoxZone("StrainEight", vec3(v.Strain.StrainEight.x, v.Strain.StrainEight.y, v.Strain.StrainEight.z-1), 6.0, 0.6,
                    { name="StrainEight", heading = 340, debugPoly = Config.Debug, minZ = v.Strain.StrainEight.z-1.03, maxZ = v.Strain.StrainEight.z+1.5, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainEight, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainEight.xyz, }, }, distance = 1.0 })

                --JOINTS
                Targets["WWJoints"] =
                    exports['qb-target']:AddBoxZone("WWJoints", vec3(v.Targets.JointsLoc.x, v.Targets.JointsLoc.y, v.Targets.JointsLoc.z-1), 0.6, 2.0,
                    { name="WWJoints", heading = 339.79, debugPoly = Config.Debug, minZ = v.Targets.JointsLoc.z-1.03, maxZ = v.Targets.JointsLoc.z, },
                    { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["joints"], craftable = Crafting.Joints, header = Loc[Config.Lan].menu["header_joints"], coords = v.Targets.JointsLoc.xyz, }, }, distance = 2.0 })

                -- TRIMMING
                Targets["WWTrimming"] =
                    exports['qb-target']:AddBoxZone("WWTrimming", vec3(v.Targets.TrimmingLoc.x, v.Targets.TrimmingLoc.y, v.Targets.TrimmingLoc.z-1), 0.6, 2.0,
                    { name="WWTrimming", heading = 248.5, debugPoly = Config.Debug, minZ = v.Targets.TrimmingLoc.z-1.03, maxZ = v.Targets.TrimmingLoc.z, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["trimming"], craftable = Crafting.Trimming, header = Loc[Config.Lan].menu["header_trimming"], coords = v.Targets.TrimmingLoc.xyz, }, }, distance = 2.0 })

                --COOKING--
                Targets["WWEdibleOven"] =
                    exports['qb-target']:AddBoxZone("WWEdibleOven", vec3(v.Targets.EdibleLoc.x, v.Targets.EdibleLoc.y, v.Targets.EdibleLoc.z-1), 0.9, 1.7,
                    { name="WWEdibleOven", heading = v.Targets.EdibleLoc.w, debugPoly = Config.Debug, minZ = v.Targets.EdibleLoc.z-1.03, maxZ = v.Targets.EdibleLoc.z, },
                    { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-utensil-spoon", job = v.job, label =Loc[Config.Lan].target["oven"], craftable = Crafting.Edibles, header = Loc[Config.Lan].menu["header_oven"], coords = v.Targets.EdibleLoc.xyz, }, }, distance = 2.0 })

                --WORKER ITEMS --
                Targets["WWShop"] =
                    exports['qb-target']:AddBoxZone("WWShop", vec3(v.Targets.StoreLoc.x, v.Targets.StoreLoc.y, v.Targets.StoreLoc.z-1), 0.6, 2.0,
                    { name="WWShop", heading = v.Targets.StoreLoc.w, debugPoly=Config.Debug, minZ = v.Targets.StoreLoc.z-1.03, maxZ= v.Targets.StoreLoc.z+1, },
                    { options = { {  event = "jixel-whitewidow:Shop", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = v.job, wjob = v.job, coords = v.Targets.StoreLoc.xyz, }, }, distance = 2.0 })

                --STORAGE
                Targets["WWWeedPrepared"] =
                    exports['qb-target']:AddBoxZone("WWWeedPrepared", vec3(v.Targets.PreppedStorage.x, v.Targets.PreppedStorage.y, v.Targets.PreppedStorage.z-1), 0.6, 2.8,
                    { name="WWWeedPrepared", heading = 249.94, debugPoly=Config.Debug, minZ= v.Targets.PreppedStorage.z-1, maxZ= v.Targets.PreppedStorage.z+1 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_1", coords = v.Targets.PreppedStorage.xyz, }, },  distance = 2.0 })
                Targets["WWWeedPrepared2"] =
                    exports['qb-target']:AddBoxZone("WWWeedPrepared2", vec3(v.Targets.PreppedStorage2.x, v.Targets.PreppedStorage2.y, v.Targets.PreppedStorage2.z-1), 0.6, 2.8,
                    { name="WWWeedPrepared2", heading = 160.25, debugPoly=Config.Debug, minZ= v.Targets.PreppedStorage2.z-1.03, maxZ= v.Targets.PreppedStorage2.z+1 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_2", coords = v.Targets.PreppedStorage2.xyz, }, },  distance = 2.0 })
                Targets["WWEmployeeStorage"] =
                    exports['qb-target']:AddBoxZone("WWEmployeeStorage", vec3(v.Targets.EmployeeStorage.x, v.Targets.EmployeeStorage.y, v.Targets.EmployeeStorage.z-1), 2.0, 0.9,
                    { name="WWEmployeeStorage", heading = 160.25, debugPoly=Config.Debug, minZ= v.Targets.EmployeeStorage.z-1.03, maxZ= v.Targets.EmployeeStorage.z }, { options = {
                        {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_3", coords = v.Targets.EmployeeStorage.xyz, },
                        { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["table"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                        }, distance = 2.0 })

                --Payments
                Targets["WWPOS"] =
                    exports['qb-target']:AddBoxZone("WWPOS", vec3(189.03, -241.17, 54.07), 0.6, 0.6, { name="WWPOS1", heading = 247.61, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(188.09, -243.54, 54.07),
                    img = "<center><p><img src=https://i.imgur.com/OWrv91s.png width=100px></p>"}, }, distance = 2.0 })
                Targets["WWPOS2"] =
                    exports['qb-target']:AddBoxZone("WWPOS2", vec3(188.09, -243.54, 54.07), 0.6, 0.6, { name="WWPOS2", heading = 247.61, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(188.09, -243.54, 54.07),
                    img = "<center><p><img src=https://i.imgur.com/OWrv91s.png width=100px></p>"}, }, distance = 2.0 })
                Targets["WWPOS3"] =
                    exports['qb-target']:AddBoxZone("WWPOS3", vec3(197.95, -235.69, 54.07-1), 0.6, 0.6, { name="WWPOS3", heading = 125.75, debugPoly=Config.Debug, minZ=53.20, maxZ=54.37 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(197.95, -235.69, 54.07),
                    img = "<center><p><img src=https://i.imgur.com/OWrv91s.png width=100px></p>" }, }, distance = 2.0 })

                --Tables
                Targets["WWTable"] =
                    exports['qb-target']:AddBoxZone("WWTable", vec3(199.55, -246.94, 53.07), 1.1, 1.1, { name="WWTable", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_1", coords = vec3(199.55, -246.94, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["WWTable2"] =
                    exports['qb-target']:AddBoxZone("WWTable2", vec3(188.09, -252.81, 53.07), 1.1, 1.1, { name="WWTable2", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                        { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_2", coords = vec3(188.09, -252.81, 54.07), },
                        { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                        }, distance = 2.0 })
                Targets["WWTable3"] =
                    exports['qb-target']:AddBoxZone("WWTable3", vec3(197.36, -252.95, 53.07), 1.1, 1.1, { name="WWTable3", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_3", coords = vec3(197.36, -252.95, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["WWTable4"] =
                    exports['qb-target']:AddBoxZone("WWTable4", vec3(195.81, -257.58, 53.07), 1.1, 1.1, { name="WWTable4", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_4", coords = vec3(195.81, -257.58, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["WWTable5"] =
                    exports['qb-target']:AddBoxZone("WWTable5", vec3(193.65, -263.1, 53.07), 1.1, 1.1, { name="WWTable5", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_5", coords = vec3(193.65, -263.1, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["WWTable6"] =
                    exports['qb-target']:AddBoxZone("WWTable6", vec3(185.99, -258.46, 53.07), 1.1, 1.1, { name="WWTable6", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_6", coords = vec3(185.99, -258.46, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["WWTable7"] =
                    exports['qb-target']:AddBoxZone("WWTable7", vec3(183.85, -264.76, 53.07), 1.1, 1.1, { name="WWTable7", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_7", coords = vec3(183.85, -264.76, 54.07), },
                        { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                        }, distance = 2.0 })
                Targets["WWTable8"] =
                    exports['qb-target']:AddBoxZone("WWTable8", vec3(192.08, -267.76, 53.07), 1.1, 1.1, { name="WWTable8", heading = 160.25, debugPoly=Config.Debug, minZ=53.20, maxZ=54.07 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_8", coords = vec3(192.08, -267.76, 54.07), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(199.55, -246.94, 54.07), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })

                -- TRAY
                Targets["WWTray"] =
                    exports['qb-target']:AddBoxZone("WWTray", vec3(188.53, -239.69, 54.07), 0.6, 0.6, { name="WWTray", heading = 340.44, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "WWTray_1", coords = vec3(188.53, -239.69, 54.07), }, },  distance = 2.0 })
                Targets["WWTray2"] =
                    exports['qb-target']:AddBoxZone("WWTray2", vec3(188.56, -242.36, 54.07), 0.6, 0.6, { name="WWTray2", heading = 247.66, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "WWTray_2", coords = vec3(188.56, -242.36, 54.07), }, },  distance = 2.0 })

                Targets["WWClockin"] =
                    exports['qb-target']:AddBoxZone("WWClockin", vec3(182.48, -250.17, 53.75), 0.6, 0.6, { name="WWClockin", heading = 223.06, debugPoly=Config.Debug, minZ = 53.00, maxZ = 54.00, },
                    { options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(182.48, -250.17, 54.07), },
                                { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(184.25, -244.34, 54.07), },
                                }, distance = 2.0 })

            elseif v.MLO == "bestbuds" then

                Props[#Props+1] = makeProp({prop = "v_res_r_silvrtray", coords = vec4(379.2, -827.39, 30.32, 1.12)}, true, false)
                Props[#Props+1] = makeProp({prop = "v_res_r_silvrtray", coords = vec4(375.53, -828.86, 30.32, 90.12)}, true, false)
                Props[#Props+1] = makeProp({prop = "prop_cooker_03", coords = v.Targets.EdibleLoc}, true, false)
                Props[#Props+1] = makeProp({prop = "prop_bong_01", coords = vec4(382.27, -831.11, 29.85, 173.18) }, true, false)
                Props[#Props+1] = makeProp({prop = "prop_laptop_01a", coords = vec4(375.48, -824.43, 30.12, 195.76) }, true, false)
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(378.16, -814.77, 26.88, 192.86) }, true, false)   -- 1st
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(379.31, -814.77, 26.88, 175.63) }, true, false)   -- 2nd
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(380.4, -814.77, 26.88, 183.9) }, true, false)     -- 3rd
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(382.22, -814.77, 26.88, 260.95) }, true, false)   -- 4th
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(383.23, -814.77, 26.88, 242.42) }, true, false)   -- 5th
                Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(377.74, -824.5, 26.88, 242.42) }, true, false)    -- 6th

                --HARVESTING--
                Targets["StrainOneBB"] =
                    exports['qb-target']:AddBoxZone("StrainOneBB", vec3(v.Strain.StrainOne.x, v.Strain.StrainOne.y, v.Strain.StrainOne.z-1), 3.0, 0.6,
                    { name="StrainOneBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainOne.z-1.03, maxZ = v.Strain.StrainOne.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainOne, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainOne.xyz, }, }, distance = 1.0 })
                Targets["StrainTwoBB"] =
                    exports['qb-target']:AddBoxZone("StrainTwoBB", vec3(v.Strain.StrainTwo.x, v.Strain.StrainTwo.y, v.Strain.StrainTwo.z-1), 3.0, 0.6,
                    { name="StrainTwoBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainTwo.z-1.03, maxZ = v.Strain.StrainTwo.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainTwo, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainTwo.xyz, }, }, distance = 1.0 })
                Targets["StrainThreeBB"] =
                    exports['qb-target']:AddBoxZone("StrainThreeBB", vec3(v.Strain.StrainThree.x, v.Strain.StrainThree.y, v.Strain.StrainThree.z-1), 3.0, 0.6,
                    { name="StrainThreeBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainThree.z-1.03, maxZ = v.Strain.StrainThree.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainThree, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainThree.xyz, }, }, distance = 1.0 })
                Targets["StrainFourBB"] =
                    exports['qb-target']:AddBoxZone("StrainFourBB", vec3(v.Strain.StrainFour.x, v.Strain.StrainFour.y, v.Strain.StrainFour.z-1), 2.0, 0.6,
                    { name="StrainFourBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainFour.z-1.03, maxZ = v.Strain.StrainFour.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFour, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFour.xyz, }, }, distance = 1.0 })
                Targets["StrainFiveBB"] =
                    exports['qb-target']:AddBoxZone("StrainFiveBB", vec3(v.Strain.StrainFive.x, v.Strain.StrainFive.y, v.Strain.StrainFive.z-1), 2.0, 0.6,
                    { name="StrainFiveBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainFive.z-1.03, maxZ = v.Strain.StrainFive.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFive, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFive.xyz, }, }, distance = 1.0 })
                Targets["StrainSixBB"] =
                    exports['qb-target']:AddBoxZone("StrainSixBB", vec3(v.Strain.StrainSix.x, v.Strain.StrainSix.y, v.Strain.StrainSix.z-1), 2.0, 0.6,
                    { name="StrainSix", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainSix.z-1.03, maxZ = v.Strain.StrainSix.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSix, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSix.xyz, }, }, distance = 1.0 })
                Targets["StrainSevenBB"] =
                    exports['qb-target']:AddBoxZone("StrainSevenBB", vec3(v.Strain.StrainSeven.x, v.Strain.StrainSeven.y, v.Strain.StrainSeven.z-1), 1.6, 0.6,
                    { name="StrainSevenBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainSeven.z-1.03, maxZ = v.Strain.StrainSeven.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSeven, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSeven.xyz, }, }, distance = 1.0 })
                Targets["StrainEightBB"] =
                    exports['qb-target']:AddBoxZone("StrainEightBB", vec3(v.Strain.StrainEight.x, v.Strain.StrainEight.y, v.Strain.StrainEight.z-1), 1.6, 0.6,
                    { name="StrainEightBB", heading = 270, debugPoly = Config.Debug, minZ = v.Strain.StrainEight.z-1.03, maxZ = v.Strain.StrainEight.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainEight, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainEight.xyz, }, }, distance = 1.0 })

                --JOINTS
                Targets["BBJoints"] =
                    exports['qb-target']:AddBoxZone("BBJoints", vec3(v.Targets.JointsLoc.x, v.Targets.JointsLoc.y, v.Targets.JointsLoc.z-1), 0.6, 2.0,
                    { name="BBJoints", heading = v.Targets.JointsLoc.w, debugPoly = Config.Debug, minZ = v.Targets.JointsLoc.z-1.03, maxZ = v.Targets.JointsLoc.z, },
                        { options = {
                            { event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["joints"], craftable = Crafting.Joints, header = Loc[Config.Lan].menu["header_joints"], coords = v.Targets.JointsLoc.xyz, },
                            { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["trimming"], craftable = Crafting.Trimming, header = Loc[Config.Lan].menu["header_trimming"], coords = v.Targets.TrimmingLoc.xyz, },
                        }, distance = 2.0 })

                --COOKING--
                Targets["BBEdibleOven"] =
                    exports['qb-target']:AddBoxZone("BBEdibleOven", vec3(v.Targets.EdibleLoc.x, v.Targets.EdibleLoc.y, v.Targets.EdibleLoc.z-1), 0.9, 1.7,
                    { name="BBEdibleOven", heading = v.Targets.EdibleLoc.w, debugPoly = Config.Debug, minZ = v.Targets.EdibleLoc.z-1.03, maxZ = v.Targets.EdibleLoc.z, },
                    { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-utensil-spoon", job = v.job, label =Loc[Config.Lan].target["oven"], craftable = Crafting.Edibles, header = Loc[Config.Lan].menu["header_oven"], coords = v.Targets.EdibleLoc.xyz, }, }, distance = 2.0 })

                --WORKER ITEMS --
                Targets["BBShop"] =
                    exports['qb-target']:AddBoxZone("BBShop", vec3(v.Targets.StoreLoc.x, v.Targets.StoreLoc.y, v.Targets.StoreLoc.z-1), 0.6, 1.2,
                    { name="BBShop", heading = v.Targets.StoreLoc.w, debugPoly=Config.Debug, minZ = v.Targets.StoreLoc.z-1.03, maxZ= v.Targets.StoreLoc.z+1, },
                    { options = { {  event = "jixel-whitewidow:Shop", icon = "fas fa-box-open", label = v.label.." "..Loc[Config.Lan].target["store"], job = v.job, wjob = v.job, coords = v.Targets.StoreLoc.xyz, }, }, distance = 2.0 })

                --STORAGE
                Targets["BBWeedPrepared"] =
                    exports['qb-target']:AddBoxZone("BBWeedPrepared", vec3(v.Targets.PreppedStorage.x, v.Targets.PreppedStorage.y, v.Targets.PreppedStorage.z-1), 0.6, 2.0,
                    { name="WeedPrepped", heading = v.Targets.PreppedStorage.w, debugPoly=Config.Debug, minZ=v.Targets.PreppedStorage.z-1, maxZ=v.Targets.PreppedStorage.z+1 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "BBShelf_1", coords = v.Targets.PreppedStorage.xyz, }, },  distance = 2.0 })
                Targets["BBWeedPrepared2"] =
                    exports['qb-target']:AddBoxZone("BBWeedPrepared2", vec3(v.Targets.PreppedStorage2.x, v.Targets.PreppedStorage2.y, v.Targets.PreppedStorage2.z-1), 2.0, 0.6,
                    { name="BBWeedPrepped2", heading = v.Targets.PreppedStorage2.w, debugPoly=Config.Debug, minZ= v.Targets.PreppedStorage2.z-1.03, maxZ= v.Targets.PreppedStorage2.z+1 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "BBShelf_2", coords = v.Targets.PreppedStorage2.xyz, }, },  distance = 2.0 })
                Targets["BBEmployeeStorage"] =
                    exports['qb-target']:AddBoxZone("BBEmployeeStorage", vec3(v.Targets.EmployeeStorage.x, v.Targets.EmployeeStorage.y, v.Targets.EmployeeStorage.z-1), 0.8, 0.6,
                    { name="BBEmployeeStorage", heading = 355.5, debugPoly=Config.Debug, minZ=v.Targets.EmployeeStorage.z-.97, maxZ=v.Targets.EmployeeStorage.z+.90 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "BBShelf_3", coords = v.Targets.EmployeeStorage.xyz, }, }, distance = 1.0 })

                --Payments
                Targets["BBPOS"] =
                    exports['qb-target']:AddBoxZone("BBPOS", vec3(380.2, -827.33, 29.29), 0.6, 0.6, { name="BBReceipt1", heading = 180, debugPoly=Config.Debug, minZ=29, maxZ=29.60 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(380.2, -827.33, 29.29),
                    img = "<center><p><img src=https://i.imgur.com/dtT2ghd.png width=100px></p>"}, }, distance = 2.0 })
                Targets["BBPOS2"] =
                    exports['qb-target']:AddBoxZone("BBPOS2", vec3(375.50, -827.33, 29.29), 0.6, 0.6, { name="BBReceipt2", heading = 180, debugPoly=Config.Debug, minZ=29, maxZ=29.60 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(375, -827.33, 29.29),
                    img = "<center><p><img src=https://i.imgur.com/dtT2ghd.png width=100px></p>"}, }, distance = 2.0 })

                --Tables
                Targets["BBTable"] =
                    exports['qb-target']:AddBoxZone("BBTable", vec3(382.26, -831.05, 29.36-1), 1.9, 1.0, { name="BBTable", heading = 0, debugPoly=Config.Debug, minZ=28.36, maxZ=29.56 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "BBTable_1", coords = vec3(382.26, -831.05, 29.36), },
                    { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(382.26, -831.05, 29.36), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })


                -- TRAY
                Targets["BBTray"] =
                    exports['qb-target']:AddBoxZone("BBTray", vec3(379.2, -827.39, 29.32), 0.55, 0.7, { name="BBTray", heading = 1.44, debugPoly=Config.Debug, minZ= 29.22, maxZ= 29.52 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "BBTray_1", coords = vec3(379.2, -827.39, 29.32), }, },  distance = 2.0 })
                Targets["BBTray2"] =
                    exports['qb-target']:AddBoxZone("BBTray2", vec3(375.53, -828.86, 29.32), 0.55, 0.7, { name="BBTray2", heading = 90.66, debugPoly=Config.Debug, minZ= 29.22, maxZ=29.52 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "BBTray_2", coords = vec3(375.53, -828.86, 29.32), }, },  distance = 2.0 })

                Targets["BBClockin"] =
                    exports['qb-target']:AddBoxZone("BBClockin", vec3(375.48, -824.43, 29.3-1), 0.6, 0.6, { name="BBClockin", heading = 200.06, debugPoly=Config.Debug, minZ = 28.70, maxZ = 30.47, },
                    { options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(375.48, -824.43, 29.3), },
                                { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(375.48, -824.43, 29.3), },
                                }, distance = 2.0 })

            elseif v.MLO == "jenww" then

                Props[#Props+1] = makeProp({prop = "prop_griddle_02", coords = v.Targets.EdibleLoc}, true, false)
                -- Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(183.47, -252.71, 50.87, 356.34) }, true, false) -- 1st
                -- Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(181.65, -251.93, 50.87, 328.4) }, true, false) -- 2nd
                -- Props[#Props+1] = makeProp({prop = "bkr_prop_weed_med_01a", coords = vec4(182.47, -252.38, 50.87, 328.4) }, true, false) -- 3rd
                Props[#Props+1] = makeProp({prop = "prop_weed_block_01", coords = vec4(177.6, -252.95, 54.09, 328.4) }, true, false) -- brick
                Props[#Props+1] = makeProp({prop = "prop_weed_block_01", coords = vec4(178.69, -253.28, 54.09, 328.4) }, true, false) -- brick
                Props[#Props+1] = makeProp({prop = "prop_weed_block_01", coords = vec4(175.75, -252.33, 54.09, 328.4) }, true, false) -- brick
                Props[#Props+1] = makeProp({prop = "prop_cs_silver_tray", coords = vec4(198.41, -246.35, 55.17, 70) }, true, false)
                Props[#Props+1] = makeProp({prop = "prop_cs_silver_tray", coords = vec4(199.08, -244.44, 55.17, 70) }, true, false)
                --HARVESTING--
                -- Targets["StrainOneJC"] =
                --     exports['qb-target']:AddBoxZone("StrainOneJC", vec3(v.Strain.StrainOne.x, v.Strain.StrainOne.y, v.Strain.StrainOne.z-1), 1.2, 1.2,
                --     { name="StrainOneJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainOne.z-0.3, maxZ = v.Strain.StrainOne.z+1.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainOne, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainOne.xyz, }, }, distance = 1.0 })
                --     Targets["StrainTwoJC"] =
                --     exports['qb-target']:AddBoxZone("StrainTwoJC", vec3(v.Strain.StrainTwo.x, v.Strain.StrainTwo.y, v.Strain.StrainTwo.z-1), 0.8, 0.8,
                --     { name="StrainTwoJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainTwo.z-1.03, maxZ = v.Strain.StrainTwo.z+0.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainTwo, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainTwo.xyz, }, }, distance = 1.0 })
                -- Targets["StrainThreeJC"] =
                --     exports['qb-target']:AddBoxZone("StrainThreeJC", vec3(v.Strain.StrainThree.x, v.Strain.StrainThree.y, v.Strain.StrainThree.z-1), 0.8, 0.8,
                --     { name="StrainThreeJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainThree.z-1.03, maxZ = v.Strain.StrainThree.z+0.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainThree, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainThree.xyz, }, }, distance = 1.0 })
                -- Targets["StrainFourJC"] =
                --     exports['qb-target']:AddBoxZone("StrainFourJC", vec3(v.Strain.StrainFour.x, v.Strain.StrainFour.y, v.Strain.StrainFour.z-1), 0.8, 0.8,
                --     { name="StrainFourJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainFour.z-1.03, maxZ = v.Strain.StrainFour.z+0.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFour, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFour.xyz, }, }, distance = 1.0 })
                -- Targets["StrainFiveJC"] =
                --     exports['qb-target']:AddBoxZone("StrainFiveJC", vec3(v.Strain.StrainFive.x, v.Strain.StrainFive.y, v.Strain.StrainFive.z), 0.8, 0.8,
                --     { name="StrainFiveJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainFive.z-0.3, maxZ = v.Strain.StrainFive.z+1.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFive, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFive.xyz, }, }, distance = 1.0 })
                -- Targets["StrainSixJC"] =
                --     exports['qb-target']:AddBoxZone("StrainSixJC", vec3(v.Strain.StrainSix.x, v.Strain.StrainSix.y, v.Strain.StrainSix.z-1), 1.2, 1.2,
                --     { name="StrainSix", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainSix.z-0.3, maxZ = v.Strain.StrainSix.z+1.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSix, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSix.xyz, }, }, distance = 1.0 })
                -- Targets["StrainSevenJC"] =
                --     exports['qb-target']:AddBoxZone("StrainSevenJC", vec3(v.Strain.StrainSeven.x, v.Strain.StrainSeven.y, v.Strain.StrainSeven.z-1), 0.8, 0.8,
                --     { name="StrainSevenJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainSeven.z-0.3, maxZ = v.Strain.StrainSeven.z+1.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSeven, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSeven.xyz, }, }, distance = 1.0 })
                -- Targets["StrainEightJC"] =
                --     exports['qb-target']:AddBoxZone("StrainEightJC", vec3(v.Strain.StrainEight.x, v.Strain.StrainEight.y, v.Strain.StrainEight.z-1), 1.0, 1.0,
                --     { name="StrainEightJC", heading = 70, debugPoly = Config.Debug, minZ = v.Strain.StrainEight.z-0.3, maxZ = v.Strain.StrainEight.z+1.5, },
                --     { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainEight, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainEight.xyz, }, }, distance = 1.0 })

                --JOINTS--
                Targets["JCJoints"] =
                    exports['qb-target']:AddBoxZone("JCJoints", vec3(v.Targets.JointsLoc.x, v.Targets.JointsLoc.y, v.Targets.JointsLoc.z-1), 1.0, 2.2,
                    { name="JCJoints", heading = 338, debugPoly = Config.Debug, minZ = v.Targets.JointsLoc.z-1.03, maxZ = v.Targets.JointsLoc.z, },
                    { options = { { event = "malmo-weedharvest:client:grindWeed", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["joints"], WW = true, craftable = Crafting.Joints, header = Loc[Config.Lan].menu["header_joints"], coords = v.Targets.JointsLoc.xyz, }, }, distance = 2.0 })

                Targets["JCTrimming"] =
                    exports['qb-target']:AddBoxZone("JCTrimming", vec3(v.Targets.TrimmingLoc.x, v.Targets.TrimmingLoc.y, v.Targets.TrimmingLoc.z-1), 0.6, 2.2,
                    { name="JCTrimming", heading = 338, debugPoly = Config.Debug, minZ = v.Targets.TrimmingLoc.z-1.03, maxZ = v.Targets.TrimmingLoc.z, },
                    { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["trimming"], craftable = Crafting.Trimming, header = Loc[Config.Lan].menu["header_trimming"], coords = v.Targets.TrimmingLoc.xyz, }, }, distance = 2.0 })

                --COOKING--
                Targets["JCEdibleOven"] =
                    exports['qb-target']:AddBoxZone("JCEdibleOven", vec3(v.Targets.EdibleLoc.x, v.Targets.EdibleLoc.y, v.Targets.EdibleLoc.z-1), 0.4, 0.4,
                    { name="JCEdibleOven", heading = v.Targets.EdibleLoc.w, debugPoly = Config.Debug, minZ = v.Targets.EdibleLoc.z-1.03, maxZ = v.Targets.EdibleLoc.z, },
                    { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-utensil-spoon", job = v.job, label =Loc[Config.Lan].target["oven"], craftable = Crafting.Edibles, header = Loc[Config.Lan].menu["header_oven"], coords = v.Targets.EdibleLoc.xyz, }, }, distance = 8.0 })
                --Targets["JCCoffee"] =
                    --exports['qb-target']:AddBoxZone("JCCoffee", vec3(v.Targets.CoffeeLoc.x, v.Targets.CoffeeLoc.y, v.Targets.CoffeeLoc.z-1), 0.4, 0.4,
                    --{ name="JCCoffee", heading = 250, debugPoly = Config.Debug, minZ = v.Targets.CoffeeLoc.z-1.03, maxZ = v.Targets.CoffeeLoc.z, },
                    --{ options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-utensil-spoon", item = "trimmers", label = Loc[Config.Lan].target["coffee"], craftable = Crafting.Coffee, header = Loc[Config.Lan].menu["header_coffee"], coords = v.Targets.CoffeeLoc.xyz, }, }, distance = 2.0 })

                --WORKER ITEMS --
                Targets["JCShop"] =
                    exports['qb-target']:AddBoxZone("JCShop", vec3(v.Targets.StoreLoc.x, v.Targets.StoreLoc.y, v.Targets.StoreLoc.z-1), 2.1, 3.5,
                    { name="JCShop", heading = v.Targets.StoreLoc.w, debugPoly=Config.Debug, minZ = v.Targets.StoreLoc.z-1.03, maxZ=v.Targets.StoreLoc.z+1, },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = v.job, wjob = v.job, stash = "WWIngredients", coords = v.Targets.StoreLoc.xyz, }, }, distance = 2.0 })

                --STORAGE
                Targets["JCWeedPrepared"] =
                    exports['qb-target']:AddBoxZone("JCWeedPrepared", vec3(v.Targets.PreppedStorage.x, v.Targets.PreppedStorage.y, v.Targets.PreppedStorage.z-1), 5.5, 1.2,
                    { name="JCWeedPrepared", heading = v.Targets.PreppedStorage.w, debugPoly=Config.Debug, minZ=v.Targets.PreppedStorage.z-1, maxZ=v.Targets.PreppedStorage.z+1 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_1", coords = v.Targets.PreppedStorage.xyz, }, },  distance = 2.0 })

                Targets["JCWeedPrepared2"] =
                    exports['qb-target']:AddBoxZone("JCWeedPrepared2", vec3(v.Targets.PreppedStorage2.x, v.Targets.PreppedStorage2.y, v.Targets.PreppedStorage2.z-1), 5.5, 1.2,
                        { name="JCWeedPrepared2", heading = v.Targets.PreppedStorage2.w, debugPoly=Config.Debug, minZ=v.Targets.PreppedStorage2.z-1, maxZ=v.Targets.PreppedStorage2.z+1 },
                        { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_2", coords = v.Targets.PreppedStorage2.xyz, }, },  distance = 2.0 })

                Targets["JCWeedPrepared3"] =
                    exports['qb-target']:AddBoxZone("JCWeedPrepared3", vec3(v.Targets.PreppedStorage3.x, v.Targets.PreppedStorage3.y, v.Targets.PreppedStorage3.z-1), 5.5, 1.2,
                        { name="JCWeedPrepared3", heading = v.Targets.PreppedStorage.w, debugPoly=Config.Debug, minZ=v.Targets.PreppedStorage3.z-1, maxZ=v.Targets.PreppedStorage3.z+1 },
                        { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WWShelf_3", coords = v.Targets.PreppedStorage3.xyz, }, },  distance = 2.0 })
                Targets["JCWeedPrepared4"] =
                    exports['qb-target']:AddBoxZone("JCWeedPrepared4", vec3(v.Targets.EmployeeStorage.x, v.Targets.EmployeeStorage.y, v.Targets.EmployeeStorage.z-1), 0.6, 2.2,
                        { name="JCWeedPrepared4", heading = v.Targets.EmployeeStorage.w, debugPoly=Config.Debug, minZ=v.Targets.EmployeeStorage.z-1, maxZ=v.Targets.EmployeeStorage.z+1 },
                        { options = { {  event = "malmo-weedharvest:client:TrimTable", icon = "fa-solid fa-scissors", label = "Scale & Trim Weed", job = v.job, coords = v.Targets.EmployeeStorage.xyz, }, },  distance = 2.0 })

                --Payments
                Targets["JCPOS"] =
                    exports['qb-target']:AddBoxZone("JCPOS", vec3(198.01, -247.64, 54.11), 0.6, 0.6, { name="JCReceipt1", heading = 248.83, debugPoly=Config.Debug, minZ=54.2, maxZ=54.5 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(198.62, -245.54, 54.11),
                    img = "<center><p><img src=https://i.imgur.com/dtT2ghd.png width=100px></p>"},
                    { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(375.48, -824.43, 30.12), }, }, distance = 2.0 })
                Targets["JCPOS2"] =
                    exports['qb-target']:AddBoxZone("JCPOS2", vec3(198.62, -245.54, 54.11), 0.6, 0.6, { name="JCReceipt2", heading = 248.83, debugPoly=Config.Debug, minZ=54.2, maxZ=54.5 },
                    { options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(198.62, -245.54, 54.11),
                    img = "<center><p><img src=https://i.imgur.com/dtT2ghd.png width=100px></p>"},
                    { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(375.48, -824.43, 30.12), }, }, distance = 2.0 })

                --Tables
                Targets["JCTable"] =
                    exports['qb-target']:AddBoxZone("JCTable", vec3(193.68, -233.19, 53.6-1), 0.8, 0.8, { name="JCTable", heading = 273.55, debugPoly=Config.Debug, minZ=53.2, maxZ=54.8 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_1", coords = vec3(193.68, -233.19, 53.6), },
                    { event = "malmo-weedharvest:client:HitTheBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(193.68, -233.19, 53.6), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })
                Targets["JCTable2"] =
                    exports['qb-target']:AddBoxZone("JCTable2", vec3(188.69, -265.08, 54.1-1), 2.0, 1.2, { name="JCTable2", heading = 70.0, debugPoly=Config.Debug, minZ=53.1, maxZ=54.3 }, { options = {
                    { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WWTable_2", coords = vec3(188.69, -265.08, 54.1), },
                    { event = "malmo-weedharvest:client:HitTheBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(188.69, -265.08, 54.1), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                    }, distance = 2.0 })

                -- TRAY
                Targets["JCTray"] =
                    exports['qb-target']:AddBoxZone("JCTray", vec3(198.41, -246.35, 55.17-1.1), 0.6, 0.6, { name="JCTray", heading = 340.44, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "WWTray_1", coords = vec3(188.53, -239.69, 54.07), }, },  distance = 2.0 })
                Targets["JCTray2"] =
                    exports['qb-target']:AddBoxZone("JCTray2", vec3(199.08, -244.44, 55.17-1.1), 0.6, 0.6, { name="JCTray2", heading = 247.66, debugPoly=Config.Debug, minZ=54.07, maxZ=54.37 },
                    { options = { {  event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "WWTray_2", coords = vec3(188.56, -242.36, 54.07), }, },  distance = 2.0 })

                 --[[ Targets["jenboss"] =
                    exports['qb-target']:AddBoxZone("jenboss", vec3(378.63, -821.74, 30.6), 0.7, 0.7, { name="jenboss", heading = 0.0, debugPoly=Config.Debug, minZ = 28.3, maxZ = 29.2, },
                        { options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(184.25, -244.34, 54.07), }, }, distance = 2.0 })]]

                --[[Targets["JCClockin"] =
                    exports['qb-target']:AddBoxZone("JCClockin", vec3(375.48, -824.43, 30.12), 0.6, 0.6, { name="JCClockin", heading = 223.06, debugPoly=Config.Debug, minZ = 28.70, maxZ = 29.40, },
                    { options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(375.48, -824.43, 30.12), },}, distance = 2.0 })
]]

            elseif v.MLO == "supreme" then
--[[                 Targets["WCBoss"] =
                    exports['qb-target']:AddBoxZone("WCBoss", vec3(378.63, -821.74, 30.6), 0.7, 0.7, { name="WCBoss", heading = 0.0, debugPoly=Config.Debug, minZ = 28.3, maxZ = 29.2, },
                        { options = { { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(184.25, -244.34, 54.07), }, }, distance = 2.0 })
 ]]
                Props[#Props+1] = makeProp({prop = `prop_cooker_03`, coords = v.Targets.EdibleLoc}, true, false)
                Props[#Props+1] = makeProp({prop = `bkr_prop_weed_table_01a`, coords = vec4(357.89, -1011.69, 29.4, 89.26) }, true, false)
                Props[#Props+1] = makeProp({prop = `v_club_officesofa`, coords = vec4(353.73, -1022.2, 29.4, 88) }, true, false)
                Props[#Props+1] = makeProp({prop = `v_res_d_roundtable`, coords = vector4(353.80, -1023.76, 29.4, 88) }, true, false)
                Props[#Props+1] = makeProp({prop = `prop_bong_01`, coords = vector4(353.80, -1023.76, 30.2, 88) }, true, false)

                --HARVESTING--
                Targets["StrainOneWC"] =
                        exports['qb-target']:AddBoxZone("StrainOneWC", vec3(v.Strain.StrainOne.x, v.Strain.StrainOne.y, v.Strain.StrainOne.z-1), 3.2, 0.6,
                            { name="StrainOneWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainOne.z-1.03, maxZ = v.Strain.StrainOne.z+0.5, },
                            { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainOne, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainOne.xyz, }, }, distance = 1.0 })
                Targets["StrainTwoWC"] =
                    exports['qb-target']:AddBoxZone("StrainTwoWC", vec3(v.Strain.StrainTwo.x, v.Strain.StrainTwo.y, v.Strain.StrainTwo.z-1), 3.2, 0.6,
                        { name="StrainTwoWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainTwo.z-1.03, maxZ = v.Strain.StrainTwo.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainTwo, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainTwo.xyz, }, }, distance = 1.0 })
                Targets["StrainThreeWC"] =
                    exports['qb-target']:AddBoxZone("StrainThreeWC", vec3(v.Strain.StrainThree.x, v.Strain.StrainThree.y, v.Strain.StrainThree.z-1), 3.2, 0.6,
                        { name="StrainThreeWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainThree.z-1.03, maxZ = v.Strain.StrainThree.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainThree, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainThree.xyz, }, }, distance = 1.0 })
                Targets["StrainFourWC"] =
                    exports['qb-target']:AddBoxZone("StrainFourWC", vec3(v.Strain.StrainFour.x, v.Strain.StrainFour.y, v.Strain.StrainFour.z-1), 3.2, 0.6,
                        { name="StrainFourWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainFour.z-1.03, maxZ = v.Strain.StrainFour.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFour, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFour.xyz, }, }, distance = 1.0 })
                Targets["StrainFiveWC"] =
                    exports['qb-target']:AddBoxZone("StrainFiveWC", vec3(v.Strain.StrainFive.x, v.Strain.StrainFive.y, v.Strain.StrainFive.z-1), 0.6, 0.6,
                        { name="StrainFiveWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainFive.z-1.03, maxZ = v.Strain.StrainFive.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainFive, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainFive.xyz, }, }, distance = 1.0 })
                Targets["StrainSixWC"] =
                    exports['qb-target']:AddBoxZone("StrainSixWC", vec3(v.Strain.StrainSix.x, v.Strain.StrainSix.y, v.Strain.StrainSix.z-1), 0.6, 0.6,
                        { name="StrainSix", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainSix.z-1.03, maxZ = v.Strain.StrainSix.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSix, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSix.xyz, }, }, distance = 1.0 })
                Targets["StrainSevenWC"] =
                    exports['qb-target']:AddBoxZone("StrainSevenWC", vec3(v.Strain.StrainSeven.x, v.Strain.StrainSeven.y, v.Strain.StrainSeven.z-1), 0.6, 0.6,
                        { name="StrainSevenWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainSeven.z-1.03, maxZ = v.Strain.StrainSeven.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainSeven, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainSeven.xyz, }, }, distance = 1.0 })
                Targets["StrainEightWC"] =
                    exports['qb-target']:AddBoxZone("StrainEightWC", vec3(v.Strain.StrainEight.x, v.Strain.StrainEight.y, v.Strain.StrainEight.z-1), 0.6, 0.6,
                        { name="StrainEightWC", heading = 0, debugPoly = Config.Debug, minZ = v.Strain.StrainEight.z-1.03, maxZ = v.Strain.StrainEight.z+0.5, },
                        { options = { { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["harvest"], craftable = Crafting.Strains.StrainEight, header = Loc[Config.Lan].menu["header_harvest"], coords = v.Strain.StrainEight.xyz, }, }, distance = 1.0 })

                --JOINTS
                Targets["WCJoints"] =
                    exports['qb-target']:AddBoxZone("WCJoints", vec3(v.Targets.JointsLoc.x, v.Targets.JointsLoc.y, v.Targets.JointsLoc.z-1), 1.0, 2.2,
                        { name="WCJoints", heading = v.Targets.JointsLoc.w, debugPoly = Config.Debug, minZ = v.Targets.JointsLoc.z-1.03, maxZ = v.Targets.JointsLoc.z, },
                        { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["joints"], craftable = Crafting.Joints, header = Loc[Config.Lan].menu["header_joints"], coords = v.Targets.JointsLoc.xyz, },
                        { item = "trimmers", event = "jixel-whitewidow:Crafting", icon = "fas fa-cannabis", job = v.job, label = Loc[Config.Lan].target["trimming"], craftable = Crafting.Trimming, header = Loc[Config.Lan].menu["header_trimming"], coords = v.Targets.TrimmingLoc.xyz, }, },
                        distance = 2.0 })

                --COOKING--
                Targets["WCEdibleOven"] =
                    exports['qb-target']:AddBoxZone("WCEdibleOven", vec3(v.Targets.EdibleLoc.x, v.Targets.EdibleLoc.y, v.Targets.EdibleLoc.z-1), 0.9, 1.7,
                        { name="WCEdibleOven", heading = v.Targets.EdibleLoc.w, debugPoly = Config.Debug, minZ = v.Targets.EdibleLoc.z-1.03, maxZ = v.Targets.EdibleLoc.z, },
                        { options = { { event = "jixel-whitewidow:Crafting", icon = "fas fa-utensil-spoon", job = v.job, label =Loc[Config.Lan].target["oven"], craftable = Crafting.Edibles, header = Loc[Config.Lan].menu["header_oven"], coords = v.Targets.EdibleLoc.xyz, }, }, distance = 2.0 })

                --WORKER ITEMS --
                Targets["WCShop"] =
                    exports['qb-target']:AddBoxZone("WCShop", vec3(v.Targets.StoreLoc.x, v.Targets.StoreLoc.y, v.Targets.StoreLoc.z-1), 3.5, 0.8,
                        { name="WCShop", heading = v.Targets.StoreLoc.w, debugPoly=Config.Debug, minZ = v.Targets.StoreLoc.z-1.03, maxZ=v.Targets.StoreLoc.z+1, },
                        { options = { { event = "jixel-whitewidow:Shop", icon = "fas fa-box-open", label = Loc[Config.Lan].target["store"], job = v.job, wjob = v.job, coords = v.Targets.StoreLoc.xyz, }, }, distance = 2.0 })

                --STORAGE
                Targets["WCWeedPrepared"] =
                    exports['qb-target']:AddBoxZone("WCWeedPrepared", vec3(v.Targets.PreppedStorage.x, v.Targets.PreppedStorage.y, v.Targets.PreppedStorage.z-1), 1.25, 1.0,
                        { name="WeedPrepped", heading = v.Targets.PreppedStorage.w, debugPoly=Config.Debug, minZ=v.Targets.PreppedStorage.z-1, maxZ=v.Targets.PreppedStorage.z+1 },
                        { options = { { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["weed"], job = v.job, stash = "WCShelf_1", coords = v.Targets.PreppedStorage.xyz, }, },  distance = 2.0 })

                --Payments
                Targets["WCPOS"] =
                    exports['qb-target']:AddBoxZone("WCPOS", vec3(357.94, -1019.2, 29.4), 0.6, 0.6, { name="WCReceipt1", heading = 180, debugPoly=Config.Debug, minZ=29, maxZ=29.60 },
                    { options = {
                        { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].target["charge"], job = v.job, coords = vec3(188.09, -243.54, 54.07),
                                    img = "<center><p><img src=https://i.imgur.com/dtT2ghd.png width=100px></p>"},
                        { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].target["duty"], job = v.job, coords = vec3(375.48, -824.43, 30.12), },
                        { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].target["boss"], job = bossroles, coords = vec3(184.25, -244.34, 54.07), },
                    }, distance = 2.0 })

                --Tables
                Targets["WCTable"] =
                    exports['qb-target']:AddBoxZone("WCTable", vec3(353.82, -1023.75, 29.4-1), 0.7, 0.7, { name="WCTable", heading = 0, debugPoly=Config.Debug, minZ=28.4, maxZ=29.8 }, { options = {
                        { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["table"], stash = "WCTable_1", coords = vec3(353.82, -1023.75, 29.4), },
                        { event = "jixel-whitewidow:Crafting:TableBong", icon = "fas fa-cannabis", label = Loc[Config.Lan].target["bong"], coords = vec3(353.82, -1023.75, 29.4), craftable = Crafting.TableBong, header = Loc[Config.Lan].menu["header_tablebong"], },
                        }, distance = 2.0 })

                -- TRAY
                Targets["WCTray"] =
                    exports['qb-target']:AddBoxZone("WCTray", vec3(355.4, -1019.17, 29.4-0.5), 0.5, 0.5, { name="WCTray", heading = 0, debugPoly=Config.Debug, minZ=29.0, maxZ=29.8 },
                        { options = { { event = "jixel-whitewidow:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["counter"], stash = "WCTray_1", coords = vec3(355.4, -1019.17, 29.4), }, },  distance = 2.0 })
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() or not LocalPlayer.state.isLoggedIn then return end
    for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
    exports[Config.Core]:HideText()
    exports['qb-menu']:closeMenu()
end)