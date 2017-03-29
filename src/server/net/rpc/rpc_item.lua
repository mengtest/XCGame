module("server", package.seeall)

s_use_item = function(UserId, ItemId, Count)
	if not ClsSerDataMgr.GetInstance()._ItemList[ItemId] then
		server.c_tell_fail("要使用的物品不存在")
		return 
	end
	if ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount <= 0 then
		assert(false, "数据出错，物品数量居然小于零")
		server.c_tell_fail("数据出错，物品数量居然小于零")
		return 
	end
	
	local curCount = ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount - Count
	ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount = curCount
	
	if curCount > 0 then
		server.c_item_amount(ItemId, curCount)
	else
		ClsSerDataMgr.GetInstance()._ItemList[ItemId] = nil
		server.c_del_item(ItemId)
	end
	
	ClsSerDataMgr.GetInstance():SaveItemList()
end

s_sell_item = function(UserId, ItemId, Count)
	if not ClsSerDataMgr.GetInstance()._ItemList[ItemId] then
		server.c_tell_fail("要使用的物品不存在")
		return 
	end
	if ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount <= 0 then
		assert(false, "数据出错，数量小于零")
		server.c_tell_fail("数据出错，物品数量居然小于零")
		return 
	end
	
	local curCount = ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount - Count
	ClsSerDataMgr.GetInstance()._ItemList[ItemId].iCount = curCount
	
	if curCount > 0 then
		server.c_item_amount(ItemId, curCount)
	else
		ClsSerDataMgr.GetInstance()._ItemList[ItemId] = nil
		server.c_del_item(ItemId)
	end
	
	ClsSerDataMgr.GetInstance():SaveItemList()
end
