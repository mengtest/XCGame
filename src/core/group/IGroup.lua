----------------------
-- 群组
----------------------
clsIGroup = class("clsIGroup")

function clsIGroup:ctor(id)
	assert(id, "ERROR: no clsIGroup id")
	self.Uid = id
	
	self.tMemberList = new_weak_table("k")	--成员列表
	self.tPartnerList = {}	--好友列表
	self.tEnemyList = {}	--敌人列表
end

function clsIGroup:dtor()
	self:ClearMemberList()
	self:ClearAllPartners()
	self:ClearAllEnemys()
end

function clsIGroup:GetUid()
	return self.Uid
end

-------------------------------------------------------

function clsIGroup:GetMemberList()
	return self.tMemberList
end

function clsIGroup:HasMember(obj)
	return self.tMemberList[obj]
end

function clsIGroup:GetMemberById(iMemberId)
	for obj, _ in pairs(self.tMemberList) do
		if obj:GetUid() == iMemberId then 
			return obj 
		end
	end
	return nil
end

function clsIGroup:GetMemberCount()
	return table.size(self.tMemberList)
end

function clsIGroup:ClearMemberList()
	for obj, _ in pairs(self.tMemberList) do
		self:OnRemoveMember(obj)	--【NOTE:】 从群组移除时回调
	end
	self.tMemberList = new_weak_table("v")
end

function clsIGroup:AddMember(obj)
	if self.tMemberList[obj] then
		print("ERROR: 已经添加过该成员", obj)
		return
	end
	self.tMemberList[obj] = true
	self:OnAddMember(obj)			--【NOTE:】 成功添加进了群组时回调
end

function clsIGroup:RemoveMember(member)
	if self.tMemberList[member] then
		self:OnRemoveMember(member)	--【NOTE:】 从群组移除时回调
		self.tMemberList[member] = nil
	end
end

--@need override
function clsIGroup:OnAddMember(obj)
	assert(false, "you should override me")
end

--@need override
function clsIGroup:OnRemoveMember(obj)
	assert(false, "you should override me")
end

-------------------------------------------------------

function clsIGroup:GetPartnerList()
	return self.tPartnerList or {}
end

function clsIGroup:ClearAllPartners()
	for _, grp in pairs(self.tPartnerList) do
		grp.tPartnerList[self.Uid] = nil
	end
	self.tPartnerList = {}
end

function clsIGroup:GetPartner(partner_id)
	return self.tPartnerList[partner_id]
end

function clsIGroup:AddPartner(grp)
	if not grp then return end
	local partner_id = grp:GetUid()
	
	if grp==self or partner_id==self.Uid then
		log_error("ERROR: self add self", partner_id, self.Uid)
		return
	end
	
	self:RemoveEnemy(grp)
	grp.tPartnerList[self.Uid] = self
	self.tPartnerList[partner_id] = grp
end

function clsIGroup:RemovePartner(partner)
	if not partner then return end
	
	local id = is_number(partner) and partner or partner:GetUid()
	local grp = self.tPartnerList[id]
	if grp then grp.tPartnerList[self.Uid] = nil end
	self.tPartnerList[id] = nil
end

-------------------------------------------------------

function clsIGroup:GetEnemyList()
	return self.tEnemyList
end

function clsIGroup:ClearAllEnemys()
	for _, grp in pairs(self.tEnemyList) do
		grp.tEnemyList[self.Uid] = nil
	end
	self.tEnemyList = {}
end

function clsIGroup:GetEnemy(enemy_id)
	return self.tEnemyList[enemy_id]
end

function clsIGroup:AddEnemy(grp)
	if not grp then return end
	local enemy_id = grp:GetUid()
	
	if grp==self or enemy_id==self.Uid then
		log_error("ERROR: self add self", enemy_id, self.Uid)
		return
	end
	
	self:RemovePartner(grp)
	grp.tEnemyList[self.Uid] = self
	self.tEnemyList[enemy_id] = grp
end

function clsIGroup:RemoveEnemy(enemy)
	if not enemy then return end
	
	local id = is_number(enemy) and enemy or enemy:GetUid()
	local grp = self.tEnemyList[id]
	if grp then grp.tEnemyList[self.Uid] = nil end
	self.tEnemyList[id] = nil
end

