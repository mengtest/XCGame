module("server", package.seeall)

ClsSerDataMgr = class("ClsSerDataMgr")
ClsSerDataMgr.__is_singleton = true

function ClsSerDataMgr:ctor()
	self._UserInfoSet = table.force_load( string.format("%s/UserList.lua", GetServerWritablePath()) )
end

function ClsSerDataMgr:dtor()

end

function ClsSerDataMgr:OnUserLogin(UserId)
	-- 加载数据
	self._CountryList = table.force_load( string.format("%s/CountryList.lua", GetServerPrivatePath()) )
	self._CityList = table.force_load( string.format("%s/CityList.lua", GetServerPrivatePath()) )
	self._NpcInfoSet = table.force_load( string.format("%s/NpcInfoSet.lua", GetServerPrivatePath()) )
	self._StageSet = table.force_load( string.format("%s/StageSet.lua", GetServerPrivatePath()) )
	self._TroopList = table.force_load( string.format("%s/TroopList.lua", GetServerPrivatePath()) )
	self._ItemList = table.force_load( string.format("%s/ItemList.lua", GetServerPrivatePath()) )
	self._SignInfoList = table.force_load( string.format("%s/SigninList.lua", GetServerPrivatePath()) )
	self._CountryRelation = table.force_load( string.format("%s/CountryRelation.lua", GetServerPrivatePath()) )
	-- 检查数据
	self:_check_datas()
end


-- 主要是因为三者之间有些数据必须同步，这里做数据是否同步的检测
function ClsSerDataMgr:_check_datas()
	for id, Country in pairs(self._CountryList) do
		assert(id==Country.Uid, "以CountryId为键")
	end
	--
	for _, info in pairs(self._UserInfoSet) do
		if info.iOffice then
			assert(info.iCountryId, "有官职没所属国怎么行")
		end
		if info.iCountryId then
			assert(self._CountryList[info.iCountryId], "角色所属国不存在")
		end
	end
	--
	for cityid, cityinfo in pairs(self._CityList) do
		assert(cityinfo.Uid == cityid, "cityid不一致")
		if cityinfo.iCountryId then
			assert(self._CountryList[cityinfo.iCountryId], "城堡所属国不存在")
		end
	end
end

function ClsSerDataMgr:SaveUserInfoSet()
	table.save( self._UserInfoSet, string.format("%s/UserList.lua", GetServerWritablePath()) )
end
function ClsSerDataMgr:SaveCountryList()
	table.save( self._CountryList, string.format("%s/CountryList.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveCityList()
	table.save( self._CityList, string.format("%s/CityList.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveNpcInfoSet()
	table.save( self._NpcInfoSet, string.format("%s/NpcInfoSet.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveItemList()
	table.save( self._ItemList, string.format("%s/ItemList.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveSigninList()
	table.save( self._SignInfoList, string.format("%s/SigninList.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveStageSet()
	table.save( self._StageSet, string.format("%s/StageSet.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveTroopList()
	table.save( self._StageSet, string.format("%s/TroopList.lua", GetServerPrivatePath()) )
end
function ClsSerDataMgr:SaveCountryRelation()
	table.save( self._CountryRelation, string.format("%s/CountryRelation.lua", GetServerPrivatePath()) )
end


function ClsSerDataMgr:GetUserInfoSet()
	return self._UserInfoSet
end

function ClsSerDataMgr:GetUserInfoByUsername(username)
	for userid, info in pairs(self._UserInfoSet) do
		if info.UserName == username then
			return info
		end
	end
	return nil 
end

function ClsSerDataMgr:GetCountryByName(sName)
	for _, CountryInfo in pairs(self._CountryList) do
		if CountryInfo.sName == sName then
			return CountryInfo
		end
	end
	return nil 
end

