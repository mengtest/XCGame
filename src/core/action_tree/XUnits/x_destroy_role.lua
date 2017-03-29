---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
}

local x_destroy_role = class("x_destroy_role", clsXUnit)

x_destroy_role._default_args = default_args

function x_destroy_role:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_destroy_role"
end

function x_destroy_role:Proc(args, xCtx)
	local atom_id = args.atom_id 
	
	if not xCtx:GetXRole(atom_id) then 
		log_error("====ERROR: 要删除的角色不存在：", atom_id, self._node_type) 
	end
	xCtx:DestroyXRole(atom_id)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_destroy_role
