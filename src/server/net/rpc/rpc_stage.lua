module("server", package.seeall)

s_stage_list = function(UserId)
	server.c_stage_list(ClsSerDataMgr.GetInstance()._StageSet)
end