print'Pug Fishing 1.5.5'
local OpeningChest = false
local succededchestopen = false

RegisterNetEvent('Pug:client:TournamentHasBecomeAvilable', function()
	-- This event is for you to add whatever you want to happen when the fishing tournament becomes available for people to sign up.
	if Config.Phone == "renewed" or Config.Phone == "qb" then
		TriggerServerEvent('qb-phone:server:sendNewMail', {
			sender = 'Fisher Joe',
			subject = "Fishing Tournament",
			message = 'Come on down to test your fishing skills in this tournament!',
		})
	elseif Config.Phone == "quasar" then
		TriggerServerEvent('qs-smartphone:server:sendNewMail', {
			sender = 'Fisher Joe',
			subject = "Fishing Tournament",
			message = 'Come on down to test your fishing skills in this tournament!',
		})
	elseif Config.Phone == "gks" then
		TriggerServerEvent('gksphone:NewMail', {
			sender = 'Fisher Joe',
			image = '/html/static/img/icons/mail.png',
			subject = "Fishing Tournament",
			message = 'Come on down to test your fishing skills in this tournament!'
		})
	elseif Config.Phone == "road" then
		TriggerServerEvent('roadphone:receiveMail', {
			sender = 'Fisher Joe',
			subject = "Fishing Tournament",
			message = 'Come on down to test your fishing skills in this tournament!',
			image = ' '
		})
	end
end)

--Put your drawtext option here
function DrawTextOption(text)
	if Framework == "QBCore" then
		exports[Config.CoreName]:DrawText(text, 'left')
	else
		FWork.TextUI(text, "error")
	end
end
function HideTextOption()
	if Framework == "QBCore" then
		exports[Config.CoreName]:HideText()
		Wait(1000)
	else
		FWork.HideUI()
	end
end

-- Change this to your notification script if needed
function FishingNotify(msg, type, length)
	if Framework == "ESX" then
		FWork.ShowNotification(msg)
	elseif Framework == "QBCore" then
    	FWork.Functions.Notify(msg, type, length)
	end
end

-- item lable text
function ShowItemLable(Item)
    if Framework == "QBCore" then
		if FWork.Shared.Items[Item] ~= nil then
        	return FWork.Shared.Items[Item].label
		else
			return Item
		end
    else
        return Item
    end
end

function HasItem(items, amount)
    if Framework == "QBCore" then
        local DoesHasItem = "nothing"
        Config.FrameworkFunctions.TriggerCallback("Pug:server:FishingGetITemQBCore", function(HasItem)
            if HasItem then
                DoesHasItem = true
            else
                DoesHasItem = false
            end
        end, items, amount)
        while DoesHasItem == "nothing" do Wait(1) end
        return DoesHasItem
    else
		local DoesHasItem = "nothing"
		Config.FrameworkFunctions.TriggerCallback("Pug:server:GetItemFishingESX", function(HasItem)
			if HasItem then
				DoesHasItem = true
			else
				DoesHasItem = false
			end
		end, items, amount)
		while DoesHasItem == "nothing" do Wait(1) end
		return DoesHasItem
    end
end

local function SellFishAnim()
	local random = math.random(1,5)
	if random == 1 then
		ExecuteCommand("e ".."wait")
	elseif random == 2 then 
		ExecuteCommand("e ".."argue")
	elseif random == 3 then 
		ExecuteCommand("e ".."argue2")
	elseif random == 4 then 
		ExecuteCommand("e ".."lean2")
	elseif random == 5 then 
		ExecuteCommand("e ".."danceslow")
	end
