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
			["Name"] = "bkgframe",
			["ClassName"] = "clsScale9Sprite",
			["Attr"] = {
				["tPos"] = { 512,235 },
				["tConSize"] = { 1000,450 },
				["CapInsets"] = { x = 300, y = 30, width = 1, height = 1 },
				["sTexNormal"] = "res/uiface/wnds/rank/frame_ranking.png",
			},
		},
	},
}