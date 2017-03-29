---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["times"] = 20,
}

local x_blink = class("x_blink", clsXUnit)

x_blink._default_args = default_args

function x_blink:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_blink"
end

function x_blink:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXBlink then
		target:stopAction(target._tmpXBlink)
		target._tmpXBlink = nil
	end
end

function x_blink:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local seconds = args.seconds or default_args.seconds
	local times = args.times and default_args.times
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXBlink = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXBlink = tmpAtom:runAction(cc.Sequence:create(
		cc.Blink:create(seconds, times), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_blink
