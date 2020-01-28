//shared

hook.Run("PVB_StartLoad")

GM.Version = "0.2"
GM.Name = "Players VS BOSS"
GM.Author = "By Ancient Entity & Friends"
GM.Config = {}
PVB = {}

DeriveGamemode("base")
DEFINE_BASECLASS("gamemode_base")

GM.Base = BaseClass

if SERVER then
	local JUMPING = {}

	function GM:StartMove( ply, move )
		
		-- Only apply the jump boost in FinishMove if the player has jumped during this frame
		-- Using a global variable is safe here because nothing else happens between SetupMove and FinishMove
		if bit.band( move:GetButtons(), IN_JUMP ) ~= 0 and bit.band( move:GetOldButtons(), IN_JUMP ) == 0 and ply:OnGround() then
			JUMPING[ply:SteamID()] = true
		end
		
	end

	function GM:FinishMove( ply, move )
		
		-- If the player has jumped this frame
		if JUMPING[ply:SteamID()] then
			-- Get their orientation
			local forward = move:GetAngles()
			forward.p = 0
			forward = forward:Forward()
			
			-- Compute the speed boost
			
			-- HL2 normally provides a much weaker jump boost when sprinting
			-- For some reason this never applied to GMod, so we won't perform
			-- this check here to preserve the "authentic" feeling
			local speedBoostPerc = ( ( not ply:Crouching() ) and 0.5 ) or 0.1
			
			local speedAddition = math.abs( move:GetForwardSpeed() * speedBoostPerc )
			local maxSpeed = move:GetMaxSpeed() * ( 1 + speedBoostPerc )
			local newSpeed = speedAddition + move:GetVelocity():Length2D()
			
			-- Clamp it to make sure they can't bunnyhop to ludicrous speed
			if newSpeed > maxSpeed then
				speedAddition = speedAddition - (newSpeed - maxSpeed)
			end
			
			/*-- Reverse it if the player is running backwards
			if move:GetVelocity():Dot(forward) < 0 then
				speedAddition = -speedAddition
			end*/
			
			-- Apply the speed boost
			move:SetVelocity(forward * speedAddition + move:GetVelocity())
		end
		
		JUMPING[ply:SteamID()] = nil
		
	end
end

AddCSLuaFile()
AddCSLuaFile("team_spectator.lua")
include("team_spectator.lua")
AddCSLuaFile("team_players.lua")
include("team_players.lua")
AddCSLuaFile("team_boss.lua")
include("team_boss.lua")
AddCSLuaFile("team_init.lua")
include("team_init.lua")
AddCSLuaFile("bosses/init.lua")
include("bosses/init.lua")
AddCSLuaFile("music/manifest.lua")
include("music/manifest.lua")
AddCSLuaFile("config/manifest.lua")
include("config/manifest.lua")
AddCSLuaFile("rounds/manifest.lua")
include("rounds/manifest.lua")
AddCSLuaFile("hud/manifest.lua")
include("hud/manifest.lua")
AddCSLuaFile("vgui/manifest.lua")
include("vgui/manifest.lua")
AddCSLuaFile("loadout/manifest.lua")
include("loadout/manifest.lua")/*
AddCSLuaFile("items/manifest.lua")
include("items/manifest.lua")*/
include("tutorial/sh_tutorial.lua")
AddCSLuaFile("tutorial/sh_tutorial.lua")
include("misc/manifest.lua")
//Hit indictators was only in for testing.
//include("hitindicator/server/sv_hitdamagenumbers.lua")
//include("hitindicator/client/cl_hitdamagenumbers.lua")
//AddCSLuaFile("hitindicator/client/cl_hitdamagenumbers.lua")
//include("ulx/manifest.lua")