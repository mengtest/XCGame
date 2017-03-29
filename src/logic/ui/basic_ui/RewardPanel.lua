------------------
-- 奖励界面
------------------
module("ui", package.seeall)

clsRewardPanel = class("clsRewardPanel", clsWindow)

function clsRewardPanel:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_publics/reward_panel.lua")
	self:InitListComp()
end

function clsRewardPanel:dtor()
	KE_SafeDelete(self.mCompList)
	self.mCompList = nil
end

function clsRewardPanel:InitListComp()
	if self.mCompList then return self.mCompList end
	
	self.mCompList = clsCompList.new(self, ccui.ScrollViewDir.horizontal, 104*4, 110, 104, 110)
	self.mCompList:setPosition(-104*2,-50-110/2)
	self.mCompList:SetHighLightImgPath(nil)
	self.mCompList:SetCellCreator(function(CellObj)
		local CellData = CellObj:GetCellData()
		local ItemInfo = {
			["ItemType"] = CellData.ItemType,
			["iCount"] = CellData.Count,
		}
		local ItemWnd = clsItemWnd.new()
		ItemWnd:SetItemInfo(ItemInfo)
		ItemWnd:SetTipsEnable(true)
		return ItemWnd
	end)
	
	return self.mCompList
end

local TestBonusList = {
	{ Type = "金币", Count = 10000 },
	{ Type = "钻石", Count = 200 },
	{ Type = "物品", ItemType = 3010002, Count = 5 },
	{ Type = "物品", ItemType = 2001005, Count = 3 },
	{ Type = "物品", ItemType = 1010103, Count = 1 },
	{ Type = "物品", ItemType = 2001014, Count = 1 },
	{ Type = "卡牌", CardType = 3020001 },
}
function clsRewardPanel:SetBonusList(BonusList)
	BonusList = BonusList or TestBonusList
	
	self.mCompList:RemoveAll()
	
	for _, info in ipairs(BonusList) do
		if info.Type == "金币" then
			self:GetCompByName("LabelMoney"):setString("金币："..info.Count)
		elseif info.Type == "钻石" then
			self:GetCompByName("LabelDiamond"):setString("钻石："..info.Count)
		elseif info.Type == "物品" then
			self.mCompList:Insert(info)
		elseif info.Type == "卡牌" then
			
		end
	end
	
	self.mCompList:ForceReLayout()
end
