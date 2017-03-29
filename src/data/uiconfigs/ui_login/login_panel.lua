return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 1024,576 },
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "framebg",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 512,288 },
				["sTexNormal"] = "res/uiface/loading/loading1.jpg",
			},
		},
		{
			["Name"] = "label_username",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 320,320 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 32,
				["sTxt"] = "用户名：",
			},
		},
		{
			["Name"] = "label_password",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 320,250 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 32,
				["sTxt"] = "密    码：",
			},
		},
		{
			["Name"] = "usernameinput",
			["ClassName"] = "clsEditor",
			["Attr"] = {
				["tPos"] = { 600,320 },
				["tConSize"] = { 240,40 },
				["sTexNormal"] = "res/uiface/panels/edit_bg_4.png",
			},
		},
		{
			["Name"] = "pswdinput",
			["ClassName"] = "clsEditor",
			["Attr"] = {
				["tPos"] = { 600,250 },
				["tConSize"] = { 240,40 },
				["sTexNormal"] = "res/uiface/panels/edit_bg_4.png",
			},
		},
		{
			["Name"] = "btn_enter",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 392,150 },
				["sTxt"] = "进入游戏",
				["bScale9Enable"] = true,
				["tConSize"] = { 240,60 },
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_zhuce",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 632,150 },
				["sTxt"] = "注册",
				["bScale9Enable"] = true,
				["tConSize"] = { 240,60 },
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
	},
}