---------------------
-- 
---------------------
module("const", package.seeall)

--战斗类型
COMBAT_TYPE = {
	["CITY_SIEGE"] = 1,		--攻城战: 3-1 围攻
	["CITY_BREAK"] = 2,		--攻城战：3-2 破城
	["CITY_CLAIM"] = 3,		--攻城战：3-3 破将
	["STAGE"] = 4,			--闯关战
	["ARENA"] = 5,			--竞技场
	["ROUND"] = 6,			--回合战
}

--战斗配置 
--@param    MAX_GENERAL    最大上阵将领数
COMBAT_CFG = {
	[COMBAT_TYPE.CITY_SIEGE] = { MAX_GENERAL = 3 },
	[COMBAT_TYPE.CITY_BREAK] = { MAX_GENERAL = 3 },
	[COMBAT_TYPE.CITY_CLAIM] = { MAX_GENERAL = 3 },
	[COMBAT_TYPE.STAGE]		 = { MAX_GENERAL = 3 },
	[COMBAT_TYPE.ARENA]		 = { MAX_GENERAL = 0 },
	[COMBAT_TYPE.ROUND]		 = { MAX_GENERAL = 4 },
}

--战斗结束原因
REASON_CLICK_QUIT = 1		--点击退出按钮
REASON_RESULT = 2			--胜负已分
REASON_TIMEOUT = 3			--超时

--关卡类型
STAGE_NORMAL = 1		--普通
STAGE_HARD = 2			--困难
STAGE_PURGATORY = 3		--炼狱
