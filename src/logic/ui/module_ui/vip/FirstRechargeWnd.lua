------------------
-- 首冲界面
------------------
module("ui", package.seeall)

clsFirstRechargeWnd = class("clsFirstRechargeWnd", clsCommonFrame)

function clsFirstRechargeWnd:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_vip/first_recharge_wnd.lua", "首充")
	
end

function clsFirstRechargeWnd:dtor()
	
end
