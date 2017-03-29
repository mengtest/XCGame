-------------------
-- tShapeInfo：形状信息
-- tDamageInfo：伤害信息
-------------------
clsPhysBody = class("clsPhysBody")

function clsPhysBody:ctor()
	self._iPhysGroupID = nil
	
	self.tShapeInfo = {
		["sShapeType"] = "Rect",
		["tShapeDesc"] = {x=0, y=0, width=100, height=40},
		["iBodyHeight"] = 100,
	}
	self.tDamageInfo = nil
end

function clsPhysBody:dtor()
	self:RemoveFromPhysWorld()
	self._iPhysGroupID = nil
	self.tDamageInfo = nil
end

-- 身高
function clsPhysBody:GetBodyHeight()
	return self.tShapeInfo.iBodyHeight or 100
end

-- 设置形状
function clsPhysBody:SetShapeInfo(tShapeInfo)
--	self.tShapeInfo = table.clone(tShapeInfo)
	self.tShapeInfo.sShapeType = tShapeInfo.sShapeType
	self.tShapeInfo.tShapeDesc = table.clone(tShapeInfo.tShapeDesc)
	self.tShapeInfo.iBodyHeight = tShapeInfo.iBodyHeight
end

-- 获取形状
function clsPhysBody:GetShapeInfo()
	self.tShapeInfo.tShapeDesc.x = self:getPositionX()
	self.tShapeInfo.tShapeDesc.y = self:getPositionY()
	return self.tShapeInfo
end

-- 设置伤害信息
function clsPhysBody:SetDamageInfo(tDamageInfo)
	self.tDamageInfo = table.clone(tDamageInfo)
end

-- 获取伤害信息
function clsPhysBody:GetDamageInfo()
	return self.tDamageInfo
end

-- 碰撞回调
function clsPhysBody:OnCollision(body)
	assert(false, "Override Me")
end

-- 攻击
function clsPhysBody:OnAttack(Victim, DamageInfo)
	assert(false, "Override Me")
end

-- 受击
function clsPhysBody:OnHit(Attacker, DamageInfo)
	assert(false, "Override Me")
end


-- 所在碰撞群组ID
function clsPhysBody:GetMyPhysGroupID()
	return self._iPhysGroupID
end

-- 投放到检测空间
function clsPhysBody:AddToPhysWorld(grp_id)
	assert(not self._iPhysGroupID, "已经在物理空间中")
	ClsPhysicsWorld.GetInstance():AddBody(self, grp_id)
end

-- 撤出检测空间
function clsPhysBody:RemoveFromPhysWorld()
	ClsPhysicsWorld.GetInstance():RemoveBody(self)
end

-- 投放到检测空间成功时回调
function clsPhysBody:OnAddtoPhysGroup(oPhysGrp)
	self._iPhysGroupID = oPhysGrp:GetUid()
end

-- 撤出检测空间时回调
function clsPhysBody:OnRemoveFromPhysGroup(oPhysGrp)
	self._iPhysGroupID = nil
end
