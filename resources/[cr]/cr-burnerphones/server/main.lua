local CRBurnerphones = {}
CRBurnerphones.Phones = {}
CRBurnerphones.Locations = {}
CurrentDrops = {}
GlobalState.CRBurnerphones = CRBurnerphones

local function VersionCheck()
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        local function ToNumber(cd) return tonumber(cd) end
        local resource_name = GetCurrentResourceName()
        local current_version = GetResourceMetadata(resource_name, 'version', 0)
        PerformHttpRequest('https://github.com/Constant-Development/cr-versions/blob/main/'..resource_name..'.txt?raw=true',function(_, r, _)
            if not r then print('^8Cannot Reach GitHub, Updater Disabled^0') return end
            local result = json.decode(r:sub(1, -1))
            local color = '^9'--'^'..math.random(2,9)
            local symbols = color..'~= ^5Constant Development Updater '..color
            local suffix = ""
            for _ = 1, 26+#resource_name do
                suffix = suffix..'='
            end
            symbols = symbols..suffix..'~^0'
            if ToNumber(result.version:gsub('%.', '')) > ToNumber(current_version:gsub('%.', '')) then
                print(symbols)
                print('^1 ['..resource_name..'] - Update Available!\n'..color..'^0 You are using: ^3'..current_version..'^0\n Version Available: ^3'..result.version..'\n^0 Changelog: ^3'..result.notes..'^0\n See Discord for full changelog ^3(https://discord.gg/5Trc4nEuga)')
                print(symbols)
            else
                --print(symbols)
                print('^2 ['..resource_name..'] ~ v'..current_version..' ~ Up to Date!^0')
                --print(symbols)
            end
        end,'GET')
    end)
end

local function SetupGlobalCooldown(time)
    Citizen.CreateThread(function()
        if time then
            CRBurnerphones.GlobalCooldown = true
            GlobalState.CRBurnerphones = CRBurnerphones
            Wait(time * 60000)
            CRBurnerphones.GlobalCooldown = false
            GlobalState.CRBurnerphones = CRBurnerphones
        end
    end)
end

local function SetupPhoneCooldown(phone, time)
    Citizen.CreateThread(function()
        if time then
            CRBurnerphones.Phones[phone].onCooldown = true
            GlobalState.CRBurnerphones = CRBurnerphones
            Wait(time * 60000)
            CRBurnerphones.Phones[phone].onCooldown = false
            GlobalState.CRBurnerphones = CRBurnerphones
        end
    end)
end

RegisterNetEvent('cr-burnerphones:server:GetNextLoc')
AddEventHandler('cr-burnerphones:server:GetNextLoc', function(phone)
    local selected, ran, coords
    local Phone = Config.Burnerphones[phone]
    local checks = 0
    local totalchecks = 0
    for _, v in pairs(Config.Burnerphones) do
        totalchecks = totalchecks + #v.DropOffLocations
    end
    while not selected do
        checks = checks + 1
        ran = math.random(#Phone.DropOffLocations)
        coords = Phone.DropOffLocations[ran]
        local invalid = false
        for k, _ in pairs(CurrentDrops) do
            if #(k - coords) < 5.0 then invalid = true end
        end
        if not invalid then selected = true end
        if checks > totalchecks then print(Lcl('debug_ErrorSelecting')) return end
    end
    CurrentDrops[coords] = coords
    CRBurnerphones.Phones[phone] = {NextLoc = ran}
    GlobalState.CRBurnerphones = CRBurnerphones
    --print(phone.." | "..ran.." | ("..coords..")")
end)

RegisterServerEvent('cr-burnerphones:server:BurnerPhoneReward')
AddEventHandler('cr-burnerphones:server:BurnerPhoneReward', function(phone, ran, loc)
    local src = source
    local Phone = Config.Burnerphones[phone]
    local coords = Phone.DropOffLocations[loc]
    if GlobalState.CRBurnerphones.Locations[coords] then
        CRBurnerphones.Locations[coords] = nil
        GlobalState.CRBurnerphones = CRBurnerphones
        local reward = Phone.Rewards[ran].item
        local amount = math.random(Phone.Rewards[ran].qty.min, Phone.Rewards[ran].qty.max)
        if BSUtils.GiveItem(src, reward, amount) then
            if Config.Logs then BSUtils.Logs(Lcl('logs_ItemPickedUp'), 'green', '**'..Lcl('logs_Player')..' :** '..GetPlayerName(src)..'\n**'..Lcl('logs_Item')..' :** '..reward..' **'..Lcl('logs_Amount')..' :** '..amount) end
            TriggerClientEvent('cr-burnerphones:client:deleteBox', -1, phone, loc, ran)
            CurrentDrops[Phone.DropOffLocations[loc]] = nil
        else
            BSUtils.Notify(3, Lcl('notif_CantCarry'), Lcl('title_CantCarry'))
        end
    end
end)

RegisterNetEvent('cr-burnerphones:server:Battery')
AddEventHandler('cr-burnerphones:server:Battery', function(item)
    local src = source
    BSUtils.PhoneBattery(src, item)
end)

RegisterNetEvent('cr-burnerphones:server:BatteryOut')
AddEventHandler('cr-burnerphones:server:BatteryOut', function(item, serversrc)
    local src = serversrc or source
    if BSUtils.RemoveItem(src, item, 1) then
        if Config.Logs then TriggerEvent('qb-log:server:CreateLog', 'burnerphone', Lcl('logs_BurnerphoneBroke'), 'red', {ply = GetPlayerName(src), txt = Lcl('logs_Player')..' '..GetPlayerName(src)}) end
    end
end)

RegisterNetEvent('cr-burnerphones:server:callCops')
AddEventHandler('cr-burnerphones:server:callCops', function(coords)
    TriggerClientEvent('cr-burnerphones:client:callCops', -1, coords)
end)

-- Placing Drop + Syncing Accross All Clients DONE
RegisterNetEvent('cr-burnerphones:server:setUpDrop')
AddEventHandler('cr-burnerphones:server:setUpDrop', function(phone, loc, reward)
    CRBurnerphones.Locations[Config.Burnerphones[phone].DropOffLocations[loc]] = true
    GlobalState.CRBurnerphones = CRBurnerphones
    TriggerClientEvent('cr-burnerphones:client:setUpDrop', -1, phone, loc, reward)
    if Config.Logs then BSUtils.Logs(Lcl('logs_BurnerPhoneUsed', phone), 'blue', '**'..Lcl('logs_Player')..'** '..GetPlayerName(source)) end
end)


RegisterNetEvent('cr-burnerphones:server:SetCooldown')
AddEventHandler('cr-burnerphones:server:SetCooldown', function(phone)
    if Config.SharedCooldown then SetupGlobalCooldown(Config.CooldownTime)
    else SetupPhoneCooldown(phone, Config.Burnerphones[phone].CooldownTime) end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        VersionCheck()
        for k, _ in pairs(Config.Burnerphones) do
            TriggerEvent('cr-burnerphones:server:GetNextLoc', k)
        end
        if Config.DevMode then return end
        if not Config.ServerStartCooldown then return end
        SetupGlobalCooldown(Config.ServerStartCooldownTime)
    end
end)
