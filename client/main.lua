Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}

event_is_running = false
event_time_passed = 0.0
timer_baboom = 0.0
event_destination = nil
event_vehicle1 = nil
event_vehicle2 = nil
event_vehicle3 = nil
event_scenario = nil
police_alerted = false
event_alarm_time = 0.0
event_delivery_blip = nil
local talktodealer = true



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 1,
    menu_title = "NPC",
    menu_subtitle = "Choix difficulte",
    color_r = 0,
    color_g = 0,
    color_b = 0,
}




Citizen.CreateThread(function()

	RequestModel(Config.NPCHash)
	while not HasModelLoaded(Config.NPCHash) do
	Wait(1)

	end

	--PROVIDER
		meth_dealer_seller = CreatePed(1, Config.NPCHash, Config.ReceleurLocation.x, Config.ReceleurLocation.y, Config.ReceleurLocation.z, Config.ReceleurLocation.h, false, true)
		SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
		SetPedDiesWhenInjured(meth_dealer_seller, false)
		SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
		SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
		SetEntityInvincible(meth_dealer_seller, true)
		FreezeEntityPosition(meth_dealer_seller, true)
		TaskStartScenarioInPlace(meth_dealer_seller, "WORLD_HUMAN_SMOKING", 0, true);

end)





Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		local pVehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))
		local v = Config.ReceleurLocation
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 2.0)then
				DisplayHelpText("Apuyez sur ~INPUT_CONTEXT~ pour parler au ~y~Receleur de véhicule")
				if(IsControlJustReleased(1, 38))then
						if talktodealer then
						    Citizen.Wait(500)
							VehRunMenu()
							Menu.hidden = false
							talktodealer = false
						else
							talktodealer = true
						end
				end
				Menu.renderGUI(options)
			end

			if event_is_running then

				if pVehicle == event_vehicle1 or event_vehicle2 or event_vehicle3 then

					local dpos = event_destination
					local delivery_point_distance = Vdist(dpos.x, dpos.y, dpos.z, pos.x, pos.y, pos.z)
					if delivery_point_distance < 50.0 then
						DrawMarker(1, dpos.x, dpos.y, dpos.z,0, 0, 0, 0, 0, 0, 3.5, 3.5, 3.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
						if delivery_point_distance < 1.5 then
							DeliverVehRun()
						end
					end
				else
					 DrawMissionText("Retournez dans le véhicule!", 1000)
				end
			end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
				if event_is_running then

						if IsPedDeadOrDying(GetPlayerPed(-1)) then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('R.I.P.')
						end
						if GetVehicleEngineHealth(event_vehicle1) < 40 and event_vehicle1 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule est trop endommagé')
						end
						if GetEntityHealth(event_vehicle1) == 0 and event_vehicle1 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a explosé')
						end
						if IsEntityInWater(event_vehicle1) and event_vehicle1 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a coulé')
						end
						if GetVehicleEngineHealth(event_vehicle2) < 40 and event_vehicle2 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule est trop endommagé')
						end
						if GetEntityHealth(event_vehicle2) == 0 and event_vehicle2 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a explosé')
						end
						if IsEntityInWater(event_vehicle2) and event_vehicle2 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a coulé')
						end
						if GetVehicleEngineHealth(event_vehicle3) < 40 and event_vehicle3 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule est trop endommagé')
						end
						if GetEntityHealth(event_vehicle3) == 0 and event_vehicle3 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a explosé')
						end
						if IsEntityInWater(event_vehicle3) and event_vehicle3 ~= nil then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le vehicule a coulé')
						end
						if event_time_passed > 600 then
							ResetVehRun()
							police_alerted = false
							DisplayMissionFailed('Le délai de livraison a expiré')
						end

						event_time_passed = event_time_passed + 5
				end
		end
end)


function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function VehRunMenu()
	ClearMenu()
    options.menu_title = "Receleur de véhicule"
    for i = 1, #Config.Scenarios do
    	Menu.addButton("Livraison de niveau " .. Config.Scenarios[i].vehlv .. "~r~ + $" .. Config.Scenarios[i].VehRunReward, "PurchaseVehRun", i)
   	end
    Menu.addButton("Quitter","CloseMenu",nil)
end



function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end


function AlertThePolice()
	local PlayerData = ESX.GetPlayerData()
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)

	local vehicle_plate = "VRUN " .. math.random(100,999)

	SetVehicleNumberPlateText(event_vehicle1, vehicle_plate)
	SetVehicleNumberPlateText(event_vehicle2, vehicle_plate)
	SetVehicleNumberPlateText(event_vehicle3, vehicle_plate)

	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

    TriggerServerEvent('esx_addons_gcphone:startCallAnonyme', 'police', "Attention ! Un véhicule suspect avec la plaque [".. vehicle_plate .."] se dirige vers le Nord", PlayerCoords, {

		PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})

    for i = 1, #Config.AlertExtraSocieties do

    if PlayerData.job.name ~= Config.AlertExtraSocieties[i] then

    	TriggerServerEvent('esx_addons_gcphone:startCallAnonyme', Config.AlertExtraSocieties[i], "Attention ! Un véhicule suspect avec la plaque [".. vehicle_plate .."] se dirige vers le Nord", PlayerCoords, {
			PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
		})

	end
	end


