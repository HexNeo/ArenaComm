ArenaComm = LibStub("AceAddon-3.0"):NewAddon("ArenaComm")
local AceGUI = LibStub("AceGUI-3.0");
settings = {};

local main_frame = {};
local unit_frames = {};

local myTimer;

-- local settingsVisible = false;
local frameSettings;
local frameSettingsVisible = false;
local mooving = false;


local specs = {
    [62] = { specID = 62, specName = "Arcane", specNameRu = "Тайная магия", class = "MAGE" },
    [63] = { specID = 63, specName = "Fire", specNameRu = "Огонь", class = "MAGE" },
    [64] = { specID = 64, specName = "Frost", specNameRu = "Лед", class = "MAGE" },
    [65] = { specID = 65, specName = "Holy", specNameRu = "Свет", class = "PALADIN" },
    [66] = { specID = 66, specName = "Protection", specNameRu = "Защита", class = "PALADIN" },
    [70] = { specID = 70, specName = "Retribution", specNameRu = "Возмездие", class = "PALADIN" },
    [71] = { specID = 71, specName = "Arms", specNameRu = "Оружие", class = "WARRIOR" },
    [72] = { specID = 72, specName = "Fury", specNameRu = "Неистовство", class = "WARRIOR" },
    [73] = { specID = 73, specName = "Protection", specNameRu = "Защита", class = "WARRIOR" },
    [102] = { specID = 102, specName = "Balance", specNameRu = "Баланс", class = "DRUID" },
    [103] = { specID = 103, specName = "Feral", specNameRu = "Сила зверя", class = "DRUID" },
    [104] = { specID = 104, specName = "Guardian", specNameRu = "Страж", class = "DRUID" },
    [105] = { specID = 105, specName = "Restoration", specNameRu = "Исцеление", class = "DRUID" },
    [250] = { specID = 250, specName = "Blood", specNameRu = "Кровь", class = "DEATHKNIGHT" },
    [251] = { specID = 251, specName = "Frost", specNameRu = "Лед", class = "DEATHKNIGHT" },
    [252] = { specID = 252, specName = "Unholy", specNameRu = "Нечестивость", class = "DEATHKNIGHT" },
    [253] = { specID = 253, specName = "Beast Mastery", specNameRu = "Повелитель зверей", class = "HUNTER" },
    [254] = { specID = 254, specName = "Marksmanship", specNameRu = "Стрельба", class = "HUNTER" },
    [255] = { specID = 255, specName = "Survival", specNameRu = "Выживание", class = "HUNTER" },
    [256] = { specID = 256, specName = "Discipline", specNameRu = "Послушание", class = "PRIEST" },
    [257] = { specID = 257, specName = "Holy", specNameRu = "Свет", class = "PRIEST" },
    [258] = { specID = 258, specName = "Shadow", specNameRu = "Тьма", class = "PRIEST" },
    [259] = { specID = 259, specName = "Assassination", specNameRu = "Ликвидация", class = "ROGUE" },
    [260] = { specID = 260, specName = "Outlaw", specNameRu = "Головорез", class = "ROGUE" },
    [261] = { specID = 261, specName = "Subtlety", specNameRu = "Скрытность", class = "ROGUE" },
    [262] = { specID = 262, specName = "Elemental", specNameRu = "Стихии", class = "SHAMAN" },
    [263] = { specID = 263, specName = "Enhancement", specNameRu = "Совершенствование", class = "SHAMAN" },
    [264] = { specID = 264, specName = "Restoration", specNameRu = "Исцеление", class = "SHAMAN" },
    [265] = { specID = 265, specName = "Affliction", specNameRu = "Колдовство", class = "WARLOCK" },
    [266] = { specID = 266, specName = "Demonology", specNameRu = "Демонология", class = "WARLOCK" },
    [267] = { specID = 267, specName = "Destruction", specNameRu = "Разрушение", class = "WARLOCK" },
    [268] = { specID = 268, specName = "Brewmaster", specNameRu = "Хмелевар", class = "MONK" },
    [269] = { specID = 269, specName = "Windwalker", specNameRu = "Танцующий с ветром", class = "MONK" },
    [270] = { specID = 270, specName = "Mistweaver", specNameRu = "Ткач туманов", class = "MONK" },
    [577] = { specID = 577, specName = "Havoc", specNameRu = "Истребление", class = "DEMONHUNTER" },
    [581] = { specID = 581, specName = "Vengeance", specNameRu = "Месть", class = "DEMONHUNTER" },
    [1467] = { specID = 1467, specName = "Devastation", specNameRu = "Опустошение", class = "EVOKER" },
    [1468] = { specID = 1468, specName = "Preservation", specNameRu = "Сохранение", class = "EVOKER" },
    [1473] = { specID = 1473, specName = "Augmentation", specNameRu = "Насыщатель", class = "EVOKER" }
}

