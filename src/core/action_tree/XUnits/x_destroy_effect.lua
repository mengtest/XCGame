---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
}

local x_destroy_effect = class("x_destroy_effect", clsXUnit)

x_destroy_effect._default_args = default_args

function x_destroy_effect:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_destroy_effect"
end

function x_destroy_effect:Proc(args, xCtx)
	local atom_id = args.atom_id
	
	if not xCtx:GetXEffect(atom_id) then 
		log_error("====ERROR: 要删除的特效不存在：", atom_id, self._node_type) 
	end
	xCtx:DestroyXEffect(atom_id)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return x_destroy_effect
