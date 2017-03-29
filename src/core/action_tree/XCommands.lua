-----------------
-- 播放命令
-----------------
module("actree",package.seeall)

local CMD_TABLE = {}

function GetCmdTable()
	return CMD_TABLE
end

local function _register_command(sCmdName, cls)
	assert(sCmdName and cls, "cls不可为空")
	assert(not CMD_TABLE[sCmdName], string.format("已经注册过该命令：%s",sCmdName))
	CMD_TABLE[sCmdName] = cls
end
local function RegisterXCommand(sCmdName)
	local cls_name = sCmdName
	local filePath = string.format("src/core/action_tree/XUnits/%s.lua", cls_name)
	local cls = io.SafeLoadFile(filePath)
	_register_command(sCmdName, cls)
end
local function RegisterVCommand(sCmdName)
	local cls_name = sCmdName
	local filePath = string.format("src/core/action_tree/VUnits/%s.lua", cls_name)
	local cls = io.SafeLoadFile(filePath)
	_register_command(sCmdName, cls)
end

-- cocos动作封装部分
RegisterXCommand("x_root_node")
RegisterXCommand("x_callfunc")
RegisterXCommand("x_delay_time")
RegisterXCommand("x_move_to")
RegisterXCommand("x_move_by")
RegisterXCommand("x_scale_to")
RegisterXCommand("x_scale_by")
RegisterXCommand("x_rotate_to")
RegisterXCommand("x_rotate_by")
RegisterXCommand("x_skew_to")
RegisterXCommand("x_skew_by")
RegisterXCommand("x_jump_to")
RegisterXCommand("x_jump_by")
RegisterXCommand("x_fade_in")
RegisterXCommand("x_fade_out")
RegisterXCommand("x_tint_to")
RegisterXCommand("x_tint_by")
RegisterXCommand("x_cardinal_spline_by")
RegisterXCommand("x_blink")
RegisterXCommand("x_set_opacity")
-- 自定义动作封装部分
RegisterXCommand("x_create_role")
RegisterXCommand("x_create_effect")
RegisterXCommand("x_create_panel")
RegisterXCommand("x_destroy_role")
RegisterXCommand("x_destroy_effect")
RegisterXCommand("x_destroy_panel")
RegisterXCommand("x_role_face_to")
RegisterXCommand("x_role_walk_to")
RegisterXCommand("x_role_run_to")
RegisterXCommand("x_role_rush_to")
RegisterXCommand("x_role_rush_by")
RegisterXCommand("x_role_set_ani")
RegisterXCommand("x_role_play_ani")
RegisterXCommand("x_show_obj")
RegisterXCommand("x_hide_obj")
RegisterXCommand("x_play_skill")
RegisterXCommand("x_pop_say")
RegisterXCommand("x_move_camera")
RegisterXCommand("x_black_screen")
RegisterXCommand("x_shake_screen")
-- 战斗技能相关
RegisterVCommand("v_add_harm")
RegisterVCommand("v_del_harm")
RegisterVCommand("v_add_missile")
RegisterVCommand("v_destroy_missile")
RegisterVCommand("v_role_sprint")
RegisterVCommand("v_add_buff")

--[[
RegisterXCommand("x_cardinal_spline")
RegisterXCommand("x_catmull_rom")
RegisterXCommand("x_bezier_to")
RegisterXCommand("x_bezier_by")
RegisterXCommand("x_seq_animation")
RegisterXCommand("x_orbit_camera")
RegisterXCommand("x_follow")
RegisterXCommand("x_targeted")
RegisterXCommand("x_pause_all_act")
RegisterXCommand("x_resume_all_act")
-- repeat
-- repeat_forever
]]