local debugMode = false
if debugMode then
	--@debug@
	--"Version: " .. '@project-version@'
	--@end-debug@
end

function ArenaComm:OnDisable()
	-- print("ArenaComm:OnInitialize");
end

function ArenaComm:OnInitialize()
	-- print("ArenaComm:OnInitialize");
end

function ArenaComm:OnEnable()
	if not settings then
		settings = {};
	end

	-- init settings
	if settings then
		if not settings.messages then
			settings.messages = { left = "target?", right = "ok", middle = "some target or random bullshit go?"}
		end

		if not settings.bpoint or not isString(settings.bpoint) then
			settings.bpoint = "LEFT";
		end

		if not settings.brelativeTo or not isString(settings.brelativeTo) then
			settings.brelativeTo = "UIParent";
		end

		if not settings.brelativePoint or not isString(settings.brelativePoint) then
			settings.brelativePoint = "LEFT";
		end

		if not settings.bxOfs or not isNumber(settings.bxOfs) then
			settings.bxOfs = 320;
		end

		if not settings.byOfs or not isNumber(settings.byOfs) then
			settings.byOfs = 200;
		end
	end

	-- print("ArenaComm:OnEnable");
	main_frame.frame = CreateFrame("Frame", "MainFrame", UIParent);
	main_frame.frame:SetFrameStrata("BACKGROUND");
	main_frame.frame:SetSize(260, 64);
	if (settings and settings.bxOfs and settings.byOfs) then
		main_frame.frame:SetPoint(settings.bpoint, settings.brelativeTo, settings.brelativePoint, settings.bxOfs, settings.byOfs);
	else
		main_frame.frame:SetPoint("LEFT", UIParent, "LEFT", 320, 200);
	end

	main_frame.frame:SetMovable(true);
	main_frame.frame:EnableMouse(true);
	main_frame.frame:RegisterForDrag("RightButton");
	main_frame.frame:SetScript("OnDragStart", main_frame.frame.StartMoving);
	main_frame.frame:SetScript("OnDragStop", 
		function(self) 
			self:StopMovingOrSizing();

			local p, rTo, rP, xO, yO = self:GetPoint();
			settings.bpoint = p;
			settings.brelativeTo = rTo;
			settings.brelativePoint = rP;
			settings.bxOfs = xO;
			settings.byOfs = yO;
		end
	);

	main_frame.border = {};
	-- main_frame.border.line1 = main_frame.frame:CreateLine();
	-- main_frame.border.line1:SetColorTexture(0.5, 0, 0, 0.5);
	-- main_frame.border.line1:SetStartPoint("BOTTOMLEFT", 0, 0);
	-- main_frame.border.line1:SetEndPoint("BOTTOMRIGHT", 0, 0);

	-- main_frame.border.line2 = main_frame.frame:CreateLine();
	-- main_frame.border.line2:SetColorTexture(0.5, 0, 0, 0.5);
	-- main_frame.border.line2:SetStartPoint("TOPLEFT", 0, 0);
	-- main_frame.border.line2:SetEndPoint("TOPRIGHT", 0, 0);

	-- main_frame.border.line3 = main_frame.frame:CreateLine();
	-- main_frame.border.line3:SetColorTexture(0.5, 0, 0, 0.5);
	-- main_frame.border.line3:SetStartPoint("BOTTOMLEFT", 0, 0);
	-- main_frame.border.line3:SetEndPoint("TOPLEFT", 0, 0);

	main_frame.border.line4 = main_frame.frame:CreateLine();
	main_frame.border.line4:SetColorTexture(0.5, 0, 0, 0.5);
	main_frame.border.line4:SetStartPoint("BOTTOMRIGHT", 0, 0);
	main_frame.border.line4:SetEndPoint("TOPRIGHT", 0, 0);

	main_frame.icon_quetion = CreateFrame("Button", "ClassIcon", main_frame.frame);
	main_frame.icon_quetion:SetFrameStrata("BACKGROUND");
	main_frame.icon_quetion:SetPoint("LEFT", main_frame.frame, 0, 0);
	main_frame.icon_quetion:SetSize(64, 64);
	-- Interface\\Icons\\INV_Misc_QuestionMark
	main_frame.icon_quetion:SetNormalTexture("Interface\\ICONS\\Spell_Holy_PainSupression");
	main_frame.icon_quetion:RegisterForClicks("AnyUp"); -- , "AnyDown"
	main_frame.icon_quetion:SetScript("OnClick", 
		function (self, button, down)
			if button == "LeftButton" then
				-- print(self, button, down);
				SendChatMessage(settings.messages.left, "SAY", "Common");
			elseif button == "MiddleButton" then
				SendChatMessage(settings.messages.middle, "SAY", "Common");
			else
				SendChatMessage(settings.messages.right, "SAY", "Common");
			end
		end
	);

	-- Set the OnEnter script to show the tooltip
	main_frame.icon_quetion:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Messages", 1, 1, 1)
		GameTooltip:AddLine("Left click message: " .. settings.messages.left, 1, 1, 1, true)
		GameTooltip:AddLine("Right click message: " .. settings.messages.right, 1, 1, 1, true)
		GameTooltip:AddLine("Middle click message: " .. settings.messages.middle, 1, 1, 1, true)
		GameTooltip:Show()
	end)

	-- Set the OnLeave script to hide the tooltip
	main_frame.icon_quetion:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)



	for i = 1, 3 do
		local unit = "arena" .. i
		CreateUnitFrameN(i, unit);
	end

	main_frame.icon_settings = CreateFrame("Button", "ClassIcon", main_frame.frame);
	main_frame.icon_settings:SetFrameStrata("BACKGROUND");
	main_frame.icon_settings:SetPoint("LEFT", main_frame.frame, 256, 0);
	main_frame.icon_settings:SetSize(64, 64);
	main_frame.icon_settings:SetNormalTexture("Interface\\ICONS\\Icon_PetFamily_Mechanical");
	main_frame.icon_settings:RegisterForClicks("AnyUp", "AnyDown"); -- 
	main_frame.icon_settings:SetScript("OnClick", 
		function (self, button, down)
			-- print(self, button, down);
			
			if button == "LeftButton" then
				if not frameSettingsVisible then
					CreateSettingsFrame();
				end
			elseif button == "MiddleButton" then
				
			else
				if mooving and not down then
					mooving = false;
					main_frame.frame:StopMovingOrSizing();
					local p, rTo, rP, xO, yO = main_frame.frame:GetPoint();
					settings.bpoint = p;
					settings.brelativeTo = rTo;
					settings.brelativePoint = rP;
					settings.bxOfs = xO;
					settings.byOfs = yO;
				elseif down then
					mooving = true;
					main_frame.frame:StartMoving();
				end
			end
		end
	);

	-- Set the OnEnter script to show the tooltip
	main_frame.icon_settings:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Settings", 1, 1, 1)
		GameTooltip:AddLine("Click to open settings.", 1, 1, 1, true)
		GameTooltip:AddLine("Right click to move frame.", 1, 1, 1, true)
		GameTooltip:Show()
	end)

	-- Set the OnLeave script to hide the tooltip
	main_frame.icon_settings:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-- main_frame.icon_settings:SetScript("OnDragStart", main_frame.frame.StartMoving);
	-- main_frame.icon_settings:SetScript("OnDragStop", 
	-- 	function(self) 
	-- 		self:StopMovingOrSizing();

	-- 		local p, rTo, rP, xO, yO = self:GetPoint();
	-- 		settings.bpoint = p;
	-- 		settings.brelativeTo = rTo;
	-- 		settings.brelativePoint = rP;
	-- 		settings.bxOfs = xO;
	-- 		settings.byOfs = yO;
	-- 	end
	-- );

	myTimer = C_Timer.NewTicker(2, function(self) ArenaComm:Refresh() end);

	ArenaComm:PrintMessage("|cffcccccc ArenaComm |r : |cff37ff37Initialized!|r");
