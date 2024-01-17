--
-- Server-side event examples and functions which can be used if you need them for some custom development reasons.
--

-- Used to determine if a player can join a race. For example you can check for items/jobs here, if needed.
function isPlayerAllowedToJoinRace(playerId)
    --print('isPlayerAllowedToJoinRace')
    --print(playerId)
    return true
end

AddEventHandler('rahe-racing:server:playerJoinedRace', function(playerId)
    --print('rahe-racing:server:playerJoinedRace')
    --print(playerId)
end)

AddEventHandler('rahe-racing:server:newRaceCreated', function(startCoords, trackName, startTime, isCompetition)
    --print('rahe-racing:server:raceCreated')
    --print('startcoords: ', startCoords)
end)

AddEventHandler('rahe-racing:server:raceStarted', function(startCoords, participants)
    --print('rahe-racing:server:raceStarted')
    --print('startCoords: ', startCoords)
    --print('participants:')
    --print(DumpTable(participants))
end)

AddEventHandler('rahe-racing:server:raceFinished', function(raceData)
    --print('rahe-racing:server:raceFinished')
    --print('raceData:')
    --print(DumpTable(raceData))
end)