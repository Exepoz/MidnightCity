-- ⚠️ ATTENTION: This config is only intended for the ESX framework.
-- ⚠️ If you're using the resources in a different framework, please use the config for the specific framework instead.
PublicESXConfig = {
    -- 📣 You don't need to change anything here unless you've modified your ESX framework.
    ResourceName = "es_extended",
    ExportName = "getSharedObject",
    EventName = "esx:getSharedObject",

    -- 📣 Event that is triggered on the client when the player spawns. (Customizations in public/client/api.lua)
    ClientPlayerLoadEvent = "esx:playerLoaded",

    -- 📣 Event that is triggered on the server when the player spawns. (Customizations in public/server/api.lua)
    ServerPlayerLoadEvent = "esx:playerLoaded",

    -- 📣 Event that is triggered on the client when the player job is updated. (Customizations in public/client/api.lua)
    ClientPlayerJobUpdateEvent = "esx:setJob",

    -- 📣 Event that is triggered on the server when the player job is updated. (Customizations in public/server/api.lua)
    ServerPlayerJobUpdateEvent = "esx:setJob",

    -- 👮 Determine permission levels for each ESX group
    -- 📣 PERMISSION_LOW = Lowest permission level
    -- 📣 PERMISSION_MEDIUM = Medium permission level
    -- 📣 PERMISSION_HIGH = Highest permission level
    -- 📣 Permission level requirements are defined in the config for each resource
    PermissionLevel = {
        superadmin = PERMISSION_HIGH,
        admin = PERMISSION_HIGH,
        mod = PERMISSION_MEDIUM,
    },
}
