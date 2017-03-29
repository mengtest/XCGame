module("server", package.seeall)

s_chat = function(UserId, channel, msg, sender_id, sender_name)
	server.c_chat(channel, msg, sender_id, sender_name)
end