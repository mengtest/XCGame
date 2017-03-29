return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tPos"] = { -160,355 },
	},
	["Childrens"] = {
		{
			["Name"] = "area1",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 0,0 },
			},
			["Childrens"] = {
				{
					["Name"] = "spr_bkg1",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tConSize"] = { 220,36 },
						["tAnchorPt"] = { 0,0.5 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
					},
				},
				{
					["Name"] = "sprMoney",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["iScale"] = 0.8,
						["sTexNormal"] = "res/icons/money.png",
					},
				},
				{
					["Name"] = "btn_addmoney",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 200,0 },
						["sTexNormal"] = "res/uiface/buttons/btn_add.png",
						["sTexTouchDown"] = "",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "LabelMoney",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 50,0 },
						["tConSize"] = { 220,40 },
						["tAnchorPt"] = { 0,0.5 },
						["iFontSize"] = 24,
						["iAlignment"] = 0,
						["sTxt"] = "3252343",
					},
				},
			},
		},
		{
			["Name"] = "area2",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 220,0 },
			},
			["Childrens"] = {
				{
					["Name"] = "spr_bkg2",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tConSize"] = { 220,36 },
						["tAnchorPt"] = { 0,0.5 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
					},
				},
				{
					["Name"] = "sprDiamond",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["iScale"] = 0.8,
						["sTexNormal"] = "res/icons/diamond.png",
					},
				},
				{
					["Name"] = "btn_adddiamond",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 200,0 },
						["sTexNormal"] = "res/uiface/buttons/btn_add.png",
						["sTexTouchDown"] = "",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "LabelDiamond",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 50,0 },
						["tConSize"] = { 220,40 },
						["tAnchorPt"] = { 0,0.5 },
						["iFontSize"] = 24,
						["iAlignment"] = 0,
						["sTxt"] = "3252343",
					},
				},
			},
		},
		{
			["Name"] = "area3",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 440,0 },
			},
			["Childrens"] = {
				{
					["Name"] = "spr_bkg3",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tConSize"] = { 220,36 },
						["tAnchorPt"] = { 0,0.5 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
					},
				},
				{
					["Name"] = "sprPower",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["iScale"] = 0.8,
						["sTexNormal"] = "res/icons/power.png",
					},
				},
				{
					["Name"] = "btn_addpower",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["tPos"] = { 200,0 },
						["sTexNormal"] = "res/uiface/buttons/btn_add.png",
						["sTexTouchDown"] = "",
						["sTexDisable"] = "",
					},
				},
				{
					["Name"] = "LabelPower",
					["ClassName"] = "clsRichText",
					["Attr"] = {
						["tPos"] = { 50,0 },
						["tConSize"] = { 220,40 },
						["tAnchorPt"] = { 0,0.5 },
						["iFontSize"] = 24,
						["iAlignment"] = 0,
						["sTxt"] = "32/120",
					},
				},
			},
		},
	},
}