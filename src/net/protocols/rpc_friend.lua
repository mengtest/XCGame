----------------
-- 好友协议
----------------
module("rpc", package.seeall)

c_add_friend = function(uid, FriInfo)
	KE_Director:GetFriendMgr():AddFriend(uid, FriInfo)
end

c_del_friend = function(uid)
	KE_Director:GetFriendMgr():DelFriend(uid)
end

c_update_friend = function(uid, info)
	KE_Director:GetFriendMgr():UpdateFriend(uid, info)
end

c_add_section = function(section_id, section_name)
	KE_Director:GetFriendMgr():AddSection(section_id, section_name)
end

c_del_section = function(section_id)
	KE_Director:GetFriendMgr():DelSection(section_id)
end

c_rename_section = function(section_id, new_name)
	KE_Director:GetFriendMgr():RenameSection(section_id, new_name)
end
