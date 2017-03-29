---------------------
-- 
---------------------
module("const", package.seeall)

-- 角色ID范围
TEMP_ROLE_ID		= -1
NPC_ID_BEGIN 		= 1000001
NPC_ID_END 			= 9999999
MONSTER_ID_BEGIN 	= 10000001
MONSTER_ID_END 		= 999999999
PLAYER_ID_BEGIN 	= 1000000001
PLAYER_ID_END 		= 2147483647
MAX_ROLE_ID = 2147483648  --2的31次方

-- 角色跳跃常量
JMP_HEIGHT = 180
JMP_SPEED = 20 
FLIGHT_SPEED = 20

-- 模型动作名集合
ANI_IDLE 		= "stand"			--站立
ANI_WALK 		= "walk"			--走
ANI_RUN 		= "run"				--跑
ANI_JUMP 		= "jump"			--跳
ANI_ATTACK_1 	= "skill_0_1"		--攻击
ANI_ATTACK_2 	= "skill_0_2"		--攻击
ANI_ATTACK_3 	= "skill_0_3"		--攻击
ANI_SKILL_1 	= "skill_1"			--施法
ANI_SKILL_2 	= "skill_2"			--施法
ANI_SKILL_3 	= "skill_3"			--施法
ANI_SKILL_4 	= "skill_4"			--施法
ANI_SKILL_5 	= "skill_5"			--施法
ANI_SKILL_6 	= "skill_6"			--施法
ANI_HIT 		= "hit"				--受击
ANI_DIE 		= "die"				--死亡
ANI_DEF			= "def"				--防御
ANI_WIN			= "win"				--赢
ANI_ABN			= "abn"				--眩晕
ANI_FLIGHT_UP	= "flight_up"		--
ANI_FLIGHT_DOWN	= "flight_down"		--

--模型身体组成部分
BODY_PART = {
	["HAIR"] 	= 1,		--头发
	["HEAD"] 	= 2,		--头
	["BODY"] 	= 3,		--躯干
	["JIAN"] 	= 4,		--肩膀
	["L_HAND"] 	= 5,		--左手
	["R_HAND"] 	= 6,		--右手
	["L_LEG"] 	= 7,		--左脚
	["R_LEG"] 	= 8,		--右脚
	["TAIL"] 	= 10,		--尾巴
}

-- 性别分类
SEX_TYPE = {
	["MAIL"]   = 1,		--男
	["FEMAIL"] = 2,		--女
	["EUNUCH"] = 0,		--中性
}

-- 角色类型
ROLE_TYPE = {
	["TP_UNKNOWN"] 		= 0,		--
	["TP_HERO"] 		= 1,		--主角
	["TP_PLAYER"] 		= 2,		--玩家
	["TP_NPC"] 			= 3,		--NPC
	["TP_MONSTER"] 		= 4,		--怪物
}


-- 最大卡牌星级
MIN_CARD_STARLV = 1
MAX_CARD_STARLV = 5

-- 职业分类
CAREER_TYPE_1 = 1
CAREER_TYPE_2 = 2
CAREER_TYPE_3 = 3
CAREER_TYPE_4 = 4

-- 官职
OFFICE_KING = 1
OFFICE_GENERAL = 2
OFFICE_SOLDIER = 3
OFFICE_NULL	= 0

-- 官职命名
OFFICE_TYPE_2_NAME = {
	[OFFICE_KING] 		= "国王",
	[OFFICE_GENERAL] 	= "将领",
	[OFFICE_SOLDIER] 	= "兵卒",
	[OFFICE_NULL]		= "",
}

--兵种分类
FIGHTER_GENERALNPC	= 0		--将帅(NPC)
FIGHTER_ELING		= 1		--恶灵
FIGHTER_BUBING 		= 2		--步兵
FIGHTER_GONGBING 	= 3		--弓兵
FIGHTER_QIBING 		= 4		--骑兵
FIGHTER_SHUIBING 	= 5		--水兵
FIGHTER_ARTILLERY	= 6		--炮兵

-- 兵种命名
FIGHTER_TYPE_2_CNNAME = {
	[FIGHTER_GENERALNPC]	= "将帅",
	[FIGHTER_ELING]			= "恶灵",
	[FIGHTER_BUBING] 		= "步兵",
	[FIGHTER_GONGBING] 		= "弓兵",
	[FIGHTER_QIBING] 		= "骑兵",
	[FIGHTER_SHUIBING] 		= "水兵",
	[FIGHTER_ARTILLERY]		= "炮兵",
}

-- 最大技能索引
MAX_SKILL_INDEX = 5

-- 技能系
-- 金 火 雷 冰 木 土 风
