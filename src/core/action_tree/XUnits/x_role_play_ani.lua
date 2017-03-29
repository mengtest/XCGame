---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["ani_name"] = const.ANI_ATTACK_1,
	["loop_times"] = 0,
	["speed_scale"] = 1,
}

local x_role_play_ani = class("x_role_play_ani", clsXUnit)

x_role_play_ani._default_args = default_args

function x_role_play_ani:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_role_play_ani"
end

function x_role_play_ani:OnStop()
	self.on_ani_over = nil
end

function x_role_play_ani:Proc(args, xCtx)
	local atom_id = args.atom_id
	local ani_name = args.ani_name
	local loop_times = args.loop_times or 0
	local speed_scale = args.speed_scale
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	self.on_ani_over = function()
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpChar:PlayAni(ani_name, function()
		if self.on_ani_over then self.on_ani_over() end
	end)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_role_play_ani
