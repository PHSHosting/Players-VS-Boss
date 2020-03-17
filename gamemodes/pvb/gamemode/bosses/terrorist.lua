local BOSS = {}
BOSS.Num = 2 //Boss ID number. 1,2,3,etc if making a new boss make sure it increments in order!
BOSS.PName = "Terrorist" //Boss name
BOSS.Music = {
}
//Put music in BOSS.Music for it to play during fight. 'pvb_enablebossmusic' in console controls if its playing (client side)

function BOSS:Init()
	local ply = table.Random(player.GetAll())
	ply:SetTeam(TEAM_BOSS)
	ply.BossPlayerModel = "models/player/guerilla.mdl" //Bosses Model
end

//Include weapons/ammo/armor/etc in BOSS:Loadout
function BOSS:Loadout(ply)
	ply:SetHealth(#team.GetPlayers(TEAM_PLAYERS)*3800) //Health multiplier so health scales depending on player count
	ply:Give("bulletstorm")
	//ply:GiveAmmo(99999999,"Pistol", true)

end
PVB.RegisterBossClass(BOSS)