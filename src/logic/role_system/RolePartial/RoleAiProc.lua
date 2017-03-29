-------------------
-- 角色AI处理
-------------------

function clsRole:GetFightTarget()
	local FightTargetId = self:GetBlackBoard():GetFightTargetId()
	if not FightTargetId then return nil end
	local target = ClsRoleMgr.GetInstance():GetRole(FightTargetId)
	if target and not target:IsDead() then
		return target
	else
		self:GetBlackBoard():SetFightTargetId(nil)
		return nil
	end
end

----------------------------------
--- 动作处理
----------------------------------

-- 视野
function clsRole:ProcAOI(objBTNode, iRange)
	local enemy_teams = self:GetEnemyTeamList()
	if not enemy_teams then 
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BT_FAIL 
	end
	
	local GetDisSquareWithCache = math.GetDisSquareWithCache
	local iRange_X_iRange = iRange * iRange
	for _, team in pairs(enemy_teams) do
		local member_list = team:GetMemberList()
		if member_list then
			for enemy, _ in pairs(member_list) do
				if not enemy:IsDead() and GetDisSquareWithCache(self, enemy) <= iRange_X_iRange then
					self:GetBlackBoard():SetFightTargetId(enemy:GetUid())
					return ai.BT_SUCCESS
				end
			end
		end
	end
	
	self:GetBlackBoard():SetFightTargetId(nil)
	return ai.BT_FAIL
end

-- 距离最近的敌人
function clsRole:ProcFindNearestEnemy(objBTNode)
	local enemy_teams = self:GetEnemyTeamList() 
	if not enemy_teams then
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BT_FAIL
	end
	
	local target
	local GetDisSquareWithCache = math.GetDisSquareWithCache
	local minDis = 8100000000
	for _, team in pairs(enemy_teams) do
		local member_list = team:GetMemberList() or {}
		for enemy, _ in pairs(member_list) do
			if not enemy:IsDead() then
				local disSquare = GetDisSquareWithCache(self, enemy)
				if disSquare < minDis then
					minDis = disSquare
					target = enemy
				end
			end
		end
	end
	
	if target ~= nil then
		self:GetBlackBoard():SetFightTargetId(target:GetUid())
		return ai.BT_SUCCESS
	else
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BT_FAIL
	end
end

--敌人最密集的点
function clsRole:ProcFindDensestPoint(objBTNode)
	local myteam = self:GetMyTeam()
	local Pt = myteam and myteam:FindDensestPoint() or nil
	self:GetBlackBoard():SetDensestPoint(Pt)
	if Pt then 
		return ai.BT_SUCCESS
	else
		return ai.BT_FAIL
	end 
end

-- 
function clsRole:ProcChooseCastPoint()
	assert(false,"尚未实现该接口")
end

-- 选择技能
function clsRole:ProcChooseSkill(objBTNode)
	local SkillPak = self.mSkillMgr:GetSkillPak()
	if not SkillPak then return ai.BT_FAIL end
	
	for iSkillIndex = const.MAX_SKILL_INDEX, 1, -1 do
		if self:ProcCan2Skill(iSkillIndex) and self:ProcInSkillRange(iSkillIndex) then
			self:GetBlackBoard():SetSkillIndex(iSkillIndex)
			return ai.BT_SUCCESS
		end
	end
	
	self:GetBlackBoard():SetSkillIndex(nil)
	return ai.BT_FAIL 
end

--释放技能
function clsRole:ProcCastSkill(objBTNode, iSkillIndex)
	if not iSkillIndex then iSkillIndex = self:GetBlackBoard():GetSkillIndex() end
	if not iSkillIndex or not self:ProcCan2Skill(iSkillIndex) then return ai.BT_FAIL end
	
	local callback = function() 
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
	end
	local result = self:CallSkill(iSkillIndex, callback, callback)
	
	if result then
		result = ai.BT_RUNNING
	else
		result = ai.BT_FAIL
	end
	
	return result
end

