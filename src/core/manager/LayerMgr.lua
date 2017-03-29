ClsLayerMgr = class("ClsLayerMgr")
ClsLayerMgr.__is_singleton = true

function ClsLayerMgr:ctor()
	self.tAllLayers = new_weak_table("v")
end

function ClsLayerMgr:dtor()
	
end

function ClsLayerMgr:OnLayerNew(iLayerId, LayerObj)
	assert(utils.IsValidGameLayerId(iLayerId), "未定义层："..iLayerId)
	assert(LayerObj, "无效的对象")
	for id, obj in pairs(self.tAllLayers) do
		if obj == LayerObj then
			assert(false, string.format("重复添加层: %d %d", id, iLayerId))
		end
	end
	
	self.tAllLayers[iLayerId] = LayerObj
end

function ClsLayerMgr:OnLayerDel(iLayerId)
	assert(utils.IsValidGameLayerId(iLayerId), "未定义层："..iLayerId)
	self.tAllLayers[iLayerId] = nil
end


function ClsLayerMgr:GetLayer(iLayerId)
	assert(utils.IsValidGameLayerId(iLayerId), "未定义层："..iLayerId)
	return self.tAllLayers[iLayerId]
end

function ClsLayerMgr:ShowLayer(iLayerId, bShow)
	assert(utils.IsValidGameLayerId(iLayerId), "未定义层："..iLayerId)
	if bShow == nil then bShow = true end
	if self.tAllLayers[iLayerId] then
		self.tAllLayers[iLayerId]:setVisible(bShow)
	end
end

function ClsLayerMgr:ShowAllLayer(bShow)
	if bShow == nil then bShow = true end
	if self.tAllLayers[const.ORDER_MAP_LAYER] then
		self.tAllLayers[const.ORDER_MAP_LAYER]:setVisible(bShow)
	end
	if self.tAllLayers[const.ORDER_UI_LAYER] then
		self.tAllLayers[const.ORDER_UI_LAYER]:setVisible(bShow)
	end
end
