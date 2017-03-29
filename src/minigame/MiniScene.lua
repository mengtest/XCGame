----------------
-- 小游戏场景
----------------
clsMiniScene = class("clsMiniScene", clsGameScene)

function clsMiniScene:ctor()
	clsGameScene.ctor(self)
	self.mNibblesView = ui.clsNibblesView.new(self)
	
end

function clsMiniScene:dtor()
	
end

function clsMiniScene:OnDestroy()
	KE_SafeDelete(self.mNibblesView)
	self.mNibblesView = nil
	clsGameScene.OnDestroy(self)
end

REG_SCENE_CFG("mini_scene", { clsname = clsMiniScene })
