-- ⚠️ ATTENTION: This config is only intended for the QBCore framework.
-- ⚠️ If you're using the resources in a different framework, please use the config for the specific framework instead.
PublicQBCoreConfig = {
    -- 📣 You don't need to change anything here unless you've modified your QBCore framework.
    ResourceName = "qb-core",
    ExportName = "GetCoreObject",
    EventName = "QBCore:GetObject",

    -- 📣 Event that is triggered on the client when the player spawns. (Customizations in public/client/api.lua)
    ClientPlayerLoadEvent = "QBCore:Client:OnPlayerLoaded",

    -- 📣 Event that is triggered on the server when the player spawns. (Customizations in public/server/api.lua)
    ServerPlayerLoadEvent = "QBCore:Server:OnPlayerLoaded",

    -- 📣 Event that is triggered on the client when the player job is updated. (Customizations in public/client/api.lua)
    ClientPlayerJobUpdateEvent = "QBCore:Client:OnJobUpdate",

    -- 📣 Event that is triggered on the server when the player job is updated. (Customizations in public/server/api.lua)
    ServerPlayerJobUpdateEvent = "QBCore:Server:OnJobUpdate",

    -- 👮 Determine permission levels for each QBCore group
    -- 📣 PERMISSION_LOW = Lowest permission level
    -- 📣 PERMISSION_MEDIUM = Medium permission level
    -- 📣 PERMISSION_HIGH = Highest permission level
    -- 📣 Permission level requirements are defined in the config for each resource
    PermissionLevel = {
        god = PERMISSION_HIGH,
        admin = PERMISSION_HIGH,
        mod = PERMISSION_MEDIUM,
    },
}
