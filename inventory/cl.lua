-- local spawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
-- local pickups = {}
-- local msl = CreatePickupRotate(GetHashKey("PICKUP_MONEY_PAPER_BAG"), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, 0.0, 0.0, 512, 1, 0, 0, GetHashKey("prop_ld_int_safe_01"))
-- local netid = NetworkGetNetworkIdFromEntity(msl)
-- SetNetworkIdExistsOnAllMachines(netid, true)
-- SetNetworkIdCanMigrate(netid, false)

-- Citizen.CreateThread(function()
    -- while true do
        -- Citizen.Wait(50)
         -- for i=0, #pickups do
              -- if HasPickupBeenCollected(msl) then
                 -- Citizen.Trace("IT WORKED\n")
            -- end
        -- end
    -- end
-- end)



inventory = {
	ITEM_TOOLBOX = 0,
	ITEM_BEER = 0,
	ITEM_BOX = 0,
	ITEM_RAWWEED = 0,
	ITEM_BAGOWEED = 0,
	ITEM_UNPROCESSEDCOKE = 0,
	ITEM_PROCESSEDCOKE = 0,
	ITEM_GOLDBAR = 0,
	ITEM_METH = 0,
	ITEM_MDMA = 0,
	ITEM_MEDKIT = 0
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local tbl = table.unpack(inventory)
		local jsontbl = json.encode(tbl)
		TriggerServerEvent("INV:SyncInventory", jsontbl)
	end
end)

function joaat(item)
return GetHashKey(item)
end

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

local makingmeth = false
local processingweed = false

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local x1 = 1389.8321533203
		local y1 = 3608.8298339844
		local z1 = 38.0
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
			DrawMarker(27, x1,y1,z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, false, false, 0,1)
			DisplayHelpText("Press ~INPUT_CONTEXT~ to Produce ~r~Meth~w~.")
            if IsControlJustPressed(0,51) and not makingmeth then
				makingmeth = true
				Citizen.Wait(60000)
				inventory.ITEM_METH = inventory.ITEM_METH + 1
				SendNUIMessage({
					type = "add",
					added = "Methamphetamine"
				})
				makingmeth = false
            end
		end
		Citizen.Wait(0)
	end
end)

AddEventHandler("inv:addraweed", function()
	inventory.ITEM_RAWWEED = inventory.ITEM_RAWWEED + 1
	SendNUIMessage({
		type = "add",
		added = "Brick of Raw Cannabis"
	})
end)

Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local x1 = 1389.8321533203
		local y1 = 3608.8298339844
		local z1 = 38.0
		local dist = Vdist2(x,y,z, x1,y1,z1)
		if (dist <= 5.0) then
			DisplayHelpText("Press ~INPUT_CONTEXT~ to Process and Package ~y~Cannabis~w~.")
            DrawMarker(27, x1,y1,z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 33, 120, 42, 255, false, false, 0,1)
            if IsControlJustPressed(0,51) and not processingweed and ITEM_RAWWEED >= 1 then
				processingweed = true
				Citizen.Wait(60000)
				inventory.ITEM_BAGOWEED = inventory.ITEM_BAGOWEED + 1
				SendNUIMessage({
					type = "add",
					added = "Small Bag of Cannabis"
				})
				processingweed = false
            end
		end
		Citizen.Wait(0)
	end
end)

function getNearestVeh()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
	return vehicleHandle
end

AddEventHandler("inv:UseToolbox", function()
		if inventory.ITEM_TOOLBOX >= 1 then
			local playerPed = GetPlayerPed(-1)
			local vehicle = getNearestVeh()
			if Vdist2(GetEntityCoords(playerPed), GetEntityCoords(vehicle)) <= 4.0 and not IsPedInAnyVehicle(playerPed, false) then
					inventory.ITEM_TOOLBOX = inventory.ITEM_TOOLBOX - 1
					SetVehicleEngineHealth(vehicle, 1000)
					SetVehicleEngineOn( vehicle, true, true )
					SetVehicleFixed(vehicle)
					SetVehicleDirtLevel(vehicle, 0)
					SetVehicleOnGroundProperly(vehicle)
			end
		else
			SendError("~r~ERROR~w~: You do not have a Vehicle Repair Toolkit OR are not near a Vehicle!")
		end
end)

AddEventHandler("inv:add2inv", function(obj)
	if obj == joaat("gr_prop_gr_tool_box_01a") then
		inventory.ITEM_TOOLBOX = inventory.ITEM_TOOLBOX + 1
		SendNUIMessage({
			type = "add",
			added = "Vehicle Repair Toolkit",
			amount = inventory.ITEM_TOOLBOX
		})
	elseif obj == joaat("hei_prop_heist_weed_block_01b") then
		inventory.ITEM_RAWWEED = inventory.ITEM_RAWWEED + 1 
		SendNUIMessage({
			type = "add",
			added = "Brick of Raw Weed",
			amount = inventory.ITEM_RAWWEED
		})
	elseif obj == joaat("hei_prop_heist_gold_bar") then
		inventory.ITEM_GOLDBAR = inventory.ITEM_GOLDBAR + 1 
		SendNUIMessage({
			type = "add",
			added = "Bar of Gold Bullion",
			amount = inventory.ITEM_GOLDBAR
		})
	end
end)

AddEventHandler("inv:useitem", function(itemname)
	if itemname == "Vehicle Repair Toolkit" then
		SendError("You used 1 ~g~Toolkit")
		TriggerEvent("inv:UseToolbox")
		
	elseif itemname == "Methamphetamine" then
		SendError("You used 1 ~r~Methamphetamine")
		
	elseif itemname == "Small Bag of Cannabis" then
		SendError("You used 1 Small Bag of ~y~Cannabis")
	else
		SendError("~r~You Cannot use this Item.")
	end
end)

AddEventHandler("inv:dropitem", function(itemname)
	if string.find(itemname ,"Vehicle Repair Toolkit") then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, -1.0))
		CreateObjectNoOffset(joaat("gr_prop_gr_tool_box_01a"), x, y, z, true, false, true)
	elseif string.find(itemname,"Brick of Raw Cannabis") then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, -1.0))
		CreateObjectNoOffset(joaat("hei_prop_heist_weed_block_01b"), x, y, z, true, false, true)	
	elseif string.find(itemname,"Methamphetamine") then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, -1.0))
		CreateObjectNoOffset(joaat("prop_meth_bag_01"), x, y, z, true, false, true)
	end
end)

function SetDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUIMessage({
		type = "ui",
		status = bool
	})
end

RegisterNUICallback("main", function(data)

end)

RegisterNUICallback("error", function(data)
	Citizen.Trace(data.error)
end)

RegisterNUICallback("use", function(data)
		if data.amount > 1 then
			TriggerEvent("inv:useitem", data.selectBox)
			
			SetDisplay(false)
		else
			
		end
end)

RegisterNUICallback("drop", function(data)
		TriggerEvent("inv:dropitem", data.selectBox)
		SendNUIMessage({
			type = "remove",
			amount = 1
		})
		SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
	SetDisplay(false)
end)


local InventoryOpen = false

RegisterCommand("inv", function(src, txt, fullcmd)
			if InventoryOpen then
				SetDisplay(false)
				InventoryOpen = false
			else
				SetDisplay(true)
				InventoryOpen = true
			end
end,false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			if IsDisabledControlJustPressed(0, 244) then
				if InventoryOpen then
					SetDisplay(false)
					InventoryOpen = false
				else
					SetDisplay(true)
					InventoryOpen = true
				end
			end
		Citizen.Wait(0)
	end
end)