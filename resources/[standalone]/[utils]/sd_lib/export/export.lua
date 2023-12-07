exports("getLib", function()
    return SD
end)

if GetResourceState(Config.CoreNames.QBCore) == 'started' then Framework = 'qb' SD.Framework = 'qb' elseif GetResourceState(Config.CoreNames.ESX) == 'started' then Framework = 'esx' SD.Framework = 'esx' end
invState = GetResourceState(Config.InvName.OX)