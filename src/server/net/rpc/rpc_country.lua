module("server", package.seeall)

s_build_country = function(UserId, CountryName, FlagId)
	assert(type(UserId)=="number" and type(CountryName)=="string" and type(FlagId)=="number", "参数类型错误")
	-- 防御
	if not CountryName then
		server.c_tell_fail("请输入国名")
		return false
	end
	if not FlagId then
		server.c_tell_fail("请选择旗帜")
		return false
	end
	if FlagId <= 100 then
		server.c_tell_fail("不可使用系统旗帜")
		return false
	end
	
	if ClsSerDataMgr.GetInstance():GetCountryByName(CountryName) then
		server.c_tell_fail("国名: 【"..CountryName.."】已经被占用")
		return false
	end
	if ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iCountryId then
		server.c_tell_fail("请先脱离原来的国家")
		return false
	end
	
	-- 创建
	local _COUNTRY_ID = idmng:GenCountryUid()
	
	local CountryInfo = {
		Uid = _COUNTRY_ID,
		sName = CountryName,
		iFlagId = FlagId,
		iKingId = UserId,
	}
	ClsSerDataMgr.GetInstance()._CountryList[_COUNTRY_ID] = CountryInfo
	
	local userinfo = ClsSerDataMgr.GetInstance()._UserInfoSet[UserId]
	userinfo.iOffice = const.OFFICE_KING
	userinfo.iCountryId = _COUNTRY_ID
	
	local bNeedSaveCity = false
	for cityid, cityinfo in pairs(self._CityList) do
		if cityinfo.iCastellanId == UserId then
			cityinfo.iCountryId = _COUNTRY_ID
			bNeedSaveCity = true
		end
	end
	
	-- 存盘
	ClsSerDataMgr.GetInstance():SaveCountryList()
	ClsSerDataMgr.GetInstance():SaveUserInfoSet()
	if bNeedSaveCity then ClsSerDataMgr.GetInstance():SaveCityList() end
	
	-- 下行
	server.c_build_country(_COUNTRY_ID, CountryInfo)
end

s_request_enter_country = function(UserId, CountryId)
	if ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iCountryId then
		server.c_tell_fail("请先脱离原来的国家")
		return false
	end
	if not ClsSerDataMgr.GetInstance()._CountryList[CountryId] then
		server.c_tell_fail("你要加入的国家已经解散")
		return false
	end
	
	local PersonId = UserId
	local PersonInfo = {
		Uid = PersonId,
		iOffice = const.OFFICE_SOLDIER,
	}
	
	ClsSerDataMgr.GetInstance()._UserInfoSet[PersonId].iOffice = PersonInfo.iOffice
	ClsSerDataMgr.GetInstance()._UserInfoSet[PersonId].iCountryId = CountryId
	
	local bNeedSaveCity = false
	for cityid, cityinfo in pairs(self._CityList) do
		if cityinfo.iCastellanId == UserId then
			cityinfo.iCountryId = CountryId
			bNeedSaveCity = true
		end
	end
			
	ClsSerDataMgr.GetInstance():SaveUserInfoSet()
	ClsSerDataMgr.GetInstance():SaveCountryList()
	if bNeedSaveCity then ClsSerDataMgr.GetInstance():SaveCityList() end
			
	server.c_country_add_person(PersonId, CountryId, personInfo)
end

s_request_leave_country = function(UserId, CountryId)
	CountryId = self._UserInfoSet[UserId].iCountryId
	if not CountryId then
		server.c_tell_fail("【BUG】你并未加入任何国家")
		return 
	end
	if not ClsSerDataMgr.GetInstance()._CountryList[CountryId] then
		server.c_tell_fail("你要脱离的国家已经解散")
		return
	end
	
	
	self._UserInfoSet[UserId].iCountryId = nil
	self._UserInfoSet[UserId].iOffice = nil 
			
	self:SaveCountryList()
	self:SaveUserInfoSet()
	
	server.c_person_leave_country(CountryId, UserId)
end

s_country_dismiss_person = function(UserId, PersonId)
	local CountryId = self._UserInfoSet[UserId].iCountryId
	if not CountryId then
		server.c_tell_fail("【BUG】你并未加入任何国家，无权删除成员")
		return 
	end
	local iOffice = self._UserInfoSet[UserId].iOffice
	if iOffice ~= const.OFFICE_KING or iOffice ~= const.OFFICE_GENERAL then
		server.c_tell_fail("你的官职不够，无权删除成员")
		return
	end
	if iOffice > self._UserInfoSet[PersonId].iOffice then
		server.c_tell_fail("你无权删除官职比你高的成员")
		return
	end
	if not ClsSerDataMgr.GetInstance()._CountryList[CountryId] then
		server.c_tell_fail("【数据错误】 国家已经不存在了")
		return
	end
	
	
	self._UserInfoSet[PersonId].iCountryId = nil
	self._UserInfoSet[PersonId].iOffice = nil 
			
	self:SaveCountryList()
	self:SaveUserInfoSet()
			
	server.c_country_dismiss_person(CountryId, PersonId)
end

s_country_person_list = function(UserId, CountryId)
	if not ClsSerDataMgr.GetInstance()._CountryList[CountryId] then
		server.c_tell_fail("【数据错误】 国家已经不存在了")
		return
	end
	
	local persion_list = {}
	if ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iCountryId == CountryId then
		persion_list[1] = {Uid=UserId, iOffice=ClsSerDataMgr.GetInstance()._UserInfoSet[UserId].iOffice}
	end
	for _, npcinfo in pairs(ClsSerDataMgr.GetInstance()._NpcInfoSet) do
		if npcinfo.iCountryId == CountryId then
			table.insert(persion_list, {Uid=npcinfo.Uid,iOffice=npcinfo.iOffice})
		end
	end
	
	server.c_country_person_list(CountryId, persion_list)
end

s_chg_country_relation = function(UserId, CountryId_1,CountryId_2,iRelation)
	if not ClsSerDataMgr.GetInstance()._CountryList[CountryId_1] or not ClsSerDataMgr.GetInstance()._CountryList[CountryId_2] then
		server.c_tell_fail("指定的国家不存在")
		return
	end
	
	local bExist = false
	for _, info in pairs(ClsSerDataMgr.GetInstance()._CountryRelation) do
		if info.Id1==CountryId_1 and info.Id2==CountryId_2 then
			info.iRelation = iRelation
			bExist = true
			break
		elseif info.Id2==CountryId_2 and info.Id1==CountryId_1 then
			info.iRelation = iRelation
			bExist = true
			break
		end
	end
	if not bExist then
		table.insert(ClsSerDataMgr.GetInstance()._CountryRelation, {Id1=CountryId_1, Id2=CountryId_2, iRelation=iRelation})
	end
	
	ClsSerDataMgr.GetInstance():SaveCountryRelation()
	
	server.c_chg_country_relation(CountryId_1, CountryId_2, iRelation)
end
