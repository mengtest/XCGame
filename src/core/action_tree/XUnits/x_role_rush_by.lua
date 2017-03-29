---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dis"] = 200,
	["iAngle"] = 0,
	["speed"] = 20,
}

local x_role_rush_by = class("x_role_rush_by", clsXUnit)

x_role_rush_by._default_args = default_args

function x_role_rush_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_role_rush_by"
end

function x_role_rush_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local role = self:GetXContext():GetXRole(atom_id)
	if role then role:CallRest() end
end

function x_role_rush_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local dis = args.dis
	local iAngle = args.iAngle
	local speed = args.speed
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local x,y = tmpChar:getPosition()
	local CurDir = tmpChar:GetDirection()
	local hudu = math.rad(iAngle)
	local dx, dy = x+dis*math.cos(CurDir+hudu), y+dis*math.sin(CurDir+hudu)
	tmpChar:CallRush(dx, dy, 0, function()
		self:on_event_point(XEventEnum.ec_xfinish)
	end)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_role_rush_by
