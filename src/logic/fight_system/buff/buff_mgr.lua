-------------------
-- Buff管理
-------------------
module("fight", package.seeall)

clsBuffMgr = class("clsBuffMgr", clsCoreObject)

function clsBuffMgr:ctor(Owner)
	assert(Owner, "未设置Buff所属角色")
	clsCoreObject.ctor(self)
	self.mOwner = Owner
	self.tAllBuffs = {}
	self.tTimeBuffs = new_weak_table("kv")
end

function clsBuffMgr:dtor()
	self:DelAllBuff()
end

function clsBuffMgr:FrameUpdate(deltaTime)
	for _, BuffData in pairs(self.tTimeBuffs) do
		if BuffData:IsOver() then
			self:DelBuffById( BuffData:GetBuffId() )
		end
	end
end

function clsBuffMgr:GetOwner()
	return self.mOwner
end

function clsBuffMgr:AddBuff(BuffName)
	local BuffId = setting.GetBuffIdByName(BuffName)
	local BuffInfo = setting.T_buff.BuffInfoTbl[BuffId]
	
	--
	local RejectBuffs = setting.T_buff.MutexBuffs[BuffName]
	if RejectBuffs then
		for OtherBuffName,_ in pairs(RejectBuffs) do
			local OtherBuff = self:GetBuffData(OtherBuffName)
			if OtherBuff then
				local OtherBuffCfg = OtherBuff:GetBuffCfg()
				if OtherBuffCfg.MutexDoTips then
					self.mOwner:PopSay(string.format("免疫%s",BuffName))
				end
				return 
			end
		end
	end
	
	--
	if not BuffInfo.MaxOverlap or BuffInfo.MaxOverlap <= 1 then  --没填堆叠上限字段，则覆盖
		self:DelBuffById(BuffId)
	end
	
	if not self.tAllBuffs[BuffId] then
		self.tAllBuffs[BuffId] = clsBuffData.new(BuffId, 100, self.mOwner)
	elseif self.tAllBuffs[BuffId]:GetOverlap() < BuffInfo.MaxOverlap then
		self.tAllBuffs[BuffId]:SetOverlap(self.tAllBuffs[BuffId]:GetOverlap()+1)
	end
	
	self:OnAddBuff()
	
	if BuffInfo.LastTime then
		self.tTimeBuffs[BuffId] = self.tAllBuffs[BuffId]
		self.tTimeBuffs[BuffId]:SetLastTime(BuffInfo.LastTime)
	end
	
	return self.tAllBuffs[BuffId]
end

function clsBuffMgr:DelBuff(BuffName)
	local BuffId = setting.GetBuffIdByName(BuffName)
	self:DelBuffById(BuffId)
end

function clsBuffMgr:DelBuffById(BuffId)
	if self.tAllBuffs[BuffId] then
		self:OnDelBuff()
		KE_SafeDelete(self.tAllBuffs[BuffId])
		self.tAllBuffs[BuffId] = nil
		self.tTimeBuffs[BuffId] = nil
	end
end

function clsBuffMgr:DelAllBuff()
	for _, BuffData in pairs(self.tAllBuffs) do
		KE_SafeDelete(BuffData)
	end
	self.tAllBuffs = {}
	self.tTimeBuffs = new_weak_table("kv")
end

function clsBuffMgr:GetBuffData(BuffName)
	local BuffId = setting.GetBuffIdByName(BuffName)
	return self.tAllBuffs[BuffId]
end

function clsBuffMgr:GetAllBuffs()
	return self.tAllBuffs
end

-----------------
--
-----------------

function clsBuffMgr:OnAddBuff()

end

function clsBuffMgr:OnHit()

end

function clsBuffMgr:OnAttack()

end

function clsBuffMgr:OnDead()

end

function clsBuffMgr:OnAddHp()

end

function clsBuffMgr:OnAddMp()

end

function clsBuffMgr:OnDelBuff()

end
