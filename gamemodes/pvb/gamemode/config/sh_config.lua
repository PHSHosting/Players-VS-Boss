PVB.Config = {}

PVB.Config.MinPlayers = 2
PVB.Config.WeaponDropChance = 4 //Minimum 2

PVB.Config.DefaultItems = {
	{["weapon_pvb_ak47"] = 1, ["weapon_pvb_revolver"] = 1},			//Default
	{},												//Rarity 1
	{},												//Rarity 2
	{},												//Rarity 3
	{},												//Rarity 4
	{["weapon_fists"] = 1},							//Mele
	{["weapon_medkit"] = 1},						//Extra
	{/*["models/player/urban.mdl"] = {1, "Urban"}*/},	//Skins
}

PVB.Config.GenericWeapons = {"weapon_pvb_ak47","weapon_pvb_aug","weapon_pvb_fiveseven","weapon_pvb_mac10"}
PVB.Config.SpecialWeapons = {"weapon_pvb_famas","weapon_pvb_galil","weapon_pvb_glock","weapon_pvb_sg552","weapon_pvb_ump"}
PVB.Config.RareWeapons = {"weapon_pvb_deagle","weapon_pvb_m4a1","weapon_pvb_mp5navy","weapon_pvb_scout","weapon_pvb_xm1014"}
PVB.Config.ArcaneWeapons = {"weapon_pvb_awp","weapon_pvb_p90","weapon_pvb_tmp","weapon_pvb_usp"}