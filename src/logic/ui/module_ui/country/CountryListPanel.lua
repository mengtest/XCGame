------------------
-- 国家列表界面
------------------
module("ui", package.seeall)

clsCountryListPanel = class("clsCountryListPanel", clsCommonFrame)

function clsCountryListPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_country/country_list_panel.lua", "国家")
	
	self:InitCountryList()
	
	local HeroData = KE_Director:GetHeroData()
	
	if HeroData:GetiCountryId() then 
		self:GetCompByName("btn_buildup"):setVisible(false)
		self:GetCompByName("btn_applyfor"):setVisible(false)
		--宣战/议和
		utils.RegButtonEvent(self:GetCompByName("btn_relation"), function()
			if not self._SelectedCountryId then
				utils.TellMe("请选择要宣战/议和的国家")
				return
			end
			if self._SelectedCountryId == HeroData:GetiCountryId() then
				utils.TellMe("不可向自己所在国宣战/议和")
				return
			end
			
			local CountryData = KE_Director:GetCountryMgr():GetCountry(self._SelectedCountryId)
			local panel = ClsUIManager.GetInstance():ShowDialog("clsConfirmDlg")
			
			local iRelation = KE_Director:GetCountryMgr():GetCountryRelation(self._SelectedCountryId, HeroData:GetiCountryId())
			if iRelation == const.RELATION_ENEMY then
				panel:Refresh("议和", string.format("您确定要和【%s】议和吗？",CountryData:GetsName()), function()
					network.SendPro("s_chg_country_relation", nil, self._SelectedCountryId, HeroData:GetiCountryId(), const.RELATION_PARTNER)
				end)
			elseif iRelation == const.RELATION_PARTNER then
				panel:Refresh("宣战", string.format("您确定要向【%s】宣战吗？",CountryData:GetsName()), function()
					network.SendPro("s_chg_country_relation", nil, self._SelectedCountryId, HeroData:GetiCountryId(), const.RELATION_ENEMY)
				end)
			elseif iRelation == const.RELATION_NONE then
				panel:Refresh("宣战", string.format("您确定要向【%s】宣战吗？",CountryData:GetsName()), function()
					network.SendPro("s_chg_country_relation", nil, self._SelectedCountryId, HeroData:GetiCountryId(), const.RELATION_ENEMY)
				end)
			end
		end)
	else
		--建立国家
		utils.RegButtonEvent(self:GetCompByName("btn_buildup"), function()
			local wnd = ClsUIManager.GetInstance():ShowDialog("clsCountryBuildWnd")
	        wnd:Refresh(function(CountryName, FlagId)
	        	network.SendPro("s_build_country", nil, CountryName, FlagId)
	        end)
		end)
		--申请加入
		utils.RegButtonEvent(self:GetCompByName("btn_applyfor"), function()
			if self._SelectedCountryId then
				network.SendPro("s_request_enter_country", nil, self._SelectedCountryId)
			else
				utils.TellMe("请选择要加入的国家")
			end
		end)
		self:GetCompByName("btn_buildup"):setVisible(true)
		self:GetCompByName("btn_applyfor"):setVisible(true)
	end
	
	--查看成员
	utils.RegButtonEvent(self:GetCompByName("btn_member"), function()
		local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsCountryMemberPanel")
		wnd:SetCountryId(self._SelectedCountryId)
	end)
	
	self:GetCompByName("btn_relation"):setVisible(HeroData:GetiCountryId()~=self._SelectedCountryId)
end

function clsCountryListPanel:dtor()
	local InstCountryMgr = KE_Director:GetCountryMgr()
	InstCountryMgr:DelListener(self)
	
	if self.mCompCountryList then
		KE_SafeDelete(self.mCompCountryList)
		self.mCompCountryList = nil 
	end
	
	ClsUIManager.GetInstance():DestroyWindow("clsCountryBuildWnd")
end

