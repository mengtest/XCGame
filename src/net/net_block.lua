-----------------
-- 阻塞列表
-----------------
module("network", package.seeall)

ERROR_PTO_LIST = { ["c_tell_fail"] = true, }  -- 出错的协议

local _pto_pairs = {
	["s_build_country"] 			= { "c_build_country" },
	["s_request_enter_country"] 	= { "c_country_add_person" },
	["s_request_leave_country"] 	= { "c_person_leave_country" },
	["s_country_dismiss_person"] 	= { "c_country_dismiss_person" },
	["s_country_person_list"] 		= { "c_country_person_list" },
	["s_fight_city"] 				= { "c_fight_city" },
	["s_fight_arena"]				= { "c_fight_arena" },
	["s_fight_stage"]				= { "c_fight_stage" },
	["s_chat"] 						= { "c_chat" },
	["s_use_item"] 					= { "c_item_amount", "c_del_item" },
	["s_sell_item"] 				= { "c_item_amount", "c_del_item" },
	["s_login"] 					= { "c_login_succ" },
	["s_signin"]					= { "c_signin" },
	["s_stage_list"]				= { "c_stage_list" },
	["s_player_info"]				= { "c_player_info" },
	["s_chg_country_relation"]		= { "c_chg_country_relation" },
}

-- 通过协议名索引，方便快速查找
PROTOCAL_PAIR = {}
for SendPtoName, RecieveList in pairs(_pto_pairs) do
	if #RecieveList > 0 then
		PROTOCAL_PAIR[SendPtoName] = {}
		for _, RecieveName in ipairs(RecieveList) do
			PROTOCAL_PAIR[SendPtoName][RecieveName] = true
		end
	end
end
_pto_pairs = nil
