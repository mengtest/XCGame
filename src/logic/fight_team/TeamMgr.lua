---------------------
-- 分组管理
---------------------
ClsTeamMgr = class("ClsTeamMgr", clsIGroupMgr)

function ClsTeamMgr:ctor()
	clsIGroupMgr.ctor(self)
end

function ClsTeamMgr:dtor()

end

-- @override
function ClsTeamMgr:DoCleanup()
	for team_id, grp in pairs(self.tAllGroups) do
		KE_SafeDelete(grp)
		FireGlobalEvent("DEL_TEAM", team_id)
	end
	self.tAllGroups = {}
end

-- @override
function ClsTeamMgr:CreateGroup(team_id)
	if self.tAllGroups[team_id] then
		assert(false, "已经存在该Team: "..team_id)
		return self.tAllGroups[team_id]
	end
	
	self.tAllGroups[team_id] = clsTeam.new(team_id)
	
	FireGlobalEvent("NEW_TEAM", team_id, self.tAllGroups[team_id])
	
	return self.tAllGroups[team_id]
end

-- @override
function ClsTeamMgr:RemoveGroup(team_id)
	clsIGroupMgr.RemoveGroup(self, team_id)
	
	FireGlobalEvent("DEL_TEAM", team_id)
end

-- @override
function ClsTeamMgr:SetGroupRelation(team_1, team_2, relation)
	clsIGroupMgr.SetGroupRelation(self, team_1, team_2, relation)
	
	FireGlobalEvent("TEAM_RELATION_CHG", team_1, team_2, relation)
end

function ClsTeamMgr:DumpDebugInfo()
	log_warn("---------开始---------")
	for grpID, grp in pairs(self.tAllGroups) do
		log_warn(string.format("TeamId=%d  MemberCnt=%d  EnemyCnt=%d  PartnerCnt=%d", 
			grpID, table.size(grp:GetMemberList()), 
			table.size(grp:GetEnemyList()), table.size(grp:GetPartnerList())) )
	end
	log_warn("---------结束---------")
end