------------------
-- 切磋界面
------------------
module("ui", package.seeall)

clsQiecuoPanel = class("clsQiecuoPanel", clsCommonFrame)

function clsQiecuoPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_qiecuo/qiecuo_panel.lua", "切磋")
	
end

function clsQiecuoPanel:dtor()
	
end
