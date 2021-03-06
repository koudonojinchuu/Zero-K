--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Chili Inactivity Win",
    desc      = "GUI for winning the game through opponent inactivity.",
    author    = "GoogleFrog",
    date      = "1 August 2015",
    license   = "GNU GPL, v2 or later",
    layer     = 0, 
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local Chili
local Button
local Label
local Window
local Panel
local TextBox
local Image
local Progressbar
local Control
local Font

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetupWindow()
	-- setup Chili
	Chili = WG.Chili
	Button = Chili.Button
	Label = Chili.Label
	Colorbars = Chili.Colorbars
	Window = Chili.Window
	Panel = Chili.Panel
	TextBox = Chili.TextBox
	Image = Chili.Image
	Progressbar = Chili.Progressbar
	Control = Chili.Control
	screen0 = Chili.Screen0

	local newMainWindow = Window:New{
		--parent = screen0,
		name  = 'inactivityWindow';
		color = {0, 0, 0, 0},
		width = 280;
		height = 160;
		y = 80,
		right = 60;
		dockable = false;
		draggable = true,
		resizable = false,
		tweakDraggable = true,
		tweakResizable = false,
		minWidth = MIN_WIDTH, 
		minHeight = MIN_HEIGHT,
		padding = {0, 0, 0, 0},
		--itemMargin  = {0, 0, 0, 0},
	}
	local panel_main = Panel:New{
		parent = newMainWindow,
		resizeItems = true;
		orientation   = "vertical";
		height = "100%";
		width =  "100%";
		padding = {0, 0, 0, 0},
		itemMargin  = {0, 0, 0, 0},
		--backgroundColor = {0, 0, 0, 0},
	}
	local label_text = TextBox:New{
		x = "9%",
		right = "9%",
		y = "24%",
		bottom = "65%",
		parent = panel_main,
		autosize = false;
		align  = "center";
		valign = "top";
		text   = "Connection problems detected for opposition \n\n       Wait  or  Win";
		font   = {size = 20, color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, outlineWidth = 3},
	}
	
	local button_win = Button:New {
		y = "55%",
		bottom = "24%",
		x = "52%",
		right = "29%",
		parent = panel_main;
		padding = {0, 0, 0,0},
		margin = {0, 0, 0, 0},
		backgroundColor = {1, 1, 1, 0.9},
		caption = "Win";
		font   = {size = 20, color = {1,1,1,1}, outlineColor = {0,0,0,0.7}, outlineWidth = 3},
		tooltip = "Stop waiting for dropped players and declare yourself the winner.";
		OnClick = {
			function() 
				Spring.SendCommands("luarules inactivitywin")
			end
		}
	}
	return newMainWindow
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local windowVisible = false
local timeSinceLastUpdate = 0
local mainWindow

local function GetDesiredWindowActivation()
	local allyTeamID = Spring.GetMyAllyTeamID()
	if not allyTeamID then
		return false
	end
	local inactivityWin = Spring.GetGameRulesParam("inactivity_win")
	if inactivityWin ~= allyTeamID then
		return false
	end
	
	local replay = Spring.IsReplay()
	if replay then
		return false
	end
	local specating = Spring.GetSpectatingState()
	if specating then
		return false
	end
	
	return true
end

function widget:Update(dt)
	timeSinceLastUpdate = timeSinceLastUpdate + dt
	if timeSinceLastUpdate < 0.2 then
		return
	end
	timeSinceLastUpdate = 0

	local desiredActive = GetDesiredWindowActivation()

	if desiredActive and Spring.IsGameOver() then
		desiredActive = false
	end
	
	if desiredActive ~= windowVisible then
		if desiredActive then
			windowVisible = true
			if not mainWindow then
				mainWindow = SetupWindow()
			end
			screen0:AddChild(mainWindow)
		else
			windowVisible = false
			screen0:RemoveChild(mainWindow)
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

