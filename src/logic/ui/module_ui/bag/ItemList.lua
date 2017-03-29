------------------
-- 物品list控件
------------------
module("ui", package.seeall)

clsItemList = class("clsItemList", clsCompGrid)

function clsItemList:ctor(parent, RowCount, ColCount)
	clsCompGrid.ctor(self, parent, RowCount, ColCount)
end

function clsItemList:dtor()
	
end

function clsItemList:AddItem(ItemInfo)
	if ItemInfo.ItemId and self:GetCellById(ItemInfo.ItemId) then
		assert(false, "已经添加了该物品")
	end
	
	local r,c = self:GetFirstEmptyPos()
	if not r then 
		self:Expand() 
		r, c = self:GetFirstEmptyPos()
	end
	self:AddSlot(r,c,ItemInfo,ItemInfo.ItemId)
end

function clsItemList:DelItemById(ItemId)
	self:UpdateSlotDataById(ItemId, nil)
end

function clsItemList:UpdateItem(ItemInfo)
	self:UpdateSlotDataById(ItemInfo.ItemId, ItemInfo)
end
