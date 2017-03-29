return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 1024,576 },
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "normal_frame",
			["ClassName"] = "clsCompnent",
			["Attr"] = {
				["tPos"] = { 512,288 },
				["sFilePath"] = "src/data/uiconfigs/ui_frame.lua",
			},
		},
		{
			["Name"] = "label_mine",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 512,480 },
				["iFontSize"] = 28,
				["TextColor"] = { r = 222, g = 211, b = 0 },
				["sTxt"] = "我的排名：132     我的战力：251234          今日剩余挑战次数：3/5",
			},
		},
		{
			["Name"] = "rankarea",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 512,275 },
			},
		},
		{
			["Name"] = "bottomarea",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 0,55 },
			},
			["Childrens"] = {
				{
					["Name"] = "btn_def_team",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 100,0 },
						["sTxt"] = "防守阵容",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "btn_refresh",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 200,0 },
						["sTxt"] = "刷新对手",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "btn_shop",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 624,0 },
						["sTxt"] = "商店",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "btn_rank",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 724,0 },
						["sTxt"] = "排行",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "btn_history",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 824,0 },
						["sTxt"] = "记录",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "btn_score",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 924,0 },
						["sTxt"] = "积分",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
			},
		},
	},
}