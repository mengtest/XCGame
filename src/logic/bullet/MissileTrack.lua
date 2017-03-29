---------------
-- 追踪
---------------
module("missile",package.seeall)

local clsMissileTrack = class("clsMissileTrack", clsMissile)

function clsMissileTrack:ctor(id, iOwnerID)
	clsMissile.ctor(self, id, iOwnerID)
end

function clsMissileTrack:dtor()
	
end

-- 飞出
function clsMissileTrack:BeginFly(funcOnFlyOver)
	self._fOnFlyOver = funcOnFlyOver
	local MagicInfo = self:GetMagicInfo()
	local tTrackCfg = MagicInfo and MagicInfo.tTrackCfg
	assert(tTrackCfg.iMoveSpeed>0)
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	if not theOwner then 
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	if not utils.AddObj2Map(self) then
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	
	local xFrom, yFrom = theOwner:getPosition()
	local hFrom = theOwner:GetPositionH()
	
	self:setPosition(xFrom, yFrom+hFrom)
	self:SetDirection(theOwner:GetDirection())
	self:SetCurMoveSpeed(tTrackCfg.iMoveSpeed)
	
	self:CreateTimerLoop("tm_track", 1, function()
		local moveVector
		local FlySpeed = self:GetCurMoveSpeed()	--飞行速度
		local xFrom, yFrom = self:getPosition()
		local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
		local trackTarget = theOwner and theOwner:GetFightTarget()
		
		if trackTarget then
			local fromPt = {x=xFrom,y=yFrom}
			local targetPt = cc.p(theOwner:GetFightTarget():getPosition())
			moveVector = cc.pSub(targetPt,fromPt)
			self:SetDirection(math.Vector2Radian(moveVector.x, moveVector.y))
		elseif self:GetDirection() then
			local vX,vY = math.Radian2Vector(self:GetDirection())
			moveVector = cc.p(vX,vY)
		end
		
		if moveVector then
			moveVector = cc.pMul(cc.pNormalize(moveVector), FlySpeed)
			self:SetDirection(math.Vector2Radian(moveVector.x, moveVector.y))
			self:setPosition(xFrom+moveVector.x, yFrom+moveVector.y)
		end
	end)
end

function clsMissileTrack:StopFly()
	self:DestroyTimer("tm_track")
end

return clsMissileTrack
