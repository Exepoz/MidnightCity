*********************************
*** NW_fishingGame by DemiGod ***
*********************************
discord: Demigod#0001

DM me or comment on the forum post with issues or suggestions

----------------------------------------------------------------------------------------------------------------------------------------

*************
** Install **
*************

1.) copy NW_fishingGame folder into your resources folder

2.) add "ensure NW_fishingGame" to your server.cfg


************
** How-To **
************

here is an example of how to add this to your scripts: 

--test command that will allow you to try the game. '/testfishinggame {difficulty}' difficulty will be "easy", "medium", or "hard"

RegisterCommand("testfishinggame", function(source,args,rawCommand) --remove this before putting in your live server. this is for testing purposes

    local success = exports["NW_fishingGame"]:fishingGameStart(args[1]) --will return true or false if the game is passed or not
    
    if success then
        --passed fishing game. reward fish here
        print("SUCCESS")
    else
        --failed fishing game do something else
        print("FAIL")
    end

end)


--if you want to cancel the game at any point you can call:

exports["NW_fishingGame"]:cancelGame() --this will close the game, but also count as a fail
