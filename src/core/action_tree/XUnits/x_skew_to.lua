---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["SkewX"] = 40,
	["SkewY"] = -40,
	["seconds"] = 1,
}

local x_skew_to = class("x_skew_to", clsXUnit)

x_skew_to._default_args = default_args

x_skew_to._default_args = default_args

function x_skew_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_skew_to"
end

function x_skew_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXSkewTo then
		target:stopAction(target._tmpXSkewTo)
		target._tmpXSkewTo = nil
	end
end

function x_skew_to:Proc(args, xCtx)
	local atom_id = args.atom_id
	local SkewX = args.SkewX
	local SkewY = args.SkewY
	local seconds = args.seconds
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXSkewTo = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXSkewTo = tmpAtom:runAction(cc.Sequence:create(
		cc.SkewTo:create(seconds, SkewX, SkewY), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_skew_to
