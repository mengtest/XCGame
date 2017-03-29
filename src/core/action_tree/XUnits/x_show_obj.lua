---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	atom_id = 1,
}

local x_show_obj = class("x_show_obj", clsXUnit)

x_show_obj._default_args = default_args

function x_show_obj:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_show_obj"
end

function x_show_obj:Proc(args, xCtx)
	local atom_id = args.atom_id 
	
	local tmpAtom = xCtx:GetAtom(atom_id)
	if not tmpAtom then
		log_error("====ERROR: 不存在该元素", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpAtom:setVisible(true)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_show_obj
