local currentText = ""
local function hideText()
    currentText = ''
    lib.hideTextUI()
    -- SendNUIMessage({
    --     action = 'HIDE_TEXT',
    -- })
end

local function drawText(text, position)
    if type(position) ~= 'string' then position = 'left-center' end
    if position == "left" then position = "lef-center" end
    if position ~= 'right-center' and position ~= 'left-center' and position ~= 'top-center' then
        QBCore.Debug('Draw text tried to set a custom position but the value is not valid. (Text : '..text.." | Position : "..position..")")
        position = 'left-center'
    end
    lib.showTextUI(text, {
        position = position,
        --icon = 'flask-vial',
        -- style = {
        --     background = "linear-gradient(45deg, rgb(39, 199, 247), 10%, rgb(105, 105, 105), 85%, rgba(39, 199, 247))",
        --     color = "#FFFFFF",
        --     border = "2px solid rgb(0, 195, 255)",
        --     boxShadow = "rgba(39, 199, 247, 0.527) 0px 0px 3px 3px, rgba(39, 199, 247, 0.527) 0px 0px 3px 3px",
        --     borderRadius = "25px",
        -- }
    })
    -- SendNUIMessage({
    --     action = 'DRAW_TEXT',
    --     data = {
    --         text = text,
    --         position = position
    --     }
    -- })
end

local function changeText(text, position)
    if text == "" or text == currentText then hideText() return end
    text = currentText

    -- if type(position) ~= 'string' then position = 'left' end
    if type(position) ~= 'string' then position = 'left-center' end
    if position == "left" then position = "lef-center" end
    if position ~= 'right-center' and position ~= 'left-center' and position ~= 'top-center' then
        QBCore.Debug('Draw text tried to set a custom position but the value is not valid. (Text : '..text.." | Position : "..position..")")
        position = 'left-center'
    end
    lib.showTextUI(text, {
        position = position,
        --icon = 'flask-vial',
        -- style = {
        --     background = "linear-gradient(45deg, rgb(39, 199, 247), 10%, rgb(105, 105, 105), 85%, rgba(39, 199, 247))",
        --     color = "#FFFFFF",
        --     border = "2px solid rgb(0, 195, 255)",
        --     boxShadow = "rgba(39, 199, 247, 0.527) 0px 0px 3px 3px, rgba(39, 199, 247, 0.527) 0px 0px 3px 3px",
        --     borderRadius = "25px",
        -- }
    })

    -- SendNUIMessage({
    --     action = 'CHANGE_TEXT',
    --     data = {
    --         text = text,
    --         position = position
    --     }
    -- })
end

local function keyPressed()
    CreateThread(function() -- Not sure if a thread is needed but why not eh?
        -- SendNUIMessage({
        --     action = 'KEY_PRESSED',
        -- })
        Wait(500)
        hideText()
    end)
end

RegisterNetEvent('qb-core:client:DrawText', function(text, position)
    drawText(text, position)
end)

RegisterNetEvent('qb-core:client:ChangeText', function(text, position)
    changeText(text, position)
end)

RegisterNetEvent('qb-core:client:HideText', function()
    hideText()
end)

RegisterNetEvent('qb-core:client:KeyPressed', function()
    keyPressed()
end)

exports('DrawText', drawText)
exports('ChangeText', changeText)
exports('HideText', hideText)
exports('KeyPressed', keyPressed)
