ENT.Base = "base_point"
ENT.Type = "point"
ENT.PrintName = "Gamemode State Transmitter"
AddCSLuaFile()
function ENT:Initialize()
	PVB.TRANSMITTER = self
end
function ENT:Think()
	if not IsValid(PVB.TRANSMITTER) and IsValid(self) then
		PVB.TRANSMITTER = self;
	end
end
function ENT:SetupDataTables()
	self:NetworkVar( "Int",	1, "RoundsPassed" );
	self:NetworkVar( "Int", 2, "BossInt" );
	self:NetworkVar( "Int",	4, "BossMaxHealth" );
		
	self:NetworkVar( "Float", 0, "TimeLeft" );
	
	self:NetworkVar( "Bool", 0, "RoundActive" );
		
	if ( SERVER ) then
		self:SetTimeLeft(-1);
		self:SetRoundsPassed(0);
		self:SetBossInt(-1);
		self:SetBossMaxHealth(0);
		self:SetRoundActive(false)
	end
end
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end
function ENT:KeyValue( key, value )
	if ( self:SetNetworkKeyValue( key, value ) ) then
		return
	end
end
function ENT:CanEditVariables( ply )
	return false;
end