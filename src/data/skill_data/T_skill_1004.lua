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
            ["ani_name"] = "skill_1",
            ["atom_id"] = "starman",
        },
        ["cmdName"] = "x_role_play_ani",
        ["connectors"] = {
            [10] = { 
            	3,4,5,6,7,8,9,10
            },
            [20] = { 
            	11,12,13,14,15,16,17,18
            },
        },
    },
    [3] = {
        ["args"] = {
            ["atom_id"] = 1,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	21
            },
        },
    },
    [4] = {
        ["args"] = {
            ["atom_id"] = 2,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 45,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	22
            },
        },
    },
    [5] = {
        ["args"] = {
            ["atom_id"] = 3,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 90,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	23
            },
        },
    },
    [6] = {
        ["args"] = {
            ["atom_id"] = 4,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 135,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	24
            },
        },
    },
    [7] = {
        ["args"] = {
            ["atom_id"] = 5,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 180,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	25
            },
        },
    },
    [8] = {
        ["args"] = {
            ["atom_id"] = 6,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 225,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	26
            },
        },
    },
    [9] = {
        ["args"] = {
            ["atom_id"] = 7,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 270,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	27
            },
        },
    },
    [10] = {
        ["args"] = {
            ["atom_id"] = 8,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado1.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 315,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	28
            },
        },
    },
    [11] = {
        ["args"] = {
            ["atom_id"] = 9,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 0,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	29
            },
        },
    },
    [12] = {
        ["args"] = {
            ["atom_id"] = 10,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 45,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	30
            },
        },
    },
    [13] = {
        ["args"] = {
            ["atom_id"] = 11,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 90,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	31
            },
        },
    },
    [14] = {
        ["args"] = {
            ["atom_id"] = 12,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 135,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	32
            },
        },
    },
    [15] = {
        ["args"] = {
            ["atom_id"] = 13,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 180,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	33
            },
        },
    },
    [16] = {
        ["args"] = {
            ["atom_id"] = 14,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 225,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	34
            },
        },
    },
    [17] = {
        ["args"] = {
            ["atom_id"] = 15,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 270,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	35
            },
        },
    },
    [18] = {
        ["args"] = {
            ["atom_id"] = 16,
			["owner_atom"] = "starman",
			["cfg_info"] = {
				--资源路径
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileLine",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveDir"] = 315,			--移动方向（角度）
					["iMoveSpeed"] = 15,			--移动速度
					["iMoveDis"] = 300,			--移动距离
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	36
            },
        },
    },
    
    [21] = {
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
    [22] = {
        ["args"] = {
            ["owner_atom"] = 2,
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
    [23] = {
        ["args"] = {
            ["owner_atom"] = 3,
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
    [24] = {
        ["args"] = {
            ["owner_atom"] = 4,
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
    [25] = {
        ["args"] = {
            ["owner_atom"] = 5,
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
    [26] = {
        ["args"] = {
            ["owner_atom"] = 6,
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
    [27] = {
        ["args"] = {
            ["owner_atom"] = 7,
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
    [28] = {
        ["args"] = {
            ["owner_atom"] = 8,
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
    [29] = {
        ["args"] = {
            ["owner_atom"] = 9,
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
    [30] = {
        ["args"] = {
            ["owner_atom"] = 10,
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
    [31] = {
        ["args"] = {
            ["owner_atom"] = 11,
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
    [32] = {
        ["args"] = {
            ["owner_atom"] = 12,
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
    [33] = {
        ["args"] = {
            ["owner_atom"] = 13,
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
    [34] = {
        ["args"] = {
            ["owner_atom"] = 14,
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
    [35] = {
        ["args"] = {
            ["owner_atom"] = 15,
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
    [36] = {
        ["args"] = {
            ["owner_atom"] = 16,
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
}