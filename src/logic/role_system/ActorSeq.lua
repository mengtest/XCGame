-----------------------
-- 职责：动作与换装
-- 序列帧动画
-----------------------

local map_sAniKey_2_iAni = {
	[const.ANI_IDLE] = 1,
	[const.ANI_WALK] = 2,
	[const.ANI_RUN] = 3,
	[const.ANI_JUMP] = 8,
	[const.ANI_ATTACK_1] = 4,
	[const.ANI_SKILL_1] = 5,
	[const.ANI_HIT] = 6,
	[const.ANI_DIE] = 7,
}


------------- 分割线 ------------------------------------

clsActorSeq = class("clsActorSeq", clsGameObject)

-- 构造函数
function clsActorSeq:ctor(iShapeId)
	clsGameObject.ctor(self)
	AddMemoryMonitor(self)
	
	self._mBody = nil			--动画
	self.mShadowSpr = nil		--影子
	self.mNameLabel = nil		--名字
	self.mCompPopSay = nil		--冒泡说话
	
	self:SetShapeId(iShapeId)
	self:ShowShadow(true)
end

--析构函数
function clsActorSeq:dtor()
	KE_RemoveFromParent(self)
	self.body = nil
end

--@每帧更新
function clsActorSeq:FrameUpdate(deltaTime)
	
end

-- 刷新外观（影响因素：套装 + 方向 + 动作）
function clsActorSeq:_RefreshAppearance()
	if not self._mBody then
		self._mBody = cc.Sprite:create()
		KE_SetParent(self._mBody, self)
		self._mBody:setScale(1.5)
	end
	
	local curDir8 = math.EightDir(self._iCurDir)
	local aniKey = self.sAniKey
	local resId	= self._ShapeId
	if not resId then return end
	
	local ani = self:_loadAnimate(resId, aniKey, curDir8)
	if not ani then return end
	
	self._mBody:stopAllActions()
	local function onAniOver(sender)
		if self._tAniOverCallData then
			local callbackFunc = self._tAniOverCallData.callbackFunc
			local args = self._tAniOverCallData.args
			self._tAniOverCallData = nil
			callbackFunc(unpack(args))
		else
			
		end
	end
	
	self._mBody:runAction(cc.Sequence:create(
		ani,
		cc.CallFunc:create(function() 
			onAniOver()
		end)
	))
	
	local needFlipX = (curDir8 == const.DIRECTION8.L or curDir8 == const.DIRECTION8.LU or curDir8 == const.DIRECTION8.LD)
	self._mBody:setFlippedX(needFlipX)
end

function clsActorSeq:_LoadBody()
	local iShapeId = self._ShapeId
	if not iShapeId then return end
	
	local texPath = string.format("res/role/%d/tex/%d.plist", iShapeId, iShapeId)
	ClsResMgr.GetInstance():AddSpriteFrames(texPath)
	
	self:_RefreshAppearance()
end

function clsActorSeq:_UnloadBody()
	if not self._mBody then return end
	if self._mBody then KE_SafeDelete(self._mBody) self._mBody = nil end
end

---------------------------------------------
-- 换装部分 -->
---------------------------------------------
function clsActorSeq:SetShapeId(iShapeId)
	assert(is_number(iShapeId), "没有造型")
	if self._ShapeId == iShapeId then return end
	self._ShapeId = iShapeId
	self:_LoadBody()
end

function clsActorSeq:SetEquipment(equip_info)
	assert(is_table(equip_info) or equip_info==nil)
end

---------------------------------------------
-- 动作部分 -->
---------------------------------------------

-- 设置动作（Idle Jump Run Walk Dance Skill001 Die Cry ...）
function clsActorSeq:SetAni(sAniKey, callback, ...)
	if self.sAniKey == sAniKey then return end
	
	self.sAniKey = sAniKey
	self:_RefreshAppearance()
	
	if callback then
		self._tAniOverCallData = {
			callbackFunc = callback,
			args = {...}
		}
	end
