---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["stepx"] = 0,
	["stepy"] = 0,
	["seconds"] = 2,
}

local x_move_by = class("x_move_by", clsXUnit)

x_move_by._default_args = default_args

function x_move_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_move_by"
end

function x_move_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXMoveBy then
		target:stopAction(target._tmpXMoveBy)
		target._tmpXMoveBy = nil
	end
end

function x_move_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local stepx = args.stepx
	local stepy = args.stepy
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
		tmpAtom._tmpXMoveBy = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXMoveBy = tmpAtom:runAction(cc.Sequence:create(
		cc.MoveBy:create(seconds, cc.p(stepx, stepy)), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_move_by
