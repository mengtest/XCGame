-------------------
-- 战斗系统
-------------------
module("fight", package.seeall)

ClsFightSystem = class("ClsFightSystem", clsCoreObject)
ClsFightSystem.__is_singleton = true

function ClsFightSystem:ctor()
	clsCoreObject.ctor(self)
	--
	self._bInFight = false		--入口开关，防止重复进入
	self._bCombating = false	--战斗开关，是否处于战斗中
	--
	self.tFightResult = nil
	self.sCombatType = nil
	self.tFightGoal = nil
	self.tTeamList = nil
	self.tTeamRelationInfo = nil
	self.funcEndCallback = nil
	self.bVideo = false
	self.bAffectEnable = true
	--
	self.mCombat = nil
end

function ClsFightSystem:dtor()
	self:DestroyAllTimer()
	self:_DoCleanup()
end

function ClsFightSystem:GetCombatType() return self.sCombatType end
function ClsFightSystem:GetFightGoal() return self.tFightGoal end
function ClsFightSystem:GetTeamList() return self.tTeamList end
function ClsFightSystem:GetTeamRelationInfo() return self.tTeamRelationInfo end

function ClsFightSystem:IsAffectEnable() return self.bAffectEnable end
function ClsFightSystem:IsInFight() return self._bInFight end
function ClsFightSystem:IsCombating() return self._bCombating end
function ClsFightSystem:GetFightResult() return self.tFightResult end


