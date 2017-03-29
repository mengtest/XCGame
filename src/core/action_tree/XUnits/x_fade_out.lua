---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
}

local x_fade_out = class("x_fade_out", clsXUnit)

x_fade_out._default_args = default_args

function x_fade_out:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_fade_out"
end

function x_fade_out:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXFadeOut then
		target:GetBody():stopAction(target._tmpXFadeOut)
		target._tmpXFadeOut = nil
	end
end

function x_fade_out:Proc(args, xCtx)
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
		tmpAtom._tmpXFadeOut = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXFadeOut = tmpAtom:GetBody():runAction(cc.Sequence:create(
		cc.FadeOut:create(seconds), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_fade_out