end
local function LoadModel(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end
Citizen.CreateThread(function()
	if Config.UseDefaultPed then
		MainFisherMan = Config.TournamentPed
		LoadModel(MainFisherMan)
		FisherMan = CreatePed(2, MainFisherMan, Config.TournamentPedLoc, false, false)
		SetPedFleeAttributes(FisherMan, 0, 0)
		SetPedDiesWhenInjured(FisherMan, false)
		SetPedKeepTask(FisherMan, true)
		SetBlockingOfNonTemporaryEvents(FisherMan, true)
		SetEntityInvincible(FisherMan, true)
		FreezeEntityPosition(FisherMan, true)
	end
	if Config.Target == "ox_target" and Config.InventoryType == "ox" then
		exports.ox_target:addLocalEntity(FisherMan, {
			{
				name="fishguy",
				type = "client",
				event = "Pug:client:ViewTournamentMenu",
				icon = "fas fa-user-check",
				label = Translations.menu.Join,
				distance = 2.0
			},
			{
				name="fishshop",
				type = "client",
				event = "pug-fishing:client:OpenShop",
				icon = "fas fa-user-check",
				label = Translations.menu.open_shop,
				distance = 2.0
			},
		})
	elseif Config.Target == "ox_target" then
		exports.ox_target:addLocalEntity(FisherMan, {
			{
				name="fishguy",
				type = "client",
				event = "Pug:client:ViewTournamentMenu",
				icon = "fas fa-user-check",
				label = Translations.menu.Join,
				distance = 2.0
			},
		})
	elseif Config.InventoryType == "ox" then
		exports[Config.Target]:AddTargetEntity(FisherMan, {
			options = {
				{
					type = "client",
					event = "Pug:client:ViewTournamentMenu",
					icon = "fas fa-user-check",
					label = Translations.menu.Join,
				},
				{
					type = "client",
					event = "pug-fishing:client:OpenShop",
					icon = "fas fa-user-check",
					label = Translations.menu.open_shop,
				},
			},
			distance = 2.5
		})
	else
		exports[Config.Target]:AddTargetEntity(FisherMan, {
			options = {
				{
					type = "client",
					event = "Pug:client:ViewTournamentMenu",
					icon = "fas fa-user-check",
					label = Translations.menu.Join,
				},
			},
			distance = 2.5
		})
	end
    FisherManSellShop = Config.SellShopPed
    LoadModel(FisherManSellShop)
    FisherManShop = CreatePed(2, FisherManSellShop, Config.SellShopPedPedLoc, false, false)
    SetPedFleeAttributes(FisherManShop, 0, 0)
    SetPedDiesWhenInjured(FisherManShop, false)
    SetPedKeepTask(FisherManShop, true)
    SetBlockingOfNonTemporaryEvents(FisherManShop, true)
    SetEntityInvincible(FisherManShop, true)
    FreezeEntityPosition(FisherManShop, true)
	if Config.Target == "ox_target" then
		exports.ox_target:addLocalEntity(FisherManShop, {
			{
				name="sellfish",
				type = "client",
				event = "Pug:client:SellFishMenu",
				icon = "fas fa-fish",
				label = Translations.menu.sell_fish,
				distance = 2.0
			}
		})
	else
		exports[Config.Target]:AddTargetEntity(FisherManShop, {
			options = {
				{
					event = "Pug:client:SellFishMenu",
					icon = "fas fa-fish",
					label = Translations.menu.sell_fish,
				}
			},
			distance = 2.5
		})
	end
	FishSellBlip = AddBlipForCoord(-2196.83, 4272.38, 48.55)
    SetBlipSprite(FishSellBlip, 628)
    SetBlipDisplay(FishSellBlip, 4)
    SetBlipScale(FishSellBlip, 0.75)
    SetBlipColour(FishSellBlip, 33)
    SetBlipAsShortRange(FishSellBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Big Game Traders Market")
    EndTextCommandSetBlipName(FishSellBlip)
	if craftingbench == nil then
		RequestModel(GetHashKey("prop_tool_bench02"))
		while not HasModelLoaded(GetHashKey("prop_tool_bench02")) do Wait(1) end
		craftingbench = CreateObject(GetHashKey("prop_tool_bench02"),Config.CrafingRodLocation.x, Config.CrafingRodLocation.y, Config.CrafingRodLocation.z-1,false,false,false)
		SetEntityHeading(craftingbench,GetEntityHeading(craftingbench)-24.7)
		FreezeEntityPosition(craftingbench, true)
	end
	if Config.Target == "ox_target" then
		exports.ox_target:addLocalEntity(craftingbench, {
			{
				name="CraftFishingRod",
				type = "client",
				event = "Pug:client:CraftFishingRodMenu",
				icon = "fa-solid fa-pen-ruler",
				label = "Craft Fishing Rod",
				distance = 2.0
			}
		})
	else
		exports[Config.Target]:AddTargetEntity(craftingbench, {
			options = {
				{
					event = "Pug:client:CraftFishingRodMenu",
					icon = "fa-solid fa-pen-ruler",
					label = 'Craft Fishing Rod',
				}
			},
			distance = 2.5
		})
	end
	GemsFisherMan = Config.GemsBuyingPed
    LoadModel(GemsFisherMan)
    GemsBuyer = CreatePed(2, GemsFisherMan, Config.GemsBuyingPedLoc, false, false)
    SetPedFleeAttributes(GemsBuyer, 0, 0)
    SetPedDiesWhenInjured(GemsBuyer, false)
    SetPedKeepTask(GemsBuyer, true)
    SetBlockingOfNonTemporaryEvents(GemsBuyer, true)
    SetEntityInvincible(GemsBuyer, true)
    FreezeEntityPosition(GemsBuyer, true)
	if Config.Target == "ox_target" then
		exports.ox_target:addLocalEntity(GemsBuyer, {
			{
				name="gemsguy",
				type = "client",
				event = "Pug:client:SellFishingGemsMenu",
				icon = "fas fa-user-check",
				label = Translations.menu.sell_gems,
				distance = 5.0
			}
		})
	else
		exports[Config.Target]:AddTargetEntity(GemsBuyer, {
			options = {
				{
					type = "client",
					event = "Pug:client:SellFishingGemsMenu",
					icon = "fas fa-user-check",
					label = Translations.menu.sell_gems,
				}
			},
			distance = 2.5
		})
	end
end)
RegisterNetEvent('Pug:client:SellFishingGemsMenu', function()
	if Config.Menu == "ox_lib" then
		local menu = {
			{
				title = Translations.menu.sell_gems,
				description = "ESC or click to go close",
				event = " ",
			}
		}
		for k, v in pairs(Config.SellGems) do
			menu[#menu+1] = {
				title = 'Sell '..ShowItemLable(k),
				icon = "fas fa-gem",
				description = 'between $'..v.pricemin..' - '..v.pricemax,
				event = "Pug:client:SellFishingGems",
				args = k
				
			}
		end
		lib.registerContext({
			id = 'sell_gems',
			title = Translations.menu.sell_gems,
			options = menu
		})
		lib.showContext('sell_gems')
	else
		local menu = {
			{
				header = Translations.menu.sell_gems,
				txt = "ESC or click to go close",
				params = {
					event = " ",
				}
			}
		}
		for k, v in pairs(Config.SellGems) do
			menu[#menu+1] = {
				header = 'Sell '..ShowItemLable(k),
				icon = "fas fa-gem",
				text = 'between $'..v.pricemin..' - '..v.pricemax,
				params = {
					event = "Pug:client:SellFishingGems",
					args = k
				}
			}
		end
		exports[Config.Menu]:openMenu(menu)
	end
end)
RegisterNetEvent("Pug:client:SellFishingGems")
AddEventHandler("Pug:client:SellFishingGems", function(item)
	if HasItem(item, 1) then
		SellFishAnim()
		if Framework == "QBCore" then
			FWork.Functions.Progressbar("selling_gems", Translations.details.selling_fish..' '..ShowItemLable(item), math.random(5000,10000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:SellGems', function(cansell)
					if cansell then
						
					else
						FishingNotify(Translations.error.no_gems, 'error')
					end
				end,item)
			end, function()
				FishingNotify(Translations.details.canceled, "error")
			end)
		else
			FWork.Progressbar(Translations.details.selling_fish..' '..ShowItemLable(item), math.random(5000,10000), {FreezePlayer = true, onFinish = function()
				Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:SellGems', function(cansell)
					if cansell then
						
					else
						FishingNotify(Translations.error.no_gems, 'error')
					end
				end,item)
			end, onCancel = function()
				FishingNotify(Translations.details.canceled, "error")
			end})
		end
	else
		FishingNotify(Translations.error.no_gems, 'error')
	end
end)
RegisterNetEvent('Pug:client:CraftFishingRodMenu', function()
	if Config.Menu == "ox_lib" then
		local menu = {
			{
				title = Translations.menu.CraftRodHeader,
				description = "ESC or click to go close",
				event = " ",
			}
		}
		for k, v in pairs(Config.CraftRods) do
			menu[#menu+1] = {
				title = v.name..' | '..v.repRequired..' Fishing Rep & $'..v.price,
				icon = "fas fa-fish",
				description = 'Required: '..v.item1Amount..'x '..ShowItemLable(v.item1)..' | '..v.item2Amount..'x '..ShowItemLable(v.item2),
				event = "Pug:client:CraftFishingRod",
				args = k
				
			}
		end
		lib.registerContext({
			id = 'CraftRodHeader',
			title = Translations.menu.CraftRodHeader,
			options = menu
		})
		lib.showContext('CraftRodHeader')
	else
		local menu = {
			{
				header = Translations.menu.CraftRodHeader,
				txt = "ESC or click to go close",
				params = {
					event = " ",
				}
			}
		}
		for k, v in pairs(Config.CraftRods) do
			menu[#menu+1] = {
				header = v.name..' | '..v.repRequired..' Fishing Rep & $'..v.price,
				icon = "fas fa-fish",
				text = 'Required: '..v.item1Amount..'x '..ShowItemLable(v.item1)..' | '..v.item2Amount..'x '..ShowItemLable(v.item2),
				params = {
					event = "Pug:client:CraftFishingRod",
					args = k
				}
			}
		end
		exports[Config.Menu]:openMenu(menu)
	end
end)
RegisterNetEvent("Pug:client:CraftFishingRod")
AddEventHandler("Pug:client:CraftFishingRod", function(item)
    Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:CanCraftRod', function(cancraft)
        if cancraft then
			PugFishToggleItem(false, Config.CraftRods[item].item1, Config.CraftRods[item].item1Amount)
			PugFishToggleItem(false, Config.CraftRods[item].item2, Config.CraftRods[item].item2Amount)
			ExecuteCommand("e ".."mechanic")
			if Framework == "QBCore" then
				FWork.Functions.Progressbar("crafint_rod", Translations.details.Crafting_rod, 7000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,	
				}, {}, {}, {}, function() -- Done
					TriggerServerEvent("Pug:server:FishingRemoveMoeny",	Config.CraftRods[item].price)
					PugFishToggleItem(true, item, 1)
					FishingNotify(Translations.details.crafted_rod.. Config.CraftRods[item].name)
					if Config.RemoveFishingRepWhenCraftRod then
						TriggerServerEvent("Pug:server:RemoveFishingRedp", Config.CraftRods[item].repRequired)
					end
				end, function()
					PugFishToggleItem(true, Config.CraftRods[item].item1, Config.CraftRods[item].item1Amount)
					PugFishToggleItem(true, Config.CraftRods[item].item2, Config.CraftRods[item].item2Amount)
					FishingNotify(Translations.details.canceled, "error")
				end)
			else
				FWork.Progressbar(Translations.details.Crafting_rod, 7000, {FreezePlayer = true, onFinish = function()
					TriggerServerEvent("Pug:server:FishingRemoveMoeny",	Config.CraftRods[item].price)
					PugFishToggleItem(true, item, 1)
					FishingNotify(Translations.details.crafted_rod.. Config.CraftRods[item].name)
					if Config.RemoveFishingRepWhenCraftRod then
						TriggerServerEvent("Pug:server:RemoveFishingRedp", Config.CraftRods[item].repRequired)
					end
				end, onCancel = function()
					PugFishToggleItem(true, Config.CraftRods[item].item1, Config.CraftRods[item].item1Amount)
					PugFishToggleItem(true, Config.CraftRods[item].item2, Config.CraftRods[item].item2Amount)
					FishingNotify(Translations.details.canceled, "error")
				end})
			end
        end
    end, item)
