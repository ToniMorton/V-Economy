function FetchROSLicense(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
	    else
    	end
    end
end

RegisterNetEvent("econ:CreateData")
AddEventHandler("econ:CreateData", function(source)
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	MySQL.Async.execute("INSERT INTO users (`ROSID`, `Cash`, `Bank`, `POS`, `Property`, `Clothes`, `Garage`, `Inventory`, `Weapons`, `IsAlive`) VALUES (@ROSID, @Cash, @Bank, @POS, @Property, @Clothes, @Inventory, @Weapons, @IsAlive)", {['@ROSID'] = ROSLicense, ['@Cash'] = "0", ['@Bank'] = "8000", ['@POS'] = "[0,0,0]", ['@Property'] = "0", ['@Clothes'] = "0", ['@Garage'] = "0", ['@Inventory'] = "0", ['@Weapons'] = "0", ['@IsAlive'] = "1"})
end)

RegisterNetEvent("econ:SaveData")
AddEventHandler("econ:SaveData", function(source, Wallet, Bank, Coords, Property, Clothes, Cars, Inventory, Weapons, IsAlive)
	Citizen.Trace("\nSAVING STAT DATA")
	local x,y,z = table.unpack(Coords)
	local testjson = json.encode(x .. "," .. y .. "," .. z)
	local boolieboi = 1
	
	if IsAlive == false then
		local boolieboi = 0
	end
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	MySQL.Async.execute("UPDATE `users` SET `Cash`= "..Wallet..",`Bank`= "..Bank..",`POS`= ".. testjson ..",`Property`= "..json.encode(Property)..",`Garage`= "..json.encode(Cars)..",`Inventory`= "..json.encode(Inventory)..",`Weapons`= "..json.encode(Weapons).." ,`Clothes`= "..json.encode(Clothes)..",`IsAlive`= "..boolieboi.." WHERE ROSID = '" .. ROSLicense .. "'")
						 --UPDATE `users` SET `Cash`= 2000,`Bank`= 30000,`POS`= ,`Property`= ,`Garage`= ,`Inventory`= ,`Weapons`= ,`Clothes`= ,`IsAlive`= 1 WHERE ROSID = '9a32f4411e9db506583473a1a42e34bfb66735de'
	Citizen.Trace("\nSAVE COMPLETED\n")
end)

RegisterNetEvent("econ:LoadData")
AddEventHandler("econ:LoadData", function(source)
		local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
		Citizen.Trace("\nBEGIN STAT LOAD")
		Citizen.Trace("\n" .. ROSLicense)
		local Cash = MySQL.Sync.fetchScalar("SELECT Cash FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Bank = MySQL.Sync.fetchScalar("SELECT Bank FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local POS = MySQL.Sync.fetchScalar("SELECT POS FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Property = MySQL.Sync.fetchScalar("SELECT Property FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Clothes = MySQL.Sync.fetchScalar("SELECT Clothes FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Garage = MySQL.Sync.fetchScalar("SELECT Garage FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Inventory = MySQL.Sync.fetchScalar("SELECT Inventory FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local Weapons = MySQL.Sync.fetchScalar("SELECT Weapons FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		local IsAlive = MySQL.Sync.fetchScalar("SELECT IsAlive FROM users WHERE ROSID = '" .. ROSLicense .. "'")
		TriggerClientEvent("econ:LoadDataClient", source, Cash, Bank, POS, Property, Clothes, Garage, Inventory, Weapons, IsAlive)
		Citizen.Trace("\nSTAT LOAD COMPLETE\n")
end)