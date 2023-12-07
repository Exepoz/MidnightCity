Config = Config or {}
Config.Fence = {
    Time = {min = 5, max = 22},
    Blip = {
        Enable = false, -- Change to false to disable blip creation
        Location = vector3(973.25, -2190.45, 30.55), -- Blip location
        Sprite = 480,
        Display = 4,
        Scale = 0.6,
        Colour = 1,
        Name = "Mysterious Person", -- Name of the blip
    },
    NPC = {
        [1] = {
            location = vector3(1143.08, -2130.74, 29.98),
            heading = 313.17,
            model = "u_m_y_militarybum"
        },
    },
    Items = { -- NO GEMS FROM MINING
        [1] = {
            item = 'goldchain', -- bank loot
            price = math.random(75,150)
        },
        [2] = {
            item = 'diamond_ring', -- bank loot
            price = math.random(200,350)
        },
        [3] = {
            item = 'rolex', -- bank loot
            price = math.random(200,500)
        },
        [4] = {
            item = '10kgoldchain', -- bank loot
            price = math.random(250,400)
        },
        [5] = {
            item = 'tablet',
            price = math.random(50,80)
        },
        [6] = {
            item = 'iphone',
            price = math.random(200,400)
        },
        [7] = {
            item = 'samsungphone',
            price = math.random(100,150)
        },
        [8] = {
            item = 'laptop',
            price = math.random(200,500)
        },
        [9] = {
            item = 'goldbar',
            price = math.random(7500,12500)
        },
        [10] = {
            item = 'yellow-diamond',
            price = math.random(1000,1500)
        },
        [11] = {
            item = 'diamond',
            price = math.random(200,500)
        },
        [12] = {
           item = 'red_diamond',
           price = math.random(2000,3000)
        },
        [13] = {
            item = 'brokendetector',--remove
            price = math.random(200,275)
        },
        [14] = {
            item = 'brokenphone', --remove
            price = math.random(250,350)
        },
        [15] = {
            item = 'antiquecoin', --remove
            price = math.random(300,400)
        },
        [16] = {
            item = 'dj_deck',
            price = math.random(400,800)
        },
        [17] = {
            item = 'console',
            price = math.random(125,300)
        },
        [18] = {
            item = 'goldennugget',
            price = math.random(100,200)
        },
        [19] = {
            item = 'bong',
            price = math.random(50,150)
        },
        [20] = {
            item = 'goldcoin', --remove
            price = math.random(75,120)
        },
        [21] = {
            item = 'flat_television',--remove
            price = math.random(100,450)
        },
        [22] = {
            item = 'coffeemaker',
            price = math.random(100,250)
        },
        [23] = {
            item = 'hairdryer',
            price = math.random(15,75)
        },
        [24] = {
            item = 'j_phone', --remove
            price = math.random(25,80)
        },
        [25] = {
            item = 'sculpture', --remove
            price = math.random(100,1000)
        },
        [26] = {
            item = 'toiletry',
            price = math.random(40,60)
        },
        [27] = {
            item = 'laptop', -- remove
            price = math.random(300,800)
        },
        [28] = {
            item = 'monitor',
            price = math.random(300,600)
        },
        [29] = {
            item = 'printer', --remove
            price = math.random(150,225)
        },
        [30] = {
            item = 'watch',
            price = math.random(20,100)
        },
        [31] = {
            item = 'toothpaste',
            price = math.random(10,15)
        },
        [32] = {
            item = 'soap',
            price = math.random(10,35)
        },
        [33] = {
            item = 'romantic_book',
            price = math.random(20,30)
        },
        [34] = {
            item = 'necklace', --remove
            price = math.random(75,150)
        },
        [35] = {
            item = 'gold_watch', --remove
            price = math.random(150,250)
        },
        [36] = {
            item = 'gold_bracelet',
            price = math.random(100,350)
        },
        [37] = {
            item = 'bracelet', --remove
            price = math.random(40,150)
        },
        [38] = {
            item = 'earrings',
            price = math.random(90,150)
        },
        [39] = {
            item = 'book',
            price = math.random(25,80)
        },
        [40] = {
            item = 'skull',
            price = math.random(75,150)
        },
        [41] = {
            item = 'pencil',
            price = math.random(10,35)
        },
        [42] = {
            item = 'notepad',
            price = math.random(10,20)
        },
        [43] = {
            item = 'tapeplayer',
            price = math.random(25,50)
        },
        [44] = {
            item = 'shoebox',
            price = math.random(20,100)
        },
        [45] = {
            item = 'tv',
            price = math.random(500,850)
        },
        [46] = {
            item = 'pd_watch',
            price = math.random(500,1000)
        },
        [47] = {
            item = 'pd_ringset',
            price = math.random(750,1250)
        },
        [48] = {
            item = 'pd_necklace',
            price = math.random(1000,1500)
        },
        [49] = {
            item = 'pd_laptop',
            price = math.random(1000,1250)
        },
        [50] = {
            item = 'captainskull',
            price = math.random(5000,10000)
        },
        [51] = {
            item = 'telescope',
            price = math.random(500,1000)
        },
        [52] = {
            item = 'microwave',
            price = math.random(250,500)
        },
        [53] = {
            item = 'casino_diamonds',
            price = math.random(15000,20000)
        },
        [54] = {
            item = 'ancientcoin',
            price = math.random(8000,8500)
        },
        [55] = {
            item = 'ww2relic',
            price = math.random(10000,12000)
        },
        [56] = {
            item = 'brokengamboy',
            price = math.random(200,300)
        },
        [57] = {
            item = 'gameboy',
            price = math.random(250,500)
        },
        [58] = {
            item = 'pocketwatch',
            price = math.random(10000,12000)
        },
    }
}