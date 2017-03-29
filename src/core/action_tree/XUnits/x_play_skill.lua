---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["skill_index"] = 1,
	["times"] = 1,
}

local x_play_skill = class("x_play_skill", clsXUnit)

x_play_skill._default_args = default_args

function x_play_skill:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "x_play_skill"
end

function x_play_skill:OnStop()
	local atom_id = self:GetArgs().atom_id
	local target = self:GetXContext():GetAtom(atom_id)
	if target then
		target:break_skill()
	end
end

function x_play_skill:Proc(args, xCtx)
	local atom_id = args.atom_id
	local skill_index = args.skill_index or default_args.skill_index
	local times = args.times or default_args.times
	
	local tmpChar = xCtx:GetXRole(atom_id)
	if not tmpChar then
		log_error("====ERROR: 不存在该角色", atom_id, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	local callback = function() self:on_event_point(XEventEnum.ec_xfinish) end
	if tmpChar:CallSkill(skill_index, callback, callback) then
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
	else
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
	end
end

return x_play_skill
