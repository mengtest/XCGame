-------------------
-- 物品管理器
-------------------
local clsItemData = class("clsItemData", clsDataFace)

clsItemData:RegSaveVar("ItemId", TYPE_CHECKER.INT)
clsItemData:RegSaveVar("ItemType", TYPE_CHECKER.INT)
clsItemData:RegSaveVar("iCount", TYPE_CHECKER.INT)

function clsItemData:ctor(ItemId, ItemType, Count)
	clsDataFace.ctor(self)
	self:SetItemId(ItemId)
	self:SetItemType(ItemType)
	self:SetiCount(Count)
end

function clsItemData:dtor()

end

function clsItemData:GetItemCfg()
	return setting.T_item_cfg[self:GetItemType()]
end

------------------------------------------------------------

clsItemManager = class("clsItemManager", clsCoreObject)
clsItemManager.__is_singleton = true

clsItemManager:RegisterEventType("add_item")
clsItemManager:RegisterEventType("del_item")
clsItemManager:RegisterEventType("update_item")

function clsItemManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllItems = {}								--根据ItemId索引物品
	self.tItemsByKind = {}							--根据物品分类索引物品
	self.tItemsByType = new_weak_table("kv")		--根据物品类型索引物品
end

function clsItemManager:dtor()
	self.tItemsByKind = nil
	self.tAllItems = nil
	self.tItemsByType = nil
end

function clsItemManager:AddItem(ItemId, ItemInfo)
	assert(not self.tAllItems[ItemId], "重复添加相同物品: "..ItemId)
	if ItemInfo.ItemId then assert(ItemInfo.ItemId == ItemId) end
	
	local ItemType = ItemInfo.ItemType
	
	ItemInfo.ItemId = ItemId
	self.tAllItems[ItemId] = self.tAllItems[ItemId] or clsItemData.new(ItemId, ItemInfo.ItemType, ItemInfo.iCount)
	self.tAllItems[ItemId]:BatchSetAttr(ItemInfo)
	self.tItemsByType[ItemType] = self.tAllItems[ItemId]
	local item_kind = setting.T_item_cfg[ItemInfo.ItemType].ItemKind
	self.tItemsByKind[item_kind] = self.tItemsByKind[item_kind] or new_weak_table("v")
	self.tItemsByKind[item_kind][ItemId] = self.tAllItems[ItemId]
	self:FireEvent("add_item", ItemId, self.tAllItems[ItemId])
end

function clsItemManager:DelItem(ItemId)
	if not self.tAllItems[ItemId] then
		log_error("删除不存在的物品", ItemId)
		return
	end
	
	local ItemType = self.tAllItems[ItemId]:GetItemType()
	KE_SafeDelete(self.tAllItems[ItemId])
	self.tAllItems[ItemId] = nil
	self.tItemsByType[ItemType] = nil
	local item_kind = setting.T_item_cfg[ItemType].ItemKind
	self.tItemsByKind[item_kind][ItemId] = nil
	self:FireEvent("del_item", ItemId)
end

function clsItemManager:UpdateItem(ItemId, newInfo)
	if newInfo.ItemId then assert(newInfo.ItemId == ItemId) end
	if not self.tAllItems[ItemId] then 
		assert(false, "更新不存在的物品: "..ItemId)
		return 
	end
	
	if newInfo.iCount <= 0 then
		self:DelItem(ItemId) 
		return
	end
	
	self.tAllItems[ItemId]:BatchSetAttr(newInfo)
	newInfo.ItemId = ItemId
	self:FireEvent("update_item", ItemId, newInfo)
end

--------------------------- getter ------------------------------

function clsItemManager:SortItemList(itemlist)
	assert(table.is_array(itemlist))
	table.sort(itemlist, function(ItemData1, ItemData2)
		local type1, type2 = ItemData1:GetItemType(), ItemData2:GetItemType()
		local kind1, kind2 = setting.GetItemKind(type1), setting.GetItemKind(type2)
		
		if kind1 == kind2 then
			return type1 > type2
		else
			return const.ITEMKIND_CMP[kind1] < const.ITEMKIND_CMP[kind2]
		end
	end)
	return itemlist
end

function clsItemManager:GetAllItems()
	return self.tAllItems
end

function clsItemManager:GetItemsWithFilter(filterFunc)
	local itemlist = {}
	for ItemId, ItemData in pairs(self.tAllItems) do
		if filterFunc(ItemData) then
			itemlist[#itemlist+1] = ItemData
		end
	end
	return itemlist
end

function clsItemManager:GetItem(ItemId)
	return ItemId and self.tAllItems[ItemId]
end

function clsItemManager:GetItemsByKind(item_kind)
	return self.tItemsByKind[item_kind]
end

function clsItemManager:GetItemByType(ItemType)
	return self.tItemsByType[ItemType]
end

function clsItemManager:GetItemAmountByType(ItemType)
	local ItemData = self.tItemsByType[ItemType]
	return ItemData and ItemData:GetiCount() or 0
end

function clsItemManager:GetItemAmountById(ItemId)
	return self.tAllItems[ItemId] and self.tAllItems[ItemId]:GetiCount() or 0
end

function clsItemManager:GetItemAmountByName(ItemName)
	local ItemInfo = setting.GetItemCfgByName(ItemName)
	local ItemType = ItemInfo and ItemInfo.ItemType
	return self:GetItemAmountByType(ItemType)
end
