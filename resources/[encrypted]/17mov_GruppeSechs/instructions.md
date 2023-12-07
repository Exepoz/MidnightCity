1. Add "gruppeSechsTablet" item to your item system. If you're using qbcore, paste it under qb-core/shared/items.lua:

	['gruppesechstablet'] 			 = {['name'] = 'gruppesechstablet', 				['label'] = 'Gruppe Sechs Tablet', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'gruppesechstablet.png', 		['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A nice device that allows you to rob the gruppe sechs transports'},


# Or if you're running ESX, drop this query to your database:

    INSERT INTO `items` (name, label, weight) VALUES
        ('gruppesechstablet', 'Gruppe Sechs Tablet', 2)
    ;


# If you have any problems, ask for help on our discord:
# https://discord.gg/dWUmBQ6KuJ