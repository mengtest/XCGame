----------------
-- 物品协议
----------------
module("rpc", package.seeall)

c_item_list = function(ItemInfoList)
	for _, ItemInfo in pairs(ItemInfoList) do
		KE_Director:GetItemMgr():AddItem(ItemInfo.ItemId, ItemInfo)
	end
end

c_add_item = function(ItemId, ItemInfo)
	KE_Director:GetItemMgr():AddItem(ItemId, ItemInfo)
end

c_del_item = function(ItemId)
	KE_Director:GetItemMgr():DelItem(ItemId)
end

c_item_amount = function(ItemId, Amount)
	local newInfo = {iCount=Amount}
	KE_Director:GetItemMgr():UpdateItem(ItemId, newInfo)
end
