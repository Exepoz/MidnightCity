WebhookURL = "WEBHOOK" -- Webhook to send logs to discord

function beforeBuyLocation(source,user_id)
	-- Here you can do any verification when a player is opening the trucker UI for the first time, like if player has the permission or money to that or anything else you want to check. return true or false
	return true
end

function beforeBuyTruck(source,truck_name,price,user_id)
	-- Here you can do any verification when a player is buying a truck, like if player has driver license or anything else you want to check before buy the truck. return true or false
	return true
end

function afterBuyTruck(source,truck_name,price,user_id)
	-- Here you can run any code after the player buys a truck. Does not return anything
end

function beforeSellTruck(source,truck_name,price,user_id)
	-- Here you can do any verification when a player is selling a truck. return true or false
	return true
end

function afterSellTruck(source,truck_name,price,user_id)
	-- Here you can run any code after the player sells a truck. Does not return anything
end

function beforeHireDriver(source,price,user_id)
	-- Here you can do any verification when a player is hiring a driver. return true or false
	return true
end

function afterHireDriver(source,price,user_id)
	-- Here you can run any code after the player hires a driver. Does not return anything
end

function beforeStartContract(source,contract_id)
	-- Here you can do any verification when a player is starting a contract. return true or false
	return true
end

function afterfinishContract(source,received_amount,received_xp,distance)
	-- Here you can run any code when player finishes the job. Does not return anything
end

function beforeDepositMoney(source,amount,account)
	-- Here you can do any verification when a player is depositing money. return true or false
	return true
end

function beforeWithdrawMoney(source,amount,account)
	-- Here you can do any verification when a player is withdrawing money. return true or false
	return true
end