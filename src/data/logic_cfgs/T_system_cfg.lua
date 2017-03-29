return {
	-- 社交
	["好友"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsFriendPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_friend.png", 
	},
	["聊天"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsChatPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["婚姻"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsMarriagePanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_marriage.png", 
	},
	["宗派"] = { 
		enter_func = function()  
			utils.TellMe("敬请期待")
			return nil
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["邮件"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsEmailPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_email.png", 
	},
	
	-- 经济
	["商店"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsShopPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_shop.png", 
	},
	["充值"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsRechargePanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_recharge.png", 
	},
	["VIP特权"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsVipRightPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_vipright.png", 
	},
	["首冲"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsFirstRechargeWnd")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_firstrecharge.png", 
	},
	["抽奖"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsLotteryPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_lottery.png", 
	},
	["签到"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsSignInPanel") 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_signin.png", 
	},
	["活动"] = { 
		enter_func = function() 
			utils.TellMe("敬请期待")
			return nil
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_signin.png", 
	},
	["背包"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsBagPanel") 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_bag.png", 
	},
	["购买体力"] = {
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsDiamond2PowerWnd")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["购买金币"] = {
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsDiamond2MoneyWnd")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	
	-- 成长强化
	["装备"] = { 
		enter_func = function() 
			return ClsUIManager.GetInstance():ShowPopWnd("clsEquipPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_equip.png", 
	},
	["圣物"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsRelicsPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_relics.png", 
	},
	["融魂"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsSoulPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_soul.png", 
	},
	["坐骑"] = { 
		enter_func = function() 
			utils.TellMe("敬请期待")
			return nil
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["翅膀"] = { 
		enter_func = function() 
			utils.TellMe("敬请期待")
			return nil
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["饰品"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsSoulPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_soul.png", 
	},
	["神策"] = { 	--天策 地策 人策
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsSoulPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_soul.png", 
	},
	
	-- 特色玩法
	["国家"] = { 
		enter_func = function() 
			local RoleData = KE_Director:GetHeroData()
			if not RoleData then 
				utils.TellMe("数据获取失败") 
				return nil
			end
			if RoleData:GetiCountryId() then
				return ClsUIManager.GetInstance():ShowPopWnd("clsMyCountryPanel") 
			else
				return ClsUIManager.GetInstance():ShowPopWnd("clsCountryListPanel") 
			end
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_country.png", 
	},
	["招揽"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsRecruitPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_recruit.png", 
	},
	
	-- 战斗
	["征途"] = { 
		enter_func = function() 
			return ClsSceneMgr.GetInstance():Turn2Scene("journey_scene") 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_journey.png", 
	},
	["竞技场"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsArenaPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_arena.png", 
	},
	["切磋"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsQiecuoPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_qiecuo.png", 
	},
	["擂台"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsLeitaiPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_leitai.png", 
	},
	["比武招亲"] = { 
		enter_func = function()  
			return ClsUIManager.GetInstance():ShowPopWnd("clsWuzhaoPanel")
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_wuzhao.png", 
	},
	["宗派战"] = { 
		enter_func = function()  
			utils.TellMe("敬请期待")
			return nil 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "", 
	},
	["过关斩将"] = { 
		enter_func = function(stagetype)  
			local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsStagePanel")
			if wnd then wnd:SwitchTo(stagetype) end
			return wnd
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_stage.png", 
	},
	
	--其他
	["排行榜"] = { 
		enter_func = function(RankKey)  
			local wnd = ClsUIManager.GetInstance():ShowPopWnd("clsRanklistPanel")
			if wnd then wnd:SwitchTo(RankKey) end
			return wnd 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_ranklist.png", 
	},
	["攻略"] = { 
		enter_func = function()  
			utils.TellMe("敬请期待")
			return nil 
		end, 
		open_condition = {
			["cond_grade"] = {0},
		}, 
		icon = "res/uiface/buttons/menus/btn_ranklist.png", 
	},
}