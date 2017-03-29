---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["seconds"] = 1,
}

local x_delay_time = class("x_delay_time", clsXUnit)

x_delay_time._default_args = default_args

function x_delay_time:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_delay_time"
end

function x_delay_time:OnStop()
    KE_KillTimer(self._timer)
    self._timer = nil
end

function x_delay_time:Proc(args, xCtx)
	local seconds = args.seconds
	
	self._timer = KE_SetAbsTimeout(seconds, function()
		self:on_event_point(XEventEnum.ec_xfinish)
		self._timer = nil
	end)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_delay_time
