Config = Config or {}

----------------------------------------------------------------------------------------------------
-- # BACKGROUND SECTION # --
----------------------------------------------------------------------------------------------------
-- Allows you to set the preferred background Color from a list of available options.
Config.Background = "background_pink"

-- Available Options --
-- background_blue
-- background_darkblue
-- background_darkerblue
-- background_darkgreen
-- background_green
-- background_other
-- background_pink
-- background_projectsloth
-- background_red
-- background_yellow

-- Allows you to change the opactiy of the Background
Config.Opacity = 50

----------------------------------------------------------------------------------------------------
-- # HEADER and OPTIONS SECTION # --
----------------------------------------------------------------------------------------------------

Config.Header = {
    -- LEFT MENU CONFIG
    ["TITLE"] = "Midnight City",
    --["SUBTITLE"] = "This little Script was made by Jay <3",

    ["MAP"] = "Map",
    ["GAME"] = "Exit Game",
    ["LEAVE"] = "Return to Server List",
    ["QUIT"] = "Return to Desktop",
    ["INFO"] = "Information",
    ["STATS"] = "Statistics",
    ["SETTINGS"] = "Settings",
    ["GALLERY"] = "Gallery",
    ["KEYBIND"] = "Main Keybinds",
    ["EDITOR"] = "Rockstar Editor",

    -- RIGHT MENU CONFIG
    ["SERVER_NAME"] = "Midnight City",
    ["SERVER_TEXT"] = "Beware of Night",
    ["SERVER_DISCORD"] = "discord.gg/m-g-n"
}

--Allows you to Change the Colour ( Use this Website: https://rgbacolorpicker.com/ )
Config.RGBA = {
    LINE = { -- Line over the Options
        ["RED"] = 186,
        ["GREEN"] = 85,
        ["BLUE"] = 211,
        ["ALPHA"] = 255,
    },
    STYLE = { -- Pause Menu Options
        ["RED"] = 0,
        ["GREEN"] = 0,
        ["BLUE"] = 0,
        ["ALPHA"] = 186,
    },
    WAYPOINT = { -- Waypoint
        ["RED"] = 164,
        ["GREEN"] = 76,
        ["BLUE"] = 242,
        ["ALPHA"] = 255,
    },
}
