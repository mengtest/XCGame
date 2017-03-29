module("ui", package.seeall)

clsTipsWndItem = class("clsTipsWndItem", clsWindow)

function clsTipsWndItem:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_bag/item_tips_wnd.lua")
end

function clsTipsWndItem:dtor()
	
end

function clsTipsWndItem:UpdateContent(tContInfo)
	self.tContInfo = tContInfo
	local ItemType = tContInfo.ItemType
	local ItemId = tContInfo.ItemId
	
	--
	local ItemCfg = setting.T_item_cfg[ItemType]
	local strTips = ""
	strTips = strTips .. ItemCfg.sName
	strTips = "\n" .. strTips .. ItemCfg.Desc
	
	self:GetCompByName("label_title"):setString(strTips)
end

function clsTipsWndItem:GetContInfo()
	return self.tContInfo
end
