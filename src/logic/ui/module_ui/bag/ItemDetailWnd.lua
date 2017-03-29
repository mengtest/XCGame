module("ui", package.seeall)

clsItemDetailWnd = class("clsItemDetailWnd", clsWindow)

function clsItemDetailWnd:ctor(parent, RowCount, ColCount, xInterval, yInterval)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_bag/item_detail_wnd.lua")
	
	self._ItemId = nil
	self._ItemType = nil
	
	utils.RegButtonEvent(self:GetCompByName("btn_use"), function()
		if KE_Director:GetItemMgr():GetItem(self._ItemId) then
			network.SendPro("s_use_item", nil, self._ItemId, 1)
		else
			utils.TellMe("该物品已经被删除")
		end
	end)
	utils.RegButtonEvent(self:GetCompByName("btn_sell"), function()
		if KE_Director:GetItemMgr():GetItem(self._ItemId) then
			network.SendPro("s_sell_item", nil, self._ItemId, 1)
		else
			utils.TellMe("该物品已经被删除")
		end
	end)
end

function clsItemDetailWnd:dtor()
	if self.mItemFrame then
		KE_SafeDelete(self.mItemFrame)
		self.mItemFrame = nil 
	end
end

function clsItemDetailWnd:SetItemType(ItemType)
	self._ItemType = ItemType
	self:GetCompByName("wnd_item"):SetItemType(ItemType)
	
	local ItemCfg = ItemType and setting.T_item_cfg[ItemType] or {}
	
	self:GetCompByName("label_title"):setString(ItemCfg.sName or "")
	self:GetCompByName("label_desc"):setString(ItemCfg.Desc or "")
end

function clsItemDetailWnd:SetItemId(ItemId)
	self._ItemId = ItemId
end
