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
			["Name"] = "sep_line",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tPos"] = { 500,260 },
				["tConSize"] = { 11,520 },
				["sTexNormal"] = "res/uiface/panels/line1.png",
			},
		},
	},
}