----------------
-- 国家管理器
-- 注意CountryData CityData RoleData三者之间的同步
----------------
local clsCountryData = class("clsCountryData", clsDataFace)

clsCountryData:RegSaveVar("Uid", TYPE_CHECKER.INT)				--ID
clsCountryData:RegSaveVar("sName", TYPE_CHECKER.STRING)			--国名
clsCountryData:RegSaveVar("iFlagId", function(v) assert(utils.IsValidFlagId(v)) end)	--旗帜
clsCountryData:RegSaveVar("iKingId", TYPE_CHECKER.INT_NIL)		--国王
clsCountryData:RegSaveVar("tPersonList", TYPE_CHECKER.TABLE)	--臣民

function clsCountryData:ctor(iUid)
	clsDataFace.ctor(self)
	self:SetUid(iUid)
	self:SettPersonList({})
end

function clsCountryData:dtor()
	
end

------------------------------------------------------------

clsCountryManager = class("clsCountryManager", clsCoreObject)
clsCountryManager.__is_singleton = true

clsCountryManager:RegisterEventType("e_add_country")
clsCountryManager:RegisterEventType("e_del_country")
clsCountryManager:RegisterEventType("e_update_country")
clsCountryManager:RegisterEventType("e_person_join_country")
clsCountryManager:RegisterEventType("e_person_leave_country")
clsCountryManager:RegisterEventType("e_country_relation_chg")

function clsCountryManager:ctor()
	clsCoreObject.ctor(self)
	
	self.tAllCountrys = {}
	self.tCountryRelation = {}
end

function clsCountryManager:dtor()
	
end

-- 设置国家关系
function clsCountryManager:SetCountryRelation(CountryId_1, CountryId_2, Relation)
	assert(CountryId_1 and CountryId_2)
	self.tCountryRelation[CountryId_1] = self.tCountryRelation[CountryId_1] or { tEnemyList={},tFriendList={} }
	self.tCountryRelation[CountryId_2] = self.tCountryRelation[CountryId_2] or { tEnemyList={},tFriendList={} }
	
	if Relation == const.RELATION_ENEMY then 
		self.tCountryRelation[CountryId_1].tEnemyList[CountryId_2] = true
		self.tCountryRelation[CountryId_2].tEnemyList[CountryId_1] = true
		self.tCountryRelation[CountryId_1].tFriendList[CountryId_2] = nil
		self.tCountryRelation[CountryId_2].tFriendList[CountryId_1] = nil
	elseif Relation == const.RELATION_PARTNER then
		self.tCountryRelation[CountryId_1].tEnemyList[CountryId_2] = nil
		self.tCountryRelation[CountryId_2].tEnemyList[CountryId_1] = nil
		self.tCountryRelation[CountryId_1].tFriendList[CountryId_2] = true
		self.tCountryRelation[CountryId_2].tFriendList[CountryId_1] = true
	elseif Relation == const.RELATION_NONE then
		self.tCountryRelation[CountryId_1].tEnemyList[CountryId_2] = nil
		self.tCountryRelation[CountryId_2].tEnemyList[CountryId_1] = nil
		self.tCountryRelation[CountryId_1].tFriendList[CountryId_2] = nil
		self.tCountryRelation[CountryId_2].tFriendList[CountryId_1] = nil
	else 
		assert(false)
	end
	
	self:FireEvent("e_country_relation_chg", CountryId_1, CountryId_2, Relation)
end
-- 获取国家关系
function clsCountryManager:GetCountryRelation(CountryId_1, CountryId_2)
	if not self.tCountryRelation[CountryId_1] then return const.RELATION_NONE end
	
	if self.tCountryRelation[CountryId_1].tEnemyList[CountryId_2] then
		return const.RELATION_ENEMY
	elseif self.tCountryRelation[CountryId_1].tFriendList[CountryId_2] then
		return const.RELATION_PARTNER
	else 
		return const.RELATION_NONE
	end
end


