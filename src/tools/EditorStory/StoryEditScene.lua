----------------
-- 剧情编辑场景
----------------
module("editorstory", package.seeall)

clsStoryEditScene = class("clsStoryEditScene", clsGameScene)

function clsStoryEditScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsGameScene.ctor(self, world_id, map_id)
	
	self.mStoryEditPanel = clsStoryEditPanel.new(KE_Director:GetLayerMgr():GetLayer(const.LAYER_PANEL))
	
--	local hero = ClsRoleMgr.GetInstance():CreateHero()
--	hero:EnterMap(500, 100)
--	KE_Director:BindCameraOn(hero)
end

function clsStoryEditScene:dtor()
	
end

function clsStoryEditScene:OnDestroy()
	if self.mStoryEditPanel then
		KE_SafeDelete(self.mStoryEditPanel)
		self.mStoryEditPanel = nil 
	end
	clsGameScene.OnDestroy(self)
end

REG_SCENE_CFG("story_edit_scene", { clsname = clsStoryEditScene, scene_id = 3001, map_id = 3001, })
