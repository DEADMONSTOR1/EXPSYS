if SERVER then return end

--[[---------------------------------------------------------
   Name: Update()
   Desc: Updates all the data on the client.
-----------------------------------------------------------]]
/*
function Update(len)
	XP = net.ReadInt(32)
	level = net.ReadInt(32)
	XPOfNextLevel = net.ReadInt(32)
end
net.Receive("UpdateClient",Update)
*/
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

local function dostuff( um )
	local ply = um:ReadEntity()
	em = ParticleEmitter(ply:GetPos())
		for i=0, 1500 do
			local part = em:Add( "effects/spark", ply:GetPos() + VectorRand()*math.random(-100,100) + Vector(math.random(1,10),math.random(1,10),math.random(0,175)) )
			part:SetAirResistance( 100 )
			part:SetBounce( 0.3 )
			part:SetCollide( true )
			part:SetColor( math.random(10,250),math.random(10,250),math.random(10,250),255 )
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


function OpenIt()

	//LocalPlayer():ConCommand("CheckXP")
	-- Will add this later in time
	
end
hook.Add("OnContextMenuOpen" , "CheckXPOpen" , OpenIt)

function AddLaterTOThis()
	//
end
concommand.Add("CheckXP" , AddLaterTOThis )
