---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["sx"] = 0,
	["sy"] = 0,
	["dx"] = 0,
	["dy"] = 0,
	["distance"] = 10,
	["speed"] = 7,
}

local x_role_run_to = class("x_role_run_to", clsXUnit)

x_role_run_to._default_args = default_args

function x_role_run_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_role_run_to"
end

function x_role_run_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local role = self:GetXContext():GetXRole(atom_id)
	if role then 
		role:ClearRoadPath()
		role:CallRest() 
	end
end

function x_role_run_to:Proc(args, xCtx)
	local atom_id = args.atom_id
	local sx = args.sx
	local sy = args.sy
	local dx = args.dx
	local dy = args.dy
	local distance = args.distance or default_args.distance
	local speed = args.speed
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpChar:CallRun(dx, dy, distance, function()
		self:on_event_point(XEventEnum.ec_xfinish)
	end)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_role_run_to
