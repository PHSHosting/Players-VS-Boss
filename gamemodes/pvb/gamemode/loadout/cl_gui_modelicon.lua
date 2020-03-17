
//A DModelPanel which can be a white-overlaid model or an icon.

local PANEL = {}

AccessorFunc(PANEL,"WhiteMode","WhiteMode",FORCE_BOOL)
AccessorFunc(PANEL,"Icon","Icon")

function PANEL:Init()
	self:SetWhiteMode(true)
	self:SetFOV(1)
	self:SetAnimated(false)
end

function PANEL:SetModel(strModelName)
	-- Note - there's no real need to delete the old
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.Entity = ClientsideModel( strModelName, RENDERGROUP_OTHER )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )
	self.Entity:SetIK( false )
	
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end
	self.Entity:FrameAdvance(FrameTime())
	
	self:CenterCamera()
end

function PANEL:CenterCamera(dist)
	if not IsValid(self.Entity) then return end
	local PrevMins, PrevMaxs = self.Entity:GetRenderBounds()
	self:SetLookAt((PrevMaxs + PrevMins) / 2)
	self.dist = PrevMins:Distance(PrevMaxs) * (dist or .5)
end

function PANEL:SetIcon(i)
	if isstring(i) then
		self.Icon = Material(i,"smooth unlitgeneric")
	elseif type(i) == "IMaterial" then
		self.Icon = i
	end
end

local tbl = {
	type = "3D",
	ortho = {}
}
function PANEL:Paint( w, h )
	local icon = self:GetIcon()
	if icon then
		surface.SetMaterial(self.mat)
		surface.SetDrawColor(self.colColor)
		surface.DrawTexturedRect(0,0,w,h)
		
	elseif ( IsValid( self.Entity ) ) then
		local white = self:GetWhiteMode()
		local x, y = self:LocalToScreen( 0, 0 )

		self:LayoutEntity( self.Entity )

		local ang = self.aLookAngle
		if ( !ang ) then
			ang = ( self.vLookatPos - self.vCamPos ):Angle()
		end
		
		tbl.x = x
		tbl.y = y
		tbl.w = w
		tbl.h = h
		tbl.origin = self.vCamPos
		tbl.angles = ang
		tbl.zfar = self.FarZ
		local posi = self.dist * math.min(w/h,h/w)
		local nega = -posi
		tbl.ortho.top = nega
		tbl.ortho.bottom = posi
		tbl.ortho.left = nega
		tbl.ortho.right = posi
		
		-- tbl.ortho.left = -w/4
		-- tbl.ortho.top = -h/4
		-- tbl.ortho.right = w/4
		-- tbl.ortho.bottom = h/4
		cam.Start( tbl )
		-- cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
		render.SuppressEngineLighting( true )
		
		if !white then
			render.SetLightingOrigin( self.Entity:GetPos() )
			render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
			render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
			render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )
			for i = 0, 6 do
				local col = self.DirectionalLight[ i ]
				if ( col ) then
					render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
				end
			end
			
			self:DrawModel()
		else
			stencil.Enable(true)
			stencil.Clear()
			stencil.Mask(255)
			stencil.Reference(1)
			stencil.SetOperations(STENCIL_KEEP,STENCIL_REPLACE,STENCIL_REPLACE)
			stencil.Compare(STENCIL_NEVER)
			
			self:DrawModel()
		end
			
		
		render.SuppressEngineLighting( false )
		cam.End3D()
		
		//white overlay
		if white then
			stencil.SetOperations(STENCIL_REPLACE,STENCIL_KEEP,STENCIL_KEEP)
			stencil.Compare(STENCIL_EQUAL)
			
			surface.SetDrawColor(self.colColor)
			surface.DrawRect(0,0,w,h)
			
			stencil.Enable(false)
			stencil.Clear()
		end
		//debug
		-- surface.SetDrawColor(ColorAlpha(color_white,50))
		-- surface.DrawRect(0,0,w,h)
		
	end

	self.LastPaint = RealTime()

end

function PANEL:LayoutEntity(e)
	
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/props_junk/PlasticCrate01a.mdl" )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "ModelIcon", "A DModelPanel which can be a white-overlaid model or an icon.", PANEL, "DModelPanel" )
