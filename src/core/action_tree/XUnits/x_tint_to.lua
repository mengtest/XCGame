---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["r"] = 1,
	["g"] = 222,
	["b"] = 112,
}

local x_tint_to = class("x_tint_to", clsXUnit)

x_tint_to._default_args = default_args

function x_tint_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_tint_to"
end

function x_tint_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXTintTo then
		target:GetBody():stopAction(target._tmpXTintTo)
		target._tmpXTintTo = nil
	end
end

function x_tint_to:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local seconds = args.seconds or default_args.seconds
	local r = args.r and default_args.r
	local g = args.g and default_args.g
	local b = args.b and default_args.b
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXTintTo = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXTintTo = tmpAtom:GetBody():runAction(cc.Sequence:create(
		cc.TintTo:create(seconds, r, g, b), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_tint_to
