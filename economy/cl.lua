local RPCURRENTCASH = 0
local RPCURRENTBANK = 0
local RPCURRENTPOS = {0,0,0}
local RPCURRENTPROPERTY = {}
local RPCURRENTCLOTHES = {}
local RPCURRENTGARAGE = {}
local RPCURRENTINVENTORY = {}
local RPCURRENTWEAPONS = {}
local display = false
local RPMAXCASH = 9999999999
local PickupAmount = 0
local RPISALIVE = true



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		RPCURRENTPOS = GetEntityCoords(GetPlayerPed(-1))		
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if RPCURRENTCASH >= RPMAXCASH then
			RPCURRENTCASH = RPMAXCASH
		end
		
		SendNUIMessage({
			type = "cash",
			cash = RPCURRENTCASH
		})	
		
	end
end)

function SavingPrompt(stringtosend)
SetLoadingPromptTextEntry("STRING")
AddTextComponentSubstringPlayerName(stringtosend)
ShowLoadingPrompt()
Citizen.Wait(1000)
RemoveLoadingPrompt()
end

RegisterNetEvent("econ:LoadDataClient")
AddEventHandler("econ:LoadDataClient", function(Cash, Bank, POS, Property, Clothes, Garage, Inventory, Weapons, IsAlive)
RPCURRENTCASH = Cash
RPCURRENTBANK = Bank
RPCURRENTPOS = POS
RPCURRENTPROPERTY = Property
RPCURRENTCLOTHES = Clothes
RPCURRENTGARAGE = Garage
RPCURRENTINVENTORY = Inventory
RPCURRENTWEAPONS = Weapons
RPISALIVE = IsAlive

local x,y,z = json.decode(RPCURRENTPOS)
SetEntityCoords(GetPlayerPed(-1), x,y,z, true, true, true, false)
end)

exports.spawnmanager:spawnPlayer(1, function(spawn)
	if RPISALIVE then

	end
end)

local templateclearjson = "[]"
local clearme = json.encode(templateclearjson)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if IsEntityDead(GetPlayerPed(-1)) then
			RPISALIVE = 0
			TriggerServerEvent("econ:SaveData", GetPlayerServerId(PlayerId()), RPCURRENTCASH - RPCURRENTCASH, RPCURRENTBANK,json.encode(tostring(RPCURRENTPOS)), RPCURRENTPROPERTY, clearme, RPCURRENTGARAGE, clearme, clearme, RPISALIVE)
			SavingPrompt("Saving..")
		end
	end
end)

RegisterCommand("save", function(src, args, full)
TriggerEvent("econ:forcesave")
end,false)

RegisterCommand("load", function(src, args, full)
TriggerEvent("econ:LoadDataClient")
end,false)

RegisterNetEvent("econ:forcesave")
AddEventHandler("econ:forcesave", function()
TriggerServerEvent("econ:SaveData", GetPlayerServerId(PlayerId()), RPCURRENTCASH, RPCURRENTBANK, json.encode(tostring(RPCURRENTPOS)), RPCURRENTPROPERTY, RPCURRENTCLOTHES, RPCURRENTGARAGE, RPCURRENTINVENTORY, RPCURRENTWEAPONS, RPISALIVE)
SavingPrompt("Saving..")
end)

function rendertext(drawme, x, y)
   local screenW, screenH = GetScreenResolution()
   local height = 1080
   local ratio = screenW/screenH
   local width = height*ratio
   SetTextFont(6)
   SetTextProportional(1)
   SetTextScale(0.0, 0.56)
   SetTextColour(255, 255, 255, 255)
   SetTextDropshadow(0, 0, 0, 0, 255)
   SetTextEdge(1, 0, 0, 0, 150)
   SetTextDropshadow()
   SetTextOutline()
   SetTextEntry("String")
   AddTextComponentString(drawme)
   DrawText(x,y)
end
-----------
--NUI HANDLER
-----------

function SetDisplay(bool, typeof)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUIMessage({
		type="ui",
		status = bool
	})		
	SendNUIMessage({
		type = typeof,
		bank = RPCURRENTBANK
	})
end

RegisterNUICallback("main", function(data)

end)

RegisterNUICallback("error", function(data)
	Citizen.Trace(data.error)
end)

RegisterNUICallback("withdraw", function(data)
	if tonumber(data.amount) >= 0  and tonumber(data.amount) <= RPCURRENTBANK then
		RPCURRENTBANK = RPCURRENTBANK - tonumber(data.amount)
		RPCURRENTCASH = RPCURRENTCASH + tonumber(data.amount)
		SendNUIMessage({
			type = "bank",
			bank = RPCURRENTBANK
		})
		TriggerEvent("econ:forcesave")
	else
	end
end)

