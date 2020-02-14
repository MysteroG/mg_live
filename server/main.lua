ESX = nil
LastDelivery = 0.0


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetCopsOnline()

	local PoliceConnected = 0
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			PoliceConnected = PoliceConnected + 1
		end
	end

	return PoliceConnected
end

RegisterServerEvent('mg_live:resetEvent')
AddEventHandler('mg_live:resetEvent', function()
	LastDelivery = 0.0
end)

ESX.RegisterServerCallback('mg_live:getCopsOnline', function(source, cb)
	cb(GetCopsOnline())
end)






ESX.RegisterServerCallback('mg_live:sellVehRun', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(":: Le Receleur de vehicule a paye  " .. price .. " $")

	xPlayer.addAccountMoney('black_money', price)
	TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Vous avez gagné <b style='color:red'>" .. price .. "</b> pour cette livraison.",
            type = "success",
            timeout = 10000,
            layout = "centerRight"
        })
	cb(true)

	LastDelivery = 0.0

end)





ESX.RegisterServerCallback('mg_live:buyVehRun', function(source, cb, price)

	local xPlayer = ESX.GetPlayerFromId(source)


	--if os.time() < police_alarm_time
	if (os.time() - LastDelivery) < 30.0 and LastDelivery ~= 0.0 then

		TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Eh ! Je suis pas concessionnaire !</br>Je fourni un seul vehicule à la fois.",
            type = "error",
            timeout = 10000,
            layout = "centerRight"
        })
		cb(false)

	else

		police_alarm_time = os.time() + math.random(10000, 20000)

		if xPlayer.getAccount('black_money').money >= price then
			xPlayer.removeAccountMoney('black_money', price)

			LastDelivery = os.time()

			cb(true)
		else

			TriggerClientEvent('esx:showNotification', source, "Pas assez d' ~r~argent sale~w~.")

			cb(false)
		end

	end

end)
