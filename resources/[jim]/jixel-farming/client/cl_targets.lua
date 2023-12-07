local Props = {}
local Targets = {}
local Blip = {}
local MeatProcess = Process.MeatProcess.Setup.Locations.ProcessLoc
local MilkProcessLoc = Process.MilkProcess.Setup.Locations
local MilkBucketLoc = Process.MilkProcess.MilkBucketSetup.BucketLocations
local multibucket = Process.MilkProcess.MultiBucketSetup
local bucketloc = Process.MilkProcess.BucketLoc
local ProcessorLoc = Process.Processor.Setup.Locations
local JuicerLoc = Process.Juicer.Setup.Locations
local PestleLoc = Process.Pestle.Setup.Locations
local ChickenProcessLoc = Process.ChickenProcess.Setup.Locations.ProcessLoc
local SlaughterLoc = Process.ChickenProcess.Setup.Locations.SlaughterLoc
local ChickenPrepLoc = Process.ChickenProcess.Setup.Locations.PrepLoc
local chickenslaughterzone = AnimalSettings.Chickens.SlaughterZone.Zone
local slaughterCowPigs = AnimalSettings.Cows.SlaughterZone.Zone
local slaughterCowPigsminz = AnimalSettings.Cows.SlaughterZone.minZ
local slaughterCowPigsmaxz = AnimalSettings.Cows.SlaughterZone.maxZ
local chichkenslaughterzonminz = AnimalSettings.Chickens.SlaughterZone.minZ
local chichkenslaughterzonmaxz = AnimalSettings.Chickens.SlaughterZone.maxZ
local Colors = {
  red = { r = 255, g = 0, b = 0, a = 100 },
  yellow = { r = 255, g = 255, b = 0, a = 100 },
  green = { r = 0, g = 255, b = 0, a = 100 },
  blue = { r = 0, g = 0, b = 255, a = 100 },
  purple = { r = 255, g = 0, b = 255, a = 100 },
  pink = { r = 255, g = 192, b = 203, a = 100 },
  lime = { r = 0, g = 255, b = 0, a = 100 },
  teal = { r = 0, g = 128, b = 128, a = 100 },
  gold = { r = 255, g = 215, b = 0, a = 100 },
  silver = { r = 192, g = 192, b = 192, a = 100 },
  cyan = { r = 0, g = 255, b = 255, a = 100 },
  magenta = { r = 255, g = 0, b = 255, a = 100 },
}
local slaughterZoneChickens = PolyZone:Create(chickenslaughterzone, { name="ChickenSlaughterZone", debugPoly = Config.DebugOptions.Debug, minZ = slaughterCowPigsminz, maxZ = slaughterCowPigsmaxz })
local slaughterZonePigsCows = PolyZone:Create(slaughterCowPigs, { name="PigSlaughterZone", debugPoly = Config.DebugOptions.Debug, minZ = chichkenslaughterzonminz, maxZ = chichkenslaughterzonmaxz })


