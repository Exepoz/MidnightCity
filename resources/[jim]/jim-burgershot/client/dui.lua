-- Dont touch these
local inZone
local Targets = {}
local txd = CreateRuntimeTxd('burgTxd')
local dui = {}
local duiList = {}
local Size = {
	["wide"] = { 1024, 512 },
	["tall"] = { 256, 512 },
	["scrolling"] = { 1024, 2048 },
	["big"] = { 1024, 1024 },
	["medium"] = { 512, 512 },
}

-- Set this the lowest job grade that can change the images.
-- Default is 4 - "Boss"
local JobGrade = { ["burgershot"] = 4, ["police"] = 4, }

-- This list is used to set up the targets, and hold other information
-- Default images are in duiserver.lua
local PresetList
if Config.Locations[1].MLO == "GN" then
	PresetList = {
		{ coords = vec3(-1194.07, -898.48, 15.97), radius = 0.6, tex = { texd = "gn_burgershot_graphi", texn = "gn_tv_screen_b", size = Size["big"], }, },
		{ coords = vec3(-1195.8, -895.76, 15.97), radius = 0.6, tex = { texd = "gn_burgershot_graphi", texn = "gn_tv_screen_c", size = Size["big"], }, },
		{ coords = vec3(-1194.93, -897.13, 15.97), radius = 0.6, tex = { texd = "gn_burgershot_graphi", texn = "gn_tv_screen_scrolling", size = Size["scrolling"], }, },
		{ coords = vec3(-1196.73, -894.39, 15.97), radius = 0.6, tex = { texd = "gn_burgershot_graphi", texn = "gn_tv_screen_d", size = Size["big"], }, },
	}
elseif Config.Locations[1].MLO == "LP" then
	PresetList = {
		{ coords = vec3(-1195.71, -891.03, 16.2), radius = 0.4, tex = { texd = "bs_cj_bs_post", texn = "cj_bs_pos1", size = Size["medium"], }, },
		{ coords = vec3(-1194.73, -892.36, 16.2), radius = 0.4, tex = { texd = "bs_cj_bs_post", texn = "cj_bs_pos2", size = Size["medium"], }, },
		{ coords = vec3(-1195.22, -891.68, 16.2), radius = 0.4, tex = { texd = "bs_cj_bs_post", texn = "cj_bs_pos4", size = Size["medium"], }, },
		{ coords = vec3(-1196.12, -890.36, 16.2), radius = 0.4, tex = { texd = "bs_cj_bs_post", texn = "cj_bs_pos3", size = Size["medium"], }, },
	}
