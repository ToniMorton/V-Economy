--{735.62817382813, -1071.8243408203, 21.762516021729}
local LSCUSTOMS_INDUST = {x = 735.74267578125, y = -1073.0483398438,z = 21.668197631836, h = 156.40629577637}
local LSCUSTOMS_DOWNTOWN = {}
local LSCUSTOMS_AIRPORT = {}
local LSCUSTOMS_HARMONY = {}
local LSCUSTOMS_PALETO = {}

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SetupGarage()
local playerPed = GetPlayerPed(-1)
local vehicle = GetVehiclePedIsIn(playerPed, false)
local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
local _, outPos, outHeading = GetClosestVehicleNodeWithHeading(x, y, z, 1, 3, 0)
local x1,y1,z1 = table.unpack(outPos)
DisableAllControlActions(0)
DoScreenFadeOut(500)
Citizen.Wait(1000)
SetEntityCoords(vehicle, LSCUSTOMS_INDUST.x,LSCUSTOMS_INDUST.y,LSCUSTOMS_INDUST.z, false, false, false)
SetEntityHeading(vehicle, LSCUSTOMS_INDUST.h)
SetGameplayCamRelativeHeading(179.78373718262)
--NetworkConcealPlayer(GetPlayerPed(-1), true, false)
SetVehicleEngineHealth(vehicle, 1000)
SetVehicleEngineOn( vehicle, true, true )
SetVehicleFixed(vehicle)
SetVehicleDirtLevel(vehicle, 0)
SetVehicleOnGroundProperly(vehicle)
Citizen.Wait(1000)
--NetworkConcealPlayer(GetPlayerPed(-1), false, false)
SetEntityCoords(vehicle, x1,y1,z1, false, false, false)
SetEntityHeading(vehicle, 89.365478515625)
SetVehicleOnGroundProperly(vehicle)
DoScreenFadeIn(1000)
EnableAllControlActions(0)
DisplayHelpText("Vehicle Repaired")
end

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 20.0, 1544229216, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,2.0,-1.0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 10.0) then
            DrawMarker(29, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
			DisplayHelpText("Press ~Input_Context~ to Repair and Paint your car. ~r~$1200")
            if IsControlJustPressed(0,51) and GetLastInputMethod(0) then
			    TriggerEvent("carpaint:open")
				local playerPed = GetPlayerPed(-1)
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				SetVehicleEngineHealth(vehicle, 1000)
				SetVehicleEngineOn( vehicle, true, true )
				SetVehicleFixed(vehicle)
				SetVehicleDirtLevel(vehicle, 0)
				SetVehicleOnGroundProperly(vehicle)
            end
		end
		Citizen.Wait(0)
	end
end)

