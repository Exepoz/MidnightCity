local Size = {
	["wide"] = { 1024, 512 },
	["tall"] = { 256, 512 },
	["scrolling"] = { 1024, 2048 },
	["big"] = { 1024, 1024 },
	["medium"] = { 512, 512 },
}
--This is the list that loads at server start
--It's updated in server memory as people change them
--When ClearDui is run, it sets the url to "" making it load nothing

-- Default images
-- Targets for these are in dui.lua
local duiList = {}
if Config.Locations[1].MLO == "GN" then
	duiList = {
		["gn_tv_screen_b"] = { url = "-", size = Size["big"], texd = "gn_burgershot_graphi" },
		["gn_tv_screen_c"] = { url = "-", size = Size["big"], texd = "gn_burgershot_graphi" },
		["gn_tv_screen_d"] = { url = "-", size = Size["big"], texd = "gn_burgershot_graphi" },
		["gn_tv_screen_scrolling"] = { url = "-", size = Size["scrolling"], texd = "gn_burgershot_graphi" },
	}
elseif Config.Locations[1].MLO == "LP" then
	duiList = {
		["cj_bs_pos1"] = { url = "-", size = Size["medium"], texd = "bs_cj_bs_post" },
		["cj_bs_pos2"] = { url = "-", size = Size["medium"], texd = "bs_cj_bs_post" },
		["cj_bs_pos3"] = { url = "-", size = Size["medium"], texd = "bs_cj_bs_post" },
		["cj_bs_pos4"] = { url = "-", size = Size["medium"], texd = "bs_cj_bs_post" },
	}
elseif Config.Locations[1].MLO == "NP" then
	duiList = {
		--Exterior
		["bsjackie"] = { url = "-", size = Size["medium"], texd = "bs_ext_txd" },
		["bs_branding_waste"] = { url = "-", size = Size["wide"], texd = "bs_ext_txd" },

		--Interior
		["bs_branding_porkhole_tx"] = { url = "-", size = Size["wide"], texd = "bs_int_txd" },
		["bs_heartstopper_01"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_menu_01"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_menu_02"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_menu_03"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_menu_04"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_menu_05"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_bleeder_01"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
		["bs_mmeal_01"] = { url = "-", size = Size["tall"], texd = "bs_int_txd" },
	}
end

AddEventHandler('onResourceStart', function(r) if r ~= GetCurrentResourceName() then return end
	-- Tidier way of duplicating the original url at startup to make "presets"
	for k, v in pairs(duiList) do duiList[k].preset = duiList[k].url end
end)

RegisterServerEvent("jim-burgershot:Server:ChangeDUI", function(data)
	-- if no url given, "reset" it back to preset
	if not data.url then
		if Config.Debug then print("^5Debug^7: ^2Preset^7: ^6"..tostring(duiList[tostring(data.tex)].preset).."^7") end
		data.url = duiList[tostring(data.tex)].preset
		data.size = duiList[tostring(data.tex)].size
	end
	-- if it has a url, update server DUI list and send to players
	if Config.Debug then print("^5Debug^7: ^3DUI^2 Sending new DUI to all players^7 - ^6"..data.url.."^7") end
	duiList[tostring(data.tex)] = { url = data.url, preset = duiList[tostring(data.tex)].preset, size = data.size, texd = data.texd }
	TriggerClientEvent("jim-burgershot:ChangeDUI", -1, data)
end)
RegisterServerEvent("jim-burgershot:Server:ClearDUI", function(data)
	if data.url == "-" then duiList[data.tex].url = "-" end
	-- Clear the DUI from loading
	TriggerClientEvent("jim-burgershot:ClearDUI", -1, data)
end)

QBCore.Functions.CreateCallback('jim-burgershot:Server:duiList', function(source, cb) cb(duiList) end)