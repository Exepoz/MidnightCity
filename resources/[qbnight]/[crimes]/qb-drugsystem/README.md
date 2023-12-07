Made by Lionh34rt#4305
Discord: https://discord.gg/AWyTUEnGeN
Tebex: https://lionh34rt.tebex.io/

# Dependencies
* [QBCore Framework](https://github.com/qbcore-framework)
* [qb-target by BerkieBb](https://github.com/BerkieBb/qb-target)
* [ps-ui (optional, you can change the minigame)](https://github.com/Project-Sloth/ps-ui)
* [ps-dispatch (optional)](https://github.com/Project-Sloth/ps-dispatch)
* [K4MB1 Highend Lab Shells (optional, any shell can be used)](https://www.k4mb1maps.com/package/4698329)

# Installation
* **Add the items below to your qb-core > shared > items.lua.**
* **Run the included SQL script (druglabs.sql).**
* **Slot the snippet below into to your app.js FormateItemInfo function, make sure not to make any syntax errors.**
* **If you use anything other than ps-dispatch, go through the client files and change the dispatch exports**
* **Change the config to your liking, you can use any shells you want for this script as long as you change the offsets.**
* **Turn off debug when done configuring the script.**
* **You have to setup your own ways on how to get the pseudoephedrine, empty plastic baggies and portable_methlab, you can place it as a reward in another script like houserobberies or shops.**

# Add to your inventory app.js, FormateIteminfo to display the purity of items in the description, make sure to properly slot in with the other else if's:
```js
} else if (itemData.name == "suspicious_package") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Items packed: " + itemData.info.drug + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "meth_batch") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "meth_cured") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "meth_baggy") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "coke_batch") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "coke_cured") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "coke_baggy") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "weed_batch") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "weed_cured") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "weed_baggy") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
} else if (itemData.name == "meth") {
    $(".item-info-title").html("<p>" + itemData.label + "</p>");
    $(".item-info-description").html("<p>" + itemData.description + "</p>" + "<p>Purity: " + itemData.info.purity + "%</p>");
```

# Items for qb-core > shared > items.lua
```lua
['suspicious_package'] 			 = {['name'] = 'suspicious_package', 			['label'] = 'Suspicious Package', 		['weight'] = 10000, 	['type'] = 'item', 		['image'] = 'suspicious_package.png', 	['unique'] = true, 		['useable'] = false, 	['shouldClose'] = false,   	['combinable'] = nil,   ['description'] = 'A packed cardboard box'},
["empty_plastic_bag"] 			 = {["name"] = "empty_plastic_bag", 			["label"] = "Empty Ziploc baggies",		["weight"] = 100, 		["type"] = "item", 		["image"] = "empty-plastic-bag.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "A small and empty plastic bag."},
["meth_batch"] 		 		 	 = {["name"] = "meth_batch", 					["label"] = "Batch of Meth", 			["weight"] = 10000, 	["type"] = "item", 		["image"] = "meth_batch.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "A batch of meth that still needs curing..."},
["meth_cured"] 		 	 		 = {["name"] = "meth_cured", 					["label"] = "Cured Batch of Meth", 		["weight"] = 10000, 	["type"] = "item", 		["image"] = "meth_cured.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A cured batch of meth, ready to sell!"},
["meth_baggy"] 		 	 		 = {["name"] = "meth_baggy", 					["label"] = "Bag of Meth", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "meth_baggy.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A bag of meth!"},
["coke_batch"] 		 		 	 = {["name"] = "coke_batch", 					["label"] = "Batch of Coke", 			["weight"] = 10000, 	["type"] = "item", 		["image"] = "coke_batch.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "A batch of coke that still needs processing.."},
["coke_cured"] 		 	 		 = {["name"] = "coke_cured", 					["label"] = "Brick of Coke", 			["weight"] = 10000, 	["type"] = "item", 		["image"] = "coke_cured.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A processed brick of coke, ready to sell!"},
["coke_baggy"] 		 	 		 = {["name"] = "coke_baggy", 					["label"] = "Bag of Coke", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "coke_baggy.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A bag of cocaine!"},
["weed_batch"] 		 		 	 = {["name"] = "weed_batch", 					["label"] = "Batch of Weed", 			["weight"] = 10000, 	["type"] = "item", 		["image"] = "weed_batch.png", 			["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "A batch of weed that still needs drying.."},
["weed_cured"] 		 	 		 = {["name"] = "weed_cured", 					["label"] = "Dried Weed", 				["weight"] = 10000, 	["type"] = "item", 		["image"] = "weed_cured.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A dried batch of weed, ready to sell!"},
["weed_baggy"] 		 	 		 = {["name"] = "weed_baggy", 					["label"] = "Bag of Weed", 				["weight"] = 100, 		["type"] = "item", 		["image"] = "weed_baggy.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,		["combinable"] = nil,   ["description"] = "A bag of weed!"},
["methylamine"] 			 	 = {["name"] = "methylamine", 					["label"] = "Methylamine", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "methylamine.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "A derivative of ammonia, but with one H atom replaced by a methyl group"},
["ecgonine"] 			 		 = {["name"] = "ecgonine", 						["label"] = "Ecgonine", 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "ecgonine.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,	["combinable"] = nil,   ["description"] = "Ecgonine (tropane derivative) is a tropane alkaloid"},

['meth'] 					 	 = {['name'] = 'meth', 							['label'] = 'Bag of Meth', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'meth.png', 				['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,    	['combinable'] = nil,   ['description'] = 'A baggie of Meth'},
['portable_methlab'] 			 = {['name'] = 'portable_methlab', 				['label'] = 'Portable Methlab', 		['weight'] = 10000, 	['type'] = 'item', 		['image'] = 'portable_methlab.png', 	['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,    	['combinable'] = nil,   ['description'] = 'All you need to start your own drug empire..'},
['pseudoephedrine'] 			 = {['name'] = "pseudoephedrine", 				['label'] = "Pseudoephedrine", 			['weight'] = 1000, 		['type'] = "item", 		['image'] = "pseudoephedrine.png", 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = "Pseudoephedrine, also known as Pseudo or Sudo for short, commonly found in anti-allergy medicines."},

['weed']						 = {['name'] = "weed", 			 				['label'] = "Weed bag 1oz", 			['weight'] = 1000, 		['type'] = "item", 		['image'] = "weed.png", 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   	['combinable'] = nil,   ['description'] = "1oz Bag of Weed"},
['weed_buds']					 = {['name'] = "weed_buds", 			 		['label'] = "Weed buds", 				['weight'] = 800, 		['type'] = "item", 		['image'] = "weed_buds.png", 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   	['combinable'] = nil,   ['description'] = "Some weed buds"},	
```

# When inside a lab, you can use the 'laboffset' command to generate offsets for the locations in sh_shared, initially you may be falling through the air and have to noclip inside.