---------------------
-- 流程
---------------------
--[[
Info = {
	sCombatType = const.COMBAT_TYPE.STAGE,
	tFightGoal = {
		rule_time_limit = {60},		--需限时秒
		rule_kill_num = {-1},		--需击杀数(-1表示需全部击杀）
		rule_kill_boss = {},		--需击杀BOSS 
	},
	tTeamList = {
		[1001] = {
			{ Uid=1 },
			{ Uid=2 },
		},
		[1002] = {
			{ Uid=101 },
			{ Uid=102 },
		},
	},
	tTeamRelationInfo = {
		{ 1001, 1002, const.RELATION_ENEMY },
	},
	EndCallback = function(...) end,
	bVideo = true/false,
}
]]--
function ClsFightSystem:_CheckArgs(Info)
	assert(utils.IsValidCombatType(Info.sCombatType), "未定义的Combat类型："..Info.sCombatType)
	assert(Info.tFightGoal==nil or is_table(Info.tFightGoal), "tFightGoal类型错误")
	assert(Info.tTeamList, "参战队伍序列不可为空")
	local allfighters = {}
	for teamid, fighterlist in pairs(Info.tTeamList) do 
		assert(not table.is_empty(fighterlist), "该队伍为空："..teamid)
		for _, RoleInfo in ipairs(fighterlist) do
			assert(not allfighters[RoleInfo.Uid], "重复添加队员: "..RoleInfo.Uid)
			allfighters[RoleInfo.Uid] = true
		end
	end
	assert(Info.tTeamRelationInfo, "队伍关系描述不可为空")
	assert(not table.is_empty(Info.tTeamRelationInfo), "未设置队伍关系")
	for _, RelationInfo in ipairs(Info.tTeamRelationInfo) do
		assert(Info.tTeamList[RelationInfo[1]], "队伍关系描述错误，不存在队伍："..RelationInfo[1])
		assert(Info.tTeamList[RelationInfo[2]], "队伍关系描述错误，不存在队伍："..RelationInfo[2])
	end
	assert(is_function(Info.EndCallback) or Info.EndCallback==nil, "EndCallback必须为函数或为空")
	assert(Info.bVideo==nil or is_boolean(Info.bVideo), "bVideo需传入boolean类型")
end

--战斗系统入口
function ClsFightSystem:EnterFight(FightInfo)
	--检查参数
	self:_CheckArgs(FightInfo)
	
	--防止重复进入
	if self._bInFight then 
		utils.TellMe("已经在战斗中")
		return 
	end
	self._bInFight = true
	log_warn("+++++++ 进入战斗系统")
	
	-- 数据初始化
	assert(self.mCombat==nil)
	self.tFightResult = nil
	self.sCombatType = FightInfo.sCombatType
	self.tFightGoal = FightInfo.tFightGoal or {}
	self.tTeamList = FightInfo.tTeamList
	self.tTeamRelationInfo = FightInfo.tTeamRelationInfo
	self.funcEndCallback = FightInfo.EndCallback
	self.bVideo = FightInfo.bVideo and true or false
	self.bAffectEnable = true
	
	-- 进入战斗场景
	log_warn("+++++++ 进入战斗场景")
	ClsSceneMgr.GetInstance():Turn2Scene("fight_scene", function() self:_OnLoadingOver() end)
end

function ClsFightSystem:_OnLoadingOver()
	log_warn("+++++++ 战斗场景加载完毕")
	
	-- 显示战斗UI
	local fightPanel = ClsUIManager.GetInstance():ShowPanel("clsFightPanel")
	
	local sCombatType = self.sCombatType
	
	-- 创建战场
	if sCombatType == const.COMBAT_TYPE.CITY_SIEGE then
		self.mCombat = clsCombatCitySiege.new()
	elseif sCombatType == const.COMBAT_TYPE.CITY_BREAK then
		self.mCombat = clsCombatCitySiege.new()
	elseif sCombatType == const.COMBAT_TYPE.CITY_CLAIM then
		self.mCombat = clsCombatCitySiege.new()
	elseif sCombatType == const.COMBAT_TYPE.STAGE then
		self.mCombat = clsCombatStage.new()
	elseif sCombatType == const.COMBAT_TYPE.ROUND then
		self.mCombat = clsCombatRound.new()
	elseif sCombatType == const.COMBAT_TYPE.ARENA then
		self.bAffectEnable = false 
		self.mCombat = clsCombatArena.new()
	else 
		assert(false, "未定义的战场类型： "..sCombatType)
	end
	
	-- 3秒后开战
	local compPicNumber = ui.clsPicNumber.new(KE_Director:GetLayerMgr():GetLayer(const.LAYER_WAITING))
	compPicNumber:SetToCenter()
	compPicNumber:SetModal(true,false)
	compPicNumber:SetValue(3)
	self:CreateAbsTimerLoop("tmStart", 1, function()
		compPicNumber:SetValue(compPicNumber:GetValue()-1)
		
		if compPicNumber:GetValue() == 0 then
			self:DestroyTimer("tmStart")
			if compPicNumber then
				KE_SafeDelete(compPicNumber)
				compPicNumber = nil
			end
			
			-- 开战
			self:StartCombat()
		end
	end)
end

--开始战斗
function ClsFightSystem:StartCombat()
	assert(self._bCombating==false)
	log_warn("+++++++ 战斗开始")
	self._bCombating = true
	self.mCombat:StartCombat()
	self:StartCountDown()
end

--战斗结束
function ClsFightSystem:OnCombatEnd(iReason)
	assert(self._bCombating==true)
	self:StopCountDown()
	self.tFightResult = self.mCombat:GetFightResult()
	self._bCombating = false
	
	if self.funcEndCallback then
		self.funcEndCallback(self.tFightResult)
		self.funcEndCallback = nil
	end
	
	self:_LeaveFight()
end

function ClsFightSystem:_LeaveFight()
	-- 3秒后退出战斗
	local compPicNumber = ui.clsPicNumber.new(KE_Director:GetLayerMgr():GetLayer(const.LAYER_WAITING))
	compPicNumber:SetToCenter()
	compPicNumber:SetModal(true, true)
	compPicNumber:SetValue(3)
	self:CreateAbsTimerLoop("tmExit", 1, function()
		compPicNumber:SetValue(compPicNumber:GetValue()-1)
		
		if compPicNumber:GetValue() <= 0 then
			self:DestroyTimer("tmExit")
			
			if compPicNumber then
				KE_SafeDelete(compPicNumber)
				compPicNumber = nil
			end
			
			self:_DoCleanup()
			self._bInFight = false
			
			self:_ShowFightResult()
		end
	end)
end

function ClsFightSystem:_ShowFightResult()
	local bIsWin = self.tFightResult.bWin
	local ResultPanel 
	if bIsWin then 
		ResultPanel = ClsUIManager.GetInstance():ShowPanel("clsWinPanel")
	else
		ResultPanel = ClsUIManager.GetInstance():ShowPanel("clsFailPanel")
	end
	
	ResultPanel:SetToCenter()
	ResultPanel:SetModal(true, true, function()
		ResultPanel:Close()
		self:_ExitFightScene()
	end)
end

function ClsFightSystem:_ExitFightScene()
	local sCombatType = self.sCombatType
	
	if sCombatType == const.COMBAT_TYPE.CITY_SIEGE then
		ClsSceneMgr.GetInstance():Turn2Scene("journey_scene")
	elseif sCombatType == const.COMBAT_TYPE.STAGE then
		ClsSceneMgr.GetInstance():Turn2Scene("rest_scene")
	elseif sCombatType == const.COMBAT_TYPE.ARENA then
		ClsSceneMgr.GetInstance():Turn2Scene("rest_scene")
	else 
		assert(false,"天哪，我要回到哪个场景去才好哦")
	end
end

function ClsFightSystem:_DoCleanup()
	self:StopCountDown()
	ClsUIManager.GetInstance():DestroyWindow("clsFightPanel")
	if self.mCombat then
		KE_SafeDelete(self.mCombat)
		self.mCombat = nil
	end
end

---------------------
-- 计时器
---------------------
function ClsFightSystem:StartCountDown()
	local fightPanel = ClsUIManager.GetInstance():GetWindow("clsFightPanel")
	
	local TOTAL_SECONDS = self.tFightGoal.rule_time_limit and self.tFightGoal.rule_time_limit[1]
	if not (TOTAL_SECONDS and TOTAL_SECONDS > 0) then
		self:StopCountDown() 
		fightPanel:RefreshTimeStr("")
		return
	end
	
	local leftTime = TOTAL_SECONDS
	
	fightPanel:RefreshTimeStr( string.format("剩余时间：%d/%d", TOTAL_SECONDS, TOTAL_SECONDS) )
	
	self:CreateAbsTimerLoop("tmCountDown", 1, function()
		leftTime = leftTime - 1 
		fightPanel:RefreshTimeStr( string.format("剩余时间：%d/%d", leftTime, TOTAL_SECONDS) )
		if leftTime <= 0 then
			self:DestroyTimer("tmCountDown")
			self.mCombat:StopCombat(const.REASON_TIMEOUT)
			return true
		end
	end)
end

function ClsFightSystem:StopCountDown()
	self:DestroyTimer("tmCountDown")
end

function ClsFightSystem:PauseCountDown(bPause)
	self:PauseTimer("tmCountDown", bPause)
end

---------------------
--
---------------------

-- 点击退出战斗按钮
function ClsFightSystem:RequestExit()
	self.mCombat:StopCombat(const.REASON_CLICK_QUIT)
end
