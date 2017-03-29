---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["owner_atom"] = 1,
	["tDamageInfo"] = {
		["iDamagePower"] = 50,			--伤害值
		["iIsSingleAtk"] = 0,			--单攻or群攻
		["AffectFunc"] = {
			["funcName"] = "OnEcImpact",
			["param"] = {
				["iSPframe"] = 20,		--水平方向力（移动距离）
				["iSPspeed"] = 25,		--水平方向速度（移动速度）
				["iCZspeed"] = 0,			--垂直方向力（上为正，下为负）
			},
		},
	},
}

local v_add_harm = class("v_add_harm", clsXUnit)

v_add_harm._default_args = default_args

function v_add_harm:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "v_add_harm"
end

function v_add_harm:Proc(args, xCtx)
	local owner_atom = args.owner_atom
	local tDamageInfo = args.tDamageInfo 
	
	local theOwner = xCtx:GetAtom(owner_atom)
	if not theOwner then
		log_error("====ERROR: 不存在该角色", owner_atom, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	theOwner:SetDamageInfo(tDamageInfo)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return v_add_harm
