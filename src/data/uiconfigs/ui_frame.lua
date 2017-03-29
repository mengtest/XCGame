return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tPos"] = { 512,288 },
	},
	["Childrens"] = {
		{
			["Name"] = "±³¾°Í¼",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tConSize"] = {1024,576},
				["sTexNormal"] = "res/uiface/panels/panel_broad_1.png",
			},
		},
		{
			["Name"] = "±êÌâµ×°å",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 0,280 },
				["sTexNormal"] = "res/uiface/panels/title_bkg.png",
			},
		},
		{
			["Name"] = "label_title",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 0,272 },
				["iFontSize"] = 40,
				["sTxt"] = "Ãû×Ö",
			},
		},
		{
			["Name"] = "btn_close",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 510,286 },
				["tAnchorPt"] = { 1,1 },
				["sTexNormal"] = "res/uiface/buttons/btn_close.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_close_selected.png",
				["sTexDisable"] = "",
			},
		},
	},
}