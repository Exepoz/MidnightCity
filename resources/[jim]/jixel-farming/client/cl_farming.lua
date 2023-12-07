
local Props, Targets, PickLock = {}, {}

PickLock = {}

CreateThread(function()
    Props[#Props+1] = makeProp({prop = "prop_veg_crop_orange", coords = vector4(2393.5, 4701.99, 33.73, 213.36)}, true, false)
    Props[#Props+1] = makeProp({prop = "prop_veg_crop_orange", coords = vector4(2412.37, 4695.4, 33.52, 119.55)}, true, false)
    Props[#Props+1] = makeProp({prop = "prop_veg_crop_orange", coords = vector4(2396.04, 4722.96, 33.24, 108.0)}, true, false)
    CreateModelHide(-962.91, -2105.81, 34.64, 1.5, -1468417022, true)

    local zoneTypes = {Trees = Farming.Trees, Plants = Farming.Plants, CayoPlants = Farming.CayoPlants}

    for key, zoneTable in pairs(zoneTypes) do
        for i, zone in ipairs(Zones[key]) do
            local job = zone.job or Config.ScriptOptions.Job
            if zone.ZoneEnabled then
                for j, v in pairs(zoneTable[i]) do
                    local zoneSize = zoneTable[i].zoneSize or vector2(4.0,4.0)
                    local zoneHeading = zoneTable[i].zoneHeading
                    if type(v) == 'vector3' then
						local targetName = zone.Item..key..i..j
						PickLock[targetName] = false
                        Targets[targetName] =
							exports['qb-target']:AddBoxZone(targetName, vector3(v.x, v.y, v.z), zoneSize.x, zoneSize.y,
								{ name=targetName, heading = zoneHeading, debugPoly=Config.DebugOptions.Debug, minZ = v.z-1.2, maxZ = v.z+5, },
								{ options = {
										{
											event = "jixel-farming:client:"..key.."Pick",
											icon = Loc[Config.CoreOptions.Lan].targeticon[key:lower() .. "_" .. i .. "icon"],
											zoneData = zone,
											targetName = targetName,
											label = Loc[Config.CoreOptions.Lan].target["pick_" .. key:lower() .. i],
											job = job,
										},
									},
									distance = 2.2
								}
							)
                    end
                end
            end
        end
    end
end)
RegisterNetEvent('jixel-farming:client:TreesPick', function(data)
	if not PickLock[data.targetName] then PickLock[data.targetName] = true else return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error") end
	local Zone = data.zoneData
	if progressBar({label = Loc[Config.CoreOptions.Lan].progress["progress_picking"]..tostring(Zone.ItemLabel), time = 5000, dict = TreeDict, anim = TreeAnim, flag = Flag, cancel = true,}) then
		TriggerServerEvent("jixel-farming:getTree", Zone.ItemAmountGiven, Zone)
		if Config.ScriptOptions.StressRelief then
			TriggerServerEvent('hud:server:RelieveStress', Config.ScriptOptions.StressReliefAmount)
		end
		Wait(60000 * Config.ScriptOptions.WaitTimes.PickWait)
		PickLock[data.targetName] = false
	  end
  end)
RegisterNetEvent('jixel-farming:client:PlantsPick', function(data)
	if not PickLock[data.targetName] then PickLock[data.targetName] = true else return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error") end
    local Zone = data.zoneData
    if progressBar({label = Loc[Config.CoreOptions.Lan].progress["progress_picking"]..tostring(Zone.ItemLabel), time = 5000, dict = BushDict, anim = BushAnim, flag = Flag, cancel = true,}) then
      TriggerServerEvent("jixel-farming:getPlant", Zone.ItemAmountGiven, Zone)
      if Config.ScriptOptions.StressRelief then
        TriggerServerEvent('hud:server:RelieveStress', Config.ScriptOptions.StressReliefAmount)
      end
	  Wait(60000 * Config.ScriptOptions.WaitTimes.PickWait)
	  PickLock[data.targetName] = false
 	 end
end)
RegisterNetEvent('jixel-farming:client:CayoPick', function(data)
	if not PickLock then PickLock = true else return triggerNotify(nil, Loc[Config.CoreOptions.Lan].error["wait"], "error") end
	local Zone = Zones.CayoPlants[data.cayo]
	if progressBar({label = Loc[Config.CoreOptions.Lan].progress["progress_picking"]..tostring(Zone.ItemLabel), time = 5000, dict = BushDict, anim = BushAnim, flag = Flag, cancel = true,}) then
		TriggerServerEvent("jixel-farming:getCayoPlant", Zone.ItemAmountGiven, Zone)
		if Config.ScriptOptions.StressRelief then
			TriggerServerEvent('hud:server:RelieveStress', Config.ScriptOptions.StressReliefAmount)
		end
		Wait(60000 * Config.ScriptOptions.WaitTimes.PickWait)
		PickLock = false
	end
end)

-- Emote Variables
TreeDict = "amb@prop_human_movie_bulb@idle_a"
TreeAnim = "idle_a"
Flag = 49
BushDict = "missmechanic"
BushAnim = "work_base"
PickAnim = "base"
PickDict = "amb@world_human_gardener_plant@male@base"

Farming = {
	Trees = {
		{
			zoneSize = vector2(4.0,4.0),
			zoneHeading = 90.0,
			vector3(369.91, 6518.22, 27.39),
			vector3(377.72, 6518.22, 27.39),
			vector3(369.44, 6531.91, 27.39),
			vector3(329.4, 6531.12, 27.39),
			vector3(338.87, 6531.36, 27.39),
			vector3(346.02, 6531.68, 27.39),
			vector3(353.56, 6531.25, 27.39),
			vector3(361.56, 6531.68, 27.39),
			vector3(362.56, 6517.76, 27.39),
			vector3(330.64, 6505.91, 27.39),
			vector3(321.81, 6505.35, 27.39),
			vector3(321.63, 6517.46, 27.39),
			vector3(321.7, 6531.08, 27.39),
			vector3(377.9, 6505.88, 27.39),
			vector3(370.06, 6506.11, 27.39),
			vector3(362.83, 6505.68, 27.39),
			vector3(355.46, 6505.39, 27.39),
			vector3(355.01, 6516.95, 27.39),
			vector3(347.62, 6517.47, 27.39),
			vector3(338.83, 6517.16, 27.39),
			vector3(339.67, 6505.95, 27.39),
			vector3(329.98, 6518.28, 27.39),
			vector3(347.93, 6505.32, 27.39)
		},
		{
			vector3(282.3, 6506.38, 28.39),
			vector3(273.25, 6507.31, 28.39),
			vector3(263.97, 6506.16, 28.39),
			vector3(262.41, 6516.86, 28.39),
			vector3(261.64, 6527.68, 28.39),
			vector3(270.72, 6530.59, 28.39),
			vector3(280.49, 6530.84, 28.39),
			vector3(281.38, 6519.12, 28.39),
			vector3(272.27, 6519.09, 28.39)
		},
		{
			vector3(255.88, 6504.08, 28.39),
			vector3(253.65, 6514.27, 28.39),
			vector3(251.94, 6527.44, 28.39),
			vector3(242.96, 6526.34, 28.39),
			vector3(244.63, 6515.54, 28.39),
			vector3(246.61, 6503.15, 28.39),
			vector3(236.97, 6502.22, 28.39),
			vector3(234.4, 6512.8, 28.39),
			vector3(233.55, 6524.89, 28.39),
			vector3(223.84, 6523.58, 28.39),
			vector3(225.76, 6512.14, 28.39),
			vector3(227.51, 6501.91, 28.39)
		},
		{
			vector3(219.99, 6499.45, 30.55),
			vector3(218.02, 6510.25, 30.55),
			vector3(208.48, 6509.99, 30.55),
			vector3(199.58, 6509.0, 30.55),
			vector3(194.01, 6497.31, 30.55),
			vector3(185.09, 6498.18, 30.55),
			vector3(201.55, 6497.24, 30.55),
			vector3(209.89, 6498.28, 30.55)
		},
		{
			vector3(2341.85, 5034.91, 41.92),
			vector3(2343.86, 5022.77, 41.92),
			vector3(2329.24, 5037.41, 41.92),
			vector3(2316.59, 5023.6, 41.92),
			vector3(2316.69, 5008.94, 41.92),
			vector3(2304.74, 4997.13, 41.92),
			vector3(2317.08, 4993.87, 41.92),
			vector3(2317.63, 4984.35, 41.92),
			vector3(2331.41, 4996.3, 41.92),
			vector3(2331.01, 5007.48, 41.92),
			vector3(2344.42, 5007.87, 41.92),
			vector3(2357.29, 5020.59, 41.92),
			vector3(2330.32, 5021.74, 43.46),
		},
		{
			vector3(2376.41, 5016.63, 45.15),
			vector3(2369.32, 5011.41, 44.67),
			vector3(2336.23, 4975.99, 42.17),
			vector3(2349.22, 4975.66, 42.71),
			vector3(2361.81, 4976.16, 43.1),
			vector3(2374.42, 4989.04, 43.85),
			vector3(2390.04, 4992.4, 44.84),
			vector3(2377.63, 5004.16, 44.64),
			vector3(2389.86, 5004.45, 45.35),
			vector3(2361.9, 4989.19, 43.56),
			vector3(2349.24, 4989.55, 43.09),
			vector3(2360.08, 5001.46, 43.11)
		},
		{
			vector3(2424.34, 4658.6, 33.52),
			vector3(2419.68, 4673.67, 33.91),
			vector3(2406.95, 4677.15, 33.98),
			vector3(2401.89, 4688.29, 33.75),
			vector3(2389.83, 4691.24, 33.88),
			vector3(2393.55, 4702.15, 33.6),
			vector3(2381.78, 4700.9, 33.97),
		},
		{
			vector3(2324.33, 4746.85, 35.73),
			vector3(2339.55, 4741.41, 35.03),
			vector3(2350.36, 4734.2, 34.78),
			vector3(2359.29, 4723.91, 34.46),
			vector3(2364.87, 4729.77, 34.14),
			vector3(2366.9, 4715.75, 34.22),
			vector3(2383.27, 4713.42, 33.86),
		},
		{
			vector3(2423.96, 4697.94, 33.08),
			vector3(2422.05, 4686.75, 33.62),
			vector3(2434.52, 4678.83, 33.34),
			vector3(2443.47, 4672.41, 33.33),
			vector3(2401.2, 4717.6, 33.12),
			vector3(2412.37, 4695.4, 33.52),
			vector3(2404.4, 4703.92, 33.23),
			vector3(2386.76, 4724.46, 33.68),
		},
		{
			vector3(2396.04, 4722.96, 33.24),
			vector3(2386.94, 4736.12, 33.24),
			vector3(2374.66, 4735.12, 33.47),
			vector3(2367.47, 4752.05, 34.06),
			vector3(2353.16, 4761.07, 34.28),
			vector3(2343.49, 4755.63, 34.84),
			vector3(2339.42, 4767.11, 34.89),
			vector3(2325.92, 4761.79, 35.61),
			vector3(2327.87, 4770.16, 35.65),
		},
		{
			vector3(2098.34, 4841.31, 41.64),
			vector3(2083.43, 4853.43, 41.91),
			vector3(2086.26, 4825.5, 41.72),
			vector3(2060.54, 4842.79, 41.96),
			vector3(2064.08, 4819.59, 41.84),
		},
		{
			vector3(2031.21, 4802.13, 41.88),
			vector3(2003.59, 4787.1, 42.01),
		},
	},
	Plants = {
		{
			vector3(363.85, 6481.88, 28),
			vector3(363.85, 6477.0, 28),
			vector3(363.85, 6468.43, 28),
			vector3(363.84, 6463.62, 28),
			vector3(356.83, 6482.33, 28),
			vector3(356.92, 6477.33, 28),
			vector3(356.92, 6470.76, 28),
			vector3(356.93, 6466.27, 28)
		},
		{
			vector3(349.94, 6482.33, 28),
			vector3(349.89, 6477.7, 28),
			vector3(350.14, 6470.36, 28),
			vector3(350.14, 6465.71, 28),
			vector3(342.93, 6482.7, 28),
			vector3(343.0, 6477.36, 28),
			vector3(343.21, 6467.75, 28),
			vector3(343.06, 6462.84, 28),
		},
		{
			vector3(322.33, 6463.95, 28),
			vector3(322.18, 6468.94, 28),
			vector3(322.28, 6477.36, 28),
			vector3(329.24, 6482.04, 28),
			vector3(329.13, 6477.57, 28),
			vector3(329.1, 6469.39, 28),
			vector3(329.25, 6464.65, 28),
			vector3(322.24, 6481.99, 28),
		},
		{
			zoneHeading = 40,
			vector3(1896.37, 5103.98, 46.71),
			vector3(1892.28, 5100.45, 46.71),
			vector3(1832.84, 5049.7, 57.93),
			vector3(1828.87, 5046.27, 57.93),
			vector3(1832.94, 5041.25, 57.66),
			vector3(1836.05, 5043.88, 57.66),
			vector3(1904.73, 5102.55, 44.22),
			vector3(1907.98, 5105.37, 44.22),
		},
		{
			zoneHeading = 40,
			vector3(1839.65, 5034.72, 55.58),
			vector3(1842.9, 5037.47, 55.58),
			vector3(1918.01, 5101.74, 42.55),
			vector3(1921.59, 5104.63, 42.45),
			vector3(1922.4, 5097.06, 42.45),
			vector3(1925.91, 5099.82, 42.45),
			vector3(1926.4, 5091.94, 41.24),
			vector3(1929.53, 5094.57, 41.24),
			vector3(1851.53, 5027.93, 54.95),
			vector3(1848.27, 5025.12, 54.95),
			vector3(1846.68, 5032.45, 55.58),
			vector3(1843.69, 5029.97, 55.58),
		},
		{
			zoneHeading = 40,
			vector3(1859.4, 5022.72, 51.99),
			vector3(1862.82, 5025.64, 51.99),
			vector3(1932.43, 5084.82, 41.1),
			vector3(1935.39, 5087.31, 41.1),
			vector3(1940.67, 5083.35, 41.1),
			vector3(1937.63, 5080.8, 41.1),
			vector3(1879.38, 5031.19, 48.71),
			vector3(1876.34, 5028.65, 48.71),
		},
		{
			zoneHeading = 40,
			vector3(1878.41, 4995.15, 50.45),
			vector3(1881.52, 4997.74, 50.45),
			vector3(1884.43, 4991.69, 50.45),
			vector3(1887.68, 4994.52, 50.45),
			vector3(1893.17, 4981.54, 48.53),
			vector3(1896.2, 4984.12, 48.53),
			vector3(1932.47, 5014.99, 42.9),
			vector3(1935.74, 5017.76, 42.9),
			vector3(1936.56, 5010.02, 42.83),
			vector3(1933.31, 5007.24, 42.83),
			vector3(1903.72, 4982.03, 46.91),
			vector3(1900.62, 4979.43, 46.91),
		},
		{
			zoneHeading = 40,
			vector3(1804.75, 5026.08, 57.34),
			vector3(1801.09, 5023.06, 57.34),
			vector3(1794.72, 5017.2, 54.91),
			vector3(1791.57, 5014.54, 54.91),
			vector3(1775.78, 5001.15, 51.24),
			vector3(1772.3, 4998.23, 51.24),
			vector3(1766.01, 4992.67, 51.24),
			vector3(1762.84, 4989.99, 51.24),
			vector3(1756.15, 4984.21, 48.28),
			vector3(1752.76, 4981.24, 48.28),
			vector3(1808.74, 5021.13, 56.19),
			vector3(1805.68, 5018.59, 56.19),
			vector3(1814.91, 5014.28, 55.43),
			vector3(1811.67, 5011.45, 55.43),
			vector3(1829.42, 4997.43, 54.46),
			vector3(1826.23, 4994.63, 52.61),
			vector3(1833.42, 4992.44, 53.64),
			vector3(1830.4, 4989.79, 51.85),
		},
		{
			zoneHeading = 130,
			vector3(1920.68, 4803.76, 43.93),
			vector3(1918.64, 4806.3, 44.92),
			vector3(1925.1, 4809.02, 44.91),
			vector3(1922.49, 4812.1, 44.91),
			vector3(1906.33, 4828.13, 45.57),
			vector3(1909.06, 4825.22, 45.56),
		},
		{
			zoneHeading = 130,
			vector3(1933.48, 4817.08, 44.22),
			vector3(1930.53, 4819.78, 45.43),
			vector3(1927.9, 4832.72, 46.22),
			vector3(1930.86, 4829.79, 45.36),
			vector3(1911.25, 4849.32, 47.05),
			vector3(1907.76, 4852.44, 46.67),
			vector3(1898.16, 4861.94, 46.74),
			vector3(1894.54, 4865.5, 46.05),
			vector3(1904.07, 4841.9, 46.36),
			vector3(1900.59, 4845.22, 46.26),
			vector3(1890.91, 4854.68, 45.94),
			vector3(1887.66, 4858.18, 45.38),
		},
		{
			zoneHeading = 130,
			vector3(1894.49, 4833.19, 46.0),
			vector3(1891.55, 4836.1, 45.91),
			vector3(1881.51, 4846.06, 45.62),
			vector3(1878.38, 4849.12, 45.08),
			vector3(1888.77, 4848.09, 45.71),
			vector3(1892.25, 4844.51, 46.03),
		},
		{
			zoneHeading = 130,
			vector3(1928.47, 4865.09, 47.29),
			vector3(1925.36, 4868.23, 47.09),
			vector3(1908.28, 4885.09, 47.29),
			vector3(1904.25, 4888.82, 47.52),
			vector3(1909.26, 4893.05, 48.0),
			vector3(1912.66, 4889.69, 47.44),
			vector3(1929.75, 4873.12, 47.09),
			vector3(1932.83, 4869.94, 47.11),
		},
		{
			zoneHeading = 130,
			vector3(1915.4, 4900.02, 48.13),
			vector3(1918.65, 4896.86, 47.45),
			vector3(1945.07, 4886.46, 46.26),
			vector3(1941.98, 4889.55, 46.46),
			vector3(1923.7, 4907.99, 47.89),
			vector3(1926.71, 4904.64, 47.29),
		},
		{
			zoneHeading = 130,
			vector3(1949.83, 4890.51, 45.92),
			vector3(1946.77, 4893.58, 45.8),
			vector3(1952.0, 4897.66, 45.3),
			vector3(1949.33, 4900.47, 45.25),
			vector3(1942.53, 4907.08, 45.63),
			vector3(1939.28, 4910.29, 46.65),
		},
		{
			zoneHeading = 130,
			vector3(1986.0, 4805.44, 42.26),
			vector3(1983.0, 4808.44, 42.94),
			vector3(1968.87, 4823.21, 43.59),
			vector3(1965.23, 4826.75, 43.94),
			vector3(1991.62, 4809.74, 42.31),
			vector3(1988.19, 4813.19, 43.39),
			vector3(1973.51, 4828.44, 43.79),
			vector3(1969.92, 4831.82, 44.05),
		},
		{
			zoneHeading = 130,
			vector3(1996.15, 4815.03, 42.48),
			vector3(1993.17, 4818.13, 43.29),
			vector3(1978.57, 4833.02, 43.87),
			vector3(1975.15, 4836.26, 43.95),
			vector3(1980.24, 4841.2, 43.98),
			vector3(1983.55, 4837.9, 43.96),
			vector3(1998.14, 4822.83, 43.45),
			vector3(2001.3, 4819.47, 42.54),
			vector3(1989.21, 4848.35, 43.82),
			vector3(1992.32, 4845.18, 43.79),
			vector3(2003.59, 4833.59, 43.32),
			vector3(2006.9, 4830.19, 42.62),
		},
	},
}

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
    for key in pairs(Targets) do
			exports['qb-target']:RemoveZone(key)
	end
    exports[Config.CoreOptions.CoreName]:HideText()
end)