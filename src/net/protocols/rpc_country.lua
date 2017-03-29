----------------
-- 国家协议
----------------
module("rpc", package.seeall)

c_country_list = function(CountryInfoList)
	for _, info in pairs(CountryInfoList) do
		KE_Director:GetCountryMgr():AddCountry(info.Uid, info)
	end
end

c_build_country = function(CountryId, CountryInfo)
	KE_Director:GetCountryMgr():AddCountry(CountryId, CountryInfo)
end

c_country_add_person = function(CountryId, PersonInfo)
	KE_Director:GetCountryMgr():AddPerson(CountryId, PersonInfo)
end

c_country_dismiss_person = function(CountryId, PersonId)
	KE_Director:GetCountryMgr():RemovePerson(CountryId, PersonId)
end

c_person_leave_country = function(CountryId, PersonId)
	KE_Director:GetCountryMgr():RemovePerson(CountryId, PersonId)
end

c_country_person_list = function(CountryId, PersonInfoList)
	local InstCountryMgr = KE_Director:GetCountryMgr()

	for _, info in pairs(PersonInfoList) do
		InstCountryMgr:AddPerson(CountryId, info)
	end
	
	KE_Director:GetCountryMgr():FireEvent("e_update_country", CountryId)
end


c_country_relation_list = function(RelationDescList)
	local InstCountryMgr = KE_Director:GetCountryMgr()
	for _, info in ipairs(RelationDescList) do
		InstCountryMgr:SetCountryRelation(info.Id1,info.Id2,info.iRelation)
	end
end

c_chg_country_relation = function(CountryId_1,CountryId_2,iRelation)
	local InstCountryMgr = KE_Director:GetCountryMgr()
	InstCountryMgr:SetCountryRelation(CountryId_1,CountryId_2,iRelation)
end
