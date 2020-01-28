PVB.BossList = {}
local P = 0

function PVB.RegisterBossClass(tbl)
	P = P + 1
	PVB.BossList[P] = {}
	PVB.BossList[P].Init = tbl.Init
	PVB.BossList[P].Loadout = tbl.Loadout
	PVB.BossList[P].OnSpawn = tbl.OnSpawn
	PVB.BossList[P].Music = tbl.Music
end

local BossFiles,_ = file.Find("pvb/gamemode/bosses/*", "LUA")
for _,File in pairs(BossFiles) do
	if File != "init.lua" then
		AddCSLuaFile(File)
		include(File)
	end
end