# is-playerstyles

Persistent different styles for players.

## Features

- Supported Styles:
    - Walking Styles
    - Moods
- Persist across reboots / reconnects
- EMS revives
- Hospital Check-Ins
- fivem-appearance (/reloadskin)
- Crouch / Prone
- Supports adding custom events to re-apply styles
- No Loops!
- 0 resmon
- Open Source

## Preview

https://streamable.com/fdgdo9

![is-playerstyles](https://user-images.githubusercontent.com/104288623/171044997-af85b8a0-bb7d-458b-8a5c-7fcf633f4ee9.PNG)



## Commands

- /styles (Any player can use it)


## Persisting styles through radial menu

- Walking style events prefix: `is-playerstyles:client:SetWalkingStyle:`
- Mood events prefix: `is-playerstyles:client:SetMood:`

All events have the name of the style appended at the end. So if you want to trigger an event for the `Alien` walking style, you will use `is-playerstyles:client:SetWalkingStyle:Alien` event, or if you want to trigger it for `Casual` style, you will use `is-playerstyles:client:SetWalkingStyle:Casual` and so on. The Walking Style names can be found in shared/config.lua under `Config.WalkingStyles`. Here's how you could do it in radialmenu:

```lua
{
    id = 'walkingstyle-alien',
    title = 'Set Walking Style (Alien)',
    icon = 'address-book',
    type = 'client',
    event = 'is-playerstyles:client:SetWalkingStyle:Casual',
    shouldClose = true
}
```


## Exports

The resource exports the following functions

- SetWalkingStyle
- SetMood

You can use them in resource which resets these styles of the player

### fivem-appearance

In order to fully preserve the walking style while using fivem-appearance, you need to add this export inside of the `startPlayerCustomization` function at the end of it. This function can be found in `client/client.lua` of that resource. An example of how it would look like after the export:

```lua
function OpenShop(config, isPedMenu, shopType)
    QBCore.Functions.TriggerCallback("fivem-appearance:server:hasMoney", function(hasMoney, money)
        if not hasMoney and not isPedMenu then
            QBCore.Functions.Notify("Not enough cash. Need $" .. money, "error")
            return
        end

        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if appearance then
                if not isPedMenu then
                    TriggerServerEvent("fivem-appearance:server:chargeCustomer", shopType)
                end
                TriggerServerEvent('fivem-appearance:server:saveAppearance', appearance)
            else
                QBCore.Functions.Notify("Cancelled Customization")
            end
            exports['is-playerstyles']:SetWalkingStyle()
            exports['is-playerstyles']:SetMood()
        end, config)
    end, shopType)
end
```
