---------------
-- ø®≈∆π‹¿Ì∆˜
---------------
clsCardManager = class("clsCardManager", clsCoreObject)
clsCardManager.__is_singleton = true

function clsCardManager:ctor()
	clsCoreObject.ctor(self)
	self.tRecruitCards = {}
end

function clsCardManager:dtor()
	
end

function clsCardManager:GetCardKeyByUid(CardUid)
	for CardKey, Uid in pairs(self.tRecruitCards) do
		if Uid == CardUid then return CardKey end
	end
end

function clsCardManager:RecruitCard(CardKey, Uid)
	assert(Uid and CardKey)
	self.tRecruitCards[CardKey] = Uid
end

function clsCardManager:UnRecruitCard(Uid)
	local CardKey = self:GetCardKeyByUid(Uid)
	self.tRecruitCards[CardKey] = nil
end

function clsCardManager:CanRecruitCard(CardKey)
	if self.tRecruitCards[CardKey] then return false end
	local CondList = setting.T_card_cfg[CardKey].Condition
	return api.CheckConditions(CondList)
end

function clsCardManager:CanEvolveCard(Uid)
	local CardKey = self:GetCardKeyByUid(Uid)
	if not self.tRecruitCards[CardKey] then return false end
	return true
end

function clsCardManager:HasCanRecruitCard()
	local T_card_general = setting.GetCardGeneralCfg()
	for CardKey, _ in pairs(T_card_general) do
		if self:CanRecruitCard(CardKey) then return true end
	end
	return false
end

function clsCardManager:HasCanEvolveCard()
	for CardKey, Uid in pairs(self.tRecruitCards) do
		if self:CanEvolveCard(Uid) then return true end
	end
	return false 
end
