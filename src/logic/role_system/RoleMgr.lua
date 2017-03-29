--------------------
-- 角色管理器
--------------------
ClsRoleMgr = class("ClsRoleMgr")
ClsRoleMgr.__is_singleton = true

function ClsRoleMgr:ctor()
	self._bUpdateing = false
	self.tDelList = {}
	self.tTmpDelList = {}
	
	self.tAllPlayer = {}		--所有玩家
	self.tAllNpc = {}			--所有NPC
	self.tAllMonster = {}		--所有怪物
	self.tAllTempRole = new_weak_table("k")		--所有临时角色
	
	g_EventMgr:AddListener("ClsRoleMgr", "LEAVE_WORLD", function() 
		self:DestroyAllPlayer()
		self:DestroyAllNpc()
		self:DestroyAllMonster()
		self:DestroyAllTempRole()
	end)
end

function ClsRoleMgr:dtor()
	g_EventMgr:DelListener("ClsRoleMgr")
	self:DestroyAllPlayer()
	self:DestroyAllNpc()
	self:DestroyAllMonster()
	self:DestroyAllTempRole()
end

--@每帧更新
function ClsRoleMgr:FrameUpdate(deltaTime)
	self._bUpdateing = true
	for _, obj in pairs(self.tAllPlayer)  do obj:FrameUpdate(deltaTime) end
	for _, obj in pairs(self.tAllNpc)     do obj:FrameUpdate(deltaTime) end
	for _, obj in pairs(self.tAllMonster) do obj:FrameUpdate(deltaTime) end
	for tmpRole, _ in pairs(self.tAllTempRole) do tmpRole:FrameUpdate(deltaTime) end 
	self._bUpdateing = false
	
	self:ClearDelList()
end

function ClsRoleMgr:ClearDelList()
	for _, obj in ipairs(self.tTmpDelList) do
		self:DestroyTempRole(obj)
	end
	self.tTmpDelList = {}
	
	for _, iUid in ipairs(self.tDelList) do
		self:DestroyRole(iUid)
	end
	self.tDelList = {}
end

function ClsRoleMgr:SetLock(bLock)
	self._bUpdateing = bLock
end

function ClsRoleMgr:IsRoleDead(role_id)
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(role_id)
	assert(RoleData, "不存在角色数据："..role_id)
	return RoleData:GetiCurHP() <= 0
end

--------------分割线----------------------------

-- 创建临时角色
function ClsRoleMgr:CreateTempRole(TypeId)
	KE_Director:GetRoleDataMgr():UpdateTempData(const.TEMP_ROLE_ID, {TypeId=TypeId})
	local tmpRole = clsRole.new(const.TEMP_ROLE_ID, TypeId)
	self.tAllTempRole[tmpRole] = true
	tmpRole:retain()
	return tmpRole
end

-- 销毁临时角色
function ClsRoleMgr:DestroyTempRole(tmpRole)
	if self._bUpdateing then
		table.insert(self.tTmpDelList, tmpRole)
		return
	end
	if self.tAllTempRole[tmpRole] then
		self.tAllTempRole[tmpRole] = nil
		KE_SafeDelete(tmpRole)
		tmpRole:release()
	end
end

-- 销毁所有临时角色
function ClsRoleMgr:DestroyAllTempRole()
	for tmpRole, _ in pairs(self.tAllTempRole) do
		KE_SafeDelete(tmpRole)
		tmpRole:release()
	end
	self.tAllTempRole = {}
end

--------------分割线----------------------------

function ClsRoleMgr:CreateHero()
	local iHeroId = KE_Director:GetHeroId()
	assert(KE_Director:GetRoleDataMgr():GetRoleData(iHeroId), "角色数据丢失: "..iHeroId)
	if self.tAllPlayer[iHeroId] then return self.tAllPlayer[iHeroId] end
	
	local TypeId = KE_Director:GetHeroData():GetTypeId()
	self.tAllPlayer[iHeroId] = clsHero.new(iHeroId, TypeId)
	self.tAllPlayer[iHeroId]:retain()
	return self.tAllPlayer[iHeroId]
end

function ClsRoleMgr:CreatePlayer(iUid)
	assert( (iUid>=const.PLAYER_ID_BEGIN and iUid<=const.PLAYER_ID_END), "【错误】not valid player id" )
	assert(KE_Director:GetRoleDataMgr():GetRoleData(iUid), "角色数据丢失: "..iUid)
	if self.tAllPlayer[iUid] then return self.tAllPlayer[iUid] end
	
	local TypeId = KE_Director:GetRoleDataMgr():GetRoleData(iUid):GetTypeId()
	self.tAllPlayer[iUid] = clsPlayer.new(iUid, TypeId)
	self.tAllPlayer[iUid]:retain()
	return self.tAllPlayer[iUid]
end

function ClsRoleMgr:CreateNpc(iUid)
	assert( (iUid>=const.NPC_ID_BEGIN and iUid<=const.NPC_ID_END), "【错误】not valid npc id" )
	assert(KE_Director:GetRoleDataMgr():GetRoleData(iUid), "角色数据丢失: "..iUid)
	if self.tAllNpc[iUid] then return self.tAllNpc[iUid] end
	
	local TypeId = KE_Director:GetRoleDataMgr():GetRoleData(iUid):GetTypeId()
	self.tAllNpc[iUid] = clsNpc.new(iUid, TypeId)
	self.tAllNpc[iUid]:retain()
	return self.tAllNpc[iUid]
end

