---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["seconds"] = 1,
	["tension"] = 0.5,
	["pt_list"] = {
		{x=0, y=0},
		{x=277, y=0},
		{x=277, y=556},
		{x=0, y=222},
		{x=0, y=0},
		{x=222, y=666},
	},
}

local x_cardinal_spline_by = class("x_cardinal_spline_by", clsXUnit)

x_cardinal_spline_by._default_args = default_args

function x_cardinal_spline_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_cardinal_spline_by"
end

function x_cardinal_spline_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXCardinalSplineBy then
		target:stopAction(target._tmpXCardinalSplineBy)
		target._tmpXCardinalSplineBy = nil
	end
end

function x_cardinal_spline_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local seconds = args.seconds or default_args.seconds
	local pt_list = args.pt_list or default_args.pt_list
	local tension = args.tension or default_args.tension
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local function on_finish()
		tmpAtom._tmpXCardinalSplineBy = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXCardinalSplineBy = tmpAtom:runAction(cc.Sequence:create(
		cc.CardinalSplineBy:create(seconds, pt_list, tension), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_cardinal_spline_by
