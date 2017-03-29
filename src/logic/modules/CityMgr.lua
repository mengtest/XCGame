----------------
-- 城市数据管理
-- 注意CountryData CityData RoleData三者之间的同步
----------------
local clsCityData = class("clsCityData", clsDataFace)

clsCityData:RegSaveVar("Uid", TYPE_CHECKER.INT)					--ID
clsCityData:RegSaveVar("iCountryId", TYPE_CHECKER.INT_NIL)		--所属国
clsCityData:RegSaveVar("iCastellanId", TYPE_CHECKER.INT_NIL)	--城主
clsCityData:RegSaveVar("iCurState", function(value) assert(utils.IsValidCityState(value), "not valid: "..value) end)	--当前状态
clsCityData:RegSaveVar("iWealth", TYPE_CHECKER.INT_NIL)			--财富
clsCityData:RegSaveVar("bOnFired", TYPE_CHECKER.BOOL_NIL)		--着火

local attr_list = { 
	{"sName", TYPE_CHECKER.STRING},
	{"sResPath", TYPE_CHECKER.STRING},
}
clsCityData:InitByClientCfg(setting.T_city_cfg, "Uid", attr_list)

local keylist = { sName=1,sResPath=1 }
function clsCityData:ctor(iUid)
	clsDataFace.ctor(self)
	self:SetUid(iUid)
	self:SetiCurState(0)
end

function clsCityData:dtor()
	
end

function clsCityData:GetCityCfg()
	return setting.T_city_cfg[self:GetUid()]
end

function clsCityData:GetTroopData()
	return KE_Director:GetTroopMgr():GetCityTroopByLeader(self:GetUid())
end

------------------------------------------------------------

clsCityManager = class("clsCityManager", clsCoreObject)
clsCityManager.__is_singleton = true

function clsCityManager:ctor()
	clsCoreObject.ctor(self)
	self.tAllCitys = {}
end

function clsCityManager:dtor()
	
end

function clsCityManager:AddCity(CityId, CityInfo)
	assert(not self.tAllCitys[CityId], string.format("已经添加过该城市：%d",CityId))
	self.tAllCitys[CityId] = self.tAllCitys[CityId] or clsCityData.new(CityId)
	self:UpdateCity(CityId, CityInfo)
end

function clsCityManager:UpdateCity(CityId, Info)
	assert(self.tAllCitys[CityId], "不存在该城市："..CityId)
	if Info.Uid then assert(Info.Uid==CityId, "CityId不一致") end
	if Info.iCountryId then 
		assert(KE_Director:GetCountryMgr():GetCountry(Info.iCountryId), "不存在该国家："..Info.iCountryId) 
	end
	self.tAllCitys[CityId]:BatchSetAttr(Info)
end

--------------------------- getter ------------------------------

function clsCityManager:GetAllCitys()
	return self.tAllCitys
end

function clsCityManager:GetCityData(CityId)
	return self.tAllCitys[CityId]
end

function clsCityManager:GetCitysOfCountry(CountryId)
	local citylist = {}
	for CityId, CityData in pairs(self.tAllCitys) do
		if CityData:GetiCountryId() == CountryId then
			citylist[#citylist+1] = CityData
		end
	end
	return citylist
end
