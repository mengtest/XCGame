--------------
-- 
--------------
local clsIGroupMember = class("clsIGroupMember")

function clsIGroupMember:ctor()
	self._mGroup = nil
end

function clsIGroupMember:dtor()
	self:RemoveFromGroup()
end

function clsIGroupMember:GetMyGroupID()
	return self._mGroup and self._mGroup:GetUid() or nil
end

function clsIGroupMember:GetMyGroup()
	return self._mGroup
end

function clsIGroupMember:IsInGroup(grp)
	assert(grp)
	return self._mGroup == grp
end

-- 申请加入某群组
function clsIGroupMember:AddToGroup(grp)
	grp:AddMember(self)
end

-- 申请从某群组离开
function clsIGroupMember:RemoveFromGroup()
	if self._mGroup then
		self._mGroup:RemoveMember(self)
	end
end

-- 加入某群组成功时回调
function clsIGroupMember:OnAddtoGroup(grp)
	self._mGroup = grp
end

-- 离开某群组成功时回调
function clsIGroupMember:OnRemoveFromGroup()
	self._mGroup = nil
end
