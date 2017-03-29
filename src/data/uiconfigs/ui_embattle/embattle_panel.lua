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
			["Name"] = "btn_enter",
			["ClassName"] = "clsButton",
			["Attr"] = {
				["tPos"] = { 900,400 },
				["sTxt"] = "确定",
				["sTexNormal"] = "res/uiface/buttons/btn_blue.png",
				["sTexTouchDown"] = "res/uiface/buttons/btn_green.png",
				["sTexDisable"] = "",
			},
		},
		{
			["Name"] = "ctrl_cards",
			["ClassName"] = "clsLayout",
			["Attr"] = {
				["tPos"] = { 100,350 },
			},
		},
	},
}