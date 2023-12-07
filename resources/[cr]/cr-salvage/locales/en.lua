SalvageLocales = {
    ['salvagetitle'] = "Salvaging",
    ['ScrapyardBlipName'] = "Salvage Yard",

    ['debug_spawningPlane'] = "Spawning Plane World Wreck at %s", --| %s --> Coordinates
    ['debug_successfulSpawn'] = "Wreckage Spawned Successfully | Hash : %s | Entity : %s | Coords : %s | WreckType : %s", --| Every %s is self-explaning
    ['debug_spawningFlightBox'] = "Spawning Flight Box...",
    ['debug_flightboxSpawned'] = "Spawned Flight Box at %s | Entity : %s", --| First %s --> Coordinates, Second %s --> Entity ID
    ['debug_emailsToggle'] = "Email Notifications Set To %s", -- When Enableing Emails
    ['debug_deletingFlightBox'] = "Deleting Nearby Flight Box...", -- When Deleting the Flight Box (Someone took it)
    ['debug_menuconfigerror'] = "Error in the Menu Configuration, please advice Server Admins.", -- When the Menus are configured wrong.
    ['debug_spawning'] = "Spawning Wreck...", -- When Attempting to spawn a wreck
    ['debug_wwinfo'] = "Receiving World Wreck Info...", -- When frist receiving World Wreck Info from server
    ['debug_startharvesting'] = "Salvaging Wreck...", -- When the player starts salvaging a scrapyard wreck
    ['debug_bladequality'] = "Blade Quality : %s", -- Send the blade quality everytime it degrades (each use) (%s --> Quality)
    ['debug_bonusroll'] = "%s Got %s bonus rolls when salvaging a wreck!", -- Shows when a player gets bonus rolls on salvaging (loot) | First %s --> Player name, Second %s --> amount of rolls
    ['debug_salvagenotification'] = "%s Salvaged some materials. Check logs (if enabled, for full list of drops) - %s Rolls, Type : %s, New Wreck Health : %s", -- Sent when a player salvage some materials, | First %s, Player Name, second %s, Amoung of rolls in total)
    ['debug_wreckdepleted'] = "Wreck Depleted, Spawning New Wreck...", -- When a Scrapyard wreck's health goes to 0.
    ['debug_spawningnewwreck'] = "Spawning New Wreck at %s (Hash : %s)", -- When Spawning a new wreck (server-side).
    ['debug_GeneratingWWInfo'] = "Generating World Wreck Info...", -- When the server is generation the world wreck info
    ['debug_WorldWreckTimesUp'] = "World Wreck Idle Too Long, Despawning...",
    ['debug_WaitingForWW'] = "World Wreck On Cooldown. Waiting %s minutes...", -- When the world wreck goes on cooldown
    ['debug_WorldWreckDistanceCheck'] = "World Wreck Spawn Distance : %s", -- Distance between player and world wreck

    -- Logs
    ['logs_title'] = "Salvage", -- Logs title
    ['logs_FlightBoxRewardTitle'] = "Flight Box Reward",
    ['logs_FlightBoxTitle'] = "Flight Box Picked Up",
    ['logs_FlightBoxMoneyReward'] = "**Player : **%s\n**Money Received  : **%s",
    ['logs_FlightBoxItemReward'] = "**Player :** %s\n**Item Received :**%s **Amount :** %s", -- First %s --> Player Name, Second %s --> All Items received
    ['logs_ItemReceived'] = "**Player :** %s\n**Items Received :**\n%s", -- First %s --> Player Name, Second %s --> All Items received
    ['logs_ItemBoughtTitle'] = "Item Bought",
    ['logs_ItemBought'] = "**Player :** %s\n**Item Received :**%s **Amount :** %s", -- First %s --> Player Name, Second %s --> All Items received
    ['logs_Roll'] = "**Roll :** %s/%s", --Item Rolls (Current/Max)
    ['logs_Rarity'] = "**Rarity :** %s", -- Rarity
    ['logs_Item'] = "**Item :** %s", -- Name
    ['logs_Qty'] = "**Quantity :** %s", -- Quantity


    ['notif_missingsaw'] = "You don't have a working Power Saw with you", -- When the player doesn't have a working power saw
    ['notif_stopsalvage'] = "Press [%s] to stop salvaging materials", -- TextUI shown when player is salvaging | %s --> Interact Key
    ['notif_sawjammed'] = "You jammed the Power Saw! Lucky you didn't break the blade...", -- When the player fails the skillcheck and the behaviour is break or stop
    ['notif_sawbladebroke'] = "The sawblade broke! You need to install a new one...", -- When the player breaks the saw blade
    ['notif_notfacingwreck'] = "You need to be facing the wreckage to do this!", -- When the player tries to salvage a wreck but is not looking at it 
    ['notif_bonuslootnotif'] = "You salvaged bonus materials!", -- When the player gets bonus material from a wreckage
    ['notif_wreckDepleted'] = "You scrapped everything useful from this wreckage!", -- When a wreckage is depleted
    ['notif_notenoughspace'] = "You don't have enough space in your pockets to hold this!", -- When a player's inventory is too full to get items.
    ['notif_infogiveflightbox'] = "This is the Los Santos Air Archives, bring us a recovered Flight Box and we will give you compensation!", -- Text when interacting with the Flight Box Hand-in Ped
    ['notif_giveflightbox'] = "Thank you! Here's something for you. Bring us more if you find any!", -- Text when handing in a recovered flight box
    ['notif_enableemailnotification'] = "We will send you an email with the approximate location of the crash once we locate it.", -- Message when a player enables Email Notifications
    ['notif_disableemailnotification'] = "We will stop sending you emails when we find crashes around the island.", -- Message when a player disables email notifications
    ['notif_GPSUpdated'] = "GPS Updated.", -- When the player's GPS is updated with the world wreck location.

    ['email_subject'] = "Crash Located!", -- Email Subject
    ['email_message'] = "We have located a crash on the island! We\'ve sent you the approximate location on your GPS!", -- Email Message
    ['email_button'] = "Grab Location", -- Button Message
    ['email_notification'] = "Crash Located! Accept to receive location.", -- Short version of the notificaiton for use with NPWD phone.

    ['salvageUI_Salvage'] = "Salvage", -- M1 "Salvage" action
    ['salvageUI_Stop'] = "Stop", -- G "Stop" action
    ['salvageUI_Progress'] = "Progress", -- Progress
    ['salvageUI_BladeHeat'] = "Blade Heat", -- Blade Heat
    ['salvageUI_Sweetspot'] = "Heat Sweetspot", -- When the player hit the sweetspot and can get bonus loot.

    ['interact_handinflightbox'] = "Hand in Flight Box", -- Handing-in Flight Box Interaction 
    ['interact_talkto'] = "Talk to", -- Talk to ped Interaction
    ['interact_pedname'] = "Scrapyard Worker", -- Scrapyard Worker's Name
    ['interact_scrapyardtutorial'] = "What can I do here?", -- Tutorial Button Interaction
    ['interact_scrapyardshop'] = "What do you have for sale?", -- Shop Button Interaction
    ['interact_getemailnotif'] = "Get Email Notifications", -- Email Notification Button Interaction
    ['interact_disableemailnotif'] = "Stop Email Notifications", -- Email Notification Button Interaction
    ['interact_usepowersaw'] = "Use your Power Saw to start scraping!", -- Appears when a player is close to wreckage (target disabled)
    ['interact_scrap'] = "Scrap", -- Scrap Target Interaction
    ['interact_take'] = "Take Box", -- Take Flight Box Interaction

    ['tutorial_title'] = "Scrapyard Tutorial", -- Tutorial Title
    ['tutorial_clicktocontinue'] = "Click to Continute", -- Tutorial Click to Continute
    ['tutorial_1'] = "Welcome to the Scrapyard! Here you can break down old scrap into useful materials!", -- Page 1
    ['tutorial_2'] = "Grab a power-saw and find the old scrap in the yard, break it down to gather the materials.", -- Page 2
    ['tutorial_3'] = "If your saw blade breaks, you can replace it with a new one from my shop!", -- Page 3
    ['tutorial_4'] = "Once in a while, we localize a crashed wreckage out in the world.", -- Page 4
    ['tutorial_5'] = "Scraping it down will give you better rewards! We can notify you when we find them if you want!", -- Page 5
    ['shop_label'] = "Scrapyard Shop", -- Shop Name
    ['shop_itemdescription'] = "Price : $%s | Stock : %s", -- Item Description (Price + Stock) | First %s --> Price, Second %s --> Stock
    ['shop_buyone'] = "Buy One", -- Buy 1
    ['shop_buy'] = "Buy", -- Buy (Many)
    ['shop_selectamount'] = "Chose Amount To Buy", -- Chose Amount
    ['shop_amount'] = "Amount", -- Amount
    ['shop_invalidAmount'] = "Please Chose a Valid Amount to Buy.", -- If selected Amount is invalid
    ['shop_notenoughstock'] = "We don't have enough to sell you that amount!", -- Not Enough Stock
    ['shop_notenoughmoney'] = "You don't have enough money to buy this!", -- Not Enough Money
    ['exit'] = "Exit", -- Exit
    ['goback'] = "Go Back" -- Go Back
}