SLASH_FINDA1 = "/finda"
SLASH_FA1 = "/fa"
BTN_TEXT_SET_TO = ""
GRADIENT_ = "Interface\\GLUES\\Models\\UI_MainMenu\\swordgradient2"
Markers_ = {
	[1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14|t",
	[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:14:14|t",
	[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14|t",
	[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14|t",
	[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:14:14|t",
	[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:14:14|t",
	[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14|t",
	[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:14:14|t",
}
MarkerNames_ = {
	[1] = "Star",
	[2] = "Circle",
	[3] = "Diamond",
	[4] = "Triangle",
	[5] = "Moon",
	[6] = "Square",
	[7] = "Cross",
	[8] = "Skull",
}

-- Creates subheadings for interface options
local function Subheading(frame, title, x, y)
	local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	text:SetPoint("TOPLEFT", x, y); text:SetText(title)
	return text
end

-- Makes the first letter of string uppercase if it isn't already
local function Capitalize(str)
	local capitalized = (str:gsub("^%l", string.upper))
	-- if there is a space, capitalize the word after it
	capitalized = (capitalized:gsub("%s%l", string.upper))
	return capitalized
end

-- Prints help message to the chat window
local function PrintHelpMessage()
	print(" ")
	print("|cff00ff00--------------------------------------------------------------------------------------|r")
	print(" ")
	print("|cff00ff00>Slash commands:|r")
	print(" ")
	print("    |cff00ff00/finda|r             Opens the Interface Options if you have no target,")
	print("                           else sets current target to the FindA search.")
	print("    |cff00ff00/finda|r  |cff00E3DFhide|r      Hides the FindA button")
	print("    |cff00ff00/finda|r  |cff00E3DFshow|r      Shows the FindA button")
	print("    |cff00ff00/finda|r  |cff00E3DF******|r       Sets FindA to search for |cff00E3DF******|r")
	print(" ")
	print(" ")
	print("|cff00ff00>General usage:|r")
	print(" ")
	print("    1.  Use   |cff00ff00/finda|r   to open the options and set the marker type to use")
	print(" ")
	print("    2.  Use   |cff00ff00/finda|r   |cff00E3DF******|r   to set the thing you want to search for")
	print("                                           example:   |cff00ff00/finda|r  |cff00E3DFsqu|r   to find a Squirrel")
	print(" ")
	print("    3.  Click the FindA button to search for the thing you set")
	print("    Alternatively, create the following macro to emulate the button click:")
	print(" ")
	print("              /click FindAButton")
	print(" ")
	print("|cff00ff00--------------------------------------------------------------------------------------|r")
	print(" ")
end




------------------------------------------ LOGIN EVENT FUNCTION AND FRAME -----------------------------------------
-------------------------------------------------------------------------------------------------------------------
local function onLoadMessage()
    print(' ')
    print('|cff00FF00-------------------------------------------------------------------|r')
    print('|cff00FF00FindA successfully loaded|r')
	print(' ')
	print('Type|cff00FF00  /finda|r |cff00E3DFhelp|r  for commands and usage info')
	print(' ')
	print('Note:  |cff00FF00/finda|r  can be abbreviated to  |cff00FF00/fa|r  in all cases')
    print('|cff00FF00-------------------------------------------------------------------|r')
    print(' ')
end
local function delay(delay, func)
	Delayframe.func = func
	Delayframe.delay = delay
	Delayframe:Show()
end

local function onEvent(self, event, addOnName)
	if addOnName == "FindA" then
		FindADB = FindADB or {}					-- Load or create the saved variables database
		FindADB.sessions = (FindADB.sessions or 0) + 1		-- Increment game-sessions counter
		if  FindADB.sessions == 1 then				-- Populate/Initialize the saved variables table if first login
			FindADB.xDefault  = 0
			FindADB.yDefault  = 0
			FindADB.msgEnable = 1
			FindADB.alwaysHide= 0
			FindADB.isShowing = 0
			FindADB.defaultMarker = 8
			FindADB.rememberFinding = 1
			FindADB.lastFound = ""
		end
		ChatMsgEnable_ = FindADB.msgEnable
		AlwaysHide_ = FindADB.alwaysHide
		Marker_ = FindADB.defaultMarker
		RememberFinding_ = FindADB.rememberFinding
		LastFound_ = FindADB.lastFound
		if LastFound_ ~= "" then BTN_TEXT_SET_TO = LastFound_ end

		if not Delayframe then
			Delayframe = CreateFrame("Frame")
			Delayframe:Hide()
		end
		Delayframe:SetScript("OnUpdate", function(self, elapsed)
			self.delay = self.delay - elapsed
			if self.delay <= 0 then
				self:Hide()
				self.func()
			end
		end)
		delay(4, onLoadMessage)
	end
end

local LoginFrame = CreateFrame("Frame")
LoginFrame:RegisterEvent("ADDON_LOADED")
LoginFrame:SetScript("OnEvent", onEvent)

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------










--------------------------------------------- MAIN FUNCTION AND FRAME ---------------------------------------------
-------------------------------------------------------------------------------------------------------------------


function FindA(thing)
	local target = UnitName("target")						-- Get the name of the target
	if target then									-- If there is a target
		thing = Capitalize(thing)							-- Capitalize the target's name
		if string.find(target, thing) then						-- Check to see if user arg 'thing' is in target's name
			local dead = UnitIsDead("target")						-- Check if target is dead
			local tapped = UnitIsTapDenied("target") 					-- Check if target is tapped
			local marked = GetRaidTargetIndex("target") 					-- Check if target is marked
			if not dead and not tapped and not marked then					-- If none of the above
				SetRaidTarget("target", Marker_)						-- Mark target with selected marker
			end
		end
	end
end

local KillFrame = CreateFrame("Frame")							-- Create a frame to watch for marked target's death
KillFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")					-- Register the frame for combat log events
KillFrame:SetScript("OnEvent", function(self, event, ...)				-- When the frame receives an event
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then						-- Ensure the event is a combat log event
		local _, eventType = CombatLogGetCurrentEventInfo()				-- Get the event type
		if eventType == "PARTY_KILL" then						-- If the event is a kill from the player or a party member
			SetRaidTarget("target", 0)							-- Remove the marker from the target
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------










--------------------------------------------- MAIN MACRO-BUTTON FRAME ---------------------------------------------
-------------------------------------------------------------------------------------------------------------------

local MacroButton = CreateFrame("Button", "FindAButton", UIParent, "SecureActionButtonTemplate")
MacroButton:SetMovable(true)
MacroButton:RegisterForDrag("LeftButton")
MacroButton:SetScript("OnDragStart",function(self) self:StartMoving() end)
MacroButton:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	FindADB.xDefault = MacroButton:GetLeft()
	FindADB.yDefault = MacroButton:GetTop()
end)

MacroButton:SetWidth(128)
MacroButton:SetHeight(64)
MacroButton:SetFrameStrata("LOW")
MacroButton:SetPoint("CENTER", UIParent, "CENTER")

MacroButton:SetNormalTexture("Interface/Buttons/UI-Panel-Button-Up")
MacroButton:SetPushedTexture("Interface/Buttons/UI-Panel-Button-Down")
MacroButton:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight")

MacroButton:SetAttribute("type1", "macro")
MacroButton:SetAttribute("macrotext1", "/target ")
MacroButton:Show()

local text = MacroButton:CreateFontString(nil, "OVERLAY", "GameTooltipText")
text:SetText("Find:  ")
text:SetPoint("CENTER", -40, 10)

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------










--------------------------------------------- INTERFACE OPTIONS PANEL ---------------------------------------------
-------------------------------------------------------------------------------------------------------------------

local function isChecked(checkbox)
	if checkbox:GetChecked() then return true
	else return false end
end

Finda = {};
Finda.panel = CreateFrame("Frame", "FindAPanel");					-- Create a frame to hold the panel
Finda.panel.name = "FindA";								-- Set the Category name for the panel

local MainTitle = Subheading(Finda.panel, "FindA", 0, 0)				-- Create a title for the panel
MainTitle:SetFont(MainTitle:GetFont(), 64)
MainTitle:ClearAllPoints(); MainTitle:SetPoint("TOP", 0, -32)

local OptionsTitle = Subheading(Finda.panel, "Options", 0, 0)				-- Create a subtitle for the panel
OptionsTitle:SetFont(OptionsTitle:GetFont(), 32)
OptionsTitle:ClearAllPoints(); OptionsTitle:SetPoint("TOP", 0, -112)

local PanelTexture = Finda.panel:CreateTexture(nil, "BACKGROUND")			-- Create a background texture for the panel
PanelTexture:SetAllPoints(); PanelTexture:SetTexture(GRADIENT_)
PanelTexture:SetAlpha(0.2); PanelTexture:SetTexCoord(0, 1, 1, 0)

local ShowChatMessages_Checkbox = CreateFrame("CheckButton", nil, Finda.panel, "InterfaceOptionsCheckButtonTemplate")
ShowChatMessages_Checkbox:SetPoint("CENTER", -250, 50)
ShowChatMessages_Checkbox.Text:SetText("Show chat messages")
if ChatMsgEnable_ == 1 then
	 ShowChatMessages_Checkbox:SetChecked(true)
else ShowChatMessages_Checkbox:SetChecked(false) end
ShowChatMessages_Checkbox:SetScript("OnClick", function (self, button, down)
	if isChecked(self) then
		 ChatMsgEnable_ = 1
	else ChatMsgEnable_ = 0 end
end)

local AlwaysHide_Checkbox = CreateFrame("CheckButton", nil, Finda.panel, "InterfaceOptionsCheckButtonTemplate")
AlwaysHide_Checkbox:SetPoint("CENTER", -250, 0)
AlwaysHide_Checkbox.Text:SetText("Always hide the macro button")
if AlwaysHide_ == 1 then
	 AlwaysHide_Checkbox:SetChecked(true)
else AlwaysHide_Checkbox:SetChecked(false) end
AlwaysHide_Checkbox:SetScript("OnClick", function (self, button, down)
	if isChecked(self) then
		 AlwaysHide_ = 1
	else AlwaysHide_ = 0 end
end)

local RememberFinding_Checkbox = CreateFrame("CheckButton", nil, Finda.panel, "InterfaceOptionsCheckButtonTemplate")
RememberFinding_Checkbox:SetPoint("CENTER", -250, -250)
RememberFinding_Checkbox.Text:SetText("Remember FindA search between reloads")
if RememberFinding_ == 1 then
	 RememberFinding_Checkbox:SetChecked(true)
else RememberFinding_Checkbox:SetChecked(false) end
RememberFinding_Checkbox:SetScript("OnClick", function (self, button, down)
	if isChecked(self) then
		 RememberFinding_ = 1
	else RememberFinding_ = 0 end
end)




local MarkerSelectionText = Subheading(Finda.panel, "Marker Selection", 0, 0)		-- Create a subtitle for the panel
MarkerSelectionText:SetFont(MarkerSelectionText:GetFont(), 12)
MarkerSelectionText:ClearAllPoints(); MarkerSelectionText:SetPoint("TOP", -200, -330)

local MarkerSelectionMenu = CreateFrame("Frame", "MarkerSelectionMenu", Finda.panel, "UIDropDownMenuTemplate")
MarkerSelectionMenu:SetPoint("CENTER", -200, -75)
UIDropDownMenu_SetWidth(MarkerSelectionMenu, 100)
UIDropDownMenu_SetText(MarkerSelectionMenu, MarkerNames_[Marker_])
UIDropDownMenu_JustifyText(MarkerSelectionMenu, "LEFT")
UIDropDownMenu_Initialize(MarkerSelectionMenu, function(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.func = function(self)
		UIDropDownMenu_SetSelectedID(MarkerSelectionMenu, self:GetID())
		Marker_ = self:GetID()
		UIDropDownMenu_SetSelectedValue(MarkerSelectionMenu, MarkerNames_[Marker_])
	end
	info.text = "Star"
	info.checked = function()
		if Marker_ == 1 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"
	UIDropDownMenu_AddButton(info)
	info.text = "Circle"
	info.checked = function()
		if Marker_ == 2 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"
	UIDropDownMenu_AddButton(info)
	info.text = "Diamond"
	info.checked = function()
		if Marker_ == 3 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"
	UIDropDownMenu_AddButton(info)
	info.text = "Triangle"
	info.checked = function()
		if Marker_ == 4 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"
	UIDropDownMenu_AddButton(info)
	info.text = "Moon"
	info.checked = function()
		if Marker_ == 5 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"
	UIDropDownMenu_AddButton(info)
	info.text = "Square"
	info.checked = function()
		if Marker_ == 6 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"
	UIDropDownMenu_AddButton(info)
	info.text = "Cross"
	info.checked = function()
		if Marker_ == 7 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"
	UIDropDownMenu_AddButton(info)
	info.text = "Skull"
	info.checked = function()
		if Marker_ == 8 then return true
		else return false end
	end
	info.icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
	UIDropDownMenu_AddButton(info)
end)


function Finda.panel.okay()
	local lastMarker = MarkerNames_[FindADB.defaultMarker]
	FindADB.msgEnable = ChatMsgEnable_
	FindADB.alwaysHide = AlwaysHide_
	FindADB.defaultMarker = Marker_
	FindADB.rememberFinding = RememberFinding_
	if AlwaysHide_ == 1 then
		 MacroButton:Hide()
	else MacroButton:Show() end
	if Marker_ then
		local selectedMarker = UIDropDownMenu_GetText(MarkerSelectionMenu)
		if selectedMarker ~= lastMarker then
			if ChatMsgEnable_ == 1 then
				print("|cff00ff00Finda:  |r Marker set to  "..Markers_[Marker_].." .")
			end
		end
	end
end

function Finda.panel.refresh()
	if ChatMsgEnable_ == 1 then
		 ShowChatMessages_Checkbox:SetChecked(true)
	else ShowChatMessages_Checkbox:SetChecked(false) end
	if AlwaysHide_ == 1 then
		 AlwaysHide_Checkbox:SetChecked(true)
	else AlwaysHide_Checkbox:SetChecked(false) end
	if RememberFinding_ == 1 then
		 RememberFinding_Checkbox:SetChecked(true)
	else RememberFinding_Checkbox:SetChecked(false) end
	UIDropDownMenu_SetText(MarkerSelectionMenu, MarkerNames_[Marker_])
end

-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(Finda.panel);


local function SetMacroAttribute(txt)
	MacroButton:SetAttribute("macrotext1", "/target " .. txt .. "\n/run FindA('" .. txt .. "');")
end


-- Updates macro button visibility when player reloads
-- and sets the macro button attribute to the last remembered search
local ReloadFrame = CreateFrame("Frame")
ReloadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ReloadFrame:SetScript("OnEvent", function(self, event)
	if AlwaysHide_ == 1 then
		MacroButton:Hide()
	end
	if RememberFinding_ == 1 then
		if FindADB.lastFound then
			SetMacroAttribute(FindADB.lastFound)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------










------------------------------------------ /finda & /fa COMMAND FUNCTIONS -----------------------------------------
-------------------------------------------------------------------------------------------------------------------

local function SetBtnText(txt)
	text:SetText("Find:  \n" .. txt)
end

local function HandleGlobalActions(txt)
	BTN_TEXT_SET_TO = txt
	if ChatMsgEnable_ == 1 then
		print("|cff00ff00Finding target:|r  " ..txt)
	end
	if RememberFinding_ == 1 then
		FindADB.lastFound = txt
	end
end


local function SlashFinda(msg)
	if msg == "" then
		local target = UnitName("target")
		if target == nil then
			InterfaceOptionsFrame_OpenToCategory(Finda.panel)
			InterfaceOptionsFrame_OpenToCategory(Finda.panel)
			return
		else
			if BTN_TEXT_SET_TO ~= target then
				SetBtnText(target)
				SetMacroAttribute(target)
				HandleGlobalActions(target)
			else
				if ChatMsgEnable_ == 1 then
					print("|cff00ff00Finda:|r  Target already set to " .. target .. ".")
				end
			end
			return
		end
	end
	if msg == "hide" then
		MacroButton:Hide()
		return
	end
	if msg == "show" then
		if RememberFinding_ == 1 and FindADB.lastFound then
			SetBtnText(FindADB.lastFound)
		end
		MacroButton:Show()
		return
	end
	if msg == "help" then
		PrintHelpMessage()
		return
	end
	if BTN_TEXT_SET_TO ~= Capitalize(msg) then
		msg = Capitalize(msg)
		SetBtnText(msg)
		SetMacroAttribute(msg)
		HandleGlobalActions(msg)
		return
	else
		if ChatMsgEnable_ == 1 then
			print("|cff00ff00Finda:|r  Target already set to " .. Capitalize(msg) .. ".")
		end
		return
	end
	print('\n at bottom (not good) \n')
end


SlashCmdList["FA"] = function (msg)
	if InCombatLockdown() then
		print("|cff00ff00Finda:|r  Failed due to combat. Try again when out of combat.")
		return
	else SlashFinda(msg) end
end
SlashCmdList["FINDA"] = function (msg)
	if InCombatLockdown() then
		print("|cff00ff00Finda:|r  Failed due to combat. Try again when out of combat.")
		return
	else SlashFinda(msg) end
end

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
