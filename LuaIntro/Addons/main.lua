
if addon.InGetInfo then
	return {
		name    = "Main",
		desc    = "displays a simplae loadbar",
		author  = "jK",
		date    = "2012,2013",
		license = "GPL2",
		layer   = 0,
		depend  = {"LoadProgress"},
		enabled = true,
	}
end

------------------------------------------

local lastLoadMessage = ""
local lastProgress = 0

local progressByLastLine = {
	["Parsing Map Information"] = 0,
	["Loading SMF"] = 5,
	["Loading Radar Icons"] = 10,
	["Loading GameData Definitions"] = 15,
	["Loading Sound Definitions"] = 20,
	["Creating Smooth Height Mesh"] = 22,
	["Creating QuadField & CEGs"] = 25,
	["Creating Unit Textures"] = 30,
	["Creating Sky"] = 35,
	["Loading Weapon Definitions"] = 40,
	["Loading Unit Definitions"] = 45,
	["Loading Feature Definitions"] = 50,
	["PathCosts: writing"] = 55,
	["Initializing Map Features"] = 60,
	["Creating ShadowHandler & DecalHandler"] = 65,
	["Loading Map Tiles"] = 68,
	["Loading Square Textures"] = 70,
	["Creating TreeDrawer"] = 72,
	["Creating ProjectileDrawer & UnitDrawer"] = 75,
	["Creating Projectile Textures"] = 78,
	["Loading LuaRules"] = 80,
	["Loading LuaUI"] = 90,
	["Initializing PathCache"] = 95,
	["Finalizing"] = 100
}
for name,val in pairs(progressByLastLine) do
	progressByLastLine[name] = val*0.01
end

function addon.LoadProgress(message, replaceLastLine)
	lastLoadMessage = message
	lastProgress = progressByLastLine[message] or lastProgress
end

------------------------------------------

local font = gl.LoadFont("FreeSansBold.otf", 50, 20, 1.95)

