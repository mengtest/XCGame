------------------
-- 战斗流程与规则定制
------------------
module("fight", package.seeall)

local function check_stop_reason(iReason)
	local bFlag = iReason==const.REASON_RESULT or iReason==const.REASON_TIMEOUT or iReason==const.REASON_CLICK_QUIT
	assert(bFlag, "未知的结束原因: "..iReason)
	return bFlag
end


clsCombat = class("clsCombat", clsCoreObject)

function clsCombat:ctor()
	clsCoreObject.ctor(self)
	
	self._bFinished = false
	self.tFightResult = nil
	self.tAllOpSideUid = {}
	self.tAllMySideUid = {}
	self.mTeamMgr = ClsTeamMgr.GetInstance()
	
	self:InitTryFinishTriger()
	self:InitTeams()
end

function clsCombat:dtor()
	if self.mTeamMgr then
		ClsTeamMgr.DelInstance()
		self.mTeamMgr = nil
	end
end

function clsCombat:InitTeams()
	local TeamList = ClsFightSystem.GetInstance():GetTeamList() 
	local TeamRelationInfo = ClsFightSystem.GetInstance():GetTeamRelationInfo() 
	
	-- 创建各分组
	local InstRoleMgr = ClsRoleMgr.GetInstance()
	for TeamId, RoleInfoList in pairs(TeamList) do
		local TeamObj = self.mTeamMgr:CreateGroup(TeamId)
		print("创建队伍：", TeamId)
		for j, RoleInfo in ipairs(RoleInfoList) do
			local monster = InstRoleMgr:CreateRole(RoleInfo.Uid)
			monster:EnterMap(500+100*j, 500*TeamId)
			monster:RecoverHP()
			TeamObj:AddMember(monster)
			print("创建战士：", RoleInfo.Uid, monster:GetRoleType())
		end
	end
	
	-- 设置阵营关系
	for _, info in ipairs(TeamRelationInfo) do
		self.mTeamMgr:SetGroupRelation(info[1], info[2], info[3])
	end
	
	--
	local MySideTeamId = InstRoleMgr:GetHero():GetMyTeamID()
	local MySideTeam = InstRoleMgr:GetHero():GetMyTeam()
	
	local PartnerTeams = MySideTeam:GetPartnerList()
	for tid, TeamObj in pairs(PartnerTeams) do
		local FighterList = TeamObj:GetMemberList()
		for Fighter, _ in pairs(FighterList) do
			self.tAllMySideUid[Fighter:GetUid()] = true
		end
	end
	local FighterList = MySideTeam:GetMemberList()
	for Fighter, _ in pairs(FighterList) do
		self.tAllMySideUid[Fighter:GetUid()] = true
	end
	
	local EnemyTeams = MySideTeam:GetEnemyList()
	for tid, TeamObj in pairs(EnemyTeams) do
		local FighterList = TeamObj:GetMemberList()
		for Fighter, _ in pairs(FighterList) do
			self.tAllOpSideUid[Fighter:GetUid()] = true
		end
	end
	
	print("我方列表")
	table.print(self.tAllMySideUid)
	print("敌方列表")
	table.print(self.tAllOpSideUid)
	
	KE_Director:BindCameraOn(InstRoleMgr:CreateHero())
end

function clsCombat:StartCombat()
	assert(not self._bFinished, "已经在战斗中！！！")
	self.iStartTime = os.clock()
	FireGlobalEvent("START_COMBAT")
end

function clsCombat:StopCombat(iReason)
	check_stop_reason(iReason)
	assert(not self._bFinished, "已经停止了战斗！！！")
	if self._bFinished then return end
	self._bFinished = true
	
	self:GenerateFightResult(iReason)
	ClsFightSystem.GetInstance():OnCombatEnd(iReason)
	
	-- 打印调试信息
	if iReason == const.REASON_RESULT then
		log_warn("+++++++ 战斗结束：胜负已分")
	elseif iReason == const.REASON_TIMEOUT then
		log_warn("+++++++ 战斗结束：超时")
	elseif iReason == const.REASON_CLICK_QUIT then
		log_warn("+++++++ 战斗结束：点击退出")
	else 
		assert(false, "未知的结束原因: "..iReason)
	end
	print("----战斗结果：", self.tFightResult.bWin and "赢" or "输")
	table.print(self.tFightResult)
	
	--
	FireGlobalEvent("END_COMBAT", self.tFightResult)
end


function clsCombat:_TryFinish()
	if self._bFinished then return end
	if self:CheckFinish() then
		self:StopCombat(const.REASON_RESULT)
	end
end

-- 定义尝试结束战斗的触发条件
function clsCombat:InitTryFinishTriger()
	g_EventMgr:AddListener(self, "ROLE_DIE", function(uid, iCurHp)
		self:_TryFinish()
	end)
end

--检查战斗是否结束
function clsCombat:CheckFinish()
	assert(false, "override me")
end

--评判胜负
function clsCombat:Judge()
	assert(false, "override me")
end

--生成战斗结果信息
function clsCombat:GenerateFightResult(iReason)
	assert(not self.tFightResult, "已经统计过战斗结果")
	local EndTime = os.clock()
	self.tFightResult = {
		bWin = self:Judge(),	--胜负
		iMaxDribble = 0,		--最大连击数
		iMaxDamage = 0,			--最大伤害值
		iOpDieCount = 0,		--敌方死亡数
		iOpHurtCount = 0,		--敌方伤残数
		iMeDieCount = 0,		--我方死亡数
		iMeHurtCount = 0,		--我方伤残数
		iUseTime = EndTime-self.iStartTime,	--用时
		iReason = iReason,
	}
	return self.tFightResult
end

--获取战斗结果
function clsCombat:GetFightResult()
	assert(self.tFightResult, "尚未统计战斗结果")
	return self.tFightResult
end

--判断某队伍是否所有成员都已经阵亡
function clsCombat:IsTeamDie(TeamId)
	local InstRoleMgr = ClsRoleMgr.GetInstance()
	local TeamList = ClsFightSystem.GetInstance():GetTeamList() 
	local RoleInfoList = TeamList[TeamId]
	for _, RoleInfo in ipairs(RoleInfoList) do
		if not InstRoleMgr:IsRoleDead(RoleInfo.Uid) then
			return false
		end
	end
	return true
end


-- 检查战斗目标是否全部达成
function clsCombat:_CheckGoals()
	
end

function clsCombat:rule_time_limit(iTimeLimit)
	if not self.tFightResult then return true end
	return self.tFightResult.iReason ~= const.REASON_TIMEOUT
end

function clsCombat:rule_kill_num(iNum)
	assert(false, "尚未实现该方法")
end

function clsCombat:rule_kill_boss(bossid_list)
	local InstRoleMgr = ClsRoleMgr.GetInstance()
	for _, bossid in ipairs(bossid_list) do
		if not InstRoleMgr:IsRoleDead(bossid) then
			return false
		end
	end
	return true
end

function clsCombat:rule_more_blood()
	
end
