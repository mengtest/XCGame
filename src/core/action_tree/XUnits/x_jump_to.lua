---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["dstX"] = 40,
	["dstY"] = 40,
	["jmpHeight"] = 100,
	["jmpTimes"] = 1,
}

local x_jump_to = class("x_jump_to", clsXUnit)

x_jump_to._default_args = default_args

function x_jump_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_jump_to"
end

function x_jump_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXJumpTo then
		target:stopAction(target._tmpXJumpTo)
		target._tmpXJumpTo = nil
	end
end

function x_jump_to:Proc(args, xCtx)
	local atom_id = args.atom_id
	local seconds = args.seconds or default_args.seconds
	local dstX = args.dstX or default_args.dstX
	local dstY = args.dstY or default_args.dstY
	local jmpHeight = args.jmpHeight or default_args.jmpHeight
	local jmpTimes = args.jmpTimes or default_args.jmpTimes
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXJumpTo = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXJumpTo = tmpAtom:runAction(cc.Sequence:create(
		cc.JumpTo:create(seconds, cc.p(dstX,dstY), jmpHeight, jmpTimes), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_jump_to
