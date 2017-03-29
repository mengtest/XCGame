return 
{
	[1] = {
		["args"] = {
			
		},
		["cmdName"] = "x_root_node",
		["connectors"] = {
			["ec_xfinish"] = {
				[1] = 2,
			},
		},
	},
	[2] = {
        ["args"] = {
            ["ani_name"] = "skill_0_1",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "x_role_play_ani",
        ["connectors"] = {
            [1] = { [1] = 3, },
        },
    },
    [3] = {
        ["args"] = {
            ["owner_atom"] = "starman",
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 20,
						["iCZspeed"] = 0,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
}