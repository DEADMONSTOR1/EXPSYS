--[[
	==================================================
			Made by toshko3331 and DEADMONSTOR 	
		  GitHub:https://github.com/toshko3331/expsys   
	==================================================
]]--

if SERVER then
	util.AddNetworkString( "UpdateClient" )
	util.AddNetworkString( "XPText" )
end
XPSYS = {}
XPTable = {1}


 --[[---------------------------------------------------------
   Name: XPSYS.CreateXPGuildLines()
   Desc: Makes the XPTable GuildLines
-----------------------------------------------------------]]
function XPSYS.CreateXPGuildLines()
	XPTable = {1}
	for i=1,99 do do
		table.insert(XPTable, i * 100)
	end
end
end
hook.Add( "Initialize", "CreateXPGuildLines", XPSYS.CreateXPGuildLines )

XPSYS.CreateXPGuildLines()
 --[[---------------------------------------------------------
   Name: InitializeXPTable()
   Desc: Starts to make the Table if not there.
-----------------------------------------------------------]]
function InitializeXPTable()
	if( sql.Query( "SELECT SteamID,XP,Level FROM experience" ) == false ) then
		sql.Query( "CREATE TABLE experience( SteamID string UNIQUE, XP int, Level int )" )
		print( "XP table successfully initialized!" )
	end

	print( "XP table successfully initialized!" )
end
hook.Add( "Initialize", "Experience Table Initialization", InitializeXPTable )

--[[---------------------------------------------------------
   Name: InitializePlayerInfo(player)
   Desc: Checks if the XP table contains the proper columns and handles creating them.
   Also updates the client initially when the player loads.
-----------------------------------------------------------]]

function InitializePlayerInfo( ply )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	local steamID = ply:SteamID()
	if( sql.Query( "SELECT * FROM experience WHERE SteamID = '"..steamID.."'" ) == nil ) then
		sql.Query("INSERT INTO experience ( SteamID, XP, Level ) \
			VALUES ( '"..steamID.."', 0, 1)" )
	else
		ply:SetNWInt("XP" , tonumber(sql.QueryValue( "SELECT XP FROM experience WHERE SteamID = '"..steamID.."'" )))
		ply:SetNWInt("Level" , tonumber(sql.QueryValue( "SELECT Level FROM experience WHERE SteamID = '"..steamID.."'" )))

	end	
	UpdateClient(ply,tonumber(sql.QueryValue("SELECT XP FROM experience WHERE SteamID = '"..steamID.."'")),
		tonumber(sql.QueryValue("SELECT Level FROM experience WHERE SteamID = '"..steamID.."'")))
end
hook.Add( "PlayerInitialSpawn", "Initializing The Player Info", InitializePlayerInfo )

--[[---------------------------------------------------------
   Name: AddXP(player, xp)
   Desc: Adds XP to the player.
-----------------------------------------------------------]]

function AddXP( ply, xp )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	local steamID = ply:SteamID()
	local realxp = tonumber(ply:GetNWInt("XP" , 0))
	sql.Query( "UPDATE experience SET XP = '"..realxp.."' WHERE SteamID = '"..steamID.."'" )
	local reallevel = ply:GetNWInt("Level" , 0) 	
	ply:SetNWInt("XP", realxp + xp)
	UpdateThroughXP(ply, tonumber(ply:GetNWInt("XP" , 0)))
	ply:ConCommand("CheckXP" )
end


--[[---------------------------------------------------------
   Name: SetXP(player, xp)
   Desc: Sets the XP of the player.
-----------------------------------------------------------]]

function SetXP( ply, xp )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	ply:ConCommand("CheckXP" )
	local steamID = ply:SteamID()
	sql.Query( "UPDATE experience SET XP = '"..xp.."' WHERE SteamID = '"..steamID.."'" )
	ply:SetNWInt("XP", xp)
	UpdateThroughXP( ply, xp )
end

--[[---------------------------------------------------------
   Name: AddLevels(player, level(s))
   Desc: Add the level(s) to the player.
-----------------------------------------------------------]]

function AddLevels( ply, levels )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	ply:ConCommand("CheckXP" )
	local steamID = ply:SteamID()
	local newLevel = ply:GetNWInt("Level") + levels
	UpdateThroughLevel( ply, newLevel )
end

--[[---------------------------------------------------------
   Name: SetLevel(player, level(s))
   Desc: Sets the level(s) to the player selected.
-----------------------------------------------------------]]

function SetLevel( ply, level )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	ply:ConCommand("CheckXP" )
	UpdateThroughLevel( ply, level )
