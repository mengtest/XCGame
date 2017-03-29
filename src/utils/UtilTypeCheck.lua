----------------------
-- 辅助库
----------------------
module("utils", package.seeall)

local ValidIdList = {
	[const.ORDER_MAP_LAYER] = true,
	[const.ORDER_UI_LAYER] = true,
	[const.LAYER_LAND] = true,
	[const.LAYER_OBJ] = true,
	[const.LAYER_WEATHER] = true,
	[const.LAYER_PANEL] = true,
	[const.LAYER_POP] = true,
	[const.LAYER_TIPS] = true,
	[const.LAYER_DLG] = true,
	[const.LAYER_GUIDE] = true,
	[const.LAYER_LOADING] = true,
	[const.LAYER_CLICKEFF] = true,
	[const.LAYER_WAITING] = true,
	[const.LAYER_TOPEST] = true,
}
function IsValidGameLayerId(iLayerId)
	return iLayerId and ValidIdList[iLayerId]
end

local VALID_ANI_NAMES = { 
	[const.ANI_IDLE] = true, 
	[const.ANI_WALK] = true, 
	[const.ANI_RUN] = true,	
	[const.ANI_JUMP] = true, 
	[const.ANI_ATTACK_1] = true, 
	[const.ANI_ATTACK_2] = true, 
	[const.ANI_ATTACK_3] = true, 
	[const.ANI_SKILL_1] = true, 
	[const.ANI_SKILL_2] = true, 
	[const.ANI_SKILL_3] = true, 
	[const.ANI_SKILL_4] = true, 
	[const.ANI_SKILL_5] = true, 
	[const.ANI_SKILL_6] = true, 
	[const.ANI_HIT] = true,	
	[const.ANI_DIE] = true, 
	[const.ANI_DEF] = true, 
	[const.ANI_WIN] = true, 
	[const.ANI_ABN] = true,
	[const.ANI_FLIGHT_UP] = true, 
	[const.ANI_FLIGHT_DOWN] = true,
}
function IsValidAniName(sAniName)
	return VALID_ANI_NAMES[sAniName]
end


function IsValidCombatType(sCombatType)
	for _, v in pairs(const.COMBAT_TYPE) do
		if sCombatType == v then return true end
	end
	return false
end

local VALID_TROOP_TYPES = {
	[const.TROOP_CITY] 		= true,
	[const.TROOP_GENERAL] 	= true,
	[const.TROOP_SLAVE] 	= true,
}
function IsValidTroopType(iTroopType)
	return VALID_TROOP_TYPES[iTroopType]
end

function IsValidCityState(iState)
	for _, v in pairs(const.CITY_STATE_CIRCLE) do
		if iState == v then return true end
	end
	return false 
end

function IsValidCareer(iCareer)
	return iCareer==const.CAREER_TYPE_1 or iCareer==const.CAREER_TYPE_2 or iCareer==const.CAREER_TYPE_3 or iCareer==const.CAREER_TYPE_4
end

function IsValidFlagId(iFlagId)
	return setting.T_flag_cfg[iFlagId] ~= nil
end
