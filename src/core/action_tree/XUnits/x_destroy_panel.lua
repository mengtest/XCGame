---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
}

local x_destroy_panel = class("x_destroy_panel", clsXUnit)

x_destroy_panel._default_args = default_args

function x_destroy_panel:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_destroy_panel"
end

function x_destroy_panel:Proc(args, xCtx)
	local atom_id = args.atom_id
	
	if not xCtx:GetXPanel(atom_id) then 
		log_error("====ERROR: 要删除的面板不存在：", atom_id, self._node_type) 
	end
	xCtx:DestroyXPanel(atom_id)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_destroy_panel
