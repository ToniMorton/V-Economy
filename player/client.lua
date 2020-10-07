local coords = {
{x1 = 429.79339599609377, y1 = -811.4584350585938, z1 = 29.491113662719728},
{x1 = 71.20878601074219, y1 = -1387.227294921875, z1 = 29.376148223876954},
{x1 = -705.2880859375, y1 = -152.38873291015626, z1 = 37.41513442993164}
}
local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
local playerSkin = {}
local pmodel = nil


local components = {
	{ name = 'Head/Face', t = 0},
	{ name = 'Beard/Mask', t = 1},
	{ name = 'Hair/Hats', t = 2},
	{ name = 'Top/Shirts', t = 3},
	{ name = 'Legs/Pants', t = 4},
	{ name = 'Gloves/Hands', t = 5},
	{ name = 'Shoes/Feet', t = 6},
	{ name = 'Neck/Eyes', t = 7},
	{ name = 'Accessories-Top', t = 8},
	{ name = 'Accessories-Extra', t = 9},
	{ name = 'Badges/Decals', t = 10},
	{ name = 'Shirt/Jacket', t = 11}
}

local propComponents = {
	{ name = "Hats/Mask/Helmets", t = 0},
	{ name = "Glasses", t = 1},
	{ name = "Ears/Accessories", t = 2}
}

function savePlayerAppearanceVariables()
	local ped = PlayerPedId()
	for i=0,12,1 do
		table.insert(playerSkin, {
			drawable = GetPedDrawableVariation(ped, i),
			dtexture = GetPedTextureVariation(ped, i),
			prop = GetPedPropIndex(ped, i),
			ptexture = GetPedPropTextureIndex(ped, i),
			palette = GetPedPaletteVariation(ped, i),
			index = i
		})
	end
	TriggerServerEvent("player:skin2DB", GetPlayerServerId(PlayerId()), playerSkin)
end

function restorePlayerAppearance(skin)	
	local ped = GetPlayerPed(-1)
	for _,obj in pairs(skin) do
		SetPedComponentVariation(ped, obj.index, obj.drawable, obj.dtexture, obj.palette)
		SetPedPropIndex(ped, obj.index, obj.prop, obj.ptexture)
	end
end

RegisterNetEvent("player:returnskinfromSV")

AddEventHandler("player:returnskinfromSV",function(skin)
		restorePlayerAppearance(skin)
end)

AddEventHandler("playerSpawned",function(spawn)
		TriggerServerEvent("player:skinfromDB", GetPlayerServerId(PlayerId()))
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for i=1, #coords do
			if Vdist(x,y,z, coords[i].x1,coords[i].y1,coords[i].z1) <= 8.0 then
				DrawMarker(0, coords[i].x1,coords[i].y1,coords[i].z1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 80, 100, 200, 255, true, true, 0,0)
				if Vdist(x,y,z, coords[i].x1,coords[i].y1,coords[i].z1) <= 2.0 and IsControlJustPressed(0,51) and GetLastInputMethod(0) then
						savePlayerAppearanceVariables()
				end
			end
		end
	end
end)