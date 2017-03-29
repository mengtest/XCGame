------------------
-- 配置表
------------------
module("setting", package.seeall)

function Get(sFilePath)
	return io.SafeLoadFile(sFilePath)
end

function ReLoad(sFilePath)
	UnLoad(sFilePath)
	return self:Get(sFilePath)
end

function UnLoad(sFilePath)
	package.loaded[sFilePath] = nil
end

----------------------------------------------------------------------------------

T_multy_language = setting.Get("src/data/T_multy_language.lua")
T_system_cfg = setting.Get("src/data/logic_cfgs/T_system_cfg.lua")
T_flag_cfg = setting.Get("src/data/T_flag_cfg.lua")
T_city_cfg = setting.Get("src/data/city_cfgs/T_city_cfg.lua")
T_stage_cfg = setting.Get("src/data/stage/T_stage_cfg.lua")
T_head_cfg = setting.Get("src/data/T_head_cfg.lua")
T_skill_cfg = setting.Get("src/data/skill_data/T_skill_cfg.lua")
T_aabb_effects = setting.Get("src/data/aabb/T_aabb_effects.lua")
T_aabb_roles = setting.Get("src/data/aabb/T_aabb_roles.lua")
T_npc_cfg = setting.Get("src/data/card_cfg/T_npc_cfg.lua")
T_recruit_cfg = setting.Get("src/data/card_cfg/T_recruit_cfg.lua")
T_filter_cfg = setting.Get("src/data/T_filter_cfg.lua")
T_levelup_cfg = setting.Get("src/data/card_cfg/T_levelup_cfg.lua")
T_guide_cfg = setting.Get("src/data/guide_cfg/T_guide_cfg.lua")
T_attr_name_map = setting.Get("src/data/T_attr_name_map.lua")
T_buff = setting.Get("src/data/combat/T_buff.lua")
T_advertise = setting.Get("src/data/T_advertise.lua")
	T_item_equip_cfg = setting.Get("src/data/item_cfg/T_item_equip_cfg.lua")
	T_item_soulstone_cfg = setting.Get("src/data/item_cfg/T_item_soulstone_cfg.lua")
	T_item_stone_cfg = setting.Get("src/data/item_cfg/T_item_stone_cfg.lua")
T_item_cfg = table.union({T_item_equip_cfg, T_item_soulstone_cfg, T_item_stone_cfg})
	T_card_general = setting.Get("src/data/card_cfg/T_card_general.lua")
	T_card_hero = setting.Get("src/data/card_cfg/T_card_hero.lua")
	T_card_soldier = setting.Get("src/data/card_cfg/T_card_soldier.lua")
T_card_cfg = table.union( {T_card_hero, T_card_general, T_card_soldier} )

----------------------------------------------------------------------------------

------------------
-- 多语言
------------------
local language_map = {}
for id, text in pairs(T_multy_language) do
	assert( not language_map[text], "有重复" )
	language_map[text] = id
end
assert(table.size(language_map)==table.size(T_multy_language), "多语言表有重复")
language_map = nil

------------------
--BUFF 
------------------
function GetBuffInfoByName(BuffName)
	if not setting.BUFF_CFG_BY_NAME then
		setting.BUFF_CFG_BY_NAME = {}
		for BuffId, BuffInfo in pairs(T_buff.BuffInfoTbl) do
			setting.BUFF_CFG_BY_NAME[BuffInfo.BuffName] = BuffInfo
		end
	end
	return setting.BUFF_CFG_BY_NAME[BuffName]
end

function GetBuffIdByName(BuffName)
	local BuffInfo = GetBuffInfoByName(BuffName)
	return BuffInfo.id
end

------------------
-- 经验与等级
------------------
function GetMaxGrade()
	return #T_levelup_cfg
end

function GetGradeByExp(CurExp)
	for lvl, info in ipairs(T_levelup_cfg) do
		if CurExp < info.NeedExp then
			return CurExp - 1
		end
	end
	return #T_levelup_cfg
end

------------------
--物品
------------------
function GetItemImgPath(ItemType)
	return T_item_cfg[ItemType].sResPath
end

function GetItemKind(ItemType)
	return T_item_cfg[ItemType].ItemKind
end

function GetItemQuality(ItemType)
	return T_item_cfg[ItemType].Quality
end

function GetItemCfgByName(sName)
	if not setting.ITEM_BY_NAME then
		local ITEM_BY_NAME = {}
		for _, info in pairs(setting.T_item_cfg) do
			ITEM_BY_NAME[info.sName] = info
		end
		setting.ITEM_BY_NAME = ITEM_BY_NAME
	end
	return setting.ITEM_BY_NAME[sName]
end

function GetItemTypeByName(sName)
	local Cfg = GetItemCfgByName(sName)
	return Cfg and Cfg.ItemType
end

------------------
--技能
------------------
local ALL_SKILL_PLAY_INFO = {}
function GetSkillPlayInfo(iSkillId)
	ALL_SKILL_PLAY_INFO[iSkillId] = ALL_SKILL_PLAY_INFO[iSkillId] or setting.Get(string.format("src/data/skill_data/T_skill_%d.lua", iSkillId))
	return ALL_SKILL_PLAY_INFO[iSkillId]
end