function addon.DrawLoadScreen()
	local loadProgress = lastProgress or SG.GetLoadProgress()

	local vsx, vsy = gl.GetViewSizes()

	-- draw progressbar
	local hbw = 3.5/vsx
	local vbw = 3.5/vsy
	local hsw = 0.2
	local vsw = 0.2
	gl.BeginEnd(GL.QUADS, function()
		--shadow topleft
		gl.Color(0,0,0,0)
			gl.Vertex(0.2-hsw, 0.2    )
			gl.Vertex(0.2-hsw, 0.2+vsw)
			gl.Vertex(0.2    , 0.2+vsw)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.2    , 0.2)

		--shadow top
		gl.Color(0,0,0,0)
			gl.Vertex(0.2, 0.2+vsw)
			gl.Vertex(0.8, 0.2+vsw)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.8, 0.2)
			gl.Vertex(0.2, 0.2)

		--shadow topright
		gl.Color(0,0,0,0)
			gl.Vertex(0.8    , 0.2+vsw)
			gl.Vertex(0.8+hsw, 0.2+vsw)
			gl.Vertex(0.8+hsw, 0.2)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.8    , 0.2)

		--shadow right
		gl.Color(0,0,0,0)
			gl.Vertex(0.8+hsw, 0.2)
			gl.Vertex(0.8+hsw, 0.15)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.8    , 0.15)
			gl.Vertex(0.8    , 0.2)

		--shadow btmright
		gl.Color(0,0,0,0)
			gl.Vertex(0.8    , 0.15-vsw)
			gl.Vertex(0.8+hsw, 0.15-vsw)
			gl.Vertex(0.8+hsw, 0.15)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.8    , 0.15)

		--shadow btm
		gl.Color(0,0,0,0)
			gl.Vertex(0.2, 0.15-vsw)
			gl.Vertex(0.8, 0.15-vsw)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.8, 0.15)
			gl.Vertex(0.2, 0.15)

		--shadow btmleft
		gl.Color(0,0,0,0)
			gl.Vertex(0.2-hsw, 0.15    )
			gl.Vertex(0.2-hsw, 0.15-vsw)
			gl.Vertex(0.2    , 0.15-vsw)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.2    , 0.15)

		--shadow left
		gl.Color(0,0,0,0)
			gl.Vertex(0.2-hsw, 0.2)
			gl.Vertex(0.2-hsw, 0.15)
		gl.Color(0,0,0,0.5)
			gl.Vertex(0.2    , 0.15)
			gl.Vertex(0.2    , 0.2)

		--bar bg
		gl.Color(0,0,0,0.85)
			gl.Vertex(0.2, 0.2)
			gl.Vertex(0.8, 0.2)
			gl.Vertex(0.8, 0.15)
			gl.Vertex(0.2, 0.15)

		--progress
		gl.Color(1,1,1,0.7)
			gl.Vertex(0.2, 0.2)
			gl.Vertex(0.2 + math.max(0, loadProgress-0.01) * 0.6, 0.2)
			gl.Vertex(0.2 + math.max(0, loadProgress-0.01) * 0.6, 0.15)
			gl.Vertex(0.2, 0.15)
		gl.Color(1,1,1,0.7)
			gl.Vertex(0.2 + math.max(0, loadProgress-0.01) * 0.6, 0.2)
			gl.Vertex(0.2 + math.max(0, loadProgress-0.01) * 0.6, 0.15)
		gl.Color(1,1,1,0)
			gl.Vertex(0.2 + math.min(1, math.max(0, loadProgress+0.01)) * 0.6, 0.15)
			gl.Vertex(0.2 + math.min(1, math.max(0, loadProgress+0.01)) * 0.6, 0.2)

		--bar borders
		gl.Color(1,1,1,1)
			gl.Vertex(0.2, 0.2)
			gl.Vertex(0.8, 0.2)
			gl.Vertex(0.8, 0.2-vbw)
			gl.Vertex(0.2, 0.2-vbw)
		gl.Color(1,1,1,1)
			gl.Vertex(0.2, 0.15)
			gl.Vertex(0.8, 0.15)
			gl.Vertex(0.8, 0.15+vbw)
			gl.Vertex(0.2, 0.15+vbw)
		gl.Color(1,1,1,1)
			gl.Vertex(0.2, 0.2)
			gl.Vertex(0.2, 0.15)
			gl.Vertex(0.2+hbw, 0.15)
			gl.Vertex(0.2+hbw, 0.2)
		gl.Color(1,1,1,1)
			gl.Vertex(0.8, 0.2)
			gl.Vertex(0.8, 0.15)
			gl.Vertex(0.8-hbw, 0.15)
			gl.Vertex(0.8-hbw, 0.2)
	end)

--[[
	gl.Color(0,0,0,1)
	gl.Rect(0.2,0.15,0.8,0.2)
	gl.Color(1,1,1,1)
	gl.Rect(0.2,0.15,0.2 + math.max(0, loadProgress) * 0.6,0.2)
	gl.LineWidth(5)
	gl.PolygonMode(GL.FRONT_AND_BACK, GL.LINE)
	gl.Rect(0.2,0.15,0.8,0.2)
	gl.PolygonMode(GL.FRONT_AND_BACK, GL.FILL)
	gl.LineWidth(1)
	gl.Color(1,1,1,1)
--]]

	-- progressbar text
	gl.PushMatrix()
	gl.Scale(1/vsx,1/vsy,1)
	local barTextSize = vsy * (0.05 - 0.015)

	--font:Print(lastLoadMessage, vsx * 0.5, vsy * 0.3, 50, "sc")
	--font:Print(Game.gameName, vsx * 0.5, vsy * 0.95, vsy * 0.07, "sca")
	font:Print(lastLoadMessage, vsx * 0.2, vsy * 0.14, barTextSize*0.5, "sa")
	if loadProgress>0 then
		--font:Print(("%.0f%%"):format(loadProgress * 100), vsx * 0.5, vsy * 0.165, barTextSize, "oc")
	else
		--font:Print("Loading...", vsx * 0.5, vsy * 0.165, barTextSize, "oc")
	end
	gl.PopMatrix()
end


function addon.MousePress(...)
	--Spring.Echo(...)
end


function addon.Shutdown()
	gl.DeleteFont(font)
end