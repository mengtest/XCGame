---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	
}

local x_parallel_node = class("x_parallel_node", clsXUnit)

x_parallel_node._default_args = default_args

function x_parallel_node:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_parallel_node"
end

function x_parallel_node:Proc(args, xCtx)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_parallel_node
