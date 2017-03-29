-------------------
--技能数据管理
-------------------

local clsSkillData = class("clsSkillData", clsDataFace)

clsSkillData:RegSaveVar("iSkillId", function(v) assert(setting.T_skill_cfg[v] and setting.GetSkillPlayInfo(v)) end)
clsSkillData:RegSaveVar("iSkillIndex", TYPE_CHECKER.INT)	-- 技能位
clsSkillData:RegSaveVar("iOwnerId", TYPE_CHECKER.INT)		-- 拥有者ID
clsSkillData:RegSaveVar("iLevel", TYPE_CHECKER.INT)			-- 等级

function clsSkillData:ctor(iOwnerId, iSkillIndex, iSkillId, iLevel)
	clsDataFace.ctor(self)
	self:SetiSkillId(iSkillId)
	self:SetiSkillIndex(iSkillIndex)
	self:SetiOwnerId(iOwnerId)
	self:SetiLevel(iLevel)
end

function clsSkillData:dtor()
	
end

function clsSkillData:GetSkillCfg()
	return setting.T_skill_cfg[self:GetiSkillId()]
end

function clsSkillData:GetPlayInfo()
	return setting.GetSkillPlayInfo(self:GetiSkillId())
end

--------------------------------------------------------------------

ClsSkillDataMgr = class("ClsSkillDataMgr")
ClsSkillDataMgr.__is_singleton = true

function ClsSkillDataMgr:ctor()
	self.tSkillPakList = {}
end

function ClsSkillDataMgr:dtor()
	self.tSkillPakList = {}
end

-- 技能包
function ClsSkillDataMgr:UpdateSkillPak(iOwnerId, info_list)
	self.tSkillPakList[iOwnerId] = self.tSkillPakList[iOwnerId] or {}
	
	local IndexTbl = {}
	local IdTbl = {}
	for _, skill_info in pairs(info_list) do
		assert(not IndexTbl[skill_info.iSkillIndex], "iSkillIndex重复")
		assert(not IdTbl[skill_info.iSkillId], "iSkillId重复")
		IdTbl[skill_info.iSkillId] = true
		IndexTbl[skill_info.iSkillIndex] = true
		
		self:UpdateSkillData(iOwnerId, skill_info.iSkillIndex, skill_info)
	end
	
	return self.tSkillPakList[iOwnerId]
end

function ClsSkillDataMgr:GetSkillPak(iOwnerId)
	return self.tSkillPakList[iOwnerId]
end

-- 技能数据 更新
function ClsSkillDataMgr:UpdateSkillData(iOwnerId, iSkillIndex, skill_info)
	assert(iSkillIndex>=1 and iSkillIndex<=7, "iSkillIndex范围必须为 [1,7]")
	if skill_info.iOwnerId then assert(skill_info.iOwnerId==iOwnerId, "iOwnerId不一致") end
	if skill_info.iSkillIndex then assert(skill_info.iSkillIndex==iSkillIndex, "iSkillIndex不一致") end
	
	self.tSkillPakList[iOwnerId] = self.tSkillPakList[iOwnerId] or {}
	if not self.tSkillPakList[iOwnerId][iSkillIndex] then
		self.tSkillPakList[iOwnerId][iSkillIndex] = clsSkillData.new(iOwnerId, iSkillIndex, skill_info.iSkillId, skill_info.iLevel)
	end
	self.tSkillPakList[iOwnerId][iSkillIndex]:BatchSetAttr(skill_info)
end

-- 技能数据 移除
function ClsSkillDataMgr:RemoveSkillData(iOwnerId, iSkillIndex)
	if not self.tSkillPakList[iOwnerId] then return end
	self.tSkillPakList[iOwnerId][iSkillIndex] = nil
end

function ClsSkillDataMgr:RemoveSkillDataBySkillId(iOwnerId, iSkillId)
	local SkillData = self:GetSkillDataBySkillId(iOwnerId, iSkillId)
	if SkillData then
		self:RemoveSkillData(iOwnerId, SkillData:GetiSkillIndex())
	end
end

-- 技能数据 获取
function ClsSkillDataMgr:GetSkillData(iOwnerId, iSkillIndex)
	if not self.tSkillPakList[iOwnerId] then return nil end
	return self.tSkillPakList[iOwnerId][iSkillIndex]
end

function ClsSkillDataMgr:GetSkillDataBySkillId(iOwnerId, iSkillId)
	local SkillPak = self.tSkillPakList[iOwnerId]
	if not SkillPak then return nil end
	for iSkillIndex, SkillData in pairs(SkillPak) do
		if SkillData:GetiSkillId() == iSkillId then
			return SkillData
		end
	end
	return nil
end
