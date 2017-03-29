---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
}

local v_destroy_missile = class("v_destroy_missile", clsXUnit)

v_destroy_missile._default_args = default_args

function v_destroy_missile:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "v_destroy_missile"
end

function v_destroy_missile:Proc(args, xCtx)
	local atom_id = args.atom_id 
	
	local Bullet = xCtx:GetAtom(atom_id)
	if not Bullet then
		log_error("====ERROR: 要删除的子弹不存在: ", atom_id, self._node_type)
	end
	
	xCtx:DestroyXMissile(atom_id)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return v_destroy_missile
