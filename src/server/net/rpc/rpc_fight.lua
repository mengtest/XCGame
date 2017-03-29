module("server", package.seeall)

s_fight_city = function(UserId, CityId)
	if ClsSerDataMgr.GetInstance()._CurFighting then
		server.c_tell_fail("已经在战斗中了")
		return false
	end
	if ClsSerDataMgr.GetInstance()._CityList[CityId].iCastellanId == UserId then
		server.c_tell_fail("该城已经属于你，不可再攻占")
		return 
	end
	
	ClsSerDataMgr.GetInstance()._CurFighting = CityId
	server.c_fight_city(CityId)
end

s_fight_city_result = function(UserId, CityId, iWin, tFightResult)
	ClsSerDataMgr.GetInstance()._CurFighting = nil
	local bWin = iWin == 1 
	
	if not bWin then
		server.c_tell_fail("攻城失败！加油再上！！！")
		return
	end
	
	local CityInfo = ClsSerDataMgr.GetInstance()._CityList[CityId]
	
	if not CityInfo then
		server.c_tell_fail("要攻占的城池不存在")
		return
	end
	
	local CurState = CityInfo.iCurState
	local NextState = CurState + 1
	if NextState == #const.CITY_STATE_CIRCLE then
		NextState = const.CITY_STATE_CIRCLE[1]
		CityInfo.iCastellanId = UserId
		CityInfo.iCountryId = ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iCountryId
		server.c_notice("恭喜你拿下了城池："..setting.T_city_cfg[CityInfo.Uid].sName)
	end
	CityInfo.iCurState = NextState
			
	-- 如果已经攻占
	--    如果攻占者已经加入国家，可请求分封
	--    如果没有加入国家，询问自立建国或者加入并奉献给某国
	if CityInfo.iCastellanId == UserId then
		if ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iCountryId then
			
		else
			
		end
	end
			
	ClsSerDataMgr.GetInstance():SaveCityList()
	
	server.c_update_city(CityId, CityInfo)
end

s_fight_stage = function(UserId, StageId)
	if ClsSerDataMgr.GetInstance()._CurFighting then
		server.c_tell_fail("已经在战斗中了")
		return
	end
	
	local StageInfo = setting.GetStageInfoById(StageId)
	local StageType = StageInfo.StageType
	local preStage = setting.GetPreStage(StageId)
	
	print("=========",preStage, ClsSerDataMgr.GetInstance()._StageSet[StageType])
	if preStage and preStage > ClsSerDataMgr.GetInstance()._StageSet[StageType] then
		server.c_tell_fail("请先通关上一关卡")
		return
	end
	
	ClsSerDataMgr.GetInstance()._CurFighting = StageId
	server.c_fight_stage(StageId)
end

s_fight_stage_result = function(UserId, StageId, bWin, tFightResult)
	ClsSerDataMgr.GetInstance()._CurFighting = nil
	if bWin==1 then
		local StageInfo = setting.GetStageInfoById(StageId)
		local StageType = StageInfo.StageType
		ClsSerDataMgr.GetInstance()._StageSet[StageType] = StageId
		ClsSerDataMgr.GetInstance():SaveStageSet()
		server.c_stage_list(ClsSerDataMgr.GetInstance()._StageSet)
	end
end

s_fight_arena = function(UserId, EnemyId)
	if ClsSerDataMgr.GetInstance()._CurFighting then
		server.c_tell_fail("已经在战斗中了")
		return
	end
	
	ClsSerDataMgr.GetInstance()._CurFighting = EnemyId
	server.c_fight_arena(EnemyId)
end

s_fight_arena_result = function(UserId, EnemyId, bWin, tFightResult)
	ClsSerDataMgr.GetInstance()._CurFighting = nil
	if bWin==1 then
		
	end
end