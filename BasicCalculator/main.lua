-- Version = "1.3"

SLASH_CALC1 = "/calc"
SLASH_SOLVE1 = "/solve"

local isCalcShowing = false
local showHistory = true
local secondDown = false
sqrt_ = false
sin_ = false
cos_ = false
tan_ = false
ln_ = false
asin_ = false
acos_ = false
atan_ = false


------------------ ON ADDON LOAD, INITIALIZE --------------------

local function printMessage()
	print('|cff00E3DFBasicCalculator v1.3 loaded  ~  type  /calc  to open calculator,  /calc help  to show commands|r')
end

local function Delay(delay, func)
	DelayFrame.func = func
	DelayFrame.delay = delay
	DelayFrame:Show()
end

local function onLoad(self, event, addOnName)
	if addOnName == "BasicCalculator" then
		if not DelayFrame then
			DelayFrame = CreateFrame("Frame")
			DelayFrame:Hide()
		end
		DelayFrame:SetScript("OnUpdate", function(self, elapsed)
			self.delay = self.delay - elapsed
			if self.delay <= 0 then
				self:Hide()
				self.func()
			end
		end)
		Delay(3, printMessage)
	end
end

local addonLoadedFrame = CreateFrame("Frame")
addonLoadedFrame:RegisterEvent("ADDON_LOADED")
addonLoadedFrame:SetScript("OnEvent", onLoad)

-----------------------------------------------------------------



-------------------- BUTTON INPUT HANDLER & CALCULATOR FUNCTION --------------------


local numpadInput = Test or CreateFrame("Frame", "Test", calculatorButtonsFrame)

local function NumpadInput(self, key)
	if isCalcShowing == true then
		if key == "NUMPAD0" then
			calculatorDisplayBox:Insert("0")
			handleCalcInput("0")
		elseif key == "NUMPAD1" then
			calculatorDisplayBox:Insert("1")
			handleCalcInput("1")
		elseif key == "NUMPAD2" then
			calculatorDisplayBox:Insert("2")
			handleCalcInput("2")
		elseif key == "NUMPAD3" then
			calculatorDisplayBox:Insert("3")
			handleCalcInput("3")
		elseif key == "NUMPAD4" then
			calculatorDisplayBox:Insert("4")
			handleCalcInput("4")
		elseif key == "NUMPAD5" then
			calculatorDisplayBox:Insert("5")
			handleCalcInput("5")
		elseif key == "NUMPAD6" then
			calculatorDisplayBox:Insert("6")
			handleCalcInput("6")
		elseif key == "NUMPAD7" then
			calculatorDisplayBox:Insert("7")
			handleCalcInput("7")
		elseif key == "NUMPAD8" then
			calculatorDisplayBox:Insert("8")
			handleCalcInput("8")
		elseif key == "NUMPAD9" then
			calculatorDisplayBox:Insert("9")
			handleCalcInput("9")
		elseif key == "NUMPADDECIMAL" then
			calculatorDisplayBox:Insert(".")
			handleCalcInput('.')
		elseif key == "NUMPADPLUS" then
			if sqrt_ or sin_ or cos_ or tan_ or ln_ or asin_ or acos_ or atan_ then
				calculatorDisplayBox:Insert(") + ")
			else
				calculatorDisplayBox:Insert(" + ")
			end
			handleCalcInput(' + ')
		elseif key == "NUMPADMINUS" then
			if sqrt_ or sin_ or cos_ or tan_ or ln_ or asin_ or acos_ or atan_ then
				calculatorDisplayBox:Insert(") - ")
			else
				calculatorDisplayBox:Insert(" - ")
			end
			handleCalcInput(' - ')
		elseif key == "NUMPADMULTIPLY" then
			if sqrt_ or sin_ or cos_ or tan_ or ln_ or asin_ or acos_ or atan_ then
				calculatorDisplayBox:Insert(") x ")
			else
				calculatorDisplayBox:Insert(" x ")
			end
			handleCalcInput(' * ')
		elseif key == "NUMPADDIVIDE" then
			if sqrt_ or sin_ or cos_ or tan_ or ln_ or asin_ or acos_ or atan_ then
				calculatorDisplayBox:Insert(") / ")
			else
				calculatorDisplayBox:Insert(" / ")
			end
			handleCalcInput(' / ')
		elseif key == "ENTER" then
			calculatorDisplayBox:Insert(" = ")
			handleCalcInput(' = ')
		end
	end
end

numpadInput:SetScript("OnKeyDown", NumpadInput)
numpadInput:SetPropagateKeyboardInput(true)


inputString = ""

function doMaths(str)
	func = assert(loadstring("return " .. str), errorHandler_())
	local y = func()
	local z = tostring(y)
	if string.len(z) > 10 then
		local q = string.sub(y, 1, 10)
		calculatorDisplayBox:SetText(q)
		if showHistory then
			print(str .. " = " .. q)
		end
	else
		calculatorDisplayBox:SetText(z)
		if showHistory then
			print(str .. " = " .. z)
		end
	end
	inputString = y
	-- handle last digit being a period
end

