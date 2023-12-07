07/29/2023
- Giant Rework--
===============
+ WheatZone Patch
+ CayoFarming Minigame
++ DLC Patnership with PAIN Tobacco Warehouse MLO ++
+ MOVED THINGS AROUND TO MAKE PRETTY
+ made all targets dynamic to move from configs. Moved all configs into their own folder


4/20/2023
- Wheatzone patch
- Small patches for other functions
-- cleanup of shared.
- Prep for future updates
-- Future Updates:
-- (Couldn't push in this update)
--- Cayo Perico Plants
--- Personal Farm owning  (I figured it out will be pushed next update)



3/12/2023
v 1.0.3
- More Optimization and cleanup of code
+ animals.lua
+ server.lua

- Wheatfarming Spawn functions unescrowed

- Buyer.lua completely rewritten

- SellPrices area reflects this. You now only have to add the item to the config for it to show in the buyer menu. No need to to touch the buyer.lua

- Sell Webhooks

- prints that were left on accidentally in last update were either cleaned up or deleted.

**What files to replace?** - Reinstall fresh.

-- 3/5/2023
Jixel-Farming v 1.0.2
- More Optimization and cleanup of code

- Rep is now left in the recipes crafting table to help with people who aren't understanding how to put rep in.
You can remove `rep = 0` and it will not effect the script now as long as you have `FarmingRep` turned to `false`
if you have rep removed from the table but have `FarmingRep` turned to `true` it will error out.

- Wheat Farming... works? Possibly? Might be out of beta?

- You will need to update the `shared.lua` and `wheatfarming.lua` if you want to just get the wheatfarming update


-- 3/4/2023
Jixel-Farming v 1.0.1
- Optimized the fuck out of my spaghetti code in the farming.lua

- Config is an array instead of a table

- Removed Config.ScriptOptions.JobRequired. To a simpler version of To set job locked change Job = "farmer" or "all" for walkup

- Will update gitbook accordingly nothing else really functionality wise changed
