
--[[
   _____   ______   _        _          _____    _____    _____    _____   ______    _____
  / ____| |  ____| | |      | |        |  __ \  |  __ \  |_   _|  / ____| |  ____|  / ____|
 | (___   | |__    | |      | |        | |__) | | |__) |   | |   | |      | |__    | (___
  \___ \  |  __|   | |      | |        |  ___/  |  _  /    | |   | |      |  __|    \___ \
  ____) | | |____  | |____  | |____    | |      | | \ \   _| |_  | |____  | |____   ____) |
 |_____/  |______| |______| |______|   |_|      |_|  \_\ |_____|  \_____| |______| |_____/

-- For every item you have above you must also list them down here by their itemname
-- Prices can be set at a stright number. However, what I've found best to be easiest is to have the
prices at a math.random so that everytime your server restarts or the resource does. The prices change
thus combatting people trying to exploit for a certain price. ]]--

SellItems = {
    ['orange'] = { price = math.random(5, 20), category = "FRUIT" },
    ['apple'] = { price = math.random(5, 20), category = "FRUIT" },
    ['pear'] = { price = math.random(5, 20), category = "FRUIT" },
    ['lemon'] = { price = math.random(5, 20), category = "FRUIT" },
    ['mango'] = { price = math.random(5, 20), category = "FRUIT" },
    ['peach'] = { price = math.random(5, 20), category = "FRUIT" },
    ['plum'] = { price = math.random(5, 20), category = "FRUIT" },
    ['cherry'] = { price = math.random(5, 20), category = "FRUIT" },
    ['blueberry'] = { price = math.random(5, 20), category = "FRUIT" },
    ['blackberry'] = { price = math.random(5, 20), category = "FRUIT" },
    ['strawberry'] = { price = math.random(5, 20), category = "FRUIT" },
    ['rasberry'] = { price = math.random(5, 20), category = "FRUIT" },
    ['guava'] = { price = math.random(5, 20), category = "FRUIT" },
    ['apricot'] = { price = math.random(5, 20), category = "FRUIT" },
    ['papaya'] = { price = math.random(5, 20), category = "FRUIT" },
    ['banana'] = { price = math.random(5, 20), category = "FRUIT" },
    ['tomato'] = { price = math.random(5, 20), category = "VEGETABLES" },
    ['avacado'] = { price = math.random(5, 20), category = "VEGETABLES" },
    ['chilipepper'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['wheat'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['thyme'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['basil'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['mint'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['oregano'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['cilantro'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['chives'] = { price = math.random(5, 20), category = "HERBS & PLANTS" },
    ['walnut'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['almond'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['pistachio'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['orangejuice'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['lemonjuice'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['peachjuice'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['applejuice'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['tomatojuice'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['blueberryjam'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ["strawberryjam"] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['tomatosauce'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['flour'] = { price = math.random(5, 20), category = "PROCESSED PRODUCTS" },
    ['chickenwings'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['chickenbreast'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawbeef'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawsteak'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawpork'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawporkchops'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawgroundbeef'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['milk'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['egg'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['butter'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['cheese'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
    ['rawbacon'] = { price = math.random(5, 20), category = "ANIMAL PRODUCTS" },
}