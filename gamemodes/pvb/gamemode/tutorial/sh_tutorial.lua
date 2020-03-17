


if SERVER then
	util.AddNetworkString("PVB.TutorialMenuOpen")
	function GM:ShowSpare1(ply)
		net.Start("PVB.TutorialMenuOpen")
		net.Send(ply)
	end
	
	hook.Add("PlayerInitialSpawn","PVB.OpenTutorialFirstTime", function(ply)
	
		if(ply:GetPData("PVB.HASJOINEDBEFORE",false) == false) then
		
			net.Start("PVB.TutorialMenuOpen")
			net.Send(ply)
			ply:SetPData("PVB.HASJOINEDBEFORE",true)
		end
	end)

end

if CLIENT then
	main = nil
	
	
	 net.Receive("PVB.TutorialMenuOpen", function()
		//print("Net Recieved")
		
			
		local main = vgui.Create("PVBMenuUsableNotRounded")
			//main:SetTitle("Tutorial")
			main:SetSize(500,500)
			main:Center()
			//main:SetTitle("Tutorial")
			main:MakePopup()

	 
		local tutorialImage = vgui.Create("DImage",main)
			tutorialImage:SetImage("materials/images/tutorial1.png")
			tutorialImage:SetSize(485,485)
			tutorialImage:Center()
	 
	 

 
	 
	 end)





end