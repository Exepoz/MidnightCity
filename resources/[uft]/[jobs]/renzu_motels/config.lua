config = {}
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
			exit = vec3(-1.582336, -4.000572,  0.350227),
			stash = vec3(-2.330933, 1.047852, 0.983154),
			wardrobe = vec3(-2.280640, 2.751221, 1.049854),
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
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Pink Cage Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(313.38,-225.20,54.212),
		coord = vec3(326.04,-210.47,54.086), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(312.81, -219.11, 54.41), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(310.79, -218.33, 54.42),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(307.23, -216.97, 54.44),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(307.23, -213.19, 54.45),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(309.26, -207.85, 54.49),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(313.02, -197.99, 54.49),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = vector3(315.83, -194.56, 54.49),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(319.44, -195.94, 54.5),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(321.44, -196.71, 54.59),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
			[10] = {
				door = vector3(312.79, -219.14, 58.24),
				stash = vec3(347.33102416992,-205.13743591309,53.759078979492),
				wardrobe = vec3(351.68756103516,-205.30010986328,54.674419403076),
				fridge = vec3(349.34033203125,-206.6258392334,54.639694213867),
			},
			[11] = {
				door = vector3(310.75, -218.36, 58.26),
				stash = vec3(329.67590332031,-227.8233795166,57.556579589844),
				wardrobe = vec3(329.43222045898,-232.33073425293,58.42276763916),
				fridge = vec3(327.64138793945,-229.79788208008,58.355628967285),
			},
			[12] = {
				door = vector3(307.21, -217.0, 58.37),
				stash = vec3(339.79351806641,-224.86245727539,57.55553817749),
				wardrobe = vec3(344.26574707031,-225.00813293457,58.302909851074),
				fridge = vec3(341.6985168457,-226.52975463867,58.367748260498),
			},
			[13] = {
				door = vector3(307.24, -213.19, 58.33),
				stash = vec3(343.47412109375,-214.96145629883,57.55553817749),
				wardrobe = vec3(348.07550048828,-215.08416748047,58.288040161133),
				fridge = vec3(345.40502929688,-216.88189697266,58.281555175781),
			},
			[14] = {
				door = vector3(309.26, -207.91, 58.3),
				stash = vec3(347.12841796875,-205.05494689941,57.55553817749),
				wardrobe = vec3(351.77719116211,-205.24267578125,58.351734161377),
				fridge = vec3(349.24819946289,-206.78134155273,58.326892852783),
			},

		},
	},
	[2] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'sandy', -- shell type, configure only if using Mlo = true
		label = 'Sandy Shores Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1500, -- cost per period
		businessprice = 100000000,
		motel = 'sandyshores',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(1499.11, 3571.97, 34.66),
		coord = vec3(1498.11, 3573.50, 35.36), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(1512.39, 3567.53, 35.58), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(1520.35, 3572.12, 35.67),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(1522.05, 3573.11, 35.67),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(1530.01, 3577.69, 35.7),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(1536.61, 3581.51, 35.74),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(1544.56, 3586.1, 35.69),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = vector3(1546.27, 3587.09, 35.73),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(1554.22, 3591.67, 35.73),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(1558.13, 3593.94, 35.77),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
			[10] = {
				door = vector3(1566.08, 3598.52, 35.79),
				stash = vec3(347.33102416992,-205.13743591309,53.759078979492),
				wardrobe = vec3(351.68756103516,-205.30010986328,54.674419403076),
				fridge = vec3(349.34033203125,-206.6258392334,54.639694213867),
			},
		},
	},
	[3] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Southside Motel',
		rental_period = 'day',-- hour, day, month
		rate = 800, -- cost per period
		businessprice = 1000000,
		motel = 'southside',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(462.74, -1574.29, 29.28),
		coord = vec3(462.74, -1574.29, 28.28), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = false, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = vector3(466.79, -1590.6, 33.18), -- Door requires when using MLO/Shells
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = vector3(460.8, -1585.57, 33.22),
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = vector3(454.73, -1580.47, 33.18),
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = vector3(460.33, -1573.23, 33.26),
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = vector3(465.42, -1567.16, 33.26),
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = vector3(470.5, -1561.11, 33.33),
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = vector3(441.99, -1569.89, 33.19),
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = vector3(435.99, -1564.77, 33.31),
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = vector3(430.0, -1559.66, 33.33),
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
		},
	},
}
config.extrafunction = {
	['bed'] = function(data,identifier)
		TriggerEvent('luckyme')
	end,
	['fridge'] = function(data,identifier)
		TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'fridge_'..data.motel..'_'..identifier..'_'..data.index, name = 'Fridge', slots = 30, weight = 20000, coords = GetEntityCoords(cache.ped)})
	end,
	['exit'] = function(data)
		local coord = LocalPlayer.state.lastloc or vec3(data.coord.x,data.coord.y,data.coord.z)
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SendNUIMessage({
			type = 'door'
		})
		return Teleport(coord.x,coord.y,coord.z,0.0,true)
	end,
}

config.Text = {
	['stash'] = 'Stash',
	['fridge'] = 'My Fridge',
	['wardrobe'] = 'Wardrobe',
	['bed'] = 'Sleep',
	['door'] = 'Lock/Unlock Door',
	['exit'] = 'Exit',
}

config.icons = {
	['door'] = 'fas fa-door-open',
	['stash'] = 'fas fa-box',
	['wardrobe'] = 'fas fa-tshirt',
	['fridge'] = 'fas fa-ice-cream',
	['bed'] = 'fas fa-bed',
	['exit'] = 'fas fa-door-open',
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