Config = Config or {}

--- STARTER PED STUFF HERE
Config.PedModel = `a_m_y_indian_01`
Config.PedLocation = vector4(-582.12, 243.54, 74.89, 224.18)
--- END OF STARTER PED STUFF

Config.Dispatch = 'ps-dispatch'  -- ps-dispatch / cd-dispatch  (type of dispatch you use)
Config.AlertChance = 75 --25% chance
Config.CoolDown = 600000 -- Cooldown to do deliveries
Config.Notifications = 'phone' -- phone/qbcore (type of notifications to use on the job)
Config.CopsNeeded = 0
Config.BuyerTimer = 1000 * 8 -- Timer till the buyer spawns default 1-3 minutes

Config.PedDrivingStyle = 786603 -- suggest not changing this tbh
Config.PedDrivingSpeed = 10.0
Config.Packages = 3 -- amount of packages you recieve to deliver

--- REWARD STUFF HERE
Config.UseStartPayment = 'true' -- true/false if you want to use a start payment or not
Config.OxyStartPayment = 1500 -- amount to pay to start if the config is set to true
Config.OxyPackageName = 'oxypackage' -- name of the box package in your shared
Config.CashPay = math.random(350,550) -- amount you recieve on each handoff
Config.ItemName = 'oxy' -- oxy item name in your shared
Config.OxyAmount = math.random(4,5) -- amount of oxy you get if the chance is hit
Config.ItemChance = 75 -- chance to get oxy
Config.RareItem = {
    'advancedlockpick',
    'lockpick',
    --'vpn',
}
Config.RareItemAmount = math.random(1,4) -- Amount of the rare item you reacieve
Config.RareItemChance = 20 -- 10% chance to get rareitem
--- END OF REWARD STUFF

--- BLIPS STUFF
Config.OxySupplierBlip = 51 -- Blip that is shown where to pickup packages more blips can be found here if you want to change: https://docs.fivem.net/docs/game-references/blips/
Config.OxySupplierBlipScale = 0.60 -- Scale of the blip
Config.OxySupplierBlipRouteColor = 11 -- This is the color or the marking that shows from your location to the location
Config.UseGpsRoute = true -- true/false to turn of the route markings and only show blips

Config.OxyDropBlip = 103
Config.OxyDropBlipScale = 0.65
Config.OxyBlipsColor = 11 -- Color of the all blips oxy
--- END OF BLIP STUFF

--- PED STUFF (FOR COLLECTION OF BOXES BEFORE DELIVERY)
Config.PickUpLocations = {
    vector4(608.79, -459.17, 24.74, 181.92),
    vector4(1250.83, -2562.04, 42.71, 219.28),
    vector4(740.43, -2634.68, 6.47, 189.84),
    vector4(-1161.83, -1250.07, 6.8, 306.16),
    vector4(-2223.13, -365.75, 13.32, 260.99),
    vector4(-2982.84, 1585.71, 23.82, 359.91),
    vector4(-287.47, 2535.68, 75.47, 271.17),
    vector4(1583.08, 3620.96, 38.78, 134.18)
}

Config.SupplierPeds = {
    `a_m_y_skater_01`,
    `a_m_y_vinewood_03`,
    `a_m_y_soucent_02`,
    `a_m_y_soucent_03`,
    `a_m_y_methhead_01`,
    `a_m_m_eastsa_01`,
    `a_m_m_genfat_01`,
    `a_m_m_mexlabor_01`,
}
--- END OF PED STUFF


--- DELIVER STUFF HERE
Config.OxyLocations = {
    [1] = {
        Location = vector4(-219.29, -1491.82, 30.63, 137.46), -- Location of the drop off
        CarSpawn = vector4(-30.65, -1387.69, 29.36, 2.05), -- where the buyer car spawns
        Peds = { -- peds that will be driving the cars 
            `csb_ballasog`,
            `g_m_y_ballasout_01`,
            `g_m_y_ballaeast_01`,
            `g_m_y_ballaorig_01`,
        },
        Vehicles = { -- vehicles the peds will be driving added this so you can have certain peds and vehicles spawn in certain areas if you want
            `chino2`,
            `blade`,
            `clique`,
            `faction2`,
        },
    },
    [2] = {
        Location = vector4(-145.99, -2138.53, 16.07, 19.86),
        CarSpawn = vector4(-391.22, -2164.19, 10.32, 10.24),
        Peds = {
            `csb_ballasog`,
            `g_m_y_ballasout_01`,
            `g_m_y_ballaeast_01`,
            `g_m_y_ballaorig_01`,
        },
        Vehicles = {
            `chino2`,
            `blade`,
            `clique`,
            `faction2`,
        },
    },
    [3] = {
        Location = vector4(218.27, -164.76, 56.13, 70.18),
        CarSpawn = vector4(285.94, -11.06, 77.53, 250.84),
        Peds = {
            `csb_ballasog`,
            `g_m_y_ballasout_01`,
            `g_m_y_ballaeast_01`,
            `g_m_y_ballaorig_01`,
        },
        Vehicles = {
            `chino2`,
            `blade`,
            `clique`,
            `faction2`,
        },
    },
    [4] = {
        Location = vector4(-746.17, 373.17, 87.24, 0.37),
        CarSpawn = vector4(-903.58, 411.88, 83.83, 284.18),
        Peds = {
            `csb_ballasog`,
            `g_m_y_ballasout_01`,
            `g_m_y_ballaeast_01`,
            `g_m_y_ballaorig_01`,
        },
        Vehicles = {
            `chino2`,
            `blade`,
            `clique`,
            `faction2`,
        },
    },
    [5] = {
        Location = vector4(684.87, 238.04, 93.07, 57.68),
        CarSpawn = vector4(629.77, 249.05, 103.09, 65.03),
        Peds = {
            `csb_ballasog`,
            `g_m_y_ballasout_01`,
            `g_m_y_ballaeast_01`,
            `g_m_y_ballaorig_01`,
        },
        Vehicles = {
            `chino2`,
            `blade`,
            `clique`,
            `faction2`,
        },
    },
}
--- END OF DELIVERY STUFF