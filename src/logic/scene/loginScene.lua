----------------
-- 登录场景
----------------

clsLoginScene = class("clsLoginScene", clsGameScene)

function clsLoginScene:ctor()
	clsGameScene.ctor(self)
	ClsUIManager.GetInstance():ShowPanel("clsLoginPanel")
end

function clsLoginScene:dtor()
	self:OnDestroy()
end

function clsLoginScene:OnDestroy()
	ClsUIManager.GetInstance():DestroyWindow("clsLoginPanel")
	clsGameScene.OnDestroy(self)
end

