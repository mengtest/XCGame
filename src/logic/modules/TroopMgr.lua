----------------
-- 军队管理器
----------------

-- MemberList = { {30101,34}, {30102,44}, {30103,63}, }
local clsTroopData = class("clsTroopData", clsDataFace)

clsTroopData:RegSaveVar("Uid", TYPE_CHECKER.INT)
clsTroopData:RegSaveVar("TroopType", function(v) assert(utils.IsValidTroopType(v),"not valid TroopType: "..v) end)
clsTroopData:RegSaveVar("LeaderId", TYPE_CHECKER.INT_NIL)
clsTroopData:RegSaveVar("MemberList", TYPE_CHECKER.TABLE)

function clsTroopData:ctor(Uid, TroopType)
	clsDataFace.ctor(self)
	self:SetUid(Uid)
	self:SetTroopType(TroopType)
end

function clsTroopData:dtor()
	
end

------------------------------------------------------------

clsTroopManager = class("clsTroopManager", clsCoreObject)
clsTroopManager.__is_singleton = true

function clsTroopManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllGeneralTroop = {}		--将领率军
	self.tAllCityTroop = {}			--城市守军
	self.tAllSlaveTroop = {}		--乱军
	
	self.tAllTroopById = new_weak_table("kv")
	self.tCityTroopByLeader = new_weak_table("kv")
	self.tGeneralTroopByLeader = new_weak_table("kv")
end

function clsTroopManager:dtor()
	for _, TroopData in pairs(self.tAllCityTroop) do KE_SafeDelete(TroopData) end
	self.tAllCityTroop = {}
	
	for _, TroopData in pairs(self.tAllGeneralTroop) do KE_SafeDelete(TroopData) end
	self.tAllGeneralTroop = {}
	
	for _, TroopData in pairs(self.tAllSlaveTroop) do KE_SafeDelete(TroopData) end
	self.tAllSlaveTroop = {}
	
	self.tAllTroopById = new_weak_table("kv")
	self.tCityTroopByLeader = new_weak_table("kv")
	self.tGeneralTroopByLeader = new_weak_table("kv")
end

------------
function clsTroopManager:UpdateCityTroop(Id, Info)
	Info.TroopType = const.TROOP_CITY
	self.tAllCityTroop[Id] = self.tAllCityTroop[Id] or clsTroopData.new(Id, Info.TroopType)
	self.tAllCityTroop[Id]:BatchSetAttr(Info)
	
	self.tAllTroopById[Id] = self.tAllCityTroop[Id]
	self.tCityTroopByLeader[self.tAllTroopById[Id]:GetLeaderId()] = self.tAllTroopById[Id]
end

function clsTroopManager:UpdateGeneralTroop(Id, Info)
	Info.TroopType = const.TROOP_GENERAL
	self.tAllGeneralTroop[Id] = self.tAllGeneralTroop[Id] or clsTroopData.new(Id, Info.TroopType)
	self.tAllGeneralTroop[Id]:BatchSetAttr(Info)
	
	self.tAllTroopById[Id] = self.tAllGeneralTroop[Id]
	self.tGeneralTroopByLeader[self.tAllTroopById[Id]:GetLeaderId()] = self.tAllTroopById[Id]
end

function clsTroopManager:UpdateSlaveTroop(Id, Info)
	Info.TroopType = const.TROOP_SLAVE
	self.tAllSlaveTroop[Id] = self.tAllSlaveTroop[Id] or clsTroopData.new(Id, Info.TroopType)
	self.tAllSlaveTroop[Id]:BatchSetAttr(Info)
	
	self.tAllTroopById[Id] = self.tAllSlaveTroop[Id]
end

------------
function clsTroopManager:DelSlaveTroop(Id)
	if self.tAllSlaveTroop[Id] then
		KE_SafeDelete(self.tAllSlaveTroop[Id])
		self.tAllSlaveTroop[Id] = nil
		self.tAllTroopById[Id] = nil
	end
end

------------
function clsTroopManager:GetCityTroop(Id)
	return self.tAllCityTroop[Id]
end

function clsTroopManager:GetGeneralTroop(Id)
	return self.tAllGeneralTroop[Id]
end

function clsTroopManager:GetSlaveTroop(Id)
	return self.tAllSlaveTroop[Id]
end

function clsTroopManager:GetTroopById(Id)
	return self.tAllTroopById[Id] 
end

function clsTroopManager:GetCityTroopByLeader(LeaderId)
	return self.tCityTroopByLeader[LeaderId] 
end

function clsTroopManager:GetGeneralTroopByLeader(LeaderId)
	return self.tGeneralTroopByLeader[LeaderId]
end