elseif Config.Locations[1].MLO == "NP" then
	PresetList = {
		--Exterior
		{ coords = vec3(-1203.64, -887.29, 14.45), radius = 1.4, tex = { texd = "bs_ext_txd", texn = "bsjackie", size = Size["medium"], }, },
		{ coords = vec3(-1184.3, -904.93, 17.3), radius = 0.6, tex = { texd = "bs_ext_txd", texn = "bs_branding_waste", size = Size["wide"], }, },

		--Interior
		{ coords = vec3(-1198.00, -891.21, 15.0), radius = 0.7, tex = { texd = "bs_int_txd", texn = "bs_branding_porkhole_tx", size = Size["wide"], }, },
		{ coords = vec3(-1195.67, -892.35, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_menu_01", size = Size["tall"], }, },
		{ coords = vec3(-1196.09, -891.73, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_menu_02", size = Size["tall"], }, },
		{ coords = vec3(-1195.22, -892.96, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_menu_03", size = Size["tall"], }, },
		{ coords = vec3(-1193.19, -896.02, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_menu_04", size = Size["tall"], }, },
		{ coords = vec3(-1193.60, -895.42, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_menu_05", size = Size["tall"], }, },
		{ coords = vec3(-1194.00, -894.80, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_mmeal_01", size = Size["tall"], }, },
		{ coords = vec3(-1194.81, -893.57, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_heartstopper_01", size = Size["tall"], }, },
		{ coords = vec3(-1196.48, -891.12, 16.3), radius = 0.34, tex = { texd = "bs_int_txd", texn = "bs_bleeder_01", size = Size["tall"], }, },
	}
else PresetList = {} end
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	local p = promise.new()
	QBCore.Functions.TriggerCallback('jim-burgershot:Server:duiList', function(cb) p:resolve(cb) end)
	duiList = Citizen.Await(p)
	if inZone then
		for k, v in pairs(duiList) do TriggerEvent("jim-burgershot:ChangeDUI", { url = v.url, tex = k, texd = v.texd, size = v.size }) end
	end
end)
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	local p = promise.new()
	QBCore.Functions.TriggerCallback('jim-burgershot:Server:duiList', function(cb) p:resolve(cb) end)
	duiList = Citizen.Await(p)
	if inZone then
		for k, v in pairs(duiList) do TriggerEvent("jim-burgershot:ChangeDUI", { url = v.url, tex = k, texd = v.texd, size = v.size }) end
	end
end)
CreateThread(function()
	BurgerShotDUI = PolyZone:Create({
			vec2(-1244.4434814453, -887.61370849609),
			vec2(-1171.2486572266, -836.91143798828),
			vec2(-1135.0057373047, -889.05285644531),
			vec2(-1214.6118164062, -936.40856933594)},
		{ name = "BurgerShotDUI", debugPoly = Config.Debug })

	--Polyzone to help update/optimze the loading
	BurgerShotDUI:onPlayerInOut(function(isPointInside)
		if isPointInside then inZone = true
			-- If in polyzone, grab new list from server side, and show new DUI's
			local p = promise.new() QBCore.Functions.TriggerCallback('jim-burgershot:Server:duiList', function(cb) p:resolve(cb) end)
			duiList = Citizen.Await(p)
			--print("DUILIST: "..json.encode(duiList))
			for k, v in pairs(duiList) do TriggerEvent("jim-burgershot:ChangeDUI", { url = v.url, tex = k, texd = v.texd, size = v.size }) end
		else inZone = false
			-- If outside polyzone, attempt to unload all DUI's to help optimization
			for k, v in pairs(duiList) do
				v.tex = k
				TriggerEvent("jim-burgershot:ClearDUI", v)
			end
			dui = {}
			duiList = {}
		end
	end)
	for k, v in pairs(PresetList) do
		Targets[v["tex"].texn] =
		exports['qb-target']:AddCircleZone(v["tex"].texn, v["coords"], v["radius"], { name=v["tex"].texn, debugPoly=Config.Debug, useZ=true, },
			{ options = {
					{ type = "client", event = "jim-burgershot:DuiSelect", icon = "fas fa-circle-check", label = Loc[Config.Lan].dui["add_image"], job = JobGrade, tex = v["tex"].texn, size = v["tex"].size, texd = v["tex"].texd  },
					{ type = "server", event = "jim-burgershot:Server:ChangeDUI", icon = "fas fa-circle-minus", label = Loc[Config.Lan].dui["reset_image"], job = JobGrade, tex = v["tex"].texn, texd = v["tex"].texd, },
					{ type = "server", event = "jim-burgershot:Server:ClearDUI", icon = "fas fa-circle-xmark", label = Loc[Config.Lan].dui["clear_image"], job = JobGrade, tex = v["tex"].texn, texd = v["tex"].texd, url = "-"  },
			}, distance = 4.0 })
	end
end)

RegisterNetEvent("jim-burgershot:DuiSelect", function(data)
	local image = "" if duiList[tostring(data.tex)] then
		image = "<center>- Current Image -<br>"..
				"<img src="..duiList[tostring(data.tex)].url.." width=150px onerror='this.onerror=null; this.remove();'><br>"..
				"Size: ["..tonumber(data.size[1])..", "..tonumber(data.size[2]).."]<br><br>"
		end
	local dialog = exports['qb-input']:ShowInput({
        header = image..Loc[Config.Lan].dui["new_url"],
        submitText = Loc[Config.Lan].dui["change"],
        inputs = { { type = 'text', isRequired = true, name = 'url', text = 'HTML Link' } } })
    if dialog then
        if not dialog.url then return end
		data.url = dialog.url
		--Scan the link to see if it has an image extention otherwise, stop here.
		local searchList = { "png", "jpg", "jpeg", "gif", "webp", "bmp" }
		--Scan the link for certain terms that will flag it and refuse to show it
		local banList = { "porn" } -- I dunno let me know what links people manage to find
		local searchFound = false
		for k,v in pairs(searchList) do	if string.find(tostring(data.url), tostring(v)) then searchFound = true	end end
		for k,v in pairs(banList) do if string.find(tostring(data.url), tostring(v)) then searchFound = false print("BANNED WORD: "..v) end end
        if searchFound then TriggerServerEvent('jim-burgershot:Server:ChangeDUI', data) end
    end
end)

RegisterNetEvent("jim-burgershot:ChangeDUI", function(data)
	if Config.Debug then print("Recieving new DUI - "..data.url) end
	if (dui[tostring(data.tex)] or inZone) and tostring(data.url) ~= "-" then
		TriggerEvent("jim-burgershot:ClearDUI", data)
		--Add DUI to table
		dui[tostring(data.tex)] = CreateDui(tostring(data.url), data.size[1], data.size[2])
		local duihandle = GetDuiHandle(dui[tostring(data.tex)])
		if GetDuiHandle(dui[tostring(data.tex)]) then
			--Generate a random texture name, so it doesn't load the same one every time
			local txname = tostring(data.tex)..math.random(1000,9999)
			local tx = CreateRuntimeTextureFromDuiHandle(txd, tostring(txname), duihandle)
			AddReplaceTexture(tostring(data.texd), tostring(data.tex), 'burgTxd', tostring(txname))
			if data.texd == "bs_int_txd" then
				AddReplaceTexture("bs_ext_txd", tostring(data.tex), 'burgTxd', tostring(txname))
			end
		end
	end
end)

RegisterNetEvent("jim-burgershot:ClearDUI", function(data)
	if dui[tostring(data.tex)] then
		if tostring(data.texd) == "bs_int_txd" then	RemoveReplaceTexture("bs_ext_txd", tostring(data.tex)) end
		RemoveReplaceTexture(tostring(data.texd), tostring(data.tex))
		DestroyDui(dui[tostring(data.tex)])
		dui[tostring(data.tex)] = nil
	end
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	if GetResourceState("qb-target") == "started" or GetResourceState("ox_target") == "started" then
		for k, v in pairs(duiList) do
			exports['qb-target']:RemoveZone(k)
			RemoveReplaceTexture(tostring(v.texd), tostring(k))
			if tostring(v.texd) == "bs_int_txd" then RemoveReplaceTexture("bs_ext_txd", tostring(k)) end
		end
	end
end)