RegisterNUICallback("deposit", function(data)
	if tonumber(data.amount) >= 0  and tonumber(data.amount) <= RPCURRENTCASH then
		RPCURRENTBANK = RPCURRENTBANK + tonumber(data.amount)
		RPCURRENTCASH = RPCURRENTCASH - tonumber(data.amount)
		SendNUIMessage({
			type = "bank",
			bank = RPCURRENTBANK
		})
		TriggerEvent("econ:forcesave")
	else
	
	end
end)

RegisterNUICallback("transfer", function(data)
	Citizen.Trace(data.amount)
	SendNUIMessage({
		type = "bank",
		bank = RPCURRENTBANK
	})
	TriggerEvent("econ:forcesave")
end)

RegisterNUICallback("exit", function(data)
	SetDisplay(false, "bank")
	ClearPedTasksImmediately(GetPlayerPed(-1))
end)

-----------
--BACKEND
-----------

function AccessATM()
local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
TaskUseNearestScenarioToCoord(GetPlayerPed(-1), x,y,z, 3.0, -1 )
SetDisplay(true)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 32) then
			ClearPedTasks(GetPlayerPed(-1))
			break
		end		
		if IsControlJustPressed(0, 33) then
			ClearPedTasks(GetPlayerPed(-1))
			break
		end
		if IsControlJustPressed(0, 34) then
			ClearPedTasks(GetPlayerPed(-1))
			break
		end		
		if IsControlJustPressed(0, 35) then
			ClearPedTasks(GetPlayerPed(-1))
			break
		end
	end
end)

end

function AccessVending()
RPCURRENTCASH = RPCURRENTCASH - 1
SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(0)) + 50)
SendNotification("Transaction Completed", "Total amount of Transaction: ~r~$1")
end

-- atm and bank
Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, -870868698, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,-0.5,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessATM()
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, -1884707448, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,-0.8,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessATM()
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, -1364697528, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,-0.5,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessATM()
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, -1126237515, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,-0.5,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessATM()
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, 1114264700, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -1.0 ,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, true, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessVending()
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, -654402915, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0, -1.0 ,0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
            DrawMarker(29, x1,y1,z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, false, true, 0,0)
            if IsControlJustPressed(0,51) then
			    AccessVending()
            end
		end
		Citizen.Wait(0)
	end
end)

-- ARMORED CAR SHIT

local pickups = {}

Citizen.CreateThread(function()
	while true do
		if GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == GetHashKey("Stockade") then
			DisplayHelpText("You have ~r~stolen~w~ an ~g~Armored Van~w~. \nPress ~INPUT_CONTEXT~ to start a ~r~Robbery~w~.")
			if IsControlJustPressed(0,51) then
				CancelEvent()
				Citizen.Wait(2000)
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				local pickup = CreatePickupRotate(GetHashKey("PICKUP_MONEY_SECURITY_CASE"), x, y, z, 0.0, 0.0, 0.0, 8, 1000, 0, 0, GetHashKey("prop_ld_wallet_pickup"))
				if HasPickupBeenCollected(pickup) then
					TriggerEvent("econ:sell", 1500, 0)
					SendNUIMessage({type = "cash", cash = RPCURRENTCASH})
				end
			end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
         for i=1, #pickups do
              if HasPickupBeenCollected(pickups[i]) then
                 TriggerEvent("econ:sell", 1500, 0)
				 SendNUIMessage({type = "cash", cash = RPCURRENTCASH})
            end
        end
    end
end)


--

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

AddEventHandler("econ:sell",function(cash, bank)
RPCURRENTCASH = RPCURRENTCASH + cash
RPCURRENTBANK = RPCURRENTBANK + bank
TriggerEvent("econ:forcesave")
		SendNUIMessage({
			type = "cash",
			cash = RPCURRENTCASH
		})	
end)

AddEventHandler("econ:buy", function(cash, bank)
	if RPCURRENTCASH >= cash then
		RPCURRENTCASH = RPCURRENTCASH - cash
	else
		SendNotification("Insufficent Funds","<h3>You do not have enough money to complete this transaction</h3>")
	end
	
	if RPCURRENTBANK >= bank then
		RPCURRENTBANK = RPCURRENTBANK - bank
	else
		SendNotification("Insufficent Funds","<h3>You do not have enough money to complete this transaction</h3>")
	end
	
	TriggerEvent("econ:forcesave")
			SendNUIMessage({
			type = "cash",
			cash = RPCURRENTCASH
		})	
end)

function SpawnObject(obj)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local ox,oy,oz = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0,1.0,0))
	local heading = GetEntityHeading(GetPlayerPed(-1))
	local rotation = GetEntityRotation(GetPlayerPed(-1))
    RequestModel(obj)
    while not HasModelLoaded(obj) do
      Citizen.Wait(1)
    end
	local object = CreateObjectNoOffset(obj, ox, oy, oz, true, true, false) -- x+1
	SetEntityAsMissionEntity(object, true, true)
	NetworkRequestControlOfEntity(object)
	SetEntityHeading(object, heading)
	SetEntityRotation(object, rotation)
    PlaceObjectOnGroundProperly(object)
	return object
end

