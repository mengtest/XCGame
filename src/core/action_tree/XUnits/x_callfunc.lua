---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["func"] = function()  end,
}

local x_callfunc = class("x_callfunc", clsXUnit)

x_callfunc._default_args = default_args

function x_callfunc:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_callfunc"
end

function x_callfunc:Proc(args, xCtx)
	assert(type(args.func)=="function")
	args.func()
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_callfunc
