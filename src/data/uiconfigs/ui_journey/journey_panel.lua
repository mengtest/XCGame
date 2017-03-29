return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
		["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "area1",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { -450,350 },
			},
			["Childrens"] = {
				{
					["Name"] = "btn_back",
					["ClassName"] = "clsButton",
					["Attr"] = {
						["sTxt"] = "返回",
						["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
						["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
						["sTexDisable"] = "",
					},
				},
			},
		},
	},
}