--成立国家
function clsCountryManager:AddCountry(CountryId, CountryInfo)
	if CountryInfo.Uid then assert(CountryInfo.Uid == CountryId, "Uid不一致") end
	assert(not self.tAllCountrys[CountryId], "已经建立国家："..CountryId)
	assert(not self:GetCountryByName(CountryInfo.sName), "名字已被占用："..CountryInfo.sName)
	assert(CountryInfo.iKingId, "新建的国家必定有国王")
	
	self.tAllCountrys[CountryId] = self.tAllCountrys[CountryId] or clsCountryData.new(CountryId)
	self.tAllCountrys[CountryId]:BatchSetAttr(CountryInfo)
	
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(CountryInfo.iKingId)
	if RoleData then
		RoleData:SetiCountryId(CountryId)
	end
	
	self:FireEvent("e_add_country", CountryId)
end

--解散国家
function clsCountryManager:DelCountry(CountryId)
	if not self.tAllCountrys[CountryId] then 
		utils.TellMe("该国家不存在")
		return 
	end
	
	--
	local AllRoleData = KE_Director:GetRoleDataMgr():GetAllData()
	for _, RoleData in pairs(AllRoleData) do
		if RoleData:GetiCountryId() == CountryId then
			RoleData:SetiCountryId(nil)
			RoleData:SetiOffice(nil)
		end
	end
	
	--
	local citylist = KE_Director:GetCityMgr():GetAllCitys()
	for _, CityData in pairs(citylist) do
		if CityData:GetiCountryId() == CountryId then
			CityData:SetiCountryId(nil)
		end
	end
	
	--
	KE_SafeDelete(self.tAllCountrys[CountryId])
	self.tAllCountrys[CountryId] = nil
	
	self:FireEvent("e_del_country", CountryId)
end

--添加成员
-- PersonInfo = { Uid = 1,iOffice = const.OFFICE_SOLDIER }
function clsCountryManager:AddPerson(CountryId, PersonInfo)
	if not self.tAllCountrys[CountryId] then
		assert(false, "不存在该国家："..CountryId)
		return 
	end
	
	local personId = PersonInfo.Uid
	assert(personId, "参数错误：PersonInfo.Uid不可为空")
	local PersonList = self.tAllCountrys[CountryId]:GettPersonList()
	PersonList[personId] = PersonList[personId] or {}
	local Info = PersonList[personId]
	for k,v in pairs(PersonInfo) do
		Info[k] = v
	end
	self.tAllCountrys[CountryId]:SettPersonList(PersonList)
	
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(personId)
	if RoleData then
		RoleData:SetiCountryId(CountryId)
		RoleData:SetiOffice(PersonInfo.iOffice)
	end
	
	self:FireEvent("e_update_country", CountryId)
	self:FireEvent("e_person_join_country", PersonInfo, CountryId)
end

-- 移除成员
function clsCountryManager:RemovePerson(CountryId, PersonId)
	self.tAllCountrys[CountryId]:GettPersonList()[PersonId] = nil
	
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(PersonId)
	if RoleData then
		RoleData:SetiCountryId(nil)
		RoleData:SetiOffice(nil)
	end
	
	self:FireEvent("e_update_country", CountryId)
	self:FireEvent("e_person_leave_country", PersonId, CountryId)
end

----------------------- getter -------------------------------

function clsCountryManager:GetCountryList()
	return self.tAllCountrys
end

function clsCountryManager:GetCountry(CountryId)
	return self.tAllCountrys[CountryId]
end

function clsCountryManager:GetCountryIdOfPerson(PersonId)
	for CountryId, CountryData in pairs(self.tAllCountrys) do
		if CountryData:GettPersonList()[PersonId] then
			return CountryId
		end
	end
	return nil
end

function clsCountryManager:GetCountryByName(sCountryName)
	for CountryId, CountryData in pairs(self.tAllCountrys) do
		if CountryData:GetsName() == sCountryName then
			return CountryData
		end
	end
	return nil
end

function clsCountryManager:GetMyCountryId()
	local HeroData = KE_Director:GetHeroData()
	return HeroData and HeroData:GetiCountryId()
end

function clsCountryManager:GetMyCountryData()
	return self.tAllCountrys[self:GetMyCountryId()]
end
