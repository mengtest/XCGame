----------------
-- 战斗协议
----------------
module("rpc", package.seeall)

c_fight_city = function(CityId)
	local CityData = KE_Director:GetCityMgr():GetCityData(CityId)
	
	local sCombatType = const.COMBAT_TYPE.CITY_SIEGE
	
	local tFightGoal = {

	}
	
	local tTeamList = {}
	local InstEmbattleMgr = KE_Director:GetEmbattleMgr()
	local UidList = InstEmbattleMgr:GetFormation(sCombatType) and InstEmbattleMgr:GetFormation(sCombatType):GetFighterUidList() or {}
	tTeamList[1] = { {Uid = KE_Director:GetHeroId()} }
	for _, FighterUid in ipairs(UidList) do
		table.insert( tTeamList[1], {Uid = FighterUid} )
	end
	tTeamList[2] = {}
	local InstRoleDataMgr = KE_Director:GetRoleDataMgr()
	local monster_list = KE_Director:GetTroopMgr():GetCityTroopByLeader(CityId):GetMemberList()
	for i, cfg in ipairs(monster_list) do
		local typeid = cfg[1]
		local RoleInfo = setting.T_card_cfg[typeid]
		for j=1, cfg[2] do
			local InfoCopy = table.clone(RoleInfo)
			local Uid = #tTeamList[2]+1 + const.MONSTER_ID_BEGIN
			InstRoleDataMgr:UpdateMonsterData(Uid, InfoCopy)
			table.insert( tTeamList[2], { Uid=Uid } )
		end
	end
	
	local tTeamRelationInfo = {
		{ 1, 2, const.RELATION_ENEMY },
	}
	
	local EndCallback = function(ResultInfo) 
		local tFightResult = table.clone(ResultInfo)
		local iWin = 0  if tFightResult.bWin then iWin = 1 end 
		tFightResult.bWin = iWin
		network.SendPro("s_fight_city_result", nil, CityId, iWin, tFightResult)
		
		if ResultInfo.bWin then 
			utils.TellMe("恭喜恭喜，大获全胜！", 5)
		else
			utils.TellMe("加油加油，卷土重来！", 5)
		end 
	end 
	
	local FightInfo = {
		sCombatType = sCombatType,
		tFightGoal = tFightGoal,
		tTeamList = tTeamList,
		tTeamRelationInfo = tTeamRelationInfo,
		EndCallback = EndCallback,
	}
	fight.ClsFightSystem.GetInstance():EnterFight(FightInfo)
end

c_fight_stage = function(StageId)
	local StageInfo = setting.GetStageInfoById(StageId)
	
	local sCombatType = const.COMBAT_TYPE.STAGE
	
	local tFightGoal = {
		
	}
	
	local tTeamList = {}
	local InstEmbattleMgr = KE_Director:GetEmbattleMgr()
	local UidList = InstEmbattleMgr:GetFormation(sCombatType) and InstEmbattleMgr:GetFormation(sCombatType):GetFighterUidList() or {}
	tTeamList[1] = { {Uid = KE_Director:GetHeroId()} }
	for _, FighterUid in ipairs(UidList) do
		table.insert( tTeamList[1], {Uid = FighterUid} )
	end
	tTeamList[2] = {}
	local InstRoleDataMgr = KE_Director:GetRoleDataMgr()
	local monster_list = StageInfo.monster_list
	for i, cfg in ipairs(monster_list) do
		local typeid = cfg[1]
		local RoleInfo = setting.T_card_cfg[typeid]
		for j=1, cfg[2] do
			local InfoCopy = table.clone(RoleInfo)
			local Uid = #tTeamList[2]+1 + const.MONSTER_ID_BEGIN
			InstRoleDataMgr:UpdateMonsterData(Uid, InfoCopy)
			table.insert( tTeamList[2], { Uid=Uid } )
		end
	end
	
	local tTeamRelationInfo = {
		{ 1, 2, const.RELATION_ENEMY },
	}
	
	local EndCallback = function(ResultInfo) 
		local tFightResult = table.clone(ResultInfo)
		local iWin = 0  if tFightResult.bWin then iWin = 1 end 
		tFightResult.bWin = iWin
		network.SendPro("s_fight_stage_result", nil, StageId, iWin, tFightResult)
		
		if ResultInfo.bWin then 
			utils.TellMe("恭喜恭喜，大获全胜！", 5)
		else
			utils.TellMe("加油加油，卷土重来！", 5)
		end 
	end 
	
	local FightInfo = {
		sCombatType = sCombatType,
		tFightGoal = tFightGoal,
		tTeamList = tTeamList,
		tTeamRelationInfo = tTeamRelationInfo,
		EndCallback = EndCallback,
	}
	fight.ClsFightSystem.GetInstance():EnterFight(FightInfo)
end

c_fight_arena = function(EnemyId)
	local sCombatType = const.COMBAT_TYPE.ARENA
	
	local tFightGoal = {
		rule_time_limit = {60},
	}
	
	local tTeamList = {
		[1] = { {Uid = KE_Director:GetHeroId()} },
		[2] = { {Uid = EnemyId} },
	}
	
	local tTeamRelationInfo = {
		{ 1, 2, const.RELATION_ENEMY },
	}
	
	local EndCallback = function(ResultInfo)
		local tFightResult = table.clone(ResultInfo)
		local iWin = 0  if tFightResult.bWin then iWin = 1 end 
		tFightResult.bWin = iWin
		network.SendPro("s_fight_arena_result", nil, EnemyId, iWin, tFightResult)
		
		if ResultInfo.bWin then 
			utils.TellMe("恭喜恭喜，大获全胜！", 5)
		else
			utils.TellMe("加油加油，卷土重来！", 5)
		end 
	end 
	
	local FightInfo = {
		sCombatType = sCombatType,
		tFightGoal = tFightGoal,
		tTeamList = tTeamList,
		tTeamRelationInfo = tTeamRelationInfo,
		EndCallback = EndCallback,
	}
	fight.ClsFightSystem.GetInstance():EnterFight(FightInfo)
end
