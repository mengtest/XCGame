---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["effect_id"] = 1,
	["res_path"] = "effects/effect_seq/skills/bingpo.plist",
	["x"] = 0,
	["y"] = 0,
}

local x_create_effect = class("x_create_effect", clsXUnit)

x_create_effect._default_args = default_args

function x_create_effect:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_create_effect"
end

function x_create_effect:Proc(args, xCtx)
	local atom_id = args.atom_id
	local res_path = args.res_path or default_args.res_path
	local x = args.x or default_args.x
	local y = args.y or default_args.y
	
	xCtx:CreateXEffect(atom_id, res_path)
	
	local tmpEffect = xCtx:GetAtom(atom_id)
	if not tmpEffect then
		log_error("====ERROR: 创建特效失败", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	if KE_TheMap then
		KE_TheMap:AddObject(tmpEffect, x, y)
	end
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_create_effect
