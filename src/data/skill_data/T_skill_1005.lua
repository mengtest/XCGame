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
				["sResPath"] = "effects/effect_seq/skills/tornado2.plist",
				["sResType"] = "EffectSeq",
				--
				["AfterCollid"] = 0,		--碰撞后表现。默认：无  1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
				["iDelWithOwner"] = 0,		--随施法者消亡而消亡
				--运动轨迹（法术体的运动方式）
				["tTrackCfg"] = {
					["sTrackType"] = "clsMissileTrack",		--运动方式
					["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
					["iMoveSpeed"] = 5,			--移动速度
				},
			},
        },
        ["cmdName"] = "v_add_missile",
        ["connectors"] = {
            ["ec_xfinish"] = {
            },
            ["ec_xstart"] = {
            	4
            },
        },
    },
    [4] = {
        ["args"] = {
            ["owner_atom"] = 1,
			["tDamageInfo"] = {
				["iDamagePower"] = 50,
				["iIsSingleAtk"] = 0,
				["AffectFunc"] = {
					["funcName"] = "OnEcForce",
					["param"] = {
						["iSPframe"] = 30,
						["iCZspeed"] = 15,
					},
				},
			},
        },
        ["cmdName"] = "v_add_harm",
        ["connectors"] = {
        },
    },
}