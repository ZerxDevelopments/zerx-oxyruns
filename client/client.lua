local QBCore = exports['qb-core']:GetCoreObject()

local data = {}
local CurrentCops = 0
local SupplierSpawned = false
local OnDelivery = false
local GotPackages = false
local PackagesCollected = 0
local DeliveredPackages = 0
local InZone = false
local NoPackage = false
local DropZone
local StartZone
local HasBox = false
local prop = nil

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

CreateThread(function()
    QBCore.Functions.LoadModel(Config.PedModel)
    local jobped = CreatePed(0, Config.PedModel, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1.0, Config.PedLocation.w, false, false)
    TaskStartScenarioInPlace(jobped, 'WORLD_HUMAN_CLIPBOARD', true)
    FreezeEntityPosition(jobped, true)
    SetEntityInvincible(jobped, true)
    SetBlockingOfNonTemporaryEvents(jobped, true)

    exports.interact:AddLocalEntityInteraction({
        entity = jobped,
        distance = 2.0,
        interactDst = 2.0,
        options = {
            {
                icon = 'fas fa-circle',
                label = 'Wanna Do Oxy Run?',
                canInteract = function()
                    if not OnDelivery then return true end
                    return false
                end,
                action = function()
                    TriggerEvent('zerx-oxyruns:initiate')
                end,
            }
        }
    })
end)

RegisterNetEvent('zerx-oxyruns:initiate', function ()
    if CurrentCops >= Config.CopsNeeded then
        TriggerEvent('animations:client:EmoteCommandStart', {"clipboard"})
        QBCore.Functions.Progressbar("start_delivery", 'Getting Information', 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {
        }, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            if Config.UseStartPayment == 'true' then
                QBCore.Functions.TriggerCallback("zerx-oxyruns:Haspayment",function(money)
                    if money then
                        TriggerEvent('zerx-oxyruns:OxyStart')
                    end
                end)
            elseif Config.UseStartPayment == 'false' then
                TriggerEvent('zerx-oxyruns:OxyStart')
            end
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify("Cancelled", 'error')
        end,"fas fa-boxes-stacked")
    else
        if Config.Notifications == 'phone' then
            TriggerEvent('qb-phone:client:notify', 'NOTIFICATION', 'No deliveries available at this time', 'fas fa-bars', '#86F9A1', 4000)
            TriggerEvent('qb-phone:server:notify', 'NOTIFICATION', 'No deliveries available at this time', 'fas fa-bars', '#86F9A1', 4000)
        elseif Config.Notifications == 'qbcore' then
            QBCore.Functions.Notify('No deliveries available at this time', 'error')
        end
    end
end)

