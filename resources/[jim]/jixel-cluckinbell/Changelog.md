﻿## Changelog
- v 1.0.0
  - Release  

- v 1.0.1
  - Minor Bug fixes - fixed spelling errors in items
  - Fixed autoclock in and out

- v 2.0
  - Seperated out `install.md` and moved into `README` folder
    - `customanims.md`
    - `items.md`
    - `jimconsumables.md`
  - Moved images folder into `README` folder
  - The install.md has been moved into the `README` folder
  - Install guide has been updated
  - Complete refactor of the code
  - Easier to add location dynamically
  - Organized config and Organized Locations seperately
  - Removed internal support for garages and booths
  - Added the exports for jim-jobgarages and jim-booths
  - Added custom Menu feature via img link
  - Added new Toy Feature by rarity
  - Added Ox Lib, Ox Inv, Ox Target functionality
  - Added support for Jixel Notify (coming soon)
- v 2.0.1
- forgot to switch a server side event to jixel-cluckinbell:client:consume
  
v 2.0.2
- ConsumeSuccess function added `client\client.lua`
-- This should address any ox_inv \ qb-core hybrid issues when it comes to Consumeables
- Added Consumeable hunger/thirst item info server side server/server.lua
- You'll have to remove all hunger/thirst from your items.lua/ ox_inv/data/items (or at least specifically the items you're calling for this script)
