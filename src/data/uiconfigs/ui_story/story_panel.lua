return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "spr_bottom",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 0,-384 },
				["tAnchorPt"] = { 0.5,0 },
				["sTexNormal"] = "res/uiface/wnds/story/story_bottom.png",
			},
		},
		{
			["Name"] = "btn_break",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 510,380 },
				["tAnchorPt"] = { 1,1 },
				["iTitleFontSize"] = 24,
				["sTxt"] = "跳过剧情",
				["sTexNormal"] = "res/uiface/buttons/btn_guide_skip.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
	},
}