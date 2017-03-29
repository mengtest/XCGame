---------------
-- 用户
---------------
module("server", package.seeall)

clsUserObj = class("clsUserObj", clsCoreObject)

clsUserObj:RegSaveVar("Pid", TYPE_CHECKER.INT)				--PID
clsUserObj:RegSaveVar("Uid", TYPE_CHECKER.INT)				--UID
clsUserObj:RegSaveVar("sName", TYPE_CHECKER.STRING)			--名字


function clsUserObj:ctor(AcountInfo)
	clsCoreObject.ctor(self)
	self:SetUid(AcountInfo.Uid)
	self:SetPid(AcountInfo.Uid)
	self:SetsName(AcountInfo.Uid)
end

function clsUserObj:dtor()
	
end

