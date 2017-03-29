---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
}

local x_fade_in = class("x_fade_in", clsXUnit)

x_fade_in._default_args = default_args

function x_fade_in:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_fade_in"
end

function x_fade_in:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXFadeIn then
		target:GetBody():stopAction(target._tmpXFadeIn)
		target._tmpXFadeIn = nil
	end
end

function x_fade_in:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local seconds = args.seconds or default_args.seconds
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXFadeIn = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXFadeIn = tmpAtom:GetBody():runAction(cc.Sequence:create(
		cc.FadeIn:create(seconds), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_fade_in
