------------------
-- 角色基类
-- 数据、状态、AI
------------------
clsRole = class("clsRole", clsActorModel, clsPhysBody, clsTeamMember)

-- 构造函数
function clsRole:ctor(iUid, TypeId)
	assert(setting.T_card_cfg[TypeId], "无效的TypeId："..TypeId)
	-- 属性数据
	self.mRoleData = KE_Director:GetRoleDataMgr():GetRoleData(iUid)
	assert(self.mRoleData, string.format("不存在该RoleData：Uid=%d",iUid))
	--
	clsActorModel.ctor(self, self.mRoleData:GetiShapeId())
	clsPhysBody.ctor(self)
	clsTeamMember.ctor(self)
	--
	self.Uid = iUid
	self.iDribble = 0
	self.iDribbleFlag = 0
	-- 技能数据
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 1, {iSkillId=1001, iLevel=1})
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 2, {iSkillId=1002, iLevel=1})
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 3, {iSkillId=1003, iLevel=1})
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 4, {iSkillId=1004, iLevel=1})
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 5, {iSkillId=1005, iLevel=1})
	KE_Director:GetSkillDataMgr():UpdateSkillData(iUid, 6, {iSkillId=1006, iLevel=1})
	self.mSkillMgr = clsSkillMgr.new(self)
	self.mSkillMgr:SetSkillPak(KE_Director:GetSkillDataMgr():GetSkillPak(iUid))
	-- 状态
	self.mStateMgr = ClsStateMgr.GetInstance()
	self:ResetStates()
	-- BUFF
	self.mBuffMgr = fight.clsBuffMgr.new(self)
	-- AI
	self.mAiBrain = ai.clsAiBrain.new(self)
	
	-- 根据属性数据刷新外形
	self:SetName(self.mRoleData:GetsName())
end

--析构函数
function clsRole:dtor()
	KE_SafeDelete(self.mSkillMgr)
	self.mSkillMgr = nil
	KE_SafeDelete(self.mAiBrain)
	self.mAiBrain = nil
	KE_SafeDelete(self.mBuffMgr)
	self.mBuffMgr = nil 
	self.mStateMgr = nil
	self:LeaveMap()
end

--@每帧更新
function clsRole:FrameUpdate(deltaTime)
	self.mStateMgr:FrameUpdate(self, deltaTime)
	self.mSkillMgr:FrameUpdate(deltaTime)
	self.mBuffMgr:FrameUpdate(deltaTime)
	
	self.iDribbleFlag = self.iDribbleFlag - 1 
	if self.iDribbleFlag == 0 then
		self:ClearDribble()
	end
end

--
function clsRole:IsTempRole() return self.Uid == -1 end
function clsRole:IsHero() return self:GetRoleType() == const.ROLE_TYPE.TP_HERO end
function clsRole:IsNpc() return self:GetRoleType() == const.ROLE_TYPE.TP_NPC end
function clsRole:IsMonster() return self:GetRoleType() == const.ROLE_TYPE.TP_MONSTER end
function clsRole:IsPlayer() return self:GetRoleType() == const.ROLE_TYPE.TP_PLAYER end
--
function clsRole:GetUid() return self.Uid end
function clsRole:GetRoleType() return const.ROLE_TYPE.TP_UNKNOWN end
function clsRole:GetRoleData() return self.mRoleData end
function clsRole:SetProp(key, value) self.mRoleData:SetAttr(key, value) end
function clsRole:GetProp(key) return self.mRoleData:GetAttr(key) end
function clsRole:GetSkillMgr() return self.mSkillMgr end
function clsRole:GetStateMgr() return self.mStateMgr end
--
function clsRole:GetHPPercent() return self.mRoleData:GetiCurHP()/self.mRoleData:GetiMaxHP() end
function clsRole:GetBlackBoard() return self.mAiBrain:GetBlackBoard() end

-------------------------
-- 
-------------------------
function clsRole:EnterMap(x, y)
	if KE_TheMap then KE_TheMap:AddObject(self, x, y) end
	self:ResetStates()
end

function clsRole:LeaveMap()
	if KE_TheMap then KE_TheMap:RemoveObject(self) end
end

-------------------------
-- AI 
-------------------------
function clsRole:GetAiBrain()
	return self.mAiBrain
end

-------------------------
-- 寻路
-------------------------
function clsRole:SetRoadPath(roadpath) self._mRoadPath = roadpath end
function clsRole:GetRoadPath() return self._mRoadPath end
function clsRole:ClearRoadPath() self._mRoadPath = nil end

-------------------------
-- 状态相关
-------------------------
function clsRole:IsDead() 
	return self.iActState == ROLE_STATE.ST_DIE 
end

function clsRole:ResetStates()
	self:GetStateMgr():ResetStates(self)
end

function clsRole:GetActState() return self.iActState end
function clsRole:GetGrdMovState() return self.iGrdMovState end
function clsRole:GetSkyMovState() return self.iSkyMovState end

function clsRole:GetActStateObj() return self.mActState end
function clsRole:GetGrdMovStateObj() return self.mGrdMovState end
function clsRole:GetSkyMovStateObj() return self.mSkyMovState end

function clsRole:OnActStateChanged(iState, oState)
	self.iActState, self.mActState = iState, oState
end
function clsRole:OnGrdMovStateChanged(iState, oState)
	self.iGrdMovState, self.mGrdMovState = iState, oState
end
function clsRole:OnSkyMovStateChanged(iState, oState)
	self.iSkyMovState, self.mSkyMovState = iState, oState
end

function clsRole:Turn2ActState(iState, args)
	return self.mStateMgr:Turn2ActState(self, iState, args)
end
function clsRole:Turn2GrdMovState(iState, args)
	return self.mStateMgr:Turn2GrdMovState(self, iState, args)
end
function clsRole:Turn2SkyMovState(iState, args)
	return self.mStateMgr:Turn2SkyMovState(self, iState, args)
end
