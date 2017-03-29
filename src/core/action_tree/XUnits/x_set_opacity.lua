---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["alpha"] = 255,
}

local x_set_opacity = class("x_set_opacity", clsXUnit)

x_set_opacity._default_args = default_args

function x_set_opacity:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_set_opacity"
end

function x_set_opacity:Proc(args, xCtx)
	local atom_id = args.atom_id
	local alpha = args.alpha or default_args.alpha
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpChar:setOpacity(alpha)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_set_opacity
