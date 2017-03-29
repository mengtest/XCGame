---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["owner_atom"] = 1,
}

local v_del_harm = class("v_del_harm", clsXUnit)

v_del_harm._default_args = default_args

function v_del_harm:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "v_del_harm"
end

function v_del_harm:Proc(args, xCtx)
	local owner_atom = args.owner_atom
	
	local theOwner = xCtx:GetAtom(owner_atom)
	if not theOwner then
		log_error("====ERROR: 不存在该角色", owner_atom, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	theOwner:SetDamageInfo(nil)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return v_del_harm
