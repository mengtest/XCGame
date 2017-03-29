----------------
-- 登录场景
----------------

clsRestScene = class("clsRestScene", clsGameScene)

function clsRestScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsGameScene.ctor(self, world_id, map_id)
	
	ClsUIManager.GetInstance():ShowPanel("clsMainPanel")
	
	local hero = ClsRoleMgr.GetInstance():CreateHero()
	hero:EnterMap(500, 100)
	KE_Director:BindCameraOn(hero)
	
	ClsAdvertiseManager.GetInstance():CheckSpecAdver()
end

function clsRestScene:dtor()
	
end

function clsRestScene:OnDestroy()
	ClsUIManager.GetInstance():DestroyWindow("clsMainPanel")
	clsGameScene.OnDestroy(self)
end

