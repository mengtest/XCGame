module("server", package.seeall)

s_signin = function(UserId, iDay)
	if ClsSerDataMgr.GetInstance()._SignInfoList[iDay].iSigned == 1 then
		server.c_tell_fail("已经签过到")
		return
	end
	local today = os.date("*t")
	if iDay < today.day then
		server.c_tell_fail("已过期")
		return
	elseif iDay > today.day then
		server.c_tell_fail("尚未到时候")
		return
	end
	
	ClsSerDataMgr.GetInstance()._SignInfoList[iDay].iSigned = 1
	ClsSerDataMgr.GetInstance():SaveSigninList()
	server.c_signin(iDay)
end