----------------
-- VIP协议
----------------
module("rpc", package.seeall)

c_troop_list = function(info_list)
	local InstTroopMgr = KE_Director:GetTroopMgr()
	for _, info in ipairs(info_list) do
		info.MemberList = {}
		for k=1, #info.TypeIdList do
			table.insert(info.MemberList, {info.TypeIdList[k],info.CountList[k]})
		end
		info.TypeIdList = nil
		info.CountList = nil
		
		if info.TroopType == const.TROOP_CITY then
			InstTroopMgr:UpdateCityTroop(info.Uid, info)
		elseif info.TroopType == const.TROOP_GENERAL then
			InstTroopMgr:UpdateGeneralTroop(info.Uid, info)
		elseif info.TroopType == const.TROOP_SLAVE then
			InstTroopMgr:UpdateSlaveTroop(info.Uid, info)
		end
	end
end

c_add_troop = function(TroopId, TroopType, Info)
	if TroopType == const.TROOP_CITY then
		KE_Director:GetTroopMgr():UpdateCityTroop(TroopId, Info)
	elseif TroopType == const.TROOP_GENERAL then
		KE_Director:GetTroopMgr():UpdateGeneralTroop(TroopId, Info)
	elseif TroopType == const.TROOP_SLAVE then
		KE_Director:GetTroopMgr():UpdateSlaveTroop(TroopId, Info)
	end
end

c_update_troop = function(TroopId, TroopType, Info)
	if TroopType == const.TROOP_CITY then
		KE_Director:GetTroopMgr():UpdateCityTroop(TroopId, Info)
	elseif TroopType == const.TROOP_GENERAL then
		KE_Director:GetTroopMgr():UpdateGeneralTroop(TroopId, Info)
	elseif TroopType == const.TROOP_SLAVE then
		KE_Director:GetTroopMgr():UpdateSlaveTroop(TroopId, Info)
	end
end

c_del_troop = function(TroopId)
	KE_Director:GetTroopMgr():DelSlaveTroop(TroopId)
end
