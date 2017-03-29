-----------------
-- 用户管理
-----------------
module("server", package.seeall)

ClsUserMgr = class("ClsUserMgr", clsCoreObject)
ClsUserMgr.__is_singleton = true

function ClsUserMgr:ctor()
	clsCoreObject.ctor(self)
	
	self.AllUserByUid = {}
	self.AllUserByPid = new_weak_table("v")
	self.AllUserByName = new_weak_table("v")
end

function ClsUserMgr:dtor()
	for _, UserObj in pairs(self.AllUserByUid) do
		KE_SafeDelete(UserObj)
	end
	self.AllUserByUid = nil
	self.AllUserByPid = nil
	self.AllUserByName = nil
end

function ClsUserMgr:AddUser(AcountInfo)
	local Uid = AcountInfo.Uid
	if self.AllUserByUid[Uid] then
		assert(false, "已经添加该角色: "..Uid)
		return self.AllUserByUid[Uid]
	end
	
	local UserObj = clsUserObj.new(AcountInfo)
	self.AllUserByUid[UserObj:GetUid()] = UserObj
	self.AllUserByPid[UserObj:GetPid()] = UserObj
	self.AllUserByName[UserObj:GetName()] = UserObj
	return UserObj
end

function ClsUserMgr:DelUserByUid(Uid)
	local UserObj = self.AllUserByUid[Uid]
	if not UserObj then return end
	self.AllUserByUid[UserObj:GetUid()] = nil
	self.AllUserByPid[UserObj:GetPid()] = nil
	self.AllUserByName[UserObj:GetsName()] = nil
	KE_SafeDelete(UserObj)
end

function ClsUserMgr:GetUserByUid(Uid) return self.AllUserByUid[Uid] end
function ClsUserMgr:GetUserByPid(Pid) return self.AllUserByPid[Pid] end
function ClsUserMgr:GetUserByName(Name) return self.AllUserByName[Name] end
