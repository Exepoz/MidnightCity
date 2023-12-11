-- If you need support we have a discord available, it helps us keep track of issues and give better support.

-- https://discord.gg/jixelpatterns

Config = {
	Lan = "en",
	Debug = false, -- false to remove green boxes
	img = "lj-inventory/html/images/", -- Change this to your inventory's name and image folder (SET TO "" IF YOU HAVE DOUBLE IMAGES)

	JimShop = false, -- Enable this to use jim-shops for buying ingredients
	JimConsumables = false,
	CheckMarks = true, -- If true this will show the player if they have the correct items to be able to craft the items
	Notify = "qb",
	ScreenEffects = false, -- Do you want drugs to cause screen/character effects
	MultiCraft = true, -- This enabled the option of crafting 1, 5 or 10 at a time of an item
	TrimmerRemove = true,
	Core = "qb-core", -- Set this to your core foldername
	Inv = "qb", -- ONLY Change to "ox" for ox_inventory
	Hidden = false, -- enable this to hide crafting recipes with missing ingredients
			--Simple Toy Reward Support - look how Hen House/CC/Burgershot give out toys and play with that fn
	RewardItem = "", --Set this to the name of an item eg "tillemae"
	RewardPool = { -- Set this to the list of items to be given out as random prizes when the item is used - can be more or less items in the list
		"",
		"",
		"",
	},

	Items = {
		label = "Ingredients Storage",
		slots = 14,
		items = {
				--{ name = "gelatine", price = 0, amount = 50, info = {}, type = "item", slot = 1, },
				--{ name = "cereal", price = 0, amount = 50, info = {}, type = "item", slot = 2, },
				--{ name = "butter", price = 0, amount = 50, info = {}, type = "item", slot = 3, },
				--{ name = "sugar", price = 0, amount = 50, info = {}, type = "item", slot = 4, },
				--{ name = "flour", price = 0, amount = 50, info = {}, type = "item", slot = 5, },
				--{ name = "egg", price = 0, amount = 50, info = {}, type = "item", slot = 6, },
				--{ name = "milk", price = 0, amount = 50, info = {}, type = "item", slot = 7, },
				--{ name = "peanutbutter", price = 0, amount = 50, info = {}, type = "item", slot = 8, },
				--{ name = "chocolatechips", price = 0, amount = 50, info = {}, type = "item", slot = 9, },
				--{ name = "trimmers", price = 0, amount = 50, info = {}, type = "item", slot = 10, },
				--{ name = "grinder", price = 0, amount = 50, info = {}, type = "item", slot = 11, },
				--{ name = "rollingpapers", price = 0, amount = 50, info = {}, type = "item", slot = 12, },
				--{ name = "emptybaggy", price = 0, amount = 50, info = {}, type = "item", slot = 13, },
				--{ name = "gummymould", price = 0, amount = 50, info = {}, type = "item", slot = 14, },
				--{ name = "bong", price = 0, amount = 50, info = {}, type = "item", slot = 15, },
				--{ name = "lighter", price = 0, amount = 50, info = {}, type = "item", slot = 16, },
		},
	},

	Locations = {
		{  -- WhiteWidow --
			zoneEnable = false,
			job = "whitewidow", -- Set this to the required job
			label = "White Widow", -- Set this to the blip label
			MLO = "mosbaek", -- Don't change, this is to help the script load the locations info
			zones = {
				vec2(199.27, -280.15),
				vec2(217.28, -230.8),
				vec2(170.50, -213.94),
				vec2(151.74, -262.31),
			},
			autoClock = { enter = false, exit = true, },
			blip = vec4(196.52, -241.91, 54.07, 296.91),
			blipcolor = 2,
			garage = { spawn = vec4(198.38, -268.97, 49.59, 248.21),
				out = vec4(194.79, -271.43, 49.66-0.3, 251.19),
				list = { "burrito3" }
			},
			Strain = { -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
				StrainOne = vec3(164.77, -237.72, 50.06),
				StrainTwo = vec3(164.02, -239.55, 50.14),
				StrainThree = vec3(171.0, -239.94, 50.06),
				StrainFour = vec3(170.33, -241.8, 50.09),
				StrainFive = vec3(169.26, -247.32, 50.06),
				StrainSix = vec3(164.19, -245.42, 50.06),
				StrainSeven = vec3(161.71, -244.49, 50.11),
				StrainEight = vec3(166.71, -246.38, 50.06),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
			Targets = {
				EdibleLoc = vec4(171.74, -234.48, 50.07, 340.1),
				EmployeeStorage = vec3(180.27, -247.75, 54.11),
				StoreLoc = vec4(175.38, -239.87, 50.06, 159.17),
				JointsLoc = vec3(165.41, -235.71, 50.06),
				TrimmingLoc = vec3(164.33, -233.49, 50.06),
				PreppedStorage = vec3(185.38, -242.16, 54.07),
				PreppedStorage2 = vec3(195.33, -233.73, 54.07),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
		},
		{ -- BestBuds --
			zoneEnable = false,
			job = "bestbuds", -- Set this to the required job
			label = "Best Buds", -- Set this to the required job
			MLO = "bestbuds", -- Don't change, this is to help the script load the locations info
			zones = {
				vec2(367.40, -840.25),
				vec2(367.06, -811.42),
				vec2(386.77, -812.09),
				vec2(387.13, -840.36)
			},
			autoClock = { enter = false, exit = true, },
			blip = vec4(378.1, -830.24, 29.3, 177.65),
			blipcolor = 2,
			garage = { spawn = vec4(367.25, -831.22, 29.11, 181.3),
				out = vec4(372.12, -832.05, 29.29, 85.08),
				list = { "burrito3" }
			},
			Strain = { -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
				StrainOne = vec3(379.29, -814.73, 29.3),
				StrainTwo = vec3(379.31, -813.33, 29.3),
				StrainThree = vec3(379.3, -811.41, 29.3),
				StrainFour = vec3(382.41, -811.47, 29.3),
				StrainFive = vec3(382.81, -813.38, 29.3),
				StrainSix = vec3(382.69, -814.7, 29.3),
				StrainSeven = vec3(380.09, -824.42, 29.3),
				StrainEight = vec3(378.13, -824.54, 29.3),
			},      -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
			Targets = {
				EdibleLoc = vec4(379.04, -817.52, 29.3, 184.22),
				EmployeeStorage = vec3(374.32, -824.64, 29.3),
				StoreLoc = vec3(374.53, -816.08, 29.3),
				JointsLoc = vec3(382.52, -817.38, 29.3),
				TrimmingLoc = vec3(164.33, -233.49, 50.06),
				PreppedStorage = vec3(379.6, -825.51, 29.3),
				PreppedStorage2 = vec3(379.83, -819.7, 29.3),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
		},
		{  -- WhiteWidow --
			zoneEnable = true,
			job = "whitewidow", -- Set this to the required job
			label = "Jen Widow", -- Set this to the blip label
			MLO = "jenww", -- Don't change, this is to help the script load the locations info
			zones = {
				vec2(199.27, -280.15),
				vec2(217.28, -230.8),
				vec2(170.50, -213.94),
				vec2(151.74, -262.31),
			},
			autoClock = { enter = false, exit = true, },
			blip = vec4(196.52, -241.91, 54.07, 296.91),
			blipcolor = 2,
			garage = { spawn = vec4(198.38, -268.97, 49.59, 248.21),
				out = vec4(194.79, -271.43, 49.66-0.3, 251.19),
				list = { "burrito3" }
			},
			Strain = { -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
				StrainOne = vector3(182.25, -250.61, 53.31),
				StrainTwo = vec3(181.59, -251.92, 53.31),
				StrainThree = vec3(182.43, -252.43, 53.31),
				StrainFour = vec3(183.46, -252.73, 53.31),
				StrainFive = vec3(183.37, -254.76, 53.31),
				StrainSix = vector3(183.91, -251.14, 53.26),
				StrainSeven = vec3(182.19, -254.33, 53.31),
				StrainEight = vec3(181.09, -253.96, 53.31),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
			Targets = {
				CoffeeLoc = vec4(195.25, -265.98, 54.39, 245.0),
				EdibleLoc = vec4(178.21, -247.52, 54.11, 337),
				EmployeeStorage = vec4(180.48, -248.18, 53.31, 340.1),
				StoreLoc = vec4(162.31, -252.83, 54.13, 340.0),
				JointsLoc = vector3(176.3, -246.5, 53.81),
				TrimmingLoc = vec3(178.10, -253.10, 53.5),
				PreppedStorage = vec4(195.37, -252.86, 54.1, 70.0),
				PreppedStorage2 = vec4(194.2, -256.05, 54.1, 70.0),
				PreppedStorage3 = vec4(192.96, -259.64, 54.1, 70.0),
				--PreppedStorage2 = vec3(195.33, -233.73, 54.07),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
		},
		{  -- WeedClinic --
			zoneEnable = false,
			job = "whitewidow", -- Set this to the required job
			label = "Weed Clinic", -- Set this to the blip label
			MLO = "supreme", -- Don't change, this is to help the script load the locations info
			zones = {
				vector2(353.10, -1029.47),
				vector2(360.94, -1029.44),
				vector2(360.078, -998.60),
				vector2(337.64, -998.65),
				vector2(336.58, -1029.98)
			  },
			autoClock = { enter = false, exit = true, },
			blip = vec3(355.58, -1022.46, 29.4),
			blipcolor = 2,
			garage = { spawn = vec4(198.38, -268.97, 49.59, 248.21),
				out = vec4(194.79, -271.43, 49.66-0.3, 251.19),
				list = { "burrito3" }
			},
			Strain = { -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
				StrainOne = vec3(354.62, -1009.95, 29.4),
				StrainTwo = vec3(352.88, -1009.83, 29.4),
				StrainThree = vec3(350.22, -1009.82, 29.4),
				StrainFour = vec3(346.94, -1009.75, 29.4),
				StrainFive = vec3(354.69, -1013.85, 29.4),
				StrainSix = vec3(352.9, -1013.74, 29.4),
				StrainSeven = vec3(350.15, -1014.03, 29.4),
				StrainEight = vec3(346.93, -1013.83, 29.4),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
			Targets = {
				EdibleLoc = vec4(357.72, -1008.52, 29.4, 270.99),
				EmployeeStorage = vec3(374.32, -824.64, 29.3),
				StoreLoc = vec4(358.26, -1022.24, 29.4, 0.0),
				JointsLoc = vec4(357.86, -1011.7, 29.4, 90.0),
				TrimmingLoc = vec3(164.33, -233.49, 50.06),
				PreppedStorage = vec4(353.61, -1019.77, 29.4, 0.0),
			},  -- DO NOT CHANGE THESE UNLESS YOU KNOW WHAT YOU'RE DOING--
		},
	}
}

Edibles = {
	Strain1 = { Name = "gummy_rasberry", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain2 = { Name = "gummy_blueberry", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain3 = { Name = "gummy_grape", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain4 = { Name = "gummy_applering", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain5 = { Name = "gummy_belt", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain6 = { Name = "edible_snickerdoodle", Stress = math.random(1, 3), Health = 10, Armour = 10,	},
	Strain7 = { Name = "edible_peanutcookie", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain8 = { Name = "edible_cchip", Stress = math.random(1, 3), Health = 10, Armour = 10, }
}
Joints = {
	Strain1 = { Name = "afghankush_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain2 = { Name = "bluedream_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain3 = { Name = "granddaddypurple_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain4 = { Name = "greencrack_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain5 = { Name = "jackherrer_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain6 = { Name = "sourdiesel_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain7 = { Name = "weddingcake_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, },
	Strain8 = { Name = "whitewidow_joint", Stress = math.random(1, 3), Health = 10, Armour = 10, }
}
Bud = {
    Strain1 = { Name = "afghankush_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain2 = { Name = "bluedream_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain3 = { Name = "granddaddypurple_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain4 = { Name = "greencrack_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain5 = { Name = "jackherrer_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain6 = { Name = "sourdiesel_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain7 = { Name = "weddingcake_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, },
    Strain8 = { Name = "whitewidow_bud", Stress = math.random(1, 3), Health = 10, Armour = 10, }
}

Crafting = {
	Edibles = {
		{ ['cannabutter'] 			= { ['butter'] = 1, ['malmo_weed_oz'] = 1, } },
		{ ['edible_ricecrispy'] 	= { ['sugar'] = 3, ['cereal'] = 3, ['cannabutter'] = 1} }, -- makes 16
		{ ['edible_snickerdoodle'] 	= { ['egg'] = 3, ['milk'] = 3, ['flour'] = 3, ['sugar'] = 1} },
		{ ['edible_peanutcookie'] 	= { ['egg'] = 3, ['milk'] = 3, ['flour'] = 3, ['cannabutter'] = 1, ['peanutbutter'] = 3, } },
		{ ['edible_cchip'] 			= { ['egg'] = 3, ['milk'] = 3, ['flour'] = 3, ['cannabutter'] = 1, ['chocolatechips'] = 3, } },
		{ ['gummy_rasberry'] 		= { ['gummymould'] = 1,  ['gelatine'] = 3, ['sugar'] = 3, ['malmo_weed_oz'] = 1} }, -- makes 16
		{ ['gummy_blueberry'] 		= { ['gummymould'] = 1,  ['gelatine'] = 3, ['sugar'] = 3, ['malmo_weed_oz'] = 1} },
		{ ['gummy_grape'] 			= { ['gummymould'] = 1,  ['gelatine'] = 3, ['sugar'] = 3, ['malmo_weed_oz'] = 1} },
		{ ['gummy_applering'] 		= { ['gummymould'] = 1,  ['gelatine'] = 3, ['sugar'] = 3, ['malmo_weed_oz'] = 1} },
		{ ['gummy_belt'] 			= { ['gummymould'] = 1,  ['gelatine'] = 3, ['sugar'] = 3, ['malmo_weed_oz'] = 1} },
	},
	Joints = {
		{ ['afghankush_joint'] = { ['rollingpapers'] = 1, ['afghankush_bud'] = 1, ['grinder'] = 1,} },
		{ ['bluedream_joint'] = { ['rollingpapers'] = 1, ['bluedream_bud'] = 1, ['grinder'] = 1, } },
		{ ['granddaddypurple_joint'] = { ['rollingpapers'] = 1, ['granddaddypurple_bud'] = 1, ['grinder'] = 1, } },
		{ ['greencrack_joint'] = { ['rollingpapers'] = 1, ['greencrack_bud'] = 1, ['grinder'] = 1, } },
		{ ['jackherrer_joint'] = { ['rollingpapers'] = 1, ['jackherrer_bud'] = 1, ['grinder'] = 1, } },
		{ ['sourdiesel_joint'] = { ['rollingpapers'] = 1, ['sourdiesel_bud'] = 1, ['grinder'] = 1, } },
		{ ['weddingcake_joint'] = { ['rollingpapers'] = 1, ['weddingcake_bud'] = 1, ['grinder'] = 1, } },
		{ ['whitewidow_joint'] = { ['rollingpapers'] = 1, ['whitewidow_bud'] = 1, ['grinder'] = 1, } },
	},
	Trimming = {
		{ ['afghankush_bud'] = { ['trimmers'] = 1, ['afghankush_crop'] = 1, } },
		{ ['bluedream_bud'] = { ['trimmers'] = 1, ['bluedream_crop'] = 1, } },
		{ ['granddaddypurple_bud'] = { ['trimmers'] = 1, ['granddaddypurple_crop'] = 1, } },
		{ ['greencrack_bud'] = { ['trimmers'] = 1, ['greencrack_crop'] = 1, } },
		{ ['jackherrer_bud'] = { ['trimmers'] = 1, ['jackherrer_crop'] = 1, } },
		{ ['sourdiesel_bud'] = { ['trimmers'] = 1, ['sourdiesel_crop'] = 1, } },
		{ ['weddingcake_bud'] = { ['trimmers'] = 1, ['weddingcake_crop'] = 1, } },
		{ ['whitewidow_bud'] = { ['trimmers'] = 1, ['whitewidow_crop'] = 1, } },
	},
	TableBong = {
        { ["afghankush_bud"] = { ["afghankush_bud"] = 1, ["lighter"] = 1, } },
        { ["bluedream_bud"] = { ["bluedream_bud"] = 1, ["lighter"] = 1,} },
        { ["granddaddypurple_bud"] = { ["granddaddypurple_bud"] = 1, ["lighter"] = 1,} },
        { ["greencrack_bud"] = { ["greencrack_bud"] = 1, ["lighter"] = 1, } },
        { ["jackherrer_bud"] = { ["jackherrer_bud"] = 1, ["lighter"] = 1, } },
        { ["sourdiesel_bud"] = { ["sourdiesel_bud"] = 1, ["lighter"] = 1,} },
        { ["weddingcake_bud"] = { ["weddingcake_bud"] = 1, ["lighter"] = 1,} },
        { ["whitewidow_bud"] = { ["whitewidow_bud"] = 1, ["lighter"] = 1,} },
    },
	Coffee = {
        { ["coffee"] = {} },
    },
	Strains = {
	StrainOne = { { ['bluedream_crop'] = { ['trimmers'] = 1, } }, },
	StrainTwo = { { ['granddaddypurple_crop'] = { ['trimmers'] = 1, } }, },
	StrainThree = {	{ ['greencrack_crop'] = { ['trimmers'] = 1, } }, },
	StrainFour = { { ['jackherrer_crop'] = { ['trimmers'] = 1, } }, },
	StrainFive = { { ['afghankush_crop'] = { ['trimmers'] = 1, } }, },
	StrainSix = { { ['sourdiesel_crop'] = { ['trimmers'] = 1, } }, },
	StrainSeven = { { ['weddingcake_crop'] = { ['trimmers'] = 1, } }, },
	StrainEight = {	{ ['whitewidow_crop'] = { ['trimmers'] = 1, } }, },
	},
}

if not Config.TrimmerRemove then -- statement to correct the recipes to not use trimmers, messy but 🤷‍♀️
	for k, v in pairs(Crafting.Trimming) do for l, b in pairs(v) do Crafting.Trimming[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainOne) do for l, b in pairs(v) do Crafting.Strains.StrainOne[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainTwo) do for l, b in pairs(v) do Crafting.Strains.StrainTwo[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainThree) do for l, b in pairs(v) do Crafting.Strains.StrainThree[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainFour) do for l, b in pairs(v) do Crafting.Strains.StrainFour[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainFive) do for l, b in pairs(v) do Crafting.Strains.StrainFive[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainSix) do for l, b in pairs(v) do Crafting.Strains.StrainSix[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainSeven) do for l, b in pairs(v) do Crafting.Strains.StrainSeven[k][l]["trimmers"] = nil end end
	for k, v in pairs(Crafting.Strains.StrainEight) do for l, b in pairs(v) do Crafting.Strains.StrainEight[k][l]["trimmers"] = nil end end
end

Loc = {}

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