function clsCountryListPanel:OnSelectCountry(CountryId)
	self._SelectedCountryId = CountryId
	--
	local HeroData = KE_Director:GetHeroData()
	local CountryData = KE_Director:GetCountryMgr():GetCountry(CountryId)
	local kingid = CountryData:GetiKingId()
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(kingid)
	local kingName =RoleData and RoleData:GetsName() or kingid
	local FlagId = CountryData:GetiFlagId()
	local strText = string.format("%s  %s  %d", CountryData:GetsName(), kingName, table.size(CountryData:GettPersonList()))
	--
	self:GetCompByName("btn_relation"):setVisible(HeroData:GetiCountryId()~=CountryId)
	KE_Director:GetCountryMgr():AddListener(self, "e_country_relation_chg", function()
		local iRelation = KE_Director:GetCountryMgr():GetCountryRelation(self._SelectedCountryId, HeroData:GetiCountryId())
		if iRelation == const.RELATION_ENEMY then
			self:GetCompByName("btn_relation"):setTitleText("议和")
		elseif iRelation == const.RELATION_PARTNER then
			self:GetCompByName("btn_relation"):setTitleText("宣战")
		elseif iRelation == const.RELATION_NONE then
			self:GetCompByName("btn_relation"):setTitleText("宣战")
		end
	end, true)
end

function clsCountryListPanel:InitCountryList()
	if self.mCompCountryList then return self.mCompCountryList end
	self.mCompCountryList = clsCompList.new(self, ccui.ScrollViewDir.horizontal, 500, 80, 80, 80)
	local compList = self.mCompCountryList
	compList:setPosition(15,10)
	compList:SetCellRefresher(function(CellComp, CellObj)
		local CountryData = CellObj:GetCellData()
--		local kingid = CountryData:GetiKingId()
--		local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(kingid)
--		local kingName = RoleData and RoleData:GetsName() or kingid
--		local FlagId = CountryData:GetiFlagId()
--		local strText = string.format("%s  %s  %d", CountryData:GetsName(), kingName, table.size(CountryData:GettPersonList()))
		CellComp:setTitleText(CountryData:GetsName())
--		if not CellComp.mSprFlag then 
--			CellComp.mSprFlag = cc.Sprite:create(setting.T_flag_cfg[FlagId].respath)
--			KE_SetParent(CellComp.mSprFlag, CellComp)
--			CellComp.mSprFlag:setPosition(50,38)
--			CellComp.mSprFlag:setScale(42/165)
--		end
	end)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/panels/panel_confirm.png")
		btn:setScale9Enabled(true)
		btn:setContentSize(80,80)
		btn:setTitleFontSize(26)
		return btn
	end)
	compList:AddListener("lis_click_cell", "ec_click_cell", function(CellObj)
		self:OnSelectCountry(CellObj:GetCellId())
	end)
	
	--
	local InstCountryMgr = KE_Director:GetCountryMgr()
	local CountryList = InstCountryMgr:GetCountryList()
	local MyCountryId = InstCountryMgr:GetMyCountryId()
	for CountryId, CountryData in pairs(CountryList) do
--		if CountryId ~= MyCountryId then
			compList:Insert(CountryData, CountryId)
--		end
	end
	compList:ForceReLayout()
	compList:SetSelectedIdx(1)
	
	--
	InstCountryMgr:AddListener(self, "e_add_country", function(CountryId)
		local CountryData = InstCountryMgr:GetCountry(CountryId)
		compList:Insert(CountryData, CountryId)
		compList:ForceReLayout()
	end)
	InstCountryMgr:AddListener(self, "e_del_country", function(CountryId)
		local idx = compList:GetCellIdxById(CountryId)
		if idx then
			compList:Remove(idx)
			compList:ForceReLayout()
		end
	end)
	InstCountryMgr:AddListener(self, "e_update_country", function(CountryId, Info)
		compList:RefreshCellCompById(CountryId)
	end)
	
	return self.mCompCountryList
end
