----------------
-- 签到协议
----------------
module("rpc", package.seeall)

c_signin_list = function(infolist)
	KE_Director:GetSignInMgr():InitSigninList(infolist)
end

c_signin = function(iDay)
	KE_Director:GetSignInMgr():Sign(iDay)
end
