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
			["Name"] = "btn_buildup",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 552,40 },
				["sTxt"] = "建立国家",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_applyfor",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 672,40 },
				["sTxt"] = "申请加入",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		
		{
			["Name"] = "btn_relation",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tAnchorPt"] = {0,0.5},
				["tPos"] = { 15,150 },
				["sTxt"] = "宣战",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_member",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tAnchorPt"] = {0,0.5},
				["tPos"] = { 115,150 },
				["sTxt"] = "查看成员",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
	},
}