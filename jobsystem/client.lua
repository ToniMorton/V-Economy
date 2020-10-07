local chilijob = false
local postalworker = false
local HasJob = false

local JobCenter = {x = -234.44635009765626, y = -920.8907470703125, z = 32.31223678588867}
local Chilijob = {x = 148.35560607910157, y = -1444.4942626953126, z = 29.141618728637697}
local CourierJob = {x = 148.35560607910157, y = -1444.4942626953126, z = 29.141618728637697}

local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

RegisterNetEvent("jobsystem:hasjob")
AddEventHandler("jobsystem:hasjob", function(bool)
HasJob = bool
end)

function OpenJobSelectMenu()

end

Citizen.CreateThread(function()
	while true do	
	DrawMarker(20, JobCenter.x, JobCenter.y, JobCenter.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 80, 100, 200, 255, true, false, 0,0)
	if Vdist(x,y,z, JobCenter.x, JobCenter.y, JobCenter.z) <= 8.0 then
		if Vdist(x,y,z, JobCenter.x, JobCenter.y, JobCenter.z) <= 2.0 and IsControlJustPressed(0,51) and GetLastInputMethod(0) then
			OpenJobSelectMenu()
		end
	end
	Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do		
		while chilijob do
			hasjob = true
			Citizen.Wait(0)
			DrawMarker(20, Chilijob.x, Chilijob.y, Chilijob.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 80, 100, 200, 255, true, false, 0,0)
			if Vdist(x,y,z, Chilijob.x, Chilijob.y, Chilijob.z) <= 8.0 then
				if Vdist(x,y,z, Chilijob.x, Chilijob.y, Chilijob.z) <= 2.0 and IsControlJustPressed(0,51) and GetLastInputMethod(0) then
	
				end
			end
		end	
	
		while postalworker do
			hasjob = true
			Citizen.Wait(0)
			DrawMarker(20, CourierJob.x, CourierJob.y, CourierJob.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 80, 100, 200, 255, true, false, 0,0)
			if Vdist(x,y,z, CourierJob.x, CourierJob.y, CourierJob.z) <= 8.0 then
				if Vdist(x,y,z, CourierJob.x, CourierJob.y, CourierJob.z) <= 2.0 and IsControlJustPressed(0,51) and GetLastInputMethod(0) then
				
				end
			end
		end	
	Citizen.Wait(0)
	end
end)
