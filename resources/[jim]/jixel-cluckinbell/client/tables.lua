local clucktable = 0
local Tables, tablelist = {}, {}

for _, Location in pairs(Config.Locations) do
	if Location.zoneEnabled and Location.tablesEnabled then
		if Location.MLO == "SW" then
			tablelist[#tablelist+1] = { coords = vector3(137.06, -1470.07, 29.36)}
            tablelist[#tablelist+1] = { coords = vector3(134.91, -1468.47, 29.36)}
            tablelist[#tablelist+1] = { coords = vector3(132.76, -1466.61, 29.36)}
            tablelist[#tablelist+1] = { coords = vector3(141.16, -1465.49, 29.36)}
            tablelist[#tablelist+1] = { coords = vector3(139.11, -1463.75, 29.36)}
            tablelist[#tablelist+1] = { coords = vector3(136.89, -1461.93, 29.36)}
		elseif Location.MLO =="DI" then
			tablelist[#tablelist+1] = { coords = vec3(-189.4, -1435.98, 31.32),}
            tablelist[#tablelist+1] = { coords = vector3(-187.62, -1433.74, 31.32)}
		elseif Location.MLO == "DP" then
            tablelist[#tablelist+1] = { coords = vector3(-517.39, -688.13, 33.17)}
            tablelist[#tablelist+1] = { coords = vector3(-519.88, -688.12, 33.17)}
            tablelist[#tablelist+1] = { coords = vector3(-522.34, -688.07, 33.17)}
        elseif Location.MLO == "AMB" then
            tablelist[#tablelist+1] = { coords = vector3(-146.17, -267.68, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-145.2, -268.0, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-144.04, -268.4, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-143.1, -268.72, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-141.32, -255.63, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-142.29, -255.29, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-141.57, -262.02, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-142.51, -261.71, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-144.88, -260.9, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-145.73, -260.6, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-144.4, -264.11, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-145.42, -263.9, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-147.01, -263.32, 42.67)}
            tablelist[#tablelist+1] = { coords = vector3(-147.92, -263.0, 42.67)}
        elseif Location.MLO == "GN" then
            tablelist[#tablelist+1] = { coords = vector3(-148.93, -257.22, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-145.8, -258.18, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-144.03, -255.16, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-143.11, -257.42, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-144.14, -260.43, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-146.28, -261.75, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-148.95, -260.78, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-147.68, -254.26, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-150.97, -253.13, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-152.08, -256.08, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-153.93, -252.14, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-157.05, -254.83, 42.6)}
            tablelist[#tablelist+1] = { coords = vector3(-163.08, -254.74, 16.8)}
            tablelist[#tablelist+1] = { coords = vector3(-164.11, -257.69, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-158.5, -254.34, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-155.37, -258.73, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-152.51, -259.81, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-150.43, -258.64, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-149.59, -255.68, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-151.23, -253.03, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-154.01, -252.09, 46.8)}
            tablelist[#tablelist+1] = { coords = vector3(-154.08, -255.91, 46.8)}
        elseif Location.MLO == "KAM" then
            tablelist[#tablelist+1] = { coords = vector3(-139.8, -260.92, 42.64)}
            tablelist[#tablelist+1] = { coords = vector3(-140.68, -263.54, 42.64)}
            tablelist[#tablelist+1] = { coords = vector3(-141.6, -266.05, 42.64)}
        end
	end
end

CreateThread(function()
	local i = 0
	for _, v in pairs(tablelist) do i += 1
		if Config.Debug then print("^7 Registering Table ^2"..i.."^7") end
		local targetName = "Tables"..i
		Tables[targetName] =
			exports['qb-target']:AddBoxZone(targetName, vec3(v.coords.x, v.coords.y , v.coords.z), 0.6, 0.6,
			{ name= targetName, heading = 162, debugPoly = Config.Debug, minZ = v.coords.z-1.2, maxZ = v.coords.z+0.2, },
				{ options = { { event = "jixel-cluckinbell:Stash", icon = "fas fa-box-open", label = Loc[Config.Lan].target["open_table"], coords = v.coords, stash = targetName }, },
					distance = 2.2 })
	end
end)