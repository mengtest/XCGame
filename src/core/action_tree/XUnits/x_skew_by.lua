---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["deltaSkewX"] = 40,
	["deltaSkewY"] = -40,
	["seconds"] = 1,
}

local x_skew_by = class("x_skew_by", clsXUnit)

x_skew_by._default_args = default_args

x_skew_by._default_args = default_args

function x_skew_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_skew_by"
end

function x_skew_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXSkewBy then
		target:stopAction(target._tmpXSkewBy)
		target._tmpXSkewBy = nil
	end
end

function x_skew_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local deltaSkewX = args.deltaSkewX
	local deltaSkewY = args.deltaSkewY
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
		tmpAtom._tmpXSkewBy = nil 
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXSkewBy = tmpAtom:runAction(cc.Sequence:create(
		cc.SkewBy:create(seconds, deltaSkewX, deltaSkewY), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_skew_by