end)

RegisterNetEvent('Pug:client:SellFishMenu', function()
	if Config.Menu == "ox_lib" then
		local menu = {
			{
				title = Translations.menu.sell_fish,
				description = "ESC or click to go close",
				event = " ",
			}
		}
		for k, v in pairs(Config.SellFishies) do
			menu[#menu+1] = {
				title = 'Sell '..ShowItemLable(k),
				icon = "fas fa-fish",
				description = '$'..v.price,
				event = "Pug:client:SellFish",
				args = k
				
			}
		end
		lib.registerContext({
			id = 'sell_fish',
			title = Translations.menu.sell_fish,
			options = menu
		})
		lib.showContext('sell_fish')
	else
		local menu = {
			{
				header = Translations.menu.sell_fish,
				txt = "ESC or click to go close",
				params = {
					event = " ",
				}
			}
		}
		for k, v in pairs(Config.SellFishies) do
			menu[#menu+1] = {
				header = 'Sell '..ShowItemLable(k),
				icon = "fas fa-fish",
				text = '$'..v.price,
				params = {
					event = "Pug:client:SellFish",
					args = k
				}
			}
		end
		exports[Config.Menu]:openMenu(menu)
	end
end)
RegisterNetEvent("Pug:client:SellFish")
AddEventHandler("Pug:client:SellFish", function(item)
	if HasItem(item, 1) then
		SellFishAnim()
		if Framework == "QBCore" then
			FWork.Functions.Progressbar("selling_fish", Translations.details.selling_fish..' '..ShowItemLable(item), 5000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:SellFish', function(cansell)
					if cansell then
						
					else
						FishingNotify(Translations.error.no_fish, 'error')
					end
				end,item)
			end, function()
				FishingNotify(Translations.details.canceled, "error")
			end)
		else
			FWork.Progressbar(Translations.details.selling_fish..' '..ShowItemLable(item), 5000, {FreezePlayer = true, onFinish = function()
				Config.FrameworkFunctions.TriggerCallback('Pug:ServerCB:SellFish', function(cansell)
					if cansell then
						
					else
						FishingNotify(Translations.error.no_fish, 'error')
					end
				end,item)
			end, onCancel = function()
				FishingNotify(Translations.details.canceled, "error")
			end})
		end
	else
		FishingNotify(Translations.error.no_fish, 'error')
	end
