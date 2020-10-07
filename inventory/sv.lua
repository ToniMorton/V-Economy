local defaultdata = {Wallet = 8000, Bank = 0, Clothes = {}, Cars = {}, Property = {}, Inventory={}}
local currentdatabuff = {Wallet = 0, Bank = 0, Clothes = {}, Cars = {}, Property = {}, Inventory={}}

local NetIDBuffer = {}

function FetchDiscordID(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            return v
	    else
    	end
    end
end

function FetchSteamID(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            return v
	    else
    	end
    end
end

function FetchROSLicense(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
	    else
    	end
    end
end

function exists(name)
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end

RegisterNetEvent("econ:CreateData")
AddEventHandler("econ:CreateData", function(source)
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	local file = io.open('D:\fivem_player_data\' .. ROSLicense ..'.data', "w")
	local newFile = json.encode(defaultdata)
	file:write(newFile)
	file:flush()
	file:close()
end)

RegisterNetEvent("econ:SaveData")
AddEventHandler("econ:SaveData", function(source, wallet, bank, clothes, cars, property, inventory)
	Citizen.Trace("\nSAVING STAT DATA")
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	local file = io.open('D:\fivem_player_data\' .. ROSLicense ..'.data', "w")
	currentdatabuff.Wallet = wallet
	currentdatabuff.Bank = bank
	currentdatabuff.Clothes = clothes
	currentdatabuff.Cars = cars
	currentdatabuff.Property = property
	currentdatabuff.Inventory = inventory
	local newFile = json.encode(currentdatabuff)
	file:write(newFile)
	file:flush()
	file:close()
	currentdatabuff = {Wallet = 0, Bank = 0, Clothes = {}, Cars = {}, Property = {}, Inventory={}}
	Citizen.Trace("\nSAVE COMPLETED\n")
end)

RegisterNetEvent("econ:LoadData")
AddEventHandler("econ:LoadData", function(source)
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	if exists('D:\fivem_player_data\' .. ROSLicense ..'.data', "r") then
		Citizen.Trace("\nBEGIN STAT LOAD")
		Citizen.Trace("\n" .. ROSLicense)
		local file = io.open('D:\fivem_player_data\' .. ROSLicense ..'.data', "r")
		local filecontents = file:read()
		local currentdatabuff = json.decode(filecontents)
		TriggerClientEvent("econ:LoadDataClient", source, currentdatabuff.Wallet, currentdatabuff.Bank, currentdatabuff.Clothes, currentdatabuff.Cars, currentdatabuff.Property, currentdatabuff.Inventory)
		file:flush()
		file:close()
		currentdatabuff = {Wallet = 0, Bank = 0, Clothes = {}, Cars = {}, Property = {}, Inventory={}}
		Citizen.Trace("\nSTAT LOAD COMPLETE\n")
	else
		Citizen.Trace("\nCREATING DATA FOR NEW CLIENT\n")
		TriggerEvent("econ:CreateData", source)
		Citizen.Trace("\nDATA CREATED\n")
	end
end)

RegisterNetEvent("Econ:GetNetIDValue")
AddEventHandler("Econ:GetNetIDValue", function(ID)
	for i=1, #NetIDBuffer do
		if NetIDBuffer[i].ID == ID then
			TriggerClientEvent("Econ:ReturnNetIDValue", NetIDBuffer[i].Owner, ID, NetIDBuffer[i].Amount)
		end
	end
end)

RegisterNetEvent("INV:SyncInventory")
AddEventHandler("INV:SyncInventory", function(jsondata)
local json = json.decode(jsondata)
currentdatabuff.Inventory = json
end)

RegisterNetEvent("Econ:AssignNetIDValue")
AddEventHandler("Econ:AssignNetIDValue", function(ID, Owner, Amount)
	table.insert(NetIDBuffer, {ID = ID, Owner = Owner, Amount = tonumber(Amount)})
end)

RegisterNetEvent("Econ:RemoveNetIDValue")
AddEventHandler("Econ:RemoveNetIDValue", function(ID)
	for i=0, #NetIDBuffer do
		if NetIDBuffer[i].ID == ID then
			table.remove(NetIDBuffer[i])
		end
	end
end)