function ClsRoleMgr:CreateMonster(iUid)
	assert( (iUid>=const.MONSTER_ID_BEGIN and iUid<=const.MONSTER_ID_END), "【错误】not valid monster id" )
	assert(KE_Director:GetRoleDataMgr():GetRoleData(iUid), "角色数据丢失: "..iUid)
	if self.tAllMonster[iUid] then return self.tAllMonster[iUid] end
	
	local TypeId = KE_Director:GetRoleDataMgr():GetRoleData(iUid):GetTypeId()
	self.tAllMonster[iUid] = clsMonster.new(iUid, TypeId)
	self.tAllMonster[iUid]:retain()
	return self.tAllMonster[iUid]
end

function ClsRoleMgr:CreateRole(iUid)
	local RoleData = KE_Director:GetRoleDataMgr():GetRoleData(iUid)
	assert(RoleData, "角色数据丢失："..iUid)
	if not RoleData then return end
	
	local roleType = RoleData:GetiRoleType()
	
	if roleType == const.ROLE_TYPE.TP_HERO then
		assert(iUid==KE_Director:GetHeroId(), string.format("不可创建为主角类型：%d",iUid))
		return self:CreateHero()
	elseif roleType == const.ROLE_TYPE.TP_PLAYER then
		return self:CreatePlayer(iUid)
	elseif roleType == const.ROLE_TYPE.TP_MONSTER then
		return self:CreateMonster(iUid)
	elseif roleType == const.ROLE_TYPE.TP_NPC then
		return self:CreateNpc(iUid)
	else 
		log_error("未知的角色类型：", iUid, roleType)
		assert(false, "未知角色类型")
	end
end

---------------------------------

function ClsRoleMgr:DestroyHero()
	self:DestroyPlayer(KE_Director:GetHeroId())
end

function ClsRoleMgr:DestroyPlayer(iUid)
	if self._bUpdateing then
		table.insert(self.tDelList, iUid)
		return
	end
	if self.tAllPlayer[iUid] then
		KE_SafeDelete(self.tAllPlayer[iUid])
		self.tAllPlayer[iUid]:release()
		self.tAllPlayer[iUid] = nil
	end
end

function ClsRoleMgr:DestroyNpc(iUid)
	if self._bUpdateing then
		table.insert(self.tDelList, iUid)
		return
	end
	if self.tAllNpc[iUid] then
		KE_SafeDelete(self.tAllNpc[iUid])
		self.tAllNpc[iUid]:release()
		self.tAllNpc[iUid] = nil
	end
end

function ClsRoleMgr:DestroyMonster(iUid)
	if self._bUpdateing then
		table.insert(self.tDelList, iUid)
		return
	end
	if self.tAllMonster[iUid] then
		KE_SafeDelete(self.tAllMonster[iUid])
		self.tAllMonster[iUid]:release()
		self.tAllMonster[iUid] = nil
	end
end

function ClsRoleMgr:DestroyRole(iUid)
	if self.tAllMonster[iUid] then
		self:DestroyMonster(iUid)
	elseif self.tAllPlayer[iUid] then
		self:DestroyPlayer(iUid)
	elseif self.tAllNpc[iUid] then
		self:DestroyNpc(iUid)
	end
end

function ClsRoleMgr:DestroyAllPlayer()
	for iUid, obj in pairs(self.tAllPlayer) do
		KE_SafeDelete(self.tAllPlayer[iUid])
		self.tAllPlayer[iUid]:release()
	end
	self.tAllPlayer = {}
end

function ClsRoleMgr:DestroyAllNpc()
	for iUid, obj in pairs(self.tAllNpc) do
		KE_SafeDelete(self.tAllNpc[iUid])
		self.tAllNpc[iUid]:release()
	end
	self.tAllNpc = {}
end

function ClsRoleMgr:DestroyAllMonster()
	for iUid, obj in pairs(self.tAllMonster) do
		KE_SafeDelete(self.tAllMonster[iUid])
		self.tAllMonster[iUid]:release()
	end
	self.tAllMonster = {}
end

-----------------------------

function ClsRoleMgr:ShowAllMonster(bShow)
	if self._bShowAllMonster == bShow then return end
	self._bShowAllMonster = bShow
	for iUid, obj in pairs(self.tAllMonster) do
		obj:ShowBody(bShow)
	end
end

function ClsRoleMgr:ShowAllNpc(bShow)
	if self._bShowAllNpc == bShow then return end
	self._bShowAllNpc = bShow
	for iUid, obj in pairs(self.tAllNpc) do
		obj:ShowBody(bShow)
	end
end

function ClsRoleMgr:ShowAllPlayer(bShow)
	if self._bShowAllPlayer == bShow then return end
	self._bShowAllPlayer = bShow
	for iUid, obj in pairs(self.tAllPlayer) do
		obj:ShowBody(bShow)
	end
	if self:GetHero() then
		self:GetHero():ShowBody(true)
	end
end

function ClsRoleMgr:IsShowMonster() return self._bShowAllMonster end
function ClsRoleMgr:IsShowNpc() return self._bShowAllNpc end
function ClsRoleMgr:IsShowPlayer() return self._bShowAllPlayer end

-----------------------------

function ClsRoleMgr:GetRole(iUid)
	return self.tAllPlayer[iUid] or self.tAllNpc[iUid] or self.tAllMonster[iUid] or nil
end
function ClsRoleMgr:GetHero() return self.tAllPlayer[KE_Director:GetHeroId()] end
function ClsRoleMgr:GetPlayer(iUid) return self.tAllPlayer[iUid] end
function ClsRoleMgr:GetNpc(iUid) return self.tAllNpc[iUid] end
function ClsRoleMgr:GetMonster(iUid) return self.tAllMonster[iUid] end
