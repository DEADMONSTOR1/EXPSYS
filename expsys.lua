--[[
	==================================================
				Made by DEADMONSTOR 	
	==================================================
]]--

if game.SinglePlayer() then
	error("[EXP SYSTEM] This addon is not for single player")
else
	if CLIENT then return end
	if SERVER then
		util.AddNetworkString( "UpdateClients" )
		util.AddNetworkString( "XPText" )
		util.AddNetworkString( "ResetAll" )
		util.AddNetworkString( "GiveXP" )
		util.AddNetworkString( "UpdateAllLeaderBoards" )
	end
	XPSYS = {}
	XPTable = {1}

	 --[[---------------------------------------------------------
	   Name: XPSYS.CreateXPGuildLines()
	   Desc: Makes the XPTable GuildLines
	-----------------------------------------------------------]]
	function XPSYS.CreateXPGuildLines()
		XPTable = {1}
		for i=1,99 do
			table.insert(XPTable, i * 100)
		end
	end
	hook.Add( "Initialize", "CreateXPGuildLines", XPSYS.CreateXPGuildLines )

	XPSYS.CreateXPGuildLines()

	 --[[---------------------------------------------------------
	   Name: XPSYS.CreateXPGuildLines()
	   Desc: Makes the XPTable GuildLines
	-----------------------------------------------------------]]
	function XPSYS.CreateXPGuildLines2()
		XPTable2 = {1}
		for i=1,99 do
			if i == 1 then
				table.insert(XPTable2, XPTable2[1] + i * 100)
			else
				table.insert(XPTable2, XPTable2[i] + i * 100)
			end
		end

	end
	hook.Add( "Initialize", "CreateXPGuildLines2", XPSYS.CreateXPGuildLines2 )

	XPSYS.CreateXPGuildLines2()
	 --[[---------------------------------------------------------
	   Name: InitializeXPTable()
	   Desc: Starts to make the Table if not there.
	-----------------------------------------------------------]]
	function XPSYS.InitializeXPTable()
		if( sql.Query( "SELECT SteamID,XP,Level FROM experience" ) == false ) then
			sql.Query( "CREATE TABLE experience( SteamID string UNIQUE, XP int, Level int, Prestige int )" )
			print( "XP table successfully made!" )
		end

		print( "XP table successfully initialized!" )
	end
	hook.Add( "Initialize", "Experience Table Initialization", XPSYS.InitializeXPTable )
	XPSYS.InitializeXPTable()
	--[[---------------------------------------------------------
	   Name: InitializePlayerInfo(player)
	   Desc: Checks if the XP table contains the proper columns and handles creating them.
	   Also updates the client initially when the player loads.
	-----------------------------------------------------------]]

	function XPSYS.InitializePlayerInfo( ply )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		local steamID = ply:SteamID()
		if( sql.Query( "SELECT * FROM experience WHERE SteamID = '"..steamID.."'" ) == nil ) then
			sql.Query("INSERT INTO experience ( SteamID, XP, Level, Prestige ) \
				VALUES ( '"..steamID.."', 0, 1 , 1)" )
			XPSYS.LeaderBoardUpdate(ply)
			ply:SetNWInt("XP" , tonumber(sql.QueryValue( "SELECT XP FROM experience WHERE SteamID = '"..steamID.."'" )))
			ply:SetNWInt("Level" , tonumber(sql.QueryValue( "SELECT Level FROM experience WHERE SteamID = '"..steamID.."'" )))
			ply:SetNWInt("Prestige" , tonumber(sql.QueryValue( "SELECT Prestige FROM experience WHERE SteamID = '"..steamID.."'" )))
		else
			ply:SetNWInt("XP" , tonumber(sql.QueryValue( "SELECT XP FROM experience WHERE SteamID = '"..steamID.."'" )))
			ply:SetNWInt("Level" , tonumber(sql.QueryValue( "SELECT Level FROM experience WHERE SteamID = '"..steamID.."'" )))
			ply:SetNWInt("Prestige" , tonumber(sql.QueryValue( "SELECT Prestige FROM experience WHERE SteamID = '"..steamID.."'" )))
		end	
	end
	hook.Add( "PlayerInitialSpawn", "Initializing The Player Info", XPSYS.InitializePlayerInfo )

	--[[---------------------------------------------------------
	   Name: AddXP(player, xp)
	   Desc: Adds XP to the player.
	-----------------------------------------------------------]]

	function XPSYS.AddXP( ply, xp )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		local steamID = ply:SteamID()
		local realxp = tonumber(ply:GetNWInt("XP" , 0))
		sql.Query( "UPDATE experience SET XP = '"..realxp.."' WHERE SteamID = '"..steamID.."'" )
		local reallevel = ply:GetNWInt("Level" , 0) 	
		ply:SetNWInt("XP", realxp + xp)
		XPSYS.UpdateThroughXP(ply, tonumber(ply:GetNWInt("XP" , 0)))
		ply:ConCommand("CheckXP" )
	end


	--[[---------------------------------------------------------
	   Name: SetXP(player, xp)
	   Desc: Sets the XP of the player.
	-----------------------------------------------------------]]

	function XPSYS.SetXP( ply, xp )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		ply:ConCommand("CheckXP" )
		local steamID = ply:SteamID()
		sql.Query( "UPDATE experience SET XP = '"..xp.."' WHERE SteamID = '"..steamID.."'" )
		ply:SetNWInt("XP", xp)
		XPSYS.UpdateThroughXP( ply, xp )
	end

	--[[---------------------------------------------------------
	   Name: AddLevels(player, level(s))
	   Desc: Add the level(s) to the player.
	-----------------------------------------------------------]]

	function XPSYS.AddLevels( ply, levels )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		ply:ConCommand("CheckXP" )
		local steamID = ply:SteamID()
		local newLevel = ply:GetNWInt("Level") + levels
		if newLevel > 100 then 
			newLevel = 100
		end
		sql.Query( "UPDATE experience SET Level = '"..newLevel.."' WHERE SteamID = '"..steamID.."'" )
		XPSYS.UpdateThroughLevel( ply, newLevel )
	end

	--[[---------------------------------------------------------
	   Name: SetLevel(player, level(s))
	   Desc: Sets the level(s) to the player selected.
	-----------------------------------------------------------]]

	function XPSYS.SetLevel( ply, level )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		local steamID = ply:SteamID()
		ply:ConCommand("CheckXP" )
		if level > 100 then 
			level = 100
		end
		sql.Query( "UPDATE experience SET Level = '"..level.."' WHERE SteamID = '"..steamID.."'" )
		XPSYS.UpdateThroughLevel( ply, level )
	end

	--[[---------------------------------------------------------
	   Name: GetLevel(player)
	   Desc: Returns the level of the player.
	-----------------------------------------------------------]]

	function XPSYS.GetLevel(ply)
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		return tonumber(ply:GetNWInt("Level", 1))
	end

	--[[---------------------------------------------------------
	   Name: GetXP(player)
	   Desc: Returns the XP of the player.
	-----------------------------------------------------------]]

	function XPSYS.GetXP(ply)
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		return tonumber(ply:GetNWInt("XP", 0))
	end

	--[[---------------------------------------------------------
	   Name: GetXPTotal(player)
	   Desc: Returns the total XP of the player.
	-----------------------------------------------------------]]

	function XPSYS.GetXPTotal(ply)
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		return tonumber(XPTable2[XPSYS.GetLevel(ply)])
	end


	--[[---------------------------------------------------------
	   Name: isPlayerMaxLevel(player)
	   Desc: Returns a boolean value on weather the player is the max level.
	-----------------------------------------------------------]]

	function XPSYS.isPlayerMaxLevel( ply )
		if !(ply:IsValid() and ply:IsPlayer()) then
			return 
		end
		local maxLevel = #XPTable
		if tonumber(XPSYS.GetLevel( ply )) >= maxLevel  then
			return true
		else
			return false
		end
	end

	--[[---------------------------------------------------------
	   Name: UpdateThroughXP(player, xp)
	   Desc: Utility function for updating the xp and taking into account any leveling up that happens in the process.
				Not meant to be used outside of this file without good reason.
	-----------------------------------------------------------]]

	function XPSYS.UpdateThroughXP( ply, xp )
		local steamID = ply:SteamID()
		if tonumber(XPSYS.GetLevel( ply )) > 99 then 
			ply:SendLua("notification.AddLegacy('You are max level. You should Prestige!', NOTIFY_GENERIC, 5);")
			ply:SetNWInt("XP" , XPTable[#XPTable])
			sql.Query( "UPDATE experience SET XP = '"..XPTable[#XPTable].."' WHERE SteamID = '"..steamID.."'" )
			return 
		end
		if !XPSYS.isPlayerMaxLevel(ply) then
			for k,v in pairs(XPTable) do 
				local xp = tonumber(ply:GetNWInt("XP" , 0))
				local xplevel = tonumber(XPSYS.GetLevel( ply ))
				local neededxp = XPTable[xplevel]
				xp = xp or 0
				neededxp = neededxp or 0
				if xp > neededxp then
					if tonumber(XPSYS.GetLevel( ply )) > 99 then 
							ply:SendLua("notification.AddLegacy('You are max level. You should Prestige!', NOTIFY_GENERIC, 5);")
							ply:SetNWInt("XP" , XPTable[#XPTable])
							ply:SetNWInt("Level", #XPTable)
							sql.Query( "UPDATE experience SET XP = '"..XPTable[#XPTable].."' WHERE SteamID = '"..steamID.."'" )
						return 
					end
					umsg.Start("LevelUP", ply)
						umsg.Entity(ply)
					umsg.End()
					ply:SendLua("notification.AddLegacy('You leveled up!', NOTIFY_GENERIC, 5);")
					ply:SetNWInt("XP", xp - neededxp)
					ply:SetNWInt("Level" , tonumber(XPSYS.GetLevel( ply )) + 1)
					sql.Query( "UPDATE experience SET Level = '"..tonumber(XPSYS.GetLevel( ply )).."' WHERE SteamID = '"..steamID.."'" )
					sql.Query( "UPDATE experience SET XP = '"..ply:GetNWInt("XP", 0).."' WHERE SteamID = '"..steamID.."'" )
				else
				
					break
				end
			end
		else
			ply:SetNWInt("XP" , XPTable[#XPTable])
			ply:SetNWInt("Level", #XPTable2)
		end
		--[[ if !isPlayerMaxLevel(ply) then
			if xp <= XPTable[GetLevel(ply) + 1] then
				-- We do this to make sure it does not send data that will register the 
				-- player as having more XP than the current level's max on the client side.
			end
			
			while xp >= XPTable[tonumber(ply:GetNWInt("Level", 0) + 1)] do
				sql.Query( "UPDATE experience SET Level = Level + 1 WHERE SteamID = '"..steamID.."'" )
				xp = xp - XPTable[1]
				sql.Query( "UPDATE experience SET XP = 0 WHERE SteamID = '"..steamID.."'")
				ply:SetNWInt("XP" , 0)
				ply:SetNWInt("Level", GetLevel(ply) + 1)
				umsg.Start("LevelUP", ply)
					umsg.Entity(ply)
				umsg.End()
				if isPlayerMaxLevel(ply) and xp > XPTable[#XPTable] then
					-- We check here in case the initial XP that was passed overflows the table but when we player received it
					-- they were not max level (e.x: Level 14 and receive enough xp to push them 3 levels over, which overflows table.)
					sql.Query( "UPDATE experience SET XP = '"..XPTable[#XPTable].."' WHERE SteamID = '"..steamID.."'")
					UpdateClient(ply , XPTable[#XPTable] , #XPTable)
					ply:SetNWInt("XP", XPTable[#XPTable] )
					ply:SetNWInt("Level", #XPTable)
					break
				end
			ply:SendLua("notification.AddLegacy('You leveled up!', NOTIFY_GENERIC, 5);")
			end
		else
			local maxXP = XPTable2[#XPTable2]
			if tonumber(GetXPTotal( ply ) ) > maxXP then
				--If max level and xp that was passed was over the max amaount
				sql.Query("UPDATE experience SET XP = '"..maxXP.."' WHERE SteamID = '"..steamID.."'")
				ply:SetNWInt("XP" , maxXP)
				ply:SetNWInt("Level", #XPTable2)
			else
				--If max level and xp passed was below or equal to the last levels xp max.

			end
		end ]]
		if xp > XPTable[#XPTable] then
			ply:SetNWInt("XP" , XPTable[#XPTable]) 
			local xp = ply:GetNWInt("XP" , 0)
			sql.Query("UPDATE experience SET XP = '"..xp.."' WHERE SteamID = '"..steamID.."'")
		end
	end

	--[[---------------------------------------------------------
	   Name: UpdateThroughLevel(player, xp)
	   Desc: Utility function for updating level.
				Not meant to be used outside of this file without good reason.
	-----------------------------------------------------------]]

	function XPSYS.UpdateThroughLevel( ply, level )
		local steamID = ply:SteamID()
		local maxLevel = #XPTable
		if level >= maxLevel then
			sql.Query("UPDATE experience SET Level = '"..maxLevel.."' WHERE SteamID = '"..steamID.."'")	
			ply:SetNWInt("Level", maxLevel)
			ply:SendLua("notification.AddLegacy('Your level is set to "..maxLevel.."!', NOTIFY_GENERIC, 5);")
		else
			sql.Query("UPDATE experience SET Level = '"..level.."' WHERE SteamID = '"..steamID.."'")
			ply:SetNWInt("Level", level)
			ply:SendLua("notification.AddLegacy('Your level is set to "..level.."!', NOTIFY_GENERIC, 5);")
		end
	end


	function XPSYS.Prestige(ply)
		if !(IsValid(ply)) then return end
		local steamID = ply:SteamID()
		if XPSYS.isPlayerMaxLevel(ply) then
			local prestige = tonumber(sql.QueryValue( "SELECT Prestige FROM experience WHERE SteamID = '"..steamID.."'" )) + 1 
			if !(prestige > 10) then 
				ply:SetNWInt("Prestige", ply:GetNWInt("Prestige", 1) + 1)
				sql.Query( "UPDATE experience SET Prestige = '"..tonumber(ply:GetNWInt("Prestige" , 1)).."' WHERE SteamID = '"..steamID.."'" )
				ply:SetNWInt("Level", 1)
				local level = ply:GetNWInt("Level", 1)	
				sql.Query("UPDATE experience SET Level = '"..level.."' WHERE SteamID = '"..steamID.."'")
				
				ply:SetNWInt("XP", 0)
				local xp = ply:GetNWInt("XP", 0)	
				sql.Query("UPDATE experience SET XP = '"..xp.."' WHERE SteamID = '"..steamID.."'")
				umsg.Start("LevelUPP", ply)
						umsg.Entity(ply)
				umsg.End()
				ply:SendLua("notification.AddLegacy('You have Prestiged! ', NOTIFY_GENERIC , 5);")
				
			else
				ply:SendLua("notification.AddLegacy('You cannot Prestige. You are max Prestige!', NOTIFY_ERROR, 5);")
			end
		else
			ply:SendLua("notification.AddLegacy('You cannot Prestige!', NOTIFY_ERROR, 5);")
		end	
	end
	concommand.Add("Prestige" , XPSYS.Prestige)

	function XPSYS.ResetPrestige(ply)
		local steamID = ply:SteamID()
		local prestige = tonumber(sql.QueryValue( "SELECT Prestige FROM experience WHERE SteamID = '"..steamID.."'" ))
		if !(tonumber(prestige)) == 1 then
			sql.Query("UPDATE experience SET Prestige = '1' WHERE SteamID = '"..steamID.."'")
		else
			ply:SendLua("notification.AddLegacy('You are already Prestige 1!', NOTIFY_ERROR, 5);")
		end
	end
	concommand.Add("ResetMyPrestige" , XPSYS.ResetPrestige)


	function XPSYS.GetMaxLevel()
		return tonumber(XPTable[#XPTable])
	end

	function XPSYS.NextLevelXP( ply )
		local level = ply:GetNWInt("Level", 0)
		if level == #XPTable then	
			return XPTable[#XPTable]
		else
			return XPTable[level + 1]
		end
	end

	function XPSYS.MyLevelXP( ply )
		local level = ply:GetNWInt("Level", 0)
		return XPTable[level]
	end

	function XPSYS.AddXPOnKill(victim, inflictor, attacker )
		if ( victim == attacker ) then return end
		--[[ AddXP(attacker , 30) ]]
		local victimLevel = victim:GetNWInt("Level",  1 )
		local attackerLevel = attacker:GetNWInt("Level" , 1)
		if tonumber(victimLevel) > tonumber(attackerLevel) then
			XPSYS.AddXP(attacker , 60)
		else
			XPSYS.AddXP(attacker , 30)
		end
	end

	hook.Add( "PlayerDeath", "playerDeathAddXP", XPSYS.AddXPOnKill )
	
		net.Receive( "ResetAll", function( len, ply )
		if IsValid(ply) then
			if ply:IsSuperAdmin() then
				local Option = net.ReadString()
				if Option == "ATM" then
					for k,v in pairs(player.GetAll()) do 
						v:SetNWInt("Level" , 1)
						v:SetNWInt("XP", 0)
						v:SetNWInt("Prestige", 1)
						local steamID = v:SteamID()
						sql.Query( "DELETE FROM experience WHERE SteamID = '"..steamID.."'")
						XPSYS.InitializePlayerInfo( v )
					end
				else
					
				end
			else
				ply:Kick("Exploiting - XP System Reset All")
			end
		end
	end)

	net.Receive( "GiveXP", function( len, ply )
		if IsValid(ply) then
			if ply:IsSuperAdmin() then
				for k,v in pairs(player.GetAll()) do 
					XPSYS.AddXP(v , 100)
				end
			else
				ply:Kick("Exploiting - XP System Give All")
			end
		end
	end)

	net.Receive( "UpdateAllLeaderBoards", function( len, ply )
		if IsValid(ply) then
			if ply:IsSuperAdmin() then
				XPSYS.ForAllLeaderBoardUpdate()
			else
				ply:Kick("Exploiting - XP System Update LeaderBoard")
			end
		end
	end)

	function XPSYS.LeaderBoardUpdate(ply)
		local test = sql.Query( "SELECT * FROM experience" )
		local test = test or {}
		net.Start("UpdateClients")
			net.WriteTable(test)
		net.Send(ply)
	end
	hook.Add( "PlayerInitialSpawn", "Sending the leader board to the client", XPSYS.LeaderBoardUpdate )

	function XPSYS.ForAllLeaderBoardUpdate()
		local test = sql.Query( "SELECT * FROM experience" )
		local test = test or {}
		net.Start("UpdateClients")
			net.WriteTable(test)
		net.Broadcast()
		for k, v in pairs(player.GetAll()) do
			v:SendLua("notification.AddLegacy('Leader Board updated! Click F2 to use the LeaderBoard!', NOTIFY_GENERIC, 5);")
		end
	end
	timer.Create("Update All LeaderBoards", 300 , 0 , XPSYS.ForAllLeaderBoardUpdate)
	if istable(ulx) then
		local state = false
		function ulx.addxp( calling_ply, target_plys, xp  )
			if tonumber(xp) > 1000 then
				calling_ply:SendLua("notification.AddLegacy('Bug Currently Cannot give over 10000 XP!', NOTIFY_GENERIC, 5);")
				return
			end
			for k, v in pairs( target_plys ) do	
				XPSYS.AddXP(v, tonumber(xp))
				local state = true
			end
			if state ~= true then
				ulx.fancyLogAdmin( calling_ply, "#A Gave XP to #T", target_plys )
			end
		end



		local addxp = ulx.command( "Fun", "ulx addxp", ulx.addxp, "!addxp", true )
		addxp:addParam{ type=ULib.cmds.PlayersArg }
		addxp:defaultAccess( ULib.ACCESS_ADMIN )
		addxp:addParam{ type=ULib.cmds.NumArg, default=200, hint="XP", ULib.cmds.optional }
		addxp:help( "Add XP to a player" )

		local state = false
		function ulx.resetplayer( calling_ply, target_plys  )
			for k, v in pairs( target_plys ) do	
				local state = true
				v:ConCommand("ResetMyPrestige")
				XPSYS.SetLevel(v, 1)
				XPSYS.SetXP(v, 0)
			end
			if state ~= true then
				ulx.fancyLogAdmin( calling_ply, "#A reset level and XP of #T", target_plys )
			end
		end



		local resetplayer = ulx.command( "Fun", "ulx resetplayer", ulx.resetplayer, "!resetplayer", true )
		resetplayer:addParam{ type=ULib.cmds.PlayersArg }
		resetplayer:defaultAccess( ULib.ACCESS_SUPERADMIN )
		resetplayer:help( "Resets a player" )
		
		local state = false
		function ulx.setlevel( calling_ply, target_plys, level  )
			if level > 100 or level == 0 then
				calling_ply:SendLua("notification.AddLegacy('You cannot set above level 100 or 0!', NOTIFY_GENERIC, 5);")
				return
			end
			for k, v in pairs( target_plys ) do	
				local state = true
				XPSYS.SetLevel(v, tonumber(level))
			end
			if state ~= true then
				ulx.fancyLogAdmin( calling_ply, "#A set level of #T", target_plys )
			end
		end



		local setlevel = ulx.command( "Fun", "ulx setlevel", ulx.setlevel, "!setlevel", true )
		setlevel:addParam{ type=ULib.cmds.PlayersArg }
		setlevel:defaultAccess( ULib.ACCESS_SUPERADMIN )
		setlevel:addParam{ type=ULib.cmds.NumArg, default=1, hint="Level", ULib.cmds.optional }
		setlevel:help( "SetLevel of a player" )
		
	else
		
	end
end
