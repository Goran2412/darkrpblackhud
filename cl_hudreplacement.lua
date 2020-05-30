/*---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------*/

surface.CreateFont( "namef", {
 font = "Bebas Neue",
 size = 40,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "namefsmall", {
 font = "Bebas Neue",
 size = 20,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "jobf", {
 font = "Bebas Neue",
 size = 34,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "jobfsmall", {
 font = "Bebas Neue",
 size = 24,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "jobfxsmall", {
 font = "Bebas Neue",
 size = 16,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "moneyf", {
 font = "Bebas Neue",
 size = 48,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "moneyfsmall", {
 font = "Bebas Neue",
 size = 36,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "salaryf", {
 font = "Bebas Neue",
 size = 24,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "healthf", {
 font = "Bebas Neue",
 size = 16,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "healthf2", {
 font = "Bebas Neue",
 size = 20,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "wantf", {
 font = "Bebas Neue",
 size = 36,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "hungerf", {
 font = "Bebas Neue",
 size = 18,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = false,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet
	["DarkRP_LocalPlayerHUD"] = true,

	-- Drawing the DarkRP agenda
	["DarkRP_Agenda"] = false
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

--if true then return end -- REMOVE THIS LINE TO ENABLE THE CUSTOM HUD BELOW

/*---------------------------------------------------------------------------
The Custom HUD
only draws health
---------------------------------------------------------------------------*/
local Health = 0

HM = {}

HM.UsingHungerMod = false
local av
local name

local oldName

local function DrawPlayerAvatar( p )
	
	oldName = LocalPlayer():Name()
	print( oldName )
	
	av = vgui.Create("AvatarImage")
	av:SetPos(64,ScrH() - 130)
	av:SetSize(56, 56)
	av:SetPlayer( p, 64 )
end

local function formatNumber(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

local function hudPaint()

	draw.RoundedBox( 4, 9, ScrH() - 143, 392, 133, Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 10, ScrH() - 142, 390, 132, Color( 38, 38, 38, 255 ) )
	draw.RoundedBoxEx( 4, 10, ScrH() - 142, 40, 80, Color( 54, 54, 54, 255 ), true, false, false, false )
	draw.RoundedBoxEx( 4, 400 - 156, ScrH() - 142, 156, 80, Color( 54, 54, 54, 255 ), false, true, false, false )
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawLine( 10, ScrH() - 102, 50, ScrH() - 102 )
	
	surface.SetDrawColor( 61, 61, 61, 255 )
	surface.DrawLine( 10, ScrH() - 101, 50, ScrH() - 101 )
	
	surface.SetDrawColor( 4, 4, 4, 255 )
	surface.DrawLine( 10, ScrH() - 62, 400, ScrH() - 62 )
	
	surface.SetDrawColor( 61, 61, 61, 255 )
	surface.DrawLine( 10, ScrH() - 61, 400, ScrH() - 61 )
	
	surface.SetDrawColor( 84, 84, 84, 255 )
	surface.DrawLine( 11, ScrH() - 142, 398, ScrH() - 142 )
	
	surface.SetDrawColor( 24, 24, 24, 255 )
	surface.DrawLine( 400 - 156, ScrH() - 142, 400 - 156, ScrH() - 62 )
	
	surface.SetDrawColor( 24, 24, 24, 255 )
	surface.DrawLine( 50, ScrH() - 142, 50, ScrH() - 62 )
	
	local font
	
	surface.SetFont( "namef" )
	local PlayerName = LocalPlayer():Name()
	local Width, Height = surface.GetTextSize(PlayerName)
	if Width > 100 then
		font = "namefsmall"
	else
		font = "namef"
	end
	
	surface.SetFont( "namefsmall" )
	local wh, hw = surface.GetTextSize(PlayerName)
	if font == "namefsmall" and wh > 100 then
		PlayerName = string.sub( LocalPlayer():Name(), 1, 18 )..".."
	end
	
	if font == "namef" and Width < 100 then
		local PlayerName = LocalPlayer():Name()
	end
	
	draw.SimpleText( PlayerName, font, 130, ScrH() - 132, Color( 255, 255, 255 ) )
	
	local jfont
	local jof
	local eof
	
	surface.SetFont( "jobf" )
	local PlayerJob = team.GetName(LocalPlayer():Team())
	local wi, hi = surface.GetTextSize(PlayerJob)
	if wi > 100 and wi < 140 then
		jfont = "jobfsmall"
		jof = 2
	elseif wi > 140 then
		jfont = "jobfxsmall"
		jof = 4
	else
		jfont = "jobf"
		jof = 0
	end
	
	if jfont == "jobfsmall" and font == "namefsmall" then
		jof = jof - 4
	elseif jfont == "jobf" and font == "namefsmall" then
		jof = jof - 6
	elseif	jfont == "jobfxsmall" and font == "namefsmall" then
		jof = jof - 8
	else
		jof = jof
	end
	draw.SimpleText( PlayerJob, jfont, 130, ScrH() - 100 + jof, Color( 220, 220, 220, 255 ) )
	if HM.UsingHungerMod then
		draw.SimpleText( "Energía: "..math.Round(LocalPlayer():getDarkRPVar( "Energy" ) or 0), "hungerf", 130, ScrH() - 88 + jof, Color( 200, 200, 200, 255 ) )
	end
	
	local mfont
	
	surface.SetFont( "moneyf" )
	local PlayerMoney = formatNumber(LocalPlayer():getDarkRPVar( "money" ))
	local wl, hl = surface.GetTextSize(PlayerMoney)
	
	if wl > 140 then
		mfont = "moneyfsmall"
	else
		mfont = "moneyf"
	end
	
	draw.SimpleText( "$"..PlayerMoney, mfont, 320, ScrH() - 132, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	draw.SimpleText( "Salario: $"..formatNumber(LocalPlayer():getDarkRPVar( "salary" )), "salaryf", 320, ScrH() - 96, Color( 200, 200, 200, 255 ), TEXT_ALIGN_CENTER )
	
	local x, y = 30, ScrH() - 20
	local localplayer = LocalPlayer()
	Health = math.min(100, (Health == localplayer:Health() and Health) or Lerp(0.1, Health, localplayer:Health()))

	local DrawHealth = math.Min(Health / GAMEMODE.Config.startinghealth, 1)
	local Border = math.Min(6, math.pow(2, math.Round(3*DrawHealth)))
	draw.RoundedBox(4, 20 + 60, y - 33, 309 - 7, 16, Color(0,0,0,200))
	if LocalPlayer():Health() > 0 then
		draw.RoundedBox(4, 21 + 60, y - 32, (309 - 9) * DrawHealth, 14, Color(255,40,40,180))
	end

	draw.DrawText(math.Max(0, math.Round(localplayer:Health())), "healthf", 302 / 2 + 80, y - 33, Color(255,255,255,200), 1, TEXT_ALIGN_CENTER)
	
	local armor = LocalPlayer():Armor()
	draw.RoundedBox(4, 20 + 60, ScrH() - 34, 302, 16, Color(0,0,0,200))
	if armor > 0 then
		draw.RoundedBox(4, 21 + 60, ScrH() - 33, math.Clamp(localplayer:Armor() , 0 , 100) * 3, 14, Color(40,40,255,255))
	end
	draw.SimpleText(armor, "healthf", 80 + 302 / 2, ScrH() - 33, Color(255,255,255,200), TEXT_ALIGN_CENTER)
	
	draw.SimpleText("Vida:", "healthf2", 20, ScrH() - 54, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	draw.SimpleText("Chaleco:", "healthf2", 20, ScrH() - 36, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	
	if LocalPlayer():isWanted() then
		draw.SimpleText("!", "wantf", 30, ScrH() - 98, Color( math.sin( CurTime() * 3 ) * 255, 0, 0 ), TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("!", "wantf", 30, ScrH() - 98, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
	end
	
	if LocalPlayer():isArrested() then
		draw.SimpleText("+", "wantf", 30, ScrH() - 138, Color (255, 0, 0 ), TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("+", "wantf", 30, ScrH() - 138, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
	end
	
	if av then
		return
	else
		DrawPlayerAvatar( LocalPlayer() )
	end
end
hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)

hook.Add( "HUDShouldDraw", "Remove default", function( name ) 
    if ( name == "CHudHealth" or name == "CHudBattery" ) then
        return false
    end
end )

hook.Add("HUDDrawTargetID", "HMHUD", function()
	return
end)


local Page = Material("icon16/page_white_text.png")
local function GunLicense()
    if localplayer:getDarkRPVar("HasGunlicense") then

        surface.SetMaterial(Page)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(405, ScrH() - 40, 30, 30)
    end
end

function DrawHUD()
    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end-- Default
    GunLicense()
end
hook.Add("HUDPaint", "DrawHUD", DrawHUD)
