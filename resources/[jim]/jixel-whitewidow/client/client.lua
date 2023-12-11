local QBCore = exports[Config.Core]:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports[Config.Core]:GetCoreObject() end)
PlayerJob = {}
local Targets = {}
local Blips = {}
local onDuty = false
local Props = {}

local function jobCheck()
	canDo = true
	if not onDuty then triggerNotify(nil, Loc[Config.Lan].error["not_clockin"], 'error') canDo = false end
	return canDo
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        for k, v in pairs(Config.Locations) do
          if PlayerData.job.onduty then if PlayerData.job.name == v.job then TriggerServerEvent("QBCore:ToggleDuty") end end
        end
    end)
end)
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end)
RegisterNetEvent('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
  QBCore.Functions.GetPlayerData(function(PlayerData)
    PlayerJob = PlayerData.job
    for k, v in pairs(Config.Locations) do
      if PlayerData.job.onduty then if PlayerData.job.name == v.job then TriggerServerEvent("QBCore:ToggleDuty") end end
    end
  end)
end)

RegisterNetEvent('jixel-whitewidow:Crafting', function(data)
    lookEnt(data.coords)
    local Menu = {}
    Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
    Menu[#Menu + 1] = { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = "" } }
    for i = 1, #data.craftable do
      for k, v in pairs(data.craftable[i]) do
        if k ~= "amount" then
          local text = ""
          setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[k].image.." width=35px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[tostring(k)].label
          if data.craftable[i]["amount"] ~= nil then setheader = setheader.." x"..data.craftable[i]["amount"] end
          local disable = false
          local checktable = {}
          for l, b in pairs(data.craftable[i][tostring(k)]) do
            if b == 1 then number = "" else number = " x"..b end
            if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
            text = text.."- "..QBCore.Shared.Items[l].label..number.."<br>"
            settext = text
            checktable[l] = HasItem(l, b)
          end
          for _, v in pairs(checktable) do if v == false then disable = true break end end
          if not disable then setheader = setheader.." ✔️" end
          local event = "jixel-whitewidow:Crafting:MakeItem"
          if Config.MultiCraft then event = "jixel-whitewidow:Crafting:MultiCraft" end
          Menu[#Menu + 1] = { hidden = Config.Hidden, disabled = disable, icon = k, header = setheader, txt = settext, params = { event = event, args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header } } }
          settext, setheader = nil
        end
      end
    end
    exports['qb-menu']:openMenu(Menu)
end)
local nonConsumable = {
	['gummymould'] = true,
	['grinder'] = true,
  ['trimmers'] = true,
}
RegisterNetEvent('jixel-whitewidow:Crafting:MultiCraft', function(data)
  local success = { ["5"] = true, ["10"] = true }
  for _, v in pairs({5, 10}) do for l, b in pairs(data.craft[data.item]) do print(l, b) local e = v if nonConsumable[l] then e = 1 end local has, _ = HasItem(l, (b * e)) if not has then success[tostring(v)] = false break else success[tostring(v)] = true end end end

  local Menu = {}
  Menu[#Menu + 1] = { header = data.header, txt = "", isMenuHeader = true }
  Menu[#Menu + 1] = { icon = "fas fa-arrow-left", header = "", txt = Loc[Config.Lan].menu["back"], params = { event = "jixel-whitewidow:Crafting", args = data } }

  local setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[data.item].image.." width=35px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[data.item].label

  Menu[#Menu + 1] = { icon = data.item, header = setheader.." x1", params = { event = "jixel-whitewidow:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, amount = 1 } } }
  Menu[#Menu + 1] = { disabled = not success["5"], icon = data.item, header = setheader.." x5", params = { event = "jixel-whitewidow:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, amount = 5 } } }
  Menu[#Menu + 1] = { disabled = not success["10"], icon = data.item, header = setheader.." x10", params = { event = "jixel-whitewidow:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craftable, header = data.header, amount = 10 } } }
  --Menu[#Menu + 1] = { icon = data.item, header = setheader.." (All)", params = { event = "jixel-whitewidow:Crafting:MakeItem", args = { item = data.item, craft = data.craft, craftable = data.craft, header = data.header, amount = "all"} } }

  exports['qb-menu']:openMenu(Menu)
end)

RegisterNetEvent('jixel-whitewidow:Crafting:TableBong', function(data) -- Alternative Event to help separtate the type of
  lookEnt(data.coords)
  local Menu = { { header = data.header, txt = "", isMenuHeader = true },  { icon = "fas fa-circle-xmark", header = "", txt = Loc[Config.Lan].menu["close"], params = { event = ""} } }
  for i = 1, #data.craftable do
    for k, v in pairs(data.craftable[i]) do
      if k ~= "amount" then
        local text, disable, checktable = table.unpack({"", false, {}})
        setheader = "<img src=nui://"..Config.img..QBCore.Shared.Items[k].image.." width=35px onerror='this.onerror=null; this.remove();'>"..QBCore.Shared.Items[tostring(k)].label
        if data.craftable[i]["amount"] ~= nil then setheader = setheader.." x"..data.craftable[i]["amount"] end
        for l, b in pairs(data.craftable[i][tostring(k)]) do
          if not QBCore.Shared.Items[l] then print("^3Error^7: ^2Script can't find ingredient item in QB-Core items.lua - ^1"..l.."^7") return end
          checktable[l] = HasItem(l, b)
        end
        for _, v in pairs(checktable) do if v == false then disable = true break end end
        Menu[#Menu + 1] = { hidden = disable, icon = k, header = setheader, txt = "", params = { event = "jixel-whitewidow:Crafting:MakeItem", args = { item = k, craft = data.craftable[i], craftable = data.craftable, header = data.header } } }
        settext, setheader = nil
      end
    end
  end
  if #Menu > 2 then
    exports['qb-menu']:openMenu(Menu)
  else
    triggerNotify(nil, Loc[Config.Lan].error["not_clockin"], 'error')
  end
end)

RegisterNetEvent('jixel-whitewidow:Crafting:MakeItem', function(data)
  if data.amount then data.craft["amount"] = data.amount for k, v in pairs(data.craft[data.item]) do data.craft[data.item][k] = (data.craft[data.item][k] * data.amount) end end

  local ped, stress, health, armour, animDictNow, animNow, bartext, duration, bong = table.unpack({PlayerPedId(), "", "", "", "", "", "", 0, false})
  if data.header == Loc[Config.Lan].menu["header_tablebong"] or data.header == Loc[Config.Lan].menu["header_bong"] then bong = true end
  for _, v in pairs(Bud) do if data.item == v.Name then stress = v.Stress health = v.Health armour = v.Armour end end
  if data.header == Loc[Config.Lan].menu["header_oven"] then -- Oven
    animDictNow = "amb@prop_human_bbq@male@base"
    animNow = "base"
    bartext = Loc[Config.Lan].progressbar["progress_cook"]
    duration = 5000
  elseif data.header == Loc[Config.Lan].menu["header_harvest"] then -- Harvest
    animDictNow = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    animNow = "weed_crouch_checkingleaves_idle_01_inspector"
    bartext = Loc[Config.Lan].progressbar["progress_harvest"]
    duration = 5000
  elseif data.header == Loc[Config.Lan].menu["header_joints"] then -- Joints
    animDictNow = "amb@prop_human_parking_meter@female@base"
    animNow = "base_female"
    bartext = Loc[Config.Lan].progressbar["progress_rolling"]
    duration = 5000
  elseif data.header == Loc[Config.Lan].menu["header_trimming"] then -- Trimming
    animDictNow = "amb@prop_human_parking_meter@female@base"
    animNow = "base_female"
    bartext = Loc[Config.Lan].progressbar["progress_trimming"]
    duration = 5000
  elseif data.header == Loc[Config.Lan].menu["header_tablebong"] then -- BongTable
    --animDictNow = "anim@safehouse@bong" -- keep these for when we can be arsed adding props to progressbar
    --animNow = "bong_stage1"
    ExecuteCommand("e bong") -- lol hax (easier than adding a prop command to the progressbar)
    bartext = Loc[Config.Lan].progressbar["progress_smoke"]
    duration = 10000
  elseif data.header == Loc[Config.Lan].menu["header_bong"] then -- BongTable
    ExecuteCommand("e bong") -- lol hax (easier than adding a prop command to the progressbar)
    bartext = Loc[Config.Lan].progressbar["progress_smoke"]
    duration = 10000
  end
  QBCore.Functions.Progressbar('making_food', bartext..QBCore.Shared.Items[data.item].label, duration, false, true,
  { disableMovement = true, disableCarMovement = false, disableMouse = false, disableCombat = false, },
  { animDict = animDictNow, anim = animNow, flags = 49, },
  {}, {}, function()
    if bong then
      ExecuteCommand("e c")
      toggleItem(false, data.item, 1)
      SetEntityHealth(ped, GetEntityHealth(ped) + health)
      TriggerServerEvent('hud:server:RelieveStress', stress)
      AddArmourToPed(ped, GetPedArmour(ped) + armour)
      ClearPedTasks(ped)
      if Config.ScreenEffects then CreateThread(function() BongEffect() end) end
    else TriggerServerEvent("jixel-whitewidow:Crafting:GetItem", data.item, data.craft) end
      Wait(500)
      TriggerEvent("jixel-whitewidow:Crafting", data)
  end, function() -- Cancel
    ClearPedTasks(PlayerPedId())
    TriggerEvent('inventory:client:busy:status', false)
    if bong then ExecuteCommand("e c") end
  end, data.item)
end)

RegisterNetEvent("jixel-whitewidow:client:UseDroog", function(args) --Functions for usable items
  local ped, item, animDictNow, animNow, duration, prop, bone, rotation, bartext, joint = table.unpack({PlayerPedId(), {}, "", "", 0, "", nil, nil, "", false --[[0.03, -0.05, 0.0, 10.0, 70.0]]})
  for _, v in pairs(Edibles) do if args == v.Name then item = v animDictNow = "mp_suicide" animNow = "Pill" prop = nil bone = nil rotation = nil bartext = Loc[Config.Lan].progressbar["progress_eat"] break end end
  for _, v in pairs(Joints) do if args == v.Name then item = v animDictNow = "timetable@gardener@smoking_joint" animNow = "smoke_idle" prop = "p_amb_joint_01" bone = "57005" rotation = 0.12 joint = true bartext = Loc[Config.Lan].progressbar["progress_smoke"] break end end

  QBCore.Functions.Progressbar(item.Name, bartext..QBCore.Shared.Items[item.Name].label.."..", 3000, false, true,
  { disableMovement = true, disableCarMovement = false, disableMouse = false, disableCombat = true, },
  { animDict = animDictNow, anim = animNow, flags = 49, }, {}, {}, function()
    toggleItem(false, item.Name, 1)
    if QBCore.Shared.Items[item.Name].hunger then TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + QBCore.Shared.Items[item.Name].hunger) end
    if QBCore.Shared.Items[item.Name].thirst then TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + QBCore.Shared.Items[item.Name].thirst) end
    SetEntityHealth(ped, GetEntityHealth(ped) + tonumber(item.Health))
    TriggerServerEvent('hud:server:RelieveStress', tonumber(item.Stress))
    AddArmourToPed(ped, GetPedArmour(ped) + tonumber(item.Armour))
    ClearPedTasks(ped)
    if Config.ScreenEffects then if joint then CreateThread(function() JointEffect() end) else CreateThread(function() EdiblesEffect() end) end end
  end, function() -- Cancel
    ClearPedTasks(ped)
    TriggerEvent('inventory:client:busy:status', false)
  end)
end)

RegisterNetEvent('jixel-whitewidow:client:Menu:Close', function() exports['qb-menu']:closeMenu() end)

RegisterNetEvent('jixel-whitewidow:Stash', function(data)
  --for k, v in pairs(data) do print (tostring(k).." "..json.encode(v)) end
  lookEnt(data.coords)
  if Config.Inv == "ox_inv" then
    exports.ox_inventory:openInventory('stash', data.stash)
  else
    TriggerEvent("inventory:client:SetCurrentStash", data.stash)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", data.stash)
  end
end)

RegisterNetEvent('jixel-whitewidow:Shop', function(data)
	if not jobCheck() then return end
	lookEnt(data.coords)
	local event = "inventory:server:OpenInventory"
	if Config.JimShop then event = "jim-shops:ShopOpen"
  elseif Config.Inv == "ox_inv" then exports.ox_inventory:openInventory('shop', { type = data.wjob.."ingredients", id = 1 }) end
	TriggerServerEvent(event, "shop", data.wjob, Config.Items)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() or not LocalPlayer.state.isLoggedIn then return end
	for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
  for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
  exports[Config.Core]:HideText()
  exports['qb-menu']:closeMenu()
end)