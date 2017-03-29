---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["deltaX"] = 40,
	["deltaY"] = 40,
	["jmpHeight"] = 200,
	["jmpTimes"] = 1,
}

local x_jump_by = class("x_jump_by", clsXUnit)

x_jump_by._default_args = default_args

function x_jump_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_jump_by"
end

function x_jump_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXJumpBy then
		target:stopAction(target._tmpXJumpBy)
		target._tmpXJumpBy = nil
	end
end

function x_jump_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local seconds = args.seconds or default_args.seconds
	local deltaX = args.deltaX or default_args.deltaX
	local deltaY = args.deltaY or default_args.deltaY
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
		tmpAtom._tmpXJumpBy = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXJumpBy = tmpAtom:runAction(cc.Sequence:create(
		cc.JumpBy:create(seconds, cc.p(deltaX,deltaY), jmpHeight, jmpTimes), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_jump_by
