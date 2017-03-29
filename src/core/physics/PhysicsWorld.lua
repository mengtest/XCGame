------------------------
-- 碰撞检测系统
------------------------

ClsPhysicsWorld = class("ClsPhysicsWorld", clsIGroupMgr)
ClsPhysicsWorld.__is_singleton = true

function ClsPhysicsWorld:ctor()
	clsIGroupMgr.ctor(self)
	self._testing = false
	self:_init_listeners()
end

function ClsPhysicsWorld:dtor()
	g_EventMgr:DelListener(self)
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
end

--@每帧更新
function ClsPhysicsWorld:FrameUpdate(deltaTime)
	self:DoCollisionTest()
end

function ClsPhysicsWorld:_init_listeners()
	--
	g_EventMgr:AddListener(self, "START_COMBAT", function()
		ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_PHYSICS)
	end)
	g_EventMgr:AddListener(self, "END_COMBAT", function()
		ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	end)
	
	--
	g_EventMgr:AddListener(self, "NEW_TEAM", function(team_id, oTeam)
		self:CreateGroup(team_id)
	end)
	g_EventMgr:AddListener(self, "DEL_TEAM", function(team_id)
		self:RemoveGroup(team_id)
	end)
	g_EventMgr:AddListener(self, "TEAM_RELATION_CHG", function(team_1, team_2, relation)
		self:SetGroupRelation(team_1, team_2, relation)
	end)
	g_EventMgr:AddListener(self, "TEAM_ADD_MEMBER", function(team_id, obj)
		self:AddBody(obj, team_id)
	end)
	g_EventMgr:AddListener(self, "TEAM_DEL_MEMBER", function(team_id, obj)
		self:RemoveBody(obj)
	end)
end

--@override
function ClsPhysicsWorld:CreateGroup(grp_id)
	assert(grp_id, "grp_id不可为空")
	self.tAllGroups[grp_id] = self.tAllGroups[grp_id] or clsPhysGroup.new(grp_id)
	return self.tAllGroups[grp_id]
end

function ClsPhysicsWorld:AddBody(obj, grp_id)
	if not obj then return end
	local grp = self:GetGroup(grp_id)
	grp:AddMember(obj)
end

function ClsPhysicsWorld:RemoveBody(body)
	if not body then return end
	for _, grp in pairs(self.tAllGroups) do
		grp:RemoveMember(body)
	end
end

function ClsPhysicsWorld:DumpDebugInfo()
	for grpID, grp in pairs(self.tAllGroups) do
		log_warn(string.format("GroupId=%d  MemberCnt=%d  EnemyCnt=%d  PartnerCnt=%d", 
				grpID, 
				table.size(grp:GetMemberList()), 
				table.size(grp:GetEnemyList()), 
				table.size(grp:GetPartnerList())) )
	end
end


----------------------------
-- 碰撞检测相关
----------------------------
local math_abs = math.abs
local math_min = math.min

local func_table = {
	["Rect"] = {
		["Rect"] 	= math.RectAndRect,
		["Circle"] 	= math.RectAndCircle,
	},
	["Circle"] = {
		["Rect"] 	= math.CircleAndRect,
		["Circle"] 	= math.CircleAndCircle,
	},
}

local function TestAABB(obj1, obj2)
	local disH = (obj1:getPositionY()+obj1:GetPositionH()) - (obj2:getPositionY()+obj2:GetPositionH())
	local minBodyH = disH>0 and obj2:GetBodyHeight() or obj1:GetBodyHeight()
	if math_abs(disH) > minBodyH then
		return false 
	end
	
	local shapeInfo1 = obj1:GetShapeInfo()
	local shapeInfo2 = obj2:GetShapeInfo()
	return func_table[shapeInfo1.sShapeType][shapeInfo2.sShapeType](shapeInfo1.tShapeDesc,shapeInfo2.tShapeDesc)
end

function ClsPhysicsWorld:DoCollisionTest()
	-- before test 
	self._testing = true
	ClsRoleMgr.GetInstance():SetLock(true)
	missile.ClsMissileMgr.GetInstance():SetLock(true)
	
	-- test 
	local checked_list = {}
	
	for _, GroupA in pairs(self.tAllGroups) do
		checked_list[GroupA] = checked_list[GroupA] or {}
		
		local members_1 = GroupA:GetMemberList()
		local enemy_grp_list = GroupA:GetEnemyList() or {}
		
		for _, GroupB in pairs(enemy_grp_list) do
			checked_list[GroupB] = checked_list[GroupB] or {}
			
			if not checked_list[GroupA][GroupB] then
				checked_list[GroupA][GroupB] = true
				checked_list[GroupB][GroupA] = true
				
				local members_2 = GroupB:GetMemberList()
				for obj_1, _ in pairs(members_1) do
					for obj_2, _ in pairs(members_2) do
						if TestAABB(obj_1, obj_2) then
							obj_1:OnCollision(obj_2)
							obj_2:OnCollision(obj_1)
						end
					end
				end
			end
		end
	end
	
	-- after test 
	self._testing = false
	ClsRoleMgr.GetInstance():SetLock(false)
	missile.ClsMissileMgr.GetInstance():SetLock(false)
	
	--
	missile.ClsMissileMgr.GetInstance():ClearDelList()
	ClsRoleMgr.GetInstance():ClearDelList()
end
