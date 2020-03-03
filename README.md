# Players VS Boss Gamemode

## Overview

Players VS Boss (PVB) is a round-based [Garry's Mod](https://store.steampowered.com/app/4000/Garrys_Mod/) gamemode in which a team of players fight against a boss played by a randomly selected player each round. Every round players can win new weapons that help them defeat more bosses!

### Features

:white_check_mark: 23 Custom PVB Weapons

:white_check_mark: 3 Included Bosses (Easily create more)

:white_check_mark: Easy Tutorial (F3)

:white_check_mark: Loadout system + Weapon Drops (F4)

:white_check_mark: Compatibility for Lower-end systems

:white_check_mark: [Working FastDL](https://steamcommunity.com/sharedfiles/filedetails/?id=1563809530/)

:white_check_mark: [Extensive Configuration](#configuration)

## Installation

1.  [Download the Repository](https://github.com/AncientEntity/PVBPublicRepository/archive/master.zip).

2.  Extract the `gamemodes/pvb/` directory from the downloaded archive (Using a file archiver utility such as [WinRAR](https://www.rarlab.com/) or [7-Zip](https://www.7-zip.org/)).

3.  Move the `gamemodes/pvb/` directory into the Server's `garrysmod/gamemodes/` directory.

4.  [Configure the gamemode](#configuration).

5.  Change the gamemode of the Server to `pvb`.

## Configuration

[`pvb/gamemode/config/sh_config.lua`](pvb/gamemodes/pvb/gamemode/config/sh_config.lua)

```Lua
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
```

## License

This project is licensed under the [MIT](./LICENSE.md) License &copy; 2019-2020 [Ancient Entity](https://github.com/AncientEntity/)
