
function GM:CanPlayerSuicide(ply)
	if(ply:IsSuperAdmin() or ply:IsAdmin()) then
		return true
	end
end