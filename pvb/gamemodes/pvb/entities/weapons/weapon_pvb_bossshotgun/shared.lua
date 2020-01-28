
AddCSLuaFile()
SWEP.Author						= "Ancient Entity & Friends"
SWEP.Base						= "weapon_base"
SWEP.PrintName					= "Shotgun"
SWEP.Instructions				= [[Default PVB Weapon]]

SWEP.ViewModel             = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel            = "models/weapons/w_shotgun.mdl"
SWEP.ViewModelFlip				= false
SWEP.UseHands					= true
SWEP.SetHoldType				= "ar2"

SWEP.Weight						= 8
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= false

SWEP.Slot						= 2
SWEP.SlotPos					= 0

SWEP.DrawAmmo					= false
SWEP.DrawCrosshair				= true

SWEP.Spawnable					= false
SWEP.AdminSpawnable				= true

SWEP.ShouldDropOnDie = false

SWEP.Primary.ClipSize			= 8
SWEP.Primary.DefaultClip		= 89
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= true
SWEP.Primary.Recoil				= 8
SWEP.Primary.Damage				= 18
SWEP.Primary.NumShots			= 5
SWEP.Primary.Spread				= 0.11
SWEP.Primary.Cone				= 0.11
SWEP.Primary.Delay				= 0.8

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false

local ShootSound = Sound("Weapon_XM1014.Single")


function SWEP:Initialize()
	
end

function SWEP:PrimaryAttack()
	if(not self:CanPrimaryAttack()) then
		return
	end
	
	local ply = self:GetOwner()
	
	ply:LagCompensation(true)
	
	local Bullet = {}
		Bullet.Num		=	self.Primary.NumShots
		Bullet.Src		=	ply:GetShootPos()
		Bullet.Dir		=	ply:GetAimVector()
		Bullet.Spread	=	Vector(self.Primary.Spread,self.Primary.Spread,0)
		Bullet.Tracer	=	0
		Bullet.Damage	=	self.Primary.Damage
		Bullet.AmmoType =	self.Primary.Ammo
	
	self:FireBullets(Bullet)
	self:ShootEffects()
	self:EmitSound( ShootSound )
	//self:BaseClass.ShootEffects()
	
	self.Owner:ViewPunch(Angle(-self.Primary.Recoil,0,0))
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	
	ply:LagCompensation(false)
end


SWEP.Secondary.ScopeLevel = 0
function SWEP:SecondaryAttack()
	if(self.Secondary.ScopeLevel == 0) then
 
		if(SERVER) then
			self.Owner:SetFOV( 25, 0 )
		end	
 
		self.Secondary.ScopeLevel = 1
 
	else if(self.Secondary.ScopeLevel == 1) then
 
		if(SERVER) then
			self.Owner:SetFOV( 0, 0 )
		end	
 
		self.Secondary.ScopeLevel = 0

	end
	end
end

function SWEP:CanSecondaryAttack()
	return false
end










