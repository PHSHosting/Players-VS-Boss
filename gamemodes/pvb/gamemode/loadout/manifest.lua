AddCSLuaFile("cl_loadoutmenu.lua")

if SERVER then
	include("sv_data.lua")
else
	include("cl_loadoutmenu.lua")
end