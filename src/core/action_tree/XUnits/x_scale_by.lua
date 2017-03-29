---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["scaleX"] = 2,
	["scaleY"] = 2,
	["seconds"] = 1,
}

local x_scale_by = class("x_scale_by", clsXUnit)

x_scale_by._default_args = default_args

function x_scale_by:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_scale_by"
end

function x_scale_by:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target and target._tmpXScaleBy then
		target:stopAction(target._tmpXScaleBy)
		target._tmpXScaleBy = nil
	end
end

function x_scale_by:Proc(args, xCtx)
	local atom_id = args.atom_id
	local scaleX = args.scaleX
	local scaleY = args.scaleY
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
		tmpAtom._tmpXScaleBy = nil
		self:on_event_point(XEventEnum.ec_xfinish)
	end
	tmpAtom._tmpXScaleBy = tmpAtom:runAction(cc.Sequence:create(
		cc.ScaleBy:create(seconds, scaleX, scaleY), 
		cc.CallFunc:create(on_finish)
	))
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_scale_by
