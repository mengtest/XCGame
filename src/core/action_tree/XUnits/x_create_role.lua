---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["TypeId"] = 10001,
	["iShapeId"] = 32000,
	["x"] = 110,
	["y"] = 110,
}

local x_create_role = class("x_create_role", clsXUnit)

x_create_role._default_args = default_args

function x_create_role:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_create_role"
end

function x_create_role:Proc(args, xCtx)
	local atom_id = args.atom_id 
--	local iShapeId = args.iShapeId or default_args.iShapeId
	local TypeId = args.TypeId or default_args.TypeId
	local x = args.x or default_args.x
	local y = args.y or default_args.y
	
	xCtx:CreateXRole(atom_id, TypeId)
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		log_error("====ERROR: 创建角色失败", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	if args.iShapeId then tmpChar:SetShapeId(args.iShapeId) end
	tmpChar:EnterMap(x, y)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_create_role
