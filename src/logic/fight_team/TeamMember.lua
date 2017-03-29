---------------
--
---------------

clsTeamMember = class("clsTeamMember")

function clsTeamMember:ctor()
	self._mTeam = nil
end

function clsTeamMember:dtor()
	self:RemoveFromTeam()
end

function clsTeamMember:GetMyTeamID()
	return self._mTeam and self._mTeam:GetUid()
end

function clsTeamMember:GetMyTeam()
	return self._mTeam
end

function clsTeamMember:IsInTeam(oTeam)
	assert(oTeam)
	return self._mTeam == oTeam
end

-- 申请入队
function clsTeamMember:AddToTeam(oTeam)
	assert(not self._mTeam, "已经在队伍中: "..self._mTeam:GetUid())
	oTeam:AddMember(self)
end

-- 申请离队
function clsTeamMember:RemoveFromTeam()
	if self._mTeam then
		self._mTeam:RemoveMember(self)
	end
end

-- 成功加入某队时回调
function clsTeamMember:OnAddtoTeam(oTeam)
	self._mTeam = oTeam
end

-- 成功离开某队时回调
function clsTeamMember:OnRemoveFromTeam()
	self._mTeam = nil
end

-----------------------
function clsTeamMember:GetPartnerTeamList()
	return self._mTeam and self._mTeam:GetPartnerList()
end

function clsTeamMember:GetPartnerTeamCount()
	return table.size(self:GetPartnerTeamList())
end

function clsTeamMember:GetTeammateCount()
	local partner_teams = self:GetPartnerTeamList()
	if not partner_teams then return 0 end
	
	local count = 0
	for _, team in pairs(partner_teams) do
		local memberList = team:GetMemberList() or {}
		for obj, _ in pairs(memberList) do
			count = count + 1 
		end
	end
	return count
end

function clsTeamMember:GetEnemyTeamList()
	return self._mTeam and self._mTeam:GetEnemyList()
end

function clsTeamMember:GetEnemyTeamCount()
	return table.size(self:GetEnemyTeamList())
end

function clsTeamMember:GetEnemyCount()
	local enemy_teams = self:GetEnemyTeamList()
	if not enemy_teams then return 0 end
	
	local count = 0
	for _, team in pairs(enemy_teams) do
		count = count + team:GetMemberCount()
	end
	return count
end
