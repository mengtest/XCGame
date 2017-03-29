------------------
-- 排行榜界面
------------------
module("ui", package.seeall)

local RANKKEY_2_SPORT = {
	["竞技场排行榜"] = "战力",
	["战力排行榜"] = "战力",
	["等级排行榜"] = "等级",
	["官阶排行榜"] = "官阶",
	["威望排行榜"] = "威望",
	["将领排行榜"] = "战力",
	["消费排行榜"] = "消费总钻石",
}

clsRanklistPanel = class("clsRanklistPanel", clsCommonFrame)

function clsRanklistPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_ranklist/ranklist_panel.lua", "排行榜")
	
	self:InitLeftList()
	self:InitRightList()
--	self.mLeftList:SetSelectCell( self.mLeftList:GetCellByIdx(1) )
end

function clsRanklistPanel:dtor()
	if self.mLeftList then KE_SafeDelete(self.mLeftList) self.mLeftList = nil end
	if self.mRightList then KE_SafeDelete(self.mRightList) self.mRightList = nil end
end

function clsRanklistPanel:InitLeftList()
	if self.mLeftList then return self.mLeftList end
	
	self.mLeftList = clsCompList.new(self, ccui.ScrollViewDir.vertical, 200, 405, 200, 74)
	local compList = self.mLeftList
	compList:setPosition(45,35)
	compList:SetCellRefresher(function(CellComp, CellObj)
		local RankKey = CellObj:GetCellId()
		CellComp:setTitleText(RankKey)
	end)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_tab_unchoose_2.png")
		btn:setScale9Enabled(true)
		btn:setContentSize(200,72)
		return btn
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		self:ShowRank(CellObj:GetCellId())
	end)
	
	--
	local InstRankMgr = KE_Director:GetRankMgr()
	local AllRankList = InstRankMgr:GetAllRanklist()
	for RankKey, _ in pairs(AllRankList) do
		compList:Insert(RankKey, RankKey)
	end
	compList:ForceReLayout()
	
	return compList
end

function clsRanklistPanel:InitRightList()
	if self.mRightList then return self.mRightList end
	
	self.mRightList = clsCompList.new(self, ccui.ScrollViewDir.vertical, 715, 405, 715, 112)
	local compList = self.mRightList
	compList:setPosition(272,35)
	compList:SetCellRefresher(function(CellComp, CellObj)
		local RankInfo = CellObj:GetCellData()
		CellComp:GetCompByName("label_rankidx"):setString(RankInfo.RankIdx)
		CellComp:GetCompByName("label_name"):setString(RankInfo.Name)
		CellComp:GetCompByName("label_level"):setString( string.format("Lv.%d",RankInfo.Level) )
		CellComp:GetCompByName("label_sport"):setString( string.format("%s： %d",RANKKEY_2_SPORT[self._CurRankKey],RankInfo.Sport) )
		local head_wnd = clsHeadWnd.new(CellComp, RankInfo.HeadId, 2)
		head_wnd:setPosition(170,55)
	end)
	compList:SetCellCreator(function(CellObj)
		local btn = clsWindow.new(CellComp, "src/data/uiconfigs/ui_ranklist/rank_cell.lua")
		
		local RankInfo = CellObj:GetCellData()
		local path = RankInfo.RankIdx<=3 and string.format("res/uiface/wnds/rank/rank_%d.png",RankInfo.RankIdx) or "res/uiface/wnds/rank/rank_common.png"
		local spr = cc.Sprite:create(path)
		KE_SetParent(spr, btn:GetCompByName("rankspr"))
	
		return btn
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		local RankInfo = CellObj:GetCellData()
		local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsUserInfoPanel")
		if wnd then wnd:Refresh(RankInfo.Uid) end
	end)
	
	return compList
end

function clsRanklistPanel:SwitchTo(RankKey)
	RankKey = RankKey or "战力排行榜"
	assert(KE_Director:GetRankMgr():IsValidRankKey(RankKey), "无效的排行榜键："..RankKey)
	self.mLeftList:SetSelectedId(RankKey)
end

function clsRanklistPanel:ShowRank(RankKey)
	self._CurRankKey = RankKey
	local InstRankMgr = KE_Director:GetRankMgr()
	local RankList = InstRankMgr:GetRanklist(RankKey) or {}
	local compList = self:InitRightList()
	compList:RemoveAll()
	
	for i, Info in ipairs(RankList) do
		compList:Insert(Info)
	end
	compList:ForceReLayout()
end