end

function isNumber(value)
    return type(value) == "number"
end

function isString(value)
    return type(value) == "string"
end

function capitalize(str)
	if not str then return nil end
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

function ArenaComm:Refresh()
	-- print("Refreshing arena frames");
	if UnitAffectingCombat("player") or 
		(UnitExists("party1") and UnitAffectingCombat("party1")) or 
		(UnitExists("party2") and UnitAffectingCombat("party2")) or 
		(UnitExists("arena1") and UnitAffectingCombat("arena1")) or 
		(UnitExists("arena2") and UnitAffectingCombat("arena2")) or 
		(UnitExists("arena3") and UnitAffectingCombat("arena3")) then
			-- print("In combat, skipping refresh");
		return;
	end

	-- ArenaComm:PrintMessage("Refreshing arena frames");
	for i = 1, 3 do
		local unit = "arena" .. i
		-- print("Checking unit " .. unit);
		if GetArenaUnitSpec(unit) then
			-- local localizedClass, englishClass, classID = UnitClass(unit);
			CreateUnitFrameN(i, unit);
		end
	end
end

function CreateUnitFrameN(i, unit)
	-- print("Creating frame " .. i);
	local specID, specName, icon, class = GetArenaUnitSpec(unit);

	local specID1, specName1, icon1, class1 = GetArenaUnitSpec("arena1");
	local specID2, specName2, icon2, class2 = GetArenaUnitSpec("arena2");
	local specID3, specName3, icon3, class3 = GetArenaUnitSpec("arena3");

	local specText = "";

	if specID then
		if specs[specID] then
			-- print("SpecID: " .. specID);
			specName = specs[specID].specName;
			class = specs[specID].class;
		else
			-- print("SpecID: " .. specID .. " not found in specs");
		end
	end

	-- in case same class or even same spec
	if specName then
		if i == 1 and ((class == class2) or (class == class3)) then
			if specID == specID2 or specID == specID3 then
				specText = " arena1";
			else
				specText = " " .. specName;
			end
		elseif i == 2 and ((class == class1) or (class == class3)) then
			if specID == specID1 or specID == specID3 then
				specText = " arena2";
			else
				specText = " " .. specName;
			end
		elseif i == 3 and ((class == class1) or (class == class2)) then
			if specID == specID1 or specID == specID2 then
				specText = " arena3";
			else
				specText = " " .. specName;
			end
		end
	end

	if not unit_frames[i] then
		-- print("Creating frame " .. i);
		unit_frames[i] = {};
		unit_frames[i].button = CreateFrame("Button", "ArenaIcon"..i, main_frame.frame);
		unit_frames[i].button:SetFrameStrata("BACKGROUND");
		unit_frames[i].button:SetPoint("LEFT", main_frame.frame, 0 + (64 * i), 0);
		unit_frames[i].button:SetSize(64, 64);
		if icon then
			-- print("Creating icon and script " .. icon);
			unit_frames[i].button:SetNormalTexture(icon);
			unit_frames[i].button:RegisterForClicks("AnyUp"); -- , "AnyDown"
			unit_frames[i].button:SetScript("OnClick", 
				function(self, button, down) 
					if button == "LeftButton" then
						SendChatMessage("go " .. capitalize(class) .. specText .. "", "SAY", "Common");
					elseif button == "MiddleButton" then
						SendChatMessage("target " .. capitalize(class) .. specText .. "?", "SAY", "Common");
					else
						SendChatMessage("cc " .. capitalize(class) .. specText .. "?", "SAY", "Common");
					end
				end
			);

			-- Set the OnEnter script to show the tooltip
			unit_frames[i].button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText("Messages", 1, 1, 1)
				GameTooltip:AddLine("Left click message: go " .. capitalize(class) .. specText, 1, 1, 1)
				GameTooltip:AddLine("Right click message: cc " .. capitalize(class) .. specText .. "", 1, 1, 1, true)
				GameTooltip:AddLine("Middle click message: target " .. capitalize(class) .. specText .. "?", 1, 1, 1, true)
				GameTooltip:Show()
			end)

			-- Set the OnLeave script to hide the tooltip
			unit_frames[i].button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		else
			unit_frames[i].button:SetNormalTexture("Interface\\Icons\\INV_Misc_QuestionMark");

			-- Set the OnEnter script to show the tooltip
			unit_frames[i].button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText("no on click messages loaded, enter arena and them will be loaded automatically", 1, 1, 1)
				GameTooltip:Show()
			end)

			-- Set the OnLeave script to hide the tooltip
			unit_frames[i].button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		end
	elseif unit_frames[i] and specID and (not unit_frames[i].data or unit_frames[i].data.specID ~= specID) then
		-- print("Updating frame " .. i);
		if icon then
			-- print("Setting icon " .. icon);
			unit_frames[i].button:SetNormalTexture(icon);
		else
			unit_frames[i].button:SetNormalTexture("Interface\\Icons\\INV_Misc_QuestionMark");
		end

		if class and specName then
			-- print("Setting script " .. class .. " " .. specName);
			unit_frames[i].button:RegisterForClicks("AnyUp");
			unit_frames[i].button:SetScript("OnClick", 
				function(self, button, down) 
					if button == "LeftButton" then
						SendChatMessage("go " .. capitalize(class) .. specText .. "", "SAY", "Common");
					elseif button == "MiddleButton" then
						SendChatMessage("target " .. capitalize(class) .. specText .. "?", "SAY", "Common");
					else
						SendChatMessage("cc " .. capitalize(class) .. specText .. "", "SAY", "Common");
					end
				end
			);

			-- Set the OnEnter script to show the tooltip
			unit_frames[i].button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText("Messages", 1, 1, 1)
				GameTooltip:AddLine("Left click message: go " .. capitalize(class) .. specText, 1, 1, 1)
				GameTooltip:AddLine("Right click message: cc " .. capitalize(class) .. specText .. "", 1, 1, 1, true)
				GameTooltip:AddLine("Middle click message: target " .. capitalize(class) .. specText .. "?", 1, 1, 1, true)
				GameTooltip:Show()
			end)

			-- Set the OnLeave script to hide the tooltip
			unit_frames[i].button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
		end
	end

	if (specID and specName and icon and class) then
		unit_frames[i].data = { specID = specID, specName = specName, icon = icon, class = class};
	end
