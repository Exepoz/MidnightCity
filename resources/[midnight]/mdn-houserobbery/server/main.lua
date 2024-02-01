local QBCore = exports['qb-core']:GetCoreObject()
local CurrentQuests = {}
local Rewards = {}
local Quests = {
	[1] = {},
	[2] = {},
	[3] = {},
}

local jobStages = {
    [1] = {name = "Wait to receive the house's location.", isDone = false, id = 1},
    [2] = {name = "Enter the house.", isDone = false, id = 2},
    [3] = {name = "Loot the house.", isDone = false, id = 3},
    [4] = {name = "Leave the area & get back to Jhonny.", isDone = false, id = 4}
}

GlobalState.CompHRQuests = Quests

local webhook = 'https://discord.com/api/webhooks/1114994318554447882/MhekhZo-FmaKEcMNQWvsqUB7-iHmfSwwpa6vXmkej1Ga0bKcqfXVPKkb4gPsBGqw-rlS' -- Your Discord webhook for logs.

RegisterNetEvent('houseRob-receivenote', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('stickynote', 1, false, {label = "Fuck, people with big mouths spoke too much and the entire town knew about me! I'm losing the heat..."})
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['stickynote'], "add", 1)
end)

local policeJobs = {'police'}

local cooldownTimer = {}
local props = {
	['prop_micro_01'] = {item = 'microwave'},
	['prop_micro_02'] = {item = 'microwave'},
	['sf_prop_sf_esp_machine_01a'] = {item = 'coffeemaker'},
	['Prop_Tapeplayer_01'] = {item = 'tapeplayer'}
}

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local usedKeys = {}
		for i = 1, 3 do
			local kk = math.random(#Config.Quests)
			local k = Config.Quests[kk]
			while usedKeys[kk] do
				kk = math.random(#Config.Quests)
				k = Config.Quests[kk]
			end
			if not usedKeys[kk] then usedKeys[kk] = true end
			CurrentQuests[i] = {item = k.item, amount = k.amount[#k.amount]}
		end
		GlobalState.CurrentHRQuests = CurrentQuests
		Rewards = Config.CompletionRewards[math.random(#Config.CompletionRewards)]
		GlobalState.CompletionRewards = Rewards
	end
end)

RegisterNetEvent('av_houserobbery:server:extraRep', function()
	local src = source
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	local members = exports['qb-phone']:getGroupMembers(groupID)
	for k, v in pairs(members) do
		local Player = QBCore.Functions.GetPlayer(v)
		Player.Functions.SetMetaData('house_robbery_rep', Player.PlayerData.metadata.house_robbery_rep+1)
		TriggerClientEvent('QBCore:Notify', v, 'You earned extra reputation for grabbing everything inside the house!', 'success')
	end
end)


RegisterNetEvent('av_houserobbery:server:HandInBounty', function(rec_bounty, currentLvl)
	local src = source
	local bounty = CurrentQuests[rec_bounty]
	local Player = QBCore.Functions.GetPlayer(src)
	local item = Player.Functions.GetItemByName(bounty.item)
	local items = Player.Functions.GetItemsByName(bounty.item)
	local totAmount = 0
	if items then for _, v in pairs(items) do
		if bounty.item == 'lootbag' and v and Player.PlayerData.items[v.slot].info.type ~= 'houseRobbery' then item = false end
		totAmount = totAmount + v.amount
	end end
	if not item or totAmount == 0 then return TriggerClientEvent('QBCore:Notify', src, 'You do not have this item...', 'error') end
	if totAmount < bounty.amount then return TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough of this item...', 'error') end
	for _ = 1, bounty.amount do Player.Functions.RemoveItem(bounty.item, 1) end
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[bounty.item], "remove", bounty.amount)
	local repAmount = 1
	if bounty.item == 'lootbag' or bounty.item == 'malmo_laptop' then repAmount = 3 end
	if bounty.item == 'tv' then repAmount = 2 end
	if Config.Rep[currentLvl].double and math.random(100) <= 50 then
		TriggerClientEvent('QBCore:Notify', src, 'You got double the rewards for this bounty!', 'success')
		repAmount = repAmount * 2
	end
	local cid = Player.PlayerData.citizenid
	Quests[rec_bounty][cid] = true
	GlobalState.CompHRQuests = Quests
	local dBountyStr = ""
	if Quests[1][cid] and Quests[2][cid] and Quests[3][cid] then
		dBountyStr = " \n\n**Daily Bounties Completed!**\n**Reward :** "
		local rStr = ""
		TriggerClientEvent('QBCore:Notify', src, 'You gain an extra reputation for completing all bounties!', 'success')
		repAmount = repAmount + 1
		if Rewards.t == 'item' then
			Player.Functions.AddItem(Rewards.r, 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Rewards.r], "add")
			rStr = QBCore.Shared.Items[Rewards.r].label
		elseif Rewards.t == 'cash' then
			Player.Functions.AddMoney('cash', Rewards.r)
			rStr = "$"..Rewards.r
		elseif Rewards.t == 'xp' then
			repAmount = repAmount + Rewards.r
			rStr = Rewards.r.." Extra Reputation"
		end
		dBountyStr = dBountyStr..rStr
		Wait(1000)
		TriggerClientEvent('QBCore:Notify', src, 'Thank you, here\'s for the trouble. I will have an other list tomorrow.', 'success')
	end
	Player.Functions.SetMetaData('house_robbery_rep', Player.PlayerData.metadata.house_robbery_rep+repAmount)
	Wait(3000)
	TriggerClientEvent('QBCore:Notify', src, 'You gained a total of '..repAmount..' rep!', 'success')


	local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    local pName = firstName.." "..lastName
	local logString = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\n"..Player.PlayerData.citizenid.."\n\nBounty : "..QBCore.Shared.Items[bounty.item].label.."\nAmount : "..bounty.amount..dBountyStr.." \nRep Gained : "..repAmount.."\nTotal Rep : "..Player.PlayerData.metadata.house_robbery_rep+repAmount
	TriggerEvent("qb-log:server:CreateLog", "houseRob", "Bounty Handed In!", "green", {ply = GetPlayerName(src), txt = logString})
end)

RegisterNetEvent('av_houserobbery:server:InitCooldown', function()
	local src = source
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	local stages = exports['qb-phone']:getJobStages(groupID)
	if stages[2].isDone then return end

	stages[2].isDone = true
	exports['qb-phone']:setJobStatus(groupID, "House Robbery", stages)

	local members = exports['qb-phone']:getGroupMembers(groupID)
	local time = os.time()
	local pStr = 'Players :\n'
	local plys = {}
	for k, v in pairs(members) do
		TriggerClientEvent('av_houserobbery:client:groupSync', v, 'doorOpen')
		local Player = QBCore.Functions.GetPlayer(v)
		cooldownTimer[Player.PlayerData.citizenid] = time

		-- Give XP to player
		Player.Functions.SetMetaData('house_robbery_rep', Player.PlayerData.metadata.house_robbery_rep+Config.RepGains.doorUnlocked)

		-- Log String
		local charinfo = Player.PlayerData.charinfo
		local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
		if src == v then exports['qb-phone']:NotifyGroup(groupID, firstName.." has unlocked the door.", 'info') end
		local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
		local pName = firstName.." "..lastName.."\n"
		plys[#plys+1] = {"Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\n"..Player.PlayerData.citizenid}
		pStr = pStr..pName
	end


	local logString = pStr.."\nStarted a House Robbery"
	TriggerEvent("qb-log:server:CreateLog", "houseRob", "Robbery Started", "blue", {group = plys, txt = logString})
end)

RegisterNetEvent('av_houserobbery:server:lockpickFailed', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(Config.LockpickName, 1)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.LockpickName ], "remove")
end)

local function GenerateLoot(items)
    local total_prob = 0
    for _, item in ipairs(items) do
        total_prob = total_prob + item.probability
    end

    local total_weight = 0
    for _, item in ipairs(items) do
        item.weight = math.ceil(item.probability / total_prob * 100)
        total_weight = total_weight + item.weight
    end

    local chosenLoot = math.random(total_weight)
    local chosenItem
    for k, item in ipairs(items) do
        chosenLoot = chosenLoot - item.weight
        if chosenLoot <= 0 then chosenItem = k break end
    end

    return chosenItem
end

-- RegisterCommand('setHRRep', function(source, args)
-- 	local player = QBCore.Functions.GetPlayer(source)
-- 	player.Functions.SetMetaData('house_robbery_rep', tonumber(args[1]))
-- end)

RegisterServerEvent('av_houserobbery:item', function(tipo, trunk)
	local src = source
	local player = QBCore.Functions.GetPlayer(source)
	local itemStr = ""
	if tipo == 'random' then
		local currentLvl = trunk
		local lucky = GenerateLoot(Config.ItemsReward)
		local item = Config.ItemsReward[lucky]
		if item.item == 'cash' then
			local qty = math.random(item.amt.min, item.amt.max)
			player.Functions.AddMoney('cash',qty)
			TriggerClientEvent('QBCore:Notify', src, Config.Lang['money_found']..qty, 'success')
			itemStr = "\n\n**Item :** Cash\n**Amount :** "..qty
		else
			local qty = math.random(item.amt.min, item.amt.max)
			player.Functions.AddItem(item.item, qty)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add", qty)
			itemStr = "\n\n**Item :** "..QBCore.Shared.Items[item.item].label.."\n**Amount :** "..qty
		end
		local chance = Config.Rep[currentLvl] and Config.Rep[currentLvl].loot or 0
		if math.random(100) < chance then
			Wait(500)
			lucky = GenerateLoot(Config.ItemsReward)
			item = Config.ItemsReward[lucky]
			if item.item == 'cash' then
				local qty = math.random(item.amt.min, item.amt.max)
				player.Functions.AddMoney('cash',qty)
				TriggerClientEvent('QBCore:Notify', src, Config.Lang['money_found']..qty, 'success')
				itemStr = itemStr.."\n\n**Item :** Cash\n**Amount :** "..qty
			else
				local qty = math.random(item.amt.min, item.amt.max)
				player.Functions.AddItem(item.item, qty)
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.item], "add", qty)
				itemStr = itemStr.."\n\n**Item :** "..QBCore.Shared.Items[item.item].label.."\n**Amount :** "..qty
			end
		end
	elseif tipo == 'safe' then
		exports['mdn-extras']:GiveLootBag(src, 'houseRobbery')
		-- local info = { type = 'houseRobbery', typeName = 'House Robbery'}
		-- player.Functions.AddItem('lootbag', 1, false, info)
		-- TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lootbag'], "add")
		itemStr = "\n\n**Item :** "..QBCore.Shared.Items['lootbag'].label.."\n**Amount :** "..1
	elseif tipo == 'tv' then
		local trunkItems = exports['ps-inventory']:fetchTrunkItems(trunk.plate)
		local weight = 0
		if not trunkItems then return 0 end
		for _, item in pairs(trunkItems) do
			weight = weight + (item.weight * item.amount)
		end
		if weight + QBCore.Shared.Items['tv'].weight > trunk.maxweight then
			player.Functions.AddItem('tv', 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['tv'], "add")
			TriggerClientEvent('QBCore:Notify', src, 'The trunk is full!', 'error')
			itemStr = "\n\n**Item :** "..QBCore.Shared.Items['tv'].label.."\n**Amount :** "..1
		else
			for i = 1, trunk.slots, 1 do
				if trunkItems[i] == nil then
					trunkItems[i] = { name = 'tv', amount = 1, info = '', label = QBCore.Shared.Items['tv'].label, description = QBCore.Shared.Items['tv'].description, weight = QBCore.Shared.Items['tv'].weight, type = QBCore.Shared.Items['tv'].type, unique = QBCore.Shared.Items['tv'].unique, useable = QBCore.Shared.Items['tv'].useable, image = QBCore.Shared.Items['tv'].image, shouldClose = QBCore.Shared.Items['tv'].shouldClose, slot = i, combinable = QBCore.Shared.Items['tv'].combinable}
					TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['tv'], "add")
					TriggerClientEvent('QBCore:Notify', src, 'You place the TV in the trunk', 'info')
					itemStr = "\n\n**Item :** "..QBCore.Shared.Items['tv'].label.."\n**Amount :** "..1
					break
				end
			end
			exports['ps-inventory']:addTrunkItems(trunk.plate, trunkItems)
		end
	elseif tipo == 'telescope' then
			local trunkItems = exports['ps-inventory']:fetchTrunkItems(trunk.plate)
			local weight = 0
			if not trunkItems then return 0 end
			for _, item in pairs(trunkItems) do
				weight = weight + (item.weight * item.amount)
			end
			if weight + QBCore.Shared.Items['telescope'].weight > trunk.maxweight then
				player.Functions.AddItem('telescope', 1)
				TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['telescope'], "add")
				TriggerClientEvent('QBCore:Notify', src, 'The trunk is full!', 'error')
				itemStr = "\n\n**Item :** "..QBCore.Shared.Items['telescope'].label.."\n**Amount :** "..1
			else
				for i = 1, trunk.slots, 1 do
					if trunkItems[i] == nil then
						trunkItems[i] = { name = 'telescope', amount = 1, info = '', label = QBCore.Shared.Items['telescope'].label, description = QBCore.Shared.Items['telescope'].description, weight = QBCore.Shared.Items['telescope'].weight, type = QBCore.Shared.Items['telescope'].type, unique = QBCore.Shared.Items['telescope'].unique, useable = QBCore.Shared.Items['telescope'].useable, image = QBCore.Shared.Items['telescope'].image, shouldClose = QBCore.Shared.Items['telescope'].shouldClose, slot = i, combinable = QBCore.Shared.Items['telescope'].combinable}
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['telescope'], "add")
						TriggerClientEvent('QBCore:Notify', src, 'You place the telescope in the trunk', 'info')
						itemStr = "\n\n**Item :** "..QBCore.Shared.Items['telescope'].label.."\n**Amount :** "..1
						break
					end
				end
				exports['ps-inventory']:addTrunkItems(trunk.plate, trunkItems)
			end
	elseif tipo == 'art' then
		player.Functions.AddItem('art', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['art'], "add")
		itemStr = "\n\n**Item :** "..QBCore.Shared.Items['art'].label.."\n**Amount :** "..1
	elseif tipo == 'laptop' then
		player.Functions.AddItem('laptop', 1)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['laptop'], "add")
		itemStr = "\n\n**Item :** "..QBCore.Shared.Items['laptop'].label.."\n**Amount :** "..1
	else
		local trunkItems = exports['ps-inventory']:fetchTrunkItems(trunk.plate)
		local weight = 0
		if not trunkItems then return 0 end
		for _, item in pairs(trunkItems) do
			weight = weight + (item.weight * item.amount)
		end
		local item = props[tipo].item
		if weight + QBCore.Shared.Items[item].weight > trunk.maxweight then
			player.Functions.AddItem(item, 1)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
			TriggerClientEvent('QBCore:Notify', src, 'The trunk is full!', 'error')
			itemStr = "\n\n**Item :** "..QBCore.Shared.Items[item].label.."\n**Amount :** "..1

		else
			for i = 1, trunk.slots, 1 do
				if trunkItems[i] == nil then
					trunkItems[i] = { name = item, amount = 1, info = '', label = QBCore.Shared.Items[item].label, description = QBCore.Shared.Items[item].description, weight = QBCore.Shared.Items[item].weight, type = QBCore.Shared.Items[item].type, unique = QBCore.Shared.Items[item].unique, useable = QBCore.Shared.Items[item].useable, image = QBCore.Shared.Items[item].image, shouldClose = QBCore.Shared.Items[item].shouldClose, slot = i, combinable = QBCore.Shared.Items[item].combinable}
					TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
					TriggerClientEvent('QBCore:Notify', src, 'You place the item in the trunk', 'info')
					itemStr = "\n\n**Item :** "..QBCore.Shared.Items[item].label.."\n**Amount :** "..1
					break
				end
			end
			exports['ps-inventory']:addTrunkItems(trunk.plate, trunkItems)
		end
	end

	-- local charinfo = player.PlayerData.charinfo
    -- local firstName = charinfo.firstname:sub(1,1):upper()..charinfo.firstname:sub(2)
    -- local lastName = charinfo.lastname:sub(1,1):upper()..charinfo.lastname:sub(2)
    -- local pName = firstName.." "..lastName
	-- local logString = "Player : ".. GetPlayerName(src) .. "\nCharacter : "..pName.."\n"..Player.PlayerData.citizenid.."\n"..itemStr
	-- TriggerEvent("qb-log:server:CreateLog", "houseRob", "Item Grabbed", "lightgreen", logString)