CreateThread(function()
  for _, v in pairs(Process) do
    if v.BlipSettings.BlipEnabled then
        Blip[#Blip + 1] = makeBlip({
            coords = v.BlipSettings.BlipLoc,
            sprite = v.BlipSettings.BlipSprite,
            col = v.BlipSettings.BlipColor,
            scale = 0.65,
            disp = 6,
            name = v.BlipSettings.Label
        })
    end
  end
  for _, v in pairs(Zones.Trees) do
    if v.BlipEnabled then
      if Config.DebugOptions.Debug then print(tostring(v.BlipLoc), tostring(v.BlipSprite), tostring(v.BlipColor), tostring(v.ItemLabel)) end
      Blip[#Blip+1] = makeBlip({ coords = v.BlipLoc, sprite = v.BlipSprite, col = v.BlipColor, scale = 0.65, cat = 1, disp = 6, name = v.ItemLabel.." Zone"})
    end
  end
  for _, v in pairs(Zones.Plants) do
    if v.BlipEnabled then
    if Config.DebugOptions.Debug then print(tostring(v.BlipLoc), tostring(v.BlipSprite), tostring(v.BlipColor), tostring(v.ItemLabel)) end
    Blip[#Blip+1] = makeBlip({ coords = v.BlipLoc, sprite = v.BlipSprite, col = v.BlipColor, scale = 0.65, cat = 1, disp = 6, name = v.ItemLabel.." Zone"})
    end
  end
end)

for i , juicer in ipairs(JuicerLoc) do
  local targetName = "Juicer_"..i
  Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(juicer.coords.xyz), juicer.l, juicer.w,
    { name = targetName, heading = juicer.h, debugPoly = Config.DebugOptions.Debug, minZ = juicer.minZ, maxZ = juicer.maxZ, },
    { options = {
      {
        event = "jixel-farming:Crafting",
        icon = "fas fa-utensils",
        craftable = Crafting.Juicer,
        header = Loc[Config.CoreOptions.Lan].header["header_juicer"],
        label = Loc[Config.CoreOptions.Lan].target["juicer"],
        job = Config.ScriptOptions.Job },
    },
    distance = 2.0 })
  if juicer.prop then
    Props[#Props+1] = makeProp({prop = tostring(juicer.prop), coords = juicer.coords}, true, false)
    if juicer.prop2 then
      Props[#Props+1] = makeProp({prop = tostring(juicer.prop2), coords = juicer.prop2loc}, true, false)
    end
  end
end

for i , processor in ipairs(ProcessorLoc) do
  local targetName = "Processor_"..i
  Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(processor.coords.xyz), processor.l, processor.w,
    { name = targetName, heading = processor.h, debugPoly = Config.DebugOptions.Debug, minZ = processor.minZ, maxZ = processor.maxZ, },
    { options = {
      {
        event = "jixel-farming:Crafting",
        icon = "fas fa-utensils",
        craftable = Crafting.Processor,
        header = Loc[Config.CoreOptions.Lan].header["header_processor"],
        label = Loc[Config.CoreOptions.Lan].target["processor"],
        job = Config.ScriptOptions.Job
      },
    },
      distance = 2.0
    })
    if processor.prop then
      Props[#Props+1] = makeProp({prop = tostring(processor.prop), coords = processor.coords}, true, false)
      if processor.prop2 then
        Props[#Props+1] = makeProp({prop = tostring(processor.prop2), coords = processor.prop2loc}, true, false)
      end
    end
end

for i , milk in ipairs(MilkProcessLoc) do
  local targetName = "Milk_"..i
  Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(milk.coords.xyz), milk.l, milk.w,
    { name = targetName, heading = milk.h, debugPoly = Config.DebugOptions.Debug, minZ = milk.minZ, maxZ = milk.maxZ, },
    { options = {
      {
        event = "jixel-farming:Crafting",
        header = Loc[Config.CoreOptions.Lan].header["header_milkprocessor"],
        icon = "fas fa-utensils",
        craftable = Crafting.MilkProcess,
        label = Loc[Config.CoreOptions.Lan].target["milkprocessor"],
        job = Config.ScriptOptions.Job
      },
    },
      distance = 2.0
    })
end
if Process.MilkProcess.MilkBucketSetup.MilkBucket then
  for _, milkbucket in ipairs(MilkBucketLoc) do
    local options = { }
    if Process.MilkProcess.MilkBucketSetup.MultiBucket then
        local multibucketOptions = Process.MilkProcess.MilkBucketSetup.MultibucketOptions
        for _, amount in ipairs(multibucketOptions) do
            options[#options + 1] = { event = "jixel-farming:client:GetBucket", icon = "fas fa-sign-in-alt", label = Loc[Config.CoreOptions.Lan].target["grab_bucket"].." x"..json.encode(amount), amount = amount }
        end
    else
        options[#options + 1] = { event = "jixel-farming:client:GetBucket", icon = "fas fa-sign-in-alt", label = Loc[Config.CoreOptions.Lan].target["grab_bucket"], }
    end
      Targets["GetCowBucket"] =
      exports['qb-target']:AddBoxZone("GetCowBucket", vector3(milkbucket.coords.xyz), 0.5, 0.5,
        { name = "GetCowBucket", heading=315, debugPoly = Config.DebugOptions.Debug, minZ=milkbucket.z, maxZ=milkbucket.z, },
        { options = options, distance = 1.2 })
      if milkbucket.prop then
        Props[#Props+1] = makeProp({prop = tostring(milkbucket.prop), coords = milkbucket.coords}, true, false)
        if milkbucket.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(milkbucket.prop2), coords = milkbucket.prop2loc}, true, false)
        end
      end
  end
end

slaughterZoneChickens:onPlayerInOut(function(isPointInside)
    print(isPointInside)
    isPlayerInsideZone = isPointInside
      while isPlayerInsideZone do
        for _, locationGroup in pairs(Process.ChickenProcess.Setup.Locations) do
          for _, location in ipairs(locationGroup) do
            if not location.helpmarker then return end
            for _, helpmarker in pairs(location.helpmarker)do
              local markerColor = Colors[helpmarker.color]
              if not markerColor then
                  error(string.format("Invalid color %s", helpmarker.color))
              end
              local markerData = {
                  markerType = 26,
                  x = helpmarker.coords.x,
                  y = helpmarker.coords.y,
                  z = helpmarker.coords.z,
                  scaleX = helpmarker.scalex,
                  scaleY = helpmarker.scaley,
                  scaleZ = helpmarker.scalez,
                  red = markerColor.r,
                  green = markerColor.g,
                  blue = markerColor.b,
                  alpha = markerColor.a,
                  bobbing = helpmarker.bobbing,
                  faceCamera = true,
                  p19 = 2,
                  rotate = false
              }
              MarkerDraw(markerData)
            end
          end
        end
        Wait(0)
      end
end)

slaughterZonePigsCows:onPlayerInOut(function(isPointInside)
    isPlayerInsideZone = isPointInside
      while isPlayerInsideZone do
        for _, locationGroup in pairs(Process.MeatProcess.Setup.Locations) do
          for _, location in ipairs(locationGroup) do
            if not location.helpmarker then return end
            for _, helpmarker in pairs(location.helpmarker)do
              local markerColor = Colors[helpmarker.color]
              if not markerColor then
                  error(string.format("Invalid color %s", helpmarker.color))
              end
              local markerData = {
                  markerType = 26,
                  x = helpmarker.coords.x,
                  y = helpmarker.coords.y,
                  z = helpmarker.coords.z,
                  scaleX = helpmarker.scalex,
                  scaleY = helpmarker.scaley,
                  scaleZ = helpmarker.scalez,
                  red = markerColor.r,
                  green = markerColor.g,
                  blue = markerColor.b,
                  alpha = markerColor.a,
                  bobbing = helpmarker.bobbing,
                  faceCamera = true,
                  p19 = 2,
                  rotate = false
        }
              MarkerDraw(markerData)
            end
          end
        end
        Wait(0)
      end
  end)

  for i , chickenproc in ipairs(ChickenProcessLoc) do
    local targetName = "Chicken_"..i
    Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(chickenproc.coords.xyz), chickenproc.l, chickenproc.w,
      { name = targetName, heading = chickenproc.h, debugPoly = Config.DebugOptions.Debug, minZ = chickenproc.minZ, maxZ = chickenproc.maxZ, },
      { options = {
        {
          event = "jixel-farming:Crafting",
          icon = "fas fa-utensils",
          craftable = Crafting.ChickenProcess,
          label = Loc[Config.CoreOptions.Lan].target["chickenprocessor"],
          header = Loc[Config.CoreOptions.Lan].header["header_chickenprocessor"],
          job = Config.ScriptOptions.Job
        }, },
      distance = 2.0 })
      if chickenproc.prop then
        Props[#Props+1] = makeProp({prop = tostring(chickenproc.prop), coords = chickenproc.coords}, true, false)
        if chickenproc.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(chickenproc.prop2), coords = chickenproc.prop2loc}, true, false)
        end
      end
    end

    for i , chickenprep in ipairs(ChickenPrepLoc) do
      local targetName = "ChickenPrep_"..i
      Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(chickenprep.coords.xyz), chickenprep.l, chickenprep.w,
        { name = targetName, heading = chickenprep.h, debugPoly = Config.DebugOptions.Debug, minZ = chickenprep.minZ, maxZ = chickenprep.maxZ, },
        { options = {
          {
            event = "jixel-farming:client:PrepareChicken",
            icon = "fas fa-utensils",
            label = Loc[Config.CoreOptions.Lan].target["chickenprep"],
            job = Config.ScriptOptions.Job
          },
        },
        distance = 2.0 })
        if chickenprep.prop then
          Props[#Props+1] = makeProp({prop = tostring(chickenprep.prop), coords = chickenprep.coords}, true, false)
          if chickenprep.prop2 then
            Props[#Props+1] = makeProp({prop = tostring(chickenprep.prop2), coords = chickenprep.prop2loc}, true, false)
          end
        end
      end

    for i, slaughter in ipairs(SlaughterLoc) do
      local targetName = "SlaughterChicken"..i
      Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(slaughter.coords.xyz), slaughter.l, slaughter.w,
      { name = targetName, heading = slaughter.h, debugPoly = Config.DebugOptions.Debug, minZ = slaughter.minZ, maxZ = slaughter.maxZ, },
      { options = { { event = "jixel-farming:client:SlaughterChicken", icon = "fas fa-utensils", label = Loc[Config.CoreOptions.Lan].target["kill_chicken"], job = Config.ScriptOptions.Job }, },
      distance = 2.0 })
      if slaughter.prop then
        Props[#Props+1] = makeProp({prop = tostring(slaughter.prop), coords = slaughter.coords}, true, false)
        if slaughter.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(slaughter.prop2), coords = slaughter.prop2loc}, true, false)
        end
      end
    end

  for i, pestle in ipairs(PestleLoc) do
  local targetName = "Pestle"..i
    Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(pestle.coords.xyz), pestle.l, pestle.w,
      { name = targetName, heading = pestle.h, debugPoly = Config.DebugOptions.Debug, minZ = pestle.minZ, maxZ = pestle.maxZ, },
      { options = { { event = "jixel-farming:Crafting", icon = "fas fa-utensils", craftable = Crafting.Pestle,
      label = Loc[Config.CoreOptions.Lan].target["processor"], job = Config.ScriptOptions.Job, header = Loc[Config.CoreOptions.Lan].header["header_pestle"], }, },
      distance = 2.0 })
      if pestle.prop then
        Props[#Props+1] = makeProp({prop = tostring(pestle.prop), coords = pestle.coords}, true, false)
        if pestle.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(pestle.prop2), coords = pestle.prop2loc}, true, false)
        end
      end
  end

