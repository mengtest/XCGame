return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "sprbkg",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["sTexNormal"] = "res/uiface/panels/jiangli.png",
			},
		},
		{
			["Name"] = "titlebkg",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 0,125 },
				["sTexNormal"] = "res/texts/huodejiangli.png",
			},
		},
		{
			["Name"] = "LabelMoney",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { -150,40 },
				["tConSize"] = { 220,40 },
				["iFontSize"] = 32,
				["iAlignment"] = 0,
				["sTxt"] = "金币：10000",
			},
		},
		{
			["Name"] = "LabelDiamond",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 150,40 },
				["tConSize"] = { 220,40 },
				["iFontSize"] = 32,
				["iAlignment"] = 0,
				["sTxt"] = "钻石：200",
			},
		},
	},
}