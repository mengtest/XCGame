---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["toAngle"] = 0,
}

local x_rotate_to = class("x_rotate_to", clsXUnit)

x_rotate_to._default_args = default_args

function x_rotate_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_rotate_to"
end

function x_rotate_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXRotateTo then
		target:stopAction(target._tmpXRotateTo)
		target._tmpXRotateTo = nil
	end
end

function x_rotate_to:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local seconds = args.seconds or default_args.seconds
	local toAngle = args.toAngle or default_args.toAngle
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXRotateTo = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXRotateTo = tmpAtom:runAction(cc.Sequence:create(
		cc.RotateTo:create(seconds, toAngle), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_rotate_to
