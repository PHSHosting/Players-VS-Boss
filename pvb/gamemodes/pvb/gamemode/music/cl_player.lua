local SongCache = SongCache or {}
local ActiveSong = ActiveSong or nil

//Temp changed boss music to false by default until further notice
local EnableSongs = CreateClientConVar("pvb_enablebossmusic", 0, true, false, "Set to 0 to disable music, 1 to enable music. Clientside only.")

cvars.AddChangeCallback("pvb_enablebossmusic", function(cvar, old, new)
	local BossInt = PVB.TRANSMITTER:GetBossInt()
	if tonumber(new) != 0 and BossInt == -1 then return end
	if tonumber(new) == 0 then
		PVB:FadeMusic()
	else
		PVB:ChangeMusic(true, BossInt)
	end
end, "PVB.OnMusicToggled")

function PVB:FadeMusic()
	if !ActiveSong then return end
	if timer.Exists("PVB.MusicNewTrack") then
		timer.Remove("PVB.MusicNewTrack")
	end
	local End = 0
	local Vol = 5//stationinfo:GetVolume() //SongCache[ActiveSong]:GetVolume()
	
	//HOPEFULLY ADD FADING MUSIC LATER BUT CURRENTLY ITS LOW PRIORIY
	
	-- timer.Create("PVB.FadeMusic", 0.1, 10, function()
		-- Vol = math.Approach(Vol, End, 0.1)
		-- SongCache[ActiveSong]:SetVolume(Vol)
	-- end)
	-- timer.Simple(1, function()
		-- SongCache[ActiveSong]:SetTime(0)
		-- SongCache[ActiveSong]:Pause()
	-- end)
end

//stationinfo = ""

function PVB:ChangeMusic(Play, BossID)
	if Play and EnableSongs:GetBool() and BossID != -1 then
		local SongList = PVB.BossList[BossID].Music
		ActiveSong = math.random(#SongList)
		if !SongCache[ActiveSong] then
			if string.Left(SongList[ActiveSong], 4) != "http" then
				sound.PlayFile("sound/"..SongList[ActiveSong], "noblock mono", function(stationinfo)//stationinfo[0], EID, EName)
					stationinfo:SetVolume( 5 )
					//stationinfo[0]:EnableLooping(true)
					SongCache[ActiveSong] = "sound/"..SongList[ActiveSong]
					timer.Create("PVB.MusicNewTrack", SoundDuration("sound/"..SongList[ActiveSong]), 1, function()
						stationinfo:SetTime(0)
						stationinfo:Pause()
						PVB:ChangeMusic(true, BossID)
					end)
				end)
			else
				sound.PlayURL(SongList[ActiveSong], "noblock mono", function(stationinfo)
					stationinfo:SetVolume( 5 )
					//stationinfo[0]:EnableLooping(true)
					SongCache[ActiveSong] = "sound/"..SongList[ActiveSong]
					timer.Create("PVB.MusicNewTrack", SoundDuration("sound/"..SongList[ActiveSong]), 1, function()
						stationinfo[0]:SetTime(0)
						stationinfo[0]:Pause()
						PVB:ChangeMusic(true, BossID)
					end)
				end)
			end
		else
			//SongCache[ActiveSong]:SetTime(0)
			//SongCache[ActiveSong]:Play()
			//SongCache[ActiveSong]:SetVolume(5)
			
			sound.PlayFile("sound/"..SongList[ActiveSong], "noblock mono", function(stationinfo)
			
				timer.Create("PVB.MusicNewTrack", SoundDuration("sound/"..SongList[ActiveSong]), 1, function()
					stationinfo:SetVolume( 5 )
					stationinfo:SetTime(0)
					stationinfo:Pause()
					PVB:ChangeMusic()
				end)
			end)
		end
	else
		//PVB:FadeMusic()
	end
end

net.Receive("PVB.UpdateMusicState", function(len)
	local DoSong = net.ReadBool()
	local BossID = PVB.TRANSMITTER:GetBossInt()
	PVB:ChangeMusic(DoSong, BossID)
end)

hook.Add("InitPostEntity", "PVB.Music.OnJoin", function()
	timer.Simple(0, function()
		local BossID = PVB.TRANSMITTER:GetBossInt()
		PVB:ChangeMusic(true, BossID)
	end)
end)




hook.Add("PlayerSay","PVB.MusicToggleCommand", function(  ply, text,  teamChat )
	if(ply == LocalPlayer()) then
		if(text == "!music") then
			if(EnableSongs:GetInt() == 1) then
				RunConsoleCommand( "pvb_enablebossmusic 0")
			
			end
			if(EnableSongs:GetInt() == 0) then
				RunConsoleCommand( "pvb_enablebossmusic 0")
			
			end
			print("Music Toggled")
		end
	end
end)


