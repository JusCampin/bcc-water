Config = {

    defaultlang = 'en_lang',
    ---------------------------------------------------------------

    devMode = {
        active  = false,      -- When active, you can restart the script while connected for testing (otherwise requires relog)
        command = 'WaterDev', -- Command to start the script functions
    },
    ---------------------------------------------------------------

    -- Vorp Metabolism              = 1
    -- Fred Metabolism Free         = 2
    -- Outsider Needs               = 3
    -- Fred Metabolism Paid v1.4    = 4
    -- Fred Metabolism Paid v2      = 5
    -- RSD Metabolism               = 6
    -- NXT Metabolism               = 7
    -- Andrade Metabolism           = 8
    -- FX-HUD                       = 9
    -- Mega Metabolism              = 10
    -- POS-Metabolism               = 11
    -- BLN HUD                      = 12
    -- SS-Metabolism                = 13
    -- bcc-corehud                  = 14
    -- cas-metabolism               = 15
    app = 1,
    ---------------------------------------------------------------

    keys = {
        drink       = { code = 0x760A9C6F, char = 'G' }, -- Drink at Water Pumps and Wild Waters
        wash        = { code = 0x80F28E95, char = 'L' }, -- Wash Player at Water Pumps and Wild Waters
        fillBucket  = { code = 0xCEFD9220, char = 'E' }, -- Fill Bucket at Water Pumps and Wild Waters
        fillBottle  = { code = 0xD3ECF82F, char = 'B' }, -- Fill Bottle at Water Pumps and Wild Waters
        fillCanteen = { code = 0x27D1C284, char = 'R' }  -- Fill Canteen at Water Pumps and Wild Waters
    },
    ---------------------------------------------------------------

    -- Manage Activities at Water Pumps and Other Objects
    pump = {
        active  = true,       -- Enable the Use of Water Pumps and Other Objects
        canteen = true,       -- Allow to Fill Canteen
        bucket  = true,       -- Allow to Fill Bucket
        bottle  = true,       -- Allow to Fill Bottle
        wash    = true,       -- Allow Player to Wash
        drink   = true,       -- Allow Player to Drink
        multi   = {
            bottles = true,   -- Allow to Fill Multiple Bottles at Once
            bottleAmount = 5, -- Maximum Amount of Bottles to Fill at Once
            buckets = true,   -- Allow to Fill Multiple Buckets at Once
            bucketAmount = 5  -- Maximum Amount of Buckets to Fill at Once
        }
    },
    ---------------------------------------------------------------

    -- Manage Activities in Rivers and Lakes (Wild Waters)
    wild = {
        active  = true,       -- Enable the Use of Wild Waters
        canteen = true,       -- Allow to Fill Canteen
        bucket  = true,       -- Allow to Fill Bucket
        bottle  = true,       -- Allow to Fill Bottle
        wash    = true,       -- Allow Player to Wash
        drink   = true,       -- Allow Player to Drink
        multi   = {
            bottles = true,   -- Allow to Fill Multiple Bottles at Once
            bottleAmount = 5, -- Maximum Amount of Bottles to Fill at Once
            buckets = true,   -- Allow to Fill Multiple Buckets at Once
            bucketAmount = 5  -- Maximum Amount of Buckets to Fill at Once
        }
    },
    ---------------------------------------------------------------

    -- Sickness from Drinking Wild Water (Player Dies if Duration or Health Reaches 0)
    sickness = {
        chance   = 25,  -- Range 1 - 100 (lower Number = lower Chance) / Set to 0 to Disable
        duration = 600, -- Default: 600 / Death Timer in Seconds 
        interval = 15,  -- Default: 15 / Time in Seconds Between each Health Loss
        health   = 50,  -- Default: 50 / Health lost per Interval
    },
    ---------------------------------------------------------------

    -- Automatically seed the items table on resource start
    autoSeedDatabase = true,

    -- Item Names from Database
    canteen      = 'canteen',

    emptyBucket  = 'wateringcan_empty',
    cleanBucket  = 'wateringcan',
    dirtyBucket  = 'wateringcan_dirtywater',

    emptyBottle  = 'bcc_empty_bottle',
    cleanBottle  = 'bcc_clean_bottle',
    dirtyBottle  = 'bcc_dirty_bottle',

    antidoteItem = 'antidote', -- Item name that cures sickness
    ---------------------------------------------------------------

    -- Soap Item Configuration
    soapItem = {
        'bcc_soap_bar',    -- Basic soap bar
        --'perfumed_soap',   -- Perfumed soap
    },
    requireSoap = false,       -- Set to true to require soap for washing
    consumeSoap = true,        -- Set to false to make soap reusable (not consumed on use)
    soapUses = 10,             -- Number of uses before soap item is removed (when consumeSoap is true)
    ---------------------------------------------------------------

    durability = {
        canteen = 5, -- Durability used per Drink
    },
    ---------------------------------------------------------------

    -- Register Items as Useable
    useable = {
        cleanBottle  = true,
        dirtyBottle  = true,
        antidoteItem = true,
    },
    ---------------------------------------------------------------

    -- Objects Where You Can Get Water
    objects = {
        'p_waterpump01x',
        'p_wellpumpnbx01x',
        'p_sink02x',
        'p_drysink01x',
        'p_sink03x',
        'p_barrel_ladle01x',
        'p_barrel_wash01x',
    },
    ---------------------------------------------------------------

    -- Boosts Drinking from Canteen
    canteenDrink = {
        health  = 10, -- Default: 10 / Value is 0 - 100 / Set to 0 to Disable
        stamina = 20, -- Default: 20 / Value is 0 - 100 / Set to 0 to Disable
        thirst  = 50  -- Default: 50 / Value is 0 - 100
    },

    -- Effects Drinking from Wild Waters
    wildDrink = {
        gainHealth  = true, -- true = Gain Health by health Value / false = Lose by Value
        health      = 5,    -- Default: 5 / Value is 0 - 100 / Set to 0 to Disable
        gainStamina = true, -- true = Gain Stamina by stamina Value / false = Lose by Value
        stamina     = 10,   -- Default: 10 / Value is 0 - 100 / Set to 0 to Disable
        thirst      = 25    -- Default: 25 / Value is 0 - 100
    },
    ---------------------------------------------------------------

    maxCanteenDrinks = 5, -- Maximum Drinks per Full Canteen
    ---------------------------------------------------------------

    -- Crouch in Wild Water to Show Prompts
    crouch = true, -- Default: true / Set to false to Remove Crouch Requirement
    ---------------------------------------------------------------

    usePrompt = true, -- true = Show Prompt Button at Water Pumps / false = Show Text at Water Pumps (no button)
    ---------------------------------------------------------------

    showMessages = true, -- Show / Hide Canteen Messages
    ---------------------------------------------------------------
}
