----------------
-- 聊天协议
----------------
module("rpc", package.seeall)

c_chat = function(channel, msg, sender_id, sender_name)
	KE_Director:GetChatMgr():ReceiveMsg(channel, msg, sender_id, sender_name)
end
