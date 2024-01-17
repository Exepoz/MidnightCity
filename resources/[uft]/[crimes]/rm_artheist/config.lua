Config = {}
Config['ArtHeist'] = {
    ['nextRob'] = 1800, -- seconds for next heist
    ['startHeist'] ={ -- heist start coords
        pos = vector3(244.346, 374.012, 105.738),
        peds = {
            {pos = vector3(244.346, 374.012, 105.738), heading = 156.39, ped = 's_m_m_highsec_01'},
            {pos = vector3(243.487, 372.176, 105.738), heading = 265.63, ped = 's_m_m_highsec_02'},
            {pos = vector3(245.074, 372.730, 105.738), heading = 73.3, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['sellPainting'] ={ -- sell painting coords
        pos = vector3(288.558, -2981.1, 5.90696),
        peds = {
            {pos = vector3(288.558, -2981.1, 5.90696), heading = 135.88, ped = 's_m_m_highsec_01'},
            {pos = vector3(287.190, -2980.9, 5.72252), heading = 218.0, ped = 's_m_m_highsec_02'},
            {pos = vector3(287.731, -2982.6, 5.82852), heading = 336.08, ped = 's_m_m_fiboffice_02'}
        }
    },
    ['painting'] = {
        {
            rewardItem = 'madrazo_art', -- u need add item to database
            paintingPrice = '300', -- price of the reward item for sell
            scenePos = vector3(1395.4, 1159.77, 113.4136), -- animation coords vector3(1400.486, 1164.55, 113.4136)
            sceneRot = vector3(0.0, 0.0, 180.0), -- animation rotation
            object = 'ch_prop_vault_painting_01e', -- object (https://mwojtasik.dev/tools/gtav/objects/search?name=ch_prop_vault_painting_01)
            objectPos = vector3(1395.4, 1158.8, 114.5336), -- object spawn coords vector3(1400.946, 1164.55, 114.5336),
            objHeading = 180.0 -- object spawn heading
        },
        {
            rewardItem = 'madrazo_art',
            paintingPrice = '300',
            scenePos = vector3(1408.175, 1144.014, 113.4136),
            sceneRot = vector3(0.0, 0.0, 180.0),
            object = 'ch_prop_vault_painting_01i',
            objectPos = vector3(1408.175, 1143.564, 114.5336),
            objHeading = 180.0
        },
        {
            rewardItem = 'madrazo_art',
            paintingPrice = '300',
            scenePos = vector3(1407.637, 1150.74, 113.4136),
            sceneRot = vector3(0.0, 0.0, 0.0),
            object = 'ch_prop_vault_painting_01h',
            objectPos = vector3(1407.637, 1151.17, 114.5336),
            objHeading = 0.0
        },
        {
            rewardItem = 'madrazo_art',
            paintingPrice = '300',
            scenePos = vector3(1408.637, 1150.74, 113.4136),
            sceneRot = vector3(0.0, 0.0, 0.0),
            object = 'ch_prop_vault_painting_01j',
            objectPos = vector3(1408.637, 1151.17, 114.5336),
            objHeading = 0.0
        },
        {
            rewardItem = 'madrazo_art',
            paintingPrice = '300',
            scenePos = vector3(1397.586, 1165.579, 113.4136),
            sceneRot = vector3(0.0, 0.0, 90.0),
            object = 'ch_prop_vault_painting_01f',
            objectPos = vector3(1397.136, 1165.579, 114.5336),
            objHeading = 90.0
        },
        {
            rewardItem = 'madrazo_art',
            paintingPrice = '300',
            scenePos = vector3(1397.976, 1165.679, 113.4136),
            sceneRot = vector3(0.0, 0.0, 0.0),
            object = 'ch_prop_vault_painting_01g',
            objectPos = vector3(1397.936, 1166.079, 114.5336),
            objHeading = 0.0
        },
    },
    ['objects'] = { -- dont change (required)
        'hei_p_m_bag_var22_arm_s',
        'w_me_switchblade'
    },
    ['animations'] = { -- dont change (required)
        {"top_left_enter", "top_left_enter_ch_prop_ch_sec_cabinet_02a", "top_left_enter_ch_prop_vault_painting_01a", "top_left_enter_hei_p_m_bag_var22_arm_s", "top_left_enter_w_me_switchblade"},
        {"cutting_top_left_idle", "cutting_top_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_idle_ch_prop_vault_painting_01a", "cutting_top_left_idle_hei_p_m_bag_var22_arm_s", "cutting_top_left_idle_w_me_switchblade"},
        {"cutting_top_left_to_right", "cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a", "cutting_top_left_to_right_ch_prop_vault_painting_01a", "cutting_top_left_to_right_hei_p_m_bag_var22_arm_s", "cutting_top_left_to_right_w_me_switchblade"},
        {"cutting_top_right_idle", "_cutting_top_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_top_right_idle_ch_prop_vault_painting_01a", "cutting_top_right_idle_hei_p_m_bag_var22_arm_s", "cutting_top_right_idle_w_me_switchblade"},
        {"cutting_right_top_to_bottom", "cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_right_top_to_bottom_ch_prop_vault_painting_01a", "cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_right_top_to_bottom_w_me_switchblade"},
        {"cutting_bottom_right_idle", "cutting_bottom_right_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_idle_ch_prop_vault_painting_01a", "cutting_bottom_right_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_idle_w_me_switchblade"},
        {"cutting_bottom_right_to_left", "cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_right_to_left_ch_prop_vault_painting_01a", "cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s", "cutting_bottom_right_to_left_w_me_switchblade"},
        {"cutting_bottom_left_idle", "cutting_bottom_left_idle_ch_prop_ch_sec_cabinet_02a", "cutting_bottom_left_idle_ch_prop_vault_painting_01a", "cutting_bottom_left_idle_hei_p_m_bag_var22_arm_s", "cutting_bottom_left_idle_w_me_switchblade"},
        {"cutting_left_top_to_bottom", "cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a", "cutting_left_top_to_bottom_ch_prop_vault_painting_01a", "cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s", "cutting_left_top_to_bottom_w_me_switchblade"},
        {"with_painting_exit", "with_painting_exit_ch_prop_ch_sec_cabinet_02a", "with_painting_exit_ch_prop_vault_painting_01a", "with_painting_exit_hei_p_m_bag_var22_arm_s", "with_painting_exit_w_me_switchblade"},
    },
}

Strings = {
    ['steal_blip'] = 'Madrazo Mansion',
    ['sell_blip'] = 'Painting Customers',
    ['start_stealing'] = 'Press ~INPUT_CONTEXT~ to stealing',
    ['cute_right'] = 'Press ~INPUT_CONTEXT~ to cut right',
    ['cute_left'] = 'Press ~INPUT_CONTEXT~ to cut left',
    ['cute_down'] = 'Press ~INPUT_CONTEXT~ to cut down',
    ['go_steal'] = 'Go to Madrazo Mansion and steal painting.',
    ['go_sell'] = 'Go to blip and sell painting.',
    ['already_cuting'] = 'You already stealing.',
    ['already_heist'] = 'You already start heist. Wait until its over.',
    ['start_heist'] = 'Press ~INPUT_CONTEXT~ to start heist',
    ['sell_painting'] = 'Press ~INPUT_CONTEXT~ to sell painting',
    ['wait_nextrob'] = 'You have to wait this long to undress again',
    ['minute'] = 'Minute',
    ['police_alert'] = 'Art stealing alert! Check your gps.',
}

Config.Patrols = {
    [1] = {
        npc = {coords = vector3(1401.05, 1129.26, 114.33), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'StandGuard', coords = vector3(1401.05, 1129.26, 114.33), lookat =  vector3(1396.76, 1132.54, 114.33), time = {min = 10000, max =15000}},
            [2] = {stance = '', coords = vector3(1391.92, 1129.74, 114.33), lookat = vector3(0,0,0), time = 0},
            [3] = {stance = 'StandGuard', coords = vector3(1391.41, 1132.85, 114.33), lookat = vector3(1387.8, 1132.61, 114.33), time = {min = 7500, max =10000}},
            [4] = {stance = '', coords = vector3(1392.0, 1134.53, 114.33), lookat = vector3(0,0,0), time = 0},
            [5] = {stance = '', coords = vector3(1398.18, 1135.58, 114.33), lookat = vector3(0,0,0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1398.34, 1143.4, 114.33), lookat = vector3(1405.53, 1149.69, 114.33), time = {min = 10000, max =15000}},
            [7] = {stance = '', coords = vector3(1398.35, 1147.75, 114.33), lookat = vector3(0,0,0), time = 0},
            [8] = {stance = 'StandGuard', coords = vector3(1392.13, 1147.44, 114.33), lookat = vector3(1387.95, 1147.62, 114.33), time = {min = 7500, max =10000}},
            [9] = {stance = '', coords = vector3(1398.35, 1147.75, 114.33), lookat = vector3(0,0,0), time = 0},
            [10] = {stance = '', coords = vector3(1398.33, 1137.24, 114.33), lookat = vector3(0,0,0), time = 0},
            [11] = {stance = '', coords = vector3(1400.42, 1134.27, 114.33), lookat = vector3(0,0,0), time = 0},
        }
    },
    [2] = {
        npc = {coords = vector3(1387.2, 1127.32, 114.33), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'StandGuard', coords = vector3(1387.2, 1127.32, 114.33), lookat = vector3(1374.22, 1133.42, 114.09), time = {min = 10000, max = 15000}},
            [2] = {stance = '', coords = vector3(1387.45, 1154.43, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [3] = {stance = 'WORLD_HUMAN_AA_SMOKE', coords = vector3(1383.23, 1154.87, 114.33), lookat = vector3(1374.8, 1155.32, 114.01), time = {min = 45000, max = 60000}},
            [4] = {stance = '', coords = vector3(1387.53, 1155.11, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [5] = {stance = '', coords = vector3(1387.24, 1126.96, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1409.34, 1127.22, 114.33), lookat = vector3(1414.24, 1132.85, 114.35), time = {min = 10000, max = 15000}},
        }
    },
    [3] = {
        npc = {coords = vector3(1388.6, 1162.45, 114.33), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'StandGuard', coords = vector3(1388.6, 1162.45, 114.33), lookat = vector3(1375.96, 1162.62, 114.21), time = {min = 10000, max = 15000}},
            [2] = {stance = '', coords = vector3(1387.35, 1162.57, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [3] = {stance = 'StandGuard', coords = vector3(1387.52, 1167.41, 114.33), lookat = vector3(1380.4, 1173.34, 114.39), time = {min = 10000, max = 15000}},
            [4] = {stance = 'StandGuard', coords = vector3(1410.13, 1167.31, 114.33), lookat = vector3(1409.67, 1176.14, 114.31), time = {min = 10000, max = 15000}},
            [5] = {stance = '', coords = vector3(1410.26, 1154.54, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1418.28, 1151.84, 114.67), lookat = vector3(1421.29, 1151.9, 112.97), time = {min = 7500, max = 10000}},
            [7] = {stance = '', coords = vector3(1410.26, 1154.54, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [8] = {stance = 'StandGuard', coords = vector3(1410.13, 1167.31, 114.33), lookat = vector3(1409.67, 1176.14, 114.31), time = {min = 10000, max = 15000}},
            [9] = {stance = 'StandGuard', coords = vector3(1387.52, 1167.41, 114.33), lookat = vector3(1380.4, 1173.34, 114.39), time = {min = 10000, max = 15000}},
            [10] = {stance = '', coords = vector3(1387.35, 1162.57, 114.33), lookat = vector3(0, 0, 0), time = 0},
        }

    },
    [4] = {
        npc = {coords = vector3(1399.28, 1165.17, 114.33), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'WORLD_HUMAN_WINDOW_SHOP_BROWSE', coords = vector3(1399.28, 1165.17, 114.33), lookat = vector3(1399.21, 1165.79, 114.33), time = {min = 10000, max = 15000}},
            [2] = {stance = 'StandGuard', coords = vector3(1399.28, 1165.17, 114.33), lookat = vector3(1400.01, 1164.97, 114.33), time = {min = 1000, max = 1000}},
            [3] = {stance = 'WORLD_HUMAN_WINDOW_SHOP_BROWSE', coords = vector3(1399.28, 1165.17, 114.33), lookat = vector3(1400.01, 1164.97, 114.33), time = {min = 10000, max = 15000}},
            [4] = {stance = 'StandGuard', coords = vector3(1399.28, 1165.17, 114.33), lookat = vector3(1399.28, 1158.87, 114.33), time = {min = 10000, max = 15000}},
            [5] = {stance = '', coords = vector3(1399.18, 1151.33, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1396.8, 1152.16, 114.33), lookat = vector3(1393.49, 1153.33, 114.44), time = {min = 10000, max = 15000}},
            [7] = {stance = '', coords = vector3(1400.08, 1149.97, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [8] = {stance = 'StandGuard', coords = vector3(1408.36, 1149.8, 114.33), lookat = vector3(1412.94, 1147.85, 114.33), time = {min = 10000, max = 15000}},
            [9] = {stance = 'StandGuard', coords = vector3(1408.18, 1144.66, 114.33), lookat = vector3(1401.42, 1149.48, 114.33), time = {min = 7500, max = 10000}},
            [10] = {stance = '', coords = vector3(1406.23, 1145.25, 114.33), lookat = vector3(0, 0, 0), time = 0},
            [11] = {stance = '', coords = vector3(1399.37, 1145.18, 114.33), lookat = vector3(0, 0, 0), time = 0},
        }
    },
    [5] = {
        npc = {coords = vector3(1431.32, 1179.95, 114.17), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'WORLD_HUMAN_AA_SMOKE', coords = vector3(1431.32, 1179.95, 114.17), lookat = vector3(1431.16, 1188.9, 114.16), time = {min = 10000, max = 15000}},
            [2] = {stance = 'StandGuard', coords = vector3(1432.32, 1123.58, 114.3), lookat = vector3(1422.11, 1119.51, 114.67), time = {min = 10000, max = 15000}},
            [3] = {stance = '', coords = vector3(1423.53, 1115.41, 114.54), lookat = vector3(0, 0, 0), time = 0},
            [4] = {stance = '', coords = vector3(1390.53, 1115.61, 114.82), lookat = vector3(0, 0, 0), time = 0},
            [5] = {stance = '', coords = vector3(1372.7, 1124.33, 114.13), lookat = vector3(0, 0, 0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1368.33, 1135.49, 113.76), lookat = vector3(1363.72, 1144.27, 113.76), time = {min = 10000, max = 15000}},
            [7] = {stance = '', coords = vector3(1372.7, 1124.33, 114.13), lookat = vector3(0, 0, 0), time = 0},
            [8] = {stance = '', coords = vector3(1390.53, 1115.61, 114.82), lookat = vector3(0, 0, 0), time = 0},
            [9] = {stance = 'StandGuard', coords = vector3(1423.53, 1115.41, 114.54), lookat = vector3(1429.41, 1110.54, 114.19), time = {min = 10000, max = 15000}},
            [10] = {stance = 'StandGuard', coords = vector3(1432.32, 1123.58, 114.3), lookat = vector3(0, 0, 0), time = 0},
        }
    },
    [6] = {
        npc = {coords = vector3(1361.39, 1161.03, 113.75), model = 'g_m_m_armlieut_01', weapon = 'WEAPON_COMBATPISTOL'},
        path = {
            [1] = {stance = 'WORLD_HUMAN_AA_SMOKE', coords = vector3(1361.39, 1161.03, 113.75), lookat = vector3(1361.17, 1154.46, 113.76), time = {min = 10000, max = 15000}},
            [2] = {stance = 'StandGuard', coords = vector3(1360.7, 1182.3, 112.49), lookat = vector3(1360.43, 1188.86, 112.45), time = {min = 10000, max = 15000}},
            [3] = {stance = '', coords = vector3(1366.92, 1189.31, 112.76), lookat = vector3(0, 0, 0), time = 0},
            [4] = {stance = 'StandGuard', coords = vector3(1416.69, 1187.73, 114.0), lookat = vector3(1431.47, 1186.33, 114.16), time = {min = 10000, max = 15000}},
            [5] = {stance = '', coords = vector3(1366.92, 1189.31, 112.76), lookat = vector3(0, 0, 0), time = 0},
            [6] = {stance = 'StandGuard', coords = vector3(1341.34, 1188.54, 110.17), lookat = vector3(1331.43, 1188.79, 108.39), time = {min = 10000, max = 15000}},
            [7] = {stance = '', coords = vector3(1354.29, 1188.47, 112.17), lookat = vector3(0, 0, 0), time = 0},
            [8] = {stance = '', coords = vector3(1360.7, 1182.3, 112.49), lookat = vector3(0, 0, 0), time = 0},
        }
    },
}