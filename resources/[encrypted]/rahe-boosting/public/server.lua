function generateLicensePlate()
    local sectionLength = 4
    local availableCharacters, availableNumbers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', '0123456789'

    local randomPlate = ''

    for _ = 1, sectionLength do
        local rand = math.random(#availableNumbers)
        randomPlate = randomPlate .. string.sub(availableNumbers, rand, rand)
    end

    for _ = 1, sectionLength do
        local rand = math.random(#availableCharacters)
        randomPlate = randomPlate .. string.sub(availableCharacters, rand, rand)
    end

    return randomPlate
end

function deleteDropOffVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end