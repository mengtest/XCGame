module("server", package.seeall)

s_login = function(xxx, ip, port, username, password)
	local info = ClsSerDataMgr.GetInstance():GetUserInfoByUsername(username)
	if not info then
		server.c_tell_fail("不存在该用户："..username)
		return 
	end
	
	local userid = info.Uid
	print("登录成功...", userid, username, ip, port)
	
	ClsSerDataMgr.GetInstance():OnUserLogin(userid)
	server.c_login_succ(userid, username)
	server.c_hero_info(userid, info)
	server.c_country_list(ClsSerDataMgr.GetInstance()._CountryList)
	server.c_city_list(ClsSerDataMgr.GetInstance()._CityList)
	server.c_npcinfo_list(ClsSerDataMgr.GetInstance()._NpcInfoSet)
	server.c_country_relation_list(ClsSerDataMgr.GetInstance()._CountryRelation)
	server.c_enter_game()
	--
	server.c_item_list(ClsSerDataMgr.GetInstance()._ItemList)
	local trooplist = {}
	for _, troop in ipairs(ClsSerDataMgr.GetInstance()._TroopList) do
		local TypeIdList = {}
		local CountList = {}
		for _, mbr in ipairs(troop.MemberList) do
			table.insert(TypeIdList,mbr[1])
			table.insert(CountList,mbr[2])
		end
		trooplist[#trooplist+1] = { 
			Uid = troop.Uid, TroopType=troop.TroopType, LeaderId=troop.LeaderId, 
			TypeIdList=TypeIdList, CountList=CountList 
		}
	end
	server.c_troop_list(trooplist)
	server.c_stage_list(ClsSerDataMgr.GetInstance()._StageSet)
	server.c_signin_list(ClsSerDataMgr.GetInstance()._SignInfoList)
	
	--[[
	local MAX_CNT = 20
	local cnt = 0 
	for uid, info in pairs(ClsSerDataMgr.GetInstance()._UserInfoSet) do
		server.c_player_enter_scene(uid, -1, math.random(100,900), math.random(100,500), info)
		server.c_role_state(uid, math.random(50,2500), math.random(50,1400), 2)
		cnt = cnt + 1 
		if cnt > MAX_CNT then break end
	end
	KE_SetAbsInterval(4, function()
		local cnt = 0
		for uid, info in pairs(ClsSerDataMgr.GetInstance()._UserInfoSet) do
			if uid ~= userid then
				server.c_role_state(uid, math.random(50,2500), math.random(50,1400), math.random(1,5))
				cnt = cnt + 1 
				if cnt > MAX_CNT then break end
			end
		end
	end)
	--]]
end
