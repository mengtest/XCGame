----------------
-- 商店管理器
----------------
clsShopManager = class("clsShopManager", clsCoreObject)
clsShopManager.__is_singleton = true

function clsShopManager:ctor()
	clsCoreObject.ctor(self)
	self.tShopList = {}
end

function clsShopManager:dtor()
	self.tShopList = nil
end

-- GoodsInfo = { GoodsId, ItemType, Amount, MaxAmount }
function clsShopManager:ResetShop(ShopId, GoodsList)
	self.tShopList[ShopId] = GoodsList
end

function clsShopManager:GetShopData(ShopId)
	self.tShopList[ShopId] = self.tShopList[ShopId] or {}
	
	if not self.all_item_types then
		self.all_item_types = {}
		for itemtype, _ in pairs(setting.T_item_cfg) do
			table.insert(self.all_item_types, itemtype)
		end
	end
	if table.is_empty(self.tShopList[ShopId]) then
		for i=1, 12 do
			local GoodsInfo = { 
				GoodsId = i, 
				ItemType = self.all_item_types[ math.random(1,#self.all_item_types) ], 
				Amount = math.random(0,5), 
				MaxAmount = 5, 
			}
			table.insert(self.tShopList[ShopId], GoodsInfo)
		end
	end
	
	return self.tShopList[ShopId]
end

function clsShopManager:BuyGoods(GoodsId, Cnt)
	local GoodsInfo = self:GetGoodsInfo(GoodsId)
	GoodsInfo.SelledCnt = GoodsInfo.SelledCnt + Cnt
end

function clsShopManager:GetGoodsInfo(GoodsId)
	for ShopId, GoodsList in pairs(self.tShopList) do
		for idx, GoodsInfo in ipairs(GoodsList) do
			if GoodsInfo.Uid == GoodsId then
				return GoodsInfo
			end
		end
	end
end

