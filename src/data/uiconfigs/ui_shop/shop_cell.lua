return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 360,120 },
		["sTexNormal"] = "res/uiface/panels/list_common.png",
	},
	["Childrens"] = {
		{
			["Name"] = "item_wnd",
			["ClassName"] = "clsItemWnd",
			["Attr"] = {
				["tPos"] = { 65,60 },
			},
		},
		{
			["Name"] = "label_name",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 120,90 },
				["tAnchorPt"] = { 0,0.5 },
				["iFontSize"] = 24,
				["sTxt"] = "物品名",
			},
		},
		{
			["Name"] = "sprsellout",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tAnchorPt"] = { 1,1 },
				["tPos"] = { 360,120 },
				["sTexNormal"] = "res/uiface/wnds/shop/sell_out.png",
			},
		},
	},
}