//custom state enums
PVB_WAITING = 0
PVB_PREP = 1
PVB_ACTIVE = 2
PVB_SWITCH = 3
//end custom state enums
local AllPlayers = player.GetAll
local StateName = "PVB.RoundState"

PVB.BossNum = 0

include("..//config//sh_config.lua")

PVB.GenericWeapons = PVB.Config.GenericWeapons
PVB.SpecialWeapons = PVB.Config.SpecialWeapons
PVB.RareWeapons = PVB.Config.RareWeapons
PVB.ArcaneWeapons = PVB.Config.ArcaneWeapons

team.SetSpawnPoint( TEAM_BOSS,"info_terrorist_start" );
team.SetSpawnPoint( TEAM_PLAYERS,"info_player_start" );

resource.AddFile("models/w_winchester_1873.mdl")

util.AddNetworkString("PVB.UpdateMusicState")
util.AddNetworkString("PVB.RoundStarted")

hook.Add("InitPostEntity", "PVB.Rounds.SpawnLogicEnt", function()
	local T = ents.FindByClass("info_pvb_logic")
	if T then
		for k,v in pairs(T) do
			SafeRemoveEntity(T)
		end
	end
	local newT = ents.Create("info_pvb_logic")
	newT:Spawn()	//I got better!
end)

function PVB:WaitForPlayers()
	print("Waiting for players to connect.")
	if player.GetCount()>1 then
		for _,v in pairs(AllPlayers()) do
			v:SetTeam(TEAM_SPECTATOR)
		end
	end
	hook.Run("PVB.State_Waiting")
end
if player.GetCount() < PVB.Config.MinPlayers then PVB:WaitForPlayers() end

