util.AddNetworkString("PVB.SendLoadoutInfo")

function GM:ShowTeam(ply)
	net.Start("PVB.SendLoadoutInfo")
	net.WriteString(PVB:GetItems(ply))
	net.Send(ply)
end