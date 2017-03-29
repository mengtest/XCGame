---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["iBlackScreen"] = 1,
	["iKeepSeconds"] = 1,
}

local x_black_screen = class("x_black_screen", clsXUnit)

x_black_screen._default_args = default_args

function x_black_screen:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_black_screen"
end

function x_black_screen:OnStop()
	KE_KillTimer(self._timer)
	self._timer = nil
	KE_Director:GetLayerMgr():ShowAllLayer(true)
end

function x_black_screen:Proc(args, xCtx)
	local iBlackScreen = tonumber(args.iBlackScreen) or 1
	local iKeepSeconds = tonumber(args.iKeepSeconds) or 1
	
	local bBlack = iBlackScreen == 1
	KE_Director:GetLayerMgr():ShowAllLayer(not bBlack)
	
	self._timer = KE_SetAbsTimeout(iKeepSeconds, function()
		KE_Director:GetLayerMgr():ShowAllLayer(bBlack)
		self:on_event_point(XEventEnum.ec_xfinish)
		self._timer = nil
	end)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_black_screen
