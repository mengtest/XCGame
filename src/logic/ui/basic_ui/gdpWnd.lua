------------------
-- 主界面
------------------
module("ui", package.seeall)

clsGDPWnd = class("clsGDPWnd", clsWindow)

function clsGDPWnd:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_publics/gdp_wnd.lua")
	self:setPositionY(GAME_CONFIG.SCREEN_H_2-25)
	
	utils.RegButtonEvent(self:GetCompByName("btn_addmoney"), function()
		ClsSystemMgr.GetInstance():EnterSystem("购买金币")
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_adddiamond"), function()
		ClsSystemMgr.GetInstance():EnterSystem("充值")
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_addpower"), function()
		ClsSystemMgr.GetInstance():EnterSystem("购买体力")
	end)
	
	
	local HeroData = KE_Director:GetHeroData()
	HeroData:AddListener(self, "iMoney", function()
		self:GetCompByName("LabelMoney"):setString(HeroData:GetiMoney())
	end, true)
	HeroData:AddListener(self, "iDiamond", function()
		self:GetCompByName("LabelDiamond"):setString(HeroData:GetiDiamond())
	end, true)
end

function clsGDPWnd:dtor()
	local HeroData = KE_Director:GetHeroData()
	HeroData:DelListener(self)
end
