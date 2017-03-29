return 
{
	["ClassName"] = "clsWindow",
    ["Name"] = "RootComp",
    ["Attr"] = {
    	["sAdaption"] = { ["center"] = true },
    },
    ["Childrens"] = {
        [1] = {
            ["Attr"] = {
                ["sTexNormal"] = "res/uiface/panels/panel_broad_2.png",
                ["tConSize"] = {
                    [1] = 320.000000,
                    [2] = 500.000000,
                },
                ["tPos"] = {
                    [1] = -200,
                    [2] = 0,
                },
            },
            ["Childrens"] = {
                [1] = {
                    ["Attr"] = {
                        ["iFontSize"] = 24.000000,
                        ["sTxt"] = "",
                        ["tAnchorPt"] = {0,1},
                        ["iAlignment"] = 0,
                        ["tPos"] = {
                            [1] = 15,
                            [2] = 485,
                        },
                    },
                    ["Childrens"] = {
                    },
                    ["ClassName"] = "clsRichText",
                    ["Name"] = "LabelDetail",
                },
            },
            ["ClassName"] = "clsWindow",
            ["Name"] = "Control_1",
        },
    },
}