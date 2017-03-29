return {
	["Name"] = "RootComp",
	["ClassName"] = "clsWindow",
	["Attr"] = {
	--	["sAdaption"] = { ["center"] = true },
	},
	["Childrens"] = {
		{
			["Name"] = "spr9_bkg",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tConSize"] = { 1024,768 },
				["sTexNormal"] = "res/uiface/loading/loading1.png",
			},
		},
		{
			["Name"] = "bar_timer",
			["ClassName"] = "clsProgressBar",
			["Attr"] = {
				["tPos"] = { 0,-200 },
				["sTexNormal"] = "res/uiface/progress/loadingbar.png",
			},
		},
	},
}