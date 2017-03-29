----------------------
-- 群组
----------------------
clsPhysGroup = class("clsPhysGroup", clsIGroup)

function clsPhysGroup:ctor(id)
	clsIGroup.ctor(self, id)
	self.tMemberList = new_weak_table("k")	--成员列表
end

function clsPhysGroup:dtor()
	
end

function clsPhysGroup:OnAddMember(obj)
	obj:OnAddtoPhysGroup(self)
end

function clsPhysGroup:OnRemoveMember(obj)
	obj:OnRemoveFromPhysGroup(self)
end
