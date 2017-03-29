-------------
-- API中心
-------------
module("api", package.seeall)

-- 条件API
local CONDITION_API = {
	["cond_item_amount"] = function(itemname, count)
		local itemtype = setting.GetItemTypeByName(itemname)
		assert(itemtype, string.format("未找到物品名为【%s】的配置，请检查物品配置表",itemname))
		local curAmount = KE_Director:GetItemMgr():GetItemAmountByType(itemtype)
		return curAmount >= count		--, count, curAmount
	end,
	["cond_money"] = function(count)
		local curMoney = KE_Director:GetHeroData():GetiMoney()
		return curMoney >= count		--, count, curMoney
	end,
	["cond_diamond"] = function(count)
		local curDiamond = KE_Director:GetHeroData():GetiDiamond()
		return curDiamond >= count		--, count, curDiamond
	end,
	["cond_grade"] = function(grade)
		local curGrade = KE_Director:GetHeroData():GetiGrade()
		return curGrade >= grade		--, grade, curGrade
	end,
	["cond_prestige"] = function(prestige)
		local curPrestige = KE_Director:GetHeroData():GetiPrestige()
		return curPrestige >= prestige	--, prestige, curPrestige
	end,
	["cond_vip_level"] = function(level)
		local curVipLevel = KE_Director:GetHeroData():GetiVipLevel()
		return curVipLevel >= level		--, level, curVipLevel
	end,
	["cond_leadership"] = function(level)
		local curLeadership = KE_Director:GetHeroData():GetiLeadership()
		return curLeadership >= level	--, level, curVipLevel
	end,
	["cond_entered_country"] = function()
		return KE_Director:GetHeroData():GetiCountryId() ~= nil
	end,
}


function CheckConditions(CondList)
	if not CondList then return true end
	
	if table.is_array(CondList) then
		return CheckConditionList(CondList)
	else
		return CheckConditionTbl(CondList)
	end
end

function CheckConditionTbl(CondList)
	if not CondList then return true end
	
	for api_name, arglist in pairs(CondList) do
		assert(CONDITION_API[api_name], "无效的API接口："..api_name)
		if not CONDITION_API[api_name](unpack(arglist)) then
			return false
		end
	end
	return true
end

function CheckConditionList(CondList)
	if not CondList then return true end
	
	for _, info in ipairs(CondList) do
		local api_name, arglist = info[1], info[2]
		assert(CONDITION_API[api_name], "无效的API接口："..api_name)
		if not CONDITION_API[api_name](unpack(arglist)) then
			return false
		end
	end
	return true
end
