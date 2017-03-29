-------------
-- 钻石换金币
-------------
module("ui", package.seeall)

clsDiamond2MoneyWnd = class("clsDiamond2MoneyWnd", clsWindow)

function clsDiamond2MoneyWnd:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_exchange/diamond_2_money.lua")
	
	utils.RegButtonEvent(self:GetCompByName("btn_close"), function()
		KE_SetTimeout(1, function() self:Close() end)
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_use_1"), function()
		print("兑换一次")
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_use_10"), function()
		print("兑换十次")
	end)
	
	local InstExchangeMgr = KE_Director:GetExchangeMgr()
	local RemainTimes, MaxTimes = InstExchangeMgr:GetD2MRemainTimes(), InstExchangeMgr:GetD2MMaxTimes()
	self:GetCompByName("LabelTips"):setString( string.format("剩余次数：%d/%d",RemainTimes,MaxTimes) )
end

function clsDiamond2MoneyWnd:dtor()
	
end
