Config = {}
-- For more info check https://codem.gitbook.io/codem-documentation/

Config.Theme = 'proxima' --  sky, blvck, cherry, kush, mango, proxima
Config.Logo = 'default' -- Default or URL link
Config.BackgroundImage = 'background.webm' -- default or custom image/video
-- Backgrounds can be found in html/assets/background/
-- Config.BackgroundImage = 'background.png'
Config.PlayMusicByDefault = true -- if true plays the music when loading screen is active

--html\assets\music
Config.Musics = {
    "music.mp3",


}

-- To display on left menu (must be an image)
-- Supports max 2 images
Config.AlbumsThumbnail = {
    {
        source = 'https://i.imgur.com/5v9y4AD.png', -- Must be a link
    },
    {
        source = 'https://i.imgur.com/5v9y4AD.png', -- Must be a link
    }
}

Config.Albums = {
   {
       source = 'https://i.imgur.com/5v9y4AD.png', -- Must be a link
   },
   {
       source = 'EjaorVlUcn0'  -- Must be a link
   }
}


Config.EnableHintMessages = true
Config.HintMessages = {
    {
        text= 'To get socialize you can visit the most popular places in the city. They aresuch as Motel, Hospital, LS Customs and other working areas.   Good luck out there!',
        time= 8000,
    },
    {
        text= 'Need to get around? /roller will put you on a pair of skates, /leave will take them off',
        time= 3000,
    },
    {
        text= 'Something not open? Come back at a different time of the day!',
        time= 3000,
    },
    {
        text= '/report or make a ticket if you encounter any bugs!',
        time= 3000,
    },
    {
        text= '/hud will open up your Hud Menu to edit it!',
        time= 3000,
    },
    {

        text= 'Looking for work? Head to the city hall!',
        time= 1000,
    },
    {
        text= 'Beware of the night.',
        time= 1000,
    }
}


Config.ButtonLinks = {
    ["twitter"] = 'https://twitter.com',
    ["instagram"] = 'https://www.instagram.com/',
    ["reddit"] = 'https://www.reddit.com/',
    ["discord"] = 'https://discord.gg/zj3QsUfxWs',
}

Config.ServerName = 'Midnight City Roleplay'

Config.Language = {
    ["WELCOME"] = 'WELCOME TO',
    ["INSIDE_CITY"] = 'Inside The City',
    ["FOOTAGES"] = 'Latest footages from the city.',
    ["PATCH_NOTES"] = 'Patch Notes',
    ["PATCH_NOTES_VERSION"] = 'Patch Notes v1.0',
    ["LATEST_UPDATES"] = 'Latest updates...',
    ["FOLLOW_CITY"] = 'Follow the city on social!',


    ["CITY_LOADING"] = 'Please wait, the city is loading...',
    ["SETTINGS"] = 'Settings',
    ["ENABLE_MUSIC"] = 'Enable music',
    ["SHOW_MENU"] = 'Show left menu',
    ["SHOW_HINT"] = 'Show hint',
    ["SHOW_ALL"] = 'Show all UI',



    ["KEYBINDS_INFO"] = 'Please click a highlighted key to see binding on the right panel.',
    ["KEYBINDS_INFO_2"] = 'Some keybindings can be changed from in game settings. To change them',
    ["GO_TO"] = 'go to',
    ["FIVEM_SETTINGS"] = 'ESC>Settings>Keybindings>FiveM',
    ["PRESS"] = 'Press',
    ["DOUBLE_PRESS"] = 'Double Press',
    ["COMBINATIONS"] = 'Combinations',
    ["KEYBINDS_INFO_3"] = 'Please click on a key to display binding.',
    ["KEYBINDS_INFO_4"] = 'Be aware that those are settings commands and there are many more commands in game.',

    ["COMMANDS"] = 'Commands',
    ["SHOW_ALL_UI"] = 'Show All Commands',
    ["SELECT_COMMAND"] = 'Please select a command',
    ["DISPLAY_BINDING"] = 'display binding',
    ["COMMANDS_INFO"] = 'Please click on a command to see the function on the right panel.',
    ["HINT"] = 'Hint',

}

