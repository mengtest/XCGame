---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["words"] = "不要逼我骂你！",
}

local x_pop_say = class("x_pop_say", clsXUnit)

x_pop_say._default_args = default_args

function x_pop_say:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_pop_say"
end

function x_pop_say:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target then target:StopSay() end
end

function x_pop_say:Proc(args, xCtx)
	local atom_id = args.atom_id
	local sWords = args.words or default_args.words
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	tmpChar:PopSay(sWords, function()
		self:on_event_point(XEventEnum.ec_xfinish)
	end)
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
end

return x_pop_say
