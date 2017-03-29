-----------------------
-- 职责：动作与换装
-- 3D模型
-----------------------
clsActorModel = class("clsActorModel", clsGameObject)

function clsActorModel:ctor(iShapeId)
	clsGameObject.ctor(self)
	AddMemoryMonitor(self)
	
	self._ShapeId = nil
	self._tAllAnimation = {}
	self._bShowBody = true
	
	self._mBody = nil			--动画
	self.mShadowSpr = nil		--影子
	self.mNameLabel = nil		--名字
	self.mCompPopSay = nil		--冒泡说话
	
	self:SetShapeId(iShapeId)
	self:ShowShadow(true)
end

function clsActorModel:dtor()
	self:_UnloadBody()
end

--@每帧更新
function clsActorModel:FrameUpdate(deltaTime)
	
end

function clsActorModel:_LoadBody()
	if not self._ShapeId then return end
	if self._mBody then return end
	self._mBody = utils.NewModel(self, string.format("res/role/%d/stand.c3b", self._ShapeId))
	self._mBody:setScale(0.6)
end

function clsActorModel:_UnloadBody()
	if self._mBody then 
		KE_SafeDelete(self._mBody) 
		self._mBody = nil 
	end
end

function clsActorModel:ShowBody(bShow)
	if self._bShowBody == bShow then return end
	self._bShowBody = bShow
	if bShow then
		self:_LoadBody()
		self._mBody:setVisible(true)
	else
		if self._mBody then
			self._mBody:setVisible(false)
		end
	end
end

---------------------------
-- 换装部分
---------------------------
function clsActorModel:SetShapeId(iShapeId)
	iShapeId = 10001
	assert(is_number(iShapeId), "没有造型")
	if self._ShapeId == iShapeId then return end
	self._ShapeId = iShapeId
	self:_UnloadBody()
	self:_LoadBody()
end

function clsActorModel:SetEquipment(equip_info)
	assert(is_table(equip_info) or equip_info==nil)
end

---------------------------
-- 动作部分
---------------------------
function clsActorModel:AddAni(sAniKey)
	if not self._tAllAnimation[sAniKey] then
		self._tAllAnimation[sAniKey] = cc.Animation3D:create(string.format("res/role/%d/%s.c3b", self._ShapeId, sAniKey))
	end
	assert(self._tAllAnimation[sAniKey], "添加动作失败："..sAniKey)
	return self._tAllAnimation[sAniKey]
end

function clsActorModel:SetAni(sAniKey, iLoop, iDtFrame)
	assert(utils.IsValidAniName(sAniKey), "Error: 无效的动作名: "..sAniKey)
	if self.sAniKey == sAniKey then return end
	self.sAniKey = sAniKey
	
	local animation = self:AddAni(sAniKey)
	if animation then
		self._mBody:stopAction(self._mBody._act_ani)
		local animate = cc.Animate3D:create(animation)
		if iLoop and iLoop > 0 then
			self._mBody._act_ani = self._mBody:runAction(cc.Repeat:create(animate, iLoop))
		else
			self._mBody._act_ani = self._mBody:runAction(cc.RepeatForever:create(animate))
		end
	end
end

function clsActorModel:PlayAni(sAniKey, Callback)
	assert(utils.IsValidAniName(sAniKey), "Error: 无效的动作名: "..sAniKey)
	if self.sAniKey == sAniKey then return end
	self.sAniKey = sAniKey
	
	local animation = self:AddAni(sAniKey)
	if animation then
		self._mBody:stopAction(self._mBody._act_ani)
		local animate = cc.Animate3D:create(animation)
		self._mBody._act_ani = self._mBody:runAction(cc.Sequence:create(
			animate,
			cc.CallFunc:create(function()
				if Callback then 
					Callback() 
				end
			end)
		))
	end
end

function clsActorModel:PauseAni(iFrame)
--	assert(false, "尚未实现")
end

function clsActorModel:ResumeAni(iFrame)
--	assert(false, "尚未实现")
end

function clsActorModel:GetAni()
	return self.sAniKey
end

----------------------------
-- 物理性质
----------------------------
function clsActorModel:OnDirectionChanged(iDir)
	self._mBody:setRotation3D({x = 0, y = math.deg(iDir)+90, z = 0})
end


----------------------------
-- 功能接口
----------------------------

function clsActorModel:GetNameLblH()
	return self:GetBodyHeight() + 15
end

--显示影子
local shadow_path = "res/role/shadow.png"
function clsActorModel:ShowShadow(bShow)
	if not bShow and not self.mShadowSpr then return end
	if not self.mShadowSpr then
		self.mShadowSpr = cc.Sprite:create(shadow_path)
		KE_SetParent(self.mShadowSpr, self)
	end
	self.mShadowSpr:setVisible(bShow)
end

--设置名字
local font_cfg = const.DEF_FONT_CFG()
font_cfg.fontSize = 18
function clsActorModel:SetName(sName)
	if not sName or sName == "" then return end
	if not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(font_cfg, sName)
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	self.mNameLabel:setString(sName)
end

--显示名字
function clsActorModel:ShowName(bShow)
	if self.mNameLabel then
		self.mNameLabel:setVisible(bShow)
	end
end

--冒泡说话
function clsActorModel:PopSay(sWords, OnCallback)
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

function clsActorModel:StopSay()
	if self.mCompPopSay then
		self.mCompPopSay:stopAllActions()
		self.mCompPopSay:setVisible(false)
	end
end
