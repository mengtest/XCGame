return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 710,120 },
		["sTexNormal"] = "res/uiface/panels/list_common.png",
	},
	["Childrens"] = {
		{
			["Name"] = "label_name",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 135,80 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_level",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 435,80 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_combatforce",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 135,35 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["TextColor"] = { r = 222, g = 211, b = 0 },
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_state",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 435,35 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["TextColor"] = { r = 222, g = 211, b = 0 },
				["sTxt"] = "",
			},
		},
	},
}