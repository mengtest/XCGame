---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["seconds"] = 4,
	["degree"] = 20,
}

local x_shake_screen = class("x_shake_screen", clsXUnit)

x_shake_screen._default_args = default_args

function x_shake_screen:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_shake_screen"
end

function x_shake_screen:OnStop()
	if KE_TheMap then
		KE_TheMap:StopShake()
	end
end

function x_shake_screen:Proc(args, xCtx)
	local seconds = args.seconds or default_args.seconds
	local degree = args.degree or default_args.degree
	
	if KE_TheMap then
		KE_TheMap:Shake(seconds, degree, function()
			self:on_event_point(XEventEnum.ec_xfinish)
		end)
		
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
	else
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
	end
end

return x_shake_screen
