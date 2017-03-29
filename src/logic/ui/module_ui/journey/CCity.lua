module("ui", package.seeall)

clsCity = class("clsCity", ui.clsWindow)

function clsCity:ctor(parent, Uid)
	ui.clsWindow.ctor(self, parent, "src/data/uiconfigs/ui_journey/city_wnd.lua")

	self:SetUid(Uid)
	
	local CityData = KE_Director:GetCityMgr():GetCityData(Uid)
	if CityData then
		CityData:AddListener(self, "iCountryId", function()
			self:SetUid(self:GetUid())
		end)
		CityData:AddListener(self, "iCastellanId", function()
			self:SetUid(self:GetUid())
		end)
		CityData:AddListener(self, "bOnFired", function(isFire)
			self:SetOnFire(isFire)
		end)
		CityData:AddListener(self, "iCurState", function(CurState)
			self:SetCurState(CurState)
		end)
	else
		print("城市数据不存在："..Uid)
	end
	
	--
	self:CreateTimerDelay("tm_fixorder",1,function() self:setLocalZOrder(-self:getPositionY()) end)
	
	utils.RegButtonEvent(self:GetCompByName("btn_city"), function()
		self:OnClicked()
	end)
end

function clsCity:dtor()
	local CityData = KE_Director:GetCityMgr():GetCityData(self:GetUid())
	if CityData then
		CityData:DelListener(self)
	end
	ClsUIManager.GetInstance():DestroyWindow("clsCityAskWnd")
end

function clsCity:OnClicked()
	local opTarget = ClsRoleMgr.GetInstance():GetHero()
	if opTarget then 
		local x,y = self:getPosition()
		opTarget:CallRun(x, y, nil, function() 
			local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsCityAskWnd")
			if wnd then wnd:SetCity(self:GetUid(), self) end
		end)
	else 
		local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsCityAskWnd")
		if wnd then wnd:SetCity(self:GetUid(), self) end
	end
end	

function clsCity:SetUid(Uid)
	self.Uid = Uid
	
	local CityCfg = setting.T_city_cfg[Uid]
	assert(CityCfg, "没有配置该城市："..Uid)
	local CityData = KE_Director:GetCityMgr():GetCityData(Uid)
	local CountryData = KE_Director:GetCountryMgr():GetCountry(CityData and CityData:GetiCountryId())
	
	self:RefreshName()
	self:RefreshBuilding(CityCfg.sResPath, "", "")
	self:RefreshFlag(CountryData and CountryData:GetiFlagId())
	self:SetCastellan(CityData and CityData:GetiCastellanId())
	self:SetOnFire(CityData and CityData:GetbOnFired())
	self:SetCurState(CityData and CityData:GetiCurState())
	
	--
	guide:RegGuideBtn("世界地图_城市_"..CityCfg.sName, self:GetCompByName("btn_city"))
end

function clsCity:RefreshBuilding(a,b,c)
	if self._bHasInitRes then return end
	self._bHasInitRes = true
	self:GetCompByName("btn_city"):loadTextures(a,b,c)
	local size = self:GetCompByName("btn_city"):getContentSize()
	self:GetCompByName("label_name"):setPosition(size.width/2, 20)
end

function clsCity:RefreshName()
	local CityData = KE_Director:GetCityMgr():GetCityData(self.Uid)
	local CountryData = KE_Director:GetCountryMgr():GetCountry(CityData and CityData:GetiCountryId())
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(CityData and CityData:GetiCastellanId())
	
	local CityName = setting.T_city_cfg[self.Uid].sName
	local CountryName = CountryData and "【"..CountryData:GetsName().."】" or ""
	local CastellanName = RoleData and "（"..RoleData:GetsName().."）" or ""
	
	local sShowName = string.format("%s%s%s", CountryName, CityName, CastellanName)
	self:GetCompByName("label_name"):setString(sShowName)
end

function clsCity:SetOnFire(bOnFired)
	if bOnFired then
		if not self.mEmitter then
			self.mEmitter = cc.ParticleFire:create()
			KE_SetParent(self.mEmitter, self)
			self.mEmitter:setPosition(-50,-20)
			self.mEmitter:setPositionType(cc.POSITION_TYPE_GROUPED)
		end
	else
		if self.mEmitter then
			KE_SafeDelete(self.mEmitter)
			self.mEmitter = nil
		end
	end
end

function clsCity:RefreshFlag(iFlagId)
	if self._iFlagId == iFlagId then return end
	if self.mSprFlag then
		KE_SafeDelete(self.mSprFlag)
		self.mSprFlag = nil
	end
	if not iFlagId then return end
	self.mSprFlag = cc.Sprite:create(string.format("res/flags/flag%d.png", iFlagId))
	KE_SetParent(self.mSprFlag, self)
	self.mSprFlag:setPosition(15,40)
end

function clsCity:SetCurState(iState)
	if self.mSprState then
		KE_SafeDelete(self.mSprState)
		self.mSprState = nil
	end
	
	if iState == const.ST_CITY_SIEGED then
		self.mSprFlag = cc.Sprite:create("res/icons/battle_1.png")
		KE_SetParent(self.mSprFlag, self)
	elseif iState == const.ST_CITY_BREAKD then
		self.mSprFlag = cc.Sprite:create("res/icons/battle_2.png")
		KE_SetParent(self.mSprFlag, self)
	end
end

function clsCity:SetCastellan(iCastellanUid)
	if self._iCastellanUid == iCastellanUid then return end
	self._iCastellanUid = iCastellanUid
end


function clsCity:GetUid()
	return self.Uid
end
function clsCity:GetName()
	return setting.T_city_cfg[self.Uid].sName
end

