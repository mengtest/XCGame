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
            [10] = { 4, },
            [20] = { 5, },
        },
    },
    [3] = {
        ["args"] = {
            ["atom_id"] = 1,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/particle/skills/SmallSun.plist",
				["sResType"] = "EffectQuad",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileParabola",	--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 10,		--移动速度
					["iMoveDis"] = 200,			--移动距离
					["iMaxHeight"] = 150,		--高度
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	6
            },
        },
    },
    [4] = {
        ["args"] = {
            ["atom_id"] = 2,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/particle/skills/SmallSun.plist",
				["sResType"] = "EffectQuad",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileParabola",	--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 10,		--移动速度
					["iMoveDis"] = 200,			--移动距离
					["iMaxHeight"] = 150,		--高度
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	7
            },
        },
    },
    [5] = {
        ["args"] = {
            ["atom_id"] = 3,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/particle/skills/SmallSun.plist",
				["sResType"] = "EffectQuad",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileParabola",	--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 10,		--移动速度
					["iMoveDis"] = 200,			--移动距离
					["iMaxHeight"] = 150,		--高度
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	8
            },
        },
    },
    
    [6] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcForce",
					["param"] = {
						["iSPframe"] = 30,
						["iCZspeed"] = 10,
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
            ["owner_atom"] = 2,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcForce",
					["param"] = {
						["iSPframe"] = 25,
						["iCZspeed"] = 10,
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
            ["owner_atom"] = 3,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcForce",
					["param"] = {
						["iSPframe"] = 20,
						["iCZspeed"] = 12,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
}