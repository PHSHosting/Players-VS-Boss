
--[[ hook.Add("PVB.RoundFinished", "PVB.Music.End", function()
	net.Start("PVB.UpdateMusicState")
		net.WriteBool(false)
	net.Broadcast()
end)

hook.Add("PVB.State_Waiting", "PVB.Music.Waiting", function()
	net.Start("PVB.UpdateMusicState")
		net.WriteBool(false)
	net.Broadcast()
end)
 ]]
hook.Add("PVB.StartRound", "PVB.Music.StartSong", function()
	//print("ayy")
	net.Start("PVB.UpdateMusicState")
		net.WriteBool(true)
	net.Broadcast()
end)

for BName,Boss in pairs(PVB.BossList) do
	if type(Boss.Music) == "table" then
		for k,v in pairs(Boss.Music) do
			if string.Left(v, 4) != "http" then
				resource.AddSingleFile("sound/" .. v)
			end
		end
	end
end
