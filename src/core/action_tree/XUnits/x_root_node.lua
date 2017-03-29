---------------
-- 根节点
---------------
module("actree",package.seeall)

local default_args = {
	["sNodeName"] = "树名",
	["tAutoDelAtoms"] = {},
}

local x_root_node = class("x_root_node", clsXUnit)

x_root_node._default_args = default_args

function x_root_node:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_root_node"
end

function x_root_node:Proc(args, xCtx)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_root_node