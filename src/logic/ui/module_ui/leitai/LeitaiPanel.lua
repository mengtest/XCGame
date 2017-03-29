------------------
-- 擂台界面
------------------
module("ui", package.seeall)

clsLeitaiPanel = class("clsLeitaiPanel", clsCommonFrame)

function clsLeitaiPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_leitai/leitai_panel.lua", "擂台")
end

function clsLeitaiPanel:dtor()
	
end
