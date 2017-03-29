------------------
-- 技能框
------------------
module("ui", package.seeall)

local ICON_SIZE = 100
local HALF_ICON_SIZE = 50

local clsSkillWndBase = class("clsSkillWndBase", function() return ccui.Button:create() end)

function clsSkillWndBase:ctor(parent)
	self:setScale9Enabled(true)
	self:setContentSize(ICON_SIZE,ICON_SIZE)
	if parent then KE_SetParent(self, parent) end
end

function clsSkillWndBase:dtor()
	KE_RemoveFromParent(self)
end

-----------------------------------------------------
local ORDER_SPRFRAME = 1
local ORDER_SPRHEAD = 2
local ORDER_SPRHIGHLIGHT = 3
local ORDER_SPRLOCK = 4

local ALL_STYLES = {
	[1] = "res/icons/frame/skill_frame.png",
	[2] = "res/icons/frame/skill_frame.png",
	[3] = "res/icons/frame/skill_frame.png",
	[4] = "res/icons/frame/skill_frame.png",
	[5] = "res/icons/frame/skill_frame.png",
}
local LOCKIMGPATH = "res/icons/lock_single_item.png"

clsSkillWnd = class("clsSkillWnd", clsSkillWndBase, clsCoreObject)

clsSkillWnd:RegisterEventType(const.CORE_EVENT.ec_touch_began)
clsSkillWnd:RegisterEventType(const.CORE_EVENT.ec_touch_moved)
clsSkillWnd:RegisterEventType(const.CORE_EVENT.ec_touch_ended)
clsSkillWnd:RegisterEventType(const.CORE_EVENT.ec_touch_canceled)

function clsSkillWnd:ctor(parent, iStyle)
	clsSkillWndBase.ctor(self, parent)
	clsCoreObject.ctor(self)
	
	--
	self._SkillId = nil
	--
	self._bTipsEnabled = true 
	--
	self._sFrameImg = nil
	self._sIconImg = nil
	self._bHighLight = false
	self._bLocked = false 
	--
	self.mSprFrame = nil
	self.mSprIcon = nil
	self.mSprHighLight = nil
	self.mSprLock = nil 
	
	self:SetFrameStyle(iStyle)
	self:_init_widget_events()
end

function clsSkillWnd:dtor()
	
end

function clsSkillWnd:SetFrameStyle(iStyle)
	assert(ALL_STYLES[iStyle], "无效的样式")
	self:SetFrameImg(ALL_STYLES[iStyle])
end

function clsSkillWnd:_ShowTips()
	if not self._bTipsEnabled then return end
	utils.TellTips( "TIP_SKILL", self, {SkillId=self._SkillId} )
end

function clsSkillWnd:_init_widget_events()
	local function touchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self:FireEvent(const.CORE_EVENT.ec_touch_began, self)
			
		elseif eventType == ccui.TouchEventType.moved then
			self:FireEvent(const.CORE_EVENT.ec_touch_moved, self)
			
    	elseif eventType == ccui.TouchEventType.ended then
    		self:FireEvent(const.CORE_EVENT.ec_touch_ended, self)
    		
    	elseif eventType == ccui.TouchEventType.canceled then
        	self:FireEvent(const.CORE_EVENT.ec_touch_canceled, self)
        	
        end 
    end
    self:addTouchEventListener(touchEvent)
end

function clsSkillWnd:SetFrameImg(imgPath)
	if self._sFrameImg == imgPath then return end
	self._sFrameImg = imgPath
	
	KE_SafeDelete(self.mSprFrame)
	self.mSprFrame = nil
	if not imgPath or imgPath=="" then return end
	self.mSprFrame = cc.Scale9Sprite:create(imgPath)
	KE_SetParent(self.mSprFrame, self, ORDER_SPRFRAME)
	self.mSprFrame:setContentSize(ICON_SIZE,ICON_SIZE)
	self.mSprFrame:setPosition(HALF_ICON_SIZE,HALF_ICON_SIZE)
end

function clsSkillWnd:SetSkillImg(imgPath)
	if self._sIconImg == imgPath then return end
	self._sIconImg = imgPath
	
	KE_SafeDelete(self.mSprIcon)
	self.mSprIcon = nil
	if not imgPath or imgPath=="" then return end
	self.mSprIcon = cc.Sprite:create(imgPath)
	KE_SetParent(self.mSprIcon, self, ORDER_SPRHEAD)
	self.mSprIcon:setPosition(HALF_ICON_SIZE,HALF_ICON_SIZE)
end

function clsSkillWnd:SetHighLight(bHighLight)
	if self._bHighLight == bHighLight then return end
	self._bHighLight = bHighLight
	
	if self.mSprHighLight then
		self.mSprHighLight:setVisible(bHighLight)
	elseif bHighLight then
		self.mSprHighLight = cc.Scale9Sprite:create("res/icons/frame/frame_choosed.png")
		KE_SetParent(self.mSprHighLight, self, ORDER_SPRHEAD)
		self.mSprHighLight:setContentSize(ICON_SIZE,ICON_SIZE)
		self.mSprHighLight:setPosition(HALF_ICON_SIZE,HALF_ICON_SIZE)
	end
end

function clsSkillWnd:SetLocked(bLocked)
	if self._bLocked == bLocked then return end
	self._bLocked = bLocked
	
	if self.mSprLock then
		self.mSprLock:setVisible(bLocked)
	elseif bLocked then
		self.mSprLock = cc.Sprite:create(LOCKIMGPATH)
		KE_SetParent(self.mSprLock, self, ORDER_SPRLOCK)
		self.mSprLock:setPosition(HALF_ICON_SIZE,HALF_ICON_SIZE)
	end
end

--------------------------

function clsSkillWnd:SetSkillId(SkillId)
	if self._SkillId == SkillId then return end
	self._SkillId = SkillId
	local Info = setting.T_skill_cfg[SkillId]
	assert(Info, "未配置的技能ID："..SkillId)
	self:SetSkillImg(Info.sIconPath)
end
