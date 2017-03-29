------------------
-- VIP特权界面
------------------
module("ui", package.seeall)

clsVipRightPanel = class("clsVipRightPanel", clsCommonFrame)

function clsVipRightPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_vip/vip_right_panel.lua", "VIP特权")
end

function clsVipRightPanel:dtor()
	
end
