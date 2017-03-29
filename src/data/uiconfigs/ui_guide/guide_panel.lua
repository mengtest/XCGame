return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tPos"] = { 512,288 },
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "spr_agent",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["sTexNormal"] = "res/uiface/buttons/btn_yellow.png",
			},
		},
		{
			["Name"] = "btn_break",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 510,380 },
				["tAnchorPt"] = { 1,1 },
				["iTitleFontSize"] = 24,
				["sTxt"] = "跳过指引",
				["sTexNormal"] = "res/uiface/buttons/btn_guide_skip.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
	},
}