end

function clsActorSeq:PlayAni(sAniKey, Callback)
	self:SetAni(sAniKey, Callback)
end

function clsActorSeq:PauseAni(iFrame)
	
end

function clsActorSeq:ResumeAni(iFrame)
	
end

-- 获取动作Key
function clsActorSeq:GetAni()
	return self.sAniKey
end


local function getAnimate(iShapeId, sAniKey, iDir)
	local aniFrames = {}
	local iAni = map_sAniKey_2_iAni[sAniKey]
	local frameIdx = 0
	
	while true do
		if (iDir < 8 and iDir > 4) then iDir = 8 - iDir end
		local frameName = string.format("%d_%d_%d_%02d.png", iShapeId, iAni, iDir, frameIdx)
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not spriteFrame then break end
		table.insert(aniFrames, spriteFrame)
		frameIdx = frameIdx + 1
	end
	
	local _animation = cc.Animation:createWithSpriteFrames(aniFrames, 0.05)
	local _animation = cc.Animate:create(_animation)
   	return _animation
end
function clsActorSeq:_loadAnimate(iShapeId, sAniKey, iDir)
	if not iShapeId or not sAniKey or not iDir then return end
	
	local avatarKey = string.format("ani_%d_%s_%d", iShapeId, sAniKey, iDir)
	if self._sAvatarKey == avatarKey then return end
	self._sAvatarKey = avatarKey
	
	local ani = getAnimate(iShapeId, sAniKey, iDir)
	assert(ani, "加载动作失败: "..sAniKey)
	
	return ani
end

----------------------------
-- 物理性质
----------------------------

function clsActorSeq:OnDirectionChanged(iDir, oldDir)
	if math.EightDir(oldDir) ~= math.EightDir(iDir) then 
		self:_RefreshAppearance() 
	end
end

----------------------------
-- 功能接口
----------------------------

function clsActorSeq:GetNameLblH()
	return self:GetBodyHeight() + 15
end

--显示影子
function clsActorSeq:ShowShadow(bShow)
	if not self.mShadowSpr then
		self.mShadowSpr = cc.Sprite:create("res/role/shadow.png")
		KE_SetParent(self.mShadowSpr, self)
	end
	self.mShadowSpr:setVisible(bShow)
end

--设置名字
function clsActorSeq:SetName(sName)
	sName = sName or "滴滴滴"
	if not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(const.DEF_FONT_CFG(), sName)
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	self.mNameLabel:setString(sName)
end

--显示名字
function clsActorSeq:ShowName(bShow)
	if bShow and not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(const.DEF_FONT_CFG(), "滴滴滴")
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	if self.mNameLabel then
		self.mNameLabel:setVisible(bShow)
	end
end

--冒泡说话
function clsActorSeq:PopSay(sWords, OnCallback)
	sWords = sWords or "我再说话你看到了吗？"
	if not self.mCompPopSay then
		self.mCompPopSay = cc.Label:createWithTTF(const.DEF_FONT_CFG(), sWords)
		KE_SetParent(self.mCompPopSay, self)
	end
	
	self.mCompPopSay:stopAllActions()
	self.mCompPopSay:setString(sWords)
	self.mCompPopSay:setPosition(0,self:GetNameLblH())
	self.mCompPopSay:setScale(0.2)
	self.mCompPopSay:setVisible(true)
	self.mCompPopSay:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.ScaleTo:create(0.3, 1, 1),
			cc.MoveTo:create(0.3, cc.p(0,self:GetNameLblH()+30))
		),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.mCompPopSay:setVisible(false)
			
			if OnCallback then
				OnCallback()
			end
		end)
	))
end

function clsActorSeq:StopSay()
	if self.mCompPopSay then
		self.mCompPopSay:stopAllActions()
		self.mCompPopSay:setVisible(false)
	end
end
