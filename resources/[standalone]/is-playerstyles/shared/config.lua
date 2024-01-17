Config = {}

Config.Language = "en"

Config.ApplyDelay = 1000

Config.WalkingStyleEvents = { -- Events to set the walk style again on
    {
        Name = "hospital:client:Revive",
        Delay = 1000,
    },
    {
        Name = "illenium-appearance:client:reloadSkin",
        Delay = 1000,
    }
}

Config.CommandName = "styles"

Config.DefaultWalkingStyles = {
    Male = "move_m@multiplayer",
    Female = "move_f@multiplayer"
}

Config.DefaultMood = "pose_normal_1"

Config.WalkingStyles = {
    {
        Name = "Alien",
        Style = "move_m@alien"
    },
    {
        Name = "Armored",
        Style = "anim_group_move_ballistic"
    },
    {
        Name = "Arrogant",
        Style = "move_f@arrogant@a"
    },
    {
        Name = "Brave",
        Style = "move_m@brave"
    },
    {
        Name = "Casual",
        Style = "move_m@casual@a"
    },
    {
        Name = "Casual2",
        Style = "move_m@casual@b"
    },
    {
        Name = "Casual3",
        Style = "move_m@casual@c"
    },
    {
        Name = "Casual4",
        Style = "move_m@casual@d"
    },
    {
        Name = "Casual5",
        Style = "move_m@casual@e"
    },
    {
        Name = "Casual6",
        Style = "move_m@casual@f"
    },
    {
        Name = "Chichi",
        Style = "move_f@chichi"
    },
    {
        Name = "Confident",
        Style = "move_m@confident"
    },
    {
        Name = "Cop",
        Style = "move_m@business@a"
    },
    {
        Name = "Cop2",
        Style = "move_m@business@b"
    },
    {
        Name = "Cop3",
        Style = "move_m@business@c"
    },
    {
        Name = "Default Female",
        Style = "move_f@multiplayer"
    },
    {
        Name = "Default Male",
        Style = "move_m@multiplayer"
    },
    {
        Name = "Drunk",
        Style = "move_m@drunk@a"
    },
    {
        Name = "Drunk1",
        Style = "move_m@drunk@slightlydrunk"
    },
    {
        Name = "Drunk2",
        Style = "move_m@buzzed"
    },
    {
        Name = "Drunk3",
        Style = "move_m@drunk@verydrunk"
    },
    {
        Name = "Femme",
        Style = "move_f@femme@"
    },
    {
        Name = "Fire",
        Style = "move_characters@franklin@fire"
    },
    {
        Name = "Fire2",
        Style = "move_characters@michael@fire"
    },
    {
        Name = "Fire3",
        Style = "move_m@fire"
    },
    {
        Name = "Flee",
        Style = "move_f@flee@a"
    },
    {
        Name = "Franklin",
        Style = "move_p_m_one"
    },
    {
        Name = "Gangster",
        Style = "move_m@gangster@generic"
    },
    {
        Name = "Gangster2",
        Style = "move_m@gangster@ng"
    },
    {
        Name = "Gangster3",
        Style = "move_m@gangster@var_e"
    },
    {
        Name = "Gangster4",
        Style = "move_m@gangster@var_f"
    },
    {
        Name = "Gangster5",
        Style = "move_m@gangster@var_i"
    },
    {
        Name = "Grooving",
        Style = "anim@move_m@grooving@"
    },
    {
        Name = "Guard",
        Style = "move_m@prison_gaurd"
    },
    {
        Name = "Handcuffs",
        Style = "move_m@prisoner_cuffed"
    },
    {
        Name = "Heels",
        Style = "move_f@heels@c"
    },
    {
        Name = "Heels2",
        Style = "move_f@heels@d"
    },
    {
        Name = "Hiking",
        Style = "move_m@hiking"
    },
    {
        Name = "Hipster",
        Style = "move_m@hipster@a"
    },
    {
        Name = "Hobo",
        Style = "move_m@hobo@a"
    },
    {
        Name = "Hurry",
        Style = "move_f@hurry@a"
    },
    {
        Name = "Janitor",
        Style = "move_p_m_zero_janitor"
    },
    {
        Name = "Janitor2",
        Style = "move_p_m_zero_slow"
    },
    {
        Name = "Jog",
        Style = "move_m@jog@"
    },
    {
        Name = "Lemar",
        Style = "anim_group_move_lemar_alley"
    },
    {
        Name = "Lester",
        Style = "move_heist_lester"
    },
    {
        Name = "Lester2",
        Style = "move_lester_caneup"
    },
    {
        Name = "Maneater",
        Style = "move_f@maneater"
    },
    {
        Name = "Michael",
        Style = "move_ped_bucket"
    },
    {
        Name = "Money",
        Style = "move_m@money"
    },
    {
        Name = "Muscle",
        Style = "move_m@muscle@a"
    },
    {
        Name = "Posh",
        Style = "move_m@posh@"
    },
    {
        Name = "Posh2",
        Style = "move_f@posh@"
    },
    {
        Name = "Quick",
        Style = "move_m@quick"
    },
    {
        Name = "Runner",
        Style = "female_fast_runner"
    },
    {
        Name = "Sad",
        Style = "move_m@sad@a"
    },
    {
        Name = "Sassy",
        Style = "move_m@sassy"
    },
    {
        Name = "Sassy2",
        Style = "move_f@sassy"
    },
    {
        Name = "Scared",
        Style = "move_f@scared"
    },
    {
        Name = "Sexy",
        Style = "move_f@sexy@a"
    },
    {
        Name = "Shady",
        Style = "move_m@shadyped@a"
    },
    {
        Name = "Slow",
        Style = "move_characters@jimmy@slow@"
    },
    {
        Name = "Swagger",
        Style = "move_m@swagger"
    },
    {
        Name = "Tough",
        Style = "move_m@tough_guy@"
    },
    {
        Name = "Tough2",
        Style = "move_f@tough_guy@"
    },
    {
        Name = "Trash",
        Style = "clipset@move@trash_fast_turn"
    },
    {
        Name = "Trash2",
        Style = "missfbi4prepp1_garbageman"
    },
    {
        Name = "Trevor",
        Style = "move_p_m_two"
    },
    {
        Name = "Wide",
        Style = "move_m@bag"
    }
}

