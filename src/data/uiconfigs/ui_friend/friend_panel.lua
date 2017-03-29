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
				["tPos"] = { 500,260 },
				["tConSize"] = { 740,440 },
				["sTexNormal"] = "res/uiface/panels/dividing_dark.png",
			},
		},
		{
			["Name"] = "tabarea",
			["ClassName"] = "clsWindow",
			["Attr"] = {
				["tPos"] = { 860,288 },
			},
			["Childrens"] = {
				{
					["Name"] = "btn_chanel_1",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["tPos"] = { 0,90 },
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
								["sTxt"] = "好友",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_2",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
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
								["sTxt"] = "添加",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_3",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0.5 },
						["tPos"] = { 0,-90 },
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
								["sTxt"] = "申请",
							},
						},
					},
				},
			},
		},
	},
}