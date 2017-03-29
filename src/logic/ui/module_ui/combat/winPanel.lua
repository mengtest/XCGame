-------------
-- 主界面
-------------
module("ui", package.seeall)

clsWinPanel = class("clsWinPanel", clsWindow)

function clsWinPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_battle/win_panel.lua")
	self.mEff = ClsEffectMgr.GetInstance():NewEffectQuad("res/effects/particle/skills/ButterFly.plist", self)
	self.mEff:setPositionX(self:getContentSize().width/2)
end

function clsWinPanel:dtor()
	KE_SafeDelete(self.mEff)
	self.mEff = nil
end
