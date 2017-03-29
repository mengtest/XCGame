------------------
-- 融魂界面
------------------
module("ui", package.seeall)

clsSoulPanel = class("clsSoulPanel", clsCommonFrame)

function clsSoulPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_soul/soul_panel.lua", "融魂")
	
end

function clsSoulPanel:dtor()
	
end
