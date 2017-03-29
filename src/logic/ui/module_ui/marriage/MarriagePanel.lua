------------------
-- 婚姻界面
------------------
module("ui", package.seeall)

clsMarriagePanel = class("clsMarriagePanel", clsCommonFrame)

function clsMarriagePanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_marriage/marriage_panel.lua", "婚姻")
	
end

function clsMarriagePanel:dtor()
	
end
