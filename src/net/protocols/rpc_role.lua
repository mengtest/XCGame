----------------
-- 
----------------
module("rpc", package.seeall)

c_hero_info = function(Uid, HeroInfo)
	table.print(HeroInfo)
	KE_Director:GetRoleDataMgr():SetHeroId(Uid)
	KE_Director:GetRoleDataMgr():UpdateHeroData(HeroInfo)
end

c_player_info = function(Uid, Info)
	KE_Director:GetRoleDataMgr():UpdatePlayerData(Uid, Info)
end

c_npc_info = function(Uid, Info)
	KE_Director:GetRoleDataMgr():UpdateNpcData(Uid, Info)
end

c_monster_info = function(Uid, Info)
	KE_Director:GetRoleDataMgr():UpdateMonsterData(Uid, Info)
end


c_npcinfo_list = function(InfoList)
	for npcid, npcinfo in pairs(InfoList) do
		KE_Director:GetRoleDataMgr():UpdateNpcData(npcid, npcinfo)
	end
end


c_player_enter_scene = function(Uid, SceneId, x, y, RoleInfo)
	RoleInfo = RoleInfo or {}
	KE_Director:GetRoleDataMgr():UpdatePlayerData(Uid, RoleInfo)
	local man = ClsRoleMgr.GetInstance():CreatePlayer(Uid)
	man:EnterMap(x, y)
end

c_player_leave_scene = function(Uid)
	ClsRoleMgr.GetInstance():DestroyPlayer(Uid)
end

c_role_state = function(roleid, x, y, state)
	if ClsSceneMgr.GetInstance():GetCurSceneName() ~= "rest_scene" then return end
	
	local RoleObj = ClsRoleMgr.GetInstance():GetRole(roleid)
	if not RoleObj and KE_Director:GetRoleDataMgr():GetRoleData(roleid) then 
		c_player_enter_scene(roleid,nil,x,y)
		RoleObj = ClsRoleMgr.GetInstance():GetRole(roleid)
	end
	if not RoleObj then return end
	
	if state == 1 then 
		RoleObj:CallRun(x,y) 
	elseif state == 2 then
		RoleObj:CallWalk(x,y)
	elseif state == 3 then
		RoleObj:CallJump(x,y)
	elseif state == 4 then
		RoleObj:CallRush(x,y)
	end
end
