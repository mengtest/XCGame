return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 334,458 },
	},
	["Childrens"] = {
		{
			["Name"] = "sprbkg",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 167,229 },
				["sTexNormal"] = "res/uiface/wnds/lottery/type_silver.jpg",
			},
		},
		{
			["Name"] = "border1",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 40,242 },
				["sTexNormal"] = "res/uiface/wnds/lottery/type_silver_panel.png",
			},
		},
		{
			["Name"] = "border2",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 294,242 },
				["iScaleX"] = -1,
				["sTexNormal"] = "res/uiface/wnds/lottery/type_silver_panel.png",
			},
		},
		{
			["Name"] = "sprtip",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 167,235 },
				["sTexNormal"] = "res/uiface/wnds/lottery/type_silver_text.png",
			},
		},
		{
			["Name"] = "label_time",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 167,-15 },
				["iFontSize"] = 30,
				["sTxt"] = "",
			},
		},
		{
			["Name"] = "area1",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 10,150 },
			},
			["Childrens"] = {
				{
					["Name"] = "spr_bkg1",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["tConSize"] = { 200,48 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
					},
				},
				{
					["Name"] = "sprMoney1",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["sTexNormal"] = "res/icons/money.png",
					},
				},
				{
					["Name"] = "LabelMoney1",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 60,0 },
						["tConSize"] = { 200,40 },
						["tAnchorPt"] = { 0,0.5 },
						["iFontSize"] = 24,
						["iAlignment"] = 0,
						["sTxt"] = "2000",
					},
				},
				{
					["Name"] = "btn_once",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 260,0 },
						["sTxt"] = "抽一次",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
			},
		},
		{
			["Name"] = "area2",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 10,75 },
			},
			["Childrens"] = {
				{
					["Name"] = "spr_bkg2",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["tConSize"] = { 200,48 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
					},
				},
				{
					["Name"] = "sprMoney2",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["sTexNormal"] = "res/icons/money.png",
					},
				},
				{
					["Name"] = "LabelMoney2",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 60,0 },
						["tConSize"] = { 200,40 },
						["tAnchorPt"] = { 0,0.5 },
						["iFontSize"] = 24,
						["iAlignment"] = 0,
						["sTxt"] = "19000",
					},
				},
				{
					["Name"] = "btn_ten",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 260,0 },
						["sTxt"] = "抽十次",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
			},
		},
	},
}