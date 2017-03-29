--------------
-- 服务器入口
--------------
module("server", package.seeall)

ClsServerMachine = class("ClsServerMachine", clsCoreObject)

function ClsServerMachine:ctor()
	clsCoreObject.ctor(self)
	
end

function ClsServerMachine:dtor()
	
end

function ClsServerMachine:ToStateStart()
	-- 数据初始化
	ClsSerDataMgr.GetInstance()
	-- 网络初始化
	server:Start()
end

function ClsServerMachine:ToStateExit()
	
end

-----------------------

ClsServerMachine.GetInstance():ToStateStart()
