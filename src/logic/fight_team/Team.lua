-------------------
-- 战斗分组 FightTeam
-------------------

clsTeam = class("clsTeam", clsIGroup)

function clsTeam:ctor(team_id)
	clsIGroup.ctor(self, team_id)
	self.iLeaderId = nil	--队长ID
end

function clsTeam:dtor()
	KE_KillTimer(self._TmrClearDensestPt)
	self._TmrClearDensestPt = nil
end

--@override
function clsTeam:OnAddMember(obj)
	obj:OnAddtoTeam(self)
	FireGlobalEvent("TEAM_ADD_MEMBER", self:GetUid(), obj)
end

--override
function clsTeam:OnRemoveMember(obj)
	obj:OnRemoveFromTeam(self)
	FireGlobalEvent("TEAM_DEL_MEMBER", self:GetUid(), obj)
end

function clsTeam:SetLeaderId(leader_id)
	assert(self:GetMemberById(leader_id), "ERROR: leader is not team member")
	self.iLeaderId = leader_id
end

function clsTeam:GetLeaderId()
	return self.iLeaderId
end

--找到敌人最密集的区域中心
function clsTeam:FindDensestPoint()
	local enemy_teams = self:GetEnemyList()
	if not enemy_teams then 
		self:MarkDensestPoint(nil)
		return nil 
	end
	
	if self._DensestPoint then return self._DensestPoint end
	
	local retPoint
	local math_floor = math.floor
	local GRID_W,GRID_H = 256,256
	local grid_info = {}
	
	-- 统计各格子人数
	for _, team in pairs(enemy_teams) do
		local memberList = team:GetMemberList() or {}
		for enemy, _ in pairs(memberList) do
			if not enemy:IsDead() then
				local x,y = enemy:getPosition()
				x = math_floor(x/GRID_W)	--用位移运算应该快些
				y = math_floor(y/GRID_H)
				grid_info[x] = grid_info[x] or {}
				grid_info[x][y] = grid_info[x][y] and grid_info[x][y]+1 or 1
			end
		end
	end
	
	-- 找到最密集格子
	local max_grid = {}
	local max_count = 0
	for i, col_list in pairs(grid_info) do
		for j, count in pairs(col_list) do
			if count > max_count then
				max_count = count
				max_grid.x, max_grid.y = i, j
			end
		end
	end
	
	-- 得到最终坐标点
	if max_count > 0 then
		local dstX = max_grid.x*GRID_W + GRID_W/2
		local dstY = max_grid.y*GRID_H + GRID_H/2
		self:MarkDensestPoint({ dstX, dstY })
		return { dstX, dstY }
	end
	
	self:MarkDensestPoint(nil)
	return nil
end

function clsTeam:MarkDensestPoint(Pt)
	self._DensestPoint = Pt
	
	KE_KillTimer(self._TmrClearDensestPt)
	self._TmrClearDensestPt = nil
	
	if Pt then
		self._TmrClearDensestPt = KE_SetTimeout(2, function()
			self._DensestPoint = nil
			self._TmrClearDensestPt = nil
		end)
		
		local PartnerList = self:GetPartnerList()
		for _, Partner in pairs(self.tPartnerList) do
			Partner:MarkDensestPoint(Pt)
		end
	end
end
