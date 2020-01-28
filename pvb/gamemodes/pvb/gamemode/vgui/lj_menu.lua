surface.CreateFont("PVB.LoadoutMenuTitle", {
	font = "Coolvetica",
	size = 80
})

surface.CreateFont("PVB.LoadoutMenuTitleSmall", {
	font = "Coolvetica",
	size = 55
})
surface.CreateFont("PVB.LoadoutMenuTitleTiny", {
	font = "Coolvetica",
	size = 18
})

local PANEL = {}

PANEL.Font = "PVB.LoadoutMenuTitle"
PANEL.TextCol = Color(255,255,255,255)
//PANEL.BackColor = Color(100,100,100,255)
PANEL.OutlineRad = 17

function PANEL:Init()
	self.StartTime = SysTime()
	self:MakePopup()
	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function ( button ) self:Remove() end
	timer.Simple(0,function()
		self.CloseButton:SetPos( self:GetWide() - 31 - 4, 0 )
		self.CloseButton:SetSize( 31, 31 )
		self.CloseButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end
	end)
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.StartTime)
	DisableClipping(true)
	local a = 255
	for i=15,1,-1 do
		a = math.Approach(a, 0, 2)
		draw.RoundedBox(self.OutlineRad, -i/2,-i,self:GetWide()+i,self:GetTall()+i*1.5,Color(100-i*2,100-i*2,100-i*2,a))
	end
	DisableClipping(false)
	//surface.SetDrawColor(self.BackColor)
	//surface.DrawRect(0,0,w,h)
	surface.SetTextColor(self.TextCol)
	surface.SetTextPos(10,2)
	surface.SetFont("PVB.LoadoutMenuTitle")
	surface.DrawText("Loadout")
end

vgui.Register("PVBMenu", PANEL, "DPanel")

local USABLELJPANEL = {}

USABLELJPANEL.Font = "PVB.LoadoutMenuTitle"
USABLELJPANEL.TextCol = Color(255,255,255,255)
//USABLELJPANEL.BackColor = Color(100,100,100,255)
USABLELJPANEL.OutlineRad = 17

function USABLELJPANEL:Init()
	self.StartTime = SysTime()
	self:MakePopup()
	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function ( button ) self:Remove() end
	timer.Simple(0,function()
		self.CloseButton:SetPos( self:GetWide() - 31 - 4, 0 )
		self.CloseButton:SetSize( 31, 31 )
		self.CloseButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end
	end)
end

function USABLELJPANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.StartTime)
	DisableClipping(true)
	local a = 255
	for i=15,1,-1 do
		a = math.Approach(a, 0, 2)
		draw.RoundedBox(self.OutlineRad, -i/2,-i,self:GetWide()+i,self:GetTall()+i*1.5,Color(100-i*2,100-i*2,100-i*2,a))
	end
	DisableClipping(false)
	//surface.SetDrawColor(self.BackColor)
	//surface.DrawRect(0,0,w,h)
	surface.SetTextColor(self.TextCol)
	surface.SetTextPos(10,2)
	surface.SetFont("PVB.LoadoutMenuTitle")
	//surface.DrawText("Loadout")
end

vgui.Register("PVBMenuUsable",USABLELJPANEL,"DPanel")


local USABLELJPANELNOTROUNDED = {}

USABLELJPANELNOTROUNDED.Font = "PVB.LoadoutMenuTitle"
USABLELJPANELNOTROUNDED.TextCol = Color(255,255,255,255)
//USABLELJPANELNOTROUNDED.BackColor = Color(100,100,100,255)
USABLELJPANELNOTROUNDED.OutlineRad = 17

function USABLELJPANELNOTROUNDED:Init()
	self.StartTime = SysTime()
	self:MakePopup()
	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function ( button ) self:Remove() end
	timer.Simple(0,function()
		self.CloseButton:SetPos( self:GetWide() - 31 - 4, 0 )
		self.CloseButton:SetSize( 31, 31 )
		self.CloseButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end
	end)
end

function USABLELJPANELNOTROUNDED:Paint(w, h)
	Derma_DrawBackgroundBlur(self, self.StartTime)
	//DisableClipping(true)
	local a = 255
	for i=15,1,-1 do
		a = math.Approach(a, 0, 2)
		draw.RoundedBox(self.OutlineRad, -i/2,-i,self:GetWide()+i,self:GetTall()+i*1.5,Color(100-i*2,100-i*2,100-i*2,a))
	end
	//DisableClipping(false)
	//surface.SetDrawColor(self.BackColor)
	//surface.DrawRect(0,0,w,h)
	surface.SetTextColor(self.TextCol)
	surface.SetTextPos(10,2)
	surface.SetFont("PVB.LoadoutMenuTitle")
	//surface.DrawText("Loadout")
end

vgui.Register("PVBMenuUsableNotRounded",USABLELJPANELNOTROUNDED,"DPanel")








local LJPANELBUTTON = {}

LJPANELBUTTON.Font = "PVB.LoadoutMenuTitle"
LJPANELBUTTON.TextCol = Color(255,255,255,255)
//LJPANELBUTTON.BackColor = Color(100,100,100,255)
LJPANELBUTTON.OutlineRad = 17

function LJPANELBUTTON:Init()
	self.StartTime = SysTime()
	self:MakePopup()
--[[ 	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function ( button ) self:Remove() end ]]
--[[ 	timer.Simple(0,function()
		self.CloseButton:SetPos( self:GetWide() - 31 - 4, 0 )
		self.CloseButton:SetSize( 31, 31 )
		self.CloseButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end
	end) ]]
end

function LJPANELBUTTON:Paint(w, h)
	//Derma_DrawBackgroundBlur(self, self.StartTime)
	//DisableClipping(true)
	local a = 255
	for i=15,1,-1 do
		a = math.Approach(a, 0, 2)
		draw.RoundedBox(self.OutlineRad, -i/2,-i,self:GetWide()+i,self:GetTall()+i*1.5,Color(150-i*2,150-i*2,150-i*2,a))
	end
	//DisableClipping(false)
	//surface.SetDrawColor(self.BackColor)
	//surface.DrawRect(0,0,w,h)
	surface.SetTextColor(self.TextCol)
	surface.SetTextPos(10,2)
	surface.SetFont("PVB.LoadoutMenuTitle")
	//surface.DrawText("Loadout")
end

vgui.Register("PVBButton",LJPANELBUTTON,"DButton")







