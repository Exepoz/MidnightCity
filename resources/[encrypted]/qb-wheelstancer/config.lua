-------------------------------
------- Core CONFIG
-------------------------------

Config                      = {}
Menu                        = {}
Config.Core                 = {
  gettingObjectName = "GetCoreObject", -- the event name / export name for getting the core object.
  core_resource_name = "qb-core"       -- the core resource name.
}
Config.Locale               = 'en'     -- Language.
Config.SharedVehicleStancer = false    -- Only set this to [true] if you are using Nopixel Garages to Fetch stance values from shared_vehicles table !



-------------------------------
------- Webhooks Logs
-------------------------------
Config.EnableWebhooks      = false

Config.Webhooks            = {

  WebhookURL = '',                       -- Make Sure You Put Your Webhook Here

  HeaderImageURL = 'YOUR_IMAGE_LINK',    -- If you Want Image Header For The Logs insert The URL

  LogHeader = 'QBCore WheelStancer Log', -- What Will be the Header Of Your logs

  SubHeading = 'Player Info Who Used Stancer',

  EmbedColor = 'red', -- Choose from qb-wheelstance/server/sv-whebhook.lua
}

-------------------------------
------- TEXT CONFIG
-------------------------------

-- Menu Text Customization

Menu.heading               = "LS Customs"
Menu.subheading            = "Adjust Wheel Stance"

-- SubMenu Text Customization

Menu.AllWheelsWidth        = "All Wheels Width"
Menu.AllWheelsSize         = "All Wheels Size"
Menu.SuspensionHeight      = "Suspension Height"
Menu.WheelFrontLeftOffset  = "Wheel Front Left Offset"
Menu.WheelFrontRightOffset = "Wheel Front Right Offset"
Menu.WheelRearLeftOffset   = "Wheel Rear Left Offset"
Menu.WheelRearRightOffset  = "Wheel Rear Right Offset"
Menu.WheelFrontLeftCamber  = "Wheel Front Left Camber"
Menu.WheelFrontRightCamber = "Wheel Front Right Camber"
Menu.WheelRearLeftCamber   = "Wheel Rear Left Camber"
Menu.WheelRearRightCamber  = "Wheel Rear Right Camber"

-- Exit Menu Text Customization

Menu.exitConfirmation      = "Confirm Exit"
Menu.HeadingSaveChanges    = "Save Changes?"

Menu.GoBack                = "Go Back"
Menu.SubHeadingSaveChanges = "Save Changes"

-- Marker Customization

Config.Drawmarker          = true -- true/false to View or Hide the Marker
Config.Draw3DText          = true -- true/false to View or Hide the 3D Text

