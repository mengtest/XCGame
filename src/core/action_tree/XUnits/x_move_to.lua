---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["sx"] = 0,
	["sy"] = 0,
	["dx"] = 0,
	["dy"] = 0,
	["seconds"] = 2,
}

local x_move_to = class("x_move_to", clsXUnit)

x_move_to._default_args = default_args

function x_move_to:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_move_to"
end

function x_move_to:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXMoveTo then
		target:stopAction(target._tmpXMoveTo)
		target._tmpXMoveTo = nil
	end
end

function x_move_to:Proc(args, xCtx)
	local atom_id = args.atom_id
	local sx = args.sx
	local sy = args.sy
	local dx = args.dx
	local dy = args.dy
	local seconds = args.seconds
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	if sx and sy then tmpAtom:setPosition(sx, sy) end
	
	local function on_finish()
		tmpAtom._tmpXMoveTo = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXMoveTo = tmpAtom:runAction(cc.Sequence:create(
		cc.MoveTo:create(seconds, cc.p(dx, dy)), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_move_to
