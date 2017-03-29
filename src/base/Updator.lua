----------------------
-- 游戏逻辑更新子注册管理
----------------------
ClsUpdator = class("ClsUpdator")
ClsUpdator.__is_singleton = true

ClsUpdator.ORDER_GAME = 1
ClsUpdator.ORDER_CAMERA = 2
ClsUpdator.ORDER_PHYSICS = 3

local ValidOrders = {
	[ClsUpdator.ORDER_GAME] = true,
	[ClsUpdator.ORDER_CAMERA] = true,
	[ClsUpdator.ORDER_PHYSICS] = true,
}



function ClsUpdator:ctor()
	self._isUpdating = false
	self._tAllUpdators = {}
end

function ClsUpdator:dtor()
	self._isUpdating = true
	self._tAllUpdators = nil
end

function ClsUpdator:_IsValidOrder(order)
	return ValidOrders[order]
end

function ClsUpdator:HasUpdator(func, obj)
	local all_updators = self._tAllUpdators 
	for i, data in ipairs(all_updators) do
		if func==data[1] and obj==data[2] then
			return true
		end
	end
	return false
end

function ClsUpdator:RegisterUpdator(func, obj, order)
	assert(not self._isUpdating)
	assert(self:_IsValidOrder(order), "错误的优先级: "..order)
	
	if self:HasUpdator(func, obj) then 
		assert(false, "【错误】重复注册相同更新函数")
		return 
	end
	
	table.insert(self._tAllUpdators, {func, obj, order})
	table.sort(self._tAllUpdators, function(a, b) return a[3] < b[3] end)
end

function ClsUpdator:UnregisterUpdator(func, obj)
	local all_updators = self._tAllUpdators
	for i, data in ipairs(all_updators) do
		if func==data[1] and obj==data[2] then
			table.remove(self._tAllUpdators, i)
			return
		end
	end
end

--@每帧更新
function ClsUpdator:FrameUpdate(deltaTime)
	self._isUpdating = true
	local all_updators = self._tAllUpdators
	for _, data in ipairs(all_updators) do
		data[1](data[2], deltaTime)
	end
	self._isUpdating = false
end