end)

local function checkCooldownTimer(cid, time)
	local onCd = true
	if cooldownTimer[cid] and cooldownTimer[cid] + (Config.CooldownTime * 60) <= time then onCd = false
	elseif not cooldownTimer[cid] then onCd = false end
	return onCd
end

local function getHouse(tier)
	local houseInfo = Config.Houses[tier][math.random(#Config.Houses[tier])]
	while houseInfo.inUse do houseInfo = Config.Houses[tier][math.random(#Config.Houses[tier])] end
	houseInfo.inUse = true
	return houseInfo
end

RegisterNetEvent('av_houserobbery:server:checkRequirements', function(args)
	local src = source
	local tier = args.tier
	-- Cop Condition Check
	local copAmount = 0
	for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
		for _, jobs in pairs(policeJobs) do
			if v.PlayerData.job.name == jobs and v.PlayerData.job.onduty then
				copAmount = copAmount + 1
			end
		end
	end
	if copAmount < Config.CopsNeeded[tier] then TriggerClientEvent('QBCore:Notify', src, 'I\'m sorry I don\'t have any jobs for you currently...', 'error') return end

	-- Group / hasJob Condition Check
	local s = Config.GroupSize[tier]
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	if groupID == nil then TriggerClientEvent('QBCore:Notify', src, 'You need to be in a work group to do this!', 'error') return end
	if exports['qb-phone']:GetGroupLeader(groupID) ~= src then TriggerClientEvent('QBCore:Notify', src, 'You\'re not the leader of your group.', 'error') return end
	if exports['qb-phone']:getJobStatus(groupID) ~= 'WAITING' then TriggerClientEvent('QBCore:Notify', src, 'Your group already has a job!', 'error') return end
	if exports['qb-phone']:getGroupSize(groupID) > s then TriggerClientEvent('QBCore:Notify', src, 'Your group can only have a maximum of '..s..' members for this job...', 'error') return end
	local members = exports['qb-phone']:getGroupMembers(groupID)

	-- Cooldown Condition Check
	local cdStatus = false
	local time = os.time()
	for _, v in pairs(members) do
		local Player = QBCore.Functions.GetPlayer(v)
		local cid = Player.PlayerData.citizenid
		cdStatus = checkCooldownTimer(cid, time)
		if cdStatus == true then TriggerClientEvent('QBCore:Notify', src, 'A member in your group has done this too recently!', 'error') return end
		if tier == 'high' and Player.PlayerData.metadata.house_robbery_rep < Config.HighEndRepNeeded then TriggerClientEvent('QBCore:Notify', src, 'A member in your group doesn\'t have access to high end houses!', 'error') return end
	end

	Citizen.CreateThread(function()
		local houseInfo = getHouse(tier)
		houseInfo.tier = tier
		local c = {math.random(0,99), math.random(0,99), math.random(0,99)}
		--houseInfo.safe = math.random(100) < Config.SafeChances[tier]
		houseInfo.safe = true
		houseInfo.laptop = math.random(100) < 40
		for _, v in pairs(members) do
			TriggerClientEvent('av_houserobbery:client:resetAll', v)
			TriggerClientEvent('av_houserobbery:client:setupJob', v, houseInfo, c, src == v)
		end
		exports['qb-phone']:NotifyGroup(groupID, Config.Lang['waitcall'], 'info')
		if not Config.Debug then Wait(Config.CoordsWait * 60000) end
		local job = lib.table.deepclone(jobStages)
		job[1].isDone = true
		exports['qb-phone']:setJobStatus(groupID, "House Robbery", job)
		for _, v in pairs(members) do
			TriggerClientEvent('av_houserobbery:client:startJob', v)
		end
	end)
end)

RegisterNetEvent('av_houserobbery:server:playerCaught', function()
	local src = source
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	if not groupID then return end
	local members = exports['qb-phone']:getGroupMembers(groupID)
	exports['qb-phone']:NotifyGroup(groupID, 'Someone triggered the Alarm, run!', 'error')
	exports['qb-phone']:resetJobStatus(groupID)
	Wait(2000)
	for k, v in pairs(members) do TriggerClientEvent('av_houserobbery:client:resetAll', v) end
end)

RegisterNetEvent('av_houserobbery:server:finishHeist', function()
	local src = source
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	if not groupID then return end
	local members = exports['qb-phone']:getGroupMembers(groupID)
	for k, v in pairs(members) do TriggerClientEvent('av_houserobbery:client:groupSync', v, 'caught') end
	exports['qb-phone']:resetJobStatus(groupID)
	Wait(2000) for k, v in pairs(members) do TriggerClientEvent('av_houserobbery:client:resetAll', v) end
end)

RegisterNetEvent('av_houserobbery:server:groupSync', function(sync, ...)
	local src = source
	local groupID = exports['qb-phone']:GetGroupByMembers(src)
	if not groupID then return end
	local members = exports['qb-phone']:getGroupMembers(groupID)
	for k, v in pairs(members) do
		TriggerClientEvent('av_houserobbery:client:groupSync', v, sync, ...)
	end
end)

function debugPrint(...)
    if not Config.Debug then return end
	Midnight.Functions.Debug(...)
end

