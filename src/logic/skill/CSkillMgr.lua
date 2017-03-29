-------------------
-- 技能管理器
-------------------
clsSkillMgr = class("clsSkillMgr")

function clsSkillMgr:ctor(theOwner)
	assert(theOwner)
	self.mOwner = theOwner	--所属角色
	self.tCDList = {}		--技能CD信息
	self.tSkillPak = nil	--技能数据包
	self.mCurSkill = nil	--当前释放中的技能
	self.mSkillObjList = {}
end

function clsSkillMgr:dtor()
	for _, SkillObj in pairs(self.mSkillObjList) do
		KE_SafeDelete(SkillObj)
	end
	self.mSkillObjList = {}
	self.mCurSkill = nil 
end

--@每帧更新
function clsSkillMgr:FrameUpdate(deltaTime)
	local tCDList = self.tCDList
	for iSkillIndex, curCD in pairs(tCDList) do
		tCDList[iSkillIndex] = curCD - deltaTime
		if tCDList[iSkillIndex] < 0 then tCDList[iSkillIndex] = nil end
	end
end

-- 设置技能数据包
function clsSkillMgr:SetSkillPak(SkillPak)
	self.tSkillPak = SkillPak
end

-- 获取技能数据包
function clsSkillMgr:GetSkillPak()
	return self.tSkillPak
end

-- 是否拥有某技能
function clsSkillMgr:HasSkill(iSkillId)
	return self:GetSkillIndex(iSkillId) ~= nil
end

-- 根据技能索引获取技能ID
function clsSkillMgr:GetSkillId(iSkillIndex)
	return self.tSkillPak[iSkillIndex] and self.tSkillPak[iSkillIndex]:GetiSkillId()
end

-- 根据技能ID获取技能索引
function clsSkillMgr:GetSkillIndex(iSkillId)
	for iSkillIndex, SkillData in pairs(self.tSkillPak) do
		if SkillData:GetiSkillId() == iSkillId then
			return iSkillIndex
		end
	end
	return nil
end

-- 是否正在释放技能
function clsSkillMgr:IsCastingSkill()
	return self.mCurSkill~=nil and self.mCurSkill:IsPlaying() 
end

-- 判断某技能是否处于CD中
function clsSkillMgr:IsSkillInCD(iSkillIndex)
	return self.tCDList[iSkillIndex] ~= nil and self.tCDList[iSkillIndex]>0 
end

----------------我是一条分割线---------------------------

-- 检测是否可以释放某技能
function clsSkillMgr:IsSkillEnable(iSkillIndex)
	assert(iSkillIndex)
	if self:IsCastingSkill() then 
		--log_warn("上一技能尚未释放完毕")
		return false
	end
	if not self.tSkillPak[iSkillIndex] then
		--log_warn("尚未学习该技能")
		return false
	end
	if self.tCDList[iSkillIndex] and self.tCDList[iSkillIndex] > 0 then
		--log_warn("技能CD中", self.tCDList[iSkillIndex])
		return false
	end
	if not self.mOwner then
		--log_warn("并没有施法者")
		return false 
	end
	
	return true
end

-- 释放技能
function clsSkillMgr:CastSkill(iSkillIndex, finishCallback, breakCallback)
	assert(self:IsSkillEnable(iSkillIndex))
	----- 能进入这里证明已经确认可以释放该技能 ------
	local theOwner = self.mOwner
	local iSkillId = self:GetSkillId(iSkillIndex)
	
	-- 开始CD
	local iCD = setting.T_skill_cfg[iSkillId].iCD
	if iCD > 0.001 then
		self.tCDList[iSkillIndex] = iCD
	end
	
	-- 面向攻击对象
	local fight_target = theOwner:GetFightTarget()
	if fight_target then
		theOwner:FaceTo(fight_target:getPosition())
	end
	
	-- 释放技能
	self.mCurSkill = self:_CreateSkillObj(iSkillId)
	self.mCurSkill:Play(finishCallback, breakCallback)
	
	return true
end

-- 技能被打断
function clsSkillMgr:BreakSkill(OnSkillBreaked)
	if self.mCurSkill then
		self.mCurSkill:BreakSkill()
		if OnSkillBreaked then
			OnSkillBreaked()
		end
	end
end

function clsSkillMgr:_CreateSkillObj(iSkillId)
	if not self.mSkillObjList[iSkillId] then 
		self.mSkillObjList[iSkillId] = clsSkill.new(iSkillId, self.mOwner)
	end
	return self.mSkillObjList[iSkillId]
end
