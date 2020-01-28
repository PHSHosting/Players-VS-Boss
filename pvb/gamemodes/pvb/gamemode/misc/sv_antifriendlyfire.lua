

function GM:PlayerShouldTakeDamage(ply, attacker)
	
	if(attacker:IsWeapon()) then
		if(ply:Team() == attacker:GetOwner():Team()) then
			return false
		end
	end
	return true
end