for i, meat in ipairs(MeatProcess) do
  local targetName = "MeatProcess"..i
    Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(meat.coords.xyz), meat.l, meat.w,
      { name = targetName, heading = meat.h, debugPoly = Config.DebugOptions.Debug, minZ = meat.minZ, maxZ = meat.maxZ, },
      { options = { { event = "jixel-farming:Crafting", header = Loc[Config.CoreOptions.Lan].header["header_meatprocessor"], icon = "fas fa-utensils", craftable = Crafting.MeatProcessor,
      label = Loc[Config.CoreOptions.Lan].target["meatprocessor"], job = Config.ScriptOptions.Job }, },
      distance = 2.0 })
      if meat.prop then
        Props[#Props+1] = makeProp({prop = tostring(meat.prop), coords = meat.coords}, true, false)
        if meat.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(meat.prop2), coords = meat.prop2loc}, true, false)
        end
    end
end
local SlaughterAnimalsLoc = {
  { coords = vector3(991.36, -2184.19, 30.68), l = 1.5, w = 1.5, h = 1.0, minZ = 30, maxZ = 31, },
}
for i, location in ipairs(SlaughterAnimalsLoc) do
  local targetName = "SlaughterAnimals"..i
  Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(location.coords.xyz), location.l, location.w,
    { name = targetName, heading = location.h, debugPoly = Config.DebugOptions.Debug, minZ = location.minZ, maxZ = location.maxZ, },
    { options = {
      { event = "jixel-farming:client:slaughterAnimal", icon = "fas fa-utensils", label = Loc[Config.CoreOptions.Lan].target["slaughter_cow"], animal = "cow" },
      { event = "jixel-farming:client:slaughterAnimal", icon = "fas fa-utensils", label = Loc[Config.CoreOptions.Lan].target["slaughter_pig"],  animal = "pig"},
    },
    distance = 2.0 })
