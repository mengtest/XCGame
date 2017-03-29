----------------
-- 装备管理器
----------------
local clsEquipData = class("clsEquipData", clsDataFace)

clsEquipData:RegSaveVar("Uid", TYPE_CHECKER.INT)
clsEquipData:RegSaveVar("ItemType", TYPE_CHECKER.INT)
clsEquipData:RegSaveVar("EquipIndex", TYPE_CHECKER.INT)
clsEquipData:RegSaveVar("Level", TYPE_CHECKER.INT)
clsEquipData:RegSaveVar("StarLvl", TYPE_CHECKER.INT)
clsEquipData:RegSaveVar("OwnerId", TYPE_CHECKER.INT)

function clsEquipData:ctor(Uid, ItemType, EquipIndex)
	clsDataFace.ctor(self)
	self:SetUid(Uid)
	self:SetItemType(ItemType)
	self:SetEquipIndex(EquipIndex)
end

function clsEquipData:dtor()

end

------------------------------------------------------------

clsEquipManager = class("clsEquipManager", clsCoreObject)
clsEquipManager.__is_singleton = true

function clsEquipManager:ctor()
	clsCoreObject.ctor(self)
	self.tEquipDataList = {}
end

function clsEquipManager:dtor()
	
end

function clsEquipManager:AddEquip(Uid, DataInfo)	
	
end

function clsEquipManager:DelEquip(Uid)

end
