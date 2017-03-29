----------------
-- 城堡协议
----------------
module("rpc", package.seeall)

c_city_list = function(CityInfoList)
	for _, info in pairs(CityInfoList) do
		KE_Director:GetCityMgr():AddCity(info.Uid, info)
	end
end

c_update_city = function(CityId, Info)
	KE_Director:GetCityMgr():UpdateCity(CityId, Info)
end
