DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 
PLAYER.DisplayName			= "Spectator"
PLAYER.WalkSpeed 			= 260
PLAYER.RunSpeed				= 260
PLAYER.DuckSpeed			= 1

function PLAYER:CanRespawn()
	return false
end

player_manager.RegisterClass( "player_spectator", PLAYER, "player_default" )