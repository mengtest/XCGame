-------------
-- 装备界面
-------------
module("ui", package.seeall)

clsEquipPanel = class("clsEquipPanel", clsCommonFrame)

function clsEquipPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_equip/equip_panel.lua", "装备")
	
	local HeroData = KE_Director:GetHeroData()
	self.mUiRoleHero = ClsRoleMgr.GetInstance():CreateTempRole(HeroData:GetTypeId())
	self.mUiRoleHero:ShowName(false)
	KE_SetParent(self.mUiRoleHero, self:GetCompByName("suit_view"):GetCompByName("pendant_man"))
	self.mUiRoleHero:setScale(1.5)
end

function clsEquipPanel:dtor()
	if self.mUiRoleHero then
		self.mUiRoleHero = ClsRoleMgr.GetInstance():DestroyTempRole(self.mUiRoleHero) 
	end
end
