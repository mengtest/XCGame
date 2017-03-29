------------------
-- 签到界面
------------------
module("ui", package.seeall)

clsSignInPanel = class("clsSignInPanel", clsCommonFrame)

function clsSignInPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_signin/sign_in_panel.lua", "签到")
	
	self:InitItemList()
end

function clsSignInPanel:dtor()
	local InstSignInMgr = KE_Director:GetSignInMgr()
	InstSignInMgr:DelListener(self)
	redpoint.RemoveRedButton(self.mTodayWnd)
	
	if self.mItemFrame then
		KE_SafeDelete(self.mItemFrame)
		self.mItemFrame = nil 
	end
end

local function idx2rc(idx)
	return math.ceil(idx/5), idx%5==0 and 5 or idx%5
end

local function rc2idx(r,c)
	return (r-1) * 5 + c
end

function clsSignInPanel:InitItemList()
	local funcCreator = function(CellObj)
		local item_wnd = clsItemWnd.new()
		item_wnd:AddListener(self, const.CORE_EVENT.ec_touch_ended, function(itemwnd)
			self.mItemList:SetSelectCell(CellObj)
		end)
		return item_wnd
	end
	local funcRefresher = function(GridComp, GridObj)
		local CellData = GridObj:GetCellData()
		GridComp:SetItemInfo(CellData.ItemInfo)
		GridComp:SetLocked(CellData.ItemInfo.iSigned==1)
		
		local r,c = self.mItemList:GetCellPosByCellObj(GridObj) 
		local bHighLight = os.date("*t").day == rc2idx(r,c)
		if bHighLight then
			self.mTodayWnd = GridComp
			GridComp:SetHighLight(true)
			redpoint.RegisterRedButton("red_signin", GridComp)
			guide:RegGuideBtn("签到界面_今日", GridComp)
		end
	end
	self.mItemList = clsItemList.new(self, 5, 5)
	self.mItemList:SetCellCreator(funcCreator)
	self.mItemList:SetCellRefresher(funcRefresher)
	self.mItemList:setPosition(self:getContentSize().width - self.mItemList:getContentSize().width - 5, 10)
	
	--
	local InstSignInMgr = KE_Director:GetSignInMgr()
	local allitems = InstSignInMgr:GetSigninList()
	local today = os.date("*t")
	for idx, info in ipairs(allitems) do
		local CellData = {
			ItemInfo = info,
		}
		self.mItemList:AddItem(CellData)
	end
	
	self.mItemList:ForceReLayout()
	
	--
	self:AddListener("lis_show", const.CORE_EVENT.EC_SHOW, function(bShow)
		if not bShow then return end
	end)
	self.mItemList:AddListener(self, "ec_click_cell", function(CellObj)
		local r, c = self.mItemList:GetCellPosByCellObj( CellObj )
		if not r then return end
		local pos = rc2idx(r,c)
		network.SendPro("s_signin", nil, pos)
	end)
	InstSignInMgr:AddListener(self, "sign_in", function(idx)
		local r,c = idx2rc(idx)
		local GridObj = self.mItemList:GetCellByPos(r,c)
		if not GridObj then return end
		self.mItemList:UpdateSlotDataByPos(r,c,GridObj:GetCellData())
	end)
end
