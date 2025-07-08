local QBCore = exports['qb-core']:GetCoreObject()

local CoolDown = false

RegisterServerEvent('zerx-oxyruns:coolout', function()
    CoolDown = true
    local timer = Config.CoolDown
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            CoolDown = false
        end
    end
end)

QBCore.Functions.CreateCallback("zerx-oxyruns:coolc", function(source, cb)
    if CoolDown then
        cb(true)
    else
        cb(false)
    end
end)


QBCore.Functions.CreateCallback('zerx-oxyruns:Haspayment',function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    
    local Payment = Config.OxyStartPayment
    if Player.PlayerData.money.cash >= Payment then
        Player.Functions.RemoveMoney('cash', Payment, 'Oxy Delivery Payment')
        cb(true)
    else
        cb(false)
		TriggerClientEvent('QBCore:Notify', src, 'You cannot afford to do this..', 'error')
    end
end)

RegisterNetEvent('zerx-oxyruns:giveoxypackages', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	Player.Functions.AddItem(Config.OxyPackageName, 1, false)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.OxyPackageName], "add")
	Wait(2500)
end)

QBCore.Functions.CreateCallback('zerx-oxyruns:hasPackage', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local hasPackage = Player.Functions.GetItemByName(Config.OxyPackageName)
    if hasPackage then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('zerx-oxyruns:removeoxypackages', function ()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local OxyPackage = Player.Functions.GetItemByName(Config.OxyPackageName)
    if OxyPackage then
        Player.Functions.AddMoney('cash', Config.CashPay, 'Oxy Sale')

        Player.Functions.RemoveItem(Config.OxyPackageName, 1, false)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.OxyPackageName], "remove")

        local chance = math.random(100)
        local rare = Config.RareItem[math.random(#Config.RareItem)]
        if chance <= Config.RareItemChance then
            Player.Functions.AddItem(rare, Config.RareItemAmount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[rare], "add",Config.RareItemAmount)
        end

        if chance <= Config.ItemChance then
            Player.Functions.AddItem(Config.ItemName, Config.OxyAmount, false)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ItemName], "add",Config.OxyAmount)
        end
    end
	Wait(2500)
end)