end
if Config.ScriptOptions.DLC.jixelcigarbar then
  local dryingTargets = Process.Targets.CigarBarDrying
  local curingTargets = Process.Targets.CigarBarCuring
  for i, drying in ipairs(dryingTargets) do
    local targetName = "Drying_"..i
    Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(drying.coords.xyz), drying.l, drying.w,
      { name = targetName, heading = drying.h, debugPoly = Config.DebugOptions.Debug, minZ = drying.minZ, maxZ = drying.maxZ, },
      { options = {
        { event = "jixel-farming:client:DryingMenu",
          id=targetName,dryingItems = Crafting.Drying,
          label = Loc[Config.CoreOptions.Lan].target["drying"],
          job = Config.ScriptOptions.Job }, },
      distance = 2.0 })
      if drying.prop then
        Props[#Props+1] = makeProp({prop = tostring(drying.prop), coords = drying.coords, heading = drying.heading}, true, false)
        if drying.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(drying.prop2), coords = drying.prop2loc}, true, false)
      end
    end
  end
  for i, curing in ipairs(curingTargets) do
    local targetName = "Curing_"..i
    Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(curing.coords.xyz), curing.l, curing.w,
      { name = targetName, heading = curing.h, debugPoly = Config.DebugOptions.Debug, minZ = curing.minZ, maxZ = curing.maxZ, },
      { options = {
        { event = "jixel-farming:client:CuringMenu",
          id=targetName,cureItems = Crafting.Curing,
          label = Loc[Config.CoreOptions.Lan].target["curing"],
          job = Config.ScriptOptions.Job }, },
      distance = 2.0 })
      if curing.prop then
        Props[#Props+1] = makeProp({prop = tostring(curing.prop), coords = curing.coords, heading = curing.heading}, true, false)
        if curing.prop2 then
          Props[#Props+1] = makeProp({prop = tostring(curing.prop2), coords = curing.prop2loc}, true, false)
      end
    end
  end
  else
    local curingTargets = Process.Targets.Curing
    local dryingTargets = Process.Targets.Drying
    for i, drying in ipairs(dryingTargets) do
      local targetName = "Drying_"..i
      Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(drying.coords.xy, drying.coords.z - 3.0), drying.l, drying.w,
        { name = targetName, heading = drying.h, debugPoly = Config.DebugOptions.Debug, minZ = drying.minZ, maxZ = drying.maxZ, },
        { options = {
          { event = "jixel-farming:client:DryingMenu",
            id=targetName,dryingItems = Crafting.Drying,
            label = Loc[Config.CoreOptions.Lan].target["drying"],
            job = Config.ScriptOptions.Job }, },
        distance = 2.0 })
        if drying.prop then
          Props[#Props+1] = makeProp({prop = tostring(drying.prop), coords = drying.coords, heading = drying.heading}, true, false)
          if drying.prop2 then
            Props[#Props+1] = makeProp({prop = tostring(drying.prop2), coords = drying.prop2loc}, true, false)
        end
      end
    for i, curing in ipairs(curingTargets) do
      local targetName = "Curing_"..i
      Targets[targetName] = exports['qb-target']:AddBoxZone(targetName, vector3(curing.coords.xy, curing.coords.z - 3.0), curing.l, curing.w,
        { name = targetName, heading = curing.h, debugPoly = Config.DebugOptions.Debug, minZ = curing.minZ, maxZ = curing.maxZ, },
        { options = {
          { event = "jixel-farming:client:CuringMenu",
            id=targetName,cureItems = Crafting.Curing,
            label = Loc[Config.CoreOptions.Lan].target["curing"],
            job = Config.ScriptOptions.Job }, },
        distance = 2.0 })
        if curing.prop then
          Props[#Props+1] = makeProp({prop = tostring(curing.prop), coords = curing.coords, heading = curing.heading}, true, false)
          if curing.prop2 then
            Props[#Props+1] = makeProp({prop = tostring(curing.prop2), coords = curing.prop2loc}, true, false)
        end
      end
    end
  end
end
RegisterNetEvent('jixel-farming:client:GetBucket', function(data)
  getBucket(data.amount)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	for _, v in pairs(Props) do unloadModel(GetEntityModel(v)) DeleteObject(v) end
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
    exports[Config.CoreOptions.CoreName]:HideText()
end)