end)
local function GiveFishingRep(rep)
	return TriggerServerEvent("Pug:Server:GiveFishingRep", rep)
end
-- Tournament first place item rewards
RegisterNetEvent('Pug:client:GiveFirstPlaceReward', function(k)
	local random = math.random(1,100)
	if random <= 10 then
		TriggerServerEvent("Pug:server:GiveLure")
	elseif random > 10 and random <= 100 then
		PugFishToggleItem(true, 'chestkey')
	end
	GiveFishingRep(math.random(17,22))
end)
-- Tournament second place item rewards
RegisterNetEvent('Pug:client:GiveSecondPlaceReward', function(k)
	local random = math.random(1,100)
	if random <= 10 then
		TriggerServerEvent("Pug:server:GiveLure")
	elseif random > 10 and random <= 13 then
		PugFishToggleItem(true, 'treasurechest')
	end
	GiveFishingRep(math.random(10,15))
end)
-- Tournament third place item rewards
RegisterNetEvent('Pug:client:GiveThirdPlaceReward', function()
	local random = math.random(1,100)
	if random <= 10 then
		TriggerServerEvent("Pug:server:GiveLure")
	elseif random > 10 and random <= 13 then
		PugFishToggleItem(true, 'bottlemap')
	end
	GiveFishingRep(math.random(7,11))
end)
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		DeleteEntity(craftingbench)
	end
end)

function GetFishingInfoOpen()
    local info = {
		opnchest = OpeningChest,
		success = succededchestopen
    }
    return info
end

function FishingRod1Loot() -- Starter fishing rod loot table
	local fish = "stripedbass"
	if GetFishingInfoClosed().intournarea and GetFishingInfoClosed().started then -- only true if in a fishing area during a fishing torunament
		local luck = math.random(1,200)
		local treasure = math.random(1,300)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(5,7))
		end
		local reel = math.random(1,200)
		if reel == 69 then
			PugFishToggleItem(true, 'skill-reel')
			GiveFishingRep(math.random(5,7))
		end
		if luck == 200 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(15, 20)) -- gives points for the tournament
			fish = "killerwhale"
			GiveFishingRep(10)
		elseif luck >= 189 and luck <= 199 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", 0) -- gives points for the tournament
			fish = "eelfish"
		elseif luck >= 186 and luck < 189 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "tigershark"
			GiveFishingRep(math.random(5,7))
		elseif luck >= 182 and luck < 186 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "swordfish"
			GiveFishingRep(math.random(4,5))
		elseif luck >= 178 and luck < 182 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "tuna-fish"
			GiveFishingRep(3)
		elseif luck >= 174 and luck < 178 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "catfish"
			GiveFishingRep(3)
		elseif luck >= 170 and luck < 174 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "salmon"
			GiveFishingRep(3)
		elseif luck >= 166 and luck < 170 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 8)) -- gives points for the tournament
			fish = "largemouthbass"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 162 and luck < 166 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "goldfish"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 159 and luck < 162 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "redfish"
			GiveFishingRep(2)
		elseif luck >= 156 and luck < 159 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "bluefish"
			GiveFishingRep(2)
		elseif luck >= 151 and luck < 156 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(2, 5)) -- gives points for the tournament
			fish = "stripedbass"
			GiveFishingRep(2)
		elseif luck < 151 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			fish = "fish"
			GiveFishingRep(1)
		end
		PugFishToggleItem(true, fish)
	else
		local treasure = math.random(1,3000)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(15,20))
		end
		local reel = math.random(1,3000)
		if reel == 69 then
			PugFishToggleItem(true, 'skill-reel')
			GiveFishingRep(math.random(15,20))
		end
		local luck = math.random(1,200)
		if luck == 200 then
			GiveFishingRep(7)
			fish = "killerwhale"
		elseif luck >= 189 and luck <= 199 then
			fish = "eelfish"
		elseif luck >= 185 and luck < 189 then
			GiveFishingRep(2)
			fish = "goldfish"
		elseif luck >= 181 and luck < 185 then
			GiveFishingRep(2)
			fish = "redfish"
		elseif luck >= 177 and luck < 181 then
			GiveFishingRep(1)
			fish = "bluefish"
		elseif luck >= 172 and luck < 177 then
			GiveFishingRep(1)
			fish = "stripedbass"
		elseif luck < 172 then
			fish = "fish"
			local repluck = math.random(1,10)
			if repluck <= 3 then
				GiveFishingRep(1)
			end
		end
		PugFishToggleItem(true, fish)
	end
