------------------
-- 国家成员界面
------------------
module("ui", package.seeall)

local LIST_W, LIST_H = 480, 380
local CELL_W, CELL_H = 480, 70

clsCountryMemberPanel = class("clsCountryMemberPanel", clsCommonFrame)

function clsCountryMemberPanel:ctor(parent)
	clsCommonFrame.ctor(self, parent, "src/data/uiconfigs/ui_country/country_member_panel.lua", "国家成员")
	self:InitPersonList()
end

function clsCountryMemberPanel:dtor()
	local InstCountryMgr = KE_Director:GetCountryMgr()
	InstCountryMgr:DelListener(self)
	
	if self.mCompPerList then 
		KE_SafeDelete(self.mCompPerList)
		self.mCompPerList = nil 
	end
end

function clsCountryMemberPanel:SetCountryId(CountryId)
	self._CurCountryId = CountryId
	network.SendPro("s_country_person_list", nil, CountryId)
	self:RefreshPersonList()
end

function clsCountryMemberPanel:InitPersonList()
	if self.mCompPerList then return self.mCompPerList end
	
	--
	self.mCompPerList = clsCompList.new(self, ccui.ScrollViewDir.vertical, LIST_W, LIST_H, CELL_W, CELL_H)
	local compList = self.mCompPerList
	compList:setPosition(self:getContentSize().width/2-LIST_W/2, self:getContentSize().height/2-LIST_H/2)
	
	compList:SetCellRefresher(function(CellComp, CellObj)
		local PersonInfo = CellObj:GetCellData()
		local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(PersonInfo.Uid)
		local RoleName = RoleData and RoleData:GetsName() or PersonInfo.Uid
		local iOffice = PersonInfo.iOffice
		local OfficeName = const.OFFICE_TYPE_2_NAME[iOffice]
		local strText = string.format("%s  %s", RoleName, OfficeName)
		CellComp:setTitleText(strText)
	end)
	
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/panels/list_common.png")
		btn:setScale9Enabled(true)
		btn:setContentSize(480,70)
		return btn
	end)
	
	--
	local InstCountryMgr = KE_Director:GetCountryMgr()
	InstCountryMgr:AddListener(self, "e_person_join_country", function(PersonInfo, CountryId)
		if CountryId ~= self._CurCountryId then return end
		
		local personId = PersonInfo.Uid 
		if compList:GetCellById(personId) then
			compList:RefreshCellCompById(personId)
		else
			compList:Insert(PersonInfo, personId)
			compList:ForceReLayout()
		end
		
		local CountryData = KE_Director:GetCountryMgr():GetCountry(CountryId)
		local strDesc = string.format("将领：（%d）",table.size(CountryData:GettPersonList()))
	--	self:GetCompByName("LabelGeneralDesc"):setString(strDesc)
	end)
	InstCountryMgr:AddListener(self, "e_person_leave_country", function(PersonId, CountryId)
		if CountryId ~= self._CurCountryId then return end
		
		local idx = compList:GetCellIdxById(PersonId)
		if idx then
			compList:Remove(idx)
			compList:ForceReLayout()
		end
		
		local CountryData = KE_Director:GetCountryMgr():GetCountry(CountryId)
		local strDesc = string.format("将领：（%d）",table.size(CountryData:GettPersonList()))
	--	self:GetCompByName("LabelGeneralDesc"):setString(strDesc)
	end)
	
	return self.mCompPerList
end

function clsCountryMemberPanel:RefreshPersonList()
	local CountryId = self._CurCountryId
	local compList = self:InitPersonList()
	compList:RemoveAll()
	if not CountryId then return end
	
	local InstCountryMgr = KE_Director:GetCountryMgr()
	local CountryData = InstCountryMgr:GetCountry(CountryId)
	local PersonList = CountryData:GettPersonList()
	for _, PersonInfo in pairs(PersonList) do
		compList:Insert(PersonInfo, PersonInfo.Uid)
	end
	compList:ForceReLayout()
end
