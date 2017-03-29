---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["dstX"] = 555,
	["dstY"] = 555,
	["speed"] = 12,
}

local x_move_camera = class("x_move_camera", clsXUnit)

x_move_camera._default_args = default_args

function x_move_camera:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_move_camera"
end

function x_move_camera:OnStop()
	KE_KillTimer(self._mTimer)
end

function x_move_camera:Proc(args, xCtx)
	local dstX = args.dstX
	local dstY = args.dstY
	local speed = args.speed
	
	if not KE_TheMap then
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local curX, curY = KE_TheMap:GetCameraPos()
	local iDir = math.Vector2Radian(dstX-curX, dstY-curY)
	local pathline = ClsPathFinder.GetInstance():FindPath(curX, curY, dstX, dstY)
	
	self._mTimer = KE_SetInterval(1, function()
		local x,y,dir,isEnd = pathline.get_next(5)
		if isEnd then
			self:on_event_point(XEventEnum.ec_xfinish)
			KE_KillTimer(self._mTimer)
			return true
		else
			KE_TheMap:SetCameraPos(x,y)
		end
	end)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_move_camera
