local MyItems = {}

local CurPrimary = CreateClientConVar("pvb_primary", "weapon_pvb_ak47")
local CurSecondary = CreateClientConVar("pvb_secondary", "weapon_pvb_fiveseven")
local CurMele = CreateClientConVar("pvb_mele", "")
local CurExtra = CreateClientConVar("pvb_extra", "weapon_medkit")
local CurSkin = CreateClientConVar("pvb_skin", "")

local WeaponTypes = {	//List of tabs to create as weapon rarities.
	"Default",
	"Generic",
	"Special",
	"Rare",
	"Arcane",
	"Melee",
	"Extra",
	"Skins"
}

surface.CreateFont("PVB.LoadoutMenuTabs", {
	font = "Roboto-Medium",
	size = 35
})
surface.CreateFont("PVB.LoadoutMenuWeps", {
	font = "coolvetica",
	size = 20
})

net.Receive("PVB.SendLoadoutInfo", function(len)
	if IsValid(LoadoutMenu) then
		LoadoutMenu:Remove()
		return
	end
	MyItems = util.JSONToTable(net.ReadString())
	//PrintTable(MyItems)
	
	
	LoadoutMenu = vgui.Create("PVBMenu")
		LoadoutMenu:SetSize(ScrW()/4*3+10, ScrH()/8*7+10)
		LoadoutMenu:Center()
	
	
	LoadoutMenu.Div = vgui.Create("DPanel", LoadoutMenu)
		LoadoutMenu.Div:SetPos(0,80)
		LoadoutMenu.Div:SetSize(LoadoutMenu:GetWide(),LoadoutMenu:GetTall()-80)
		function LoadoutMenu.Div:Paint()//w,h)
			//surface.SetDrawColor(LoadoutMenu.BackColor)
			//surface.DrawRect(0,0,w,h)
		end
	
	
	local LeftSide = vgui.Create("DPanel", LoadoutMenu.Div)	//Holds rarity tabs
		LeftSide:SetSize(LoadoutMenu:GetWide() - 600, LoadoutMenu.Div:GetTall())
	LeftSide.Wep = vgui.Create("DPanel", LeftSide)			//Holds weapon tabs


	local RightSide = vgui.Create("PVBWeapons", LoadoutMenu.Div)
		RightSide:SetPos(LoadoutMenu:GetWide()-600,_)
		RightSide:SetSize(600, LoadoutMenu.Div:GetTall())
		
	local AdjustableModelPanel = vgui.Create( "DModelPanel", RightSide )
		AdjustableModelPanel:SetPos( 0, 0 )
		AdjustableModelPanel:SetSize(RightSide:GetWide() / 1.2,ScrW() / 5)
		AdjustableModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
		//AdjustableModelPanel:SetModel( "models/props_borealis/bluebarrel001.mdl" )
		AdjustableModelPanel:SetCamPos( Vector( -25, -25, -30 ) )
	
	
		
	
	//Rarity tabs
	local pos = 10
	for k,v in pairs(WeaponTypes) do
		local ListPnl = vgui.Create("DPanel", LeftSide)
		ListPnl:SetPos(0,pos-10)
		ListPnl:SetSize(LeftSide:GetWide()/2, 50)
		ListPnl.Col1 = Color(255,255,255,255)
		ListPnl.Col2 = Color(0,0,0,255)
		ListPnl.Tbl = MyItems[k]
		function ListPnl:Paint()
			surface.SetDrawColor(self.Col2)
			surface.DrawOutlinedRect(0,-2,LeftSide:GetWide()/2,self:GetTall())
		end
		function ListPnl:OnMousePressed()
			LeftSide.Wep:ChangeType(self.Tbl)
		end
		//ListPnl:SetBackgroundColor(Color(255,255,255,255))
		ListPnl.Lbl = vgui.Create("DLabel", LeftSide)
		ListPnl.Lbl:SetPos(10, pos)
		ListPnl.Lbl:SetSize(LeftSide:GetWide()/2-4, 25)
		ListPnl.Lbl:SetFont("PVB.LoadoutMenuTabs")
		ListPnl.Lbl:SetTextColor(Color(75,75,75,255))
		ListPnl.Lbl:SetText(v)
		pos = pos + 50
	end
	
	
	//Individual weapon tabs
	LeftSide.Wep:SetPos(LeftSide:GetWide()/2,_)
	LeftSide.Wep:SetSize(LeftSide:GetWide()/2, LeftSide:GetTall())
	function LeftSide.Wep:ChangeType(tbl)
		for k,v in pairs(self:GetChildren()) do
			v:Remove()
		end
		local pos = 1
		for k,v in pairs(tbl) do
		
			if(k != "BaseClass") then

			
				local ListPnl = vgui.Create("DPanel", LeftSide.Wep)
				ListPnl:SetPos(0,pos-5)
				ListPnl:SetSize(LeftSide:GetWide()/2, 30)
				ListPnl.Col1 = Color(255,255,255,255)
				ListPnl.Col2 = Color(0,0,0,255)
				ListPnl.Class = k
				function ListPnl:Paint()
					surface.SetDrawColor(self.Col2)
					surface.DrawOutlinedRect(0,-2,LeftSide:GetWide()/2,self:GetTall())
				end
				function ListPnl:OnMousePressed()
					RightSide.ActiveWeapon = k
					if type(v) == "table" then
						RightSide.ActiveWeapon = v[2]
					end
					//RightSide:Update()
					
					
					AdjustableModelPanel:SetModel(weapons.Get(RightSide.ActiveWeapon).WorldModel)
					
					if(IsValid(MainSelect)) then
						MainSelect:Remove()
					end
					if(IsValid(SecondSelect)) then
						SecondSelect:Remove()
					end
					local MainSelect = vgui.Create("DButton", RightSide)
						MainSelect:SetSize(RightSide:GetWide() / 2,RightSide:GetTall() / 12)
						MainSelect:SetPos(RightSide:GetWide()/4,RightSide:GetTall() / 1.3)
						MainSelect:SetFont("PVB.LoadoutMenuTitleTiny")
						MainSelect:SetColor(Color(0,0,0))
						if(CurPrimary:GetString() == RightSide.ActiveWeapon) then
							MainSelect:SetColor(Color(255,0,0))
						end
						MainSelect:SetText("Select Weapon As Primary")
					local SecondSelect = vgui.Create("DButton", RightSide)
						SecondSelect:SetSize(RightSide:GetWide() / 2,RightSide:GetTall() / 12)
						SecondSelect:SetPos(RightSide:GetWide()/4,RightSide:GetTall() / 1.15)
						SecondSelect:SetFont("PVB.LoadoutMenuTitleTiny")
						SecondSelect:SetColor(Color(0,0,0))
						if(CurSecondary:GetString() == RightSide.ActiveWeapon) then
							SecondSelect:SetColor(Color(255,0,0))
						end
						SecondSelect:SetText("Select Weapon As Secondary")
						SecondSelect.DoClick = function()
							CurSecondary:SetString(RightSide.ActiveWeapon)
							SecondSelect:SetColor(Color(255,0,0))
						end
					
					MainSelect.DoClick = function()
						CurPrimary:SetString(RightSide.ActiveWeapon)
						MainSelect:SetColor(Color(255,0,0))
					end
					
				end
				//ListPnl:SetBackgroundColor(Color(255,255,255,255))
				ListPnl.Lbl = vgui.Create("DLabel", LeftSide.Wep)
				ListPnl.Lbl:SetPos(5, pos)
				ListPnl.Lbl:SetSize(LeftSide:GetWide()/2-4, 25)
				ListPnl.Lbl:SetFont("PVB.LoadoutMenuWeps")
				ListPnl.Lbl:SetTextColor(Color(75,75,75,255))
				if string.Left(k, 7) != "models/" then
					if(k != "BaseClass") then
						ListPnl.Lbl:SetText(weapons.Get(k).PrintName)
					end
				else
					ListPnl.Lbl:SetText(v[2])
				end
				pos = pos + 25
				

			end
		end
	end
end)