Config.Moods = {
    {
        Name = "Angry",
        Mood = "mood_angry_1"
    },
    {
        Name = "Drunk",
        Mood = "mood_drunk_1"
    },
    {
        Name = "Dumb",
        Mood = "pose_injured_1"
    },
    {
        Name = "Electrocuted",
        Mood = "electrocuted_1"
    },
    {
        Name = "Grumpy",
        Mood = "effort_1"
    },
    {
        Name = "Grumpy2",
        Mood = "mood_drivefast_1"
    },
    {
        Name = "Grumpy3",
        Mood = "pose_angry_1"
    },
    {
        Name = "Happy",
        Mood = "mood_happy_1"
    },
    {
        Name = "Injured",
        Mood = "mood_injured_1"
    },
    {
        Name = "Joyful",
        Mood = "mood_dancing_low_1"
    },
    {
        Name = "Mouthbreather",
        Mood = "smoking_hold_1"
    },
    {
        Name = "Never Blink",
        Mood = "pose_normal_1"
    },
    {
        Name = "One Eye",
        Mood = "pose_aiming_1"
    },
    {
        Name = "Shocked",
        Mood = "shocked_1"
    },
    {
        Name = "Shocked2",
        Mood = "shocked_2"
    },
    {
        Name = "Sleeping",
        Mood = "mood_sleeping_1"
    },
    {
        Name = "Sleeping2",
        Mood = "dead_1"
    },
    {
        Name = "Sleeping3",
        Mood = "dead_2"
    },
    {
        Name = "Smug",
        Mood = "mood_smug_1"
    },
    {
        Name = "Speculative",
        Mood = "mood_aiming_1"
    },
    {
        Name = "Stressed",
        Mood = "mood_stressed_1"
    },
    {
        Name = "Sulking",
        Mood = "mood_sulk_1"
    },
    {
        Name = "Weird",
        Mood = "effort_2"
    },
    {
        Name = "Weird2",
        Mood = "effort_3"
    }
}
