return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tConSize"] = { 1024,576 },
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "normal_frame",
			["ClassName"] = "clsCompnent",
			["Attr"] = {
				["tPos"] = { 512,288 },
				["sFilePath"] = "src/data/uiconfigs/ui_frame.lua",
			},
		},
		{
			["Name"] = "listwnd",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tPos"] = { 480,260 },
				["tConSize"] = { 752,440 },
				["sTexNormal"] = "res/uiface/panels/dividing_dark.png",
			},
		},
		{
			["Name"] = "tabarea",
			["ClassName"] = "clsWindow",
			["Attr"] = {
				["tPos"] = { 860,390 },
			},
			["Childrens"] = {
				{
					["Name"] = "btn_chanel_1",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            			["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_1",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 40,40 },
								["iFontSize"] = 20,
								["sTxt"] = "杂货店",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_2",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,-80 },
						["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            			["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_2",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 40,40 },
								["iFontSize"] = 20,
								["sTxt"] = "竞技场",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_3",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,-160 },
						["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            			["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_3",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 40,40 },
								["iFontSize"] = 20,
								["sTxt"] = "宗派",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_4",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,-240 },
						["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            			["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_4",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 40,40 },
								["iFontSize"] = 20,
								["sTxt"] = "过关斩将",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_5",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,-320 },
						["sTexSelected"] = "res/uiface/buttons/radio_button_on.png",
            			["sTexUnselected"] = "res/uiface/buttons/radio_button_off.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_5",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 40,40 },
								["iFontSize"] = 20,
								["sTxt"] = "擂台",
							},
						},
					},
				},
			},
		},
	},
}