Config.MarkerText          = "[E]- To Open Stance Menu"
Config.SetTextFont         = 4  -- Ranges from 0 to 7
Config.MarkerType          = 20 -- Vsist this Site to Change Marker Types [https://docs.fivem.net/docs/game-references/markers/]

-- Visit this site to Get your Color Red,Green,Blue,Alpha Values  [https://rgbacolorpicker.com/]

Config.red                 = 255  -- Red Color
Config.green               = 255  -- Green Color
Config.blue                = 252  -- Blue Color
Config.alpha               = 0.8  -- Alpha Color
Config.MarkerUpAndDown     = true -- Marker Up and Down Animation
Config.MarkerRotate        = true -- Marker Rotation Animation


Config.MenuOpenKey = 38 -- Key To Open Stance Menu, Visit here: https://docs.fivem.net/docs/game-references/controls/


-------------------------------
------- POLYZONE CONFIG
-------------------------------

Config.Polyzone            = {
  -- //Gabz Los Santos TunerShop Location//
  {
    data    = { id = "1" },
    coords  = vector3(-333.12, -133.05, 39.01),
    length  = 3.0,
    width   = 5.0,
    minZ    = 36.04,
    maxZ    = 39.84,
    heading = 250.0,
  },
  --=================================================
  -- // Hayes Autos Location 1
  --{
  --  data    = { id = "2" },
  --  coords  = vector3(-1423.64, -450.21, 35.19),
  --  length  = 5.0,
  --  width   = 3.0,
  --  minZ    = 32.79,
  --  maxZ    = 36.79,
  --  heading = 31.32,
  --},
  --=================================================
  -- // Hayes Autos Location 2
  --{
  --  data    = { id = "3" },
  --  coords  = vector3(-1417.08, -446.44, 35.56),
  --  length  = 5.0,
  --  width   = 3.0,
  --  minZ    = 33.36,
  --  maxZ    = 37.36,
  --  heading = 30.78,
  --},
  --=================================================
  -- // Default Bennys Workshop Location
  --{
  --  data    = { id = "4" },
  --  coords  = vector3(-222.65, -1329.33, 30.54),
  --  length  = 5.0,
  --  width   = 3.0,
  --  minZ    = 28.14,
  --  maxZ    = 32.14,
  --  heading = 268.87,
  --},
  --=================================================
  -- //Gabz MRPD Police Station Location//
  --{
  --  data    = { id = "5" },
  --  coords  = vector3(435.41, -975.99, 25.7),
  --  length  = 5.0,
  --  width   = 3.0,
  --  minZ    = 24.5,
  --  maxZ    = 27.1,
  --  heading = 89.03,
  --},
  --=================================================
  -- //AutoCare Mechanic Location//
  --{
  --  data    = { id = "6" },
  --  coords  = vector3(-324.21, -138.46, 39.01),
  --  length  = 5.0,
  --  width   = 3.0,
  --  minZ    = 36.01,
  --  maxZ    = 40.01,
  --  heading = 69.44,
  --},
  --=================================================
  -- /*-*/ Add More Below /*-*/





}

-------------------------------
------- WHEELZONE CONFIG
-------------------------------

Config.Blips               = {
  Sprite = 545,
  Display = 4,
  Scale = 0.7,
  Colour = 26,
  Name = "Stance Station"
}

Config.WheelZones          = {
  --=================================================
  -- Gabz Los Santos TunerShop Location
  ["wheel:zone1"] = {
    coords      = vector3(-333.12, -133.05, 39.01),
    heading     = 340.0,
    jobRequired = true,
    jobs        = {
      { name = "lscustoms", grades = { 1, 2, 3, 4 } },
      { name = "tuner",    grades = { 1, 2, 3, 4 } },
    },
    blips       = false,
    price       = 100
  },
  --=================================================
  
  -- /*-*/ Add More Below /*-*/







}

-------------------------------
------- MENU PARAMETER CONFIG
-------------------------------

config                     = {
  maxLimits = {
    fl = 1.0,
    fr = 1.0,
    rl = 1.0,
    rr = 1.0,
    flro = 0.5,
    frro = 0.15,
    rlro = 1.0,
    rrro = 0.15,
    size = 1.3,
    susp = 1.0,
    width = 1.5
  },
  minLimits = {
    fl = -1.0,
    fr = -1.0,
    rl = -1.0,
    rr = -1.0,
    flro = -0.15,
    frro = -1.0,
    rlro = -0.15,
    rrro = -1.0,
    size = 0.0,
    susp = -0.2,
    width = 0.0
  }
}

-------------------------------
------- BLACKLIST CONFIG
-------------------------------

-- Blacklist Vehicle by Spawn Name !

Config.BlacklistedVehicles = {

  -- Add vehicle spawn name to Blacklist them from usign the Stance Menu !
  "bmx",
  "faggio",
  "ruffian",
  "akuma",
  "sanchez",
  "bati",
  "hakuchou",
  "pcj",
  "hexer",
  "enduro",
  "bf400",
  "zombiea",
  "zombieb",
  "fcr",
  "nightblade",
  "cliffhanger",
  "esskey",
  "nemesis",
  "chimera",
  "bobber",

}


Config.debugPoly = false  -- Set to [True/False] to Show Created Zones
Config_RefreshTime = 1000 -- Dont Touch Unless you know what you are Doing!
