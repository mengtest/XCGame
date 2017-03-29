----------------------
-- 法术体基类
----------------------
module("missile",package.seeall)

clsMissile = class("clsMissile", clsGameObject, clsPhysBody)

function clsMissile:ctor(Uid, iOwnerID)
	clsGameObject.ctor(self)
	clsPhysBody.ctor(self)
	assert(Uid, "Uid should not be nil")
	assert(iOwnerID, "iOwnerID should not be nil")
	
	AddMemoryMonitor(self)
	
	self.Uid = Uid
	self.iOwnerID = iOwnerID
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	local GrpId = theOwner and theOwner:GetMyPhysGroupID()
	if GrpId then
		self:AddToPhysWorld(GrpId)
	end
	
	self:_UnloadBody()
end

function clsMissile:dtor()
	self:DestroyAllTimer()
	self:RemoveFromPhysWorld()
	self:_UnloadBody()
	
	if self._fOnFlyOver then
		self._fOnFlyOver(self.Uid)
	end
end

function clsMissile:_LoadBody()
	self:_UnloadBody()
	
	local obj = utils.CreateObject(self.tMagicInfo.sResType, self.tMagicInfo.sResPath, nil, 1, function()
		ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end)
	assert(obj, "加载失败: "..self.tMagicInfo.sResPath)
	self._mBody = obj
	KE_SetParent(obj, self)
end

function clsMissile:_UnloadBody()
	if self._mBody then
		KE_SafeDelete(self._mBody)
		self._mBody = nil
	end
end

function clsMissile:OnCreate(magicInfo)
	self.tMagicInfo = magicInfo
	
	self:_LoadBody()
	
	if magicInfo.tKeyEvents then
		for i, EvtInfo in ipairs(magicInfo.tKeyEvents) do
			self:CreateTimerDelay(i, EvtInfo.iFrame, function()
				self:SetDamageInfo(EvtInfo.args.tDamageInfo)
			end)
		end
	end
end

function clsMissile:GetMagicInfo() return self.tMagicInfo end
function clsMissile:GetUid() return self.Uid end
function clsMissile:GetOwnerID() return self.iOwnerID end
function clsMissile:GetOwner() return self.iOwnerID and ClsRoleMgr.GetInstance():GetRole(self.iOwnerID) or nil end

-- 飞出
function clsMissile:BeginFly(funcOnFlyOver)
	assert(false, "override me")
end

function clsMissile:StopFly()

end

---------------------------------------------

function clsMissile:SetDirection(iDir)
	if not iDir then return end
	self._iCurDir = iDir
end


---------------------------------------------

-- 碰撞
--@override
function clsMissile:OnCollision(body)

end

-- 受击
--@override
function clsMissile:OnHit(Attacker, DamageInfo)
	
end

-- 攻击
--@override
function clsMissile:OnAttack(Victim, DamageInfo)
	assert(DamageInfo==self:GetDamageInfo())
	
	if DamageInfo.iIsSingleAtk == 1 then
		self:SetDamageInfo(false)
	else
		DamageInfo.tResults = DamageInfo.tResults or {}
		DamageInfo.tResults[Victim] = true
	end
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	if theOwner then theOwner:IncDribble() end
	
	--------------------
	
	local AfterCollid = self.tMagicInfo.AfterCollid
	if AfterCollid == 0 or not AfterCollid then
		return
	end
	if AfterCollid == 1 then
		--爆炸
		self:RemoveFromPhysWorld()
		ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	elseif AfterCollid == 2 then
		--停止运动
		self:StopFly()
	elseif AfterCollid == 3 then
		--粘附到碰撞对象
		self:StopFly()
		local TargetId = Victim:GetUid()
		if not self:HasTimer("tm_adhere") then
			self:CreateTimerLoop("tm_adhere",1,function()
				local target = ClsRoleMgr.GetInstance():GetRole(TargetId)
				if not target then return true end
				
				local xTarget, yTarget = target:getPosition()
				local x, y = self:getPosition()
				self:setPosition((x+xTarget)/2, (y+yTarget)/2)
			end)
		end
	end
end
