config = {}
local QBCore = exports['qb-core']:GetCoreObject()

config.wardrobe = 'illenium-appearance' -- choose your skin menu
config.target = true -- false = markers zones type. true = ox_target, qb-target
config.business = false -- allowed players to purchase the motel
config.autokickIfExpire = true -- auto kick occupants if rent is due. if false owner of motel must kick the occupants
config.breakinJobs = { -- jobs can break in to door using gunfire in doors
	['police'] = true,

}
config.wardrobes = { -- skin menus
	['renzu_clothes'] = function()
		exports.renzu_clothes:OpenClotheInventory()
	end,
	['fivem-appearance'] = function()
		return exports['fivem-appearance']:startPlayerCustomization() -- you could replace this with outfits events
	end,
	['illenium-appearance'] = function()
		return TriggerEvent('illenium-appearance:client:openOutfitMenu')
	end,
	['qb-clothing'] = function()
		return TriggerEvent('qb-clothing:client:openOutfitMenu')
	end,
	['esx_skin'] = function()
		TriggerEvent('esx_skin:openSaveableMenu')
	end,
}

-- Shells Offsets and model name
config.shells = {
	['standard'] = {
		shell = `standardmotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(-0.43,-2.51,1.16),
			stash = vec3(1.368164, -3.134506, 1.16),
			wardrobe = vec3(1.643646, 2.551102, 1.16),
			bed = vector3(0.016541, -0.131332, 1.16),
			--bedexit = vector3(0.016541, -0.131332, 1.16),
		}
	},
	['modern'] = {
		shell = `modernmotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(5.410095, 4.299301, 0.9),
			stash = vec3(-4.068207, 4.046188, 0.9),
			wardrobe = vec3(2.811829, -3.619385, 0.9),
		}
	},
	['sandy'] = {
		shell = `furnitured_motel`, -- kambi shell
		offsets = {
			exit = vec3(-1.582336, -4.000572,  0.983154),
			stash = vec3(-2.330933, 1.047852, 0.983154),
			wardrobe = vec3(-2.280640, 2.751221, 1.049854),
			bed = vector3(1.100739, -0.516479, 0.983154),
		}
	},
}

config.messageApi = function(data) -- {title,message,motel}
	local motel = GlobalState.Motels[data.motel]
	local identifier = motel.owned -- owner identifier
	-- add your custom message here. ex. SMS phone

	-- basic notification (remove this if using your own message system)
	local success = lib.callback.await('renzu_motels:MessageOwner',false,{identifier = identifier, message = data.message, title = data.title, motel = data.motel})
	if success then
		Notify('message has been sent', 'success')
	else
		Notify('message fail  \n  owner is not available yet', 'error')
	end
end

-- @shell string (shell type)
-- @Mlo string ( toggle MLO or shell type)
-- @hour_rate int ( per hour rates)
-- @motel string (Motel Index Name)
-- @rentcoord vec3 (coordinates of Rental Menu)
-- @radius float ( total size radius of motel )
-- @maxoccupants int (total player can rent in each Rooms)
-- @uniquestash bool ( Toggle Non Sharable / Stealable Stash Storage )
-- @doors table ( lists of doors feature coordinates. ex. stash, wardrobe) wardrobe,stash coords are only applicable in Mlo. using shells has offsets for stash and wardrobes.
-- @manual boolean ( accept walk in occupants only )
-- @businessprice int ( value of motel)
-- @door int (door hash or doormodel `model`) for MLO type

