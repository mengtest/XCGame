----------------
-- 登录协议
----------------
module("rpc", package.seeall)

c_login_succ = function(userid, username)
	print("登录成功 ... ...", userid, username)
	KE_Director:GetStateMachine():ToStateChooseServer()
end

c_enter_game = function()
	KE_Director:GetStateMachine():ToStateGameing()
end
