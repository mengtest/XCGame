-------------
--特效管理器
-------------
ClsEffectMgr = class("ClsEffectMgr")
ClsEffectMgr.__is_singleton = true

function ClsEffectMgr:ctor()
	self.tAllEffects = {}
end

function ClsEffectMgr:dtor()
	for effID, Eff in pairs(self.tAllEffects) do
		KE_SafeDelete(Eff)
	end
	self.tAllEffects = nil
end

---------------------
-- 由外部自己去管理
---------------------
function ClsEffectMgr:NewEffectSeq(res_path, parent, iLoopTimes, callback)
	return clsEffectSeq.new(nil, res_path, parent, iLoopTimes, callback)
end

function ClsEffectMgr:NewEffectQuad(res_path, parent, iLoopTimes, callback)
	return clsEffectQuad.new(nil, res_path, parent, iLoopTimes, callback)
end


---------------------
-- 通过ID管理
---------------------
-- 创建序列帧特效
function ClsEffectMgr:CreateEffectSeq(effectID, res_path, parent, iLoopTimes)
	if self.tAllEffects[effectID] then
		print("effect is already exist", effectID)
		return self.tAllEffects[effectID]
	end
	
	self.tAllEffects[effectID] = clsEffectSeq.new(effectID, res_path, parent, iLoopTimes)
	self.tAllEffects[effectID]:retain()
	return self.tAllEffects[effectID]
end

-- 创建粒子特效
function ClsEffectMgr:CreateEffectQuad(effectID, res_path, parent, iLoopTimes)
	if self.tAllEffects[effectID] then
		print("effect is already exist", effectID)
		return self.tAllEffects[effectID]
	end
	
	self.tAllEffects[effectID] = clsEffectQuad.new(effectID, res_path, parent, iLoopTimes)
	self.tAllEffects[effectID]:retain()
	return self.tAllEffects[effectID]
end

-- 销毁
function ClsEffectMgr:DestroyEffect(effectID)
	if self.tAllEffects[effectID] then
		KE_SafeDelete(self.tAllEffects[effectID])
		self.tAllEffects[effectID]:release()
		self.tAllEffects[effectID] = nil
	end
end

-- 获取
function ClsEffectMgr:GetEffect(effectID)
	return self.tAllEffects[effectID]
end
