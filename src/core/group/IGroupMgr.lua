------------------------
-- 
------------------------
clsIGroupMgr = class("clsIGroupMgr", clsCoreObject)

function clsIGroupMgr:ctor()
	clsCoreObject.ctor(self)
	
	self.tAllGroups = {}
end

function clsIGroupMgr:dtor()
	self:DoCleanup()
end

function clsIGroupMgr:DoCleanup()
	for grpID, grp in pairs(self.tAllGroups) do
		KE_SafeDelete(grp)
	end
	self.tAllGroups = {}
end

--@need override
function clsIGroupMgr:CreateGroup(grp_id)
	assert(false, "you should override me")
--	self.tAllGroups[grp_id] = self.tAllGroups[grp_id] or clsIGroup.new(grp_id)
--	return self.tAllGroups[grp_id]
end

function clsIGroupMgr:RemoveGroup(grp_id)
	if self.tAllGroups[grp_id] then
		KE_SafeDelete(self.tAllGroups[grp_id])
		self.tAllGroups[grp_id] = nil
	end
end

function clsIGroupMgr:GetAllGroups()
	return self.tAllGroups
end

function clsIGroupMgr:GetGroup(grp_id)
	return self.tAllGroups[grp_id]
end

function clsIGroupMgr:HasGroup(grp)
	return self.tAllGroups[grp:GetUid()] and true or false
end


function clsIGroupMgr:SetGroupRelation(grp_1, grp_2, relation)
	local group_1, group_2
	if is_number(grp_1) then group_1 = self:GetGroup(grp_1) else group_1 = grp_1 end
	if is_number(grp_2) then group_2 = self:GetGroup(grp_2) else group_2 = grp_2 end
	if not group_1 or not group_2 then return end
	if group_1 == group_2 then return end
	
	if relation == const.RELATION_ENEMY then
		group_1:AddEnemy(group_2)
	elseif relation == const.RELATION_PARTNER then
		group_1:AddPartner(group_2)
	elseif relation == const.RELATION_NONE then
		group_1:RemovePartner(group_2)
		group_1:RemoveEnemy(group_2)
	else 
		assert(false, "²ÎÊý´íÎó: "..relation)
	end
end

function clsIGroupMgr:SetToPartner(grp_1, grp_2)
	self:SetGroupRelation(grp_1, grp_2, const.RELATION_PARTNER)
end

function clsIGroupMgr:SetToEnemy(grp_1, grp_2)
	self:SetGroupRelation(grp_1, grp_2, const.RELATION_ENEMY)
end

