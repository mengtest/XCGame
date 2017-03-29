---------------
--
---------------
module("actree",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["owner_atom"] = 2,
	["cfg_info"] = {
		--资源路径
		["sResPath"] = "effects/particle/skills/SmallSun.plist",
		["sResType"] = "EffectQuad",
		--
		["AfterCollid"] = 0,		--碰撞后表现。0：无   1：爆破（撤出碰撞空间）  2：停止运动  3：粘附到碰撞对象
		["iDelWithOwner"] = 0,		--随施法者消亡而消亡
		--运动轨迹（法术体的运动方式）
		["tTrackCfg"] = {
			["sTrackType"] = "clsMissileLine",		--运动方式
			["sStartPoint"] = "weapon",	--起始位置（根据挂接点确定，也可指定xy坐标）
			["iMoveDir"] = 0,			--移动方向（角度）
			["iMoveSpeed"] = 8,			--移动速度
			["iMoveDis"] = 150,			--移动距离
		}
	}
}

local v_add_missile = class("v_add_missile", clsXUnit)

v_add_missile._default_args = default_args

function v_add_missile:ctor(args, xCtx, oXTree)
	clsXUnit.ctor(self, args, xCtx, oXTree)
	self._node_type = "v_add_missile"
end

function v_add_missile:Proc(args, xCtx)
	local atom_id = args.atom_id
	local owner_atom = args.owner_atom
	local cfg_info = args.cfg_info 
	
	local theOwner = xCtx:GetAtom(owner_atom)
	if not theOwner then
		log_error("====ERROR: 不存在该角色", owner_atom, self._node_type)
		self:on_event_point(XEventEnum.ec_xstart)
		self:trigger_user_events()
		self:on_event_point(XEventEnum.ec_xfinish)
		return
	end
	
	xCtx:CreateXMissile(atom_id, theOwner, cfg_info)
	
	self:on_event_point(XEventEnum.ec_xstart)
	self:trigger_user_events()
	self:on_event_point(XEventEnum.ec_xfinish)
end

return v_add_missile
