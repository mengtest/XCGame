------------------
-- 圣物界面
------------------
module("ui", package.seeall)

clsRelicsPanel = class("clsRelicsPanel", clsCommonFrame)

function clsRelicsPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_relics/relics_panel.lua", "圣物")
	
end

function clsRelicsPanel:dtor()
	
end
