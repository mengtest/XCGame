------------------
-- 充值界面
------------------
module("ui", package.seeall)

clsRechargePanel = class("clsRechargePanel", clsCommonFrame)

function clsRechargePanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_vip/recharge_panel.lua", "充值")
	
end

function clsRechargePanel:dtor()
	
end