-- 逃跑
function clsRole:ProcEscape(objBTNode, iDistance)
	local result = false
	local on_success = function()
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
	end
	local on_breaked = function()
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_FAIL)
	end
	iDistance = iDistance or 150
	local enemy = self:GetFightTarget()
	if enemy then
		local x0, y0 = enemy:getPosition()
		local x1, y1 = self:getPosition()
		local bestVector = cc.p(x1-x0, y1-y0)
		local bestAngle = math.Vector2Radian(bestVector.x, bestVector.y)
		local fixAngle = bestAngle + math.rad(math.random(-60,60))
		local fixVector = cc.p(math.Radian2Vector(fixAngle))
		local MoveVector = cc.pMul(cc.pNormalize(fixVector), iDistance)
		result = self:CallRun(x1+MoveVector.x, y1+MoveVector.y, nil, on_success, on_breaked)
	else 
		local area_list = {0,0,0,0}
		local x0, y0 = self:getPosition()
		local enemy_teams = self:GetEnemyTeamList() or {}
		for _, team in pairs(enemy_teams) do
			local member_list = team:GetMemberList() or {}
			for enemy, _ in pairs(member_list) do
				if not enemy:IsDead() then
					local x1, y1 = enemy:getPosition()
					local vecX, vecY = x1-x0, y1-y0
					if vecX>=0 and vecY>=0 then
						area_list[1] = area_list[1] + 1
					end
					if vecX<=0 and vecY>=0 then
						area_list[2] = area_list[2] + 1
					end
					if vecX<=0 and vecY<=0 then
						area_list[3] = area_list[3] + 1
					end
					if vecX>=0 and vecY<=0 then
						area_list[4] = area_list[4] + 1
					end
				end
			end
		end
		local minArea = 1
		local minCnt = area_list[1]
		for i=2,4 do
			if area_list[i] < minCnt then
				minCnt = area_list[i]
				minArea = i
			end
		end
		local iAngle = math.pi/2*(minArea-1) + math.random(1,90)/90 * math.pi/2
		local dstX, dstY = x0+iDistance*math.cos(iAngle), y0+iDistance*math.sin(iAngle)
		result = self:CallRun(dstX, dstY, nil, on_success, on_breaked)
	end
	
	if result then
		result = ai.BT_RUNNING
	else 
		result = ai.BT_FAIL
	end
	
	return result
end

-- 追逐
function clsRole:ProcChase(objBTNode)
	local target = self:GetFightTarget()
	if not target then return ai.BT_FAIL end
	
	local result = false 
	local x1, y1 = self:getPosition()
	local x2, y2 = target:getPosition()
	if (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) > 10000 then
		local dstX = x2 + math.random(90,110) * math.cos(math.random(1,360)/360*2*math.pi)
		local dstY = y2 + math.random(90,110) * math.cos(math.random(1,360)/360*2*math.pi)
		local on_success = function()
			self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
		end
		local on_breaked = function()
			self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_FAIL)
		end
		result = self:CallRun(dstX, dstY, nil, on_success, on_breaked)
	else
		return ai.BT_SUCCESS
	end
	
	if result then
		result = ai.BT_RUNNING
	else 
		result = ai.BT_FAIL
	end 
	
	self:GetBlackBoard():ChgRunningNodeState(objBTNode, result)
	return result
end

-- 巡逻
function clsRole:ProcPatrol(objBTNode, iPatrolX, iPatrolY, iRange)
	local PatrolPos = self:GetBlackBoard():GetPatrolPos() or {}
	iPatrolX = iPatrolX or PatrolPos[1] or self:getPositionX()
	iPatrolY = iPatrolY or PatrolPos[2] or self:getPositionY()
	iRange = iRange or 200
	
	local dstX = iPatrolX + math.random(-iRange, iRange)
	local dstY = iPatrolY + math.random(-iRange, iRange)
	local on_success = function() 
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
	end
	local on_breaked = function()
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_FAIL)
	end
	local result = self:CallWalk(dstX, dstY, nil, on_success, on_breaked)
	
	if result then
		result = ai.BT_RUNNING
	else 
		result = ai.BT_FAIL
	end 
	
	return result
end

-- 前往某地
function clsRole:ProcGoTo(objBTNode, sType, mapid, x, y, dis)
	local on_success = function()
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
	end
	local on_breaked = function()
		self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_FAIL)
	end
	
	local result = false
	if sType == "run" then
		result = self:CallRun(x, y, dis, on_success, on_breaked)
	elseif sType == "walk" then
		result = self:CallWalk(x, y, dis, on_success, on_breaked)
	elseif sType == "rush" then
		result = self:CallRush(x, y, dis, on_success, on_breaked)
	else 
		assert(false, "参数错误: "..sType)
		result = false
	end
	
	if result then
		result = ai.BT_RUNNING
	else 
		result = ai.BT_FAIL
	end 
	
	return result
end

-- 休息
function clsRole:ProcRest(objBTNode, iTotalFrames)
	self:DestroyTimer("tm_ai_rest")
	local rslt = self:CallRest()
	if rslt then
		if iTotalFrames > 0 then
			self:CreateTimerDelay("tm_ai_rest", iTotalFrames, function()
				self:DestroyTimer("tm_ai_rest")
				self:GetBlackBoard():ChgRunningNodeState(objBTNode, ai.BT_SUCCESS)
			end)
			return ai.BT_RUNNING
		else
			return ai.BT_SUCCESS
		end
	else 
		return ai.BT_FAIL
	end
end

