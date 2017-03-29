---------------
-- 抛物线
---------------
module("missile",package.seeall)

local clsMissileParabola = class("clsMissileParabola", clsMissile)

function clsMissileParabola:ctor(id, iOwnerID)
	clsMissile.ctor(self, id, iOwnerID)
end

function clsMissileParabola:dtor()
	
end

-- 飞出
function clsMissileParabola:BeginFly(funcOnFlyOver)
	self._fOnFlyOver = funcOnFlyOver
	local MagicInfo = self:GetMagicInfo()
	local tTrackCfg = MagicInfo and MagicInfo.tTrackCfg
	assert(tTrackCfg.iMoveSpeed>0)
	assert(tTrackCfg.iMaxHeight>0)
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	if not theOwner then 
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	if not utils.AddObj2Map(self) then
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	
	local xFrom, yFrom = theOwner:getPosition()
	local hFrom = theOwner:GetPositionH()
	local flyDis = tTrackCfg.iMoveDis
	local Angle = theOwner:GetDirection()+math.rad(tTrackCfg.iMoveDir)
	local total_frame = tTrackCfg.iMoveDis/tTrackCfg.iMoveSpeed
	local seconds = total_frame * GAME_CONFIG.SPF
	local moveVector = cc.pMul(cc.p(math.cos(Angle), math.sin(Angle)), flyDis)
	
	self:SetCurMoveSpeed(tTrackCfg.iMoveSpeed)
	self:SetDirection(Angle)
	self:setPosition(xFrom, yFrom+hFrom)
	
	self:runAction(cc.Sequence:create(
		cc.JumpBy:create(seconds, moveVector, tTrackCfg.iMaxHeight, 1), 
		cc.CallFunc:create(function()
		--	ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
		end)
	))
end

function clsMissileParabola:StopFly()
	self:stopAllActions()
end

return clsMissileParabola