end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CloseMenu()
		Menu.hidden = true
end

function ResetVehRun()

	TriggerServerEvent('mg_live:resetEvent')
	SetEntityAsNoLongerNeeded(event_vehicle1)
	SetEntityAsNoLongerNeeded(event_vehicle2)
	SetEntityAsNoLongerNeeded(event_vehicle3)
	SetEntityAsMissionEntity(event_vehicle1,true,true)
	SetEntityAsMissionEntity(event_vehicle2,true,true)
	SetEntityAsMissionEntity(event_vehicle3,true,true)
	DeleteEntity(event_vehicle1)
	DeleteEntity(event_vehicle2)
	DeleteEntity(event_vehicle3)

	RemoveBlip(event_delivery_blip)
	event_delivery_blip	= nil
	event_time_passed = 0.0
	timer_baboom = 0.0
	event_is_running = false
	event_destination = nil
	event_vehicle1 = nil
	event_vehicle2 = nil
	event_vehicle3 = nil
	event_scenario = nil
	police_alerted = false
	local talktodealer = true

end

function DeliverVehRun()

	ESX.TriggerServerCallback('mg_live:sellVehRun', function(sold)
			if sold then

			end
			end, Config.Scenarios[event_scenario].VehRunReward)

	local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))

	SetEntityAsNoLongerNeeded(vehicle)
	SetEntityAsMissionEntity(vehicle,true,true)
	DeleteEntity(vehicle)

	RemoveBlip(event_delivery_blip)
	event_delivery_blip	= nil

	event_is_running = false
	event_time_passed = 0.0
	timer_baboom = 0.0
	event_destination = nil
	event_vehicle1 = nil
	event_vehicle2 = nil
	event_vehicle3 = nil
	event_scenario = nil
	police_alerted = false
	local talktodealer = true


end

function SpawnVehRunVehicle(scenario)

	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	if Config.Scenarios[scenario].vehlv == 1 then
		carlist1 = {'savestra','retinue','cheburek','michelli'}
		cl1 = carlist1[math.random(1,4)]
		vehicle = GetHashKey(cl1)
	elseif Config.Scenarios[scenario].vehlv == 2 then
		carlist2 = {'specter2','ruston','banshee2','flashgt'}
		cl2 = carlist2[math.random(1,4)]
		vehicle = GetHashKey(cl2)
	elseif Config.Scenarios[scenario].vehlv == 3 then
		carlist3 = {'2f2frx7','2f2fs2000','350zdk','350zm','fnfjetta','fnfrx7dom','2f2fgts','2f2fmk4','2f2fmle7','ff4wrx','fnf4r34','','fnfmk4','fnfrx7'}
		cl3 = carlist3[math.random(1,13)]
		vehicle = GetHashKey(cl3)
	end

    RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	colors = table.pack(GetVehicleColours(veh))
	extra_colors = table.pack(GetVehicleExtraColours(veh))
	plate = math.random(100, 900)
	if Config.Scenarios[scenario].vehlv == 1 then
		spawned_car1 = CreateVehicle(vehicle, Config.Scenarios[1].SpawnPoint.x, Config.Scenarios[1].SpawnPoint.y, Config.Scenarios[1].SpawnPoint.z, false, true)
		SetEntityHeading(spawned_car1, Config.Scenarios[1].SpawnPoint.h)
		SetVehicleOnGroundProperly(spawned_car1)
		SetPedIntoVehicle(myPed, spawned_car1, - 1)
	elseif Config.Scenarios[scenario].vehlv == 2 then
		spawned_car2 = CreateVehicle(vehicle, Config.Scenarios[2].SpawnPoint.x, Config.Scenarios[2].SpawnPoint.y, Config.Scenarios[2].SpawnPoint.z, false, true)
		SetEntityHeading(spawned_car2, Config.Scenarios[2].SpawnPoint.h)
		SetVehicleOnGroundProperly(spawned_car2)
		SetPedIntoVehicle(myPed, spawned_car2, - 1)
	elseif Config.Scenarios[scenario].vehlv == 3 then
		spawned_car3 = CreateVehicle(vehicle, Config.Scenarios[3].SpawnPoint.x, Config.Scenarios[3].SpawnPoint.y, Config.Scenarios[3].SpawnPoint.z, false, true)
		SetEntityHeading(spawned_car3, Config.Scenarios[3].SpawnPoint.h)
		SetVehicleOnGroundProperly(spawned_car3)
		SetPedIntoVehicle(myPed, spawned_car3, - 1)
	end
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
	CruiseControl = 0
	DTutOpen = false
	SetEntityVisible(myPed, true)
	FreezeEntityPosition(myPed, false)
	if Config.Scenarios[scenario].vehlv == 1 then
		event_vehicle1 = spawned_car1
	elseif Config.Scenarios[scenario].vehlv == 2 then
		event_vehicle2 = spawned_car2
	elseif Config.Scenarios[scenario].vehlv == 3 then
		event_vehicle3 = spawned_car3
	end
	