function SpawnObjectCoords(obj, ox, oy, oz)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local heading = GetEntityHeading(GetPlayerPed(-1))
	local rotation = GetEntityRotation(GetPlayerPed(-1))
    RequestModel(obj)
    while not HasModelLoaded(obj) do
      Citizen.Wait(1)
    end
	local object = CreateObjectNoOffset(obj, ox, oy, oz, true, true, false) -- x+1
	SetEntityAsMissionEntity(object, true, true)
	NetworkRequestControlOfEntity(object)
	SetEntityHeading(object, heading)
	SetEntityRotation(object, rotation)
    PlaceObjectOnGroundProperly(object)
end

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, 452618762, false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,0,-1.0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
			DisplayHelpText("Press ~INPUT_CONTEXT~ to trim the ~y~Weed~w~")
            DrawMarker(27, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, false, false, 0,1)
            if IsControlJustPressed(0,51) then
				PlayTrimAnim()
				NetworkRequestControlOfEntity(obj)
				SetEntityAsMissionEntity(obj, true, true)
				NetworkRequestControlOfEntity(obj)
				NetworkFadeOutEntity(obj, true, false)
				Citizen.Wait(3000)
				SpawnObject("hei_prop_heist_weed_block_01b")
				SpawnObjectCoords(-305885281, GetEntityCoords(obj))
				DeleteEntity(obj)
            end
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local obj = GetClosestObjectOfType(x, y, z, 10.0, GetHashKey("hei_prop_heist_weed_block_01b"), false, false, false)
		local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(obj, 0,0,-1.0))
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
			DisplayHelpText("Press ~INPUT_CONTEXT~ to Pickup.")
            DrawMarker(27, x1,y1,z1+1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, false, false, 0,1)
            if IsControlJustPressed(0,51) and not trimming then
				NetworkRequestControlOfEntity(obj)
				SetEntityAsMissionEntity(obj, true, true)
				NetworkRequestControlOfEntity(obj)
				NetworkFadeOutEntity(obj, true, false)
				Citizen.Wait(500)
				DeleteEntity(obj)
            end
		end
		Citizen.Wait(0)
	end
end)

function PlayTrimAnim()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		trimming = true
		if not IsEntityPlayingAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search", 3) then
			RequestAnimDict("anim@gangops@facility@servers@bodysearch@")
			while not HasAnimDictLoaded("anim@gangops@facility@servers@bodysearch@") do
				Citizen.Wait(100)
			end
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			TaskPlayAnim(ped, "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8, -1, 49, 0, 0, 0, 0)
            Citizen.Wait(6000)
            ClearPedTasksImmediately(ped)
		end
		trimming = false
		FreezeEntityPosition(GetPlayerPed(-1), false)
	end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if trimming then
		FreezeEntityPosition(GetPlayerPed(-1), true)
    end
  end
end)

function SendError(title, text)
BeginTextCommandThefeedPost("STRING")
AddTextComponentSubstringPlayerName("~r~Error~w~: You don't have enough money to perform that action.")
EndTextCommandThefeedPostTicker(true, true)
end

TriggerServerEvent("econ:LoadData", GetPlayerServerId(PlayerId()))
SetDisplay(false, "cash")

local coords = {
    {441.06457519531, -978.93707275391, 29.689584732056,"Police",535.77,0x15F8700D,"s_f_y_cop_01"}
}

Citizen.CreateThread(function()
    while true do
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNIFE"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BOTTLE"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_KNUCKLE"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HATCHET"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHETE"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SWITCHBLADE"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOL"), 0.1)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL50"), 0.8)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_VINTAGEPISTOL"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"), 0.8)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNSPISTOL"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLAREGUN"), 0.1)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MARKSMANPISTOL"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_REVOLVER"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_STUNGUN"), 0.1)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MICROSMG"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MG"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATMG"), 0.8)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GUSENBERG"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPDW"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MACHINEPISTOL"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSULTSMG"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MINISMG"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTRIFLE"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ADVANCEDRIFLE"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SPECIALCARBINE"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPRIFLE"), 0.5)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMPACTRIFLE"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PUMPSHOTGUN"), 0.4)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SAWNOFFSHOTGUN"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BULLPUPSHOTGUN"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_ASSAULTSHOTGUN"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_MUSKET"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYSHOTGUN"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_DBSHOTGUN"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SNIPERRIFLE"), 0.75)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FIREEXTINGUISHER"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PETROLCAN"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BRIEFCASE"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("weapon_raypistol"), 0.0)
	SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
    Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	   DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

--CreateObjectNoOffset("prop_cash_note_01", x, y, z, true,false,true)
--CreateObjectNoOffset("prop_cash_pile_02", x, y, z, true,false,true)
--CreateObjectNoOffset("prop_cash_pile_01", x, y, z, true,false,true)
--CreateObjectNoOffset("bkr_prop_money_wrapped_01", x, y, z, true,false,true)
--CreateObjectNoOffset("bkr_prop_moneypack_01a", x, y, z, true,false,true)