end

--[[---------------------------------------------------------
   Name: GetLevel(player)
   Desc: Returns the level of the player.
-----------------------------------------------------------]]

function GetLevel(ply)
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	return tonumber(ply:GetNWInt("Level", 0))
end

--[[---------------------------------------------------------
   Name: GetXP(player)
   Desc: Returns the XP of the player.
-----------------------------------------------------------]]

function GetXP(ply)
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	return tonumber(ply:GetNWInt("XP", 0))
end

--[[---------------------------------------------------------
   Name: isPlayerMaxLevel(player, xp)
   Desc: Returns a boolean value on weather the player is the max level.
-----------------------------------------------------------]]

function isPlayerMaxLevel( ply )
	if !(ply:IsValid() and ply:IsPlayer()) then
		return 
	end
	local maxLevel = #XPTable
	if tonumber(GetLevel( ply )) >= maxLevel  then
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

function UpdateThroughXP( ply, xp )
	local steamID = ply:SteamID()
	if !isPlayerMaxLevel(ply) then
		if xp <= XPTable[GetLevel(ply) + 1] then
			-- We do this to make sure it does not send data that will register the 
			-- player as having more XP than the current level's max on the client side.
			UpdateClient(ply , xp , tonumber(GetLevel(ply)))
		end
		
		while xp >= XPTable[tonumber(ply:GetNWInt("Level", 0) + 1)] do
			sql.Query( "UPDATE experience SET Level = Level + 1 WHERE SteamID = '"..steamID.."'" )
			xp = xp - XPTable[1]
			sql.Query( "UPDATE experience SET XP = 0 WHERE SteamID = '"..steamID.."'")
			ply:SetNWInt("XP" , 0)
			ply:SetNWInt("Level", GetLevel(ply) + 1)
			umsg.Start("LevelUP", ply)
			umsg.End()
			UpdateClient(ply , xp , GetLevel( ply ) )
			
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
		local maxXP = XPTable[#XPTable]
		if tonumber(GetXP( ply ) ) > maxXP then
			--If max level and xp that was passed was over the max amaount
			sql.Query("UPDATE experience SET XP = '"..maxXP.."' WHERE SteamID = '"..steamID.."'")
			UpdateClient(ply , maxXP , #XPTable )
			ply:SetNWInt("XP" , maxXP)
			ply:SetNWInt("Level", #XPTable)
		else
			--If max level and xp passed was below or equal to the last levels xp max.
			UpdateClient(ply , xp , #XPTable)
		end
	end
end

--[[---------------------------------------------------------
   Name: UpdateThroughLevel(player, xp)
   Desc: Utility function for updating level.
			Not meant to be used outside of this file without good reason.
-----------------------------------------------------------]]

function UpdateThroughLevel( ply, level )
	local steamID = ply:SteamID()
	local maxLevel = #XPTable
	if level >= maxLevel then
		sql.Query("UPDATE experience SET Level = '"..maxLevel.."' WHERE SteamID = '"..steamID.."'")	
		ply:SetNWInt("Level", maxLevel)
		UpdateClient(ply, GetXP(ply) ,maxLevel)
		ply:SendLua("notification.AddLegacy('Your level is set to "..maxLevel.."!', NOTIFY_GENERIC, 5);")
	else
		sql.Query("UPDATE experience SET Level = '"..level.."' WHERE SteamID = '"..steamID.."'")
		ply:SetNWInt("Level", level)
		UpdateClient(ply, GetXP(ply) ,level)
		ply:SendLua("notification.AddLegacy('Your level is set to "..level.."!', NOTIFY_GENERIC, 5);")
	end
end

--[[---------------------------------------------------------
   Name: UpdateClient(player, xp, level)
   Desc: Sends all player data to the client.
-----------------------------------------------------------]]
function GetMaxLevel()
	return tonumber(XPTable[#XPTable])
end

function NextLevelXP( ply )
	local level = ply:GetNWInt("Level", 0)
	if level == #XPTable then	
		return XPTable[#XPTable]
	else
		return XPTable[level + 1]
	end
end

function MyLevelXP( ply )
	local level = ply:GetNWInt("Level", 0)
	return XPTable[level]
end

function UpdateClient( ply, xp, level )
	//
end

function AddXPOnKill(victim, inflictor, attacker )
	if ( victim == attacker ) then return end
	AddXP(attacker , 10)
end

hook.Add( "PlayerDeath", "playerDeathTest", AddXPOnKill )
