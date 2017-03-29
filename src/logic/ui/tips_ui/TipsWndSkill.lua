module("ui", package.seeall)

clsTipsWndSkill = class("clsTipsWndSkill", clsWindow)

function clsTipsWndSkill:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_bag/item_tips_wnd.lua")
end

function clsTipsWndSkill:dtor()
	
end

function clsTipsWndSkill:UpdateContent(tContInfo)
	self.tContInfo = tContInfo
	
end

function clsTipsWndSkill:GetContInfo()
	return self.tContInfo
end
