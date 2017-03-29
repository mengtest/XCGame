module("ui", package.seeall)

clsTipsWndRole = class("clsTipsWndRole", clsWindow)

function clsTipsWndRole:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_bag/item_tips_wnd.lua")
end

function clsTipsWndRole:dtor()
	
end

function clsTipsWndRole:UpdateContent(tContInfo)
	self.tContInfo = tContInfo
	
end

function clsTipsWndRole:GetContInfo()
	return self.tContInfo
end
