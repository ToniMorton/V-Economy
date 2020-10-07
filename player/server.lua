RegisterNetEvent("player:skin2DB")
RegisterNetEvent("player:skinfromDB")

function FetchROSLicense(source)
	for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
	    else
    	end
    end
end

AddEventHandler("player:skin2DB",function(src, skin)
	Citizen.Trace("\nSAVING CLOTHING DATA")
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	MySQL.Async.execute("UPDATE `users` SET `Clothes`= '".. json.encode(skin) .."' WHERE ROSID = '" .. ROSLicense .. "'")
	Citizen.Trace("\nSAVE COMPLETED\n")
end)

AddEventHandler("player:skinfromDB",function(src)
	local ROSLicense = string.gsub(FetchROSLicense(source), "license:", "")
	Citizen.Trace("\nBEGIN CLOTHING LOAD")
	Citizen.Trace("\n" .. ROSLicense)
	local Clothes = MySQL.Sync.fetchScalar("SELECT Clothes FROM users WHERE ROSID = '" .. ROSLicense .. "'")
	Citizen.Trace("\nCLOTHING LOAD COMPLETE\n")
	local rawskindata = json.decode(Clothes)
	TriggerClientEvent("player:returnskinfromSV", src, rawskindata)
end)