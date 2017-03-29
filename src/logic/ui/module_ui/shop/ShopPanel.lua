------------------
-- 商店界面
------------------
module("ui", package.seeall)

clsShopPanel = class("clsShopPanel", clsCommonFrame)

function clsShopPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_shop/shop_panel.lua", "商店")
	
	--
	local radioButtonGroup = ccui.RadioButtonGroup:create()
	self:addChild(radioButtonGroup)
	radioButtonGroup:addEventListener(function(radioButton, index, iType)
		local ShopId = index + 1
		self:Turn2Shop(ShopId)
	end)
	for i = 1, 5 do
		radioButtonGroup:addRadioButton(self:GetCompByName("btn_chanel_"..i))
	end
	
	self:InitGoodsList()
	radioButtonGroup:setSelectedButton(0)
end

function clsShopPanel:dtor()
	
end

function clsShopPanel:InitGoodsList()
	if self.mCompList then return self.mCompList end
	local funcCreator = function(CellObj)
		local btn = clsWindow.new(nil, "src/data/uiconfigs/ui_shop/shop_cell.lua")
	    utils.RegButtonEvent(btn, function()
			self.mCompList:SetSelectCell(CellObj)
		end)
		return btn
	end
	local funcRefresher = function(GridComp, GridObj)
		local GoodsInfo = GridObj:GetCellData() or {}
		GridComp:GetCompByName("item_wnd"):SetItemType(GoodsInfo.ItemType)
		GridComp:GetCompByName("item_wnd"):SetItemAmountEx(GoodsInfo.Amount, GoodsInfo.MaxAmount)
		GridComp:GetCompByName("item_wnd"):SetTipsEnable(true)
		GridComp:GetCompByName("sprsellout"):setVisible(GoodsInfo.Amount <= 0)
		GridComp:GetCompByName("label_name"):setString(setting.T_item_cfg[GoodsInfo.ItemType].sName)
	end
	self.mCompList = clsCompGrid.new(self:GetCompByName("listwnd"), 5, 2, 370, 128, 370*2+12, 420)
	self.mCompList:SetCellCreator(funcCreator)
	self.mCompList:SetCellRefresher(funcRefresher)
	local compList = self.mCompList
	compList:setPosition(6,6)
	
	self.mCompList:AddListener(self, "ec_click_cell", function(CellObj)
		print("clicked", self.mCompList:GetSelectedPos())
	end)
	
	return self.mCompList
end

function clsShopPanel:Turn2Shop(ShopId)
	local InstShopMgr = KE_Director:GetShopMgr()
	local GoodsList = InstShopMgr:GetShopData(ShopId)
	
	local compList = self.mCompList
	compList:RemoveAll()
	
	self:DestroyTimer("ddddd")
	self:CreateTimerDelay("ddddd", 1, function()
		for i=1, 10 do
			local r,c = compList:ForceGetFirstEmptyPos()
			compList:AddSlot(r,c, GoodsList[i])
		end
		compList:ForceReLayout()
	end)
end
