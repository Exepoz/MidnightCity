--
-- Client-side event examples and functions which can be used if you need them for some custom development reasons.
--

AddEventHandler('rahe-racing:client:checkpointPassed', function()
    --print('rahe-racing:client:checkpointPassed')
end)


-- Race joining
AddEventHandler('rahe-racing:client:startRaceJoinDisplay', function(raceInfo)
    --print('rahe-racing:client:startRaceJoinDisplay')
    --print(DumpTable(raceInfo))
end)

AddEventHandler('rahe-racing:client:stopRaceJoinDisplay', function(raceInfo)
    --print('rahe-racing:client:stopRaceJoinDisplay')
    --print(DumpTable(raceInfo))
end)

AddEventHandler('rahe-racing:client:updateRaceJoinDisplay', function(data)
    --print('rahe-racing:client:updateRaceDisplay')
    --print(DumpTable(data))
end)