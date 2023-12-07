PlayerJob = {}
local Targets, Props, Blips, CraftLock = {}, {}, {},  false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData) PlayerJob = PlayerData.job if PlayerJob.onduty then for k, v in pairs(Config.Locations) do if PlayerData.job.name == v.job then TriggerServerEvent("QBCore:ToggleDuty") end end end end)
	Ped = PlayerPedId()
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	QBCore.Functions.GetPlayerData(function(PlayerData)	PlayerJob = PlayerData.job for k, v in pairs(Config.Locations) do if PlayerData.job.name == v.job then onDuty = PlayerJob.onduty end end end)
	Ped = PlayerPedId()
end)

CreateThread(function()
	local propTable = {}
	if Config.Locations[1].zoneEnable then	-- [[ Main Location ]] --
		local loc = Config.Locations[1]
		local bossroles = {}
		for grade in pairs(QBCore.Shared.Jobs[loc.job].grades) do
			if QBCore.Shared.Jobs[loc.job].grades[grade].isboss == true then
				if bossroles[loc.job] then
					if bossroles[loc.job] > tonumber(grade) then bossroles[loc.job] = tonumber(grade) end
				else bossroles[loc.job] = tonumber(grade)	end
			end
		end
		if loc.zones then
			JobLocation = PolyZone:Create(loc.zones, { name = loc.label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside)
				if PlayerJob.name == loc.job then
					if loc.autoClock and loc.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
					if loc.autoClock and loc.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				end
			end)
		end
		if loc.blip then Blips[#Blips+1] = makeBlip({coords = loc.blip, sprite = loc.blipsprite or 106, col = loc.blipcolor, scale = loc.blipscale, disp = loc.blipdisp, category = nil, name = loc.label}) end
		if loc.MLO == "GN" then
			CoordTables = {
				Fridge = { { coords = vec4(-1201.31, -901.69, 13.49, 35.0), minZ = 13.0, maxZ = 14.5, w = 3.8, d = 0.6, }, },
				Store = { { coords = vec4(-1198.5, -904.02, 12.99, 213.65), minZ = 12.97, maxZ = 15.37, w = 0.4, d = 1.4, }, },
				Shelf = { { coords = vec4(-1195.29, -897.51, 13.47, 35.0), minZ = 13.7, maxZ = 14.87, w = 3.0, d = 1.0, }, },
				Prepare = { { coords = vec4(-1196.54, -899.28, 13.0, 35.65), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 1.8, }, },
				Chop = { { coords = vec4(-1197.19, -898.18, 13.0, 35.65), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 1.8, }, },
				Grill = { { coords = vec4(-1198.27, -895.3, 13.0, 34.0), minZ = 12.67, maxZ = 14.57, w = 0.6, d = 1.6, }, },
				Fryer = { { coords = vec4(-1200.85, -896.84, 13.0, 34.0), minZ = 12.97, maxZ = 14.57, w = 0.6, d = 1.6, }, },
				Drink = { { coords = vec4(-1197.25, -894.48, 13.97, 35.0), minZ = 13.97, maxZ = 14.97, w = 2.0, d = 0.6, }, },
				Donut = { { coords = vec4(-1196.52, -895.74, 13.97, 35.65), minZ = 13.97, maxZ = 15.17, w = 0.8, d = 0.6, }, },
				Tray = {
					{ coords = vec4(-1194.29, -893.85, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.7, }, { coords = vec4(-1193.39, -895.42, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.7, },
					{ coords = vec4(-1192.39, -896.86, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.7, },
				},
				Till = {
					{ coords = vec4(-1194.95, -893.15, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, }, { coords = vec4(-1193.97, -894.67, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, },
					{ coords = vec4(-1192.93, -896.24, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, },
				},
				BBag = { { coords = vec4(-1196.52, -902.07, 13.0, 305.0), minZ = 12.97, maxZ = 14.57, w = 0.7, d = 0.5, }, },
				HandWash = {
					{ coords = vec4(-1197.61, -902.73, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.8, }, { coords = vec4(-1205.24, -893.9, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.8, },
					{ coords = vec4(-1206.01, -892.84, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.8, }, { coords = vec4(-1201.96, -890.09, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.8, },
					{ coords = vec4(-1201.16, -891.14, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.8, },
				},
				Toilets = {
					{ coords = vec4(-1200.58, -886.64, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, { coords = vec4(-1202.00, -887.6, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, },
					{ coords = vec4(-1204.65, -889.41, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, { coords = vec4(-1206.07, -890.36, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, },
					{ coords = vec4(-1202.47, -891.21, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.65, urinal = true }, { coords = vec4(-1201.86, -892.1, 12.97, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.65, urinal = true },
				},
				Clockin = { { coords = vec4(-1179.06, -896.32, 13.47, 10.0), minZ = 13.57, maxZ = 14.7, w = 0.6, d = 0.6, }, },
			}
			propTable[#propTable+1] = { prop = "prop_food_bs_tray_02", coords = vec4(-1193.36, -895.44, 14.1+1.03, 305.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_tray_01", coords = vec4(-1194.52, -893.83, 14.1+1.03, 305.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_tray_01", coords = vec4(-1192.41, -896.84, 14.1+1.03, 305.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1196.68, -902.19, 13.9+1.03, 180.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1196.31, -901.9, 13.9+1.03, 180.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1196.5, -902.09, 13.9+1.03, 300.0) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1184.53, -882.85, 13.94-0.22, 122.53) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1199.6, -884.99, 13.50-0.22, 215.0) }

		elseif loc.MLO == "LP" then
			CoordTables = {
				Fridge = { { coords = vec4(-1203.9, -889.75, 12.99, 215.0), minZ = 13.0, maxZ = 14.5, w = 1.2, d = 1.6, }, },
				Store = { { coords = vec4(-1205.75, -892.99, 12.99, 122.65), minZ = 12.97, maxZ = 15.37, w = 1.0, d = 4.5, }, },
				Shelf = { { coords = vec4(-1197.75, -894.31, 13.99, 122.65), minZ = 13.6, maxZ = 14.6, w = 1.1, d = 4.5, }, },
				Prepare = { { coords = vec4(-1198.37, -898.36, 13.5, 123.65), minZ = 13.3, maxZ = 14.5, w = 1.8, d = 3.2, }, },
				Chop = { { coords = vec4(-1199.38, -902.07, 13.0, 123.65), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 1.5, }, },
				Grill = { { coords = vec4(-1200.27, -900.76, 13.5, 123.65), minZ = 13.3, maxZ = 14.5, w = 0.7, d = 1.2, }, { coords = vec4(-1202.64, -897.27, 13.5, 122.65), minZ = 13.3, maxZ = 14.5, w = 0.7, d = 1.2, }, },
				Fryer = { { coords = vec4(-1201.4, -898.98, 13.5, 123.0), minZ = 13.3, maxZ = 14.5, w = 0.7, d = 2.5, }, },
				Drink = { { coords = vec4(-1199.47, -895.44, 13.8, 122.65), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 2.1, }, },
				Donut = { { coords = vec4(-1203.35, -895.66, 13.5, 122.65), minZ = 13.3, maxZ = 14.8, w = 0.7, d = 1.4, }, },
				Tray = {
					{ coords = vec4(-1196.3, -890.7, 13.5, 215.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 1.0, }, { coords = vec4(-1195.0, -892.68, 13.5, 215.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 1.0, },
					{ coords = vec4(-1193.86, -894.4, 13.5, 215.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 1.0, },
				},
				Till = {
					{ coords = vec4(-1196.04, -891.38, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, }, { coords = vec4(-1194.70, -893.32, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, },
					{ coords = vec4(-1193.42, -895.22, 13.65, 35.0), minZ = 13.5, maxZ = 14.8, w = 0.6, d = 0.6, },
				},
				BBag = { { coords = vec4(-1200.51, -896.17, 13.5, 304.0), minZ = 13.6, maxZ = 14.6, w = 0.5, d = 0.7, }, },
				HandWash = {
					{ coords = vec4(-1197.12, -902.07, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 1.0, }, { coords = vec4(-1198.23, -902.78, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 1.1, d = 0.8, },
					{ coords = vec4(-1200.70, -888.98, 12.98, 35.00), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, }, { coords = vec4(-1198.57, -887.54, 12.98, 215.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, },
				},
				Toilets = { { coords = vec4(-1202.15, -887.81, 13.1, 215.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, { coords = vec4(-1199.88, -886.31, 13.1, 215.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, },
				Clockin = { { coords = vec4(-1193.18, -898.13, 14.2, 34.0), minZ = 14.2, maxZ = 15.2, w = 0.6, d = 2.5, }, },
			}
			--CLEAR PROPS
			local ModelHide = {
				{ coords = vec3(-1202.76, -889.01, 14.0), id = -851111464 }, { coords = vec3(-1202.76, -889.01, 14.0), id = -421145003 }, { coords = vec3(-1199.01, -890.5, 14.0), id = 1864388210 }, { coords = vec3(-1196.95, -886.98, 14.0), id = 1864388210 },
				{ coords = vec3(-1191.59, -882.02, 14.86), id = 1864388210 }, { coords = vec3(-1195.24, -890.98, 14.0), id = 1864388210 }, { coords = vec3(-1186.99, -894.32, 14.86), id = 1864388210 }, { coords = vec3(-1186.81, -881.8, 14.0), id = 1864388210 },
				{ coords = vec3(-1188.73, -890.44, 14.0), id = 1864388210 }, { coords = vec3(-1190.81, -899.94, 14.0), id = 1864388210 }, { coords = vec3(-1182.04, -894.47, 14.0), id = 1864388210 }, { coords = vec3(-1180.42, -892.44, 14.0), id = 1864388210 },
				{ coords = vec3(-1186.26, -896.37, 14.0), id = 1864388210 }, { coords = vec3(-1180.42, -892.44, 14.0), id = 759729215 }, { coords = vec3(-1180.19, -893.49, 14.0), id = -775118285 }, { coords = vec3(-1200.74, -887.44, 14.0), id = 1778631864 },
				{ coords = vec3(-1200.34, -886.73, 14.01), id = -1842599357 }, { coords = vec3(-1190.81, -899.94, 14.0), id = 600967813 }, { coords = vec3(-1190.81, -899.94, 14.0), id = 1049934319 }, { coords = vec3(-1190.81, -899.94, 14.0), id = 443058963 },
				{ coords = vec3(-1190.81, -899.94, 14.0), id = 510552540 }, { coords = vec3(-1187.63, -898.52, 14.0), id = 510552540 }, { coords = vec3(-1184.18, -895.2, 14.0), id = 1948359883 }, { coords = vec3(-1184.18, -895.2, 14.0), id = 1388308576 },
				{ coords = vec3(-1200.69, -888.19, 14.0), id = 922914566 }, { coords = vec3(-1202.72, -888.3, 14.0), id = -1732499190 },
			}
			for i = 1, #ModelHide do CreateModelHide(ModelHide[i].coords, 1.5, tonumber(ModelHide[i].id), true)	Wait(10) end

			--ADD JOB RELATED PROPS
			propTable[#propTable+1] = { prop = "prop_food_bs_tray_02", coords = vec4(-1196.3, -890.7, 15.05, 305.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_tray_01", coords = vec4(-1195.0, -892.68, 15.05, 305.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.44, -896.36, 13.91+1.03, 300.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.44, -896.16, 13.91+1.03, 180.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.64, -896.06, 13.91+1.03, 250.0) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1184.53, -882.85, 13.94-0.22, 122.53) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1199.6, -884.99, 13.50-0.22, 215.0) }

		elseif loc.MLO == "NP" then
			CoordTables = {
				Fridge = { { coords = vec4(-1196.71, -901.79, 13.48, 304.0), minZ = 13.3, maxZ = 15.53, w = 1.6, d = 0.5, }, },
				Store = { { coords = vec4(-1205.01, -893.89, 13.48, 34.0), minZ = 12.97, maxZ = 15.37, w = 2.5, d = 0.6, }, },
				Shelf = { { coords = vec4(-1197.4, -894.58, 13.98, 34.0), minZ = 13.78, maxZ = 14.78, w = 1.5, d = 1.0, }, { coords = vec4(-1198.26, -893.33, 13.98, 34.0), minZ = 13.78, maxZ = 14.78, w = 1.6, d = 1.0, }, },
				Prepare = { { coords = vec4(-1199.62, -897.78, 13.48, 34.0), minZ = 13.3, maxZ = 14.38, w = 1.7, d = 0.6, }, },
				Chop = { { coords = vec4(-1198.33, -898.66, 13.48, 304.0), minZ = 13.3, maxZ = 14.5, w = 1.8, d = 0.6, }, },
				Grill = { { coords = vec4(-1202.8, -897.25, 13.48, 34.0), minZ = 13.3, maxZ = 14.5, w = 1.7, d = 0.7, }, },
				Fryer = { { coords = vec4(-1201.85, -898.62, 13.48, 34.0), minZ = 13.3, maxZ = 14.5, w = 1.7, d = 0.8, }, },
				Drink = { { coords = vec4(-1199.85, -895.35, 13.98, 34.0), minZ = 13.78, maxZ = 14.78, w = 2.35, d = 0.6, }, { coords = vec4(-1190.07, -904.51, 13.98, 35.0), minZ = 13.78, maxZ = 14.78, w = 1.40, d = 0.6, }, },
				Donut = { { coords = vec4(-1203.45, -895.67, 13.98, 34.0), minZ = 13.97, maxZ = 15.17, w = 1.5, d = 0.5, }, },
				Tray = {
					{ coords = vec4(-1195.88, -891.31, 13.7, 215.0), minZ = 14.0, maxZ = 15.35, w = 0.6, d = 1.0, }, { coords = vec4(-1194.99, -892.92, 13.7, 215.0), minZ = 14.0, maxZ = 15.35, w = 0.6, d = 1.1, },
					{ coords = vec4(-1193.88, -894.37, 13.7, 215.0), minZ = 14.0, maxZ = 15.35, w = 0.6, d = 1.0, },
				},
				Till = {
					{ coords = vec4(-1194.23, -893.87, 13.98, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.354, d = 1.0, }, { coords = vec4(-1195.28, -892.35, 13.98, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.35, d = 1.0, },
					{ coords = vec4(-1196.29, -890.82, 13.98, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.55, d = 1.0, }, { coords = vec4(-1192.74, -906.44, 13.98, 324.0), minZ = 13.98, maxZ = 14.58, w = 0.55, d = 1.0, },
				},
				BBag = { { coords = vec4(-1197.78, -891.46, 13.98, 304.0), minZ = 13.38, maxZ = 14.38, w = 2.1, d = 0.7, }, { coords = vec4(-1196.19, -905.02, 13.98, 34.0), minZ = 13.18, maxZ = 14.78, w = 2.5, d = 0.7, }, },
				HandWash = {
					{ coords = vec4(-1199.41, -886.27, 13.48, 305.0), minZ = 13.18, maxZ = 14.38, w = 0.9, d = 0.6, }, { coords = vec4(-1201.92, -887.98, 13.48, 305.0), minZ = 13.18, maxZ = 14.38, w = 0.9, d = 0.6, },
					{ coords = vec4(-1200.24, -901.13, 13.48, 304.0), minZ = 13.18, maxZ = 14.38, w = 0.9, d = 0.6, }, { coords = vec4(-1191.73, -901.48, 13.48, 34.0), minZ = 13.18, maxZ = 14.38, w = 0.9, d = 0.6, },
					{ coords = vec4(-1181.53, -899.43, 13.48, 34.0), minZ = 13.18, maxZ = 14.38, w = 0.9, d = 0.6, },
				},
				Toilets = { { coords = vec4(-1203.09, -888.71, 12.98, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, { coords = vec4(-1200.58, -887.05, 12.98, 214.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.6, }, },
				Clockin = { { coords = vec4(-1191.52, -900.58, 13.98, 34.0), minZ = 14.18, maxZ = 15.38, w = 1.4, d = 0.2, }, { coords = vec4(-1178.11, -896.3, 13.98, 34.0), minZ = 13.78, maxZ = 14.58, w = 0.8, d = 0.5, }, },
			}
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1184.53, -882.85, 13.94-0.22, 122.53) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1199.6, -884.99, 13.50-0.22, 215.0) }

		elseif loc.MLO == "RZ" then
			CoordTables = {
				Fridge = { },
				Store = { { coords = vec4(-1203.45, -895.67, 12.98, 34.0), minZ = 12.89, maxZ = 15.49, w = 1.6, d = 0.75, },  },
				Shelf = { { coords = vec4(-1196.69, -895.51, 14.0, 34.0), minZ = 13.78, maxZ = 14.78, w = 1.5, d = 1.3, },  { coords = vec4(-1198.53, -893.04, 14.0, 34.0), minZ = 13.78, maxZ = 14.78, w = 1.5, d = 1.3, }, },
				Prepare = { { coords = vec4(-1198.21, -897.82, 13.5, 34.0), minZ = 13.78, maxZ = 14.38, w = 1.8, d = 0.6, },  },
				Chop = { { coords = vec4(-1197.6, -899.36, 13.5, 304.0), minZ = 13.3, maxZ = 14.5, w = 1.8, d = 0.6, },  },
				Grill = { { coords = vec4(-1202.8, -897.25, 12.98, 34.0), minZ = 13.3, maxZ = 14.5, w = 1.7, d = 0.7, },  },
				Fryer = { { coords = vec4(-1201.64, -899.09, 13.0, 34.0), minZ = 13.3, maxZ = 14.5, w = 2.2, d = 0.8, }, },
				Drink = {  { coords = vec4(-1199.51, -895.58, 14.0, 34.0), minZ = 13.78, maxZ = 14.78, w = 2.35, d = 0.6, }, { coords = vec4(-1189.11, -905.25, 14.0, 35.0), minZ = 13.78, maxZ = 14.78, w = 1.40, d = 0.6, }, },
				Donut = { { coords = vec4(-1199.82, -902.03, 13.5, 34.0), minZ = 13.97, maxZ = 15.17, w = 1.0, d = 0.5, }, },
				Tray = { { coords = vec4(-1195.40, -892.22, 14.0, 215.0), minZ = 14.0, maxZ = 15.35, w = 0.6, d = 0.6, }, { coords = vec4(-1194.07, -894.18, 14.0, 215.0), minZ = 14.0, maxZ = 15.35, w = 0.6, d = 0.6, }, },
				Till = {
					{ coords = vec4(-1193.38, -895.19, 13.5, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.6, d = 0.6, }, { coords = vec4(-1194.67, -893.29, 13.5, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.6, d = 0.6, },
					{ coords = vec4(-1196.03, -891.30, 13.5, 35.0), minZ = 13.98, maxZ = 14.58, w = 0.6, d = 0.6, }, { coords = vec4(-1192.52, -906.67, 13.5, 350.0), minZ = 13.98, maxZ = 14.58, w = 0.6, d = 0.6, },
				},
				BBag = { { coords = vec4(-1197.56, -894.27, 14.0, 34.0), minZ = 13.78, maxZ = 14.78, w = 1.5, d = 1.3, }, { coords = vec4(-1188.71, -897.78, 13.8, 34.0), minZ = 13.13, maxZ = 14.78, w = 2.5, d = 0.7, }, },
				HandWash = { { coords = vec4(-1197.04, -902.23, 13.0, 216.5), minZ = 13.18, maxZ = 14.38, w = 0.6, d = 0.6, }, },
				Toilets = {	},
				Clockin = { { coords = vec4(-1196.8, -902.89, 14.0, 304.0), minZ = 14.18, maxZ = 15.38, w = 1.4, d = 0.2, }, { coords = vec4(-1191.97, -901.06, 14.0, 34.0), minZ = 13.78, maxZ = 14.58, w = 0.8, d = 0.5, }, },

			}
			propTable[#propTable+1] = { prop = "v_ret_247_donuts", coords = vec4(-1199.82, -902.03, 14.0, 120) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1184.53, -882.85, 13.94-0.22, 122.53) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1199.6, -884.99, 13.50-0.22, 215.0) }

			--Targets
			--Tables
			for a, x in pairs({
				vec3(-1190.89, -891.97, 14.0), vec3(-1193.43, -888.21, 14.0), vec3(-1194.16, -883.59, 14.0), vec3(-1191.75, -881.86, 14.0),
				vec3(-1189.08, -880.75, 14.0), vec3(-1187.23, -882.49, 14.0), vec3(-1187.05, -889.39, 14.0), vec3(-1183.29, -888.22, 14.0),
				vec3(-1182.18, -890.69, 14.0), vec3(-1184.38, -892.82, 14.0), vec3(-1186.87, -894.56, 14.0), vec3(-1189.55, -885.68, 14.0),
				vec3(-1191.73, -886.58, 14.0), vec3(-1188.62, -891.31, 14.0), }) do
				Targets["RZTables"..a] =
				exports ['qb-target']:AddBoxZone("RZTables"..a, vec3(x.x,x.y,x.z-1), 0.6, 0.6,
				{ name = "RZTables"..a, heading = 35, debugPoly = Config.Debug, minZ = x.z-1, maxZ = x.z+0.5, },
				{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].targetinfo["open_table"], id = "BS_Table"..a, coords = loc.xyz,},}, distance = 2.0})
			end

		elseif loc.MLO == "GABZ" then
			CoordTables = {
				Fridge = { { coords = vec4(-1183.45, -900.56, 13.3, 35.0), minZ = 13.0, maxZ = 15.0, w = 0.5, d = 2.5, }, },
				Store = { { coords = vec4(-1192.23, -898.29, 13.8, 213.65), minZ = 12.97, maxZ = 15.37, w = 2.0, d = 0.5, }, },
				Shelf = { { coords = vec4(-1187.66, -897.04, 13.8, 35.0), minZ = 12.89, maxZ = 14.69, w = 1.0, d = 1.4, }, { coords = vec4(-1191.25, -903.9, 13.8, 35.0), minZ = 12.89, maxZ = 15.3, w = 1.5, d = 1.0, },} ,
				Prepare = {	{ coords = vec4(-1186.14, -899.46, 13.3, 124.0), minZ = 13.3, maxZ = 14.4, w = 1.0, d = 1.7, }, },
				Chop = { { coords = vec4(-1188.19, -900.86, 13.3, 124.0), minZ = 13.3, maxZ = 14.4, w = 1.0, d = 1.7, }, },
				Grill = { { coords = vec4(-1186.85, -900.56, 13.3, 34.0), minZ = 13.3, maxZ = 14.4, w = 1.0, d = 1.5, }, },
				Fryer = { { coords = vec4(-1187.41, -899.73, 13.3, 34.0), minZ = 13.3, maxZ = 14.4, w = 1.0, d = 1.5, }, },
				Drink = { { coords = vec4(-1191.45, -897.99, 13.8, 35.0), minZ = 13.97, maxZ = 14.97, w = 2.0, d = 0.6, }, { coords = vec4(-1191.26, -905.48, 13.8, 35.0), minZ = 13.97, maxZ = 14.97, w = 1.0, d = 1.5, }, },
				Donut = { { coords = vec4(-1189.76, -898.28, 13.8, 35.0), minZ = 12.97, maxZ = 14.00, w = 0.8, d = 0.9, }, },
				Tray = {
					{ coords = vec4(-1191.39, -896.16, 13.3, 304.0), minZ = 13.45, maxZ = 14.45, w = 1.0, d = 0.6, }, { coords = vec4(-1189.79, -895.0, 13.3, 304.0), minZ = 13.45, maxZ = 14.45, w = 1.0, d = 0.6, },
					{ coords = vec4(-1188.26, -894.13, 13.3, 304.0), minZ = 13.45, maxZ = 14.45, w = 1.0, d = 0.6, }, { coords = vec4(-1193.94, -905.5, 13.6, 79.0), minZ = 13.3, maxZ = 14.5, w = 1.0, d = 0.6, },
				},
				Till = {
					{ coords = vec4(-1194.77, -905.16, 13.8, 350.0), minZ = 13.45, maxZ = 14.45, w = 0.5, d = 0.5, }, { coords = vec4(-1190.58, -895.65, 13.8, 304.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.5, },
					{ coords = vec4(-1189.08, -894.63, 13.8, 304.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.5, }, { coords = vec4(-1187.61, -893.6, 13.8, 304.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.5, },
				},
				BBag = { { coords = vec4(-1188.71, -897.78, 13.8, 305.0), minZ = 13.97, maxZ = 14.57, w = 0.9, d = 0.5, }, },
				HandWash = {
					{ coords = vec4(-1200.2, -889.54, 13.3, 34.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, }, { coords = vec4(-1202.13, -895.92, 13.3, 34.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, },
					{ coords = vec4(-1202.87, -896.44, 13.3, 34.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, }, { coords = vec4(-1186.55, -903.01, 13.3, 34.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, },
					{ coords = vec4(-1184.02, -896.65, 13.3, 34.0), minZ = 13.3, maxZ = 14.5, w = 0.6, d = 0.6, },
				},
				Toilets = {
					{ coords = vec4(-1204.61, -895.51, 12.8, 34.0), minZ = 12.8, maxZ = 14.6, w = 0.6, d = 0.6, urinal = true }, { coords = vec4(-1205.17, -894.67, 12.8, 34.0), minZ = 12.8, maxZ = 14.6, w = 0.6, d = 0.6, urinal = true },
					{ coords = vec4(-1206.91, -891.02, 12.8, 214.0), minZ = 12.8, maxZ = 14.6, w = 0.6, d = 0.6, urinal = false }, { coords = vec4(-1205.58, -890.12, 12.8, 214.0), minZ = 12.8, maxZ = 14.6, w = 0.6, d = 0.6, urinal = false },
					{ coords = vec4(-1203.82, -888.88, 12.8, 214.0), minZ = 12.8, maxZ = 14.6, w = 0.6, d = 0.6, urinal = false },
				},
				Clockin = { { coords = vec4(-1177.79, -897.49, 13.8, 214.0), minZ = 13.67, maxZ = 14.77, w = 0.3, d = 1.3, }, { coords = vec4(-1198.54, -898.53, 13.2, 124.0), minZ = 12.6, maxZ = 14.4, w = 0.8, d = 1.7, }, },
			}
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1188.77, -897.9, 14.9, 31.58) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1188.97, -898.05, 14.9, 339.99) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1184.53, -882.85, 13.94-0.22, 122.53) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1199.6, -884.99, 13.50-0.22, 215.0) }

		elseif loc.MLO == "UNIQX" then
			CoordTables = {
				Fridge = { { coords = vec4(-1195.48, -902.45, 12.89, 124.0), minZ = 12.89, maxZ = 15.49, w = 2.6, d = 0.55, }, },
				Store = { { coords = vec4(-1196.33, -900.89, 12.89, 75.0), minZ = 12.89, maxZ = 15.49, w = 2.6, d = 0.75, }, },
				Shelf = { { coords = vec4(-1195.14, -896.51, 12.89, 254.0), minZ = 12.89, maxZ = 14.69, w = 3.2, d = 1.15, }, },
				Prepare = { { coords = vec4(-1196.99, -897.0, 12.89, 254.0), minZ = 12.89, maxZ = 14.69, w = 1.7, d = 0.7, }, },
				Chop = { { coords = vec4(-1193.8, -897.9, 12.89, 254.0), minZ = 12.89, maxZ = 14.69, w = 1.7, d = 0.7, }, },
				Grill = { { coords = vec4(-1195.71, -897.18, 12.89, 255.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.5, }, { coords = vec4(-1194.95, -897.37, 12.89, 255.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.5, }, },
				Fryer = {
					{ coords = vec4(-1195.27, -900.19, 12.89, 255.0), minZ = 12.89, maxZ = 15.09, w = 0.85, d = 0.8, }, { coords = vec4(-1196.11, -899.96, 12.89, 255.0), minZ = 12.89, maxZ = 15.09, w = 0.85, d = 0.8, },
					{ coords = vec4(-1196.93, -899.79, 12.89, 255.0), minZ = 12.89, maxZ = 15.09, w = 0.85, d = 0.8, },
				},
				Drink = { { coords = vec4(-1190.39, -898.59, 13.89, 305.0), minZ = 13.45, maxZ = 14.5, w = 1.2, d = 0.6, }, { coords = vec4(-1191.4, -899.28, 13.89, 305.0), minZ = 13.45, maxZ = 14.5, w = 1.2, d = 0.6, }, },
				Donut = { { coords = vec4(-1202.99, -897.76, 12.89, 214.0), minZ = 12.89, maxZ = 15.49, w = 1.6, d = 0.95, }, { coords = vec4(-1203.89, -896.43, 12.89, 214.0), minZ = 12.89, maxZ = 15.49, w = 1.6, d = 0.95, }, },
				Tray = {
					{ coords = vec4(-1196.84, -892.73, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.6, d = 0.6, }, { coords = vec4(-1194.8, -893.31, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.6, d = 0.6, },
					{ coords = vec4(-1192.83, -893.83, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.6, d = 0.6, }, { coords = vec4(-1190.87, -894.3, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.6, d = 0.6, },
				},
				Till = {
					{ coords = vec4(-1197.46, -892.49, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.6, }, { coords = vec4(-1195.46, -893.09, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.6, },
					{ coords = vec4(-1193.44, -893.66, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.6, }, { coords = vec4(-1191.53, -894.18, 13.89, 345.0), minZ = 13.8, maxZ = 14.5, w = 0.5, d = 0.6, },
				},
				BBag = {
					{ coords = vec4(-1200.75, -895.08, 12.89, 124.0), minZ = 12.89, maxZ = 14.69, w = 0.8, d = 0.8, },
				},
				HandWash = { { coords = vec4(-1201.19, -890.91, 12.89, 124.0), minZ = 12.89, maxZ = 14.69, w = 0.8, d = 0.5, }, { coords = vec4(-1205.18, -893.61, 12.89, 124.0), minZ = 12.89, maxZ = 14.69, w = 0.8, d = 0.5, }, },
				Toilets = { { coords = vec4(-1204.23, -894.99, 12.89, 34.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.5, }, { coords = vec4(-1200.24, -892.3, 12.89, 34.0), minZ = 12.89, maxZ = 14.69, w = 0.6, d = 0.5, }, },
				Clockin = {},
			}
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.44, -895.26, 13.91+1.03, 300.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.75, -895.08, 13.89+1.03, 180.0) }
			propTable[#propTable+1] = { prop = "prop_food_bs_bag_04", coords = vec4(-1200.64, -894.96, 13.91+1.03, 250.0) }

			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vector4(-1189.68, -894.22, 13.89, 164.0) }
			propTable[#propTable+1] = { prop = "prop_atm_01", coords = vec4(-1204.82, -889.15, 13.50-0.22, 215.0) } vector4(-1204.82, -889.15, 13.83, 33.62)
		end

		if countTable(CoordTables) ~= 0 then
			--[[Fridge]]
				for i = 1, #CoordTables.Fridge do local Curr = CoordTables.Fridge[i] local tName = "BSFridge"..i local debug = ""
					if Config.Debug then debug = " [".."BSFridge"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_fridge"]..debug,
										job = Config.Locations[1].job, id = tname, coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Stores]]--
				for i = 1, #CoordTables.Store do local Curr = CoordTables.Store[i] local tName = "BSStore"..i local debug = ""
					if Config.Debug then debug = " [".."BSStore"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Shop", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_storage"]..debug,
										job = Config.Locations[1].job, id = "BSShop", shop = Config.Items, coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end

			--[[Shelf]]--
				for i = 1, #CoordTables.Shelf do local Curr = CoordTables.Shelf[i] local tName = "BSShelf"..i local debug = ""
					if Config.Debug then debug = " [".."BSShelf"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].targetinfo["open_shelves"]..debug,
										job = Config.Locations[1].job, id = "BSShelf", coords = Curr.coords.xyz }, },
											distance = 2.0 })
				end
			--[[Prepare]]--
				for i = 1, #CoordTables.Prepare do local Curr = CoordTables.Prepare[i] local tName = "BSPrepare"..i local debug = ""
					if Config.Debug then debug = " [".."BSPrepare"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["prepare_food"]..debug,
										job = Config.Locations[1].job, craftable = Crafting.Prepare, header = Loc[Config.Lan].menu["prepare_food"], coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Chopping Boards]]--
				for i = 1, #CoordTables.Chop do local Curr = CoordTables.Chop[i] local tName = "BSChop"..i local debug = ""
					if Config.Debug then debug = " [".."BSChop"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-utensils", label = Loc[Config.Lan].targetinfo["use_chopping_board"]..debug,
										job = Config.Locations[1].job, craftable = Crafting.ChopBoard, header = Loc[Config.Lan].menu["chopping_board"], coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Grills]]--
				for i = 1, #CoordTables.Grill do local Curr = CoordTables.Grill[i] local tName = "BSGrill"..i local debug = ""
					if Config.Debug then debug = " [".."BSGrill"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-fire", label = Loc[Config.Lan].targetinfo["use_grill"]..debug,
										job = Config.Locations[1].job, craftable = Crafting.Grill, header = Loc[Config.Lan].menu["grill"], coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Fryer]]--
				for i = 1, #CoordTables.Fryer do local Curr = CoordTables.Fryer[i] local tName = "BSFryer"..i local debug = ""
					if Config.Debug then debug = " [".."BSFryer"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].targetinfo["use_deepfryer"]..debug,
										job = Config.Locations[1].job, craftable = Crafting.Fryer, header = Loc[Config.Lan].menu["deep_fat_fryer"], coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Drinks]]--
				for i = 1, #CoordTables.Drink do local Curr = CoordTables.Drink[i] local tName = "BSDrink"..i local debug = ""
					if Config.Debug then debug = " [".."BSDrink"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-mug-hot", label = Loc[Config.Lan].targetinfo["prepare_drinks"]..debug,
										job = Config.Locations[1].job, craftable = Crafting.Drink, header = Loc[Config.Lan].menu["drinks_dispenser"], coords = Curr.coords.xyz }, },
											distance = 1.5 })
				end
			--[[Donut]]--
				for i = 1, #CoordTables.Donut do local Curr = CoordTables.Donut[i] local tName = "BSDonut"..i local debug = ""
					if Config.Debug then debug = " [".."BSDonut"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-dot-circle", label = Loc[Config.Lan].targetinfo["open_cabinet"]..debug,
						job = Config.Locations[1].job, craftable = Crafting.Donut, header = Loc[Config.Lan].menu["food_cabinet"], coords = Curr.coords.xyz }, },
					distance = 1.5 })
				end
			--[[Trays]]--
				for i = 1, #CoordTables.Tray do local Curr = CoordTables.Tray[i] local tName = "BSTray"..i local debug = ""
					if Config.Debug then debug = " [".."BSTray"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
					exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"]..debug, id = tName }, },
							distance = 2.0 })
				end
			--[[Cash Registers]]--
				for i = 1, #CoordTables.Till do local Curr = CoordTables.Till[i] local tName = "BSReceipt"..i local debug = ""
					if Config.Debug then debug = " [".."BSReceipt"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
						exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
						{ options = {
							{ event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"]..debug, job = Config.Locations[1].job, img = "<center><p><img src="..Config.Logo.." width=225px></p>" },
								{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = Config.Locations[1].job },
								{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles, }, },
							distance = 1.5 })
				end
			--[[Hand Wash]]--
				for i = 1, #CoordTables.HandWash do local Curr = CoordTables.HandWash[i] local tName = "BSWash"..i local debug = ""
					if Config.Debug then debug = " [".."BSWash"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
						exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
							{ options = { { event = "jim-burgershot:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].targetinfo["wash_hands"]..debug, }, },
								distance = 1.2 })
				end
			--[[Toilets]]--
				for i = 1, #CoordTables.Toilets do local Curr = CoordTables.Toilets[i] local tName = "BSToilet"..i local debug = ""
					if Config.Debug then debug = " [".."BSToilet"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
						exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
							{ options = { { event = "jim-burgershot:useToilet", icon = "fas fa-toilet", label = Loc[Config.Lan].targetinfo["toilet"]..debug, sitcoords = vec4(Curr.coords.x, Curr.coords.y, Curr.coords.z+0.5, Curr.coords.w), urinal = Curr.urinal }, },
								distance = 1.2 })
				end
			--[[BBag]]--
				for i = 1, #CoordTables.BBag do local Curr = CoordTables.BBag[i] local tName = "BBag"..i local debug = ""
					if Config.Debug then debug = " [".."BBag"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
						exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
							{ options = { { event = "jim-burgershot:client:GrabBag", icon = "fas fa-bag-shopping", label = Loc[Config.Lan].targetinfo["grab_murderbag"]..debug,
											job = Config.Locations[1].job, }, },
												distance = 2.0 })
				end
			--[[Clockin]]--
				for i = 1, #CoordTables.Clockin do local Curr = CoordTables.Clockin[i] local tName = "BSClockin"..i local debug = ""
					if Config.Debug then debug = " [".."BSClockin"..i.."]"
						print("^5Debug^7: ^1Target ^2Created^7: '^6"..tName.."^7' | ^2Coord^7: ^5vec4^7(^6"..(Curr.coords[1]).."^7, ^6"..(Curr.coords[2]).."^7, ^6"..(Curr.coords[3]).."^7, ^6"..(Curr.coords[4]).."^7)")
					end
					Targets[tName] =
						exports['qb-target']:AddBoxZone(tName, Curr.coords.xyz, Curr.w, Curr.d, { name=tName, heading = Curr.coords.w, debugPoly=Config.Debug, minZ = Curr.minZ, maxZ = Curr.maxZ, },
							{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"]..debug, job = Config.Locations[1].job },
										  { event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles, },
											}, distance = 2.0 })
				end
		end
	end

	propTable[#propTable+1] = { prop = "prop_bench_01a", coords = vec4(-1195.53, -878.53, 13.5, 212.0) }

	if Config.Locations[2].zoneEnable then	-- [[ GNMODS MIRROR PARK ]] --
		local loc = Config.Locations[2]
		local bossroles = {}
		for grade in pairs(QBCore.Shared.Jobs[loc.job].grades) do
			if QBCore.Shared.Jobs[loc.job].grades[grade].isboss == true then
				if bossroles[loc.job] then
					if bossroles[loc.job] > tonumber(grade) then bossroles[loc.job] = tonumber(grade) end
				else bossroles[loc.job] = tonumber(grade) end
			end
		end
		if loc.blip then Blips[#Blips+1] = makeBlip({coords = loc.blip, sprite = loc.blipsprite or 106, col = loc.blipcolor, scale = loc.blipscale, disp = loc.blipdisp, category = nil, name = loc.label}) end

		if loc.zones then
			JobLocation = PolyZone:Create(loc.zones, { name = loc.label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside)
				if PlayerJob.name == loc.job then
					if loc.autoClock and loc.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
					if loc.autoClock and loc.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				end
			end)
		end
		--Stash/Shops
		Targets["BSMShelf"] =
		exports['qb-target']:AddBoxZone("BSMShelf", vec3(1248.35, -354.0, 68.21), 3.0, 1.0, { name="BSMShelf", heading = 75.0, debugPoly=Config.Debug, minZ = 68.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].targetinfo["open_shelves"], job = loc.job, id = "BSMShelf", coords = vec3(1248.35, -354.0, 68.21) }, },
				distance = 2.0 })
		Targets["BSMFridge"] =
		exports['qb-target']:AddBoxZone("BSMFridge", vec3(1254.09, -346.85, 68.21), 2.9, 0.7, { name="BSMFridge", heading = 75.0, debugPoly=Config.Debug, minZ = 68.21, maxZ = 70.41 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_fridge"], job = loc.job, id = "BSMFridge", coords = vec3(1254.09, -346.85, 68.21) }, },
				distance = 1.5 })

		Targets["BSMShop"] =
		exports['qb-target']:AddBoxZone("BSMShop", vec3(1255.54, -348.84, 68.21), 2.9, 0.7, { name="BSMShop", heading = 345.0, debugPoly=Config.Debug, minZ = 68.21, maxZ = 70.41 },
			{ options = { { event = "jim-burgershot:Shop", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_storage"], job = loc.job, id = "BSMShop", shop = Config.Items, coords = vec3(1255.54, -348.84, 68.21) }, },
				distance = 1.5 })

		Targets["BSMBag"] =
		exports['qb-target']:AddBoxZone("BSMBag", vec3(1251.9, -358.86, 69.01), 1.0, 0.5, { name="BSMBag", heading = 75.0, debugPoly=Config.Debug, minZ=69.01, maxZ=70.01 },
			{ options = { { event = "jim-burgershot:client:GrabBag", icon = "fas fa-bag-shopping", label = Loc[Config.Lan].targetinfo["grab_murderbag"], job = loc.job, }, },
				distance = 2.0 })

		--Food Making
		Targets["BSMGrill"] =
		exports['qb-target']:AddBoxZone("BSMGrill", vec3(1253.42, -355.18, 68.21), 1.6, 0.6, { name="BSMGrill", heading = 345.0, debugPoly=Config.Debug, minZ = 68.21, maxZ = 69.41, },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-fire", label = Loc[Config.Lan].targetinfo["use_grill"], job = loc.job, craftable = Crafting.Grill, header = Loc[Config.Lan].menu["grill"], coords = vec3(1253.42, -355.18, 68.21) }, },
				distance = 1.5 })
		Targets["BSMFryer"] =
		exports['qb-target']:AddBoxZone("BSMFryer", vec3(1254.32, -352.18, 68.21), 1.6, 0.6, { name="BSMFryer", heading = 345.0, debugPoly=Config.Debug, minZ = 68.21, maxZ = 69.41 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].targetinfo["use_deepfryer"], job = loc.job, craftable = Crafting.Fryer, header = Loc[Config.Lan].menu["deep_fat_fryer"], coords = vec3(1254.32, -352.18, 68.21) }, },
				distance = 1.5 })
		Targets["BSMChop"] =
		exports['qb-target']:AddBoxZone("BSMChop", vec3(1249.57, -352.28, 68.21), 0.6, 2.9, { name="BSMChop", heading = 75.0, debugPoly=Config.Debug, minZ = 68.41, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-utensils", label = Loc[Config.Lan].targetinfo["use_chopping_board"], job = loc.job, craftable = Crafting.ChopBoard, header = Loc[Config.Lan].menu["chopping_board"], coords = vec3(1249.57, -352.28, 68.21) }, },
				distance = 1.5 })
		Targets["BSMPrepare"] =
		exports['qb-target']:AddBoxZone("BSMPrepare", vec3(1248.1, -351.95, 68.21), 0.6, 2.9, { name="BSMPrepare", heading = 75.0, debugPoly=Config.Debug, minZ = 68.41, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["prepare_food"], job = loc.job, craftable = Crafting.Prepare, header = Loc[Config.Lan].menu["prepare_food"], coords = vec3(1248.1, -351.95, 68.21) }, },
				distance = 1.5 })
		Targets["BSMDrink"] =
		exports['qb-target']:AddBoxZone("BSMDrink", vec3(1244.77, -353.21, 69.21), 0.6, 0.9, { name="BSMDrink", heading = 345.0, debugPoly=Config.Debug, minZ = 69.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-mug-hot", label = Loc[Config.Lan].targetinfo["prepare_drinks"], job = loc.job, craftable = Crafting.Drink, header = Loc[Config.Lan].menu["drinks_dispenser"], coords = vec3(1244.77, -353.21, 69.21) }, },
				distance = 1.5 })
		Targets["BSMDonut"] =
		exports['qb-target']:AddBoxZone("BSMDonut", vec3(1245.5, -353.42, 69.21), 0.6, 0.6, { name="BSMDonut", heading = 345.0, debugPoly=Config.Debug, minZ = 69.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-dot-circle", label = Loc[Config.Lan].targetinfo["open_cabinet"], job = loc.job, craftable = Crafting.Donut, header = Loc[Config.Lan].menu["food_cabinet"], coords = vec3(1245.5, -353.42, 69.21) }, },
				distance = 1.5 })

		--Trays
		Targets["BSMTray1"] =
		exports['qb-target']:AddBoxZone("BSMTray1", vec3(1248.07, -356.25, 69.21), 0.6, 1.0, { name="BSMTray1", heading = 75.0, debugPoly=Config.Debug, minZ = 69.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSMTray1" }, },
				distance = 2.0 })
		Targets["BSMTray2"] =
		exports['qb-target']:AddBoxZone("BSMTray2", vec3(1246.12, -355.72, 69.21), 0.6, 1.0, { name="BSMTray2", heading = 75.0, debugPoly=Config.Debug, minZ = 69.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSMTray2" }, },
				distance = 2.0 })
		Targets["BSMTray3"] =
		exports['qb-target']:AddBoxZone("BSMTray3", vec3(1244.31, -355.22, 69.21), 0.6, 1.0, { name="BSMTray3", heading = 75.0, debugPoly=Config.Debug, minZ = 69.21, maxZ = 70.01 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSMTray3" }, },
				distance = 2.0 })

		--Hand Washing
		Targets["BSMWash1"] =
		exports['qb-target']:AddBoxZone("BSMWash1", vec3(1239.16, -353.85, 68.2), 0.7, 0.7, { name="BSMWash1", heading = 345.0, debugPoly=Config.Debug,minZ=68.2, maxZ=69.41 },
			{ options = { { event = "jim-burgershot:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].targetinfo["wash_hands"], }, },
				distance = 2.0 })
		Targets["BSMWash2"] =
		exports['qb-target']:AddBoxZone("BSMWash2", vec3(1245.36, -352.29, 68.2), 1.2, 0.7, { name="BSMWash2", heading = 75.0, debugPoly=Config.Debug, minZ=68.2, maxZ=69.41 },
			{ options = { { event = "jim-burgershot:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].targetinfo["wash_hands"], }, },
				distance = 2.0 })

		--Payments / Clockin
		Targets["BSMReceipt"] =
			exports['qb-target']:AddBoxZone("BSMReceipt", vec3(1248.83, -356.41, 69.21), 0.6, 0.6, { name="BSMReceipt", heading = 345.0, debugPoly=Config.Debug, minZ = 69.26, maxZ = 70.01, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })
		Targets["BSMReceipt2"] =
			exports['qb-target']:AddBoxZone("BSMReceipt2", vec3(1246.82, -355.88, 69.21), 0.6, 0.6, { name="BSMReceipt2", heading = 345.0, debugPoly=Config.Debug, minZ = 69.26, maxZ = 70.01, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })
		Targets["BSMReceipt3"] =
			exports['qb-target']:AddBoxZone("BSMReceipt3", vec3(1245.08, -355.42, 69.21), 0.6, 0.6, { name="BSMReceipt3", heading = 345.0, debugPoly=Config.Debug, minZ = 69.26, maxZ = 70.01, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })

		Targets["BSMClockin"] =
		exports['qb-target']:AddBoxZone("BSMClockin", vec3(1249.85, -346.16, 68.71), 0.6, 0.6, { name="BSMClockin", heading = 345.0, debugPoly=Config.Debug, minZ = 69.26, maxZ = 70.01, },
				{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
							{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles, },
							}, distance = 2.0 })
	end

	if Config.Locations[3].zoneEnable then -- [[ GNMODS SANDY SHORES ]] --
		local loc = Config.Locations[3]
		local bossroles = {}
		for grade in pairs(QBCore.Shared.Jobs[loc.job].grades) do
			if QBCore.Shared.Jobs[loc.job].grades[grade].isboss == true then
				if bossroles[loc.job] then
					if bossroles[loc.job] > tonumber(grade) then bossroles[loc.job] = tonumber(grade) end
				else bossroles[loc.job] = tonumber(grade) end
			end
		end
		if loc.blip then Blips[#Blips+1] = makeBlip({coords = loc.blip, sprite = loc.blipsprite or 106, col = loc.blipcolor, scale = loc.blipscale, disp = loc.blipdisp, category = nil, name = loc.label}) end
		if loc.zones then
			JobLocation = PolyZone:Create(loc.zones, { name = loc.label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside)
				if PlayerJob.name == loc.job then
					if loc.autoClock and loc.autoClock.enter then if isPointInside and not onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
					if loc.autoClock and loc.autoClock.exit then if not isPointInside and onDuty then TriggerServerEvent("QBCore:ToggleDuty") end end
				end
			end)
		end
		--Stash/Shops
		Targets["BSSShelf"] =
		exports['qb-target']:AddBoxZone("BSSShelf", vec3(1591.7, 3752.59, 34.43-1), 3.0, 1.0, { name="BSSShelf", heading = 35.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].targetinfo["open_shelves"], job = loc.job, id = "BSSShelf", coords = vec3(1591.7, 3752.59, 34.43) }, },
				distance = 2.0 })
		Targets["BSSFridge"] =
		exports['qb-target']:AddBoxZone("BSSFridge", vec3(1600.67, 3754.59, 34.44-1), 2.9, 0.7, { name="BSSFridge", heading = 35.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_fridge"], job = loc.job, id = "BSSFridge", coords = vec3(1600.67, 3754.59, 34.44) }, },
				distance = 1.5 })

		Targets["BSSShop"] =
		exports['qb-target']:AddBoxZone("BSSShop", vec3(1600.46, 3752.17, 34.44-1), 2.9, 0.7, { name="BSSShop", heading = 306.0, debugPoly=Config.Debug, minZ = 33.63, maxZ = 35.43 },
			{ options = { { event = "jim-burgershot:Shop", icon = "fas fa-temperature-low", label = Loc[Config.Lan].targetinfo["open_storage"], job = loc.job, id = "BSSShop", shop = Config.Items, coords = vec3(1600.46, 3752.17, 34.44) }, },
				distance = 1.5 })

		Targets["BSSBag"] =
		exports['qb-target']:AddBoxZone("BSSBag", vec3(1591.43, 3746.62, 34.43-0.4), 1.0, 0.5, { name="BSSBag", heading = 36.0, debugPoly=Config.Debug, minZ = 34.03, maxZ = 35.03 },
			{ options = { { event = "jim-burgershot:client:GrabBag", icon = "fas fa-bag-shopping", label = Loc[Config.Lan].targetinfo["grab_murderbag"], job = loc.job, }, },
				distance = 2.0 })

		--Food Making
		Targets["BSSGrill"] =
		exports['qb-target']:AddBoxZone("BSSGrill", vec3(1594.89, 3748.51, 34.43-1), 1.6, 0.6, { name="BSSGrill", heading = 306.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43, },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-fire", label = Loc[Config.Lan].targetinfo["use_grill"], job = loc.job, craftable = Crafting.Grill, header = Loc[Config.Lan].menu["grill"], coords = vec3(1594.89, 3748.51, 34.43) }, },
				distance = 1.5 })
		Targets["BSSFryer"] =
		exports['qb-target']:AddBoxZone("BSSFryer", vec3(1597.46, 3750.25, 34.43-1), 1.6, 0.6, { name="BSSFryer", heading = 306.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-temperature-high", label = Loc[Config.Lan].targetinfo["use_deepfryer"], job = loc.job, craftable = Crafting.Fryer, header = Loc[Config.Lan].menu["deep_fat_fryer"], coords = vec3(1597.46, 3750.25, 34.43) }, },
				distance = 1.5 })
		Targets["BSSChop"] =
		exports['qb-target']:AddBoxZone("BSSChop", vec3(1593.61, 3753.22, 34.43-1), 0.6, 2.9, { name="BSSChop", heading = 36.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-utensils", label = Loc[Config.Lan].targetinfo["use_chopping_board"], job = loc.job, craftable = Crafting.ChopBoard, header = Loc[Config.Lan].menu["chopping_board"], coords = vec3(1593.61, 3753.22, 34.43) }, },
				distance = 1.5 })
		Targets["BSSPrepare"] =
		exports['qb-target']:AddBoxZone("BSSPrepare", vec3(1592.9, 3754.27, 34.44-1), 0.6, 2.9, { name="BSSPrepare", heading = 36.0, debugPoly=Config.Debug, minZ = 33.63, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["prepare_food"], job = loc.job, craftable = Crafting.Prepare, header = Loc[Config.Lan].menu["prepare_food"], coords = vec3(1592.9, 3754.27, 34.44) }, },
				distance = 1.5 })
		Targets["BSSDrink"] =
		exports['qb-target']:AddBoxZone("BSSDrink", vec3(1589.49, 3755.53, 34.43), 0.6, 0.9, { name="BSSDrink", heading = 306.0, debugPoly=Config.Debug, minZ = 34.43, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-mug-hot", label = Loc[Config.Lan].targetinfo["prepare_drinks"], job = loc.job, craftable = Crafting.Drink, header = Loc[Config.Lan].menu["drinks_dispenser"], coords = vec3(1589.49, 3755.53, 34.43) }, },
				distance = 1.5 })
		Targets["BSSDonut"] =
		exports['qb-target']:AddBoxZone("BSSDonut", vec3(1589.96, 3754.94, 34.43), 0.6, 0.7, { name="BSSDonut", heading = 36.0, debugPoly=Config.Debug, minZ = 34.43, maxZ= 35.43 },
			{ options = { { event = "jim-burgershot:Crafting", icon = "fas fa-dot-circle", label = Loc[Config.Lan].targetinfo["open_cabinet"], job = loc.job, craftable = Crafting.Donut, header = Loc[Config.Lan].menu["food_cabinet"], coords = vec3(1589.96, 3754.94, 34.43) }, },
				distance = 1.5 })

		--Trays
		Targets["BSSTray1"] =
		exports['qb-target']:AddBoxZone("BSSTray1", vec3(1590.05, 3751.01, 34.43), 0.6, 1.0, { name="BSSTray1", heading = 36.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSSTray1" }, },
				distance = 2.0 })
		Targets["BSSTray2"] =
		exports['qb-target']:AddBoxZone("BSSTray2", vec3(1588.92, 3752.63, 34.43), 0.6, 1.0, { name="BSSTray2", heading = 36.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSSTray2" }, },
				distance = 2.0 })
		Targets["BSSTray3"] =
		exports['qb-target']:AddBoxZone("BSSTray3", vec3(1587.69, 3754.16, 34.43), 0.6, 1.0, { name="BSSTray3", heading = 36.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23 },
			{ options = { { event = "jim-burgershot:Stash", icon = "fas fa-hamburger", label = Loc[Config.Lan].targetinfo["open_tray"], id = "BSSTray3" }, },
				distance = 2.0 })

		--Hand Washing
		Targets["BSSWash1"] =
		exports['qb-target']:AddBoxZone("BSSWash1", vec3(1584.68, 3758.56, 34.43-1), 0.7, 0.7, { name="BSSWash1", heading = 36.0, debugPoly=Config.Debug, minZ=33.63, maxZ=35.03 },
			{ options = { { event = "jim-burgershot:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].targetinfo["wash_hands"], }, },
				distance = 2.0 })
		Targets["BSSWash2"] =
		exports['qb-target']:AddBoxZone("BSSWash2", vec3(1590.42, 3755.76, 34.43-1), 1.2, 0.7, { name="BSSWash2", heading = 36.0, debugPoly=Config.Debug, minZ=33.63, maxZ=35.03 },
			{ options = { { event = "jim-burgershot:washHands", icon = "fas fa-hand-holding-water", label = Loc[Config.Lan].targetinfo["wash_hands"], }, },
				distance = 2.0 })

		--Payments / Clockin
		Targets["BSSReceipt"] =
			exports['qb-target']:AddBoxZone("BSSReceipt", vec3(1590.51, 3750.41, 34.43), 0.6, 0.6, { name="BSSReceipt", heading = 35.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })
		Targets["BSSReceipt2"] =
			exports['qb-target']:AddBoxZone("BSSReceipt2", vec3(1589.29, 3752.05, 34.43), 0.6, 0.6, { name="BSSReceipt2", heading = 35.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							--{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })
		Targets["BSSReceipt3"] =
			exports['qb-target']:AddBoxZone("BSSReceipt3", vec3(1588.23, 3753.52, 34.43), 0.6, 0.6, { name="BSSReceipt3", heading = 35.0, debugPoly=Config.Debug, minZ = 34.43, maxZ = 35.23, },
			{ options = { { event = "jim-payments:client:Charge", icon = "fas fa-credit-card", label = Loc[Config.Lan].targetinfo["charge_customer"], job = loc.job,
							img = "<center><p><img src=https://static.wikia.nocookie.net/gtawiki/images/b/bf/BurgerShot-HDLogo.svg width=225px></p>" },
							--{ type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
						},	distance = 1.5 })

		Targets["BSSClockin"] =
		exports['qb-target']:AddBoxZone("BSSClockin", vec3(1597.95, 3758.02, 34.44-0.5), 0.6, 0.6, { name="BSSClockin", heading = 50.0, debugPoly=Config.Debug, minZ = 33.84, maxZ = 35.04, },
				{ options = { { type = "server", event = "QBCore:ToggleDuty", icon = "fas fa-user-check", label = Loc[Config.Lan].targetinfo["toggle_duty"], job = loc.job },
							{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-list", label = Loc[Config.Lan].targetinfo["open_bossmenu"], job = bossroles, },
							}, distance = 2.0 })
	end
	for _, prop in pairs(propTable) do Props[#Props+1] = makeProp(prop, true, false) end
end)

RegisterNetEvent('jim-burgershot:washHands', function(data)
	if progressBar({ label = Loc[Config.Lan].progressbar["washing_hands"], time = 5000, cancel = true, dict = "mp_arresting", anim = "a_uncuff", flag = 8, icon = "fas fa-hand-holding-droplet" }) then
		triggerNotify(nil, Loc[Config.Lan].success["have_washed_hands"], 'success')
	else
		TriggerEvent('inventory:client:busy:status', false) triggerNotify(nil, Loc[Config.Lan].error["cancelled"], 'error')
	end
	ClearPedTasks(Ped)
end)

RegisterNetEvent('jim-burgershot:client:GrabBag', function(data)
	if progressBar({ label = Loc[Config.Lan].progressbar["grab_murder_bag"], time = 2000, cancel = true, dict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_b_idle", flag = 8}) then
		TriggerServerEvent("jim-burgershot:server:GrabBag")
	else
		TriggerEvent('inventory:client:busy:status', false) triggerNotify(nil, Loc[Config.Lan].error["cancelled"], 'error')
	end
	ClearPedTasks(Ped)
end)

--[[CRAFTING]]--
RegisterNetEvent('jim-burgershot:Crafting:MakeItem', function(data)
	if not CraftLock then CraftLock = true else return end
	print(data.header, Loc[Config.Lan].menu["drinks_dispenser"])
	if data.header == Loc[Config.Lan].menu["drinks_dispenser"] then
		bartext = Loc[Config.Lan].progress["pouring"]..QBCore.Shared.Items[data.item].label	bartime = 3500
		animDictNow = "mp_ped_interaction" animNow = "handshake_guy_a"
	elseif data.header == Loc[Config.Lan].menu["food_cabinet"] then
		bartext = Loc[Config.Lan].progress["receiving"]..QBCore.Shared.Items[data.item].label bartime = 3500
		animDictNow = "mp_ped_interaction" animNow = "handshake_guy_a"
	elseif data.item == "slicedpotato" or data.item == "slicedonion" then
		bartext = Loc[Config.Lan].progress["slicing"]..QBCore.Shared.Items[data.item].label bartime = 3000
		animDictNow = "anim@heists@prison_heiststation@cop_reactions" animNow = "cop_b_idle"
	elseif data.item == "cheesewrap" or data.item == "chickenwrap" then
		bartext = Loc[Config.Lan].progress["preparing"]..QBCore.Shared.Items[data.item].label bartime = 8000
		animDictNow = "anim@heists@prison_heiststation@cop_reactions" animNow = "cop_b_idle"
	elseif data.header == Loc[Config.Lan].targetinfo["use_deepfryer"] then
		bartext = Loc[Config.Lan].progress["frying"]..QBCore.Shared.Items[data.item].label bartime = 5000
		animDictNow = "amb@prop_human_bbq@male@base" animNow = "base"
	elseif data.header == Loc[Config.Lan].menu["grill"] then
		bartext = Loc[Config.Lan].progress["cooking"]..QBCore.Shared.Items[data.item].label bartime = 5000
        animDictNow = "amb@prop_human_bbq@male@base" animNow = "base"
	elseif data.header == Loc[Config.Lan].menu["prepare_food"] then
		bartext = Loc[Config.Lan].progress["preparing"]..QBCore.Shared.Items[data.item].label bartime = 12500
		animDictNow = "mini@repair" animNow = "fixing_a_ped"
	else
		bartext = Loc[Config.Lan].progress["preparing"]..QBCore.Shared.Items[data.item].label bartime = 12500
		animDictNow = "mini@repair"	animNow = "fixing_a_ped"
	end
	if (data.amount and data.amount ~= 1) then data.craft["amount"] = data.amount
		for k, v in pairs(data.craft[data.item]) do	data.craft[data.item][k] *= data.amount	end
		bartime *= data.amount bartime *= 0.9
	end
	if progressBar({ label = bartext, time = bartime, cancel = true, dict = animDictNow, anim = animNow, flag = 1, icon = data.item }) then
		CraftLock = false
		TriggerServerEvent('jim-burgershot:Crafting:GetItem', data.item, data.craft)
		Wait(500)
		TriggerEvent("jim-burgershot:Crafting", data)
	else
		CraftLock = false
		TriggerEvent('inventory:client:busy:status', false)
	end
	ClearPedTasks(Ped)
end)

RegisterNetEvent('jim-burgershot:Crafting', function(data)
	if CraftLock then return end
	if not jobCheck() then return end
	local Menu = {}
	if Config.Menu == "qb" then
		Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
		Menu[#Menu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "" } }
	end
	for i = 1, #data.craftable do
		for k, v in pairs(data.craftable[i]) do
			if k ~= "amount" and k ~= "job" then
				local text = ""
				setheader = QBCore.Shared.Items[tostring(k)].label
				if data.craftable[i]["amount"] ~= nil then setheader = setheader.." x"..data.craftable[i]["amount"] end
				local disable = false
				local checktable = {}
				for l, b in pairs(data.craftable[i][tostring(k)]) do
					if b == 0 or b == 1 then number = "" else number = " x"..b end
					if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
					if Config.Menu == "ox" then text = text..QBCore.Shared.Items[l].label..number.."\n" end
					if Config.Menu == "qb" then text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>" end
					settext = text
					checktable[l] = HasItem(l, b)
				end
				for _, v in pairs(checktable) do if v == false then disable = true break end end
				if not disable then setheader = setheader.." ✔️" end
				local event = "jim-burgershot:Crafting:MakeItem"
                if Config.MultiCraft then event = "jim-burgershot:Crafting:MultiCraft" end
				Menu[#Menu + 1] = {
					disabled = disable,
					icon = "nui://"..Config.img..QBCore.Shared.Items[tostring(k)].image,
					header = setheader, txt = settext, --qb-menu
					params = { event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header, anim = data.craftable["anim"] } }, -- qb-menu
					event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header }, -- ox_lib
					title = setheader, description = settext, -- ox_lib
				}
				settext, setheader = nil
			end
		end
	end
	if Config.Menu == "ox" then exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu }) exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then exports['qb-menu']:openMenu(Menu) end
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-burgershot:Crafting:MultiCraft', function(data)
    local success = Config.MultiCraftAmounts local Menu = {}
    for k in pairs(success) do success[k] = true
        for l, b in pairs(data.craft[data.item]) do
            local has = HasItem(l, (b * k)) if not has then success[k] = false break else success[k] = true end
		end end
    if Config.Menu == "qb" then Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true } end
	Menu[#Menu + 1] = { icon = "fas fa-arrow-left", title = Loc[Config.Lan].menu["back"], header = "", txt = Loc[Config.Lan].menu["back"], params = { event = "jim-burgershot:Crafting", args = data }, event = "jim-burgershot:Crafting", args = data }
	for k in pairsByKeys(success) do
		Menu[#Menu + 1] = {
			disabled = not success[k],
			icon = "nui://"..Config.img..QBCore.Shared.Items[data.item].image, header = QBCore.Shared.Items[data.item].label.." [x"..k.."]", title = QBCore.Shared.Items[data.item].label.." [x"..k.."]",
			event = "jim-burgershot:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, amount = k },
			params = { event = "jim-burgershot:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, amount = k } }
		}
	end
	if Config.Menu == "ox" then	exports.ox_lib:registerContext({id = 'Crafting', title = data.header, position = 'top-right', options = Menu })	exports.ox_lib:showContext("Crafting")
	elseif Config.Menu == "qb" then	exports['qb-menu']:openMenu(Menu) end
end)

--[[STASH SHOPS]]--
RegisterNetEvent('jim-burgershot:Stash', function(data, id)
	if id then -- If it has a bag ID then open the limited stash (doens't work with ox yet, not sure how to make a stash on the fly that isn't exploitable)
		TriggerServerEvent("inventory:server:OpenInventory", "stash", "burgershot_"..id, { maxweight = 2000000, slots = 6, })
		TriggerEvent("inventory:client:SetCurrentStash", "burgershot_"..id)
	else
		if data.job and not jobCheck() then return end
		if Config.Inv == "ox" then exports.ox_inventory:openInventory('stash', tostring(data.id))
		else TriggerEvent("inventory:client:SetCurrentStash", tostring(data.id))
		TriggerServerEvent("inventory:server:OpenInventory", "stash", tostring(data.id)) end
	end
	lookEnt(data.coords)
end)

RegisterNetEvent('jim-burgershot:Shop', function(data)
	local event = "inventory:server:OpenInventory"
	if Config.JimShop then event = "jim-shops:ShopOpen"
	elseif Config.Inv == "ox" then  exports.ox_inventory:openInventory('shop', { type = tostring(data.id) }) end
	TriggerServerEvent(event, "shop", "bugershot", data.shop)
	lookEnt(data.coords)
end)

--[[CONSUME]]--
local function ConsumeSuccess(itemName, type)
	ExecuteCommand("e c")
	toggleItem(false, itemName, 1)
	if QBCore.Shared.Items[itemName].hunger then
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger)
		TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[itemName].hunger)
	end
	if QBCore.Shared.Items[itemName].thirst then
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst)
		TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[itemName].thirst)
	end
	if type == "alcohol" then alcoholCount += 1
		if alcoholCount > 1 and alcoholCount < 4 then TriggerEvent("evidence:client:SetStatus", "alcohol", 200)	elseif alcoholCount >= 4 then TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200) AlienEffect() end
	end
	if Config.RewardItem == itemName then toggleItem(true, Config.RewardPool[math.random(1, #Config.RewardPool)], 1) end
end

RegisterNetEvent('jim-burgershot:client:Consume', function(itemName, type)
	local emoteTable = {
		--Food
		["moneyshot"] = "burger", ["heartstopper"] = "burger", ["bleeder"] = "burger", ["meatfree"] = "burger",	["torpedo"] = "torpedo", ["cheesewrap"] = "torpedo", ["chickenwrap"] = "torpedo",
		["shotrings"] = "bsfries", ["shotnuggets"] = "bsfries", ["shotfries"] = "bsfries", ["rimjob"] = "donut2", ["creampie"] = "donut2",
		--Drinks
		["bscoke"] = "bscoke", ["bscoffee"] = "bscoffee", ["milk"] = "milk", ["milkshake"] = "glass",
	}
	local progstring, defaultemote = Loc[Config.Lan].progress["drinking"], "drink"
	if type == "food" then progstring = Loc[Config.Lan].progress["eating"] defaultemote = "burger" end
	ExecuteCommand("e "..(emoteTable[itemName] or defaultemote))
	if progressBar({label = progstring..QBCore.Shared.Items[itemName].label.."..", time = math.random(3000, 6000), cancel = true, icon = itemName}) then
		ConsumeSuccess(itemName, type)
	else
		ExecuteCommand("e c")
	end
end)

RegisterNetEvent('jim-burgershot:useToilet', function(data)
	lookEnt(data.coords)
	if data.urinal then
		if progressBar({ label = "Using Toilet", time = 5000, cancel = true, dict = "misscarsteal2peeing", anim = "peeing_loop", flag = 8 }) then
			TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] - math.random(10,30))
			TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + math.random(10,30))
			ClearPedTasks(Ped)
		else
			TriggerEvent('inventory:client:busy:status', false)
			triggerNotify(nil, Loc[Config.Lan].error["cancelled"], 'error')
		end
	else
		TaskStartScenarioAtPosition(Ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.sitcoords.x, data.sitcoords.y, data.sitcoords.z, data.sitcoords.w, 0, 1, true)
		if progressBar({ label = "Using Toilet", time = 10000, cancel = true }) then
			TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] - 50)
			TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata["thirst"] - math.random(10,30))
			ClearPedTasks(Ped)
		else
			TriggerEvent('inventory:client:busy:status', false)
			triggerNotify(nil, Loc[Config.Lan].error["cancelled"], 'error')
		end
	end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
		for k in pairs(Props) do DeleteEntity(Props[k]) end
		exports['qb-menu']:closeMenu()
	end
end)