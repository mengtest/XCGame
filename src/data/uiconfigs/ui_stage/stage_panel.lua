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
			["Name"] = "sep_line",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tPos"] = { 400,260 },
				["tConSize"] = { 11,520 },
				["sTexNormal"] = "res/uiface/panels/line1.png",
			},
		},
		{
			["Name"] = "label_desc",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 407,502 },
				["iFontSize"] = 30,
				["tAnchorPt"] = { 0,1 },
				["iAlignment"] = 0,
				["sTxt"] = "关卡描述：",
			},
		},
		{
			["Name"] = "btn_embattle",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 800,60 },
				["sTxt"] = "布阵",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_enter",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 920,60 },
				["sTxt"] = "进入",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "tab_1",
			["ClassName"] = "clsRadioButton",
			["Attr"] = {
				["tPos"] = { 50,50 },
				["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            	["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
			},
			["Childrens"] = {
				{
					["Name"] = "label_1",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 52,16 },
						["iFontSize"] = 24,
						["sTxt"] = "普通",
					},
				},
			},
		},
		{
			["Name"] = "tab_2",
			["ClassName"] = "clsRadioButton",
			["Attr"] = {
				["tPos"] = { 150,50 },
				["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            	["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
			},
			["Childrens"] = {
				{
					["Name"] = "label_2",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 52,16 },
						["iFontSize"] = 24,
						["sTxt"] = "困难",
					},
				},
			},
		},
		{
			["Name"] = "tab_3",
			["ClassName"] = "clsRadioButton",
			["Attr"] = {
				["tPos"] = { 250,50 },
				["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            	["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
			},
			["Childrens"] = {
				{
					["Name"] = "label_3",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 52,16 },
						["iFontSize"] = 24,
						["sTxt"] = "炼狱",
					},
				},
			},
		},
	},
}