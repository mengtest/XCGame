---------------------
-- 
---------------------
module("const", package.seeall)

--币种
CURRENCY_TYPE = {
	MONEY = 1,		--金币
	DIAMOND = 2		--钻石
}

--品质描述
QUALITY_CFG = {
	[0] = { color=0xff666666, desc="灰" },
	[1] = { color=0xffffffff, desc="白" },
	[2] = { color=0xff00ff00, desc="绿" },
	[3] = { color=0xff0000ff, desc="蓝" },
	[4] = { color=0xffffffff, desc="紫" },
	[5] = { color=0xffffffff, desc="金" },
}

--物品种类
ITEMKIND_CMP = {
	["装备"] = 1,
	["消耗品"] = 2,
	["宝石"] = 3,
	["材料"] = 4,
	["灵魂石"] = 5,
}

-- 装备
EQUIP_PART = {
	["HAT"] 	= "HAT",			--头盔
	["ARMOUR"]	= "ARMOUR",			--铠甲
	["SHOES"] 	= "SHOES",			--战靴
	["WEAPON"] 	= "WEAPON",			--武器
	["LEGBAND"] = "LEGBAND",		--护腿
	["ARMBAND"]	= "ARMBAND",		--护腕
}

-- 饰品
ACCESSORIES = {
	["RING"]		= "RING",		--钻戒
	["NECKLACE"] 	= "NECKLACE",	--项链
	["BRACELET"]	= "BRACELET",	--手镯
	["JADE"]		= "JADE",		--玉佩
	["BELT"]		= "BELT",		--腰带
	["SEAL"]		= "SEAL",		--玺印
}
