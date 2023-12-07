-- Emotes you add in the file will automatically be added to AnimationList.lua
-- If you have multiple custom list files they MUST be added between AnimationList.lua and Emote.lua in fxmanifest.lua!
-- Don't change 'CustomDP' it is local to this file!

local CustomDP = {}

CustomDP.Expressions = {
}
CustomDP.Walks = {
    ["Lemar"] = {"anim_group_move_lemar_alley"},
}
CustomDP.Shared = {}
CustomDP.Dances = {
    ["ashton"] = {"div@gdances@test", "ashton", "Ashton", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["charleston"] = {"div@gdances@test", "charleston", "Charleston", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["doggystrut"] = {"div@gdances@test", "doggystrut", "Strut", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dreamfeet"] = {"div@gdances@test", "dreamfeet", "Dream Feet", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["eerie"] = {"div@gdances@test", "eerie", "Eerie", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["fancyfeet"] = {"div@gdances@test", "fancyfeet", "Fancy Feet", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["festivus"] = {"div@gdances@test", "festivus", "Rave Dance", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["flamingo"] = {"div@gdances@test", "flamingo", "Flamingo", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["fresh"] = {"div@gdances@test", "fresh", "Fresh", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["getgriddy"] = {"div@gdances@test", "getgriddy", "Get Griddy", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["handstand"] = {"div@gdances@test", "handstand", "Handstand", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["imsmooth"] = {"div@gdances@test", "imsmooth", "Smooth", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["keepdance"] = {"div@gdances@test", "keepdance", "Goof Off", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["montecarlo"] = {"div@gdances@test", "montecarlo", "Monte Carlo", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["octopus"] = {"div@gdances@test", "octopus", "Octopus", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["pointydance"] = {"div@gdances@test", "pointydance", "Pointy", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["ridingdance"] = {"div@gdances@test", "ridingdance", "Riding Cowboy", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["skeldance"] = {"div@gdances@test", "skeldance", "Skeleton Dance", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["spinny"] = {"div@gdances@test", "spinny", "Spinny", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["zombiewalk"] = {"div@gdances@test", "zombiewalk", "Zombie Walk", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceclap"] = {"divined@samp@new", "danceclap", "Dance n clap", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dancedown"] = {"divined@samp@new", "dancedown", "Dance (downwards)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceleft"] = {"divined@samp@new", "danceleft", "Dance (left)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceright"] = {"divined@samp@new", "danceright", "Dance (right)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceloop"] = {"divined@samp@new", "danceloop", "Dance #1 (loop)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceloop2"] = {"divined@samp@new", "danceloop2", "Dance #2 (loop)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dancema"] = {"divined@samp@new", "dancema", "Dance #1", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dancemb"] = {"divined@samp@new", "dancemb", "Dance #2", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dancemc"] = {"divined@samp@new", "dancemc", "Dance #3", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dancemd"] = {"divined@samp@new", "dancemd", "Dance #4", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceme"] = {"divined@samp@new", "danceme", "Dance #5", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["danceup"] = {"divined@samp@new", "danceup", "Dance (upwards)", AnimationOptions =
    {
        EmoteLoop = true
    }},
    ["dbdance1"] = {"divined@fndances@new", "dbdance1", "Mdance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance2"] = {"divined@fndances@new", "dbdance2", "A1 Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance3"] = {"divined@fndances@new", "dbdance3", "Boogie Down", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance4"] = {"divined@fndances@new", "dbdance4", "Break Boy", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance5"] = {"divined@fndances@new", "dbdance5", "Breakfast Coffee Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance6"] = {"divined@fndances@new", "dbdance6", "Candy Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance7"] = {"divined@fndances@new", "dbdance7", "Cheerleader Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance8"] = {"divined@fndances@new", "dbdance8", "Crab Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dbdance9"] = {"divined@fndances@new", "dbdance9", "Eastern Blocc", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance10"] = {"divined@fndances@new", "dbdance10", "Electro Swing", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance11"] = {"divined@fndances@new", "dbdance11", "Electro Shuffle", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance12"] = {"divined@fndances@new", "dbdance12", "Floss", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance13"] = {"divined@fndances@new", "dbdance13", "Grooving Jam", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance14"] = {"divined@fndances@new", "dbdance14", "Hillbilly Shuffle", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance15"] = {"divined@fndances@new", "dbdance15", "Laser Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance16"] = {"divined@fndances@new", "dbdance16", "Ribbon Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance17"] = {"divined@fndances@new", "dbdance17", "Running Man", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance18"] = {"divined@fndances@new", "dbdance18", "Step Breakdance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance19"] = {"divined@fndances@new", "dbdance19", "Cowboy Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
       ["dbdance20"] = {"divined@fndances@new", "dbdance20", "Egyptian Dance", AnimationOptions =
    {
        EmoteLoop = true,
    }},
          ["dbdance21"] = {"divined@fndances@new", "dbdance21", "Swipe It", AnimationOptions =
    {
        EmoteLoop = true,
    }},
}
CustomDP.AnimalEmotes = {
    ["coyotehowl"] = {
        "creatures@coyote@amb@world_coyote_wander@base",
        "base",
        "Howl (coyote)",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["coyotelay2"] = {
        "creatures@coyote@amb@world_coyote_rest@idle_a",
        "idl_b",
        "Lay & Look Around (coyote)",
        AnimationOptions = {
            EmoteLoop = true
        }
    },
    ["coyotelay"] = {
        "creatures@coyote@amb@world_coyote_rest@base",
        "base",
        "Lay (Coyote)",
        AnimationOptions = {
            EmoteLoop = true,
            ExitEmote = 'coyotelayup',
            ExiteEmoteType = 'Exits',
        }
    },
    ["coyotesit"] = {
        "creatures@coyote@amb@world_coyote_howl@base",
        "base",
        "Sit (Coyote)",
        AnimationOptions = {
            EmoteLoop = true,
            ExitEmote = "coyotesitup",
            ExitEmoteType = "Exits"
        }
    },
    ["coyoteplaydead"] = {
        "creatures@coyote@move",
        "dying",
        "Play Dead (Coyote)",
        AnimationOptions = {
            EmoteLoop = false,
            ExitEmote = "coyoteplaydeadup",
            ExitEmoteType = "Exits"
        }
    },
    -- Exit Anims --
    -- ["coyotesitup"] = {
    --     "creatures@coyote@amb@world_coyote_howl@exit",
    --     "exit",
    --     "Coyote getting up from sitting",
    --     AnimationOptions = {
    --         EmoteDuration = 6500
    --     }
    -- },
    -- ["coyoteplaydeadup"] = {
    --     "creatures@coyote@getup",
    --     "getup_l",
    --     "Coyote getting up from playing dead",
    --     AnimationOptions = {
    --         EmoteDuration = 6500
    --     }
    -- },
}

CustomDP.Emotes = {
    ["mgangsign_1"] = {"mikey@gangsigns@new", "mgangsign_1", "Gangsign 1", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_2"] = {"mikey@gangsigns@new", "mgangsign_2", "Gangsign 2", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_3"] = {"mikey@gangsigns@new", "mgangsign_3", "Gangsign 3", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_4"] = {"mikey@gangsigns@new", "mgangsign_4", "Gangsign 4", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_5"] = {"mikey@gangsigns@new", "mgangsign_5", "Gangsign 5", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_6"] = {"mikey@gangsigns@new", "mgangsign_6", "Gangsign 6", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_7"] = {"mikey@gangsigns@new", "mgangsign_7", "Gangsign 7", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_8"] = {"mikey@gangsigns@new", "mgangsign_8", "Gangsign 8", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_9"] = {"mikey@gangsigns@new", "mgangsign_9", "Gangsign 9", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_10"] = {"mikey@gangsigns@new", "mgangsign_10", "Gangsign 10", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["mgangsign_11"] = {"mikey@gangsigns@new", "mgangsign_11", "Gangsign 11", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["healthkit"] = {"anim@amb@board_room@supervising@", "dissaproval_01_lo_amy_skater_01", "Health Kit", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 2500,
    }},
    ["drink"] = {"mp_player_inteat@pnq", "loop", "Drink", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 2500,
    }},
    ["hug"] = {"mp_ped_interaction", "kisses_guy_a", "Hug"},
    ["hug2"] = {"mp_ped_interaction", "kisses_guy_b", "Hug 2"},
    ["hug3"] = {"mp_ped_interaction", "hugs_guy_a", "Hug 3"},
    ["lapdance"] = {"mp_safehouse", "lap_dance_girl", "Lapdance"},
    ["lapdance2"] = {"mini@strip_club@private_dance@idle", "priv_dance_idle", "Lapdance 2", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["golfswing"] = {"rcmnigel1d", "swing_a_mark", "Golf Swing"},
    ["eat"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Eat", AnimationOptions =
    {
        EmoteMoving = true,
        EmoteDuration = 3000,
    }},
    ["twerk"] = {"switch@trevor@mocks_lapdance", "001443_01_trvs_28_idle_stripper", "Twerk", AnimationOptions =
    {
        EmoteLoop = true,
    }},
    ["dj"] = {"anim@amb@nightclub@djs@dixon@", "dixn_dance_cntr_open_dix", "DJ", AnimationOptions =
    {
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    ["beg"] = {"MaleScenario", "WORLD_HUMAN_BUM_FREEWAY", "Beg"},
    ["camera"] = {"MaleScenario", "WORLD_HUMAN_PAPARAZZI", "Camera"},
    ["copbeacon"] = {"MaleScenario", "WORLD_HUMAN_CAR_PARK_ATTENDANT", "Cop Beacon"},
    ["leafblower"] = {"MaleScenario", "WORLD_HUMAN_GARDENER_LEAF_BLOWER", "Leafblower"},
    ["map"] = {"Scenario", "WORLD_HUMAN_TOURIST_MAP", "Map"},
    ["phone"] = {"Scenario", "WORLD_HUMAN_STAND_MOBILE", "Phone 3"},
}
CustomDP.PropEmotes = {
    		--Winery
	["redwineglass"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Red Wine Glass", AnimationOptions =
    { Prop = "prop_drink_redwine", PropBone = 18905, PropPlacement = {0.14, 0.03, 0.01, 85.0, -70.0, -203.0},
    EmoteMoving = true, EmoteLoop = true, }},
    ["whitewineglass"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "White Wine Glass", AnimationOptions =
        { Prop = "prop_drink_whtwine", PropBone = 18905, PropPlacement = {0.14, 0.03, 0.01, 85.0, -70.0, -203.0},
        EmoteMoving = true, EmoteLoop = true, }},
    ["rosewineglass"] = {"anim@heists@humane_labs@finale@keycards", "ped_a_enter_loop", "Rose Wine Glass", AnimationOptions =
        { Prop = "p_wine_glass_s", PropBone = 18905, PropPlacement = {0.14, 0.03, 0.01, 85.0, -70.0, -203.0},
        EmoteMoving = true, EmoteLoop = true, }},

    ["can"] = {"bz@watercan@animation", "bz_watercan", "Can", AnimationOptions =
    { Prop = "prop_wateringcan002",
        PropBone = 57005,
        PropPlacement = {0.27, 0.0, -0.23, -75.0, 41.0, 36.0},
        EmoteLoop = true,
        EmoteMoving = true,
    }},
    	--Jim-CatCafe
	["uwu1"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_sml_drink', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu2"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_lrg_drink', PropBone = 28422, PropPlacement = {0.03, 0.0, -0.08, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu3"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_cup_straw', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu4"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_mug', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu5"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions =
	{ Prop = 'uwu_pastry', PropBone = 18905, PropPlacement = {0.16, 0.06, -0.03, -50.0, 16.0, 60.0},
		EmoteMoving = true, }},
	["uwu6"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions =
	{ Prop = 'uwu_cookie', PropBone = 18905, PropPlacement = {0.16, 0.08, -0.01, -225.0, 20.0, 60.0},
		EmoteMoving = true, }},
	["uwu7"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions =
	{ Prop = 'uwu_sushi', PropBone = 18905, PropPlacement = {0.18, 0.03, 0.02, -50.0, 16.0, 60.0},
		EmoteMoving = true, }},
	["uwu8"] = {"amb@world_human_seat_wall_eating@male@both_hands@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_eggroll', PropBone = 60309, PropPlacement = {0.10, 0.03, 0.08, -95.0, 60.0, 0.0},
		EmoteMoving = true, }},
	["uwu9"] = {"anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1", "base_idle", "", AnimationOptions =
	{ Prop = "uwu_salad_bowl", PropBone = 60309, PropPlacement = {0.0, 0.0300, 0.0100, 0.0, 0.0, 0.0},
		SecondProp = 'uwu_salad_spoon', SecondPropBone = 28422, SecondPropPlacement = {0.0, 0.0 ,0.0, 0.0, 0.0, 0.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu10"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions =
	{ Prop = 'uwu_sandy', PropBone = 18905, PropPlacement = {0.16, 0.08, 0.05, -225.0, 20.0, 60.0},
		EmoteMoving = true, }},
	["uwu11"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_cupcake', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.03, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu12"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "", AnimationOptions =
	{ Prop = 'uwu_btea', PropBone = 28422, PropPlacement = {0.02, 0.0, -0.05, 0.0, 0.0, 130.0},
		EmoteLoop = true, EmoteMoving = true, }},
	["uwu13"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "", AnimationOptions =
	{ Prop = 'uwu_gdasik', PropBone = 18905, PropPlacement = {0.16, 0.08, 0.02, -225.0, 20.0, 60.0},
		EmoteMoving = true, }},
    -- ["plushiemini1"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 1", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_09a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini2"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 2", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_08a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini3"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 3", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_07a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini4"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 4", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_06a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini5"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 5", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_05a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini6"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 6", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_04a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini7"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 7", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_03a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini8"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 8", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_02a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushiemini9"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Mini Plushie 9", AnimationOptions =
    -- {   Prop = 'sum_prop_sum_arcade_plush_01a', PropBone = 24817, PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie1"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 1", AnimationOptions =
    -- {   Prop = 'ch_prop_master_09a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie2"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 2", AnimationOptions =
    -- {   Prop = 'ch_prop_shiny_wasabi_plush_08a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie3"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 3", AnimationOptions =
    -- {   Prop = 'ch_prop_princess_robo_plush_07a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie4"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 4", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_06a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie5"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 5", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_05a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie6"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 6", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_04a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie7"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 7", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_03a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie8"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 8", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_02a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},
    -- ["plushie9"] = {"impexp_int-0", "mp_m_waremech_01_dual-0", "Plushie 9", AnimationOptions =
    -- {   Prop = 'ch_prop_arcade_claw_plush_01a', PropBone = 24817, PropPlacement = {0.0, 0.46, -0.016, -180.0, -90.0, 0.0},
    --     EmoteMoving = true, EmoteLoop = true }},

    --Jim-CluckinBell
    ["cbsoda"] = {"mp_player_intdrink", "loop_bottle", "CBCoke", AnimationOptions =
   {    Prop = "prop_food_cb_juice01", PropBone = 18905, PropPlacement = {0.04, -0.10, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["cbcoffee"] = {"mp_player_intdrink", "loop_bottle", "CBCoffee", AnimationOptions =
   {    Prop = "prop_food_cb_coffee", PropBone = 18905, PropPlacement = {0.08, -0.10, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["cbburger"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "ChickenBurger", AnimationOptions =
   {    Prop = "prop_food_cb_burg01", PropBone = 18905, PropPlacement = {0.10, -0.07, 0.091, 15.0, 135.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["cbfries"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "CBFries", AnimationOptions =
   {    Prop = "prop_food_cb_chips", PropBone = 18905, PropPlacement = {0.09, -0.06, 0.05, 300.0, 150.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["donut3"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut3", AnimationOptions =
   {   Prop = 'prop_food_cb_donuts', PropBone = 18905, PropPlacement = {0.13, 0.05, 0.02, -50.0, 100.0, 270.0},
       EmoteMoving = true, EmoteLoop = true, }},
    ["cbnuggets"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Cnuggets", AnimationOptions =
    {   Prop = 'prop_food_cb_nugets', PropBone = 18905, PropPlacement = {0.13, 0.05, 0.02, -50.0, 100.0, 270.0},
    EmoteMoving = true, EmoteLoop = true,}},
    ["cbtoy"] = {"mp_arresting", "a_uncuff", "CBToy", AnimationOptions =
    {   Prop = 'jixel_prop_cluckinbox', PropBone = 18905, PropPlacement = { 0.1, 0.1, 0.0, 0.0, 100.0, 90.0},
       EmoteMoving = true, EmoteLoop = true, }},

        	--Jim-BurgerShot
    ["milk"] = {"mp_player_intdrink", "loop_bottle", "Milk", AnimationOptions =
    {    Prop = "v_res_tt_milk", PropBone = 18905, PropPlacement = {0.10, 0.008, 0.07, 240.0, -60.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["bscoke"] = {"mp_player_intdrink", "loop_bottle", "BS Coke", AnimationOptions =
    {    Prop = "prop_food_bs_juice01", PropBone = 18905, PropPlacement = {0.04, -0.10, 0.10, 240.0, -60.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["bscoffee"] = {"mp_player_intdrink", "loop_bottle", "BS Coffee", AnimationOptions =
    {    Prop = "prop_food_bs_coffee", PropBone = 18905, PropPlacement = {0.08, -0.10, 0.10, 240.0, -60.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["glass"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Tall Glass", AnimationOptions =
    {   Prop = 'prop_wheat_grass_glass', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.1, 0.0, 0.0, 0.0},
        EmoteLoop = true, EmoteMoving = true, }},
    ["torpedo"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Torpedo", AnimationOptions =
    {    Prop = "prop_food_bs_burger2", PropBone = 18905, PropPlacement = {0.10, -0.07, 0.091, 15.0, 135.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["bsfries"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Fries", AnimationOptions =
    {    Prop = "prop_food_bs_chips", PropBone = 18905, PropPlacement = {0.09, -0.06, 0.05, 300.0, 150.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["donut2"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger", "Donut2", AnimationOptions =
    {   Prop = 'prop_donut_02', PropBone = 18905, PropPlacement = {0.13, 0.05, 0.02, -50.0, 100.0, 270.0},
        EmoteMoving = true, EmoteLoop = true, }},
    ["ecola"] = {"mp_player_intdrink", "loop_bottle", "E-cola", AnimationOptions =
        { Prop = "prop_ecola_can", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["sprunk"] = {"mp_player_intdrink", "loop_bottle", "Sprunk", AnimationOptions =
        { Prop = "v_res_tt_can03", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
            EmoteMoving = true, EmoteLoop = true, }},
    ["crisps"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Crisps", AnimationOptions =
        { Prop = 'v_ret_ml_chips2', PropBone = 28422, PropPlacement = {0.01, -0.05, -0.1, 0.0, 0.0, 90.0},
           EmoteLoop = true, EmoteMoving = true, }},
    ["bmcoffee1"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee2", AnimationOptions =
        { Prop = 'prop_fib_coffee', PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
           EmoteLoop = true, EmoteMoving = true, }},
    ["bmcoffee2"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee3", AnimationOptions =
        { Prop = 'ng_proc_coffee_01a', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.06, 0.0, 0.0, 0.0},
           EmoteLoop = true, EmoteMoving = true, }},
    ["bmcoffee3"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "Coffee3", AnimationOptions =
        { Prop = 'v_club_vu_coffeecup', PropBone = 28422, PropPlacement = {0.0, 0.0, -0.06, 0.0, 0.0, 0.0},
           EmoteLoop = true, EmoteMoving = true, }},
	--Jim-Henhouse
	["whiskeyb"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Whiskey Bottle", AnimationOptions =
	{    Prop = "prop_cs_whiskey_bottle", PropBone = 60309, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0},
		EmoteMoving = true, EmoteLoop = true }},
	["rumb"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Rum Bottle", AnimationOptions =
	{    Prop = "prop_rum_bottle", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true }},
	["icream"] = {"mp_player_intdrink", "loop_bottle", "Irish Cream Bottle", AnimationOptions =
	{    Prop = "prop_bottle_brandy", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true }},
	["ginb"] =  {"mp_player_intdrink", "loop_bottle", "(Don't Use) Gin Bottle", AnimationOptions =
	{    Prop = "prop_tequila_bottle", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true }},
	["vodkab"] = {"mp_player_intdrink", "loop_bottle", "(Don't Use) Vodka Bottle", AnimationOptions =
	{   Prop = 'prop_vodka_bottle', PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true }},
	["beer1"] = {"mp_player_intdrink", "loop_bottle", "Dusche", AnimationOptions =
	{    Prop = "prop_beerdusche", PropBone = 18905, PropPlacement = {0.04, -0.14, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
	["beer2"] = {"mp_player_intdrink", "loop_bottle", "Logger", AnimationOptions =
	{    Prop = "prop_beer_logopen", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
	["beer3"] = {"mp_player_intdrink", "loop_bottle", "AM Beer", AnimationOptions =
	{    Prop = "prop_beer_amopen", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
	["beer4"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser1", AnimationOptions =
	{    Prop = "prop_beer_pissh", PropBone = 18905, PropPlacement = {0.03, -0.18, 0.10, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
	["beer5"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser2", AnimationOptions =
	{    Prop = "prop_amb_beer_bottle", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
	["beer6"] = {"mp_player_intdrink", "loop_bottle", "Pisswasser3", AnimationOptions =
	{    Prop = "prop_cs_beer_bot_02", PropBone = 18905, PropPlacement = {0.12, 0.008, 0.03, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
        	--Jim-PizzaThis
   ["redwine"] = {"mp_player_intdrink", "loop_bottle", "Red Wine Bottle", AnimationOptions =
   {    Prop = "prop_wine_rose", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["whitewine"] = {"mp_player_intdrink", "loop_bottle", "White Wine Bottle", AnimationOptions =
   {    Prop = "prop_wine_white", PropBone = 18905, PropPlacement = {0.00, -0.26, 0.10, 240.0, -60.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["pizza"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Pizza", AnimationOptions =
   {    Prop = "v_res_tt_pizzaplate", PropBone = 18905, PropPlacement = {0.20, 0.038, 0.051, 15.0, 155.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["bowl"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "bowl", AnimationOptions =
   {    Prop = "h4_prop_h4_coke_plasticbowl_01", PropBone = 28422, PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["pineapple"] = {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", "Pizza", AnimationOptions =
   {    Prop = "prop_pineapple", PropBone = 18905, PropPlacement = {0.10, 0.038, 0.03, 15.0, 50.0},
        EmoteMoving = true, EmoteLoop = true, }},
   ["foodbowl"] = {"amb@world_human_drinking@coffee@male@idle_a", "idle_c", "bowl", AnimationOptions =
   {    Prop = "prop_cs_bowl_01", PropBone = 28422, PropPlacement = {0.0, 0.0, 0.050, 0.0, 0.0, 0.0},
        EmoteMoving = true, EmoteLoop = true, }},
    ["joint"] = {"timetable@gardener@smoking_joint", "smoke_idle", "Drug", AnimationOptions =
	{   Prop = "prop_sh_joint_01", PropBone = 57005, PropPlacement = {0.12, 0.03, -0.05, 240.0, -60.0},
		EmoteMoving = true, EmoteLoop = true, }},
    ['stab'] = {'melee@hatchet@streamed_core_fps', 'plyr_front_takedown_b', 'Stab With Knife', AnimationOptions =
    {   Prop = 'prop_knife', PropBone = 57005, PropPlacement = {0.16, 0.1, -0.01, 0.0, 0.0, -45.0 },
        EmoteLoop = false, EmoteMoving = false, }},

        ["readblueprint"] = {
            "amb@world_human_clipboard@male@base",
            "base",
            "Read Blueprint",
            AnimationOptions = {
                Prop = 'p_blueprints_01_s',
                PropBone = 60309,
                PropPlacement = {
                    0.2500,
                    -0.07,
                    0.0350,
                    0.0,
                    0.0,--179.2527,
                    -13.8804
                },
                EmoteMoving = true,
                EmoteLoop = true
            }
        },
}



-----------------------------------------------------------------------------------------
--| I don't think you should change the code below unless you know what you are doing |--
-----------------------------------------------------------------------------------------

-- Add the custom emotes to RPEmotes main array
for arrayName, array in pairs(CustomDP) do
    if RP[arrayName] then
        for emoteName, emoteData in pairs(array) do
            RP[arrayName][emoteName] = emoteData
        end
    end
    -- Free memory
    CustomDP[arrayName] = nil
end
-- Free memory
CustomDP = nil