-- 跟随
function clsRole:ProcFollowOwner(objBTNode, sTarget)
	local objTarget
	 
	if sTarget == "hero" then
		objTarget = ClsRoleMgr.GetInstance():GetHero()
	elseif sTarget == "team_leader" then
		local target_id = self:GetMyTeam() and self:GetMyTeam():GetLeaderId()
		objTarget = ClsRoleMgr:GetRole(target_id)
	elseif tonumber(sTarget) then
		local target_id = tonumber(sTarget)
		objTarget = ClsRoleMgr:GetRole(target_id)
	elseif sTarget.GetUid and ClsRoleMgr:GetRole(sTarget:GetUid()) then
		objTarget = sTarget
	end
	
	if not objTarget then 
		self:GetBlackBoard():SetFollowTargetId(nil)
		return ai.BT_FAIL 
	end
	
	self:GetBlackBoard():SetFollowTargetId(objTarget:GetUid())
	return ai.BT_SUCCESS
end


----------------------------------
--- 条件处理
----------------------------------

function clsRole:ProcCan2Rest()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_IDLE) and state_mgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
end

function clsRole:ProcCan2Rush()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_RUSH) and state_mgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH)
end

function clsRole:ProcCan2Run()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_RUN) and state_mgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH)
end

function clsRole:ProcCan2Walk()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_WALK) and state_mgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH)
end

function clsRole:ProcCan2Jump()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_JUMP) and state_mgr:Can2SkyMovState(self, ROLE_STATE.ST_SKYMOVLINE)
end

function clsRole:ProcCan2Skill(iSkillIndex)
	iSkillIndex = iSkillIndex or self:GetBlackBoard():GetSkillIndex()
	if not self:GetSkillMgr():IsSkillEnable(iSkillIndex) then
		return false
	end
	return self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_SKILL)
end

function clsRole:ProcCan2Defend()
	local state_mgr = self.mStateMgr
	return state_mgr:Can2ActState(self, ROLE_STATE.ST_DEFEND) and state_mgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
end

function clsRole:ProcCan2StopSkill()
	return true
end

--------------------------------------

-- 是否有战斗对象
function clsRole:ProcHasFightTarget()
	return self:GetFightTarget() ~= nil
end

-- 敌人是否在技能范围内
function clsRole:ProcInSkillRange(iSkillIndex)
	iSkillIndex = iSkillIndex or self:GetBlackBoard():GetSkillIndex()
	local iSkillId = self:GetSkillMgr():GetSkillId(iSkillIndex)
	local skillRange = setting.GetSkillRange(iSkillId)
	return self:ProcCmpTargetDistance("le", skillRange)
end

-- 角色是否可被攻击
function clsRole:ProcIsTargetCanBeAttack(targetID)
	local targetObj = ClsRoleMgr.GetInstance():GetRole(targetID)
	return targetObj and (not targetObj:IsDead()) and true or false
end

-- 比较敌人血量百分比
function clsRole:ProcCmpEnemyHP(sCmpType, percent)
	local target = self:GetFightTarget()
	if not target then return false end
	return ai.AiCmp(sCmpType, target:GetHPPercent(), percent)
end

-- 比较敌人数量
function clsRole:ProcCmpEnemyNum(sCmpType, iNum)
	local count = self:GetEnemyCount()
	return ai.AiCmp(sCmpType, count, iNum)
end

-- 比较自己的血量百分比
function clsRole:ProcCmpSelfHP(sCmpType, percent)
	local selfHpPercent = self:GetHPPercent()
	return ai.AiCmp(sCmpType, selfHpPercent, percent)
end

-- 比较敌我距离和某个值
function clsRole:ProcCmpTargetDistance(sCmpType, iDistance)
	local target = self:GetFightTarget()
	if not target then return false end
	
	local xTarget, yTarget = target:getPosition()
	local xSelf, ySelf = self:getPosition()
	local dis = (xTarget-xSelf)*(xTarget-xSelf) + (yTarget-ySelf)*(yTarget-ySelf)
	
	return ai.AiCmp(sCmpType, dis, iDistance*iDistance)
end

-- 比较友军数量和某个值
function clsRole:ProcCmpTeammateNum(sCmpType, iNum)
	return ai.AiCmp(sCmpType, self:GetTeammateCount(), iNum)
end

-- 血量低于某值时逃跑
function clsRole:ProcIsEscapeHP(iEscapeHP)
	return self:GetHPPercent() <= iEscapeHP
end

-- 比较概率
function clsRole:ProcCmpRate(rate)
	if is_function(rate) then rate = rate(self) end
	assert(rate>=0 and rate<=1)
	local randValue = math.random(0, 1000)/1000
	return randValue <= rate 
end

-- 比较怒气值是否大于某值
function clsRole:ProcCmpAnger(sCmpType, iValue)
	return ai.AiCmp(sCmpType, self.mRoleData:GetiAngerPower(), iValue)
end

-- 比较士气值
function clsRole:ProcCmpMorale(sCmpType, iValue)
	return ai.AiCmp(sCmpType, self.mRoleData:GetiMorale(), iValue)
end

-- 是否处于巡逻CD中
function clsRole:ProcIsInPatrolCd()
	return self:HasTimer("tm_ai_patrolcd")
end
