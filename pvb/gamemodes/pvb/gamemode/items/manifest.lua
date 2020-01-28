PVB.ItemList = {}
function PVB:AddItem(tbl)
	table.insert(PVB.ItemList)
end

local ItemFiles,_ = file.Find("pvb/gamemode/bosses/*", "LUA")
for _,File in pairs(ItemFiles) do
	if File != "manifest.lua" then
		AddCSLuaFile(File)
		include(File)
	end
end