AddCSLuaFile("cl_player.lua")
if SERVER then
	include("sv_musicdl.lua")
else
	include("cl_player.lua")
end