function handleCalcInput(input)
	if input == ' = ' then
		if sqrt_ then
			inputString = inputString .. ')'
			sqrt_ = false
			doMaths(inputString)
		elseif sin_ then
			inputString = inputString .. ')'
			sin_ = false
			doMaths(inputString)
		elseif cos_ then
			inputString = inputString .. ')'
			cos_ = false
			doMaths(inputString)
		elseif tan_ then
			inputString = inputString .. ')'
			tan_ = false
			doMaths(inputString)
		elseif ln_ then
			inputString = inputString .. ')'
			ln_ = false
			doMaths(inputString)
		elseif asin_ then
			inputString = inputString .. ')'
			asin_ = false
			doMaths(inputString)
		elseif acos_ then
			inputString = inputString .. ')'
			acos_ = false
			doMaths(inputString)
		elseif atan_ then
			inputString = inputString .. ')'
			atan_ = false
			doMaths(inputString)
		else
			doMaths(inputString)
		end
	elseif input == 'C' then
		inputString = ""
		sqrt_ = false
		sin_ = false
		cos_ = false
		tan_ = false
		ln_ = false
		asin_ = false
		acos_ = false
		atan_ = false
	elseif input == 'sqrt(' then
		inputString = inputString .. input
		sqrt_ = true
	elseif input == 'sin(' then
		inputString = inputString .. input
		sin_ = true
	elseif input == 'cos(' then
		inputString = inputString .. input
		cos_ = true
	elseif input == 'tan(' then
		inputString = inputString .. input
		tan_ = true
	elseif input == 'log(' then
		inputString = inputString .. input
		ln_ = true
	elseif input == 'asin(' then
		inputString = inputString .. input
		asin_ = true
	elseif input == 'acos(' then
		inputString = inputString .. input
		acos_ = true
	elseif input == 'atan(' then
		inputString = inputString .. input
		atan_ = true
	else
		if input == ' + ' or input == ' - ' or input == ' * ' or input == '^' or input == ' / ' then
			if sqrt_ then
				inputString = inputString .. ')' .. input
				sqrt_ = false
			elseif sin_ then
				inputString = inputString .. ')' .. input
				sin_ = false
			elseif cos_ then
				inputString = inputString .. ')' .. input
				cos_ = false
			elseif tan_ then
				inputString = inputString .. ')' .. input
				tan_ = false
			elseif ln_ then
				inputString = inputString .. ')' .. input
				ln_ = false
			elseif asin_ then
				inputString = inputString .. ')' .. input
				asin_ = false
			elseif acos_ then
				inputString = inputString .. ')' .. input
				acos_ = false
			elseif atan_ then
				inputString = inputString .. ')' .. input
				atan_ = false
			else
				inputString = inputString .. input
			end
		else
			inputString = inputString .. input
		end
	end
end

function errorHandler_(err)
	calculatorDisplayBox:SetText("error")
end

function redrawSQRT(secondDown)
	if secondDown then
		SqrtButton:Hide()
		SqrtXButton:Show()
	else
		SqrtXButton:Hide()
		SqrtButton:Show()
	end
end

function redrawSIN(secondDown)
	if secondDown then
		sinButton:Hide()
		asinButton:Show()
	else
		asinButton:Hide()
		sinButton:Show()
	end
end

function redrawCOS(secondDown)
	if secondDown then
		cosButton:Hide()
		acosButton:Show()
	else
		acosButton:Hide()
		cosButton:Show()
	end
end

function redrawTAN(secondDown)
	if secondDown then
		tanButton:Hide()
		atanButton:Show()
	else
		atanButton:Hide()
		tanButton:Show()
	end
end

function redrawLN(secondDown)
	if secondDown then
		lnButton:Hide()
		eButton:Show()
	else
		eButton:Hide()
		lnButton:Show()
	end
end

function second_(secondDown)
	if secondDown then
		-- print('2nd is engaged.')
		redrawSQRT(secondDown)
		redrawSIN(secondDown)
		redrawCOS(secondDown)
		redrawTAN(secondDown)
		redrawLN(secondDown)
	else
		-- print('2nd is disengaged.')
		redrawSQRT(secondDown)
		redrawSIN(secondDown)
		redrawCOS(secondDown)
		redrawTAN(secondDown)
		redrawLN(secondDown)
	end
end

function input()
	print('inputString = ' .. inputString)
end

function find_zero(f, x_left, x_right, eps)
	eps = eps or 0.0000000001   -- precision
	f_left, f_right = f(x_left), f(x_right)
	assert(x_left <= x_right and f_left * f_right <= 0, "Wrong diapazone")
	while x_right - x_left > eps do
		x_middle = (x_left + x_right) / 2
		f_middle = f(x_middle)
		if f_middle * f_left > 0 then
			x_left, f_left = x_middle, f_middle
		else
			x_right, f_right = x_middle, f_middle
		end
	end
	return (x_left + x_right) / 2
end

function my_func(x)
   -- return 200/(x+x^2+x^3+x^4+x^5) - 0.00001001
   return 200/(x^2) - 0.1001
end

-- Assuming that the root is between 1 and 1000
function solution()
	local x = find_zero(my_func, 1.0, 10000.0)
	print(x)       -->  28.643931367544
