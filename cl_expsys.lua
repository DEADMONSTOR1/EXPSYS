if SERVER then return end

if game.SinglePlayer() then
	return
	else

	--[[---------------------------------------------------------
	   Name: Update()
	   Desc: Updates all the data on the client.
	-----------------------------------------------------------]]
	local XPSYS = {}
	function XPSYS.Update(len)
		LeaderBoards = {}
		LeaderBoards = net.ReadTable()
	end
	net.Receive("UpdateClients", XPSYS.Update)

	--[[---------------------------------------------------------
	   Name: XPBarDraw()
	   Desc: Experience bar drawing function.
	---------------------------------------------------------]]
	-- function hud() -- Consider functions like a cyber button, and everything INSIDE the function turns on when this cyber button is pressed.
		-- local vel = math.Round( LocalPlayer():GetVelocity():Length2D() )
		-- local hp = math.Round( LocalPlayer():Health() )	
		-- draw.RoundedBox( 0, 5, ScrH() - 40, 250, 7, Color( 0, 0, 0, 200 ) )
		-- draw.RoundedBox( 0, 5, ScrH() - 40, math.Clamp( vel, 0, 1000 ) * 0.25, 7, Color( 150, 0, 0, 255 ) )
		
		
		-- draw.RoundedBox( 0, 5, ScrH() - 70, 250, 30, Color( 0, 0, 0, 200 ) )
		-- draw.RoundedBox( 0, 5, ScrH() - 70, math.Clamp( hp, 0, 100 ) * 2.5, 30, Color( 250, 0, 0, 255 ) ) 
		-- //draw.DrawText(hp , "Default" , ScrW() / 10 - 13 , ScrH() - 62 , Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER )
	-- end 
	-- hook.Add("HUDPaint", "MyHudName", hud) -- I'll explain hooks and functions in a second
	/*
	function XPBarDraw()
			draw.RoundedBox( 7,  ScrW()/4, ScrH()/1.08, ScrW()/2, 20, Color(255,174,26,200) )
			local XPOfNextLevel = XPTable[(LocalPlayer():GetNWInt("Level", 1) + 1)] 
			local ratio = LocalPlayer():GetNWInt("XP", 0) / XPOfNextLevel

			if ratio <= 0.01 then
				ratio = 0.01
			end
			
			if ratio <= 0.98 then
				draw.RoundedBoxEx( 7,ScrW()/4, ScrH()/1.08, (ScrW()/2) * ratio, 20, Color(26,107,255,255),true,false,true,false)
			else
				draw.RoundedBox( 7,ScrW()/4, ScrH()/1.08, (ScrW()/2) * ratio, 20, Color(26,107,255,255), true,false,true,false)
			end

	end

	hook.Add( "HUDPaint", "Experience Bar", XPBarDraw )
	*/
	/*
	hook.Add( "HUDPaint", "LevelDraw", function()
		draw.DrawText( "Level: "..level, "DermaLarge", ScrW() * 0.07 , ScrH() * 0.85, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end )
	*/

	XPSYS = {}

	function XPSYS.CreateXPGuildLines()
		XPTable = {1}
		for i=1,99 do
			table.insert(XPTable, i * 100)
		end
	end
	hook.Add( "Initialize", "CreateXPGuildLines", XPSYS.CreateXPGuildLines )

	XPSYS.CreateXPGuildLines()

	function XPSYS.CreateXPGuildLines2()
		XPTable2 = {1}
		for i=1,99 do do
			if i == 1 then
				table.insert(XPTable2, XPTable2[1] + i * 100)
			else
				table.insert(XPTable2, XPTable2[i] + i * 100)
			end
		end
		
	end
	end
	hook.Add( "Initialize", "CreateXPGuildLines", XPSYS.CreateXPGuildLines2 )

	XPSYS.CreateXPGuildLines2()
	local function dostuff( um )
		local ply = um:ReadEntity()
		local em = ParticleEmitter(ply:GetPos())
			for i=0, 10 do
				local part = em:Add( "effects/spark", ply:GetPos() + VectorRand()*math.random(-100,100) + Vector(math.random(1,10),math.random(1,10),math.random(0,175)) )
				part:SetAirResistance( 100 )
				part:SetBounce( 0.3 )
				part:SetCollide( true )
				part:SetColor( 255, 122 , 255 ,255 )
				part:SetDieTime( 6 )
				part:SetEndAlpha( 0 )
				part:SetEndSize( 0 )
				part:SetGravity( Vector( 0, 0, -100 ) )
				part:SetRoll( math.Rand(0, 360) )
				part:SetRollDelta( math.Rand(-7,7) )    
				part:SetStartAlpha( math.Rand( 80, 250 ) )
				part:SetStartSize( math.Rand(6,12) )
				part:SetVelocity( VectorRand() * 95 )
			end
		em:Finish()
	end

	usermessage.Hook("LevelUP", dostuff)

	local function dostuff2( um )
		local ply = um:ReadEntity()
		local em = ParticleEmitter(ply:GetPos())
			for i=0, 1000 do
				local part = em:Add( "effects/spark", ply:GetPos() + VectorRand()*math.random(-100,100) + Vector(math.random(1,10),math.random(1,10),math.random(0,175)) )
				part:SetAirResistance( 150 )
				part:SetBounce( 0.3 )
				part:SetCollide( true )
				part:SetColor( 255, 122 , 122 ,255 )
				part:SetDieTime( 6 )
				part:SetEndAlpha( 0 )
				part:SetEndSize( 0 )
				part:SetGravity( Vector( 0, 0, -100 ) )
				part:SetRoll( math.Rand(0, 360) )
				part:SetRollDelta( math.Rand(-7,7) )    
				part:SetStartAlpha( math.Rand( 80, 250 ) )
				part:SetStartSize( math.Rand(6,12) )
				part:SetVelocity( VectorRand() * 95 )
			end
		em:Finish()
	end

	usermessage.Hook("LevelUPP", dostuff2)


	function XPSYS.OpenIt()

		LocalPlayer():ConCommand("CheckXP")
		-- Will add this later in time
		
	end
	hook.Add("OnContextMenuOpen" , "CheckXPOpen" , XPSYS.OpenIt)

	function XPSYS.GetMaxLevel()
		return tonumber(XPTable[#XPTable])
	end


	function XPSYS.NextLevelXP( ply )
		local level = ply:GetNWInt("Level", 1)
		if level > #XPTable then
			return XPTable[#XPTable]
		else
			return XPTable[level + 1]
		end
	end


	function XPSYS.MyLevelXP( ply )
		local level = ply:GetNWInt("Level", 0)
		return XPTable[level]
	end

	function XPSYS.XPBar()
		-- Notification panel
		expbar = vgui.Create( "DNotify" )
		expbar:SetPos( ScrW() / 2 - 250, ScrH() - 70 )
		expbar:SetSize( 525, 40 )
		expbar:SetLife( 3 )
		
		-- Gray background panel
		local bg = vgui.Create( "DPanel", expbar )
		bg:Dock( FILL )
		bg:SetBackgroundColor( Color( 64, 64, 64 ) )
		bg.Paint = function(self, w ,h)
			local test = LocalPlayer():GetNWInt("XP" , 0) / (XPSYS.NextLevelXP(LocalPlayer()) or 9900)
			draw.RoundedBox(4,0,0,525,40,Color(66,66,66))
			if test > 0.01 then
				draw.RoundedBox(4,3,3, test * 520 ,34,Color(0,146,219))
			end
			local test = (XPSYS.NextLevelXP(LocalPlayer()) )
			local test2 = LocalPlayer():GetNWInt("XP", 0 ) 
			if test == nil then
				draw.SimpleText("100".."%", "FontEXPBar" , 525 / 2 - 15 , 7 , Color(255,255,255,255))
			else
				draw.SimpleText(math.Round(tonumber(test2) / tonumber(test) * 100 ) .."%", "FontEXPBar" , 525 / 2 - 15 , 7 , Color(255,255,255,255))
			end
		end
		
		-- Add the background panel to the notification
		expbar:AddItem( bg )

	end
	concommand.Add("CheckXP", XPSYS.XPBar)

	surface.CreateFont( "FontEXPBar", {
		font = "CloseCaption_Normal",
		extended = false,
		size = 25,
		weight = 1000,
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

	surface.CreateFont( "LeaderBoard", {
		font = "CloseCaption_Normal",
		extended = false,
		size = 15,
		weight = 1000,
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


	function XPSYS.DrawLeaderboard()
		local Tables = {}
		LBPanel = vgui.Create( "DFrame" )
		local Scrw = ScrW()
		local Scrh = ScrH()
		local left = Scrw * 0.1
		local top = Scrh * 0.1
		local wide = Scrw * 0.8 + 16
		local tall = math.Clamp( 52 + ( 17 * 40 ), 0, Scrh * 0.8 )
		
		LBPanel:SetPos( left,top ) -- Position form on your monitor
		LBPanel:SetSize( wide,tall ) -- Size form
		LBPanel:SetTitle( "" ) -- Form set name
		LBPanel:SetVisible( true ) -- Form rendered ( true or false )
		LBPanel:SetDraggable( false ) -- Form draggable
		LBPanel:ShowCloseButton( false ) -- Show buttons panel
		
		-------------------------------------------------------------------
		
		local Tabs = vgui.Create( "DPropertySheet", LBPanel )
		Tabs:SetPos( 0,0 )
		Tabs:SetSize( wide, tall )
		
		local PlayerLists = vgui.Create( "DListView", Tabs )
		PlayerLists:SetMultiSelect( false )
		PlayerLists:AddColumn( "Name" )
		PlayerLists:AddColumn( "SteamID" )
		PlayerLists:AddColumn( "XP" )
		PlayerLists:AddColumn( "Level" )
		PlayerLists:AddColumn( "Total XP Gained" )
		PlayerLists:AddColumn( "Prestige" )
		PlayerLists.OnRowSelected  = function(parent,selected) 
			SetClipboardText( "Name: " .. PlayerLists:GetLine(selected):GetValue(1) .. " Level: ".. PlayerLists:GetLine(selected):GetValue(4).. " Prestige: ".. PlayerLists:GetLine(selected):GetValue(6))
		end

		for k, ply in pairs(player.GetAll()) do
			local steamID = ply:SteamID()
			if steamID == "NULL" then
				steamID = "BOT" 
			end
			PlayerLists:AddLine(ply:Nick() , steamID , ply:GetNWInt("XP" , 0) , ply:GetNWInt("Level" , 1),  0 * (ply:GetNWInt("Prestige" , 1) - 1 ) + XPTable2[ply:GetNWInt("Level" , 1)] or XPTable2[#XPTable2] + ply:GetNWInt("XP" , 0) , ply:GetNWInt("Prestige", 1) )
		end
		Tabs:AddSheet( "Online Leaderboard", PlayerLists, "icon16/medal_gold_1.png" )
		
		-------------------------------------------------------------------
		
		local PlayerLists2 = vgui.Create( "DListView", Tabs2 )
		PlayerLists2:SetMultiSelect( false )
		PlayerLists2:AddColumn( "SteamID" )
		PlayerLists2:AddColumn( "XP" )
		PlayerLists2:AddColumn( "Level" )
		PlayerLists2:AddColumn( "Total XP Gained" )
		PlayerLists2:AddColumn( "Prestige" )
		PlayerLists2.OnRowSelected  = function(parent,selected) 
			SetClipboardText("STEAMID: ".. PlayerLists2:GetLine(selected):GetValue(1) .. " Level: ".. PlayerLists2:GetLine(selected):GetValue(3).. " Prestige: ".. PlayerLists2:GetLine(selected):GetValue(5))
		end
		local LeaderBoards = LeaderBoards or {}
		for k, ply in pairs(LeaderBoards) do
			local test = LeaderBoards[k]
			PlayerLists2:AddLine(test.SteamID , test.XP , test.Level , XPTable2[tonumber(test.Level)] or 0 + test.XP , test.Prestige)
		end
		
		Tabs:AddSheet( "Offline Leaderboard", PlayerLists2, "icon16/medal_gold_2.png" )
		
		-------------------------------------------------------------------
		
		local UserSettingsPanel = vgui.Create( "DPanel", Tabs )
		
		local ColorMixer = vgui.Create( "DLabel", UserSettingsPanel )
		ColorMixer:SetPos( 110, 100 )
		ColorMixer:SetSize(300 , 20)
		ColorMixer:SetTextColor(Color(255, 0 ,0,255))
		ColorMixer:SetFont("LeaderBoard")
		//ColorMixer:SetText( "Select the color of the leaderboard here!" )
		ColorMixer:SetText( "More Coming Soon!" )

	--[[ 	local Mixer = vgui.Create( "DColorMixer", UserSettingsPanel )
		//Mixer:Dock( FILL )			--Make Mixer fill place of Frame
		Mixer:SetColor( Color( 30, 100, 160 ) )
		Mixer:SetPos(30 , 60)
		Mixer.ValueChanged = function(self, color) 
			UserSettingsPanel:SetBackgroundColor(Color(color.r , color.g , color.b))
			end ]]
			
		local Prestige = vgui.Create( "DButton", UserSettingsPanel )
		Prestige:SetPos( 40, 20 )
		Prestige:SetText( "Prestige!" )
		Prestige:SetSize( 270, 30 )
		Prestige.DoClick = function()
			RunConsoleCommand("Prestige")
		end
			
		local ResetMyPrestige = vgui.Create( "DButton", UserSettingsPanel )
		ResetMyPrestige:SetPos( 40, 60 )
		ResetMyPrestige:SetText( "Reset My Prestige!" )
		ResetMyPrestige:SetSize( 270, 30 )
		ResetMyPrestige.DoClick = function()
			RunConsoleCommand("ResetMyPrestige")
		end

		Tabs:AddSheet( "Settings!", UserSettingsPanel, "icon16/wrench.png" )
		
		
		
		-------------------------------------------------------------------
		
		if LocalPlayer():IsSuperAdmin() then 
			local AdminPanel = vgui.Create( "DPanel", Tabs )
			Tabs:AddSheet( "Super Admin Settings!", AdminPanel, "icon16/wrench_orange.png" )
			
			local ResetAll = vgui.Create( "DButton", AdminPanel )
			ResetAll:SetPos( 40, 20 )
			ResetAll:SetText( "Reset ALL Users on the server at the moment!" )
			ResetAll:SetSize( 270, 30 )
			ResetAll.DoClick = function()
				net.Start("ResetAll")
					net.WriteString("ATM")
				net.SendToServer()
			end
			
			local GiveXP = vgui.Create( "DButton", AdminPanel )
			GiveXP:SetPos( 40, 60 )
			GiveXP:SetText( "Give XP to all the players on the server at the moment!" )
			GiveXP:SetSize( 270, 30 )
			GiveXP.DoClick = function()
				net.Start("GiveXP")
				net.SendToServer()
			end
			
			local UpdateLeaderBoard = vgui.Create( "DButton", AdminPanel )
			UpdateLeaderBoard:SetPos( 40, 100 )
			UpdateLeaderBoard:SetText( "Update the leaderboards for all the players!" )
			UpdateLeaderBoard:SetSize( 270, 30 )
			UpdateLeaderBoard.DoClick = function()
				net.Start("UpdateAllLeaderBoards")
				net.SendToServer()
			end
		end
		
		-------------------------------------------------------------------

		local DButton = vgui.Create( "DButton", LBPanel )
		DButton:SetPos( wide - 37, 2 )
		DButton:SetText( "X" )
		DButton:SetSize( 35, 17 )
		DButton.DoClick = function()
			LBPanel:Remove()
		end
		
			
		LBPanel:MakePopup()
	end


	function XPSYS.DoLeaderboard( ply )
		XPSYS.DrawLeaderboard()
	end 

	keypressed = false
	function XPSYS.CheckKeys()
		if input.IsKeyDown( KEY_F2 ) and not keypressed then
			keypressed = true
			if IsValid(LBPanel) then
				LBPanel:Remove()
			else
				XPSYS.DoLeaderboard( LocalPlayer() )
			end
		elseif keypressed and not input.IsKeyDown( KEY_F2 ) then
			keypressed = false
		end
	end
	hook.Add("Think" , "LeaderBoard", XPSYS.CheckKeys)

	concommand.Add( "LeaderBoard", function( ply, cmd, args )	XPSYS.DoLeaderboard( ply ) end )
end