end

function FishingRod2Loot() -- skilled fishing rod loot table
	local fish = "stripedbass"
	if GetFishingInfoClosed().intournarea and GetFishingInfoClosed().started then -- only true if in a fishing area during a fishing torunament
		local luck = math.random(1,200)
		local treasure = math.random(1,200)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(5,8))
		end
		local lure1 = math.random(1,350)
		if lure1 == 69 then
			TriggerServerEvent("Pug:server:GiveLure")
			GiveFishingRep(math.random(7,10))
		end
		local lure2 = math.random(1,300)
		if lure2 == 69 then
			TriggerServerEvent("Pug:server:GiveLure2")
			GiveFishingRep(math.random(7,10))
		end
		local chestkey = math.random(1,300)
		if chestkey == 69 then
			PugFishToggleItem(true, Config.ChestKey)
			GiveFishingRep(math.random(5,10))
		end
		local bottlemap = math.random(1,1000)
		if bottlemap == 69 then
			PugFishToggleItem(true, 'bottlemap')
			GiveFishingRep(math.random(20,24))
		end
		local reel = math.random(1,100)
		if reel == 69 then
			PugFishToggleItem(true, 'pro-reel')
			GiveFishingRep(math.random(8,10))
		end
		if luck == 200 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(15, 20)) -- gives points for the tournament
			fish = "killerwhale"
			GiveFishingRep(math.random(8,10))
		elseif luck >= 192 and luck <= 199 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", 0) -- gives points for the tournament
			fish = "eelfish"
		elseif luck >= 177 and luck < 192 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "tigershark"
			GiveFishingRep(math.random(4,5))
		elseif luck >= 171 and luck < 177 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "swordfish"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 165 and luck < 171 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "tuna-fish"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 159 and luck < 165 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "catfish"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 153 and luck < 159 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "salmon"
			GiveFishingRep(math.random(1,2))
		elseif luck >= 147 and luck < 153 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 8)) -- gives points for the tournament
			fish = "largemouthbass"
			GiveFishingRep(math.random(1,2))
		elseif luck >= 141 and luck < 147 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "goldfish"
			GiveFishingRep(math.random(1,2))
		elseif luck >= 136 and luck < 141 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "redfish"
			GiveFishingRep(math.random(1,2))
		elseif luck >= 130 and luck < 136 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "bluefish"
			GiveFishingRep(1)
		elseif luck >= 120 and luck < 130 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(2, 5)) -- gives points for the tournament
			fish = "stripedbass"
			GiveFishingRep(1)
		elseif luck < 120 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			fish = "fish"
			GiveFishingRep(1)
		end
		local otherfish = math.random(1,300)
		if otherfish >= 9 and otherfish < 12 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "codfish"
			GiveFishingRep(math.random(3,4))
		elseif otherfish >= 6 and otherfish < 9 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "gholfish"
			GiveFishingRep(math.random(3,4))
		elseif otherfish >= 3 and otherfish < 6 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "rainbowtrout"
			GiveFishingRep(math.random(3,4))
		elseif otherfish >= 1 and otherfish < 3 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "stingraymeat"
			GiveFishingRep(math.random(3,4))
		end
		local gems = math.random(1,600)
		if gems >= 20 and gems < 24 then 
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'diamond')
			GiveFishingRep(math.random(2,4))
		elseif gems >= 16 and gems < 20 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'emerald')
			GiveFishingRep(math.random(2,4))
		elseif gems >= 12 and gems < 16 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'sapphire')
			GiveFishingRep(math.random(2,4))
		elseif gems >= 8 and gems < 12 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'ruby')
			GiveFishingRep(math.random(2,4))
		elseif gems >= 5 and gems < 8 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'yellow-diamond')
			GiveFishingRep(math.random(2,4))
		elseif gems < 3 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'captainskull')
			GiveFishingRep(math.random(2,4))
		end
		PugFishToggleItem(true, fish)
	else
		local treasure = math.random(1,2000)
		if treasure == 69 then
			GiveFishingRep(math.random(5,10))
			PugFishToggleItem(true, Config.ChestItem)
		end
		local lure1 = math.random(1,450)
		if lure1 == 69 then
			TriggerServerEvent("Pug:server:GiveLure")
			GiveFishingRep(math.random(7,10))
		end
		local lure2 = math.random(1,400)
		if lure2 == 69 then
			TriggerServerEvent("Pug:server:GiveLure2")
			GiveFishingRep(math.random(7,10))
		end
		local reel = math.random(1,2000)
		if reel == 69 then
			GiveFishingRep(math.random(5,10))
			PugFishToggleItem(true, 'pro-reel')
		end
		local luck = math.random(1,200)
		if luck == 200 then
			fish = "killerwhale"
			GiveFishingRep(8)
		elseif luck >= 192 and luck <= 199 then
			fish = "eelfish"
		elseif luck >= 187 and luck < 192 then
			fish = "tigershark"
			GiveFishingRep(math.random(4,5))
		elseif luck >= 181 and luck < 187 then
			fish = "swordfish"
			GiveFishingRep(math.random(3,4))
		elseif luck >= 175 and luck < 181 then
			fish = "tuna-fish"
			GiveFishingRep(math.random(3,4))
		elseif luck >= 169 and luck < 175 then
			fish = "catfish"
			GiveFishingRep(3)
		elseif luck >= 163 and luck < 169 then
			fish = "salmon"
			GiveFishingRep(3)
		elseif luck >= 157 and luck < 163 then
			fish = "largemouthbass"
			GiveFishingRep(2)
		elseif luck >= 151 and luck < 157 then
			fish = "goldfish"
			GiveFishingRep(2)
		elseif luck >= 146 and luck < 151 then
			fish = "redfish"
			GiveFishingRep(2)
		elseif luck >= 140 and luck < 146 then
			fish = "bluefish"
			GiveFishingRep(1)
		elseif luck >= 130 and luck < 140 then
			fish = "stripedbass"
			GiveFishingRep(1)
		elseif luck < 130 then
			fish = "fish"
			GiveFishingRep(1)
		end
		local otherfish = math.random(1,300)
		if otherfish >= 9 and otherfish < 12 then
			GiveFishingRep(math.random(2,4))
			fish = "codfish"
		elseif otherfish >= 6 and otherfish < 9 then
			GiveFishingRep(math.random(2,4))
			fish = "gholfish"
		elseif otherfish >= 3 and otherfish < 6 then
			GiveFishingRep(math.random(2,4))
			fish = "rainbowtrout"
		elseif otherfish >= 1 and otherfish < 3 then
			GiveFishingRep(math.random(2,4))
			fish = "stingraymeat"
		end
		PugFishToggleItem(true, fish)
	end
