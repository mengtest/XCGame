----------------
-- 征途场景
----------------

clsJourneyScene = class("clsJourneyScene", clsGameScene)

function clsJourneyScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsGameScene.ctor(self, world_id, map_id)
	
	ClsUIManager.GetInstance():ShowPanel("clsJourneyPanel")
	
	local hero = ClsRoleMgr.GetInstance():CreateHero()
	hero:EnterMap(500, 100)
	KE_Director:BindCameraOn(hero)
--	if KE_TheMap then KE_TheMap:SetTouchMoveEnabled(true) end
end

function clsJourneyScene:dtor()
	
end

function clsJourneyScene:OnDestroy()
	ClsUIManager.GetInstance():DestroyWindow("clsJourneyPanel")
	clsGameScene.OnDestroy(self)
end

