-------------------
-- 角色行动力
-------------------

--站立
function clsRole:CallRest()
	if not self:ProcCan2Rest() then return false end
	local state_mgr = self.mStateMgr
	state_mgr:_SetActState(self, ROLE_STATE.ST_IDLE)
	state_mgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
	return true
end

--冲刺
function clsRole:CallRush(dx, dy, distance, on_reached, on_breaked)
	if not self:ProcCan2Rush() then return false end
	
	local sx, sy = self:getPosition()
	local roadpath = ClsPathFinder.GetInstance():FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	local state_mgr = self.mStateMgr
	self:SetCurMoveSpeed(self.mRoleData:GetiRushSpeed())
	state_mgr:_SetActState(self, ROLE_STATE.ST_RUSH)
	state_mgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, on_reached = on_reached, on_breaked = on_breaked
	})
	return true
end

--奔跑
function clsRole:CallRun(dx, dy, distance, on_reached, on_breaked)
	if not self:ProcCan2Run() then return false end
	
	local sx, sy = self:getPosition()
	local roadpath = ClsPathFinder.GetInstance():FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	local state_mgr = self.mStateMgr
	self:SetCurMoveSpeed(self.mRoleData:GetiRunSpeed())
	state_mgr:_SetActState(self, ROLE_STATE.ST_RUN)
	state_mgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, on_reached = on_reached, on_breaked = on_breaked
	})
	return true
end

--行走
function clsRole:CallWalk(dx, dy, distance, on_reached, on_breaked)
	if not self:ProcCan2Walk() then return false end
	
	local sx, sy = self:getPosition()
	local roadpath = ClsPathFinder.GetInstance():FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	local state_mgr = self.mStateMgr
	self:SetCurMoveSpeed(self.mRoleData:GetiWalkSpeed())
	state_mgr:_SetActState(self, ROLE_STATE.ST_WALK)
	state_mgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, on_reached = on_reached, on_breaked = on_breaked
	})
	return true
end

--跳跃
function clsRole:CallJump(dx, dy, distance, callback)
	if not self:ProcCan2Jump() then return false end
	
	local state_mgr = self.mStateMgr
	self:FaceTo(dx,dy)
	state_mgr:_SetActState(self, ROLE_STATE.ST_JUMP)
	state_mgr:_SetSkyMovState(self, ROLE_STATE.ST_SKYMOVLINE, {jmpSpeed = const.JMP_SPEED, callback = callback,})
	return true
end

--攻击
function clsRole:CallSkill(iSkillIndex, finishCallback, breakCallback)
	if not self:ProcCan2Skill(iSkillIndex) then return false end
	
	local state_mgr = self.mStateMgr
	local args = {iSkillIndex=iSkillIndex, finishCallback=finishCallback, breakCallback=breakCallback}
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	return self:Turn2ActState(ROLE_STATE.ST_SKILL, args)
end

--防御
function clsRole:CallDefend()
	if not self:ProcCan2Defend() then return false end
	local state_mgr = self.mStateMgr
	state_mgr:_SetActState(self, ROLE_STATE.ST_DEFEND)
	state_mgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
	return true
end

--收技
function clsRole:CallStopSkill()
	if not self:ProcCan2StopSkill() then return false end
	self:break_skill()
	return true
end

--采集
function clsRole:CallGather()

end

--打坐
function clsRole:CallZazen()

end

--打断技能
function clsRole:break_skill()
	if self.mSkillMgr then
		self.mSkillMgr:BreakSkill()
	end
end

