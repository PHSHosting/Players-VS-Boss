local PANEL = {}

surface.CreateFont("PVB.WeaponDisplay1", {
	font = "Trebuchet MS",
	size = 30,
	weight = 700
})

function PANEL:Paint()

end

vgui.Register("PVBWeapons", PANEL, "DPanel")