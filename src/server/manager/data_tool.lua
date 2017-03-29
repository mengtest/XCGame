---------------
--数据库管理
---------------
module("server", package.seeall)

local clsGen = {}

clsGen.Gen_UserList = function()
	local UserList = {}
	local sexlist = {"Boy","Girl"}
	local typelist = {10001,10002,10003}
	
	for i=1, 500 do
		local UserInfo = {
		    ["Uid"] = 1000000001+i-1,
		    ["TypeId"] = typelist[math.random(1,3)],
		    ["UserName"] = "gamer_"..i,
		    ["iCareer"] = 1.000000,
		    ["iCountryId"] = 10001.000000,
		    ["iOffice"] = 1,
		    ["iGrade"] = math.random(1,255),
		    ["iVipLevel"] = math.random(0,15),
		    ["sName"] = utils.GenUserName(sexlist[math.random(1,2)]),
		    ["iShapeId"] = 10001.000000,
		    ["CurExp"] = 1023,
		    ["iMoney"] = 2544643,
		    ["iDiamond"] = 20050,
		    ["iSmartValue"] = 1,
		    ["iPrestige"] = 0,
		    ["iLeadership"] = 1,
		}
		UserList[UserInfo.Uid] = UserInfo
	end
	
	table.save(UserList, "src/data/UserList.lua")
end

clsGen.Gen_TroopList = function()
	local info = {}
	local idx = 0
	local typelist = {30101,30102,30103,30201,30202,30203,  30301,30302,30303,30401,30402,30403}
	
	local citylist = setting.T_city_cfg
	for k,v in pairs(citylist) do
		idx = idx + 1 
		info[idx] = {
			Uid = idx,
	    	TroopType = 1,
	    	LeaderId = v.Uid,
	    	MemberList = { 
	    		{typelist[math.random(1,#typelist/2)],math.random(1,30)},
	    		{typelist[math.random(#typelist/2+1,#typelist)],math.random(1,30)}, 
	    	},
		}
	end
	
	local npclist = setting.T_npc_cfg
	for k,v in pairs(npclist) do
		idx = idx + 1 
		info[idx] = {
			Uid = idx,
	    	TroopType = 2,
	    	LeaderId = v.Uid,
	    	MemberList = { 
	    		{typelist[math.random(1,#typelist/2)],math.random(1,30)},
	    		{typelist[math.random(#typelist/2+1,#typelist)],math.random(1,30)}, 
	    	},
		}
	end
	
	table.save(info, "src/data/TroopList.lua")
end

clsGen.Gen_ItemList = function()
	local typelist = {}
	for ItemType, _ in pairs(setting.T_item_cfg) do
		typelist[#typelist+1] = ItemType
	end
	
	local ItemList = {}
	for ItemId, ItemType in ipairs(typelist) do
		local Info = {
			["ItemId"] = ItemId,
	        ["ItemType"] = ItemType,
	        ["iCount"] = math.random(1,999),
		}
		ItemList[Info.ItemId] = Info
	end
	
	table.save(ItemList, "src/data/ItemList.lua")
end

clsGen.Gen_StoneCfg = function()
	local StoneCfg = {}
	local N2NUM = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }
	local TYPE2NAME = { "物攻宝石", "物防宝石", "法攻宝石", "法防宝石", "暴击宝石", "抗暴宝石", "破击宝石", "格挡宝石" ,"生命宝石" }
	local TYPE2TYPEID = { 3010001, 3020001, 3030001, 3040001, 3050001, 3060001, 3070001, 3080001, 3090001 }
	local TYPE2PATH = { "attack_stone_lv", "def_stone_lv", "magicatt_stone_lv", "magicdef_stone_lv", "crit_stone_lv", "kangbao_stone_lv", "broken_stone_lv", "parry_stone_lv", "hp_stone_lv" }
	for idx, TypeId in ipairs(TYPE2TYPEID) do
		for lvl=1, 10 do
			local Info = {
				["ItemType"] = TYPE2TYPEID[idx]+lvl-1,
				["ItemKind"] = "宝石",
				["Desc"] = "",
				["sResPath"] = "res/icons/item/stones/attack_stone_lv1.png",
				["sResPath"] = "res/icons/item/stones/"..TYPE2PATH[idx]..lvl..".png",
				["sName"] = N2NUM[lvl].."级"..TYPE2NAME[idx],
				["SellPrice"] = {
					["Value"] = 5000*lvl,
					["Currency"] = "金币",
				},
				["Level"] = lvl,
			}
			StoneCfg[Info.ItemType] = Info
		end
	end
	
	table.save(StoneCfg, "src/data/item_cfg/T_item_stone_cfg.lua")
end

clsGen.Gen_LevelupCfg = function()
	local tbl = {}
	for Lvl = 1, 255 do
		tbl[Lvl] = { NeedExp = 500*Lvl*(Lvl-1)/2 + 500, NeedMoney = Lvl * 1000 }
	end
	table.save(tbl, "src/data/card_cfg/T_levelup_cfg.lua")
end

clsGen.Gen_ItemSoulStoneCfg = function()
	local T_card_general = setting.Get("src/data/card_cfg/T_card_general.lua")
	local ItemCfg = {}
	for TypeId, CardInfo in pairs(T_card_general) do
		local ItemInfo = {
			-- 20 01 001 : 物品分类20 国家01 序号001
			["ItemType"] = 2000000 + CardInfo.iMotherland*1000 + TypeId%100,
			["ItemKind"] = "灵魂石",
			["Desc"] = string.format("集齐%d魂石可召唤英雄：%s#r也可作为英雄升星的材料",CardInfo.Condition.cond_item_amount[2],CardInfo.sName),
			["sResPath"] = "res/icons/item/temp.png",
			["sName"] = "圣魂·"..CardInfo.sName,
			["SellPrice"] = {
				["Value"] = 100,
				["Currency"] = "金币",
			},
		}
		ItemCfg[ItemInfo.ItemType] = ItemInfo
	end
	
	table.save(ItemCfg, "src/data/item_cfg/T_item_soulstone_cfg.lua")
end

function Gen_AllCfgs()
	for funName, func in pairs(clsGen) do 
		func()
	end 
end 
