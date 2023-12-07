CRMethRunLocales = {
    ['interact_TalkTo'] = "Talk with Damien",
    ['interact_StartRun'] = "Start Run",
    ['interact_Payment'] = "Collect Payment",
    ['interact_GetPackage'] = "Get Package",
    ['interact_DeliverGoods'] = "Deliver Goods",

    ['email_Sender'] = "Johnny's Distribution",
    ['email_subject_VehicleLocated'] = "Vehicle Located",
    ['email_message_VehicleLocated'] = "Hello!<br><br>The vehicle you need to collect is a <b>%s</b><br>The license plate is <b>%s</b><br><br>The position of the vehicle is marked on your GPS.",
    ['email_subject_PackageReady'] = "Package Ready for Shipping",
    ['email_message_PackageReady'] =  "Hello!<br><br><b>Your package is ready!</b><br><br>We have prepared your product, come pick it up.",
    ['email_subject_DeliveryInProgress'] = "Delivery In Progress",
    ['email_message_DeliveryInProgress'] = "Hello!<br><br><b>You\'re on the map!</b><br><br>We've notified our clients and we'll send you the location to drop off the stuff as soon as someone is interested in your product.",

    ['blip_StolenVehicle'] = "Stolen Vehicle",

    ["notif_MethRunTitle"] = "Meth Run",
    ["notif_CooldownMessage"] = "We do not need any product at the moment", -- Starting Ped | Runs are on cooldown
    ["notif_NotEnoughCops"] = "There's not enough Cops around!",
    ["notif_MissingMeth"] = "You don't have any big meth batches on you...", -- Starting Ped | Don't have meth
    ["notif_NotEnoughMeth"] = "You don't have enough meth...", -- Starting Ped | Don't have enough meth
    ["notif_GoodsGiven"] = "Alright that\'s all the meth", -- Starting Ped | Gave all the meth
    ["notif_StartRunInfoMessage"] = "We\'ve located a car for you, we\'ll send you the location for it soon.", -- Starting Ped | Run Started

    ["notif_GPSUpdate"] = "Your GPS has been upated with recent information", -- GPS Updating
    ["notif_EmailSent"] = "You received an email with the car information", -- Receiving Email

    ["notif_ReceiveGoods"] = "Here\'s some of it, I got more so don't leave yet!", -- Goods Ped | Picked up goods
    ["notif_ReceivedAllGoods"] = "Here\'s everything, get back in the car and wait for an email.", -- Goods Ped | Picked up all the goods
    ["notif_NothingLeft"] = "There's nothing left, get back in the car and leave, you\'ll get an email soon.", -- Goods Ped | Nothing to give to the player
    ["notif_MissingCar"] = "Where is your car?", -- Goods Ped | Car is too far

    ["notif_DropOffLocated"] = "We\'ve located the drop off location!", -- Drop Off | Drop Off Location Sent
    ["notif_DropOffTooFar"] = "You\'re too far from the Drop Off Location!", -- Drop Off | Droff off too far
    ["notif_TrunkTooFar"] = "You\'re too far from the trunk!", -- Drop Off | Player too far from the car trunk
    ["notif_DropOffSuccess"] = "You dropped off the goods, leave the car there and go back to the negotiator to get your payment!", -- Drop Off | Goods droped off.
    ["notif_GettingTooFar"] = "Bring back the vehicle, the goods are inside!", -- Drop Off | Car leaving drop off area (After drop)
    ["notif_TooFar"] = "You're trying to scam us? The deal is off.", -- Drop Off | Car too far from drop off (Cancels run) (After drop)
    ["notif_Useless"] = "This is now useless", -- Drop Off | Trying to drop off goods after run ended/reset/failed

    ["notif_NothingForYou"] = "I don't have anything for you, bring me the stuff and we'll get started.", -- Starting Ped | There's no payment to collect
    ["notif_EndRun"] = "Here is your payment, come back when you have more to distribute.", -- Starting Ped | Collecting payment / Finishing Run

    ['progbar_Negotiate'] = "Negotiating...",
    ['progbar_Delivering'] = "Delivering Package...",
    ['progbar_CollectingPackage'] = "Collecting Package...",
}