function PVB:BeginPrep()
	hook.Run("PVB.BeginPrep")
	PVB.TRANSMITTER:SetRoundActive(true)
	game.CleanUpMap(false, {"info_pvb_logic"})
	game.SetGlobalCounter(StateName, PVB_PREP)
	for k,v in pairs(AllPlayers()) do
		v:SetTeam(TEAM_PLAYERS)
		v.BossPlayerModel = nil
		if v:Alive() then
			v:KillSilent()
		end
	end
	PVB.BossNum = math.random(1,#PVB.BossList)
	PVB.TRANSMITTER:SetBossInt(PVB.BossNum)
	PVB.RoundBoss = PVB.BossList[PVB.BossNum]
	PVB.RoundBoss:Init()
	hook.Run("PVB.FinishPrep")
	PVB:StartRound()
end

function PVB:StartRound()
	hook.Run("PVB.StartRound")
	game.SetGlobalCounter(StateName, PVB_ACTIVE)
	PVB.TRANSMITTER:SetBossMaxHealth(0)
	for k,v in pairs(AllPlayers()) do
		v:Spawn()
		v:SetMaxHealth(v:Health())
		v:SetModel(v.BossPlayerModel or v.PlayerModel or "models/player/riot.mdl")
		if v:Team() == TEAM_BOSS then
			PVB.TRANSMITTER:SetBossMaxHealth(PVB.TRANSMITTER:GetBossMaxHealth()+v:Health())
			print("[PVB]" .. v:Nick() .." <"..v:SteamID().."> " .." Has been selected as the boss")
			PrintMessage(HUD_PRINTTALK, "[PVB] " .. v:Nick() .. " Has been selected as the boss")
			//print("[PVBGAMEMODE]" .. v:Nick() .." <"..v:SteamID().."> " .." Has been selected as the ".. PVB.RoundBoss.PName)
			//PrintMessage(HUD_PRINTTALK, "[PVBGAMEMODE] " .. v:Nick() .. " Has been selected as the " .. PVB.RoundBoss.PName)
		end
		
		if(v:Team() == TEAM_PLAYERS) then
			v:Give("weapon_fists")
		end
	end
	net.Start("PVB.RoundStarted")
	net.Broadcast()
end

util.AddNetworkString("PVB.NotifyPlayerOfWinning")

function PVB:EndRound(winner)
	MsgC(Color(255,255,255), "\n\n[PVB]", Color(0,150,155), " Round ended: ", Color(255, 0, 0), (winner and "players") or "bosses", Color(0,150,155), " won\n\n")
	PVB.BossNum = 0
	hook.Run("PVB.RoundFinished", winner)
	game.SetGlobalCounter(StateName, PVB_SWITCH)

	for k,v in pairs(player.GetAll()) do
		if(math.random(0,PVB.Config.WeaponDropChance) == 2) then
			//possibleDrops = {"",}
			//weaponName = possibleDrops[math.random(#possibleDrops)]
			rarity = math.random(1,100) //1-50 = 1, 51-75 = 2, 76-90 = 3, 91-100 = 4
			raritytitle = ""
			if(rarity > 1 and rarity < 70) then
			//Gives generic item
			PVB:GiveRandomWeapon(v, PVB.GenericWeapons, 1)
			end
			if(rarity > 71 and rarity < 90) then
			//Gives special item
			PVB:GiveRandomWeapon(v, PVB.SpecialWeapons, 2)
			end
			if(rarity > 89 and rarity < 96) then
			//Gives rare item
			PVB:GiveRandomWeapon(v, PVB.RareWeapons, 3)
			end
			if(rarity > 95 and rarity < 100) then
			//Gives arcane item
			PVB:GiveRandomWeapon(v, PVB.ArcaneWeapons, 4)
			end
			
			//net.Start("PVB.NotifyPlayerOfWinning")
				//net.WriteString("Congratulations! You have just won a ".. weapons.Get(weaponName).PrintName .. " a " ..raritytitle.. " Weapon.")
			//net.Send(v)
		end
	end
	
	
	
	timer.Create("StartNextRound", 5, 1, function()
		if(game.GetGlobalState(StateName) != PVB_ACTIVE) then
			PVB:BeginPrep()
		end
	end)
end

function PVB:GiveRandomWeapon(v, possibleDrops, rarity, message)
	rtitle = ""
	if(message == nil) then
		if(rarity == 1) then
			rtitle = "Generic"
		end
		if(rarity == 2) then
			rtitle = "Special"
		end
		if(rarity == 3) then
			rtitle = "Rare"
		end
		if(rarity == 4) then
			rtitle = "Arcane"
		end
	end
	weaponName = possibleDrops[math.random(#possibleDrops)]
	PVB:GiveWeapon(v, weaponName, rarity)
	net.Start("PVB.NotifyPlayerOfWinning")
		if(message == nil) then
			net.WriteString("Congratulations! You have just won a ".. weapons.Get(weaponName).PrintName .. "\n a " ..rtitle.. " Weapon.")
			net.WriteString(weaponName)
		end
		if(message != null) then
			net.WriteString(message)
			net.WriteString("")
		end
	net.Send(v)
	if(weapons.Get(weaponName).PrintName[0] == "a") then
		PrintMessage(HUD_PRINTTALK, "[PVB] " .. v:Nick() .. " has just won an " .. weapons.Get(weaponName).PrintName .. ".")
	end
	if(weapons.Get(weaponName).PrintName[0] != "a") then
		PrintMessage(HUD_PRINTTALK, "[PVB] " .. v:Nick() .. " has just won a " .. weapons.Get(weaponName).PrintName .. ".")
	end
end


util.AddNetworkString("RequestWeaponConVar")
util.AddNetworkString("GrantedWeaponConVar")

function GM:PlayerLoadout(ply)
	if ply:Team() == TEAM_PLAYERS then
		net.Start("RequestWeaponConVar")
		net.Send(ply)
	end
	if ply:Team() == TEAM_BOSS then
		PVB.RoundBoss:Loadout(ply)
	end
	
	ply:GiveAmmo(999999,"Pistol")
	ply:GiveAmmo(999999,"SMG1")
	ply:GiveAmmo(999999,"357")
	ply:GiveAmmo(999999,"XBowBolt")
	ply:GiveAmmo(1,"SMG1_Grenade")
	ply:GiveAmmo(999999,"Buckshot")
	
	
end

net.Receive("GrantedWeaponConVar", function (len, ply)
	primary = net.ReadString()
	secondary = net.ReadString()
	extra = net.ReadString()
	//if(PVB:HasWep(ply, primary)) then
		ply:Give(primary)
	//end
	//if(PVB:HasWep(ply, secondary)) then
		ply:Give(secondary)
	//end
	//if(PVB:HasWep(ply, extra)) then
		ply:Give(extra)
	//end


end)

hook.Add("PlayerInitialSpawn", "PVB.Rounds.OnConnect", function(ply)
--[[ 	if(#player.GetAll() == 1) then
		ply:KillSilent()
	end ]]
	timer.Simple(0, function()
		ply:KillSilent()
		ply:SetTeam(TEAM_SPECTATOR)
		ply:Spectate(OBS_MODE_ROAMING)
		
	end)
	if game.GetGlobalState(StateName) == GLOBAL_DEAD and player.GetCount() >= PVB.Config.MinPlayers then
		game.SetGlobalState(StateName, GLOBAL_ON)
		game.SetGlobalCounter(StateName, PVB_SWITCH)
		timer.Simple(0,function()
			if(game.GetGlobalState(StateName) != PVB_ACTIVE) then
				PVB:BeginPrep()
			end
		end)
	end
	if GAMEMODE:AliveBosses() == 0 and #player.GetAll() >= 2 then
		PVB:EndRound(true)
	elseif GAMEMODE:AlivePlayers() == 0 and #player.GetAll() >= 2 then
		PVB:EndRound(false)
	end
end)

hook.Add("PlayerDisconnect", "PVB.Rounds.Disconnect", function(ply)
	if player.GetCount() < PVB.Config.MinPlayers then
		print("out of people :(")
		PVB.TRANSMITTER:SetRoundActive(false)
		if timer.Exists("StartNextRound") then timer.Remove("StartNextRound") end
		game.SetGlobalCounter(StateName, PVB_WAITING)
		game.SetGlobalState(StateName, GLOBAL_DEAD)
		PVB:WaitForPlayers()
	end
	if GAMEMODE:AliveBosses() == 0 then
		PVB:EndRound(true)
	elseif GAMEMODE:AlivePlayers() == 0 then
		PVB:EndRound(false)
	end
end)

hook.Add("PlayerDeath", "PVB.Rounds.OnDeded", function(ded, inflict, atck)
	//if !IsValid(ded) then return end
	timer.Simple(0,function()
		if game.GetGlobalCounter(StateName) == PVB_SWITCH then return end
		if GAMEMODE:AliveBosses() == 0 then
			PVB:EndRound(true)
		elseif GAMEMODE:AlivePlayers() == 0 then
			PVB:EndRound(false)
		end
		ded:Spectate(OBS_MODE_ROAMING)
	end)
end)

function GM:PlayerShouldTakeDamage( ply, attacker )
		if(attacker:IsPlayer()) then
		if(team.GetName(ply:Team()) == team.GetName(attacker:Team())) then
			return false
		end
		return true
	end
	return true
end

happened = false
timer.Create( "CheckForPlayers",5, 0,  function()
	if(happened == true) then
		timer.Stop("CheckForPlayers")
	end


	if(#player.GetAll() >= 2 and happened == false) then
		alive = 0
		for k,v in pairs(player.GetAll()) do
			if(v:Alive()) then
				alive = alive + 1
			end
		end
		if(alive <= 1) then 
			if game.GetGlobalCounter(StateName) == PVB_SWITCH then return end
			PVB:BeginPrep()
			happened = true
		end
		
	end

end)

