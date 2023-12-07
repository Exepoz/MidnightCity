PublicSharedConfig = {
    -- ⚡ Specify the framework you're using. Can be the following: esx, qbcore, custom
    Framework = "qbcore",

    -- 🗣️ Specify the language you're using. For more information on available languages visit our docs in https://docs.cdev.shop/fivem-resources/locales
    Language = "en",

    -- 👀 Specify the third eye/target resource you're using. Can be the following: qbcore, qtarget, ox, renewed(doesn't work in all props), custom
    Target = "qbcore",

    -- 🎒 Specify the inventory resource you're using. Can be the following: qbcore, ox, custom
    Inventory = "qbcore",

    -- 🚗 Specify the garage resource you're using. Can be the following: qbcore, esx, codesign, loaf, custom (only for cdev_restaurants)
    Garage = "qbcore",

    -- 🗝️ Specify the vehicle key resource you're using. Can be the following: qbcore, codesign, custom
    VehicleKey = "qbcore",

    -- 🕒 Specify the progress bar resource you're using. Can be the following: qbcore, ox, custom (only for cdev_restaurants)
    ProgressBar = "qbcore",

    -- 💬 Set this to true if you want to use your own notification UI instead of the cDev one. (Implement in public/client/api.lua)
    UseCustomNotifications = false,

    -- 📦 Set this to false if you use a custom database system. (Implement in public/server/api.lua, also remove the dependency in fxmanifest.lua)
    UseMySQL = true,

    -- 📄 Enable discord logs (webhook URL in public/server/api.lua)
    DiscordLogs = false,

    -- ⚙️ Enable debug mode (prints in console)
    Debug = true,

    -- 📄 Change the DrawText font (you can check all the available fonts at the end of this link: https://wiki.rage.mp/index.php?title=Fonts_and_Colors)
    DrawTextConfig = {
        OverrideDrawtextFont = false,
        OverrideDrawtextFontId = 1
    },

    -- 💎 Discord roles that will have access to VIP features when available
    VIPRoleIds = {
        "00000000000000000",
    },
}
