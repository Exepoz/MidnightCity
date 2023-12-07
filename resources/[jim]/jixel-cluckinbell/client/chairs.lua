local cluckseat = 0
local Chairs, chairlist = {}, {}

for _, Location in pairs(Config.Locations) do
	if Location.zoneEnabled and Location.chairsEnabled then
		if Location.MLO == "SW" then
			chairlist[#chairlist+1] = { coords = vec4(136.68, -1469.44, 29.36, 230), stand = vec3(137.13, -1468.8, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(136.05, -1470.22, 29.36, 230), stand = vec3(137.13, -1468.8, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(137.8, -1470.34, 29.36, 48), stand = vec3(138.27, -1470.7, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(137.16, -1471.1, 29.36, 48), stand = vec3(137.7, -1471.47, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(140.36, -1465.31, 29.36, 230), stand = vec3(139.83, -1465.92, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(140.96, -1464.61, 29.36, 230), stand = vec3(141.92, -1464.46, 29.35)}
			chairlist[#chairlist+1] = { coords = vec4(142.06, -1465.53, 29.36, 48), stand = vec3(142.55, -1465.84, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(141.41, -1466.29, 29.36, 48), stand = vec3(141.93, -1466.63, 29.36)}

			chairlist[#chairlist+1] = { coords = vec4(135.14, -1469.33, 29.36, 48), stand = vec3(136.21, -1468.01, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(135.78, -1468.55, 29.36, 48), stand = vec3(136.21, -1468.01, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(134.03, -1468.42, 29.36, 230), stand = vec3(134.98, -1466.92, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(134.67, -1467.62, 29.36, 230), stand = vec3(134.98, -1466.92, 29.36)}

			chairlist[#chairlist+1] = { coords = vec4(140.05, -1463.8, 29.36, 48), stand = vec3(138.75, -1464.96, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(139.33, -1464.54, 29.36, 48), stand = vec3(138.75, -1464.96, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(138.25, -1463.59, 29.36, 230), stand = vec3(137.69, -1464.39, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(138.96, -1462.86, 29.36, 230), stand = vec3(137.69, -1464.39, 29.36)}

			chairlist[#chairlist+1] = { coords = vec4(132.88, -1467.53, 29.36, 48), stand = vec3(133.92, -1466.07, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(133.51, -1466.78, 29.36, 48), stand = vec3(133.92, -1466.07, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(132.43, -1465.85, 29.36, 230), stand = vec3(133.22, -1465.44, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(131.76, -1466.66, 29.36, 230), stand = vec3(133.22, -1465.44, 29.36)}

			chairlist[#chairlist+1] = { coords = vec4(137.79, -1461.96, 29.36, 48), stand = vec3(136.59, -1463.24, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(137.23, -1462.7, 29.36, 48), stand = vec3(136.59, -1463.24, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(136.69, -1461.05, 29.36, 230), stand = vec3(135.7, -1462.54, 29.36)}
			chairlist[#chairlist+1] = { coords = vec4(136.03, -1461.86, 29.36, 230), stand = vec3(135.7, -1462.54, 29.36)}
		elseif Location.MLO =="DI" then
			--benches
			chairlist[#chairlist+1] = { coords = vec4(-189.6, -1435.38, 31.32, 174.44), stand = vec3(-189.55, -1435.07, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-188.94, -1435.44, 31.32, 174.44), stand = vec3(-188.86, -1435.16, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-189.83, -1436.51, 31.32, 353.17), stand = vec3(-189.9, -1436.83, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-189.21, -1436.59, 31.32, 353.17), stand = vec3(-189.26, -1436.95, 31.32) }
			---
			chairlist[#chairlist+1] = { coords = vec4(-188.32, -1433.77, 31.32, 304.25), stand = vec3(-188.61, -1433.92, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-188.02, -1434.37, 31.32, 304.25), stand = vec3(-188.21, -1434.52, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-187.26, -1433.16, 31.32, 118), stand = vec3(-189.9, -1436.83, 31.32) }
			chairlist[#chairlist+1] = { coords = vec4(-186.96, -1433.73, 31.32, 118), stand = vec3(-186.61, -1433.8, 31.32) }
		elseif Location.MLO == "DP" then
			--benches
			chairlist[#chairlist+1] = { coords = vec4(-523.07, -688.04, 33.17, 270), stand = vec3(-523.72, -688.11, 33.17) }
			chairlist[#chairlist+1] = { coords = vec4(-520.58, -688.02, 33.17, 270), stand = vec3(-521.07, -688.63, 33.17) }
			chairlist[#chairlist+1] = { coords = vec4(-518.1, -688.04, 33.17, 270), stand = vec3(-518.15, -688.81, 33.17) }
			chairlist[#chairlist+1] = { coords = vec4(-516.65, -688.1, 33.17, 90), stand = vec3(-516.01, -688.08, 33.17) }
			chairlist[#chairlist+1] = { coords = vec4(-519.21, -688.07, 33.17, 90), stand = vec3(-518.85, -688.8, 33.17) }
			chairlist[#chairlist+1] = { coords = vec4(-521.73, -688.03, 33.17, 90), stand = vec3(-521.73, -688.85, 33.17) }
		elseif Location.MLO == "AMB" then
		--SmallTable1 left
		chairlist[#chairlist+1] = { coords = vec4(-141.45, -256.31, 43.67, 340), stand = vec3(-141.76, -256.9, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-142.49, -255.85, 43.67, 340), stand = vec3(-142.72, -256.47, 43.67) }

		--table center
		chairlist[#chairlist+1] = { coords = vec4(-144.57, -260.27, 43.67, 160), stand = vec3(-144.19, -259.72, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-145.51, -259.96, 43.67, 160), stand = vec3(-145.49, -259.29, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-146.02, -261.23, 43.67, 340), stand = vec3(-146.09, -261.85, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-144.99, -261.59, 43.67, 340), stand = vec3(-145.19, -262.26, 43.67) }

		-- table center 2
		chairlist[#chairlist+1] = { coords = vec4(-141.33, -261.4, 43.67, 160), stand = vec3(-141.21, -260.78, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-142.28, -261.07, 43.67, 160), stand = vec3(-142.16, -260.52, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-142.73, -262.31, 43.67, 340), stand = vec3(-143.0, -262.96, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-141.76, -262.73, 43.67, 340), stand = vec3(-141.95, -263.28, 43.67) }

		-- booth center 1
		chairlist[#chairlist+1] = { coords = vec4(-147.17, -263.99, 43.67, 340), stand = vec3(-146.51, -264.28, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-148.21, -263.65, 43.67, 340), stand = vec3(-148.6, -262.65, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-144.2, -263.56, 43.67, 160), stand = vec3(-144.01, -262.96, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-145.19, -263.21, 43.67, 160), stand = vec3(-145.09, -262.66, 43.67) }
		-- booth center 2
		chairlist[#chairlist+1] = { coords = vec4(-146.76, -262.68, 43.67, 160), stand = vec3(-146.54, -262.12, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-147.73, -262.34, 43.67, 160), stand = vec3(-147.58, -261.78, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-145.6, -264.55, 43.67, 340), stand = vec3(-146.36, -264.25, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-144.66, -264.84, 43.67, 340), stand = vec3(-143.96, -265.25, 43.67) }
		-- Stools 1
		chairlist[#chairlist+1] = { coords = vec4(-142.91, -268.16, 43.67, 160), stand = vec3(-142.61, -267.48, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-143.83, -267.77, 43.67, 160), stand = vec3(-143.37, -266.9, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-145.0, -267.43, 43.67, 160), stand = vec3(-144.76, -266.74, 43.67) }
		chairlist[#chairlist+1] = { coords = vec4(-145.94, -267.05, 43.67, 160), stand = vec3(-146.85, -267.28, 43.67) }

		elseif Location.MLO == "GN" then
			--==STORE FRONT==--
			--LEFTSIDE--
			--Stools
			chairlist[#chairlist+1] = { coords = vec4(-139.77, -261.07, 43.80, 249.26), stand = vec3(-140.23, -260.96, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-140.37, -262.71, 43.80, 249.26), stand = vec3(-140.84, -262.62, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-140.86, -264.24, 43.80, 249.26), stand = vec3(-141.22, -263.98, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-141.3, -265.56, 43.80, 249.26), stand = vec3(-141.7, -265.42, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-141.86, -267.12, 43.80, 249.26), stand = vec3(-142.29, -267.03, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-142.47, -268.38, 43.80, 208.25), stand = vec3(-142.88, -267.79, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-144.03, -268.11, 43.80, 155.99), stand = vec3(-143.8, -267.59, 43.61) }
			chairlist[#chairlist+1] = { coords = vec4(-145.57, -267.64, 43.80, 155.99), stand = vec3(-145.25, -267.15, 43.61) }
			--Center Booth 1
			chairlist[#chairlist+1] = { coords = vec4(-145.27, -257.71, 43.59, 160), stand = vec3(-145.02, -257.13, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-145.91, -257.47, 43.6, 160), stand = vec3(-145.64, -256.86, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-145.72, -258.97, 43.6, 340), stand = vec3(-146.0, -259.55, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-146.37, -258.74, 43.6, 340), stand =vec3(-146.54, -259.37, 43.6) }
			--Center Booth 2
			chairlist[#chairlist+1] = { coords = vec4(-148.36, -256.72, 43.6, 160), stand = vec3(-148.18, -256.02, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-149.06, -256.4, 43.6, 160), stand = vec3(-148.82, -255.86, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-149.49, -257.74, 43.6, 340), stand = vec3(-149.71, -258.24, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-148.76, -257.95, 43.6, 340), stand = vec3(-148.93, -258.53, 43.6) }
			--Center Booth 3
			chairlist[#chairlist+1] = { coords = vec4(-151.6, -255.55, 43.6, 160), stand = vec3(-151.45, -254.86, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-152.26, -255.36, 43.6, 160), stand = vec3(-152.03, -254.74, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-152.74, -256.58, 43.6, 340), stand = vec3(-153.09, -257.54, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-152.01, -256.82, 43.6, 340), stand = vec3(-152.33, -257.34, 43.6) }
			--Left Center Booth 1
			chairlist[#chairlist+1] = { coords = vec4(-154.46, -251.56, 43.6, 250), stand = vec3(-155.06, -251.33, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-154.68, -252.16, 43.6, 250), stand = vec3(-155.27, -252.12, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-153.15, -251.92, 43.6, 70), stand = vec3(-152.47, -252.14, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-153.39, -252.61, 43.6, 70), stand = vec3(-152.77, -252.73, 43.6) }
			--Left Center Booth 2
			chairlist[#chairlist+1] = { coords = vec4(-151.5, -252.49, 43.6, 250), stand = vec3(-152.18, -252.35, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-151.76, -253.2, 43.6, 250), stand = vec3(-152.35, -252.96, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-150.11, -253.01, 43.6, 70), stand = vec3(-149.88, -253.97, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-150.33, -253.69, 43.6, 70), stand = vec3(-149.88, -253.97, 43.6) }
			--Left Center Booth 3
			chairlist[#chairlist+1] = { coords = vec4(-148.12, -253.61, 43.6, 250), stand = vec3(-148.82, -253.39, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-148.36, -254.33, 43.6, 250), stand = vec3(-148.97, -254.13, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-146.93, -254.06, 43.6, 70), stand = vec3(-146.28, -254.3, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-147.09, -254.78, 43.6, 70), stand = vec3(-146.6, -255.03, 43.6) }
			-- Booth back 1
			chairlist[#chairlist+1] = { coords = vec4(-144.62, -254.95, 43.6, 250), stand = vec3(-145.3, -254.74, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-143.42, -255.37, 43.6, 70), stand = vec3(-145.3, -254.74, 43.6) }
			-- Booth Right Side 1
			chairlist[#chairlist+1] = { coords = vec4(-146.97, -261.46, 43.6, 250), stand = vec3(-147.49, -261.28, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-145.6, -261.98, 43.6, 70), stand = vec3(-145.25, -261.4, 43.6) }
			-- Booth Right Side 2
			chairlist[#chairlist+1] = { coords = vec4(-149.58, -260.58, 43.6, 250), stand = vec3(-150.25, -260.32, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-148.34, -261.04, 43.6, 70), stand = vec3(-148.06, -260.48, 43.6) }
			-- Booth left side 1
			chairlist[#chairlist+1] = { coords = vec4(-143.95, -259.81, 43.6, 160), stand = vec3(-143.57, -259.15, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-143.36, -258.14, 43.6, 340), stand = vec3(-143.47, -258.74, 43.6) }
			-- Booth left side 2
			chairlist[#chairlist+1] = { coords = vec4(-142.83, -256.78, 43.6, 160), stand = vec3(-142.53, -256.2, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-144.36, -261.09, 43.6, 340), stand = vec3(-144.5, -261.64, 43.6) }
			-- Booth right side 2
			chairlist[#chairlist+1] = { coords = vec4(-156.84, -254.2, 43.6, 160), stand = vec3(-156.17, -254.25, 43.6) }
			chairlist[#chairlist+1] = { coords = vec4(-157.2, -255.44, 43.6, 340), stand = vec3(-156.74, -255.94, 43.6) }
			---- Upstairs
			--- Stools
			chairlist[#chairlist+1] = { coords = vec4(-157.58, -260.22, 48.1, 160), stand = vec3(-157.46, -259.81, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-158.84, -259.99, 48.1, 160), stand = vec3(-158.6, -259.17, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-159.97, -259.59, 48.1, 160), stand = vec3(-159.76, -258.97, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-157.1, -259.32, 48.1, 255.24), stand = vec3(-157.61, -259.27, 47.8) }
			-- Booth 1
			chairlist[#chairlist+1] = { coords = vec4(-158.45, -253.66, 47.8, 160), stand = vec3(-158.89, -253.07, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-157.89, -253.87, 47.8, 160), stand = vec3(-157.23, -254.21, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-158.95, -254.92, 47.8, 340), stand = vec3(-159.1, -255.64, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-158.35, -255.09, 47.8, 340), stand = vec3(-158.46, -255.79, 47.8) }
			-- Booth 2
			chairlist[#chairlist+1] = { coords = vec4(-154.13, -255.18, 47.8, 160), stand = vec3(-154.03, -254.6, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-153.52, -255.42, 47.8, 160), stand = vec3(-153.38, -254.82, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-154.61, -256.39, 47.8, 340), stand = vec3(-154.85, -257.17, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-154.02, -256.63, 47.8, 340), stand = vec3(-154.16, -257.24, 47.8) }
			-- Booth upper left side 1
			chairlist[#chairlist+1] = { coords = vec4(-164.37, -258.32, 47.8, 340), stand = vec3(-164.47, -258.95, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-163.85, -257.07, 47.8, 160), stand = vec3(-163.78, -256.46, 47.8) }
			-- Booth upper left side 2
			chairlist[#chairlist+1] = { coords = vec4(-162.86, -254.06, 47.8, 160), stand = vec3(-162.53, -253.46, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-163.31, -255.4, 47.8, 340), stand = vec3(-163.68, -255.91, 47.8) }
			-- Booth center left side 1
			chairlist[#chairlist+1] = { coords = vec4(-151.73, -252.41, 47.8, 250), stand = vec3(-152.35, -252.24, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-151.97, -253.08, 47.8, 250), stand = vec3(-152.52, -253.01, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-150.7, -253.53, 47.8, 70), stand = vec3(-150.31, -254.28, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-150.47, -252.88, 47.8, 70), stand = vec3(-149.96, -253.36, 47.8) }
			-- Booth center left side 2
			chairlist[#chairlist+1] = { coords = vec4(-154.73, -252.2, 47.8, 250), stand = vec3(-155.24, -252.03, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-154.49, -251.48, 47.8, 250), stand = vec3(-155.06, -251.54, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-153.24, -251.88, 47.8, 70), stand = vec3(-152.56, -252.15, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-153.5, -252.61, 47.8, 70), stand = vec3(-152.89, -252.95, 47.8) }
			-- Booth upper right side 1
			chairlist[#chairlist+1] = { coords = vec4(-149.28, -255.09, 47.8, 160), stand = vec3(-148.87, -254.45, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-149.75, -256.36, 47.8, 340), stand = vec3(-149.82, -256.96, 47.8) }
			-- Booth upper right side 2
			chairlist[#chairlist+1] = { coords = vec4(-150.26, -257.96, 47.8, 160), stand = vec3(-149.9, -257.44, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-150.74, -259.26, 47.8, 340), stand = vec3(-151.33, -259.16, 47.8) }

			-- Booth left side 1
			chairlist[#chairlist+1] = { coords = vec4(-153.23, -259.46, 47.8, 250), stand = vec3(-153.82, -259.25, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-151.81, -260.01, 47.8, 70), stand = vec3(-151.61, -259.37, 47.8) }
			-- Booth left side 2
			chairlist[#chairlist+1] = { coords = vec4(-156.05, -258.49, 47.8, 250), stand = vec3(-156.64, -258.22, 47.8) }
			chairlist[#chairlist+1] = { coords = vec4(-154.68, -258.98, 47.8, 70), stand = vec3(-154.19, -259.37, 47.8) }
		elseif Location.MLO == "KAM" then
		--benches
		chairlist[#chairlist+1] = { coords = vec4(-142.15, -266.63, 43.64, 340), stand = vec3(-142.97, -266.14, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-141.42, -266.91, 43.64, 340), stand = vec3(-142.97, -266.14, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-140.98, -265.43, 43.64, 160), stand = vec3(-142.48, -264.76, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-141.75, -265.19, 43.64, 160), stand = vec3(-142.48, -264.76, 43.64) }
		--BENCH
		chairlist[#chairlist+1] = { coords = vec4(-141.27, -264.11, 43.64, 340), stand = vec3(-142.15, -263.84, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-140.61, -264.32, 43.64, 340), stand = vec3(-142.15, -263.84, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-140.01, -262.82, 43.64, 160), stand = vec3(-141.58, -262.29, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-140.8, -262.55, 43.64, 160), stand = vec3(-141.58, -262.29, 43.64) }
		--BENCH
		chairlist[#chairlist+1] = { coords = vec4(-139.68, -261.67, 43.64, 340), stand = vec3(-141.08, -261.13, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-140.43, -261.45, 43.64, 340), stand = vec3(-141.08, -261.13, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-139.08, -260.27, 43.64, 160), stand = vec3(-140.71, -259.51, 43.64) }
		chairlist[#chairlist+1] = { coords = vec4(-139.91, -260.03, 43.64, 160), stand = vec3(-140.71, -259.51, 43.64) }
		end
	end
end

CreateThread(function()
	local i = 0
	for _, v in pairs(chairlist) do i += 1
		if Config.Debug then print("^7 Registering Chair ^2"..i.."^7") end
		local targetName = "CBChair"..i
		Chairs[targetName] =
			exports['qb-target']:AddBoxZone(targetName, vec3(v.coords.x, v.coords.y , v.coords.z-1.03), 0.6, 0.6,
			{ name= targetName, heading = v.coords[4], debugPoly = Config.Debug, minZ = v.coords.z-1.2, maxZ = v.coords.z+0.2, },
				{ options = { { event = "jixel-cluckinbell:Chair", icon = "fas fa-chair", label = Loc[Config.Lan].target["sit"], loc = v.coords, stand = v.stand }, },
					distance = 2.2 })
	end
end)

RegisterNetEvent('jixel-cluckinbell:Chair', function(data)
	local canSit = true
	local sitting = false
	local ped = PlayerPedId()
	for _, v in pairs(QBCore.Functions.GetPlayersFromCoords(data.loc.xyz, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc.xyz)
		if dist <= 0.4 then triggerNotify(nil, Loc[Config.Lan].error["someone_sitting"]) canSit = false end
	end
	if canSit then
		if not IsPedHeadingTowardsPosition(ped, data.loc.xyz, 20.0) then TaskTurnPedToFaceCoord(ped, data.loc.xyz, 1500) Wait(1500)	end
		if #(data.loc.xyz - GetEntityCoords(PlayerPedId())) > 1.5 then TaskGoStraightToCoord(ped, data.loc.xyz, 0.5, 1000, 0.0, 0) Wait(1100) end
		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z-0.5, data.loc[4], 0, 1, true)
		cluckseat = data.stand
		sitting = true
	end
	while sitting do
		if sitting then
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)
				if cluckseat then SetEntityCoords(ped, cluckseat) end
				cluckseat = nil
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)

AddEventHandler('onResourceStop', function(r) if r == GetCurrentResourceName() and LocalPlayer.state.isLoggedIn then for k, v in pairs(Chairs) do exports['qb-target']:RemoveZone(k) end end end)