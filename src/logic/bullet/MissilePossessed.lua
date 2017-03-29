---------------
-- 附体
---------------
module("missile",package.seeall)

local clsMissilePossessed = class("clsMissilePossessed", clsMissile)

function clsMissilePossessed:ctor(id, iOwnerID)
	clsMissile.ctor(self, id, iOwnerID)
end

function clsMissilePossessed:dtor()
	
end

-- 飞出
function clsMissilePossessed:BeginFly(funcOnFlyOver)
	self._fOnFlyOver = funcOnFlyOver
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	if not theOwner then 
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	self.mOwner = theOwner
	KE_SetParent(self, theOwner)
end

function clsMissilePossessed:getPosition()
	return self.mOwner:getPosition()
end

function clsMissilePossessed:getPositionX()
	return self.mOwner:getPositionX()
end

function clsMissilePossessed:getPositionY()
	return self.mOwner:getPositionY()
end

function clsMissilePossessed:GetPositionH()
	return self.mOwner:GetPositionH()
end

function clsMissilePossessed:GetPosition3D()
	return self.mOwner:getPositionX(), self.mOwner:getPositionY(), self:GetPositionH()
end

function clsMissilePossessed:GetCurMoveSpeed()
	return self.mOwner:GetCurMoveSpeed()
end

function clsMissilePossessed:GetCurSkySpeed()
	return self.mOwner:GetCurSkySpeed()
end

function clsMissilePossessed:GetDirection()
	return self.mOwner:GetDirection()
end

function clsMissilePossessed:IsInSky() 
	return self.mOwner:IsInSky()
end

return clsMissilePossessed
