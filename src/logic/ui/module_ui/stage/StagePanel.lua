-----------------
-- 过关斩将
-----------------
module("ui", package.seeall)

STAGE_TYPE_SIMPLE = 1
STAGE_TYPE_HARD = 2
STAGE_TYPE_HELL = 3

clsStagePanel = class("clsStagePanel", clsCommonFrame)

function clsStagePanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_stage/stage_panel.lua", "过关斩将")
	
	self._AllListWnd = {}
	
	--布阵按钮
	utils.RegButtonEvent(self:GetCompByName("btn_embattle"), function()
		local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsEmbattlePanel")
		if not wnd then return end
		wnd:Reset(const.COMBAT_TYPE.STAGE, function()
			if not self._cur_stage_id then
				utils.TellMe("请选择要进入的关卡")
				return
			end
			
			local StageId = self._cur_stage_id
			local preStage = setting.GetPreStage(StageId)
			
			if preStage and not KE_Director:GetStageMgr():HasPassedStage(preStage) then
				utils.TellMe("请先通关上一关卡")
				return
			end
			
			network.SendPro("s_fight_stage", nil, StageId)
		end)
	end)
	--战斗按钮
	utils.RegButtonEvent(self:GetCompByName("btn_enter"), function()
		if not self._cur_stage_id then
			utils.TellMe("请选择要进入的关卡")
			return
		end
		
		local StageId = self._cur_stage_id
		local preStage = setting.GetPreStage(StageId)
		
		if preStage and not KE_Director:GetStageMgr():HasPassedStage(preStage) then
			utils.TellMe("请先通关上一关卡")
			return
		end
		
		local objFormation = KE_Director:GetEmbattleMgr():GetFormation(const.COMBAT_TYPE.STAGE)
		if objFormation and objFormation:GetFighterCnt()>0 then
			network.SendPro("s_fight_stage", nil, StageId)
		else
			local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsEmbattlePanel")
			if not wnd then return end
			wnd:Reset(const.COMBAT_TYPE.STAGE, function()
				network.SendPro("s_fight_stage", nil, StageId)
			end)
		end
	end)
	
	--
	local radioButtonGroup = ccui.RadioButtonGroup:create()
	radioButtonGroup:addEventListener(function(radioButton, index, iType)
		self:ShowStageType(index+1)
	end)
	self:addChild(radioButtonGroup)
	for i = 1, 3 do
		local radioButton = self:GetCompByName("tab_"..i)
		radioButtonGroup:addRadioButton(radioButton)
	end
	self.mRadioButtonGroup = radioButtonGroup
end

function clsStagePanel:dtor()
	KE_Director:GetStageMgr():DelListener(self)
	for i, listwnd in pairs(self._AllListWnd) do
		KE_SafeDelete(listwnd)
	end
	self._AllListWnd = nil
end

function clsStagePanel:SwitchTo(stagetype)
	stagetype = stagetype or STAGE_TYPE_SIMPLE
	assert(stagetype==STAGE_TYPE_SIMPLE or stagetype==STAGE_TYPE_HARD or stagetype==STAGE_TYPE_HELL, "关卡类型非法："..stagetype)
	self.mRadioButtonGroup:setSelectedButton(stagetype-1)
end

function clsStagePanel:ShowStageType(stagetype)
	assert(stagetype==STAGE_TYPE_SIMPLE or stagetype==STAGE_TYPE_HARD or stagetype==STAGE_TYPE_HELL)
	local compList = self:InitStageList(stagetype)
	for i, listwnd in pairs(self._AllListWnd) do
		listwnd:setVisible(i==stagetype)
	end
	compList:SetSelectedIdx(1)
end

function clsStagePanel:InitStageList(iStageType)
	if self._AllListWnd[iStageType] then 
		return self._AllListWnd[iStageType] 
	end
	
	self._AllListWnd[iStageType] = clsCompList.new(self, ccui.ScrollViewDir.vertical, 388, 420, 388, 70)
	local compList = self._AllListWnd[iStageType]
	compList:setPosition(6,85)
	compList:SetCellRefresher(function(CellComp, CellObj)
		local stageid = CellObj:GetCellId()
		local stageinfo = setting.GetStageInfoById(stageid)
		local strText = string.format("%d", stageinfo.StageId)
		if KE_Director:GetStageMgr():HasPassedStage(stageid) then
			strText = strText .. "（已完成）"
		end
		CellComp:setTitleText(strText)
	end)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create(string.format("res/uiface/panels/panel_stage_type_%d.png", iStageType))
		return btn
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		local StageId = CellObj:GetCellId()
		self._cur_stage_id = StageId
		local StageInfo = setting.GetStageInfoById(StageId)
		local strDesc = {"关卡描述："}
		for _, monInfo in ipairs(StageInfo.monster_list) do
			strDesc[#strDesc+1] = string.format("\n%s：%d",setting.T_card_cfg[monInfo[1]].sName, monInfo[2])
		end
		self:GetCompByName("label_desc"):setString(table.concat(strDesc))
	end)
	
	--
	local infolist = setting.T_stage_cfg[iStageType]
	for _, stageinfo in ipairs(infolist) do
		compList:Insert(stageinfo.StageId, stageinfo.StageId)
	end
	compList:ForceReLayout()
	
	
	--
	local InstStageMgr = KE_Director:GetStageMgr()
	InstStageMgr:AddListener(self, "e_stage_progress", function(iStageType, iCurStageId)
		local idx = compList:GetCellIdxById(iCurStageId) or -1
		for i=1, idx do 
			compList:RefreshCellCompByIdx(i)
		end
	end)
	
	return self._AllListWnd[iStageType]
end
