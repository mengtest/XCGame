-----------
-- 背包
-----------
module("ui", package.seeall)

clsBagPanel = class("clsBagPanel", clsCommonFrame)

function clsBagPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_bag/bag_panel.lua", "背包")
	
	self.mItemDetail = clsItemDetailWnd.new(self)
	self.mItemDetail:setPosition(250,260)
	self:InitItemList()
end

function clsBagPanel:dtor()
	local InstItemMgr = KE_Director:GetItemMgr()
	InstItemMgr:DelListener(self)
	
	if self.mItemFrame then
		KE_SafeDelete(self.mItemFrame)
		self.mItemFrame = nil 
	end
	if self.mItemList then
		KE_SafeDelete(self.mItemList)
		self.mItemList = nil
	end
	if self.mItemDetail then
		KE_SafeDelete(self.mItemDetail)
		self.mItemDetail = nil
	end
end

function clsBagPanel:InitItemList()
	local funcCreator = function(CellObj)
		local item_wnd = clsItemWnd.new()
		item_wnd:AddListener("select_item", const.CORE_EVENT.ec_touch_ended, function(itemwnd)
			if itemwnd:IsEmpty() then return end
			self.mItemList:SetSelectCell(CellObj)
		end)
		return item_wnd
	end
	local funcRefresher = function(GridComp, CellObj)
		local CellData = CellObj and CellObj:GetCellData()
		GridComp:SetItemInfo(CellData)
		GridComp:SetHighLight(CellObj and CellObj:IsSelected())
	end
	self.mItemList = clsItemList.new(self, 5, 5)
	self.mItemList:SetCellCreator(funcCreator)
	self.mItemList:SetCellRefresher(funcRefresher)
	local FrameSize = self.mItemList:getContentSize()
	self.mItemList:setPosition(510, 10)
	self.mItemList.HighLightSelectComp = function(this, CellComp, bHighLight)
		if not CellComp then return end
		CellComp:SetHighLight(bHighLight)
	end
	self.mItemList:AddListener("bag_select_item", "ec_click_cell", function(CellObj)
		local CellData = CellObj:GetCellData()
		self.mItemDetail:SetItemId(CellData.ItemId)
		self.mItemDetail:SetItemType(CellData.ItemType)
	end)
	
	--
	local allitems = KE_Director:GetItemMgr():GetAllItems()
	local itemlist = {}
	for _, ItemData in pairs(allitems) do
		itemlist[#itemlist+1] = ItemData
	end
	KE_Director:GetItemMgr():SortItemList(itemlist)
	
	for _, ItemData in ipairs(itemlist) do
		local ItemInfo = {
			ItemId = ItemData:GetItemId(),
			ItemType = ItemData:GetItemType(),
			iCount = ItemData:GetiCount(),
		}
		self.mItemList:AddItem(ItemInfo)
	end
	
	self.mItemList:ForceReLayout()
	self.mItemList:SetSelectedPos( 1,1 )
	
	--
	local InstItemMgr = KE_Director:GetItemMgr()
	InstItemMgr:AddListener(self, "add_item", function(ItemId, ItemData)
		local ItemInfo = {
			ItemId = ItemId,
			ItemType = ItemData:GetItemType(),
			iCount = ItemData:GetiCount(),
		}
		self.mItemList:AddItem(ItemInfo)
	end)
	InstItemMgr:AddListener(self, "del_item", function(ItemId)
		self.mItemList:DelItemById(ItemId)
	end)
	InstItemMgr:AddListener(self, "update_item", function(ItemId, NewInfo)
		local ItemData = InstItemMgr:GetItem(ItemId)
		local ItemInfo = {
			ItemId = ItemId,
			ItemType = ItemData:GetItemType(),
			iCount = ItemData:GetiCount(),
		}
		self.mItemList:UpdateItem(ItemInfo)
	end)
end