Config.PatchNotes = {
    'GRAND OPENING'

}

Config.Keybinds = {
    ["ESC"] = false,
    ["F1"] = {
        ["pressInfo"] = 'Opens the radial',
        ["doublePressInfo"] = false,
    },
    ["F2"] = false,
    ["F3"] = false,
    ["F4"] = false,
    ["F5"] = { ["pressInfo"] = 'Opens the emote menu', },
    ["F6"] = {
        ["pressInfo"] = 'Opens the job interaction menu',
    },
    ["F7"] = false,
    ["F8"] = false,
    ["F9"] = false,
    ["F10"] = false,
    ["F11"] = false,
    ["F12"] = false,
    ["“"] = false,
    ["1"] = {
        ["pressInfo"] = 'Inventory hot key',
    },
    ["2"] = {
        ["pressInfo"] = 'Inventory hot key',

    },
    ["3"] = {
        ["pressInfo"] = 'Inventory hot key',

    },
    ["4"] = {
        ["pressInfo"] = 'Inventory hot key',

    },
    ["5"] = {
        ["pressInfo"] = 'Inventory hot key',

    },
    ["6"] = false,
    ["7"] = false,
    ["8"] = false,
    ["9"] = false,
    ["0"] = false,
    ["-"] = false,
    ["+"] = false,
    ["BACKSPACE"] = false,
    ["TAB"] = false,
    ["Q"] = false,
    ["W"] = false,
    ["E"] = false,
    ["R"] = false,
    ["T"] = {
        ["pressInfo"] = 'Opens the chat',
    },
    ["Y"] = false,
    ["U"] = false,
    ["I"] = false,
    ["O"] = false,
    ["P"] = false,
    ["["] = false,
    ["]"] = false,
    ["ENTER"] = {
        ["pressInfo"] = 'Opens the chat',
    },
    ["CAPS"] = false,
    ["A"] = false,
    ["S"] = false,
    ["D"] = false,
    ["F"] = false,
    ["G"] = false,
    ["H"] = false,
    ["J"] = false,
    ["K"] = false,
    ["L"] =  {
        ["pressInfo"]=  'Locks the vehicle',
        ["doublePressInfo"]=  'Opens the remote UI.',
    },
    [";"] =  false,
    ["@"] =  false,
    ["LSHIFT"] =  {
        ["pressInfo"] = 'Run',
        ["doublePressInfo"] = false,
        ["combinations"] = {
            {
                ["key"] = 'E',
                ["info"] = 'Tackle',
            },
            {
                ["key"] = 'H',
                ["info"] = 'Push vehicle',
            },
            {
                ["key"] = 'G',
                ["info"] = 'Carry on arm',
            },
        },
    },
    ["Z"] =  false,
    ["X"] =  false,
    ["C"] =  false,
    ["V"] =  false,
    ["B"] =  false,
    ["N"] =  false,
    ["M"] =  false,
    ["<"] =  false,
    [">"] =  false,
    ["?"] =  false,
    ["RSHIFT"] =  false,
    ["LCTRL"] =  false,
    ["ALT"] =  false,
    ["SPACE"] = false,
    ["ALTGR"] = false,
    ["RCTRL"] = false,
}
-- add only 2 commands here
Config.PreviewCommands = {
    ["hud"]= 'Opens hud settings.',
    ["notify"]= 'Opens notify settings.',
}

Config.Commands = {
    ["hud"]= 'Opens hud settings.',
    ["notify"]= 'Opens notify settings.',
    ["inventoryfix"]= 'Fixes inventory UI.',
    ["radialfix"]= 'Fixes radial menu UI.',
    ["report"]= 'Opens report menu.',
    ["kill"]= 'Kills the player with specified id.',
    ["admin"]= 'Opens admin menu.',
    ["emotes"]= 'Opens emotes menu.',
    ["pet"]= 'Opens pet menu.',
    ["mdt"]= 'Opens mdt.',
    ["repair"]= 'Fixes the vehicle you are driving.',
}



