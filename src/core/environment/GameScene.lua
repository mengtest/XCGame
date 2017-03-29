-----------------
-- 场景
-----------------
clsGameScene = class("clsGameScene", clsScene)

function clsGameScene:ctor(world_id, map_id, bLockCamera)
	clsScene.ctor(self)
	self.iWorldId = world_id		--场景ID
	self.iMapId = map_id			--地图ID
	
	keyboard:InitKeboardEvent(self)
	
	self.mMapRoot = cc.Node:create()
	KE_SetParent(self.mMapRoot, self)
	
	self.mUIRoot = cc.Node:create()
	KE_SetParent(self.mUIRoot, self, 99)
	
	KE_Director:GetUIMgr():InitUILayer(self.mUIRoot)
	
	self:SetMapId(map_id, bLockCamera)
	if self._mMap then 
		self._mMap:SetCameraPos(0,0) 
	end
end

function clsGameScene:dtor()
	self:OnDestroy()
	KE_RemoveFromParent(self)
end

function clsGameScene:OnDestroy()
	KE_Director:GetUIMgr():DestoryUILayer()
	self:_UnloadMap()
end


function clsGameScene:GetWorldID() 
	return self.iWorldId 
end

function clsGameScene:GetMapID() 
	return self.iMapId 
end

function clsGameScene:SetMapId(iMapId, bLockCamera)
	self.iMapId = iMapId
	if self._mMap and self._mMap:GetUid()==iMapId then return end
	self:_LoadMap(bLockCamera)
end

function clsGameScene:_UnloadMap()
	if self._mMap then
		KE_SafeDelete(self._mMap)
		self._mMap = nil
	end
end

function clsGameScene:_LoadMap(bLockCamera)
	self:_UnloadMap()
	if self.iMapId then  
		self._mMap = clsMap.new(self.mMapRoot, self.iMapId, bLockCamera)
	end
end

function clsGameScene:OnLoadingOver()
	
end
