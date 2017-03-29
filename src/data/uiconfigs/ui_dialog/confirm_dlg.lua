return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 480,320 },
		["sAdaption"] = { ["center"] = true },
		["sTexNormal"] = "res/uiface/panels/panel_confirm.png",
	},
	["Childrens"] = {
		{
			["Name"] = "label_title",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 240,260 },
				["iFontSize"] = 32,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_tips",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 240,200 },
				["iFontSize"] = 28,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "btn_ok",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 140,60 },
				["sTxt"] = "确定",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_cancel",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 340,60 },
				["sTxt"] = "取消",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
	},
}