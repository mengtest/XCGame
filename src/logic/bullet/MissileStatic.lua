---------------
-- 静止
---------------
module("missile",package.seeall)

local clsMissileStatic = class("clsMissileStatic", clsMissile)

function clsMissileStatic:ctor(id, iOwnerID)
	clsMissile.ctor(self, id, iOwnerID)
end

function clsMissileStatic:dtor()
	
end

-- 飞出
function clsMissileStatic:BeginFly(funcOnFlyOver)
	self._fOnFlyOver = funcOnFlyOver
	local MagicInfo = self:GetMagicInfo()
	local tTrackCfg = MagicInfo and MagicInfo.tTrackCfg
	
	local theOwner = ClsRoleMgr.GetInstance():GetRole(self.iOwnerID)
	if not theOwner then 
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	if not utils.AddObj2Map(self) then
		return ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
	end
	
	local xFrom, yFrom = theOwner:getPosition()
	local hFrom = theOwner:GetPositionH()
	local Dis = tTrackCfg.iDis or 0
	local Angle = theOwner:GetDirection()+math.rad(tTrackCfg.iAngle or 0)
	local Hei = tTrackCfg.iHei or 0
	
	self:SetPosition3D(xFrom+Dis*math.cos(Angle), yFrom+Dis*math.sin(Angle), Hei)
	self:SetDirection(Angle)
	self:SetCurMoveSpeed(0)
end

return clsMissileStatic
