----------------
-- 阵型管理器
----------------
clsFormation = class("clsFormation")

function clsFormation:ctor(sType)
	assert(utils.IsValidCombatType(sType), "阵型类型无效")
	self._FormationType = sType
	self.tFighterUidList = {}
end

function clsFormation:dtor()
	
end

function clsFormation:CanAddFighter(FighterUid)
	if FighterUid == nil then 
		log_normal("不可上阵： FighterUid为空")
		return false 
	end
	if self:IsFull() then 
		log_normal("不可上阵： 队伍已满")
		return false 
	end
	if self:GetFighterPos(FighterUid) then
		log_normal("不可上阵： 已经在队伍中")
		return false
	end
	return true
end

function clsFormation:CanRemoveFighter(FighterUid)
	if FighterUid == nil then 
		log_normal("不可下阵： FighterUid为空")
		return false 
	end
	return true
end

function clsFormation:AddFighter(FighterUid)
	if not self:CanAddFighter(FighterUid) then return false end
	table.insert(self.tFighterUidList, FighterUid)
	self:Sort()
	return true
end

function clsFormation:RemoveFighter(FighterUid)
	if not self:CanRemoveFighter(FighterUid) then return false end
	local pos = self:GetFighterPos(FighterUid)
	if pos then
		table.remove(self.tFighterUidList, pos)
	end
	return true
end

function clsFormation:Sort()
	local InstRoleDataMgr = KE_Director:GetRoleDataMgr()
	table.sort(self.tFighterUidList, function(a,b)
		local obj1 = InstRoleDataMgr:GetRoleData(a)
		local obj2 = InstRoleDataMgr:GetRoleData(b)
		if obj1 and obj2 then
			if obj1:GetiCurHP() ~= obj2:GetiCurHP() then
				return obj1:GetiCurHP() > obj2:GetiCurHP()
			end
		end
		return a > b
	end)
end

function clsFormation:GetType() 
	return self._FormationType
end

function clsFormation:GetFighterUidList()
	return self.tFighterUidList
end

function clsFormation:GetFighterPos(FighterUid)
	if FighterUid == nil then return nil end
	for i, Uid in ipairs(self.tFighterUidList) do
		if Uid == FighterUid then
			return i
		end
	end
	return nil
end

function clsFormation:HasFighter(FighterUid)
	return self:GetFighterPos() ~= nil
end

function clsFormation:IsFull()
	return #self.tFighterUidList >= const.COMBAT_CFG[self._FormationType].MAX_GENERAL 
end

function clsFormation:GetFighterCnt()
	return #self.tFighterUidList
end

function clsFormation:GetMaxFighterCnt()
	return const.COMBAT_CFG[self._FormationType].MAX_GENERAL 
end

------------------------------------------------------------

ClsEmbattleManager = class("ClsEmbattleManager")
ClsEmbattleManager.__is_singleton = true

function ClsEmbattleManager:ctor()
	self.tAllFormation = {}    --阵型数据
end

function ClsEmbattleManager:dtor()
	for _, objFormation in pairs(self.tAllFormation) do
		KE_SafeDelete(objFormation)
	end
	self.tAllFormation = nil 
end

function ClsEmbattleManager:AddFormation(sCombatType, FighterUidList)
	assert(utils.IsValidCombatType(sCombatType))
	assert(FighterUidList==nil or table.is_array(FighterUidList), "参数错误")
	self.tAllFormation[sCombatType] = self.tAllFormation[sCombatType] or clsFormation.new(sCombatType)
	if FighterUidList then
		for _, FighterUid in ipairs(FighterUidList) do
			self.tAllFormation[sCombatType]:AddFighter(FighterUid)
		end
	end
	return self.tAllFormation[sCombatType]
end

function ClsEmbattleManager:GetFormation(sCombatType)
	assert(utils.IsValidCombatType(sCombatType))
	return self.tAllFormation[sCombatType]
end

function ClsEmbattleManager:CloneFormation(sCombatType, srcFormation)
	local dstFormation = self:AddFormation(sCombatType)
	local FighterUidList = srcFormation:GetFighterUidList()
	dstFormation.tFighterUidList = table.clone(FighterUidList) or {}
	dstFormation:Sort()
	return dstFormation
end
