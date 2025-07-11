-- $Id: ItemFrame_GUI.lua 3697 2012-01-31 15:17:37Z lag123 $
local AtlasLoot = LibStub("AceAddon-3.0"):GetAddon("AtlasLoot")

local AL = LibStub("AceLocale-3.0"):GetLocale("AtlasLoot");

local GREY = "|cff999999"
local RED = "|cffff0000"
local WHITE = "|cffFFFFFF"
local GREEN = "|cff1eff00"
local PURPLE = "|cff9F3FFF"
local BLUE = "|cff0070dd"
local ORANGE = "|cffFF8400"

local function onShow(self)
	if self:GetParent():GetFrameStrata() ~= self:GetFrameStrata() then
		self:SetFrameStrata(self:GetParent():GetFrameStrata())
	end
end

function AtlasLoot:CreateItemFrame()
	if AtlasLoot.ItemFrame then return end
	AtlasLoot.ItemFrame = CreateFrame("Frame","AtlasLootItemsFrame")

	local Frame = AtlasLoot.ItemFrame
	Frame:ClearAllPoints()
	Frame:SetParent(UIParent)
	Frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
	Frame:SetFrameLevel(Frame:GetParent():GetFrameLevel() + 1)
	Frame:SetWidth(510)
	Frame:SetHeight(510)
	Frame:SetScript("OnHide", self.ItemsFrameOnCloseButton)
	Frame:SetScript("OnShow", onShow)

	Frame.CloseButton = CreateFrame("Button","AtlasLootItemsFrame_CloseButton",Frame,"UIPanelCloseButton")
	Frame.CloseButton:SetPoint("TOPRIGHT", Frame, "TOPRIGHT", -5, -5)
	Frame.CloseButton:SetScript("OnClick", AtlasLoot.ItemsFrameOnCloseButton)
	--Frame.CloseButton:SetScript("OnShow",function(self) self:SetFrameLevel( self:GetParent():GetFrameLevel() + 1 ) end)
	Frame.CloseButton:Hide()

	---------------
	-- loot frame
	---------------
	Frame.BackGround = Frame:CreateTexture("AtlasLootItemsFrame_Back","BACKGROUND")
	Frame.BackGround:SetPoint("TOPLEFT", Frame, "TOPLEFT")
	Frame.BackGround:SetTexture(0,0,0,0.7)
	Frame.BackGround:SetHeight(510)
	Frame.BackGround:SetWidth(510)

	Frame.BossName = Frame:CreateFontString("AtlasLoot_BossName","OVERLAY","GameFontHighlightLarge")
	Frame.BossName:SetPoint("TOP", Frame, "TOP", -25, 0)
	Frame.BossName:SetJustifyH("CENTER")
	Frame.BossName:SetText("")
	Frame.BossName:SetWidth(512)
	Frame.BossName:SetHeight(30)

	Frame.AttuneFrame = Frame:CreateFontString("AtlasLoot_BossName","OVERLAY","GameFontHighlightLarge")
	Frame.AttuneFrame:SetPoint("TOP", Frame, "TOP", -25 - 90, 0)
	Frame.AttuneFrame:SetJustifyH("RIGHT")
	Frame.AttuneFrame:SetText("")
	Frame.AttuneFrame:SetWidth(512)
	Frame.AttuneFrame:SetHeight(30)

	Frame.TitanForgedFrame = Frame:CreateFontString("AtlasLoot_BossName","OVERLAY","GameFontHighlightLarge")
	Frame.TitanForgedFrame:SetPoint("TOP", Frame, "TOP", -25 - 60, 0)
	Frame.TitanForgedFrame:SetJustifyH("RIGHT")
	Frame.TitanForgedFrame:SetText("")
	Frame.TitanForgedFrame:SetWidth(512)
	Frame.TitanForgedFrame:SetHeight(30)

	Frame.WarForgedFrame = Frame:CreateFontString("AtlasLoot_BossName","OVERLAY","GameFontHighlightLarge")
	Frame.WarForgedFrame:SetPoint("TOP", Frame, "TOP", -25 - 30, 0)
	Frame.WarForgedFrame:SetJustifyH("RIGHT")
	Frame.WarForgedFrame:SetText("")
	Frame.WarForgedFrame:SetWidth(512)
	Frame.WarForgedFrame:SetHeight(30)

	Frame.LightForgedFrame = Frame:CreateFontString("AtlasLoot_BossName","OVERLAY","GameFontHighlightLarge")
	Frame.LightForgedFrame:SetPoint("TOP", Frame, "TOP", -25 - 0, 0)
	Frame.LightForgedFrame:SetJustifyH("RIGHT")
	Frame.LightForgedFrame:SetText("")
	Frame.LightForgedFrame:SetWidth(512)
	Frame.LightForgedFrame:SetHeight(30)

	Frame.ItemButtons = {}
	for i=1,30 do
		if i == 1 then
			Frame.ItemButtons[i] = self:CreateItemButton(Frame, {"TOPLEFT", Frame, "TOPLEFT", 25, -35}, "AtlasLootItem_"..i)
		elseif i == 16 then
			Frame.ItemButtons[i] = self:CreateItemButton(Frame, {"TOPLEFT", "AtlasLootItem_1", "TOPRIGHT"}, "AtlasLootItem_"..i)
		else
			Frame.ItemButtons[i] = self:CreateItemButton(Frame, {"TOPLEFT", "AtlasLootItem_"..i-1, "BOTTOMLEFT"}, "AtlasLootItem_"..i)
		end
		Frame.ItemButtons[i].buttonID = i
	end

	Frame.Switch = CreateFrame("Button","AtlasLoot10Man25ManSwitch",Frame,"UIPanelButtonTemplate2")
	Frame.Switch:SetWidth(160)
	Frame.Switch:SetHeight(23)
	Frame.Switch:SetPoint("BOTTOM", Frame, "BOTTOM", -120, 4)
	Frame.Switch:SetScript("OnClick", AtlasLoot.Toggle10Man25Man)
	Frame.Switch:Hide()

	Frame.Heroic = CreateFrame("CheckButton", "AtlasLootItemsFrame_Heroic", Frame, "OptionsCheckButtonTemplate")
	Frame.Heroic:SetPoint("BOTTOM", Frame, "BOTTOM", -185, 24)
	Frame.Heroic:SetWidth(25)
	Frame.Heroic:SetHeight(25)
	_G[Frame.Heroic:GetName().."Text"]:SetText(AL["Heroic Mode"])
	Frame.Heroic:SetScript("OnShow", function(self)
		self:SetFrameLevel( (self:GetParent()):GetFrameLevel() + 1 )
	end)
	Frame.Heroic:SetScript("OnClick", AtlasLoot.HeroicModeToggle)
	Frame.Heroic:Hide()

	Frame.Back = CreateFrame("Button","AtlasLootItemsFrame_BACK",Frame,"UIPanelButtonTemplate2")
	Frame.Back:SetWidth(80)
	Frame.Back:SetText(AL["Back"])
	Frame.Back:SetPoint("BOTTOM", Frame, "BOTTOM", 0, 4)
	Frame.Back:SetScript("OnClick", AtlasLoot.NavButton_OnClick)
	Frame.Back:Hide()

	Frame.Next = CreateFrame("Button","AtlasLootItemsFrame_NEXT",Frame)
	Frame.Next:SetWidth(30)
	Frame.Next:SetHeight(30)
	Frame.Next:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	Frame.Next:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	Frame.Next:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
	Frame.Next:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--Frame.Next:SetFrameStrata("HIGH")
	Frame.Next:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", -5, 5)
	Frame.Next:SetScript("OnClick", AtlasLoot.NavButton_OnClick)
	Frame.Next:SetScript("OnShow", function(self) self:SetFrameLevel( (self:GetParent()):GetFrameLevel() + 1 ) end)

	Frame.NextBack = Frame.Next:CreateTexture(nil,"BACKGROUND")
	Frame.NextBack:SetPoint("CENTER", Frame.Next, "CENTER", 0, 1)
	Frame.NextBack:SetTexture("Interface\\Buttons\\UI-PageButton-Background")
	Frame.NextBack:SetHeight(30)
	Frame.NextBack:SetWidth(30)
	Frame.Next:Hide()

	Frame.Prev = CreateFrame("Button","AtlasLootItemsFrame_PREV",Frame)
	Frame.Prev:SetWidth(30)
	Frame.Prev:SetHeight(30)
	Frame.Prev:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	Frame.Prev:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	Frame.Prev:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
	Frame.Prev:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--Frame.Prev:SetFrameStrata("HIGH")
	Frame.Prev:SetPoint("BOTTOMLEFT", Frame, "BOTTOMLEFT", 12, 8)
	Frame.Prev:SetScript("OnClick", AtlasLoot.NavButton_OnClick)
	Frame.Prev:SetScript("OnShow", function(self) self:SetFrameLevel( (self:GetParent()):GetFrameLevel() + 1 ) end)

	Frame.PrevBack = Frame.Prev:CreateTexture(nil,"BACKGROUND")
	Frame.PrevBack:SetPoint("CENTER", Frame.Prev, "CENTER", 0, 1)
	Frame.PrevBack:SetTexture("Interface\\Buttons\\UI-PageButton-Background")
	Frame.PrevBack:SetHeight(30)
	Frame.PrevBack:SetWidth(30)
	Frame.Prev:Hide()

	Frame.ServerQuery = CreateFrame("Button","AtlasLootServerQueryButton",Frame,"UIPanelButtonTemplate2")
	Frame.ServerQuery:SetWidth(160)
	Frame.ServerQuery:SetHeight(23)
	Frame.ServerQuery:SetPoint("BOTTOM", Frame, "BOTTOM", 120, 4)
	Frame.ServerQuery:SetScript("OnShow", function(self)
		self:SetText(AL["Query Server"])
		self:SetFrameLevel( (self:GetParent()):GetFrameLevel() + 1 )
	end)
	Frame.ServerQuery:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -(self:GetWidth() / 2), 5)
		GameTooltip:AddLine("|cffff0000"..AL["Query Server"])
		GameTooltip:AddLine(AL["Queries the server for all items \non this page. The items will be \nrefreshed when you next mouse \nover them."])
		GameTooltip:Show()
	end)
	Frame.ServerQuery:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	Frame.ServerQuery:SetScript("OnClick", function()
		GameTooltip:Hide()
		AtlasLoot:QueryLootPage()
	end)

	Frame.QuickLooks = CreateFrame("Button","AtlasLootQuickLooksButton",Frame)
	Frame.QuickLooks:SetWidth(23)
	Frame.QuickLooks:SetHeight(23)
	Frame.QuickLooks:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	Frame.QuickLooks:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	Frame.QuickLooks:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
	Frame.QuickLooks:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	--Frame.QuickLooks:SetFrameStrata("HIGH")
	Frame.QuickLooks:SetPoint("BOTTOM", Frame, "BOTTOM", 53, 28)
	Frame.QuickLooks:SetScript("OnClick", AtlasLoot.ShowQuickLooks)
	Frame.QuickLooks:SetScript("OnShow", function(self)
		self:Enable()
	end)

	Frame.QuickLooksDropDownMenu = CreateFrame("Frame", "AtlasLootQuickLooksButtonDropDownMenu")
	Frame.QuickLooksDropDownMenu.displayMode = "MENU"
	Frame.QuickLooksDropDownMenu.initialize = self.QuickLooks_DropDownInit

	Frame.QuickLooksName = Frame:CreateFontString("AtlasLoot_QuickLooks","OVERLAY","GameFontNormal")
	Frame.QuickLooksName:SetPoint("BOTTOM", Frame, "BOTTOM", -57, 28)
	Frame.QuickLooksName:SetText(AL["Add to QuickLooks:"])
	Frame.QuickLooksName:SetJustifyH("RIGHT")
	Frame.QuickLooksName:SetWidth(200)
	Frame.QuickLooksName:SetHeight(25)

	Frame.SetItemsTable = AtlasLoot.ItemFrame_SetItemsTable

	Frame:Hide()
end
