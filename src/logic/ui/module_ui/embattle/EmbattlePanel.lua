------------------
-- 布阵
------------------
module("ui", package.seeall)

clsEmbattlePanel = class("clsEmbattlePanel", clsCommonFrame)

function clsEmbattlePanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_embattle/embattle_panel.lua", "布阵")
	
	self:InitCardList()
	self:InitJoinList()
	
	-- 确定按钮
	utils.RegButtonEvent(self:GetCompByName("btn_enter"), function()
		local UidList = self._TmpFormation:GetFighterUidList()
		
		--保存队伍
		self:SaveFormation()
		
		--回调
		if UidList and not table.is_empty(UidList) then
			self.funcOnBtnEnter(UidList)
		else
			local panel = ClsUIManager.GetInstance():ShowDialog("clsConfirmDlg")
			panel:Refresh("提示", "英雄且慢！您确定要孤身上阵吗？", function()
				self.funcOnBtnEnter(UidList)
			end)
		end
	end)
end

function clsEmbattlePanel:dtor()
	if self.mCompList then
		KE_SafeDelete(self.mCompList)
		self.mCompList = nil 
	end
	for _, wnd in pairs(self.tJoinList) do
		KE_SafeDelete(wnd)
	end
	self.tJoinList = nil 
end

function clsEmbattlePanel:SaveFormation()
	KE_Director:GetEmbattleMgr():CloneFormation(self.sCombatType, self._TmpFormation)
end

function clsEmbattlePanel:InitCardList()
	if self.mCompList then return end
	
	self.mCompList = clsCompList.new(self, ccui.ScrollViewDir.horizontal, 960, 200, 132, 200)
	local compList = self.mCompList
	compList:setPosition( (self:getContentSize().width-960)/2, 0 )
	compList:SetCellCreator(function(CellObj)
		local CardWnd = clsCardPhoto.new()
		CardWnd:SetNpcId(CellObj:GetCellId())
		return CardWnd
	end)
	compList:SetCellRefresher(function(CellComp, CellObj)
		CellComp:SetMarked(CellObj:GetCellData().Marked)
	end)
	compList:AddListener("lis_click_cell", "ec_click_cell", function(CellObj)
		self:FighterOn(CellObj:GetCellId())
	end)
	
	--
	for _, info in pairs(setting.T_npc_cfg) do
		compList:Insert({NpcId=info.Uid, Marked=false}, info.Uid)
	end
	compList:ForceReLayout()
end

function clsEmbattlePanel:InitJoinList()
	if self.tJoinList then return end
	
	self.tJoinList = {}
	for i=1, 3 do
		local CardWnd = clsCardPhoto.new()
		CardWnd:setPositionX(i*132)
		KE_SetParent(CardWnd, self:GetCompByName("ctrl_cards"))
		table.insert(self.tJoinList, CardWnd)
		utils.RegButtonEvent(CardWnd, function()
			if CardWnd:GetNpcId() then
       			self:FighterOff(CardWnd:GetNpcId())
       		end
		end)
	end
end


function clsEmbattlePanel:Reset(sCombatType, funcOnBtnEnter)
	assert(utils.IsValidCombatType(sCombatType))
	assert(is_function(funcOnBtnEnter))
	self.sCombatType = sCombatType
	self.funcOnBtnEnter = funcOnBtnEnter
	
	if self._TmpFormation then
		KE_SafeDelete(self._TmpFormation)
		self._TmpFormation = nil
	end
	self._TmpFormation = clsFormation.new(sCombatType)
	
	--旧队伍下阵
	for _, wnd in ipairs(self.tJoinList) do
		self:FighterOff(wnd:GetNpcId())
	end
	--新队伍上阵
	local objFormation = KE_Director:GetEmbattleMgr():GetFormation(self.sCombatType)
	local UidList = objFormation and objFormation:GetFighterUidList() or {}
	for _, FighterUid in ipairs(UidList) do
		self:FighterOn(FighterUid)
	end
end

-- 上阵
function clsEmbattlePanel:FighterOn(Uid)
	if Uid == nil then return end
	local bSucc = self._TmpFormation:AddFighter(Uid)
	if not bSucc then return end
	
	local DestWnd 
	for _, wnd in ipairs(self.tJoinList) do
		if wnd:GetNpcId() == Uid then
			DestWnd = nil
			break
		end
		if not wnd:GetNpcId() then
			DestWnd = DestWnd or wnd
		end
	end
	if DestWnd then
		DestWnd:SetNpcId(Uid)
	end
	
	self.mCompList:GetCellById(Uid):GetCellData().Marked = true
	self.mCompList:RefreshCellCompById(Uid)
end

-- 下阵
function clsEmbattlePanel:FighterOff(Uid)
	if Uid == nil then return end
	local bSucc = self._TmpFormation:RemoveFighter(Uid)
	if not bSucc then return end
	
	for _, wnd in ipairs(self.tJoinList) do
		if wnd:GetNpcId() == Uid then
			wnd:SetNpcId(nil)
		end
	end
	
	self.mCompList:GetCellById(Uid):GetCellData().Marked = false
	self.mCompList:RefreshCellCompById(Uid)
end