surface.CreateFont( "TitleText", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "MessageFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


net.Receive("PVB.NotifyPlayerOfWinning", function()
	//Fix win sound later
	//sound.PlayFile("sound/congratulations.mp3", "noblock mono", function() congratsMusic)
	local notifier = vgui.Create("PVBMenuUsable")
		notifier:SetSize(ScrW() / 3, ScrH() / 2)
		notifier:Center()
		//notifier:SetTitle("Congratulations!")
		notifier:MakePopup()
		//notifier:SetDraggable(true)
		//notifier.OnClose = function()
		//	congratsMusic:Stop()
		//
		//end

	local congratsTitle = vgui.Create("DLabel", notifier)
		congratsTitle:SetFont("PVB.LoadoutMenuTitleSmall")
		congratsTitle:SetText("Congratulations")
		congratsTitle:SizeToContents()
		congratsTitle:SetPos(ScrW() / 2 / 7.5,70)
		//congratsTitle:CenterHorizontal()
	
	local message = vgui.Create("DLabel", notifier)
		message:SetFont("PVB.LoadoutMenuTitleTiny")
		//message:SetPos(ScrW() / 3 / 3,150)
		message:SetText(net.ReadString())
		message:SetSize(ScrW() / 4,200)
		message:SizeToContentsY()
		message:SetContentAlignment(5)
		message:Center()
	
	local AdjustableModelPanel = vgui.Create( "DModelPanel", notifier )
		AdjustableModelPanel:SetSize(ScrW() / 5.5, ScrH() / 5.5)
		AdjustableModelPanel:SetPos(ScrW() / 2, ScrH() / 3)
		AdjustableModelPanel:CenterHorizontal()
		AdjustableModelPanel:SetLookAt( Vector( 0, 0, 0 ) )
		AdjustableModelPanel:SetModel( weapons.Get(net.ReadString()).WorldModel )
		AdjustableModelPanel:SetCamPos( Vector( -25, 0, -30 ) )
	
end)


net.Receive("RequestWeaponConVar", function()
	net.Start("GrantedWeaponConVar")
		net.WriteString(GetConVar("pvb_primary"):GetString())
		net.WriteString(GetConVar("pvb_secondary"):GetString())
		net.WriteString(GetConVar("pvb_extra"):GetString())
	net.SendToServer()


end)



