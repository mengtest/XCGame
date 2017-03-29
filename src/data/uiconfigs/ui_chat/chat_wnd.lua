return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["tAnchorPt"] = { 0,0 },
		["tPos"] = { -512,-384 },
	},
	["Childrens"] = {
		{
			["Name"] = "spr_bkg",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tConSize"] = { 380,245 },
				["tAnchorPt"] = { 0,0 },
				["sTexNormal"] = "res/mask.png",
			},
			["Childrens"] = {
				{
					["Name"] = "btn_chanel_1",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,45 },
						["sTexSelected"] = "res/uiface/buttons/tab_chanel.png",
            			["sTexUnselected"] = "res/uiface/buttons/tab_chanel_sel.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_1",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 32,18 },
								["iFontSize"] = 20,
								["sTxt"] = "私聊",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_2",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,85 },
						["sTexSelected"] = "res/uiface/buttons/tab_chanel.png",
            			["sTexUnselected"] = "res/uiface/buttons/tab_chanel_sel.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_2",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 32,18 },
								["iFontSize"] = 20,
								["sTxt"] = "组队",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_3",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,125 },
						["sTexSelected"] = "res/uiface/buttons/tab_chanel.png",
            			["sTexUnselected"] = "res/uiface/buttons/tab_chanel_sel.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_3",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 32,18 },
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
						["tPos"] = { 0,165 },
						["sTexSelected"] = "res/uiface/buttons/tab_chanel.png",
            			["sTexUnselected"] = "res/uiface/buttons/tab_chanel_sel.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_4",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 32,18 },
								["iFontSize"] = 20,
								["sTxt"] = "世界",
							},
						},
					},
				},
				{
					["Name"] = "btn_chanel_5",
					["ClassName"] = "clsRadioButton",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 0,205 },
						["sTexSelected"] = "res/uiface/buttons/tab_chanel.png",
            			["sTexUnselected"] = "res/uiface/buttons/tab_chanel_sel.png",
					},
					["Childrens"] = {
						{
							["Name"] = "label_5",
							["ClassName"] = "clsRichText",
							["Attr"] = {
								["tPos"] = { 32,18 },
								["iFontSize"] = 20,
								["sTxt"] = "综合",
							},
						},
					},
				},
				
				{
					["Name"] = "editorinput",
					["ClassName"] = "clsEditor",
					["Attr"] = {
						["tAnchorPt"] = { 0,0 },
						["tPos"] = { 65,0 },
						["tConSize"] = { 240,40 },
						["sTexNormal"] = "res/uiface/panels/edit_bg_1.png",
					},
				},
				{
					["Name"] = "btn_send",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["sTxt"] = "发送",
						["tAnchorPt"] = { 0,0 },
						["bScale9Enable"] = true,
						["tPos"] = { 305,0 },
						["tConSize"] = { 72,45 },
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
			},
		},
		{
			["Name"] = "btn_showhide",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["sTxt"] = "隐藏",
				["tAnchorPt"] = { 0,0 },
				["bScale9Enable"] = true,
				["tConSize"] = { 64,40 },
				["sTexNormal"] = "res/uiface/buttons/btn_yellow.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_yellow.png",
				["sTexDisable"] = "",
			},
		},
	},
}