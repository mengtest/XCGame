return {
	{ 
		Id = "首充", 
		TitleStr = "",
		TimeStr = "",
		ImgPath = "res/uiface/advertise/adv1.jpg",
		Desc = "首充",
		login_checker = function() return true end, 
		spec_checker = function() return true end,
		click_func = function() ClsSystemMgr.GetInstance():EnterSystem("首冲") end 
	},
	{ 
		Id = "月卡", 
		TitleStr = "",
		TimeStr = "",
		ImgPath = "res/uiface/advertise/adv2.jpg",
		Desc = "月卡",
		login_checker = function() return true end, 
		spec_checker = function() return true end,
		click_func = function() ClsSceneMgr.GetInstance():Turn2Scene("journey_scene") end 
	},
	{ 
		Id = "打体力", 
		TitleStr = "",
		TimeStr = "2016-10-01 ----> 2016-10-07",
		ImgPath = "res/uiface/advertise/adv3.jpg",
		Desc = "打体力",
		login_checker = function() return false end, 
		spec_checker = function() return false end,
		click_func = function()  end 
	},
	{ 
		Id = "圣殿", 
		TitleStr = "",
		TimeStr = "",
		ImgPath = "res/uiface/advertise/adv4.jpg",
		Desc = "圣殿",
		login_checker = function() return false end, 
		spec_checker = function() return false end,
		click_func = function()  end 
	},
	{ 
		Id = "VIP特权", 
		TitleStr = "",
		TimeStr = "",
		ImgPath = "res/uiface/advertise/adv5.jpg",
		Desc = "VIP特权",
		login_checker = function() return true end, 
		spec_checker = function() return true end,
		click_func = function() ClsSystemMgr.GetInstance():EnterSystem("VIP特权") end 
	},
	{ 
		Id = "世界BOSS", 
		TitleStr = "",
		TimeStr = "",
		ImgPath = "res/uiface/advertise/adv6.jpg",
		Desc = "世界BOSS",
		login_checker = function() return false end, 
		spec_checker = function() return false end,
		click_func = function()  end 
	},
}