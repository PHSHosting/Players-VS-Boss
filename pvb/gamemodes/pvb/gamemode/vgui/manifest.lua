AddCSLuaFile("lj_menu.lua")
AddCSLuaFile("lj_display.lua")
if CLIENT then
	include("lj_menu.lua")
	include("lj_display.lua")
end