end

function ArenaComm:PrintMessage(msg) 
	(SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME):AddMessage("|TInterface/Addons/WhatTheNext/media/pvp_chat.tga:0|t " .. msg)
end

function GetArenaUnitSpec(unit)
    local id = strmatch(unit, "^arena(%d+)$")
    if id then
        local specID = GetArenaOpponentSpec(tonumber(id))
        if specID and specID > 0 then
			-- id, name, description, icon, role, primaryStat = GetSpecializationInfo(specIndex [, isInspect, isPet, inspectTarget, sex])
			local specID, specName, description, icon, background, role, class, classID, specIndex = GetSpecializationInfoByID(specID)
            -- local specName, _, _, icon, _, class = GetSpecializationInfoByID(specID)
            return specID, specName, icon, class
        end
    end
    return nil
end

function CreateSettingsFrame()
	frameSettingsVisible = true;
	local title = "Settings for Arena Communication";
	local statusText = "Right click settings icon to move the frame";

	frameSettings = AceGUI:Create("Frame")
	frameSettings:SetTitle(title)
	frameSettings:SetStatusText(statusText)
	frameSettings:SetCallback("OnClose", function(widget) AceGUI:Release(widget); frameSettingsVisible = false; end)
	frameSettings:SetLayout("Flow")

	local boxButtonSayLeft = AceGUI:Create("EditBox")
	boxButtonSayLeft:SetLabel("Say button left click:")
	if settings.messages.left then
		boxButtonSayLeft:SetText(settings.messages.left);
	end
	boxButtonSayLeft:SetWidth(200)
	boxButtonSayLeft:SetCallback("OnEnterPressed", function (widget, event, text, param2, param3) settings.messages.left = text end)
	frameSettings:AddChild(boxButtonSayLeft)

	local boxButtonSayMiddle = AceGUI:Create("EditBox")
	boxButtonSayMiddle:SetLabel("Say button middle click:")
	if settings.messages.middle then
		boxButtonSayMiddle:SetText(settings.messages.middle);
	end
	boxButtonSayMiddle:SetWidth(200)
	boxButtonSayMiddle:SetCallback("OnEnterPressed", function (widget, event, text, param2, param3) settings.messages.middle = text end)
	frameSettings:AddChild(boxButtonSayMiddle)

	local boxButtonSayRight = AceGUI:Create("EditBox")
	boxButtonSayRight:SetLabel("Say button right click:")
	if settings.messages.right then
		boxButtonSayRight:SetText(settings.messages.right);
	end
	boxButtonSayRight:SetWidth(200)
	boxButtonSayRight:SetCallback("OnEnterPressed", function (widget, event, text, param2, param3) settings.messages.right = text end)
	frameSettings:AddChild(boxButtonSayRight)
	
	frameSettings:Show();
	settingsVisible = true;
end

function HideSettingsFrames() 
	if frameSettings then
		frameSettings:Hide();
	end
end