----------------
-- 好友管理器
----------------
clsFriendManager = class("clsFriendManager", clsCoreObject)
clsFriendManager.__is_singleton = true

clsFriendManager:RegisterEventType("add_friend")
clsFriendManager:RegisterEventType("del_friend")
clsFriendManager:RegisterEventType("update_friend")

function clsFriendManager:ctor()
	clsCoreObject.ctor(self)
	
	self.MAX_FRIEND_CNT = 100
	self.tFriendList = {}
	
	--测试数据
	local TypeList = {10001,10002,10003}
	for i=1, 100 do
		local info = {
			Uid = const.PLAYER_ID_BEGIN + i,
			TypeId = TypeList[math.random(1,3)],	
			Name = "名字_"..i,
			IsOnLine = math.random(0,1),
			iGrade = math.random(0,255),
			CombatForce = math.random(1000,9999999),
			SendPower = math.random(0,1),
		}
		self:AddFriend(info.Uid, info)
	end
end

function clsFriendManager:dtor()

end

--[[
{
	Uid = [int],			--好友的用户ID
	TypeId = [int],			--
	Name = [string],		--名字
	IsOnLine = [boolean],	--是否在线
	iGrade = [int],			--等级
	CombatForce = [int],	--战力
	SendPower = [int],		--是否送过我体力[0否 1是]
}
]]--
function clsFriendManager:AddFriend(Uid, info)
	if info.Uid then assert(Uid==info.Uid, "Uid不一致") end
	assert(not self.tFriendList[Uid], "已经添加过该好友")
	info.Uid = Uid
	self.tFriendList[Uid] = info
	self:FireEvent("add_friend", Uid, info)
end

function clsFriendManager:DelFriend(Uid)
	if self.tFriendList[Uid] then
		self.tFriendList[Uid] = nil
		self:FireEvent("del_friend", Uid)
	end
end

function clsFriendManager:UpdateFriend(Uid, info)
	local info_ref = self.tFriendList[Uid]
	if not info_ref then 
		assert(false, "并未添加该好友："..Uid)
		return
	end
	
	for k,v in pairs(info) do
		info_ref[k] = table.clone(v) 
	end
	self:FireEvent("update_friend", Uid, info_ref)
end


function clsFriendManager:GetFriendCnt()
	return table.size(self.tFriendList)
end

function clsFriendManager:GetFriendInfo(Uid)
	return self.tFriendList[Uid]
end

function clsFriendManager:GetFriendList()
	local FriendArray = {}
	for _, FriendInfo in pairs(self.tFriendList) do
		FriendArray[#FriendArray+1] = FriendInfo
	end
	table.quick_sort(FriendArray, function(a,b) 
		if a.IsOnLine == b.IsOnLine then
			return a.CombatForce < b.CombatForce
		end
		return a.IsOnLine < b.IsOnLine
	end)
	return FriendArray
end

function clsFriendManager:GetUserList()
	return {}
end

function clsFriendManager:GetReqList()
	return {}
end
