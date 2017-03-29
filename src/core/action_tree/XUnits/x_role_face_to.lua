---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dx"] = 0,
	["dy"] = 0,
}

local x_role_face_to = class("x_role_face_to", clsXUnit)

x_role_face_to._default_args = default_args

function x_role_face_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_role_face_to"
end

function x_role_face_to:Proc(args, xCtx)
	local atom_id = args.atom_id
	local dx = args.dx
	local dy = args.dy
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpChar:FaceTo(dx, dy)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_role_face_to