end

function slashSolve(arg)
	print(arg)
	init_ = string.sub(arg, 1, 1)
	for i = 1, string.len(arg)
	do
		tmp = string.sub(arg, i, i)
		if tmp == '0' or tmp == '1' or tmp == '2' or tmp == '3' or tmp == '4' or tmp == '5' or tmp == '6' or tmp == '7' or tmp == '8' or tmp == '9' then
			print('number')
		elseif tmp == '+' or tmp == '-' or tmp == '*' or tmp == '/' or tmp == '^' then
			print('operator')
		elseif tmp == 'x' then
			print('variable')
		elseif tmp == '(' then
			print('opening bracket')
		elseif tmp == ')' then
			print('closing bracket')
		elseif tmp == ' ' then
			print('space')
		else
			print('invalid')
		end

		-- print(tmp .. '\n ')
	end
	

	-- print(string.len(arg))
end

------------------------------------------------------------------------------------



-------------------- CALCULATOR FRAME ACTION FUNCTIONS --------------------

function MakeMovable_()
	calculatorParentFrame:SetMovable(true)
end

function MakeUnmovable_()
	calculatorParentFrame:SetMovable(false)
end

function toggleCalc()
	if isCalcShowing then
		calculatorParentFrame:Hide()
		isCalcShowing = false
		SetBinding("ENTER", "OPENCHAT")
	else
		calculatorParentFrame:Show()
		isCalcShowing = true
		SetBinding("ENTER")
	end
end

function closeCalc()
	calculatorParentFrame:Hide()
	isCalcShowing = false
	SetBinding("ENTER", "OPENCHAT")
end

---------------------------------------------------------------------------



-------------------- /calc SLASH COMMAND HANDLER FUNCTION --------------------

local function slashCalc(arg)
	local userArg = string.len(arg) > 0

	if userArg then
		if arg == "toggle" then
			toggleCalc()
		elseif arg == "hide" then
			calculatorParentFrame:Hide()
			isCalcShowing = false
		elseif arg == "show" then
			calculatorParentFrame:Show()
			isCalcShowing = true
		elseif arg == "showhistory" then
			showHistory = true
		elseif arg == "hidehistory" then
			showHistory = false
		elseif arg == "unlock" then
			MakeMovable_()
		elseif arg == "lock" then
			MakeUnmovable_()
		elseif arg == "config" then
			InterfaceOptionsFrame_OpenToCategory(Calc.panel)
			InterfaceOptionsFrame_OpenToCategory(Calc.panel)
		elseif arg == "help" then
			print('-----------------------------------------------------\n ')
			print('    /calc  ~  opens calculator\n ')
			print('    /calc showhistory  ~  prints input history to chat window (default)\n ')
			print('    /calc hidehistory  ~  hides input history\n ')
			print('-----------------------------------------------------\n ')
		else
			print('Invalid command.')
		end
	else
		if isCalcShowing == true then
			calculatorParentFrame:Hide()
			isCalcShowing = false
			SetBinding("ENTER", "OPENCHAT")
		else
			calculatorParentFrame:Show()
			isCalcShowing = true
			SetBinding("ENTER")
		end
	end
end

------------------------------------------------------------------------------



SlashCmdList["CALC"] = slashCalc
SlashCmdList["SOLVE"] = slashSolve










-------------------- MAIN INTERFACE OPTIONS PANELS --------------------

-- Calc = {}
-- Calc.panel = CreateFrame("Frame", "ParentCalcPanel", UIParent)										-- Parent frame
-- Calc.panel.name = "Calculator"
-- InterfaceOptions_AddCategory(Calc.panel)

-- Calc.childpanel = CreateFrame("Frame", "ChildCalcPanel", Calc.panel)								-- Child frame
-- Calc.childpanel.parent = Calc.panel.name
-- InterfaceOptions_AddCategory(Calc.childpanel)

-- local scrollFrame = CreateFrame("ScrollFrame", nil, Calc.panel, "UIPanelScrollFrameTemplate")		-- Parent scroll frame inside parent frame
-- scrollFrame:SetPoint("TOPLEFT", 3, -4)
-- scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

-- local scrollChild = CreateFrame("Frame")															-- Child scroll frame inside parent scroll frame (where everything is)
-- scrollFrame:SetScrollChild(scrollChild)
-- scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth()-18)
-- scrollChild:SetHeight(1)

-- local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")					-- Interface options title (child scroll frame)
-- title:SetPoint("TOP", -5, -30)
-- title:SetText("-- CALCULATOR CONFIGURATION MENU --")

-- local footer = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")						-- Interface options footer (child scroll frame)
-- footer:SetPoint("TOP", 0, -600)
-- footer:SetText("---\n ")

-- local calcToggleBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")				--  Toggle calculator visibility
-- calcToggleBtn:SetPoint("CENTER", 0, -200)
-- calcToggleBtn.Text:SetText("Toggle")
-- calcToggleBtn:SetWidth(100)
-- calcToggleBtn:SetScript( "OnClick", function (self, button, down) print('Toggle'); toggleCalc(); end )

-----------------------------------------------------------------------