module("server", package.seeall)

s_player_info = function(UserId, PlayerId)
	if ClsSerDataMgr.GetInstance()._UserInfoSet[PlayerId] then
		ClsSerDataMgr.GetInstance()._UserInfoSet[PlayerId].iRoleType = nil
		server.c_player_info(PlayerId, ClsSerDataMgr.GetInstance()._UserInfoSet[PlayerId])
	else 
		server.c_tell_fail("不存在该角色")
	end
end