end


--What fishing rewards the player gets when fishing with the highest tier fishing
function FishingRod3Loot()-- pro fishing rod loot table
	local fish = "stripedbass"
	if GetFishingInfoClosed().intournarea and GetFishingInfoClosed().started then -- only true if in a fishing area during a fishing torunament
		local luck = math.random(1,200)
		local treasure = math.random(1,100)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(7,10))
		end
		local lure1 = math.random(1,150)
		if lure1 == 69 then
			TriggerServerEvent("Pug:server:GiveLure")
			GiveFishingRep(math.random(7,10))
		end
		local lure2 = math.random(1,200)
		if lure2 == 69 then
			TriggerServerEvent("Pug:server:GiveLure2")
			GiveFishingRep(math.random(7,10))
		end
		local chestkey = math.random(1,200)
		if chestkey == 69 then
			PugFishToggleItem(true, Config.ChestKey)
			GiveFishingRep(math.random(7,10))
		end
		local bottlemap = math.random(1,400)
		if bottlemap == 69 then
			PugFishToggleItem(true, 'bottlemap')
			GiveFishingRep(math.random(10,15))
		end
		if luck >= 197 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(15, 20)) -- gives points for the tournament
			fish = "killerwhale"
			GiveFishingRep(math.random(10,15))
		elseif luck >= 194 and luck < 197 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", 0) -- gives points for the tournament
			fish = "eelfish"
		elseif luck >= 185 and luck < 194 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "tuna-fish"
			GiveFishingRep(math.random(4,7))
		elseif luck >= 179 and luck < 185 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "salmon"
			GiveFishingRep(math.random(4,7))
		elseif luck >= 173 and luck < 179 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 8)) -- gives points for the tournament
			fish = "largemouthbass"
			GiveFishingRep(math.random(4,7))
		elseif luck >= 167 and luck < 173 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "tigershark"
			GiveFishingRep(math.random(4,7))
		elseif luck >= 161 and luck < 167 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(5, 11)) -- gives points for the tournament
			fish = "swordfish"
			GiveFishingRep(math.random(2,5))
		elseif luck >= 156 and luck < 161 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "tuna-fish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 150 and luck < 156 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "catfish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 144 and luck < 150 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 9)) -- gives points for the tournament
			fish = "salmon"
			GiveFishingRep(math.random(2,4))
		elseif luck >= 138 and luck < 144 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(4, 8)) -- gives points for the tournament
			fish = "largemouthbass"
			GiveFishingRep(math.random(2,4))
		elseif luck >= 130 and luck < 138 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "goldfish"
			GiveFishingRep(math.random(3,4))
		elseif luck >= 122 and luck < 130 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "redfish"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 114 and luck < 122 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(3, 6)) -- gives points for the tournament
			fish = "bluefish"
			GiveFishingRep(math.random(1,2))
		elseif luck >= 98 and luck < 114 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(2, 5)) -- gives points for the tournament
			fish = "stripedbass"
			GiveFishingRep(1)
		elseif luck < 98 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			fish = "fish"
			GiveFishingRep(1)
		end
		local otherfish = math.random(1,250)
		if otherfish >= 9 and otherfish < 12 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "codfish"
			GiveFishingRep(math.random(2,4))
		elseif otherfish >= 6 and otherfish < 9 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "gholfish"
			GiveFishingRep(math.random(2,4))
		elseif otherfish >= 3 and otherfish < 6 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "rainbowtrout"
			GiveFishingRep(math.random(2,4))
		elseif otherfish >= 1 and otherfish < 3 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 2)) -- gives points for the tournament
			fish = "stingraymeat"
			GiveFishingRep(math.random(2,4))
		end
		local gems = math.random(1,400)
		if gems >= 20 and gems < 24 then 
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'diamond')
			GiveFishingRep(math.random(3,5))
		elseif gems >= 16 and gems < 20 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'emerald')
			GiveFishingRep(math.random(3,5))
		elseif gems >= 12 and gems < 16 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'sapphire')
			GiveFishingRep(math.random(3,5))
		elseif gems >= 8 and gems < 12 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'ruby')
			GiveFishingRep(math.random(3,5))
		elseif gems >= 5 and gems < 8 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'yellow-diamond')
			GiveFishingRep(math.random(3,5))
		elseif gems == 1 then
			TriggerServerEvent("Pug:Server:UpdateFishingLeaderBoard", math.random(1, 3)) -- gives points for the tournament
			PugFishToggleItem(true, 'captainskull')
			GiveFishingRep(math.random(3,5))
		end
		PugFishToggleItem(true, fish)
	else
		local treasure = math.random(1,500)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(10,20))
		end
		local lure1 = math.random(1,350)
		if lure1 == 69 then
			TriggerServerEvent("Pug:server:GiveLure")
			GiveFishingRep(math.random(7,10))
		end
		local lure2 = math.random(1,400)
		if lure2 == 69 then
			TriggerServerEvent("Pug:server:GiveLure2")
			GiveFishingRep(math.random(7,10))
		end
		local chestkey = math.random(1,600)
		if chestkey == 69 then
			PugFishToggleItem(true, Config.ChestKey)
			GiveFishingRep(math.random(10,20))
		end
		local bottlemap = math.random(1,700)
		if bottlemap == 69 then
			PugFishToggleItem(true, 'bottlemap')
			GiveFishingRep(math.random(10,20))
		end
		local luck = math.random(1,120)
		if luck == 120 then
			fish = "killerwhale"
			GiveFishingRep(math.random(10,20))
		elseif luck >= 118 and luck < 120 then
			fish = "eelfish"
		elseif luck == 117 then
			fish = "tigershark"
			GiveFishingRep(math.random(5,10))
		elseif luck == 116 then
			fish = "catfish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 110 and luck < 115 then
			fish = "salmon"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 105 and luck < 110 then
			fish = "largemouthbass"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 100 and luck < 105 then
			fish = "goldfish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 95 and luck < 100 then
			fish = "redfish"
			GiveFishingRep(math.random(3,4))
		elseif luck >= 90 and luck < 95 then
			fish = "bluefish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 85 and luck < 90 then
			fish = "stripedbass"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 80 and luck < 85 then
			fish = "tuna-fish"
			GiveFishingRep(2)
		elseif luck >= 75 and luck < 80 then
			fish = "swordfish"
			GiveFishingRep(1)
		elseif luck < 75 then
			fish = "fish"
			GiveFishingRep(1)
		end
		local otherfish = math.random(1,250)
		if otherfish >= 9 and otherfish < 12 then
			fish = "codfish"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 6 and otherfish < 9 then
			fish = "gholfish"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 3 and otherfish < 6 then
			fish = "rainbowtrout"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 1 and otherfish < 3 then
			fish = "stingraymeat"
			GiveFishingRep(math.random(2,5))
		end
		PugFishToggleItem(true, fish)
	end
