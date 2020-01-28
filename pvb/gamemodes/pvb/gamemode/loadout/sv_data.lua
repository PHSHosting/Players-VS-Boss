include("..\\config\\sh_config.lua")


local DefaultTable = {
	{["weapon_pvb_ak47"] = 1, ["weapon_pvb_fiveseven"] = 1},			//Default
	{},												//Rarity 1
	{},												//Rarity 2
	{},												//Rarity 3
	{},												//Rarity 4
	{["weapon_fists"] = 1},							//Mele
	{["weapon_medkit"] = 1},						//Extra
	{/*["models/player/urban.mdl"] = {1, "Urban"}*/},	//Skins
}

function PVB:GetItems(ply)
	return ply:GetPData("PVB_Items", util.TableToJSON(PVB.Config.DefaultItems))
end

function PVB:SaveData(ply)
	if IsValid(ply) then
		ply:SetPData("PVB_Items", table.concat(ply.PVB_Items, ";"))
		return
	end
	for k,v in pairs(player.GetAll()) do
		v:SetPData("PVB_Items", table.concat(v.PVB_Items, ";"))
	end
end


//FIX IT
--[[ function PVB:HasWep(ply, weaponToCheck)
	items = PVB:GetItems(ply)
	for rarityLevel in items do
		for k,v in rarityLevel do
			if(if k == weaponToCheck) then
				return true
			end
		end
	end
	return false
end
end ]]

function PVB:GiveWeapon(ply, weaponName, rarity)
	rarity = rarity + 1 //cause numbers start at 1 apparently and break everything
	if(!ply:IsBot()) then
		playersCurrent = util.JSONToTable(PVB:GetItems(ply))
		
		table.Add(weaponName,table.Inherit(playersCurrent[rarity],{[weaponName] = 1}))
		
		
		//table.Add(playersCurrent[rarity][weaponName],1)
		//table.Add(weaponName,table.Inherit(playersCurrent[rarity],{weaponName = 1}))

		table.remove(playersCurrent[rarity], 0)
		//table.RemoveByValue(playersCurrent[rarity], "BaseClass" )
		
		
		ply:SetPData("PVB_Items", util.TableToJSON(playersCurrent))
		print("[PVBGAMEMODE] Has just given " .. ply:Nick() .. " a " .. weaponName  .. " of rarity id: " .. rarity .. ".")
	end
end


hook.Add("PlayerInitialSpawn", "PVB.LoadData", function(ply)
	ply.PVB_Items = util.JSONToTable(PVB:GetItems(ply))
end)

hook.Add("PlayerDisconnected", "PVB.SaveData", PVB.SaveData)

hook.Add("ShutDown", "PVB.SaveData", PVB.SaveData)


util.AddNetworkString("PVB.SendLoadoutInfo")

function GM:ShowSpare2(ply) 
	net.Start("PVB.SendLoadoutInfo")
		net.WriteString(PVB:GetItems(ply))
	net.Send(ply)
end