----------------
-- 战斗场景
----------------

clsFightScene = class("clsFightScene", clsGameScene)

function clsFightScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsGameScene.ctor(self, world_id, map_id)
	ClsUIManager.GetInstance():ShowPanel("clsFightPanel")
end

function clsFightScene:dtor()
	
end

function clsFightScene:OnDestroy()
	ClsUIManager.GetInstance():DestroyWindow("clsFightPanel")
	clsGameScene.OnDestroy(self)
end