config.motels = {
	[1] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = true, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Pink Cage Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vector3(317.7, -223.84, 53.06),
		coord = vec3(326.04,-210.47,54.086), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 1, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
			door = vector3(307.07, -213.16, 54.04), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				bed = vector3(307.08, -205.3, 53.68),
				bedexit = vector3(307.08, -205.3, 53.68),
				-- fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(310.84, -203.28, 54.46),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				bed = vector3(310.91, -195.57, 53.71),
				bedexit = vector3(310.91, -195.57, 53.71),
				-- fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(315.97, -194.43, 54.56),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				bed = vector3(323.73, -194.46, 53.71),
				bedexit = vector3(323.73, -194.46, 53.71),
				-- fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(314.8, -220.06, 58.24),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				bed = vector3(306.95, -219.99, 57.51),
				bedexit = vector3(306.95, -219.99, 57.51),
				-- fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(307.05, -213.22, 58.25),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				bed = vector3(307.1, -205.39, 57.5),
				bedexit = vector3(307.1, -205.39, 57.5),
				-- fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(310.85, -203.32, 58.28),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				-- fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
				bed = vec3(312.05, -195.96, 57.51),
				bedexit = vec3(312.05, -195.96, 57.51),
			},
			[7] = {
				door = vector3(315.89, -194.36, 58.25),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				bed = vec3(323.26, -195.45, 57.51),
				bedexit = vec3(323.26, -195.45, 57.51)
				-- fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(339.59, -219.58, 54.39),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				bed = vector3(339.52, -227.41, 53.71),
				bedexit = vector3(339.52, -227.41, 53.71),
				-- fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(343.4, -209.68, 54.44),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				bed = vector3(342.96, -217.29, 53.71),
				bedexit = vector3(342.96, -217.29, 53.71),
				-- fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
			[10] = {
				door = vector3(347.18, -199.83, 54.66),
				stash = vec3(347.33102416992,-205.13743591309,53.759078979492),
				wardrobe = vec3(351.68756103516,-205.30010986328,54.674419403076),
				bed = vector3(346.92, -207.44, 53.71),
				bedexit = vector3(346.92, -207.44, 53.71),
				-- fridge = vec3(349.34033203125,-206.6258392334,54.639694213867),
			},
			[11] = {
				door = vector3(334.92, -227.8, 58.22),
				stash = vec3(329.67590332031,-227.8233795166,57.556579589844),
				wardrobe = vec3(329.43222045898,-232.33073425293,58.42276763916),
				bed = vector3(327.12, -227.64, 57.51),
				bedexit = vector3(327.12, -227.64, 57.51),
				-- fridge = vec3(327.64138793945,-229.79788208008,58.355628967285),
			},
			[12] = {
				door = vector3(339.6, -219.56, 58.24),
				stash = vec3(339.79351806641,-224.86245727539,57.55553817749),
				wardrobe = vec3(344.26574707031,-225.00813293457,58.302909851074),
				bed = vector3(339.53, -227.34, 57.51),
				bedexit = vector3(339.53, -227.34, 57.51),
				-- fridge = vec3(341.6985168457,-226.52975463867,58.367748260498),
			},
			[13] = {
				door = vector3(343.38, -209.71, 58.22),
				stash = vec3(343.47412109375,-214.96145629883,57.55553817749),
				wardrobe = vec3(348.07550048828,-215.08416748047,58.288040161133),
				bed = vector3(343.08, -217.31, 57.51),
				bedexit = vector3(343.08, -217.31, 57.51),
				-- fridge = vec3(345.40502929688,-216.88189697266,58.281555175781),
			},
			[14] = {
				door = vector3(347.18, -199.81, 58.21),
				stash = vec3(347.12841796875,-205.05494689941,57.55553817749),
				wardrobe = vec3(351.77719116211,-205.24267578125,58.351734161377),
				bed = vector3(347.13, -207.52, 57.51),
				bedexit = vector3(347.13, -207.52, 57.51),
				-- fridge = vec3(349.24819946289,-206.78134155273,58.326892852783),
			},

		},
	},
	[2] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'sandy', -- shell type, configure only if using Mlo = true
		label = 'Sandy Shores Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'sandyshores',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(1499.11, 3571.97, 34.66),
		coord = vec3(1498.11, 3573.50, 35.36), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 1, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(1512.39, 3567.53, 35.58), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				-- fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(1520.35, 3572.12, 35.67),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				-- fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(1522.05, 3573.11, 35.67),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				-- fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(1530.01, 3577.69, 35.7),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				-- fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(1536.61, 3581.51, 35.74),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				-- fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(1544.56, 3586.1, 35.69),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				-- fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = vector3(1546.27, 3587.09, 35.73),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				-- fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(1554.22, 3591.67, 35.73),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				-- fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(1558.13, 3593.94, 35.77),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				-- fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
			[10] = {
				door = vector3(1566.08, 3598.52, 35.79),
				stash = vec3(347.33102416992,-205.13743591309,53.759078979492),
				wardrobe = vec3(351.68756103516,-205.30010986328,54.674419403076),
				-- fridge = vec3(349.34033203125,-206.6258392334,54.639694213867),
			},
		},
	},
	[3] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'sandy', -- shell type, configure only if using Mlo = true
		label = 'Southside Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'southside',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(462.74, -1574.29, 29.28),
		coord = vec3(462.74, -1574.29, 28.28), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 1, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(466.79, -1590.6, 33.18), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				-- fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(460.8, -1585.57, 33.22),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				-- fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(454.73, -1580.47, 33.18),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				-- fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(460.33, -1573.23, 33.26),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				-- fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(465.42, -1567.16, 33.26),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				-- fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(470.5, -1561.11, 33.33),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				-- fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = vector3(441.99, -1569.89, 33.19),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				-- fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(435.99, -1564.77, 33.31),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				-- fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(430.0, -1559.66, 33.33),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				-- fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
		},
	},
	[4] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = true, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'BillingsGate', -- shell type, configure only if using Mlo = true
		label = 'BillingsGate Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'BillingGates',
		payment = 'money', -- money, bank
		door = -2000212373, -- door hash for MLO type
		rentcoord = vector3(569.25, -1746.5, 29.21),
		coord = vector3(560.09, -1761.51, 28.17), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 1, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(560.89, -1752.0, 29.48), -- Door requires when using MLO/Shells
				stash = vector3(562.73, -1746.37, 29.09), --  requires when using MLO
				wardrobe = vector3(559.01, -1744.07, 29.56), --  requires when using MLO
			     bed = vector3(560.25, -1746.47, 28.99),
				bedexit = vector3(560.25, -1746.47, 28.99),
				 -- fridge = vector3(557.91, -1746.56, 29.46), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(557.23, -1759.87, 29.5),
				stash = vector3(559.05, -1754.35, 29.13),
				wardrobe = vector3(555.36, -1751.9, 29.69),
				bed = vector3(556.6, -1754.33, 28.99),
				bedexit = vector3(556.6, -1754.33, 28.99),
				-- fridge = vector3(554.22, -1754.46, 29.46),
			},
			[3] = {
				door = vector3(553.4, -1768.08, 29.52),
				stash = vector3(555.18, -1762.55, 29.11),
				wardrobe = vector3(551.54, -1760.1, 29.42),
				bed = vector3(552.72, -1762.58, 28.99),
				bedexit = vector3(552.72, -1762.58, 28.99),
				-- fridge = vector3(550.39, -1762.69, 29.44),
			},
			[4] = {
				door = vector3(549.65, -1776.12, 29.53),
				stash = vector3(551.48, -1770.5, 29.13),
				wardrobe = vector3(547.77, -1768.18, 29.45),
				bed = vector3(549.04, -1770.59, 28.99),
				bedexit = vector3(549.04, -1770.59, 28.99),
				-- fridge = vector3(546.63, -1770.73, 29.4),
			},
			[5] = {
				door = vector3(556.73, -1776.62, 33.73),
				stash = vector3(551.22, -1774.74, 33.28),
				wardrobe = vector3(548.66, -1778.44, 33.68),
				bed = vector3(551.18, -1777.23, 33.15),
				bedexit = vector3(551.18, -1777.23, 33.15),
				-- fridge = vector3(551.27, -1779.61, 33.49),
			},
			[6] = {
				door = vector3(549.33, -1771.27, 33.9),
				stash = vector3(551.22, -1765.69, 33.28),
				wardrobe = vector3(547.5, -1763.24, 33.63),
				bed = vector3(548.73, -1765.73, 33.15),
				bedexit = vector3(548.73, -1765.73, 33.15),
				-- fridge = vector3(546.35, -1765.81, 33.59),
			},
			[7] = {
				door = vector3(553.18, -1763.02, 33.69),
				stash = vector3(555.07, -1757.46, 33.28),
				wardrobe = vector3(551.33, -1755.02, 33.65),
				bed = vector3(552.57, -1757.48, 33.15),
				bedexit = vector3(552.57, -1757.48, 33.15),
				-- fridge = vector3(550.2, -1757.56, 33.6),
			},
			[8] = {
				door = vector3(556.87, -1755.11, 33.74),
				stash = vector3(558.63, -1749.64, 33.28),
				wardrobe = vector3(555.02, -1747.1, 33.65),
				bed = vector3(556.23, -1749.63, 33.15),
				bedexit = vector3(556.23, -1749.63, 33.15),
				-- fridge = vector3(553.86, -1749.71, 33.57),

			},
		},
	},
	[5] = { -- index name of motel
	manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
	Mlo = true, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
	shell = 'TheMotorMotel', -- shell type, configure only if using Mlo = true
	label = 'The Motor Motel',
	rental_period = 'day',-- hour, day, month
	rate = 1000, -- cost per period
	businessprice = 1000000,
	motel = 'The Motor Motel',
	payment = 'money', -- money, bank
	door = 1025591431, -- door hash for MLO type
	rentcoord = vector3(1141.52, 2664.26, 37.16),
	coord = vector3(1126.62, 2654.0, 37.0), -- center of the motel location
	radius = 50.0, -- radius of motel location
	maxoccupants = 1, -- maximum renters per room
	uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
	doors = { -- doors and other function of each rooms
		[1] = { -- COORDINATES FOR GABZ PINKCAGE
			door = vector3(1142.8, 2654.69, 38.35), -- Door requires when using MLO/Shells
			stash = vector3(1147.65, 2655.59, 37.73), --  requires when using MLO
			wardrobe = vector3(1145.32, 2656.18, 38.25), --  requires when using MLO
			bed = vector3(1144.81, 2652.39, 37.73),
			bedexit = vector3(1144.81, 2652.39, 37.73),
			-- fridge = vector3(1149.78, 2650.64, 38.27), --  requires when using MLO
			-- luckyme = vec3(0.0,0.0,0.0) -- extra
		},
		[2] = {
			door = vector3(1142.75, 2647.76, 38.33),
			stash = vector3(1151.77, 2643.57, 39.35),
			wardrobe = vector3(1145.56, 2649.21, 38.32),
			bed = vector3(1144.83, 2645.28, 37.73),
			bedexit = vector3(1144.83, 2645.28, 37.73),
			-- fridge = vector3(1149.7, 2643.67, 38.34),
		},
		[3] = {
			door = vector3(1141.18, 2641.22, 38.35),
			stash = vector3(1137.05, 2632.7, 39.35),
			wardrobe = vector3(1142.69, 2638.99, 38.39),
			bed = vector3(1138.63, 2639.21, 37.73),
			bedexit = vector3(1138.63, 2639.21, 37.73),
			-- fridge = vector3(1137.15, 2634.24, 38.2),
		},
		[4] = {
			door = vector3(1134.19, 2641.22, 38.46),
			stash = vector3(1135.13, 2636.28, 37.71),
			wardrobe = vector3(1135.73, 2638.9, 38.34),
			bed = vector3(1131.94, 2639.18, 37.72),
			bedexit = vector3(1131.94, 2639.18, 37.72),
			-- fridge = vector3(1130.19, 2634.2, 38.32),
		},
		[5] = {
			door = vector3(1124.1, 2641.22, 38.28),
			stash = vector3(1125.01, 2636.31, 37.85),
			wardrobe = vector3(1125.63, 2638.75, 38.46),
			bed = vector3(1121.92, 2639.16, 37.73),
			bedexit = vector3(1121.92, 2639.16, 37.73),
			-- fridge = vector3(1120.09, 2634.31, 38.32),
		},
		[6] = {
			door = vector3(1117.15, 2641.22, 38.32),
			stash = vector3(1113.03, 2632.7, 39.26),
			wardrobe = vector3(1118.67, 2638.79, 38.4),
			bed = vector3(1114.88, 2639.18, 37.73),
			bedexit = vector3(1114.88, 2639.18, 37.73),
			-- fridge = vector3(1113.13, 2634.27, 38.3),
		},
		[7] = {
			door = vector3(1110.21, 2641.22, 38.33),
			stash = vector3(1106.06, 2632.55, 39.24),
			wardrobe = vector3(1111.7, 2638.84, 38.34),
			bed = vector3(1107.88, 2639.19, 37.73),
			bedexit = vector3(1107.88, 2639.19, 37.73),
			-- fridge = vector3(1106.16, 2634.24, 38.36),
		},
		[8] = {
			door = vector3(1105.66, 2644.35, 38.45),
			stash = vector3(1097.08, 2648.5, 39.23),
			wardrobe = vector3(1103.16, 2642.86, 38.28),
			bed = vector3(1103.77, 2646.64, 37.73),
			bedexit = vector3(1103.77, 2646.64, 37.73),
			-- fridge = vector3(1098.73, 2648.4, 38.31),
		},
		[9] = {
			door = vector3(1105.66, 2651.32, 38.32),
			stash = vector3(1096.98, 2655.48, 39.35),
			wardrobe = vector3(1103.31, 2649.84, 38.23),
			bed = vector3(1103.77, 2653.72, 37.73),
			bedexit =vector3(1103.77, 2653.72, 37.73),
			-- fridge = vector3(1098.72, 2655.38, 38.27),

	    	},
	    },
	},
	[6] = { -- index name of motel
	manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
	Mlo = true, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
	shell = 'CrownJewels', -- shell type, configure only if using Mlo = true
	label = 'Crown Jewels Motel',
	rental_period = 'day',-- hour, day, month
	rate = 1000, -- cost per period
	businessprice = 1000000,
	motel = 'Crown Jewels Motel',
	payment = 'money', -- money, bank
	door = -1002994035, -- door hash for MLO type
	rentcoord = vector3(-1340.27, -939.24, 12.37),
	coord = vector3(-1327.92, -935.79, 10.35), -- center of the motel location
	radius = 50.0, -- radius of motel location
	maxoccupants = 1, -- maximum renters per room
	uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
	doors = { -- doors and other function of each rooms
		[1] = { -- COORDINATES FOR GABZ PINKCAGE
			door = vector3(-1310.77, -932.38, 13.51), -- Door requires when using MLO/Shells
			stash = vector3(-1310.35, -936.69, 13.14), --  requires when using MLO
			wardrobe = vector3(-1307.48, -934.62, 13.04), --  requires when using MLO
			bed = vector3(-1308.28, -936.91, 12.9),
			bedexit = vector3(-1308.28, -936.91, 12.9),
			-- fridge = vector3(-1312.25, -934.36, 13.18), --  requires when using MLO
			-- luckyme = vec3(0.0,0.0,0.0) -- extra
		},
		[2] = {
			door = vector3(-1316.76, -934.56, 13.62),
			stash = vector3(-1316.28, -938.86, 13.15),
			wardrobe = vector3(-1313.46, -936.77, 12.94),
			bed = vector3(-1314.29, -939.11, 12.9),
			bedexit = vector3(-1314.29, -939.11, 12.9),
			-- fridge = vector3(-1318.19, -936.51, 13.18),
		},
		[3] = {
			door = vector3(-1329.23, -939.1, 12.62),
			stash = vector3(-1328.86, -943.35, 12.17),
			wardrobe = vector3(-1325.93, -941.32, 11.94),
			bed = vector3(-1326.54, -943.54, 11.87),
			bedexit = vector3(-1326.54, -943.54, 11.87),
			-- fridge = vector3(-1330.69, -941.12, 12.16),
		},
		[4] = {
			door = vector3(-1335.16, -941.26, 12.51),
			stash = vector3(-1334.73, -945.51, 12.13),
			wardrobe = vector3(-1331.88, -943.47, 11.92),
			bed = vector3(-1332.61, -945.74, 11.89),
			bedexit = vector3(-1332.61, -945.74, 11.89),
			-- fridge = vector3(-1336.62, -943.26, 12.18),
		},
		[5] = {
			door = vector3(-1310.78, -932.38, 16.61),
			stash = vector3(-1310.35, -936.73, 16.19),
			wardrobe = vector3(-1307.52, -934.61, 16.0),
			bed = vector3(-1308.24, -936.71, 15.9),
			bedexit = vector3(-1308.24, -936.71, 15.9),
			-- fridge = vector3(-1312.24, -934.43, 16.19),
		},
		[6] = {
			door = vector3(-1316.69, -934.53, 16.55),
			stash = vector3(-1316.3, -938.85, 16.19),
			wardrobe = vector3(-1313.44, -936.83, 15.97),
			bed = vector3(-1314.18, -938.85, 15.9),
			bedexit = vector3(-1314.18, -938.85, 15.9),
			-- fridge = vector3(-1318.25, -936.6, 16.19),
		},
		[7] = {
			door = vector3(-1329.2, -939.07, 15.64),
			stash = vector3(-1328.77, -943.37, 15.17),
			wardrobe = vector3(-1325.94, -941.29, 14.95),
			bed = vector3(-1326.57, -943.51, 14.9),
			bedexit = vector3(-1326.57, -943.51, 14.9),
			-- fridge = vector3(-1330.75, -941.0, 15.19),
		},
		[8] = {
			door = vector3(-1335.19, -941.26, 15.67),
			stash = vector3(-1334.68, -945.6, 15.16),
			wardrobe = vector3(-1331.88, -943.45, 14.93),
			bed = vector3(-1332.57, -945.41, 14.9),
			bedexit = vector3(-1332.57, -945.41, 14.9),
			-- fridge = vector3(-1336.58, -943.29, 15.19),

		}
	 }
  }

}
config.extrafunction = {
	['bed'] = function(data,identifier,kvp)
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		local str
		for _, v in pairs(config.motels) do if v.motel == data.motel then str = " "..v.label break end end
		TriggerServerEvent('nighttime:GoToBed', str)
	end,
	['fridge'] = function(data,identifier)
		TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'fridge_'..data.motel..'_'..identifier..'_'..data.index, name = 'Fridge', slots = 30, weight = 20000, coords = GetEntityCoords(cache.ped)})
	end,
	['exit'] = function(data)
		local coord = LocalPlayer.state.lastloc or vec3(data.coord.x,data.coord.y,data.coord.z)
		if data.Mlo then coord = GetOffsetFromEntityInWorldCoords(GetClosestObjectOfType(data.coord.x,data.coord.y,data.coord.z, 1.0, data.door, 0, 0, 0), 0,-0.5,0) end
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		return Teleport(coord.x,coord.y,coord.z,0.0,true)
	end,
	['bedexit'] = function(data)
		local d_coords
		for k, v in pairs(config.motels) do if v.motel == data.motel then d_coords = v.doors[data.index].door break end end
		local coord = vec3(d_coords.x,d_coords.y,d_coords.z)
		if data.Mlo then coord = GetOffsetFromEntityInWorldCoords(GetClosestObjectOfType(d_coords.x,d_coords.y,d_coords.z, 1.0, data.door, 0, 0, 0), 0,-0.75,0) end
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		return Teleport(coord.x,coord.y,coord.z,0.0, not data.Mlo)
	end,
}

config.Text = {
	['stash'] = 'Stash',
	['fridge'] = 'My Fridge',
	['wardrobe'] = 'Wardrobe',
	['bed'] = 'Sleep (Exit Game)',
	['door'] = 'Lock/Unlock Door',
	['exit'] = 'Exit',
	['bedexit'] = 'Leave Room (Stuck in Room)',
}

config.icons = {
	['door'] = 'fas fa-door-open',
	['stash'] = 'fas fa-box',
	['wardrobe'] = 'fas fa-tshirt',
	['fridge'] = 'fas fa-ice-cream',
	['bed'] = 'fas fa-bed',
	['exit'] = 'fas fa-door-open',
	['bedexit'] = 'fas fa-door-open',
}

config.stashblacklist = {
	['stash'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			water = true,
		},
	},
	['fridge'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			WEAPON_PISTOL = true,
		},
	},
}

PlayerData,ESX,QBCORE,zones,shelzones,blips = {},nil,nil,{},{},{}

function import(file)
	local name = ('%s.lua'):format(file)
	local content = LoadResourceFile(GetCurrentResourceName(),name)
	local f, err = load(content)
	return f()
end

if GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
	QBCORE = exports['qb-core']:GetCoreObject()
end