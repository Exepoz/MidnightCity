local QBCore = exports["qb-core"]:GetCoreObject()

local PlayerData = nil

local currentWalkingStyle = nil
local currentMood = nil

local function SetWalkingStyle()
    local playerPed = PlayerPedId()
    RequestAnimSet(currentWalkingStyle)
    while not HasAnimSetLoaded(currentWalkingStyle) do Wait(10) end
    SetPedMovementClipset(playerPed, currentWalkingStyle, 1)
    TriggerEvent("crouchprone:client:SetWalkSet", currentWalkingStyle)
end

local function SetMood()
    SetFacialIdleAnimOverride(PlayerPedId(), currentMood, 0)
end

local function SaveWalkingStyle()
    TriggerServerEvent("is-playerstyles:server:SaveStyle", "walkingStyle", currentWalkingStyle)
    QBCore.Functions.Notify(Locale[Config.Language]["walking_style_set_success"], "success")
end

local function SaveMood()
    TriggerServerEvent("is-playerstyles:server:SaveStyle", "mood", currentMood)
    QBCore.Functions.Notify(Locale[Config.Language]["mood_set_success"], "success")
end

local function SetAndSaveWalkingStyle(walkingStyle)
    currentWalkingStyle = walkingStyle
    SetWalkingStyle()
    SaveWalkingStyle()
end

local function SetAndSaveMood(mood)
    currentMood = mood
    SetMood()
    SaveMood()
end

local function OpenWalkingStylesMenu()
    local menu = {
        {
            header = Locale[Config.Language]["menu_go_back"],
            icon = "fa-solid fa-backspace",
            params = {
                isAction = true,
                event = OpenStylesMenu,
            }
        },
        {
            header = Locale[Config.Language]["walking_styles"],
            txt = Locale[Config.Language]["walking_styles_desc"],
            isMenuHeader = true,
            icon = "fa-solid fa-walking"
        }
    }
    for _, v in pairs(Config.WalkingStyles) do
        local current = currentWalkingStyle == v.Style
        menu[#menu + 1] = {
            header = v.Name,
            txt = current and "Current" or "",
            icon = current and "fa-solid fa-check-circle" or "",
            params = {
                event = SetAndSaveWalkingStyle,
                args = v.Style,
                isAction = true
            }
        }
    end
    exports["qb-menu"]:openMenu(menu)
end

local function OpenMoodsMenu()
    local menu = {
        {
            header = Locale[Config.Language]["menu_go_back"],
            icon = "fa-solid fa-backspace",
            params = {
                isAction = true,
                event = OpenStylesMenu,
            }
        },
        {
            header = Locale[Config.Language]["moods"],
            txt =  Locale[Config.Language]["moods_desc"],
            isMenuHeader = true,
            icon = "fa-solid fa-grin"
        }
    }

    for _, v in pairs(Config.Moods) do
        local current = currentMood == v.Mood
        menu[#menu + 1] = {
            header = v.Name,
            txt = current and "Current" or "",
            icon = current and "fa-solid fa-check-circle" or "",
            params = {
                event = SetAndSaveMood,
                args = v.Mood,
                isAction = true
            }
        }
    end
    exports["qb-menu"]:openMenu(menu)
end

function OpenStylesMenu()
    local menu = {
        {
            header = Locale[Config.Language]["player_styles"],
            txt = Locale[Config.Language]["player_styles_desc"],
            isMenuHeader = true,
            icon = "fa-solid fa-user"
        },
        {
            header = Locale[Config.Language]["walking_style"],
            txt = Locale[Config.Language]["walking_styles_desc"],
            icon = "fa-solid fa-walking",
            params = {
                event = OpenWalkingStylesMenu,
                isAction = true
            }
        },
        {
            header = Locale[Config.Language]["mood"],
            txt = Locale[Config.Language]["moods_desc"],
            icon = "fa-solid fa-grin",
            params = {
                event = OpenMoodsMenu,
                isAction = true
            }
        }
    }
    exports["qb-menu"]:openMenu(menu)
end

local function getDefaultWalkingStyle()
    local isMale = PlayerData.charinfo.gender == 0
    return (isMale and Config.DefaultWalkingStyles.Male or Config.DefaultWalkingStyles.Female)
end

local function Init()
    PlayerData = QBCore.Functions.GetPlayerData()
    Wait(Config.ApplyDelay) -- Delay to make sure that the ped has spawned
    currentWalkingStyle = PlayerData.metadata["walkingStyle"] or getDefaultWalkingStyle()
    currentMood = PlayerData.metadata["mood"] or Config.DefaultMood
    SetWalkingStyle()
    SetMood()
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Init()
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    Init()
end)

RegisterNetEvent("is-playerstyles:client:OpenStylesMenu", function()
    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        QBCore.Functions.Notify(Locale[Config.Language]["cannot_open_in_vehicle"], "error")
        return
    end

    OpenStylesMenu()
end)

RegisterNetEvent("is-playerstyles:client:ResetWalkingStyle", function()
    SetAndSaveWalkingStyle(getDefaultWalkingStyle())
end)

RegisterNetEvent("is-playerstyles:client:ResetMood", function()
    SetAndSaveMood(Config.DefaultMood)
end)

for _, v in pairs(Config.WalkingStyleEvents) do
    RegisterNetEvent(v.Name, function()
        Wait(v.Delay)
        SetWalkingStyle()
    end)
end

for _, v in pairs(Config.WalkingStyles) do
    RegisterNetEvent("is-playerstyles:client:SetWalkingStyle:" .. v.Name, function()
        SetAndSaveWalkingStyle(v.Style)
    end)
end

for _, v in pairs(Config.Moods) do
    RegisterNetEvent("is-playerstyles:client:SetMood:" .. v.Name, function()
        SetAndSaveMood(v.Mood)
    end)
end

exports("SetWalkingStyle", SetWalkingStyle)
exports("SetMood", SetMood)
