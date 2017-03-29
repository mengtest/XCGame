----------------
-- 行为树工厂
----------------
module("ai",package.seeall)

ClsBTFactory = class("ClsBTFactory")

function ClsBTFactory:ctor()
	self.tAllBT = {}
	self.tBTTreeSet = new_weak_table("k")
	--
	self:_InitBT("bt_hero_fight")
	self:_InitBT("bt_monster_fight")
	self:_InitBT("bt_attack")
	self:_InitBT("bt_runto")
	self:_InitBT("bt_walkto")
	self:_InitBT("bt_rushto")
	self:_InitBT("bt_attack_1")
	self:_InitBT("bt_attack_2")
	self:_InitBT("bt_attack_3")
	self:_InitBT("bt_attack_4")
	self:_InitBT("bt_attack_5")
	self:_InitBT("bt_attack_6")
	self:_InitBT("bt_attack_7")
end

function ClsBTFactory:dtor()
	for _, AiObj in pairs(self.tAllBT) do
		KE_SafeDelete(AiObj)
	end
	self.tAllBT = {}
	self.tBTTreeSet = nil
end

function ClsBTFactory:_InitBT(bt_name)
	local objBT = ai[bt_name].GetInstance()
	self.tAllBT[bt_name] = objBT
	self.tBTTreeSet[objBT] = bt_name
	assert(bt_name==objBT.__cname, "bt的命名须与其对应的类名一致")
end

function ClsBTFactory:GetBT(bt_name)
	assert(self.tAllBT[bt_name], "未定义的AI："..bt_name)
	return self.tAllBT[bt_name]
end

function ClsBTFactory:GetBtName(objBT)
	return self.tBTTreeSet[objBT]
end

function ClsBTFactory:HasBT(objBT)
	return self.tBTTreeSet[objBT] ~= nil
end
