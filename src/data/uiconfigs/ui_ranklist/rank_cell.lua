return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 710,110 },
		["sTexNormal"] = "res/uiface/panels/list_common.png",
	},
	["Childrens"] = {
		{
			["Name"] = "label_name",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 230,75 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_level",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 600,75 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "label_sport",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 230,35 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["TextColor"] = { r = 222, g = 211, b = 0 },
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "rankarea",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 65,55 },
			},
			["Childrens"] = {
				{
					["Name"] = "rankspr",
					["ClassName"] = "clsLayout",
					["Attr"] = {},
				},
				{
					["Name"] = "label_rankidx",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 0,-5 },
						["iFontSize"] = 24,
						["sTxt"] = "",
					},
				},
			},
		},
	},
}