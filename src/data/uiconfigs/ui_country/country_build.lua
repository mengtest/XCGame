return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 500,320 },
		["sAdaption"] = { ["center"] = true },
		["sTexNormal"] = "res/uiface/panels/panel_broad_2.png",
	},
	["Childrens"] = {
		{
			["Name"] = "btn_close",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 480,300 },
				["sTxt"] = "",
				["sTexNormal"] = "res/uiface/buttons/btn_close_float.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "label_tips",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 70,250 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 32,
				["sTxt"] = "请输入国家名字：",
			},
		},
		{
			["Name"] = "editorinput",
			["ClassName"] = "clsEditor",
			["Attr"] = {
				["tAnchorPt"] = { 0,0 },
				["tPos"] = { 70,160 },
				["tConSize"] = { 360,40 },
				["sTexNormal"] = "res/uiface/panels/edit_bg_1.png",
			},
		},
		{
			["Name"] = "btn_ok",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["sTxt"] = "确定",
				["bScale9Enable"] = true,
				["tPos"] = { 250,80 },
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
	},
}