---------------------
-- 
---------------------
module("const", package.seeall)

--队伍关系
RELATION_NONE = 0		--无关系
RELATION_PARTNER = 1	--伙伴关系
RELATION_ENEMY = 2		--敌对关系

-- 系统分配国家ID
COUNTRY_WEI = 1			--魏
COUNTRY_SHU = 2			--蜀
COUNTRY_WU  = 3			--吴

-- 城堡状态
ST_CITY_SAFE = 0
ST_CITY_SIEGED = 1
ST_CITY_BREAKD = 2
CITY_STATE_CIRCLE = { ST_CITY_SAFE, ST_CITY_SIEGED, ST_CITY_BREAKD }

--部队类型
TROOP_CITY = 1		--城市守军
TROOP_GENERAL = 2	--将军带军
TROOP_SLAVE = 3		--乱军