local SKILL_RANGE_INFO = {}
function GetSkillRange(iSkillId)
	if SKILL_RANGE_INFO[iSkillId] then 
		return SKILL_RANGE_INFO[iSkillId][1]
	end
	
	local minRange
	local maxRange
	local curRange
	local playinfo = GetSkillPlayInfo(iSkillId)
	
	for _, info in pairs(playinfo) do
		if info.cmdName == "v_role_sprint" then
			--50实际上应该为特效的攻击范围半径
			curRange = info.args.dis + 50
		elseif info.cmdName == "v_add_missile" then
			local tTrackCfg = info.args.cfg_info.tTrackCfg
			local MissileType = tTrackCfg.sTrackType
			
			if MissileType == "clsMissileStatic" then
				--50实际上应该为特效的攻击范围半径 
				curRange = tTrackCfg.iDis + 50
			elseif MissileType == "clsMissileTrack" then
				--50实际上应该为特效的攻击范围半径
				--3实际上应该为特效的生命周期
				curRange = tTrackCfg.iMoveSpeed * GAME_CONFIG.FPS * 3 + 50
			elseif MissileType == "clsMissileLine" then
				--50实际上应该为特效的攻击范围半径
				curRange = tTrackCfg.iMoveDis + 50
			elseif MissileType == "clsMissileParabola" then
				--50实际上应该为特效的攻击范围半径
				curRange = tTrackCfg.iMoveDis + 50
			elseif MissileType == "clsMissilePossessed" then
				--100实际上应该为特效的攻击范围半径
				curRange = 100
			end
		else 
			--100实际上应该为特效的攻击范围半径
			curRange = 100
		end
		
		minRange = minRange and math.min(curRange, minRange) or curRange
		maxRange = maxRange and math.max(curRange, maxRange) or curRange
	end
	
	SKILL_RANGE_INFO[iSkillId] = { math.ceil((minRange + maxRange)/2), minRange, maxRange }
	
	return SKILL_RANGE_INFO[iSkillId][1]
end

------------------
--城堡
------------------
local NAME_2_CITY = {} 
for _, Info in pairs(T_city_cfg) do 
	assert(not NAME_2_CITY[Info.sName], "城市名重复："..Info.sName)
	NAME_2_CITY[Info.sName] = Info 
end
function GetCityCfgByName(CityName)
	return NAME_2_CITY[CityName]
end

------------------
--场景地图
------------------
function GetSceneMapCfg(MapId)
	local filepath = string.format("src/data/scenemap_cfgs/%d.lua", MapId)
	return setting.Get(filepath)
end

------------------
--剧情
------------------
function GetStoryCfg(sStoryName)
	local filepath = string.format("src/data/storys/%s.lua", sStoryName)
	return setting.Get(filepath)
end

------------------
--NPC 
------------------
function GetTotalNpc()
	setting.NPC_TOTAL = setting.NPC_TOTAL or table.size(T_npc_cfg)
	return setting.NPC_TOTAL
end

------------------
--卡牌
------------------
function GetCardGeneralCfg()
	return T_card_general
end

function GetCardInfoByName(sName)
	if not setting.CARD_INFO_BY_NAME then
		setting.CARD_INFO_BY_NAME = {}
		for TypeId, Info in pairs(setting.T_card_cfg) do
			setting.CARD_INFO_BY_NAME[Info.sName] = Info
		end
	end
	return setting.CARD_INFO_BY_NAME[sName]
end

function GetCardInfosByMotherLand(iMotherland)
	if not setting.CARDS_BY_MOTHERLAND then
		setting.CARDS_BY_MOTHERLAND = {}
		for TypeId, Info in pairs(setting.T_card_cfg) do
			local motherland = Info.iMotherland
			if motherland then
				setting.CARDS_BY_MOTHERLAND[motherland] = setting.CARDS_BY_MOTHERLAND[motherland] or {}
				setting.CARDS_BY_MOTHERLAND[motherland][TypeId] = Info
			end
		end
	end
	return setting.CARDS_BY_MOTHERLAND[iMotherland]
end

------------------
--关卡
------------------
local function _GetStageInfoById(StageId)
	if not setting.STAGE_CFG_BY_ID then
		setting.STAGE_CFG_BY_ID = {}
		for stageType, infoList in pairs(T_stage_cfg) do
			for _, stageInfo in ipairs(infoList) do
				assert( not setting.STAGE_CFG_BY_ID[stageInfo.StageId], string.format("关卡ID有重复：%d",stageInfo.StageId) )
				setting.STAGE_CFG_BY_ID[stageInfo.StageId] = stageInfo
			end
		end
	end
	return setting.STAGE_CFG_BY_ID[StageId]
end

function GetStageInfoById(StageId)
	local info = _GetStageInfoById(StageId)
	assert(info, "缺少配置："..StageId)
	return info
end

function GetPreStage(CurStageId)
	if not _GetStageInfoById(CurStageId) then return nil end
	if _GetStageInfoById(CurStageId-1) then return CurStageId-1 end
	
	local StageInfo = setting.GetStageInfoById(CurStageId)
	local StageType = StageInfo.StageType
	local infolist = setting.T_stage_cfg[StageType]

	local preStage
	for _, info in ipairs(infolist) do
		if CurStageId == info.StageId then
			break
		end
		preStage = info.StageId
	end
	return preStage
end

function GetNextStage(CurStageId)
	if not _GetStageInfoById(CurStageId) then return nil end
	if _GetStageInfoById(CurStageId+1) then return CurStageId+1 end
	
	local StageInfo = setting.GetStageInfoById(CurStageId)
	local StageType = StageInfo.StageType
	local infolist = setting.T_stage_cfg[StageType]

	local nextStage
	for _, info in ipairs(infolist) do
		if nextStage then
			nextStage = info.StageId
			break
		end
		if CurStageId == info.StageId then
			nextStage = CurStageId
		end
	end
	return nextStage
end