end

--What fishing rewards the player gets when fishing with the fishinglure tier fishing
function FishRodLure1Loot()-- fishinglure rod loot table
	local fish = "tuna-fish"
	if GetFishingInfoClosed().intournarea and GetFishingInfoClosed().started then -- only true if in a fishing area during a fishing torunament
		FishingNotify(Translations.error.cant_use_in_tourn, 'error')
		return
	else
		local treasure = math.random(1,200)
		if treasure == 69 then
			PugFishToggleItem(true, Config.ChestItem)
			GiveFishingRep(math.random(10,20))
		end
		local lure1 = math.random(1,100)
		if lure1 == 69 then
			TriggerServerEvent("Pug:server:GiveLure")
			GiveFishingRep(math.random(7,10))
		end
		local lure2 = math.random(1,150)
		if lure2 == 69 then
			TriggerServerEvent("Pug:server:GiveLure2")
			GiveFishingRep(math.random(7,10))
		end
		local chestkey = math.random(1,300)
		if chestkey == 69 then
			PugFishToggleItem(true, Config.ChestKey)
			GiveFishingRep(math.random(10,20))
		end
		local bottlemap = math.random(1,400)
		if bottlemap == 69 then
			PugFishToggleItem(true, 'bottlemap')
			GiveFishingRep(math.random(10,20))
		end
		local luck = math.random(1,120)
		if luck == 120 then
			fish = "tuna-fish"
			GiveFishingRep(math.random(10,20))
		elseif luck >= 118 and luck < 120 then
			fish = "eelfish"
		elseif luck == 117 then
			fish = "tigershark"
			GiveFishingRep(math.random(5,10))
		elseif luck == 116 then
			fish = "tigershark"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 110 and luck < 115 then
			fish = "salmon"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 105 and luck < 110 then
			fish = "largemouthbass"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 100 and luck < 105 then
			fish = "killerwhale"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 95 and luck < 100 then
			fish = "redfish"
			GiveFishingRep(math.random(3,4))
		elseif luck >= 90 and luck < 95 then
			fish = "bluefish"
			GiveFishingRep(math.random(3,5))
		elseif luck >= 85 and luck < 90 then
			fish = "stripedbass"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 80 and luck < 85 then
			fish = "killerwhale"
			GiveFishingRep(math.random(2,3))
		elseif luck >= 75 and luck < 80 then
			fish = "swordfish"
			GiveFishingRep(math.random(2,3))
		elseif luck < 75 then
			fish = "tigershark"
			GiveFishingRep(math.random(2,3))
		end
		local otherfish = math.random(1,350)
		if otherfish >= 9 and otherfish < 12 then
			fish = "codfish"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 6 and otherfish < 9 then
			fish = "gholfish"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 3 and otherfish < 6 then
			fish = "rainbowtrout"
			GiveFishingRep(math.random(2,5))
		elseif otherfish >= 1 and otherfish < 3 then
			fish = "stingraymeat"
			GiveFishingRep(math.random(2,5))
		end
		PugFishToggleItem(true, fish)
	end
