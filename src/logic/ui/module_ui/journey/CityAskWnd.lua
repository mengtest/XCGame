------------------
-- 点击城市的询问弹窗
------------------
module("ui", package.seeall)

clsCityAskWnd = class("clsCityAskWnd", clsWindow)

function clsCityAskWnd:ctor(parent)
	clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_journey/city_ask_wnd.lua")
	self._CityId = nil
	self:SetModal(true,true,function() self:Show(false) end)
	
	self:InitAskList()
end

function clsCityAskWnd:dtor()
	if self.mAskList then KE_SafeDelete(self.mAskList) self.mAskList = nil end
end

function clsCityAskWnd:SetCity(CityId)
	assert(setting.T_city_cfg[CityId], "无效的CityId"..CityId)
	self._CityId = CityId
	
	local CityData = KE_Director:GetCityMgr():GetCityData(CityId)
	local CountryData = KE_Director:GetCountryMgr():GetCountry(CityData and CityData:GetiCountryId())
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(CityData and CityData:GetiCastellanId())
	
	local DetailStr = {}
	
	local CityName = setting.T_city_cfg[CityId].sName
	DetailStr[#DetailStr+1] = "名    字："..CityName
	local CountryName = CountryData and CountryData:GetsName() or ""
	DetailStr[#DetailStr+1] = "所属国："..CountryName
	local CastellanName = RoleData and RoleData:GetsName() or ""
	DetailStr[#DetailStr+1] = "城    主："..CastellanName
	DetailStr[#DetailStr+1] = "\n兵力"
	
	local monster_list = KE_Director:GetTroopMgr():GetCityTroopByLeader(CityId):GetMemberList()
	for i, cfg in ipairs(monster_list) do
		local typeid, Cnt = cfg[1], cfg[2]
		local CfgInfo = setting.T_card_cfg[typeid]
		DetailStr[#DetailStr+1] = CfgInfo.sName..": "..Cnt
	end
	
	self:GetCompByName("LabelDetail"):setString(table.concat(DetailStr,"\n"))
	
	self:ResetMenu( KE_Director:GetHeroData():GetiCountryId() == CityData:GetiCountryId() )
end

function clsCityAskWnd:AddMenuItem(Key, MenuText, ClickFunc)
	local Info = { Key = Key, MenuText = MenuText, ClickFunc = ClickFunc }
	self.mAskList:Insert(Info, Key)
end

--根据关系（敌对、友军、无关）刷新菜单
function clsCityAskWnd:ResetMenu(iRelation)
	if self.iRelation == iRelation then return end
	self.iRelation = iRelation
	
	self.mAskList:RemoveAll()
	
	if iRelation == false then	-- 敌对、无关
		self:AddMenuItem("攻占", "攻占", function(CityId) 
			local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsEmbattlePanel")
			wnd:Reset(const.COMBAT_TYPE.CITY_SIEGE, function()
				network.SendPro("s_fight_city", nil, CityId)
			end)
		end)
		
		self:AddMenuItem("掠夺", "掠夺", function(CityId)
			
		end)
		
		self:AddMenuItem("放火", "放火", function(CityId)
			KE_Director:GetCityMgr():GetCityData(CityId):SetbOnFired(true)
			self:Show(false)
		end)
		
		self:AddMenuItem("劝降", "劝降", function(CityId)
			
		end)
	elseif iRelation == true then	-- 友好
		self:AddMenuItem("屯兵", "屯兵", function(CityId)
		
		end)
		
		self:AddMenuItem("资助", "资助", function(CityId)
		
		end)
		
		self:AddMenuItem("游览", "游览", function(CityId)
		
		end)
		
		self:AddMenuItem("征兵", "征兵", function(CityId)
		
		end)
	end
	
	self.mAskList:ForceReLayout()
end

function clsCityAskWnd:InitAskList()
	if self.mAskList then return self.mAskList end
	
	self.mAskList = clsCompList.new(self, ccui.ScrollViewDir.vertical, 220, 480, 220, 74)
	local compList = self.mAskList
	compList:setPosition(15,-240)
	compList:SetHighLightImgPath(nil)
	compList:SetCellCreator(function(CellObj)
		local btn = ccui.Button:create("res/uiface/buttons/btn_blue.png", "res/uiface/buttons/btn_green.png")
		btn:setScale9Enabled(true)
		btn:setContentSize(220,72)
		btn:setTitleText(CellObj:GetCellId())
		guide:RegGuideBtn("城市询问面板_"..CellObj:GetCellId(), btn)
		return btn
	end)
	compList:AddListener(self, "ec_click_cell", function(CellObj)
		local ClickFunc = CellObj:GetCellData().ClickFunc
		ClickFunc(self._CityId)
	end)
	
	return compList
end