RegisterNetEvent('zerx-oxyruns:OxyStart', function ()
    if Config.Notifications == 'phone' then
        TriggerEvent('qb-phone:client:CustomNotification', 'NOTIFICATION', 'Meet With supplier and collect packages', 'fas fa-bars', '#86F9A1', 4000)
    elseif Config.Notifications == 'qbcore' then
        QBCore.Functions.Notify('Meet With supplier and collect packages', 'primary')
    end
    TriggerServerEvent('qb-logs:server:createLog', 'oxyruns', 'Player Started Oxyrun', "", src)
    loc = Config.PickUpLocations[math.random(#Config.PickUpLocations)]
    SupBlip = AddBlipForCoord(loc.x, loc.y, loc.z)

    SetBlipSprite(SupBlip, Config.OxySupplierBlip)
    SetBlipColour(SupBlip, Config.OxyBlipsColor)
    SetBlipScale(SupBlip, Config.OxySupplierBlipScale)
    SetBlipRoute(SupBlip, Config.UseGpsRoute)
    SetBlipRouteColour(SupBlip, Config.OxySupplierBlipRouteColor)

    StartZone = BoxZone:Create(vector3(loc.x, loc.y, loc.z), 65.5, 65.5, {
        heading = loc.w,
        name = 'Meet Location',
        debugPoly = false,
        -- minZ = 53.64,
        -- maxZ = 56.24
    })
    StartZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            if not GotPackages and not SupplierSpawned then
                SpawnSupplier()
            end
        end
    end)
end)

function SpawnSupplier()
    local SupplierHash = Config.SupplierPeds[math.random(#Config.SupplierPeds)]
    QBCore.Functions.LoadModel(SupplierHash)
    Supplier = CreatePed(0, SupplierHash, loc.x, loc.y, loc.z - 1.0, loc.w, true, true)
    pedprop = CreateObject(`prop_cs_cardbox_01`, 0, 0, 0, true, true, true)
    FreezeEntityPosition(Supplier, true)
    SetEntityInvincible(Supplier, true)
    AttachEntityToEntity(pedprop, Supplier, GetPedBoneIndex(Supplier, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 0, true)
    LoadAnim('anim@heists@box_carry@')
    TaskPlayAnim(Supplier, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    SupplierSpawned = true
    OnDelivery = true

    exports.interact:AddInteraction({
        coords = vector3(loc.x, loc.y, loc.z - 0.2),
        name = "zerx-takeoxypackages",
        distance = 2.0,
        interactDst = 2.0,
        options = {
            {
                label = "Take Packages",
                event = "zerx-oxyruns:collect"
            }
        }
    })
end

function Collect()
    RecievedPackages = Config.Packages
    PackagesCollected = PackagesCollected +1

    if Config.Notifications == 'phone' then
        TriggerEvent('qb-phone:client:CustomNotification', 'NOTIFICATION', PackagesCollected..' / '..RecievedPackages..' Collected Packages.', 'fas fa-bars', '#86F9A1', 4000)
    elseif Config.Notifications == 'qbcore' then
        QBCore.Functions.Notify(PackagesCollected..' / '..RecievedPackages..' Collected Packages.', 'primary')
    end

    TriggerServerEvent('zerx-oxyruns:giveoxypackages')
    if PackagesCollected == RecievedPackages then
        StartZone:destroy()
        RemoveBlip(SupBlip)
        GotPackages = true
        DeleteEntity(pedprop)
        ClearPedTasks(Supplier)
        Wait(500)
        SetPedAsNoLongerNeeded(Supplier)
        GetLocation()
    end
end

function GetLocation()
    if not NoPackage then
        data = Config.OxyLocations[math.random(#Config.OxyLocations)]
        DropBlip = AddBlipForCoord(data.Location)
        SetBlipSprite(DropBlip, Config.OxyDropBlip)
        SetBlipColour(DropBlip, Config.OxyBlipsColor)
        SetBlipScale(DropBlip, Config.OxyDropBlipScale)
        SetBlipRoute(DropBlip, Config.UseGpsRoute)
        SetBlipRouteColour(DropBlip, Config.OxyBlipsColor)

        if Config.Notifications == 'phone' then
            TriggerEvent('qb-phone:client:CustomNotification', 'NOTIFICATION', 'Go to the area on the gps to sell package', 'fas fa-bars', '#86F9A1', 4000)
        elseif Config.Notifications == 'qbcore' then
            QBCore.Functions.Notify('Go to the area on the gps to sell package', 'primary')
        end

        DropZone = BoxZone:Create(vector3(data.Location.x, data.Location.y, data.Location.z), 25.5, 25.5, {
            heading = data.Location.w,
            name = 'Drop Location',
            debugPoly = false,
            -- minZ = 53.64,
            -- maxZ = 56.24
        })
        DropZone:onPlayerInOut(function(isPointInside)
            print(isPointInside, GotPackages, BuyerSpawned)
            if isPointInside then
                if GotPackages and not BuyerSpawned then
                    InZone = true
                    SpawnBuyers()
                end
            else
                InZone = false
            end
        end)
    end
end



function SpawnBuyers()
    if Config.Notifications == 'phone' then
        TriggerEvent('qb-phone:client:CustomNotification', 'NOTIFICATION', 'Buyers have been notified...now you wait.', 'fas fa-bars', '#86F9A1', 4000)
    elseif Config.Notifications == 'qbcore' then
        QBCore.Functions.Notify('Buyers have been notified...now you wait.', 'primary')
    end
    TriggerEvent("qb-dispatch:oxyruns")
    print("waiting 18000")
    Wait(18000)
    print("spawning the homie")
    print(data.CarSpawn.x, data.CarSpawn.y, data.CarSpawn.z, data.CarSpawn.w)
    local VehicleHash =  data.Vehicles[math.random(#data.Vehicles)]
    QBCore.Functions.LoadModel(VehicleHash)
    BuyerVehicle = CreateVehicle(VehicleHash, data.CarSpawn.x, data.CarSpawn.y, data.CarSpawn.z, data.CarSpawn.w, true, true)

    local BuyerHash = data.Peds[math.random(#data.Peds)]
    QBCore.Functions.LoadModel(BuyerHash)
    Buyer = CreatePed(0,BuyerHash, data.CarSpawn.x, data.CarSpawn.y, data.CarSpawn.z, data.CarSpawn.w, true, true)
    BuyerSpawned = true
    SetPedIntoVehicle(Buyer, BuyerVehicle, -1)
    SetDriverAbility(Buyer, 1.0)
    TaskVehicleDriveToCoord(Buyer, BuyerVehicle, data.Location.x, data.Location.y, data.Location.z, Config.PedDrivingSpeed, 1, 0, Config.PedDrivingStyle, 1.0, true)

    local netId = NetworkGetNetworkIdFromEntity(BuyerVehicle)

    exports.interact:AddEntityInteraction({
        netId = netId,
        name = 'zerx:GiveOxyPackage',
        id = 'zerx_give_oxy_package', -- unique id to manage interaction lifecycle
        distance = 8.0,
        interactDst = 2.0,
        ignoreLos = false,
        offset = vec3(0.0, 0.0, 0.0), -- adjust if you want interaction offset from vehicle
        bone = 'door_dside_f', -- usually works well on vehicles
        options = {
            {
                label = 'Give Package',
                action = function(entity, coords, args)
                    if HasBox then
                        GivePackage()
                    else
                        QBCore.Functions.Notify("You have no package to give!", "error")
                    end
                end,
            },
        }
    })
end


function GivePackage()
    TriggerServerEvent('zerx-oxyruns:removeoxypackages')
    DeleteEntity(Buyer)
    DeleteEntity(BuyerVehicle)
    DeliveredPackages = DeliveredPackages +1
    ClearPedTasks(Buyer)
    BuyerSpawned = false
    RemoveBlip(DropBlip)
    Wait(3500)
    DropZone:destroy()
    GetLocation()

    if DeliveredPackages == RecievedPackages then
        DropZone:destroy()
        RemoveBlip(DropBlip)
        
        BuyerSpawned = true
        NoPackage = true

        if Config.Notifications == 'phone' then
            TriggerEvent('qb-phone:client:CustomNotification', 'NOTIFICATION', 'All packages sold.', 'fas fa-bars', '#86F9A1', 4000)
        elseif Config.Notifications == 'qbcore' then
            QBCore.Functions.Notify('All packages sold.', 'primary')
        end
        TriggerEvent('zerx-oxyruns:clean')
    end

    BuyerSpawned = false
end

RegisterNetEvent('zerx-oxyruns:clean', function ()
    SupplierSpawned = false
    OnDelivery = false
    GotPackages = false
    PackagesCollected = 0
    DeliveredPackages = 0
    InZone = false
    NoPackage = false
    HasBox = false
end)
CreateThread(function()
    while true do
        if OnDelivery then
            QBCore.Functions.TriggerCallback('zerx-oxyruns:hasPackage', function(Package)
                local ped = PlayerPedId()
                if Package then
                    if prop == nil then
                        HasBox = true
                        CarryAnimation()
                        prop = CreateObject(`prop_cs_cardbox_01`, 0, 0, 0, true, true, true)
                        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 0xEB95), 0.075, -0.10, 0.255, -130.0, 105.0, 0.0, true, true, false, false, 0, true)
                        DisableControls()
                    end
                else
                    if prop ~= nil then
                        DeleteEntity(prop)
                        HasBox = false
                        prop = nil
                        ClearPedTasks(ped)
                    end
                end
            end)
        end
        Wait(1000)
    end
end)

function DisableControls()
    while true do
        if HasBox then
            DisableControlAction(0, 21, true ) -- sprinting
            DisableControlAction(0, 22, true) -- Jumping
        end
        Wait(1)
    end
end

function CarryAnimation()
    LoadAnim('anim@heists@box_carry@')
    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    CreateThread( function ()
        while HasBox do
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end


RegisterNetEvent('zerx-oxyruns:collect', function()
    Collect()
end)

