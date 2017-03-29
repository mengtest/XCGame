---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["ani_name"] = const.ANI_ATTACK_1,
	["speed_scale"] = 1,
}

local x_role_set_ani = class("x_role_set_ani", clsXUnit)

x_role_set_ani._default_args = default_args

function x_role_set_ani:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_role_set_ani"
end

function x_role_set_ani:Proc(args, xCtx)
	local atom_id = args.atom_id
	local ani_name = args.ani_name
	local speed_scale = args.speed_scale
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpChar:SetAni(ani_name)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_role_set_ani
