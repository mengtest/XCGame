return 
{
	[1] = {
		["args"] = {
			
		},
		["cmdName"] = "x_root_node",
		["connectors"] = {
			["ec_xfinish"] = { 2, },
		},
	},
	[2] = {
        ["args"] = {
            ["ani_name"] = "skill_0_1",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "x_role_play_ani",
        ["connectors"] = {
            [1] = { 3, },
        },
    },
    [3] = {
        ["args"] = {
            ["atom_id"] = 1,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/particle/skills/Comet.plist",
				["sResType"] = "EffectQuad",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileStatic",	--运动方式
					["iDis"] = 0,
					["iAngle"] = 0,	
					["iHei"] = 30,
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = { },
            ["ec_xstart"] = { },
            [1] = {4},
            [4] = {5},
            [7] = {6},
            [10] = {7},
            [13] = {8},
            [16] = {9},
            [19] = {10},
        },
    },
    [4] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [5] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [6] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [7] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [8] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [9] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
    [10] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcImpact",
					["param"] = {
						["iSPframe"] = 2,
						["iSPspeed"] = 5,
						["iCZspeed"] = 5,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
}