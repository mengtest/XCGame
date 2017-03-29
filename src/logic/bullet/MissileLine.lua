---------------
-- 直线
---------------
module("missile",package.seeall)

local clsMissileLine = class("clsMissileLine", clsMissile)

function clsMissileLine:ctor(id, iOwnerID)
	clsMissile.ctor(self, id, iOwnerID)
end

function clsMissileLine:dtor()
	
end

-- 飞出
function clsMissileLine:BeginFly(funcOnFlyOver)
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
	local flyDis = tTrackCfg.iMoveDis
	local Angle = theOwner:GetDirection()+math.rad(tTrackCfg.iMoveDir)
	local total_frame = tTrackCfg.iMoveDis/tTrackCfg.iMoveSpeed
	
	self:SetCurMoveSpeed(tTrackCfg.iMoveSpeed)
	self:SetDirection(Angle)
	self:SetPosition3D(xFrom, yFrom, hFrom)
	
	local deltaX = flyDis*math.cos(Angle)/total_frame
	local deltaY = flyDis*math.sin(Angle)/total_frame
	self.iMoveFrame = total_frame
	self:CreateTimerLoop("tmr_line", 1, function()
		self.iMoveFrame = self.iMoveFrame - 1
		self:setPosition(self:getPositionX()+deltaX, self:getPositionY()+deltaY)
		
		if self.iMoveFrame <= 0 then
			return true
		end
	end)
end

function clsMissileLine:StopFly()
	self:DestroyTimer("tmr_line")
end

return clsMissileLine
