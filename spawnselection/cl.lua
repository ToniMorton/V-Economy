function SendError(text)
BeginTextCommandThefeedPost("STRING")
AddTextComponentSubstringPlayerName(text)
EndTextCommandThefeedPostTicker(true, true)
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SendNotification(title, text)
SetNotificationTextEntry("STRING")
AddTextComponentString(text)
SetNotificationMessage("CHAR_BANK_MAZE", "CHAR_BANK_MAZE", true, 1, title, "")
end

function SetDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUIMessage({
		type="ui",
		status = bool
	})
end

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	TriggerEvent("Spawn:invokeondeath")
end)

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		if GetEntityHealth(ped) <= 1 then
			TriggerEvent("Spawn:invokeondeath")
		end
		Citizen.Wait(0)
	end
end)

AddEventHandler('Spawn:invokeondeath', function()
	DoScreenFadeOut(50)
	SetDisplay(true)
end)

function Spawn(x1, y1, z1)
	RequestCollisionAtCoord(x1,y1,z1)
	local ped = GetPlayerPed(-1)
	SetEntityHealth(200)
	Citizen.Wait(200)
	SetEntityCoordsNoOffset(ped, x1, y1, z1, false, false, false, true)
	NetworkResurrectLocalPlayer(x1, y1, z1, 30.0, true, false)
	ClearPedBloodDamage(ped)
	ClearPedTasksImmediately(ped)
	RemoveAllPedWeapons(GetPlayerPed(-1))
	DoScreenFadeIn(4000)
	SetDisplay(false)
	SetDisplay(false)
	SetDisplay(false)
	SetDisplay(false)
end

RegisterNUICallback("main", function(data)

end)

RegisterNUICallback("error", function(data)
	Citizen.Trace(data.error)
end)

RegisterNUICallback("selectspawn", function(data)
		TriggerEvent("spawn:spawnselected", data.selectBox)
		SetDisplay(false)
end)

AddEventHandler("spawn:spawnselected", function(selection)
	if selection == "Sandy Shores" then
		Spawn(1951.3634033203,3768.1047363281,32.20764541626)
	elseif selection == "Paleto Bay" then
		Spawn(135.3450012207,6639.3818359375,31.757509231567)
	elseif selection == "Downtown Los Santos" then
		Spawn(231.39198303223,-872.06170654297,30.495817184448)
	elseif selection == "Fort Zancudo" then
		Spawn(-2272.8591308594,3343.6784667969,32.889419555664)
	elseif selection == "LS Government Facility" then
		Spawn(2516.0266113281,-384.08706665039,93.140411376953)
	end
end)