end

RegisterNetEvent("Pug:Fishing:ReloadSkin")
AddEventHandler("Pug:Fishing:ReloadSkin", function()
	if Config.LockInventory then
		LocalPlayer.state:set("inv_busy", false, true)
	end
	for k, v in pairs(GetGamePool('CObject')) do
		if IsEntityAttachedToEntity(PlayerPedId(), v) then
			SetEntityAsMissionEntity(v, true, true)
			DeleteObject(v)
			DeleteEntity(v)
		end
	end
    if Config.PugSlingScript then
	    TriggerEvent("Pug:ReloadGuns:sling")
    end
end)

--Key Lock minigame
-- Events
RegisterNetEvent('Pug:client:UseKeyOnChest', function()
	OpeningChest = true
	if Config.UsePSUiForTreasureMiniGame then
		exports['ps-ui']:Circle(function(success)
			if success then
				succededchestopen = true
				OpeningChest = false
				ClearPedTasks(PlayerPedId())
				Wait(4000)
				succededchestopen = false
				LocalPlayer.state:set("inv_busy", false, true)
			else
				OpeningChest = false
				succededchestopen = false
				PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
				LocalPlayer.state:set("inv_busy", false, true)
			end
    	end, 4, 18) -- NumberOfCircles, MS
	else
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = "openThermite",
			amount = math.random(5, 10),
		})
	end
end)

RegisterNetEvent('Pug:client:Openbottlemap', function()
    RequestAnimDict("mp_arresting")
    while (not HasAnimDictLoaded("mp_arresting")) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "mp_arresting" ,"a_uncuff" ,8.0, -8.0, -1, 1, 0, false, false, false )
    local Coords = GetEntityCoords(PlayerPedId())
    bottle = CreateObject(GetHashKey('p_amb_bag_bottle_01'), Coords.x, Coords.y,Coords.z, true, true, true)
    AttachEntityToEntity(bottle, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.05, 0.0, -40.0, 10.0, 90.0, false, false, false, false, 2, true)
	if Framework == "QBCore" then
		FWork.Functions.Progressbar("opening_box", "Opening bottle", 3700, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Don
			ExecuteCommand("e ".."smoke")
			TriggerEvent("Pug:Fishing:ReloadSkin")
			Wait(1000)
			DeleteEntity(bottle)
			Wait(1000)
			ExecuteCommand("e ".."map")
			Wait(2000)
			ExecuteCommand("e ".."smoke")
			TriggerEvent("Pug:Fishing:ReloadSkin")
			Wait(1300)
			ExecuteCommand("e ".."c")
			ClearPedTasks(PlayerPedId())
			PugFishToggleItem(true, "treasuremap", 1)
			Wait(500)
		end, function() -- Cancel
			PugFishToggleItem(true, "bottlemap", 1)
			TriggerEvent("Pug:Fishing:ReloadSkin")
			ClearPedTasks(PlayerPedId())
			FishingNotify(Translations.details.canceled, "error")
			Wait(500)
		end)
	else
		FWork.Progressbar("Opening bottle", 3700, {FreezePlayer = true, onFinish = function()
			ExecuteCommand("e ".."smoke")
			TriggerEvent("Pug:Fishing:ReloadSkin")
			Wait(1000)
			DeleteEntity(bottle)
			Wait(1000)
			ExecuteCommand("e ".."map")
			Wait(2000)
			ExecuteCommand("e ".."smoke")
			TriggerEvent("Pug:Fishing:ReloadSkin")
			Wait(1300)
			ExecuteCommand("e ".."c")
			ClearPedTasks(PlayerPedId())
			PugFishToggleItem(true, "treasuremap", 1)
			Wait(500)
		end, onCancel = function()
			PugFishToggleItem(true, "bottlemap", 1)
			TriggerEvent("Pug:Fishing:ReloadSkin")
			ClearPedTasks(PlayerPedId())
			FishingNotify(Translations.details.canceled, "error")
			Wait(500)
		end})
	end
end)

-- NUI Callbacks
RegisterNUICallback('TresureClick', function(_, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    cb('ok')
end)

RegisterNUICallback('TresureFailed', function(_, cb)
	OpeningChest = false
	succededchestopen = false
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
	LocalPlayer.state:set("inv_busy", false, true)
    cb('ok')
end)

RegisterNUICallback('TresureSuccess', function(_, cb)
	succededchestopen = true
	OpeningChest = false
    ClearPedTasks(PlayerPedId())
    cb('ok')
	Wait(4000)
	succededchestopen = false
	LocalPlayer.state:set("inv_busy", false, true)
end)

RegisterNUICallback('CloseTresure', function(_, cb)
	OpeningChest = false
    SetNuiFocus(false, false)
	LocalPlayer.state:set("inv_busy", false, true)
    cb('ok')
end)

-- Credits to ΛII#0007 for this
RegisterNetEvent("pug-fishing:client:OpenShop", function()
    TriggerServerEvent("pug-fishing:server:OpenShop") 
    exports.ox_inventory:openInventory("shop", { type = "fishingshop"})
end)

RegisterNetEvent("Pug:client:FishingNotify", function(msg, type, length)
	FishingNotify(msg, type, length)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		if Framework == "QBCore" then
			if Config.InventoryType == "ox" then
				exports.ox_inventory:displayMetadata({
					uses = "fishinglure",
					uses = "fishinglure2",
				})
			end
		end
	end
end)

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	if Config.InventoryType == "ox" then
		exports.ox_inventory:displayMetadata({
			uses = "fishinglure",
			uses = "fishinglure2",
		})
	end
end)