
--[[
  __________  _   _ ______  _____
 |___  / __ \| \ | |  ____|/ ____|
    / / |  | |  \| | |__  | (___
   / /| |  | | . ` |  __|  \___ \
  / /_| |__| | |\  | |____ ____) |
 /_____\____/|_| \_|______|_____/

This is where you can do all of your zone editing,
You may turn off and on the zones - by turning the zones true or false.
You may also change the Zone's item by changing Item (When you change the item make sure to change the Item Label this will change the bar text of your Locales)
From this section you can also turn off and on the blips as well as change the blip sprite and blip color. The Blip name will change based on your ItemLabel Name.
Note: Do not turn on all blips. There are a LOT of blips.]]

Zones ={
    Trees = {
       { -- ONE
           ZoneEnabled = true, -- True turns on the zone, false turns off the zone
           BlipEnabled = false, BlipSprite = 686, BlipColor = 21, -- https://docs.fivem.net/docs/game-references/blips/
           BlipLoc = vector3(353.3, 6518.64, 28.39),
           TargetIcon = "fas fa-circle", Item = 'orange', ItemLabel = "Oranges",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { --Two
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 687, BlipColor = 21, BlipLoc = vec3(261.64, 6527.68, 28.39), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole-whole", Item = "peach", ItemLabel = "Peaches",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Three
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 688, BlipColor = 21, BlipLoc = vec3(246.61, 6503.15, 28.39),-- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "mango", ItemLabel = "Mangoes",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Four
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 689, BlipColor = 21, BlipLoc = vec3(194.01, 6497.31, 31.51), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "plum", ItemLabel = "Plums",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Five
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 690, BlipColor = 21, BlipLoc = vec3(2304.74, 4997.13, 41.92), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fab fa-apple", Item = "apple", ItemLabel = "Apples",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Six
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 691, BlipColor = 21, BlipLoc = vec3(2361.81, 4976.16, 43.1), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-lemon",  Item = "lemon", ItemLabel = "Lemons",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Seven
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 692, BlipColor = 21, BlipLoc = vec3(2406.95, 4677.15, 33.98), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "pear", ItemLabel = "Pears",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
           },
       { -- Eight
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 693, BlipColor = 21, BlipLoc = vec3(2350.36, 4734.2, 34.78), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "guava", ItemLabel = "Guavas",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Nine
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 694, BlipColor = 21, BlipLoc = vec3(2443.47, 4672.41, 33.33), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "banana", ItemLabel = "Bananas",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Ten
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 695, BlipColor = 21, BlipLoc = vec3(2367.47, 4752.05, 34.06), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "papaya", ItemLabel = "Papayas",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Eleven
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 696, BlipColor = 21, BlipLoc = vec3(2083.43, 4853.43, 41.91), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "avacado", ItemLabel = "Avacados",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Twelve
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 697, BlipColor = 21, BlipLoc = vec3(2031.21, 4802.13, 41.88), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "apricot", ItemLabel = "Apricots",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
   },
   Plants = {
       { -- One
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 686, BlipColor = 21, BlipLoc = vector3(360.27, 6471.88, 31.97), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "blueberry", ItemLabel = "Blueberries",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Two
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 687, BlipColor = 21, BlipLoc = vector3(346.42, 6470.8, 31.62), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "strawberry", ItemLabel = "Strawberries",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Three
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 688, BlipColor = 21, BlipLoc = vector3(325.89, 6474.19, 32.88),-- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "walnut", ItemLabel = "Walnuts",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Four
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 689, BlipColor = 21, BlipLoc = vector3(1842.67, 5053.96, 58.98), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "almond", ItemLabel = "Almonds",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Five
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 690, BlipColor = 21, BlipLoc = vector3(1907.71, 5084.33, 49.45), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "pistachio", ItemLabel = "Pistachios",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Six
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 691, BlipColor = 21, BlipLoc = vector3(1914.91, 5065.4, 47.58), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "rasberry", ItemLabel = "Rasberries",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Seven
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 692, BlipColor = 21, BlipLoc = vector3(1915.75, 4996.55, 47.19), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "blackberry", ItemLabel = "Blackberry",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Eight
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 693, BlipColor = 21, BlipLoc = vector3(1780.71, 5000.83, 54.53), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "thyme", ItemLabel = "Thyme",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Nine
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 694, BlipColor = 21, BlipLoc = vec3(1925.1, 4809.02, 44.91), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "oregano", ItemLabel = "Oregano",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Ten
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 695, BlipColor = 21, BlipLoc = vec3(1930.53, 4819.78, 45.43),  -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "basil", ItemLabel = "Basil",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Eleven
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 696, BlipColor = 21, BlipLoc = vec3(1881.51, 4846.06, 45.62), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "chives", ItemLabel = "Chives",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Twelve
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 697, BlipColor = 21, BlipLoc = vec3(1904.25, 4888.82, 47.52), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "chilipepper", ItemLabel = "Chili Peppers",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Thirteen
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 698, BlipColor = 21, BlipLoc = vec3(1945.07, 4886.46, 46.26), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "cilantro", ItemLabel = "Cilantro",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Fourteen
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 699, BlipColor = 21, BlipLoc = vec3(1952.0, 4897.66, 45.3),  -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "mint", ItemLabel = "Mint",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Fifteen
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 700, BlipColor = 21, BlipLoc = vec3(1952.0, 4897.66, 45.3), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "cherry", ItemLabel = "Cherries",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2)
       },
       { -- Sixteen
           ZoneEnabled = true,
           BlipEnabled = false,
           BlipSprite = 701, BlipColor = 21, BlipLoc = vec3(1952.0, 4897.66, 45.3), -- https://docs.fivem.net/docs/game-references/blips/
           TargetIcon = "fas fa-apple-whole", Item = "tomato", ItemLabel = "Tomatoes",
           RepAmount = 2, ItemAmountGiven = math.random(1, 2),
       },
   },
}