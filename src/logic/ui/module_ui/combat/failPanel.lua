-------------
-- 主界面
-------------
module("ui", package.seeall)

clsFailPanel = class("clsFailPanel", clsWindow)

function clsFailPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_battle/fail_panel.lua")
	
	local emitter = cc.ParticleSnow:createWithTotalParticles(1000)
	local rain_batch = cc.ParticleBatchNode:createWithTexture(emitter:getTexture())
	KE_SetParent(emitter, rain_batch)
	KE_SetParent(rain_batch, self)
	emitter:setPosition(self:getContentSize().width/2,self:getContentSize().height)
end

function clsFailPanel:dtor()
	
end
