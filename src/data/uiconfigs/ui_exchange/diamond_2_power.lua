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
				["sTexNormal"] = "res/uiface/wnds/exchange/exchange_panel.png",
			},
		},
		{
			["Name"] = "spr0001",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { 0,135 },
				["sTexNormal"] = "res/uiface/wnds/exchange/exchange_title2.png",
			},
		},
		{
			["Name"] = "girlspr",
			["ClassName"] = "clsSprite",
			["Attr"] = {
				["tPos"] = { -285,-55 },
				["sTexNormal"] = "res/uiface/wnds/exchange/exchange_seller_2.png",
			},
		},
		{
			["Name"] = "LabelAaaa",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 0,55 },
				["tConSize"] = { 500,40 },
				["iFontSize"] = 35,
				["TextColor"] = { r = 222, g = 11, b = 0 },
				["sTxt"] = "体力不足？快来兑换！",
			},
		},
		{
			["Name"] = "LabelTips",
			["ClassName"] = "clsRichText",
			["Attr"] = {
				["tPos"] = { 0,-100 },
				["tConSize"] = { 500,40 },
				["iFontSize"] = 30,
				["sTxt"] = "剩余次数：3/20",
			},
		},
		{
			["Name"] = "midarea",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 0,-25 },
			},
			["Childrens"] = {
				{
					["Name"] = "midbkg",
					["ClassName"] = "clsScale9Sprite",
					["Attr"] = {
						["tConSize"] = { 400,85 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_3.png",
					},
				},
				{
					["Name"] = "arrowrightspr",
					["ClassName"] = "clsSprite",
					["Attr"] = {
						["sTexNormal"] = "res/icons/arrow_right.png",
					},
				},
				{
					["Name"] = "area1",
					["ClassName"] = "clsLayout",
					["Attr"] = {
						["tPos"] = { -110,0 },
					},
					["Childrens"] = {
						{
							["Name"] = "spr_bkg1",
							["ClassName"] = "clsScale9Sprite",
							["Attr"] = {
								["tConSize"] = { 140,48 },
								["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
							},
						},
						{
							["Name"] = "sprDiamond",
							["ClassName"] = "clsSprite",
							["Attr"] = {
								["tPos"] = { -45,0 },
								["sTexNormal"] = "res/icons/diamond.png",
							},
						},
						{
							["Name"] = "LabelDiamond",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { -15,0 },
								["tConSize"] = { 200,40 },
								["tAnchorPt"] = { 0,0.5 },
								["iFontSize"] = 24,
								["iAlignment"] = 0,
								["sTxt"] = "1",
							},
						},
					},
				},
				{
					["Name"] = "area2",
					["ClassName"] = "clsLayout",
					["Attr"] = {
						["tPos"] = { 110,0 },
					},
					["Childrens"] = {
						{
							["Name"] = "spr_bkg2",
							["ClassName"] = "clsScale9Sprite",
							["Attr"] = {
								["tConSize"] = { 140,48 },
								["sTexNormal"] = "res/uiface/panels/edit_bg_5.png",
							},
						},
						{
							["Name"] = "sprMoney",
							["ClassName"] = "clsSprite",
							["Attr"] = {
								["tPos"] = { -45,0 },
								["sTexNormal"] = "res/icons/power.png",
							},
						},
						{
							["Name"] = "LabelMoney",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { -20,0 },
								["tConSize"] = { 200,40 },
								["tAnchorPt"] = { 0,0.5 },
								["iFontSize"] = 24,
								["iAlignment"] = 0,
								["sTxt"] = "20",
							},
						},
					},
				},
			},
		},
		
		{
			["Name"] = "btn_close",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 210,125 },
				["sTexNormal"] = "res/uiface/buttons/btn_close_float.png",
				["sTexTouchDown"] = "",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_use_1",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { -90,-160 },
				["iTitleFontSize"] = 24,
				["sTxt"] = "兑换",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "btn_use_10",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 90,-160 },
				["iTitleFontSize"] = 24,
				["sTxt"] = "兑换十次",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
	},
}