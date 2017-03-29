---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["res_path"] = "src/data/uiconfigs/ui_dialog/confirm_dlg.lua",
	["x"] = 500,
	["y"] = 400,
}

local x_create_panel = class("x_create_panel", clsXUnit)

x_create_panel._default_args = default_args

function x_create_panel:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_create_panel"
end

function x_create_panel:Proc(args, xCtx)
	local atom_id = args.atom_id or default_args.atom_id
	local res_path = args.res_path or default_args.res_path
	local x = args.x or default_args.x
	local y = args.y or default_args.y
	
	xCtx:CreateXPanel(atom_id, res_path)
	
	local tmpPanel = xCtx:GetAtom(atom_id)
	if not tmpPanel then
		log_error("====ERROR: 创建面板失败", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpPanel:setPosition(x,y)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_create_panel
