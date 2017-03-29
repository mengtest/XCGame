------------------
-- 我的国家界面
--
-- 1. 拜将（成员管理）
-- 2. 外交
-- 3. 监狱
-- 4. 封地
-- 5. 军令
-- 6. 后宫
------------------
module("ui", package.seeall)

clsMyCountryPanel = class("clsMyCountryPanel", clsCommonFrame)

function clsMyCountryPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_country/my_country.lua", "国家")
	
	-- 拜将
	utils.RegButtonEvent(self:GetCompByName("btn_baijiang"), function()
		utils.TellMe("拜将")
	end)
	-- 封地
	utils.RegButtonEvent(self:GetCompByName("btn_fengdi"), function()
		utils.TellMe("封地")
	end)
	-- 外交
	utils.RegButtonEvent(self:GetCompByName("btn_waijiao"), function()
		ClsUIManager.GetInstance():ShowPopWnd("clsCountryListPanel") 
	end)
	-- 监狱
	utils.RegButtonEvent(self:GetCompByName("btn_jianyu"), function()
		utils.TellMe("监狱")
	end)
	-- 后宫
	utils.RegButtonEvent(self:GetCompByName("btn_hougong"), function()
		ClsUIManager.GetInstance():ShowPopWnd("clsBeautyPanel") 
	end)
	-- 军令
	utils.RegButtonEvent(self:GetCompByName("btn_junling"), function()
		utils.TellMe("军令")
	end)
end

function clsMyCountryPanel:dtor()
	
end
