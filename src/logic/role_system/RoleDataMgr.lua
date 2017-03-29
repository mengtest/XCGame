----------------------
-- 角色属性管理器
-- 注意CountryData CityData RoleData三者之间的同步
----------------------
local clsRoleData = class("clsRoleData",clsDataFace)

clsRoleData:RegSaveVar("Pid", TYPE_CHECKER.INT)						--PID
clsRoleData:RegSaveVar("Uid", TYPE_CHECKER.INT)						--UID
clsRoleData:RegSaveVar("TypeId", TYPE_CHECKER.INT)					--TypeId
clsRoleData:RegSaveVar("iRoleType", TYPE_CHECKER.INT)				--角色类型
--
clsRoleData:RegSaveVar("tEquipInfo", TYPE_CHECKER.TABLE_NIL)		--装备表
clsRoleData:RegSaveVar("CurExp", TYPE_CHECKER.INT)					--经验值
clsRoleData:RegSaveVar("iGrade", TYPE_CHECKER.INT)					--等级
clsRoleData:RegSaveVar("iVipLevel", TYPE_CHECKER.INT)				--VIP等级
clsRoleData:RegSaveVar("UserName", TYPE_CHECKER.STRING_NIL)			--用户名
clsRoleData:RegSaveVar("iMoney", TYPE_CHECKER.INT)					--金币
clsRoleData:RegSaveVar("iDiamond", TYPE_CHECKER.INT)				--钻石
--
clsRoleData:RegSaveVar("iCountryId", TYPE_CHECKER.INT_NIL)			--所属国
clsRoleData:RegSaveVar("CombatForce", TYPE_CHECKER.INT)				--战斗力
clsRoleData:RegSaveVar("iMorale", TYPE_CHECKER.INT_NIL)				--士气
clsRoleData:RegSaveVar("iAngerPower",TYPE_CHECKER.INT_NIL)			--怒气值（范围0到100）
clsRoleData:RegSaveVar("iCurHP",TYPE_CHECKER.INT_NIL)				--当前血量
clsRoleData:RegSaveVar("iCurMP",TYPE_CHECKER.INT_NIL)				--当前法量
--
clsRoleData:RegSaveVar("iRushSpeed",TYPE_CHECKER.INT_NIL)			--冲刺速度
clsRoleData:RegSaveVar("iRunSpeed",TYPE_CHECKER.INT_NIL)			--奔跑速度
clsRoleData:RegSaveVar("iWalkSpeed",TYPE_CHECKER.INT_NIL)			--行走速度
clsRoleData:RegSaveVar("iSceneId", TYPE_CHECKER.INT_NIL)			--在哪个场景

local attr_list = { 
	{"iHeadId", TYPE_CHECKER.INT},
	{"iShapeId", TYPE_CHECKER.INT},
	{"iCareer", function(v) assert(utils.IsValidCareer(v)) end},
	{"iFighterType", TYPE_CHECKER.INT_NIL},
	{"TypeName", TYPE_CHECKER.STRING},
	{"sName", TYPE_CHECKER.STRING_NIL},
	{"iMotherland", TYPE_CHECKER.INT_NIL},
	{"fight_ai", TYPE_CHECKER.STRING_NIL},
	{"iMaxHP", TYPE_CHECKER.INT},
	{"iPhyAtk", TYPE_CHECKER.INT},
	{"iPhyDef", TYPE_CHECKER.INT},
	{"iMagicAtk", TYPE_CHECKER.INT},
	{"iMagicDef", TYPE_CHECKER.INT},
	{"iBroken", TYPE_CHECKER.INT},
	{"iParry", TYPE_CHECKER.INT},
	{"iCriAtk", TYPE_CHECKER.INT},
	{"iCriDef", TYPE_CHECKER.INT},
	{"iCriOdds", TYPE_CHECKER.INT},
	{"iSmartValue", TYPE_CHECKER.INT_NIL},
	{"iPrestige", TYPE_CHECKER.INT_NIL},
	{"iOffice", TYPE_CHECKER.INT_NIL},
	{"iLeadership", TYPE_CHECKER.INT_NIL},
}
clsRoleData:InitByClientCfg(setting.T_card_cfg, "TypeId", attr_list)

function clsRoleData:ctor(iUid, TypeId)
	assert(setting.T_card_cfg[TypeId], "无效的TypeId："..TypeId)
	clsDataFace.ctor(self)
	self:SetUid(iUid)
	self:SetTypeId(TypeId)
	self:SetiRushSpeed(20)
	self:SetiRunSpeed(8)
	self:SetiWalkSpeed(5)
	--
	self:SetiMaxHP(1000)
	self:SetiCurHP(1000)
	--
	self:AddListener("lis_die", "iCurHP", function(Value, OldValue)
		if Value <= 0 then FireGlobalEvent("ROLE_DIE", self:GetUid(), Value) end
	end)
	
	AddMemoryMonitor(self)
