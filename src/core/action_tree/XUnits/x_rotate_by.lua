---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["Angle"] = 360,
}

local x_rotate_by = class("x_rotate_by", clsXUnit)

x_rotate_by._default_args = default_args

function x_rotate_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_rotate_by"
end

function x_rotate_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXRotateBy then
		target:stopAction(target._tmpXRotateBy)
		target._tmpXRotateBy = nil
	end
end

function x_rotate_by:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local seconds = args.seconds or default_args.seconds
	local Angle = args.Angle or default_args.Angle
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXRotateBy = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXRotateBy = tmpAtom:runAction(cc.Sequence:create(
		cc.RotateBy:create(seconds, Angle), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_rotate_by
