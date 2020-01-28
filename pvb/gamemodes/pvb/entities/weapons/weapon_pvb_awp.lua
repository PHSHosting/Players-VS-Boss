AddCSLuaFile()
SWEP.Author						= "Ancient Entity & Friends"
SWEP.Base						= "weapon_base"
SWEP.PrintName					= "AWP"
SWEP.Instructions				= [[Default PVB Weapon]]

SWEP.ViewModel			= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_awp.mdl"
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

SWEP.Primary.ClipSize			= 5
SWEP.Primary.DefaultClip		= 5
SWEP.Primary.Ammo				= "357"
SWEP.Primary.Automatic			= false
SWEP.Primary.Recoil				= 12
SWEP.Primary.Damage				= 1200
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.00001
SWEP.Primary.Cone				= 0.00001
SWEP.Primary.Delay				= 1.4

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Automatic		= false

SWEP.Secondary.ScopeLevel = 0

local ShootSound = Sound("weapons/awp/awp1.wav")


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
	return true
end