end

function clsRoleData:dtor()
	
end

function clsRoleData:GetTroopData()
	return KE_Director:GetTroopMgr():GetGeneralTroopByLeader(self:GetUid())
end


-----------------------------------------------------------

ClsRoleDataMgr = class("ClsRoleDataMgr", clsCoreObject)
ClsRoleDataMgr.__is_singleton = true

ClsRoleDataMgr:RegisterEventType("update_role_data")

function ClsRoleDataMgr:ctor()
	clsCoreObject.ctor(self)
	
	self._HeroId = nil
	self.tAllPlayerData = new_weak_table("v")
	self.tAllNpcData = new_weak_table("v")
	self.tAllMonsterData = new_weak_table("v")
	self.tAllTempData = new_weak_table("v")
	--
	self.tAllData = {}
end

function ClsRoleDataMgr:dtor()
	for _, data in pairs(self.tAllData) do
		KE_SafeDelete(data)
	end
	self.tAllData = nil
	self.tAllPlayerData = nil
	self.tAllNpcData = nil
	self.tAllMonsterData = nil
	self.tAllTempData = nil
end

function ClsRoleDataMgr:SetHeroId(HeroId)
	if self._HeroId ~= nil then
		assert(self._HeroId==HeroId, string.format("HeroId不唯一：%d, %d", self._HeroId, HeroId))
	end
	self._HeroId = HeroId
end

-- 创建/更新
function ClsRoleDataMgr:UpdateHeroData(Info)
	if Info.Uid then assert(self._HeroId==Info.Uid) end
	self.tAllPlayerData[self._HeroId] = self:_update_role_data(self._HeroId, Info)
	self.tAllPlayerData[self._HeroId]:SetiRoleType(const.ROLE_TYPE.TP_HERO)
	return self.tAllPlayerData[self._HeroId]
end

-- 创建/更新
function ClsRoleDataMgr:UpdatePlayerData(iUid, Info)
	assert(iUid ~= self._HeroId, "更新主角数据请使用UpdateHeroData接口")
	self.tAllPlayerData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllPlayerData[iUid]:SetiRoleType(const.ROLE_TYPE.TP_PLAYER)
	return self.tAllPlayerData[iUid]
end

-- 创建/更新
function ClsRoleDataMgr:UpdateNpcData(iUid, Info)
	self.tAllNpcData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllNpcData[iUid]:SetiRoleType(const.ROLE_TYPE.TP_NPC)
	return self.tAllNpcData[iUid]
end

-- 创建/更新
function ClsRoleDataMgr:UpdateMonsterData(iUid, Info)
	self.tAllMonsterData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllMonsterData[iUid]:SetiRoleType(const.ROLE_TYPE.TP_MONSTER)
	return self.tAllMonsterData[iUid]
end

-- 创建/更新
function ClsRoleDataMgr:UpdateTempData(iUid, Info)
	assert(iUid<0, "临时角色Uid需小于0")
	self.tAllTempData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllTempData[iUid]:SetiRoleType(const.ROLE_TYPE.TP_UNKNOWN)
	return self.tAllTempData[iUid]
end

-- 私有接口，外部勿用
function ClsRoleDataMgr:_update_role_data(iUid, Info)
	self.tAllData[iUid] = self.tAllData[iUid] or clsRoleData.new(iUid, Info.TypeId)
	self.tAllData[iUid]:BatchSetAttr(Info)
	self:FireEvent("update_role_data", iUid, self.tAllData[iUid])
	return self.tAllData[iUid]
end

-- 删除
function ClsRoleDataMgr:DestroyRoleData(iUid)
	if self.tAllData[iUid] then
		KE_SafeDelete(self.tAllData[iUid])
		self.tAllData[iUid] = nil
	end
	self.tAllPlayerData[iUid] = nil
	self.tAllNpcData[iUid] = nil
	self.tAllMonsterData[iUid] = nil
	self.tAllTempData[iUid] = nil
end

----------------- getter ---------------------------
function ClsRoleDataMgr:GetHeroData()
	return self.tAllData[self._HeroId]
end

function ClsRoleDataMgr:GetHeroId()
	return self._HeroId
end

function ClsRoleDataMgr:GetRoleData(iUid)
	return self.tAllData[iUid]
end

function ClsRoleDataMgr:GetAllData()
	return self.tAllData
end

function ClsRoleDataMgr:GetAllPlayerData()
	return self.tAllPlayerData
end

function ClsRoleDataMgr:GetAllNpcData()
	return self.tAllNpcData
end

function ClsRoleDataMgr:GetAllMonsterData()
	return self.tAllMonsterData
end

function ClsRoleDataMgr:GetAllTempData()
	return self.tAllTempData
end
