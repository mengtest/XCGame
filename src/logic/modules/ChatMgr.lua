----------------
-- 聊天系统管理器
----------------
local MAX_LENGTH = 100

clsChatManager = class("clsChatManager", clsCoreObject)
clsChatManager.__is_singleton = true

clsChatManager:RegisterEventType("new_msg")
clsChatManager:RegisterEventType("clear_msg")

function clsChatManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllMsgs = {
		[const.CHANNEL_PRIVATE] = {},
		[const.CHANNEL_TEAM] = {},
		[const.CHANNEL_FACTION] = {},
		[const.CHANNEL_WORLD] = {},
		[const.CHANNEL_MIX] = {},
	}
end

function clsChatManager:dtor()

end

function clsChatManager:GetMsgByChannel(channel)
	return self.tAllMsgs[channel]
end

function clsChatManager:ReceiveMsg(channel, msg, sender_id, sender_name)
	assert(self.tAllMsgs[channel], "不存在该聊天频道："..channel)
	
	msg = string.format("#G%s#n: %s", sender_name, msg)
	table.insert(self.tAllMsgs[channel], msg)
	
	if #self.tAllMsgs[channel] > MAX_LENGTH then
		table.remove(self.tAllMsgs[channel], 1)
	end
	
	self:FireEvent("new_msg", channel, msg)
end

function clsChatManager:ClearMsg(channel)
	self.tAllMsgs[channel] = {}
	self:FireEvent("clear_msg", channel)
end

function clsChatManager:ClearAllMsg()
	for channel, _ in pairs(self.tAllMsgs) do
		self:ClearMsg(channel)
	end
end


function clsChatManager:SendPrivateMsg(msg)
	network.SendPro("s_chat", nil, const.CHANNEL_PRIVATE, msg, KE_Director:GetHeroId(), KE_Director:GetHeroName())
end
function clsChatManager:SendTeamMsg(msg)
	network.SendPro("s_chat", nil, const.CHANNEL_TEAM, msg, KE_Director:GetHeroId(), KE_Director:GetHeroName())
end
function clsChatManager:SendFactionMsg(msg)
	network.SendPro("s_chat", nil, const.CHANNEL_FACTION, msg, KE_Director:GetHeroId(), KE_Director:GetHeroName())
end
function clsChatManager:SendWorldMsg(msg)
	network.SendPro("s_chat", nil, const.CHANNEL_WORLD, msg, KE_Director:GetHeroId(), KE_Director:GetHeroName())
end