end







function PurchaseVehRun(scenario)

	local cops_online = 0
	event_scenario = scenario


	if event_is_running == true then
		
		exports.pNotify:SendNotification({
            text = "Vous êtes déjà en mission de livraison.",
            type = "error",
            timeout = 10000,
            layout = "centerRight"
        })
		goto done

	end

	print("Flic en ville (minimum): " .. Config.Scenarios[scenario].MinCopsOnline .. " ||  Difficulté:  " .. Config.Scenarios[scenario].vehlv .. "")

	ESX.TriggerServerCallback('mg_live:getCopsOnline', function(police)

		police = police

		if police >= Config.Scenarios[scenario].MinCopsOnline then

			ESX.TriggerServerCallback('mg_live:buyVehRun', function(bought)
			if bought then

				exports.pNotify:SendNotification({
            text = "Véhicule récupéré avec <b style='color:green'>succès</b>.",
            type = "success",
            timeout = 10000,
            layout = "centerRight"
        })

				SpawnVehRunVehicle(scenario)

				event_is_running = true

				math.random(); math.random(); math.random()
				random_destination = math.random(1, #Config.ZoneLivraison)
				event_destination = Config.ZoneLivraison[random_destination]

				ESX.SetTimeout(math.random(Config.AlertCopsDelayRangeStart * 1000, Config.AlertCopsDelayRangeEnd * 1000), function()
    				AlertThePolice()
				end)

				event_delivery_blip	 = AddBlipForCoord(event_destination.x,event_destination.y,event_destination.z)
				SetBlipSprite(event_delivery_blip,94)
				SetBlipColour(event_delivery_blip,1)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Point de livraison')
				EndTextCommandSetBlipName(event_delivery_blip)
				SetBlipAsShortRange(event_delivery_blip,true)
				SetBlipAsMissionCreatorBlip(event_delivery_blip,true)
				SetBlipRoute(event_delivery_blip, 1)

						if Config.Scenarios[scenario].vehlv == 3 then

							exports.pNotify:SendNotification({
					text = "Ce vehicule est équipé d'un <b style='color:blue'>kit NOS</b> <b style='color:red'>instable</b>.</br>Effectuez la livraison avant que le <b style='color:blue'>NOS</b> <b style='color:red'>explose</b>.</br>Appuyez sur [E] pour utiliser le NOS",
					type = "info",
					timeout = 15000,
					layout = "centerRight",
					queue = "left"
					})

							Citizen.CreateThread(function()
							    while true do

							        Citizen.Wait(0)
									local force = 50.0
							        local ped = GetPlayerPed(-1)
									local vboost = GetVehiclePedIsIn(ped ,false)

									if IsControlPressed(1, 38) and vboost == event_vehicle3 then
										SetVehicleBoostActive(event_vehicle3, 1, 0)
										SetVehicleForwardSpeed(event_vehicle3, force)
										SetVehicleBoostActive(event_vehicle3, 0, 0)
							        end
							    end
							end)

							-- Citizen.Wait(300000)
							-- SetVehicleTimedExplosion(spawned_car3, playerped, 1)
							
						elseif Config.Scenarios[scenario].vehlv ~= 3 then

							exports.pNotify:SendNotification({
					text = "Ne trainez pas !</br>Le client attends cette livraison dans les 10 minutes.",
					type = "info",
					timeout = 15000,
					layout = "centerRight",
					queue = "left"
					})
							
						end
			else

			end
			end, Config.Scenarios[scenario].VehRunCost)


		else
			exports.pNotify:SendNotification({
            text = "Vous avez besoin d'au moins  ~b~" .. Config.Scenarios[scenario].MinCopsOnline .. " flics ~w~en ville.",
            type = "error",
            timeout = 10000,
            layout = "centerRight"
        })

		end

	end)

	::done::

end

function DisplayMissionFailed(label)
	
	exports.pNotify:SendNotification({
            text = "Echec de la livraison : " .. label,
            type = "error",
            timeout = 10000,
            layout = "centerRight"
        })
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)

end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
				if event_is_running then
				
						if timer_baboom > 300 then
							SetVehicleTimedExplosion(spawned_car3, playerped, 1)
						end

						timer_baboom = timer_baboom + 5
				end
		end
end)
