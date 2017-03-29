---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	
}

local v_add_buff = class("v_add_buff", clsXUnit)

v_add_buff._default_args = default_args

function v_add_buff:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "v_add_buff"
end

function v_add_buff:Proc(args, xCtx)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return v_add_buff
