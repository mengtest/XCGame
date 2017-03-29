------------------
-- 招揽界面
------------------
module("ui", package.seeall)

clsRecruitPanel = class("clsRecruitPanel", clsCommonFrame)

function clsRecruitPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_recruit/recruit_panel.lua", "招揽")
	
	self:InitCardList()
	self:RefreshCardList()
end

function clsRecruitPanel:dtor()
	redpoint.ClsRedPointManager.GetInstance():DelListener("clsRecruitPanel")
	if self.mUiRoleNpc then 
		ClsRoleMgr.GetInstance():DestroyTempRole(self.mUiRoleNpc) 
		self.mUiRoleNpc = nil 
	end
	if self.mCompList then
		KE_SafeDelete(self.mCompList)
		self.mCompList = nil 
	end
end

function clsRecruitPanel:OnSelectCard(iNpcId)
	if self.mUiRoleNpc then 
		ClsRoleMgr.GetInstance():DestroyTempRole(self.mUiRoleNpc) 
		self.mUiRoleNpc = nil 
	end
	
	local NpcData = KE_Director:GetRoleDataMgr():GetRoleData(iNpcId)
	self.mUiRoleNpc = ClsRoleMgr.GetInstance():CreateTempRole(NpcData:GetTypeId())
	self.mUiRoleNpc:setPosition(150,250)
	self.mUiRoleNpc:GetBody():setScale(0.7)
	KE_SetParent(self.mUiRoleNpc, self)
end

function clsRecruitPanel:InitCardList()
	if self.mCompList then return end
	self.mCompList = clsCompList.new(self, ccui.ScrollViewDir.horizontal, 960, 220, 132, 200)
	local compList = self.mCompList
	compList:setPosition( (self:getContentSize().width-960)/2, 0 )
	compList:SetCellCreator(function(CellObj)
		local CardWnd = clsCardPhoto.new()
		CardWnd:SetNpcId(CellObj:GetCellId())
		redpoint._ShowRedPointSpr(CardWnd, KE_Director:GetRecruitMgr():CanRecruitCard(CellObj:GetCellId()))
		return CardWnd
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		self:OnSelectCard(CellObj:GetCellId())
	end)
	
	redpoint.ClsRedPointManager.GetInstance():AddListener("clsRecruitPanel", "red_recruit_spec_card", function()
		if not self.mCompList then return end
		self.mCompList:ForeachCellObjs(function(CellObj)
			local CardWnd = CellObj:GetCellComp()
			if CardWnd then
				redpoint._ShowRedPointSpr(CardWnd, KE_Director:GetRecruitMgr():CanRecruitCard(CellObj:GetCellId()))
			end
		end)
	end, true)
end

function clsRecruitPanel:RefreshCardList(FilterFunc)
	local info_list = {}
	for _, info in pairs(setting.T_npc_cfg) do
		if FilterFunc then
			if FilterFunc(info) then
				info_list[#info_list+1] = info 
			end
		else
			info_list[#info_list+1] = info 
		end
	end
	
	table.sort(info_list, function(a,b)
		return a.TypeId < b.TypeId
	end)
	
	local compList = self.mCompList
	for _, info in pairs(info_list) do
		compList:Insert(info, info.Uid)
	end
	compList:ForceReLayout()
end
